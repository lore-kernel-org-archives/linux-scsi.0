From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 5/6] ps3: ROM Storage Driver
Date: Fri, 15 Jun 2007 13:39:24 +0200
Message-ID: <20070615120848.454492000@pademelon.sonytel.be>
References: <20070615113919.142332000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49692 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753884AbXFOMLY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 08:11:24 -0400
Content-Disposition: inline; filename=ps3-stable/ps3stor_rom.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Add a CD/DVD/BD Storage Driver for the PS3:
  - Implemented as a SCSI device driver
  - Uses software scatter-gather with a 64 KiB bounce buffer as the hyp=
ervisor
    doesn't support scatter-gather

CC: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
Changes since previous submission:
      o Don't use `default y' in Kconfig
      o Add missing #include <linux/highmem.h>
      o Remove ps3rom_private.scsi_done, use scsi_cmnd.scsi_done instea=
d
      o Use scsi_device.host.hostdata
      o Remove empty ps3rom_slave_{alloc,destroy}()
      o Kill superfluous test for command in progress
      o Move scsi_host_put() last in cleanup sequence
      o Remove scsi_command(), use scsi_print_command() for debugging
      o scsi_cmnd.use_sg is always > 0 these days
      o Allocate struct ps3rom_private using scsi_host_alloc()
      o Remove the thread for handling requests
      o Remove unused position parameter enum
      o Remove unused NA_PROTO and DIR_NA
      o Derive buffer length, data direction, and transfer protocol fro=
m the
	struct scsi_command, instead of using a big switch() statement
      o Kill superfluous spinlock
      o Remove manual request sense, as modern hypervisors always do au=
to sense
      o Pass all SCSI commands to the hypervisor as ATAPI commands, exc=
ept for
        READ_*/WRITE_*
      o Don't print errors for SCSI commands that are not allowed for a=
n
        Other OS by the hypervisor
      o Remove superfluous tests for data directions in
        {fill_from,fetch_to}_dev_buffer()
      o Handle errors in {fill_from,fetch_to}_dev_buffer()
      o Reorder routines
      o Manually inline ps3rom_send_atapi_command()
      o Fix all FIXMEs

 arch/powerpc/platforms/ps3/Kconfig |   10=20
 drivers/scsi/Makefile              |    1=20
 drivers/scsi/ps3rom.c              |  568 ++++++++++++++++++++++++++++=
+++++++++
 3 files changed, 579 insertions(+)

--- a/arch/powerpc/platforms/ps3/Kconfig
+++ b/arch/powerpc/platforms/ps3/Kconfig
@@ -112,4 +112,14 @@ config PS3_DISK
 	  This support is required to access the PS3 hard disk.
 	  In general, all users will say Y or M.
=20
+config PS3_ROM
+	tristate "PS3 ROM Storage Driver"
+	depends on PPC_PS3 && BLK_DEV_SR
+	select PS3_STORAGE
+	help
+	  Include support for the PS3 ROM Storage.
+
+	  This support is required to access the PS3 BD/DVD/CD-ROM drive.
+	  In general, all users will say Y or M.
+
 endmenu
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -132,6 +132,7 @@ obj-$(CONFIG_SCSI_IBMVSCSI)	+=3D ibmvscsi/
 obj-$(CONFIG_SCSI_IBMVSCSIS)	+=3D ibmvscsi/
 obj-$(CONFIG_SCSI_HPTIOP)	+=3D hptiop.o
 obj-$(CONFIG_SCSI_STEX)		+=3D stex.o
+obj-$(CONFIG_PS3_ROM)		+=3D ps3rom.o
=20
 obj-$(CONFIG_ARM)		+=3D arm/
