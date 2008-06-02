From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 -mm 6/6] cdrom: revert commit 22a9189 (cdrom: use kmalloced buffers instead of buffers on stack)
Date: Mon,  2 Jun 2008 15:57:32 +0900
Message-ID: <1212389852-1277-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1212389852-1277-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46918 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbYFBHlY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2008 03:41:24 -0400
In-Reply-To: <1212389852-1277-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, petkovbb@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp

The commit 22a9189fd073db3d03a4cf8b8c098aa207602de1 (cdrom: use
kmalloced buffers instead of buffers on stack) is introduced to use
kmalloced buffers for packet commands to avoid stack corruption on non
coherent platforms.

SCSI cdrom uses blk_rq_map_kern, which properly avoids DMA on the
stack by using the bounce buffers. IDE cdrom also has the mechnism to
avoids DMA on the stack. So we don't need this extra complexitiy in
cdrom.c, such as allocating just 8 bytes. The lower layers can handle
it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/cdrom/cdrom.c |  274 +++++++++++++++++--------------------------------
 1 files changed, 93 insertions(+), 181 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 69f26eb..a5da356 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -461,37 +461,27 @@ int cdrom_get_media_event(struct cdrom_device_info *cdi,
 			  struct media_event_desc *med)
 {
 	struct packet_command cgc;
-	unsigned char *buffer;
-	struct event_header *eh;
-	int ret = 1;
-
-	buffer = kmalloc(8, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
+	unsigned char buffer[8];
+	struct event_header *eh = (struct event_header *) buffer;
 
-	eh = (struct event_header *)buffer;
-
-	init_cdrom_command(&cgc, buffer, 8, CGC_DATA_READ);
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
 	cgc.cmd[0] = GPCMD_GET_EVENT_STATUS_NOTIFICATION;
 	cgc.cmd[1] = 1;		/* IMMED */
 	cgc.cmd[4] = 1 << 4;	/* media event */
-	cgc.cmd[8] = 8;
+	cgc.cmd[8] = sizeof(buffer);
 	cgc.quiet = 1;
 
 	if (cdi->ops->generic_packet(cdi, &cgc))
-		goto err;
+		return 1;
 
 	if (be16_to_cpu(eh->data_len) < sizeof(*med))
-		goto err;
+		return 1;
 
 	if (eh->nea || eh->notification_class != 0x4)
-		goto err;
+		return 1;
 
-	memcpy(med, buffer + sizeof(*eh), sizeof(*med));
-	ret = 0;
-err:
-	kfree(buffer);
-	return ret;
+	memcpy(med, &buffer[sizeof(*eh)], sizeof(*med));
+	return 0;
 }
 
 /*
@@ -501,82 +491,68 @@ err:
 static int cdrom_mrw_probe_pc(struct cdrom_device_info *cdi)
 {
 	struct packet_command cgc;
-	char *buffer;
-	int ret = 1;
-
-	buffer = kmalloc(16, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
+	char buffer[16];
 
-	init_cdrom_command(&cgc, buffer, 16, CGC_DATA_READ);
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
 
 	cgc.timeout = HZ;
 	cgc.quiet = 1;
 
 	if (!cdrom_mode_sense(cdi, &cgc, MRW_MODE_PC, 0)) {
 		cdi->mrw_mode_page = MRW_MODE_PC;
-		ret = 0;
+		return 0;
 	} else if (!cdrom_mode_sense(cdi, &cgc, MRW_MODE_PC_PRE1, 0)) {
 		cdi->mrw_mode_page = MRW_MODE_PC_PRE1;
-		ret = 0;
+		return 0;
 	}
-	kfree(buffer);
-	return ret;
+
+	return 1;
 }
 
 static int cdrom_is_mrw(struct cdrom_device_info *cdi, int *write)
 {
 	struct packet_command cgc;
 	struct mrw_feature_desc *mfd;
-	unsigned char *buffer;
+	unsigned char buffer[16];
 	int ret;
 
 	*write = 0;
-	buffer = kmalloc(16, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
 
-	init_cdrom_command(&cgc, buffer, 16, CGC_DATA_READ);
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
 
 	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;
 	cgc.cmd[3] = CDF_MRW;
-	cgc.cmd[8] = 16;
+	cgc.cmd[8] = sizeof(buffer);
 	cgc.quiet = 1;
 
 	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
-		goto err;
+		return ret;
 
 	mfd = (struct mrw_feature_desc *)&buffer[sizeof(struct feature_header)];
-	if (be16_to_cpu(mfd->feature_code) != CDF_MRW) {
-		ret = 1;
-		goto err;
-	}
+	if (be16_to_cpu(mfd->feature_code) != CDF_MRW)
+		return 1;
 	*write = mfd->write;
 
 	if ((ret = cdrom_mrw_probe_pc(cdi))) {
 		*write = 0;
+		return ret;
 	}
-err:
-	kfree(buffer);
-	return ret;
+
+	return 0;
 }
 
 static int cdrom_mrw_bgformat(struct cdrom_device_info *cdi, int cont)
 {
 	struct packet_command cgc;
-	unsigned char *buffer;
+	unsigned char buffer[12];
 	int ret;
 
 	printk(KERN_INFO "cdrom: %sstarting format\n", cont ? "Re" : "");
 
-	buffer = kmalloc(12, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
 	/*
 	 * FmtData bit set (bit 4), format type is 1
 	 */
-	init_cdrom_command(&cgc, buffer, 12, CGC_DATA_WRITE);
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_WRITE);
 	cgc.cmd[0] = GPCMD_FORMAT_UNIT;
 	cgc.cmd[1] = (1 << 4) | 1;
 
@@ -603,7 +579,6 @@ static int cdrom_mrw_bgformat(struct cdrom_device_info *cdi, int cont)
 	if (ret)
 		printk(KERN_INFO "cdrom: bgformat failed\n");
 
-	kfree(buffer);
 	return ret;
 }
 
@@ -663,17 +638,16 @@ static int cdrom_mrw_set_lba_space(struct cdrom_device_info *cdi, int space)
 {
 	struct packet_command cgc;
 	struct mode_page_header *mph;
-	char *buffer;
+	char buffer[16];
 	int ret, offset, size;
 
-	buffer = kmalloc(16, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
 
-	init_cdrom_command(&cgc, buffer, 16, CGC_DATA_READ);
+	cgc.buffer = buffer;
+	cgc.buflen = sizeof(buffer);
 
 	if ((ret = cdrom_mode_sense(cdi, &cgc, cdi->mrw_mode_page, 0)))
-		goto err;
+		return ret;
 
 	mph = (struct mode_page_header *) buffer;
 	offset = be16_to_cpu(mph->desc_length);
@@ -683,70 +657,55 @@ static int cdrom_mrw_set_lba_space(struct cdrom_device_info *cdi, int space)
 	cgc.buflen = size;
 
 	if ((ret = cdrom_mode_select(cdi, &cgc)))
-		goto err;
+		return ret;
 
 	printk(KERN_INFO "cdrom: %s: mrw address space %s selected\n", cdi->name, mrw_address_space[space]);
-	ret = 0;
-err:
-	kfree(buffer);
-	return ret;
+	return 0;
 }
 
 static int cdrom_get_random_writable(struct cdrom_device_info *cdi,
 			      struct rwrt_feature_desc *rfd)
 {
 	struct packet_command cgc;
-	char *buffer;
+	char buffer[24];
 	int ret;
 
-	buffer = kmalloc(24, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
-	init_cdrom_command(&cgc, buffer, 24, CGC_DATA_READ);
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
 
 	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;	/* often 0x46 */
 	cgc.cmd[3] = CDF_RWRT;			/* often 0x0020 */
-	cgc.cmd[8] = 24;		        /* often 0x18 */
+	cgc.cmd[8] = sizeof(buffer);		/* often 0x18 */
 	cgc.quiet = 1;
 
 	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
-		goto err;
+		return ret;
 
 	memcpy(rfd, &buffer[sizeof(struct feature_header)], sizeof (*rfd));
-	ret = 0;
-err:
-	kfree(buffer);
-	return ret;
+	return 0;
 }
 
 static int cdrom_has_defect_mgt(struct cdrom_device_info *cdi)
 {
 	struct packet_command cgc;
-	char *buffer;
+	char buffer[16];
 	__be16 *feature_code;
 	int ret;
 
-	buffer = kmalloc(16, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
-	init_cdrom_command(&cgc, buffer, 16, CGC_DATA_READ);
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
 
 	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;
 	cgc.cmd[3] = CDF_HWDM;
-	cgc.cmd[8] = 16;
+	cgc.cmd[8] = sizeof(buffer);
 	cgc.quiet = 1;
 
 	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
-		goto err;
+		return ret;
 
 	feature_code = (__be16 *) &buffer[sizeof(struct feature_header)];
 	if (be16_to_cpu(*feature_code) == CDF_HWDM)
-		ret = 0;
-err:
-	kfree(buffer);
-	return ret;
+		return 0;
+
+	return 1;
 }
 
 
@@ -837,14 +796,10 @@ static int cdrom_mrw_open_write(struct cdrom_device_info *cdi)
 static int mo_open_write(struct cdrom_device_info *cdi)
 {
 	struct packet_command cgc;
-	char *buffer;
+	char buffer[255];
 	int ret;
 
-	buffer = kmalloc(255, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
-	init_cdrom_command(&cgc, buffer, 4, CGC_DATA_READ);
+	init_cdrom_command(&cgc, &buffer, 4, CGC_DATA_READ);
 	cgc.quiet = 1;
 
 	/*
@@ -861,15 +816,10 @@ static int mo_open_write(struct cdrom_device_info *cdi)
 	}
 
 	/* drive gave us no info, let the user go ahead */
-	if (ret) {
-		ret = 0;
-		goto err;
-	}
+	if (ret)
+		return 0;
 
-	ret = buffer[3] & 0x80;
-err:
-	kfree(buffer);
-	return ret;
+	return buffer[3] & 0x80;
 }
 
 static int cdrom_ram_open_write(struct cdrom_device_info *cdi)
@@ -892,19 +842,15 @@ static int cdrom_ram_open_write(struct cdrom_device_info *cdi)
 static void cdrom_mmc3_profile(struct cdrom_device_info *cdi)
 {
 	struct packet_command cgc;
-	char *buffer;
+	char buffer[32];
 	int ret, mmc3_profile;
 
-	buffer = kmalloc(32, GFP_KERNEL);
-	if (!buffer)
-		return;
-
-	init_cdrom_command(&cgc, buffer, 32, CGC_DATA_READ);
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
 
 	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;
 	cgc.cmd[1] = 0;
 	cgc.cmd[2] = cgc.cmd[3] = 0;		/* Starting Feature Number */
-	cgc.cmd[8] = 32;		        /* Allocation Length */
+	cgc.cmd[8] = sizeof(buffer);		/* Allocation Length */
 	cgc.quiet = 1;
 
 	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
@@ -913,7 +859,6 @@ static void cdrom_mmc3_profile(struct cdrom_device_info *cdi)
 		mmc3_profile = (buffer[6] << 8) | buffer[7];
 
 	cdi->mmc3_profile = mmc3_profile;
-	kfree(buffer);
 }
 
 static int cdrom_is_dvd_rw(struct cdrom_device_info *cdi)
@@ -1628,15 +1573,12 @@ static void setup_send_key(struct packet_command *cgc, unsigned agid, unsigned t
 static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 {
 	int ret;
-	u_char *buf;
+	u_char buf[20];
 	struct packet_command cgc;
 	struct cdrom_device_ops *cdo = cdi->ops;
-	rpc_state_t *rpc_state;
-
-	buf = kzalloc(20, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	rpc_state_t rpc_state;
 
+	memset(buf, 0, sizeof(buf));
 	init_cdrom_command(&cgc, buf, 0, CGC_DATA_READ);
 
 	switch (ai->type) {
@@ -1647,7 +1589,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		setup_report_key(&cgc, ai->lsa.agid, 0);
 
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
-			goto err;
+			return ret;
 
 		ai->lsa.agid = buf[7] >> 6;
 		/* Returning data, let host change state */
@@ -1658,7 +1600,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		setup_report_key(&cgc, ai->lsk.agid, 2);
 
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
-			goto err;
+			return ret;
 
 		copy_key(ai->lsk.key, &buf[4]);
 		/* Returning data, let host change state */
@@ -1669,7 +1611,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		setup_report_key(&cgc, ai->lsc.agid, 1);
 
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
-			goto err;
+			return ret;
 
 		copy_chal(ai->lsc.chal, &buf[4]);
 		/* Returning data, let host change state */
@@ -1686,7 +1628,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cgc.cmd[2] = ai->lstk.lba >> 24;
 
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
-			goto err;
+			return ret;
 
 		ai->lstk.cpm = (buf[4] >> 7) & 1;
 		ai->lstk.cp_sec = (buf[4] >> 6) & 1;
@@ -1700,7 +1642,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		setup_report_key(&cgc, ai->lsasf.agid, 5);
 		
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
-			goto err;
+			return ret;
 
 		ai->lsasf.asf = buf[7] & 1;
 		break;
@@ -1713,7 +1655,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		copy_chal(&buf[4], ai->hsc.chal);
 
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
-			goto err;
+			return ret;
 
 		ai->type = DVD_LU_SEND_KEY1;
 		break;
@@ -1726,7 +1668,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 
 		if ((ret = cdo->generic_packet(cdi, &cgc))) {
 			ai->type = DVD_AUTH_FAILURE;
-			goto err;
+			return ret;
 		}
 		ai->type = DVD_AUTH_ESTABLISHED;
 		break;
@@ -1737,23 +1679,24 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cdinfo(CD_DVD, "entering DVD_INVALIDATE_AGID\n"); 
 		setup_report_key(&cgc, ai->lsa.agid, 0x3f);
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
-			goto err;
+			return ret;
 		break;
 
 	/* Get region settings */
 	case DVD_LU_SEND_RPC_STATE:
 		cdinfo(CD_DVD, "entering DVD_LU_SEND_RPC_STATE\n");
 		setup_report_key(&cgc, 0, 8);
+		memset(&rpc_state, 0, sizeof(rpc_state_t));
+		cgc.buffer = (char *) &rpc_state;
 
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
-			goto err;
+			return ret;
 
-		rpc_state = (rpc_state_t *)buf;
-		ai->lrpcs.type = rpc_state->type_code;
-		ai->lrpcs.vra = rpc_state->vra;
-		ai->lrpcs.ucca = rpc_state->ucca;
-		ai->lrpcs.region_mask = rpc_state->region_mask;
-		ai->lrpcs.rpc_scheme = rpc_state->rpc_scheme;
+		ai->lrpcs.type = rpc_state.type_code;
+		ai->lrpcs.vra = rpc_state.vra;
+		ai->lrpcs.ucca = rpc_state.ucca;
+		ai->lrpcs.region_mask = rpc_state.region_mask;
+		ai->lrpcs.rpc_scheme = rpc_state.rpc_scheme;
 		break;
 
 	/* Set region settings */
@@ -1764,23 +1707,20 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		buf[4] = ai->hrpcs.pdrc;
 
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
-			goto err;
+			return ret;
 		break;
 
 	default:
 		cdinfo(CD_WARNING, "Invalid DVD key ioctl (%d)\n", ai->type);
-		ret = -ENOTTY;
-		goto err;
+		return -ENOTTY;
 	}
-	ret = 0;
-err:
-	kfree(buf);
-	return ret;
+
+	return 0;
 }
 
 static int dvd_read_physical(struct cdrom_device_info *cdi, dvd_struct *s)
 {
-	unsigned char *buf, *base;
+	unsigned char buf[21], *base;
 	struct dvd_layer *layer;
 	struct packet_command cgc;
 	struct cdrom_device_ops *cdo = cdi->ops;
@@ -1789,11 +1729,7 @@ static int dvd_read_physical(struct cdrom_device_info *cdi, dvd_struct *s)
 	if (layer_num >= DVD_LAYERS)
 		return -EINVAL;
 
-	buf = kmalloc(21, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	init_cdrom_command(&cgc, buf, 21, CGC_DATA_READ);
+	init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
 	cgc.cmd[0] = GPCMD_READ_DVD_STRUCTURE;
 	cgc.cmd[6] = layer_num;
 	cgc.cmd[7] = s->type;
@@ -1805,7 +1741,7 @@ static int dvd_read_physical(struct cdrom_device_info *cdi, dvd_struct *s)
 	cgc.quiet = 1;
 
 	if ((ret = cdo->generic_packet(cdi, &cgc)))
-		goto err;
+		return ret;
 
 	base = &buf[4];
 	layer = &s->physical.layer[layer_num];
@@ -1829,24 +1765,17 @@ static int dvd_read_physical(struct cdrom_device_info *cdi, dvd_struct *s)
 	layer->end_sector_l0 = base[13] << 16 | base[14] << 8 | base[15];
 	layer->bca = base[16] >> 7;
 
-	ret = 0;
-err:
-	kfree(buf);
-	return ret;
+	return 0;
 }
 
 static int dvd_read_copyright(struct cdrom_device_info *cdi, dvd_struct *s)
 {
 	int ret;
-	u_char *buf;
+	u_char buf[8];
 	struct packet_command cgc;
 	struct cdrom_device_ops *cdo = cdi->ops;
 
-	buf = kmalloc(8, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	init_cdrom_command(&cgc, buf, 8, CGC_DATA_READ);
+	init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
 	cgc.cmd[0] = GPCMD_READ_DVD_STRUCTURE;
 	cgc.cmd[6] = s->copyright.layer_num;
 	cgc.cmd[7] = s->type;
@@ -1854,15 +1783,12 @@ static int dvd_read_copyright(struct cdrom_device_info *cdi, dvd_struct *s)
 	cgc.cmd[9] = cgc.buflen & 0xff;
 
 	if ((ret = cdo->generic_packet(cdi, &cgc)))
-		goto err;
+		return ret;
 
 	s->copyright.cpst = buf[4];
 	s->copyright.rmi = buf[5];
 
-	ret = 0;
-err:
-	kfree(buf);
-	return ret;
+	return 0;
 }
 
 static int dvd_read_disckey(struct cdrom_device_info *cdi, dvd_struct *s)
@@ -1894,33 +1820,26 @@ static int dvd_read_disckey(struct cdrom_device_info *cdi, dvd_struct *s)
 static int dvd_read_bca(struct cdrom_device_info *cdi, dvd_struct *s)
 {
 	int ret;
-	u_char *buf;
+	u_char buf[4 + 188];
 	struct packet_command cgc;
 	struct cdrom_device_ops *cdo = cdi->ops;
 
-	buf = kmalloc(4 + 188, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	init_cdrom_command(&cgc, buf, 4 + 188, CGC_DATA_READ);
+	init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
 	cgc.cmd[0] = GPCMD_READ_DVD_STRUCTURE;
 	cgc.cmd[7] = s->type;
 	cgc.cmd[9] = cgc.buflen & 0xff;
 
 	if ((ret = cdo->generic_packet(cdi, &cgc)))
-		goto err;
+		return ret;
 
 	s->bca.len = buf[0] << 8 | buf[1];
 	if (s->bca.len < 12 || s->bca.len > 188) {
 		cdinfo(CD_WARNING, "Received invalid BCA length (%d)\n", s->bca.len);
-		ret = -EIO;
-		goto err;
+		return -EIO;
 	}
 	memcpy(s->bca.value, &buf[4], s->bca.len);
-	ret = 0;
-err:
-	kfree(buf);
-	return ret;
+
+	return 0;
 }
 
 static int dvd_read_manufact(struct cdrom_device_info *cdi, dvd_struct *s)
@@ -2020,13 +1939,9 @@ static int cdrom_read_subchannel(struct cdrom_device_info *cdi,
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
 	struct packet_command cgc;
-	char *buffer;
+	char buffer[32];
 	int ret;
 
-	buffer = kmalloc(32, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
 	init_cdrom_command(&cgc, buffer, 16, CGC_DATA_READ);
 	cgc.cmd[0] = GPCMD_READ_SUBCHANNEL;
 	cgc.cmd[1] = 2;     /* MSF addressing */
@@ -2035,7 +1950,7 @@ static int cdrom_read_subchannel(struct cdrom_device_info *cdi,
 	cgc.cmd[8] = 16;
 
 	if ((ret = cdo->generic_packet(cdi, &cgc)))
-		goto err;
+		return ret;
 
 	subchnl->cdsc_audiostatus = cgc.buffer[1];
 	subchnl->cdsc_format = CDROM_MSF;
@@ -2050,10 +1965,7 @@ static int cdrom_read_subchannel(struct cdrom_device_info *cdi,
 	subchnl->cdsc_absaddr.msf.second = cgc.buffer[10];
 	subchnl->cdsc_absaddr.msf.frame = cgc.buffer[11];
 
-	ret = 0;
-err:
-	kfree(buffer);
-	return ret;
+	return 0;
 }
 
 /*
-- 
1.5.4.2