=20
--- /dev/null
+++ b/drivers/scsi/ps3rom.c
@@ -0,0 +1,568 @@
+/*
+ * PS3 ROM Storage Driver
+ *
+ * Copyright (C) 2007 Sony Computer Entertainment Inc.
+ * Copyright 2007 Sony Corp.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License a=
long
+ * with this program; if not, write to the Free Software Foundation, I=
nc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/cdrom.h>
+#include <linux/highmem.h>
+#include <linux/interrupt.h>
+#include <linux/kthread.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+#include <asm/lv1call.h>
+#include <asm/ps3stor.h>
+
+
+#define DEVICE_NAME			"ps3rom"
+
+#define BOUNCE_SIZE			(64*1024)
+
+#define PS3ROM_MAX_SECTORS		(BOUNCE_SIZE / CD_FRAMESIZE)
+
+#define LV1_STORAGE_SEND_ATAPI_COMMAND	(1)
+
+
+struct ps3rom_private {
+	struct ps3_storage_device *dev;
+	struct scsi_cmnd *cmd;
+};
+#define ps3rom_priv(dev)	((dev)->sbd.core.driver_data)
+
+struct lv1_atapi_cmnd_block {
+	u8	pkt[32];	/* packet command block           */
+	u32	pktlen;		/* should be 12 for ATAPI 8020    */
+	u32	blocks;
+	u32	block_size;
+	u32	proto;		/* transfer mode                  */
+	u32	in_out;		/* transfer direction             */
+	u64	buffer;		/* parameter except command block */
+	u32	arglen;		/* length above                   */
+};
+
+enum lv1_atapi_proto {
+	NON_DATA_PROTO     =3D 0,
+	PIO_DATA_IN_PROTO  =3D 1,
+	PIO_DATA_OUT_PROTO =3D 2,
+	DMA_PROTO =3D 3
+};
+
+enum lv1_atapi_in_out {
+	DIR_WRITE =3D 0, /* memory -> device */
+	DIR_READ =3D 1 /* device -> memory */
+};
+
+
+static int ps3rom_slave_configure(struct scsi_device *scsi_dev)
+{
+	struct ps3rom_private *priv;
+	struct ps3_storage_device *dev;
+
+	priv =3D (struct ps3rom_private *)scsi_dev->host->hostdata;
+	dev =3D priv->dev;
+	dev_dbg(&dev->sbd.core, "%s:%u: id %u, lun %u, channel %u\n", __func_=
_,
+		__LINE__, scsi_dev->id, scsi_dev->lun, scsi_dev->channel);
+
+	/*
+	 * ATAPI SFF8020 devices use MODE_SENSE_10,
+	 * so we can prohibit MODE_SENSE_6
+	 */
+	scsi_dev->use_10_for_ms =3D 1;
+
+	return 0;
+}
+
+/*
+ * copy data from device into scatter/gather buffer
+ */
+static int fill_from_dev_buffer(struct scsi_cmnd *cmd, const void *buf=
)
+{
+	int k, req_len, act_len, len, active;
+	void *kaddr;
+	struct scatterlist *sgpnt;
+	unsigned int buflen;
+
+	buflen =3D cmd->request_bufflen;
+	if (!buflen)
+		return 0;
+
+	if (!cmd->request_buffer)
+		return -1;
+
+	sgpnt =3D cmd->request_buffer;
+	active =3D 1;
+	for (k =3D 0, req_len =3D 0, act_len =3D 0; k < cmd->use_sg; ++k, ++s=
gpnt) {
+		if (active) {
+			kaddr =3D kmap_atomic(sgpnt->page, KM_USER0);
+			if (!kaddr)
+				return -1;
+			len =3D sgpnt->length;
+			if ((req_len + len) > buflen) {
+				active =3D 0;
+				len =3D buflen - req_len;
+			}
+			memcpy(kaddr + sgpnt->offset, buf + req_len, len);
+			kunmap_atomic(kaddr, KM_USER0);
+			act_len +=3D len;
+		}
+		req_len +=3D sgpnt->length;
+	}
+	cmd->resid =3D req_len - act_len;
+	return 0;
+}
+
+/*
+ * copy data from scatter/gather into device's buffer
+ */
+static int fetch_to_dev_buffer(struct scsi_cmnd *cmd, void *buf)
+{
+	int k, req_len, len, fin;
+	void *kaddr;
+	struct scatterlist *sgpnt;
+	unsigned int buflen;
+
+	buflen =3D cmd->request_bufflen;
+	if (!buflen)
+		return 0;
+
+	if (!cmd->request_buffer)
+		return -1;
+
+	sgpnt =3D cmd->request_buffer;
+	for (k =3D 0, req_len =3D 0, fin =3D 0; k < cmd->use_sg; ++k, ++sgpnt=
) {
+		kaddr =3D kmap_atomic(sgpnt->page, KM_USER0);
+		if (!kaddr)
+			return -1;
+		len =3D sgpnt->length;
+		if ((req_len + len) > buflen) {
+			len =3D buflen - req_len;
+			fin =3D 1;
+		}
+		memcpy(buf + req_len, kaddr + sgpnt->offset, len);
+		kunmap_atomic(kaddr, KM_USER0);
+		if (fin)
+			return req_len + len;
+		req_len +=3D sgpnt->length;
+	}
+	return req_len;
+}
+
+static int ps3rom_atapi_request(struct ps3_storage_device *dev,
+				struct scsi_cmnd *cmd)
+{
+	struct lv1_atapi_cmnd_block atapi_cmnd;
+	unsigned char opcode =3D cmd->cmnd[0];
+	int res;
+	u64 lpar;
+
+	dev_dbg(&dev->sbd.core, "%s:%u: send ATAPI command 0x%02x\n", __func_=
_,
+		__LINE__, opcode);
+
+	memset(&atapi_cmnd, 0, sizeof(struct lv1_atapi_cmnd_block));
+	memcpy(&atapi_cmnd.pkt, cmd->cmnd, 12);
+	atapi_cmnd.pktlen =3D 12;
+	atapi_cmnd.block_size =3D 1; /* transfer size is block_size * blocks =
*/
+	atapi_cmnd.blocks =3D atapi_cmnd.arglen =3D cmd->request_bufflen;
+	atapi_cmnd.buffer =3D dev->bounce_lpar;
+
+	switch (cmd->sc_data_direction) {
+	case DMA_FROM_DEVICE:
+		if (cmd->request_bufflen >=3D CD_FRAMESIZE)
+			atapi_cmnd.proto =3D DMA_PROTO;
+		else
+			atapi_cmnd.proto =3D PIO_DATA_IN_PROTO;
+		atapi_cmnd.in_out =3D DIR_READ;
+		break;
+
+	case DMA_TO_DEVICE:
+		if (cmd->request_bufflen >=3D CD_FRAMESIZE)
+			atapi_cmnd.proto =3D DMA_PROTO;
+		else
+			atapi_cmnd.proto =3D PIO_DATA_OUT_PROTO;
+		atapi_cmnd.in_out =3D DIR_WRITE;
+		res =3D fetch_to_dev_buffer(cmd, dev->bounce_buf);
+		if (res < 0)
+			return DID_ERROR << 16;
+		break;
+
+	default:
+		atapi_cmnd.proto =3D NON_DATA_PROTO;
+		break;
+	}
+
+	lpar =3D ps3_mm_phys_to_lpar(__pa(&atapi_cmnd));
+	res =3D lv1_storage_send_device_command(dev->sbd.dev_id,
+					      LV1_STORAGE_SEND_ATAPI_COMMAND,
+					      lpar, sizeof(atapi_cmnd),
+					      atapi_cmnd.buffer,
+					      atapi_cmnd.arglen, &dev->tag);
+	if (res =3D=3D LV1_DENIED_BY_POLICY) {
+		dev_dbg(&dev->sbd.core,
+			"%s:%u: ATAPI command 0x%02x denied by policy\n",
+			__func__, __LINE__, opcode);
+		return DID_ERROR << 16;
+	}
+
+	if (res) {
+		dev_err(&dev->sbd.core,
+			"%s:%u: ATAPI command 0x%02x failed %d\n", __func__,
+			__LINE__, opcode, res);
+		return DID_ERROR << 16;
+	}
+
+	return 0;
+}
+
+static inline unsigned int srb6_lba(const struct scsi_cmnd *cmd)
+{
+	/* LUN is always zero */
+	return cmd->cmnd[1] << 16 | cmd->cmnd[2] << 8 | cmd->cmnd[3];
+}
+
+static inline unsigned int srb6_len(const struct scsi_cmnd *cmd)
+{
+	return cmd->cmnd[4];
+}
+
+static inline unsigned int srb10_lba(const struct scsi_cmnd *cmd)
+{
+	return cmd->cmnd[2] << 24 | cmd->cmnd[3] << 16 | cmd->cmnd[4] << 8 |
+	       cmd->cmnd[5];
+}
+
+static inline unsigned int srb10_len(const struct scsi_cmnd *cmd)
+{
+	return cmd->cmnd[7] << 8 | cmd->cmnd[8];
+}
+
+static int ps3rom_read_request(struct ps3_storage_device *dev,
+			       struct scsi_cmnd *cmd, u32 start_sector,
+			       u32 sectors)
+{
+	int res;
+
+	dev_dbg(&dev->sbd.core, "%s:%u: read %u sectors starting at %u\n",
+		__func__, __LINE__, sectors, start_sector);
+
+	res =3D lv1_storage_read(dev->sbd.dev_id,
+			       dev->regions[dev->region_idx].id, start_sector,
+			       sectors, 0, dev->bounce_lpar, &dev->tag);
+	if (res) {
+		dev_err(&dev->sbd.core, "%s:%u: read failed %d\n", __func__,
+			__LINE__, res);
+		return DID_ERROR << 16;
+	}
+
+	return 0;
+}
+
+static int ps3rom_write_request(struct ps3_storage_device *dev,
+				struct scsi_cmnd *cmd, u32 start_sector,
+				u32 sectors)
+{
+	int res;
+
+	dev_dbg(&dev->sbd.core, "%s:%u: write %u sectors starting at %u\n",
+		__func__, __LINE__, sectors, start_sector);
+
+	res =3D fetch_to_dev_buffer(cmd, dev->bounce_buf);
+	if (res < 0)
+		return DID_ERROR << 16;
+
+	res =3D lv1_storage_write(dev->sbd.dev_id,
+				dev->regions[dev->region_idx].id, start_sector,
+				sectors, 0, dev->bounce_lpar, &dev->tag);
+	if (res) {
+		dev_err(&dev->sbd.core, "%s:%u: write failed %d\n", __func__,
+			__LINE__, res);
+		return DID_ERROR << 16;
+	}
+
+	return 0;
+}
+
+static int ps3rom_queuecommand(struct scsi_cmnd *cmd,
+			       void (*done)(struct scsi_cmnd *))
+{
+	struct ps3rom_private *priv;
+	struct ps3_storage_device *dev;
+	unsigned char opcode;
+	int res;
+
+#ifdef DEBUG
+	scsi_print_command(cmd);
+#endif
+
+	priv =3D (struct ps3rom_private *)cmd->device->host->hostdata;
+	dev =3D priv->dev;
+	priv->cmd =3D cmd;
+	cmd->scsi_done =3D done;
+
+	opcode =3D cmd->cmnd[0];
+	/*
+	 * While we can submit READ/WRITE SCSI commands as ATAPI commands,
+	 * it's recommended to use lv1_storage_{read,write}() instead
+	 */
+	switch (opcode) {
+	case READ_6:
+		res =3D ps3rom_read_request(dev, cmd, srb6_lba(cmd),
+					  srb6_len(cmd));
+		break;
+
+	case READ_10:
+		res =3D ps3rom_read_request(dev, cmd, srb10_lba(cmd),
+					  srb10_len(cmd));
+		break;
+
+	case WRITE_6:
+		res =3D ps3rom_write_request(dev, cmd, srb6_lba(cmd),
+					   srb6_len(cmd));
+		break;
+
+	case WRITE_10:
+		res =3D ps3rom_write_request(dev, cmd, srb10_lba(cmd),
+					   srb10_len(cmd));
+		break;
+
+	default:
+		res =3D ps3rom_atapi_request(dev, cmd);
+		break;
+	}
+
+	if (res) {
+		memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+		cmd->result =3D res;
+		cmd->sense_buffer[0] =3D 0x70;
+		cmd->sense_buffer[2] =3D ILLEGAL_REQUEST;
+		priv->cmd =3D NULL;
+		cmd->scsi_done(cmd);
+	}
+
+	return 0;
+}
+
+static int decode_lv1_status(u64 status, unsigned char *sense_key,
+			     unsigned char *asc, unsigned char *ascq)
+{
+	if (((status >> 24) & 0xff) !=3D SAM_STAT_CHECK_CONDITION)
+		return -1;
+
+	*sense_key =3D (status >> 16) & 0xff;
+	*asc       =3D (status >>  8) & 0xff;
+	*ascq      =3D  status        & 0xff;
+	return 0;
+}
+
+static irqreturn_t ps3rom_interrupt(int irq, void *data)
+{
+	struct ps3_storage_device *dev =3D data;
+	struct Scsi_Host *host;
+	struct ps3rom_private *priv;
+	struct scsi_cmnd *cmd;
+	int res;
+	u64 tag, status;
+	unsigned char sense_key, asc, ascq;
+
+	res =3D lv1_storage_get_async_status(dev->sbd.dev_id, &tag, &status);
+	/*
+	 * status =3D -1 may mean that ATAPI transport completed OK, but
+	 * ATAPI command itself resulted CHECK CONDITION
+	 * so, upper layer should issue REQUEST_SENSE to check the sense data
+	 */
+
+	if (tag !=3D dev->tag)
+		dev_err(&dev->sbd.core,
+			"%s:%u: tag mismatch, got %lx, expected %lx\n",
+			__func__, __LINE__, tag, dev->tag);
+
+	if (res) {
+		dev_err(&dev->sbd.core, "%s:%u: res=3D%d status=3D0x%lx\n",
+			__func__, __LINE__, res, status);
+		return IRQ_HANDLED;
+	}
+
+	host =3D ps3rom_priv(dev);
+	priv =3D (struct ps3rom_private *)host->hostdata;
+	cmd =3D priv->cmd;
+
+	if (!status) {
+		/* OK, completed */
+		if (cmd->sc_data_direction =3D=3D DMA_FROM_DEVICE) {
+			res =3D fill_from_dev_buffer(cmd, dev->bounce_buf);
+			if (res) {
+				cmd->result =3D DID_ERROR << 16;
+				goto done;
+			}
+		}
+		cmd->result =3D DID_OK << 16;
+		goto done;
+	}
+
+	if (cmd->cmnd[0] =3D=3D REQUEST_SENSE) {
+		/* SCSI spec says request sense should never get error */
+		dev_err(&dev->sbd.core, "%s:%u: end error without autosense\n",
+			__func__, __LINE__);
+		cmd->result =3D DID_ERROR << 16 | SAM_STAT_CHECK_CONDITION;
+		goto done;
+	}
+
+	if (decode_lv1_status(status, &sense_key, &asc, &ascq)) {
+		cmd->result =3D DID_ERROR << 16;
+		goto done;
+	}
+
+	cmd->sense_buffer[0]  =3D 0x70;
+	cmd->sense_buffer[2]  =3D sense_key;
+	cmd->sense_buffer[7]  =3D 16 - 6;
+	cmd->sense_buffer[12] =3D asc;
+	cmd->sense_buffer[13] =3D ascq;
+	cmd->result =3D SAM_STAT_CHECK_CONDITION;
+
+done:
+	priv->cmd =3D NULL;
+	cmd->scsi_done(cmd);
+	return IRQ_HANDLED;
+}
+
+static struct scsi_host_template ps3rom_host_template =3D {
+	.name =3D			DEVICE_NAME,
+	.slave_configure =3D	ps3rom_slave_configure,
+	.queuecommand =3D		ps3rom_queuecommand,
+	.can_queue =3D		1,
+	.this_id =3D		7,
+	.sg_tablesize =3D		SG_ALL,
+	.cmd_per_lun =3D		1,
+	.emulated =3D             1,		/* only sg driver uses this */
+	.max_sectors =3D		PS3ROM_MAX_SECTORS,
+	.use_clustering =3D	ENABLE_CLUSTERING,
+	.module =3D		THIS_MODULE,
+};
+
+
+static int __devinit ps3rom_probe(struct ps3_system_bus_device *_dev)
+{
+	struct ps3_storage_device *dev =3D to_ps3_storage_device(&_dev->core)=
;
+	int error;
+	struct Scsi_Host *host;
+	struct ps3rom_private *priv;
+
+	if (dev->blk_size !=3D CD_FRAMESIZE) {
+		dev_err(&dev->sbd.core,
+			"%s:%u: cannot handle block size %lu\n", __func__,
+			__LINE__, dev->blk_size);
+		return -EINVAL;
+	}
+
+	dev->bounce_size =3D BOUNCE_SIZE;
+	dev->bounce_buf =3D kmalloc(BOUNCE_SIZE, GFP_DMA);
+	if (!dev->bounce_buf) {
+		return -ENOMEM;
+	}
+
+	error =3D ps3stor_setup(dev);
+	if (error)
+		goto fail_free_bounce;
+
+	/* override the interrupt handler */
+	free_irq(dev->irq, dev);
+	error =3D request_irq(dev->irq, ps3rom_interrupt, IRQF_DISABLED,
+			    dev->sbd.core.driver->name, dev);
+	if (error) {
+		dev_err(&dev->sbd.core, "%s:%u: request_irq failed %d\n",
+			__func__, __LINE__, error);
+		goto fail_teardown;
+	}
+
+	host =3D scsi_host_alloc(&ps3rom_host_template,
+			       sizeof(struct ps3rom_private));
+	if (!host) {
+		dev_err(&dev->sbd.core, "%s:%u: scsi_host_alloc failed\n",
+			__func__, __LINE__);
+		goto fail_teardown;
+	}
+
+	priv =3D (struct ps3rom_private *)host->hostdata;
+	ps3rom_priv(dev) =3D host;
+	priv->dev =3D dev;
+
+	/* One device/LUN per SCSI bus */
+	host->max_id =3D 1;
+	host->max_lun =3D 1;
+
+	error =3D scsi_add_host(host, &dev->sbd.core);
+	if (error) {
+		dev_err(&dev->sbd.core, "%s:%u: scsi_host_alloc failed %d\n",
+			__func__, __LINE__, error);
+		error =3D -ENODEV;
+		goto fail_host_put;
+	}
+
+	scsi_scan_host(host);
+	return 0;
+
+fail_host_put:
+	scsi_host_put(host);
+fail_teardown:
+	ps3stor_teardown(dev);
+fail_free_bounce:
+	kfree(dev->bounce_buf);
+	return error;
+}
+
+static int ps3rom_remove(struct ps3_system_bus_device *_dev)
+{
+	struct ps3_storage_device *dev =3D to_ps3_storage_device(&_dev->core)=
;
+	struct Scsi_Host *host =3D ps3rom_priv(dev);
+
+	scsi_remove_host(host);
+	ps3stor_teardown(dev);
+	kfree(dev->bounce_buf);
+	scsi_host_put(host);
+	return 0;
+}
+
+static struct ps3_system_bus_driver ps3rom =3D {
+	.match_id	=3D PS3_MATCH_ID_STOR_ROM,
+	.core.name	=3D DEVICE_NAME,
+	.core.owner	=3D THIS_MODULE,
+	.probe		=3D ps3rom_probe,
+	.remove		=3D ps3rom_remove
+};
+
+
+static int __init ps3rom_init(void)
+{
+	return ps3_system_bus_driver_register(&ps3rom);
+}
+
+static void __exit ps3rom_exit(void)
+{
+	ps3_system_bus_driver_unregister(&ps3rom);
+}
+
+module_init(ps3rom_init);
+module_exit(ps3rom_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("PS3 ROM Storage Driver");
+MODULE_AUTHOR("Sony Corporation");
+MODULE_ALIAS(PS3_MODULE_ALIAS_STOR_ROM);

--=20
With kind regards,
=20
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium
=20
Phone:    +32 (0)2 700 8453=09
=46ax:      +32 (0)2 700 8622=09
E-mail:   Geert.Uytterhoeven@sonycom.com=09
Internet: http://www.sony-europe.com/
 =09
Sony Network and Software Technology Center Europe=09
A division of Sony Service Centre (Europe) N.V.=09
Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 Be=
lgium=09
VAT BE 0413.825.160 =C2=B7 RPR Brussels=09
=46ortis Bank Zaventem =C2=B7 Swift GEBABEBB08A =C2=B7 IBAN BE390013823=
58619

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
