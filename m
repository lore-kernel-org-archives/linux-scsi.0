From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/9] snic: snic module infrastructure
Date: Mon, 02 Mar 2015 13:39:12 +0100
Message-ID: <54F459F0.6090703@suse.de>
References: <1423586616-18177-1-git-send-email-nmusini@cisco.com> <1423586616-18177-2-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbbCBMjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Mar 2015 07:39:14 -0500
In-Reply-To: <1423586616-18177-2-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

Hi Narsimhulu,

please find comments inline.

On 02/10/2015 05:43 PM, Narsimhulu Musini wrote:
> snic_main.c contains module load and unload, global driver context,
> PCI Registration, PCI probe and remove, SCSI ML registration function=
ality.
>=20
> snic.h contains snic structure definition, snic global context, and
> prototypes.
>=20
> snic_os.h contains OS specific interfaces.
>=20
> snic_attrs.c contains device attributes to list snic state, link stat=
e,
> and driver version under /sys/class/scsi_host/host<id>/
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> ---
>  drivers/scsi/snic/snic.h       |  422 +++++++++++++++++
>  drivers/scsi/snic/snic_attrs.c |   80 ++++
>  drivers/scsi/snic/snic_main.c  | 1010 ++++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/snic/snic_os.h    |   85 ++++
>  4 files changed, 1597 insertions(+)
>  create mode 100644 drivers/scsi/snic/snic.h
>  create mode 100644 drivers/scsi/snic/snic_attrs.c
>  create mode 100644 drivers/scsi/snic/snic_main.c
>  create mode 100644 drivers/scsi/snic/snic_os.h
>=20
> diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
> new file mode 100644
> index 0000000..15d735e
> --- /dev/null
> +++ b/drivers/scsi/snic/snic.h
> @@ -0,0 +1,422 @@
> +/*
> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _SNIC_H_
> +#define _SNIC_H_
> +
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <linux/workqueue.h>
> +#include <linux/bitops.h>
> +#include <linux/mempool.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_host.h>
> +
> +#include "snic_disc.h"
> +#include "snic_io.h"
> +#include "snic_res.h"
> +#include "snic_trc.h"
> +#include "snic_stats.h"
> +#include "vnic_dev.h"
> +#include "vnic_wq.h"
> +#include "vnic_cq.h"
> +#include "vnic_intr.h"
> +#include "vnic_stats.h"
> +#include "vnic_snic.h"
> +
> +#define SNIC_DRV_NAME		"snic"
> +#define SNIC_DRV_DESCRIPTION	"Cisco SCSI NIC Driver"
> +#define SNIC_DRV_VERSION	"0.0.1.18"
> +#define PFX			SNIC_DRV_NAME ":"
> +#define DFX			SNIC_DRV_NAME "%d: "
> +
> +#define DESC_CLEAN_LOW_WATERMARK	8
> +#define SNIC_UCSM_DFLT_THROTTLE_CNT_BLD 16 /* UCSM default throttle =
count */
> +#define SNIC_MAX_IO_REQ			50 /* scsi_cmnd tag map entries */
> +#define SNIC_MIN_IO_REQ			8  /* Min IO throttle count */
> +#define SNIC_IO_LOCKS			64 /* IO locks: power of 2 */
> +#define SNIC_DFLT_QUEUE_DEPTH		32 /* Default Queue Depth */
> +#define SNIC_MAX_QUEUE_DEPTH		64 /* Max Queue Depth */
> +#define SNIC_DFLT_CMD_TIMEOUT		90 /* Extended tmo for FW */
> +
> +/*
> + * Tag bits used for special requests.
> + */
> +#define SNIC_TAG_ABORT		BIT(30)		/* Tag indicating abort */
> +#define SNIC_TAG_DEV_RST	BIT(29)		/* Tag for device reset */
> +#define SNIC_TAG_IOCTL_DEV_RST	BIT(28)		/* Tag for User Device Reset=
 */
> +#define SNIC_TAG_MASK		(BIT(24) - 1)	/* Mask for lookup */
> +#define SNIC_NO_TAG		-1
> +
> +/*
> + * Command flags to identify the type of command and for other futur=
e use
> + */
> +#define SNIC_NO_FLAGS			0
> +#define SNIC_IO_INITIALIZED		BIT(0)
> +#define SNIC_IO_ISSUED			BIT(1)
> +#define SNIC_IO_DONE			BIT(2)
> +#define SNIC_IO_REQ_NULL		BIT(3)
> +#define SNIC_IO_ABTS_PENDING		BIT(4)
> +#define SNIC_IO_ABORTED			BIT(5)
> +#define SNIC_IO_ABTS_ISSUED		BIT(6)
> +#define SNIC_IO_TERM_ISSUED		BIT(7)
> +#define SNIC_IO_ABTS_TIMEDOUT		BIT(8)
> +#define SNIC_IO_ABTS_TERM_DONE		BIT(9)
> +#define SNIC_IO_ABTS_TERM_REQ_NULL	BIT(10)
> +#define SNIC_IO_ABTS_TERM_TIMEDOUT	BIT(11)
> +#define SNIC_IO_INTERNAL_TERM_PENDING	BIT(12)
> +#define SNIC_IO_INTERNAL_TERM_ISSUED	BIT(13)
> +#define SNIC_DEVICE_RESET		BIT(14)
> +#define SNIC_DEV_RST_ISSUED		BIT(15)
> +#define SNIC_DEV_RST_TIMEDOUT		BIT(16)
> +#define SNIC_DEV_RST_ABTS_ISSUED	BIT(17)
> +#define SNIC_DEV_RST_TERM_ISSUED	BIT(18)
> +#define SNIC_DEV_RST_DONE		BIT(19)
> +#define SNIC_DEV_RST_REQ_NULL		BIT(20)
> +#define SNIC_DEV_RST_ABTS_DONE		BIT(21)
> +#define SNIC_DEV_RST_TERM_DONE		BIT(22)
> +#define SNIC_DEV_RST_ABTS_PENDING	BIT(23)
> +#define SNIC_DEV_RST_PENDING		BIT(24)
> +#define SNIC_DEV_RST_NOTSUP		BIT(25)
> +#define SNIC_SCSI_CLEANUP		BIT(26)
> +#define SNIC_HOST_RESET_ISSUED		BIT(27)
> +
> +#define SNIC_ABTS_TIMEOUT		30000		/* msec */
> +#define SNIC_LUN_RESET_TIMEOUT		30000		/* msec */
> +#define SNIC_HOST_RESET_TIMEOUT		30000		/* msec */
> +
> +
> +/*
> + * Usage of the scsi_cmnd scratchpad.
> + * These fields are locked by the hashed req_lock.
> + */
> +#define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
> +#define CMD_STATE(Cmnd)		((Cmnd)->SCp.phase)
> +#define CMD_ABTS_STATUS(Cmnd)	((Cmnd)->SCp.Message)
> +#define CMD_LR_STATUS(Cmnd)	((Cmnd)->SCp.have_data_in)
> +#define CMD_TAG(Cmnd)		((Cmnd)->SCp.sent_command)
> +#define CMD_FLAGS(Cmnd)		((Cmnd)->SCp.Status)
> +
> +#define SNIC_INVALID_CODE 0x100	/* Hdr Status val unused by firmware=
 */
> +
> +/* snic specific Errors */
> +#define SNIC_IO_QERR	 (-50)	/* Error on Failed to queue IO. */
> +
> +#define SNIC_MAX_TARGET			256
> +#define SNIC_FLAGS_NONE			(0)
> +
> +/* snic module params */
> +extern unsigned int snic_max_qdepth;
> +
> +/* snic debugging */
> +extern unsigned int snic_log_level;
> +
> +#define SNIC_MAIN_LOGGING	0x1
> +#define SNIC_SCSI_LOGGING	0x2
> +#define SNIC_ISR_LOGGING	0x8
> +#define SNIC_DESC_LOGGING	0x10
> +
> +#define SNIC_CHECK_LOGGING(LEVEL, CMD)		\
> +do {						\
> +	if (unlikely(snic_log_level & LEVEL))	\
> +		do {				\
> +			CMD;			\
> +		} while (0);			\
> +} while (0)
> +
> +#define SNIC_MAIN_DBG(host, fmt, args...)	\
> +	SNIC_CHECK_LOGGING(SNIC_MAIN_LOGGING,		\
> +		shost_printk(KERN_INFO, host, fmt, ## args);)
> +
> +#define SNIC_SCSI_DBG(host, fmt, args...)	\
> +	SNIC_CHECK_LOGGING(SNIC_SCSI_LOGGING,		\
> +		shost_printk(KERN_INFO, host, fmt, ##args);)
> +
> +#define SNIC_DISC_DBG(host, fmt, args...)	\
> +	SNIC_CHECK_LOGGING(SNIC_SCSI_LOGGING,		\
> +		shost_printk(KERN_INFO, host, fmt, ##args);)
> +
> +#define SNIC_ISR_DBG(host, fmt, args...)	\
> +	SNIC_CHECK_LOGGING(SNIC_ISR_LOGGING,		\
> +		shost_printk(KERN_INFO, host, fmt, ##args);)
> +
> +#define SNIC_HOST_ERR(host, fmt, args...)		\
> +	shost_printk(KERN_ERR, host, fmt, ##args)
> +
> +#define SNIC_HOST_INFO(host, fmt, args...)		\
> +	shost_printk(KERN_INFO, host, fmt, ##args)
> +
> +#define SNIC_INFO(fmt, args...)				\
> +	pr_info(PFX fmt, ## args)
> +
> +#define SNIC_DBG(fmt, args...)				\
> +	pr_info(PFX fmt, ## args)
> +
> +#define SNIC_ERR(fmt, args...)				\
> +	pr_err(PFX fmt, ## args)
> +
> +#ifdef DEBUG
> +#define SNIC_BUG_ON(EXPR) \
> +	({ \
> +		if (EXPR) { \
> +			SNIC_ERR("SNIC BUG(%s)\n", #EXPR); \
> +			BUG_ON(EXPR); \
> +		} \
> +	})
> +#else
> +#define SNIC_BUG_ON(EXPR) \
> +	({ \
> +		if (EXPR) { \
> +			SNIC_ERR("SNIC BUG(%s) at %s : %d\n", \
> +				 #EXPR, __func__, __LINE__); \
> +			WARN_ON_ONCE(EXPR); \
> +		} \
> +	})
> +#endif
> +
> +/* Soft assert */
> +#define SNIC_ASSERT_NOT_IMPL(EXPR) \
> +	({ \
> +		if (EXPR) {\
> +			SNIC_INFO("Functionality not impl'ed at %s:%d\n", \
> +				  __func__, __LINE__); \
> +			WARN_ON_ONCE(EXPR); \
> +		} \
> +	 })
> +
> +
> +extern const char *snic_state_str[];
> +
> +enum snic_intx_intr_index {
> +	SNIC_INTX_WQ_RQ_COPYWQ,
> +	SNIC_INTX_ERR,
> +	SNIC_INTX_NOTIFY,
> +	SNIC_INTX_INTR_MAX,
> +};
> +
> +enum snic_msix_intr_index {
> +	SNIC_MSIX_WQ,
> +	SNIC_MSIX_IO_CMPL,
> +	SNIC_MSIX_ERR_NOTIFY,
> +	SNIC_MSIX_INTR_MAX,
> +};
> +
> +struct snic_msix_entry {
> +	int requested;
> +	char devname[IFNAMSIZ];
> +	irqreturn_t (*isr)(int, void *);
> +	void *devid;
> +};
> +
> +enum snic_state {
> +	SNIC_INIT =3D 0,
> +	SNIC_ERROR,
> +	SNIC_ONLINE,
> +	SNIC_OFFLINE,
> +	SNIC_FWRESET,
> +};
> +
> +#define SNIC_WQ_MAX		1
> +#define SNIC_CQ_IO_CMPL_MAX	1
> +#define SNIC_CQ_MAX		(SNIC_WQ_MAX + SNIC_CQ_IO_CMPL_MAX)
> +
> +/* firmware version information */
> +struct snic_fw_info {
> +	u32	fw_ver;
> +	u32	hid;			/* u16 hid | u16 vnic id */
> +	u32	max_concur_ios;		/* max concurrent ios */
> +	u32	max_sgs_per_cmd;	/* max sgls per IO */
> +	u32	max_io_sz;		/* max io size supported */
> +	u32	hba_cap;		/* hba capabilities */
> +	u32	max_tgts;		/* max tgts supported */
> +	u16	io_tmo;			/* FW Extended timeout */
> +	struct completion *wait;	/* protected by snic lock*/
> +};
> +
> +/*
> + * snic_work item : defined to process asynchronous events
> + */
> +struct snic_work {
> +	struct work_struct work;
> +	u16	ev_id;
> +	u64	*ev_data;
> +};
> +
> +/*
> + * snic structure to represent SCSI vNIC
> + */
> +struct snic {
> +	/* snic specific members */
> +	struct list_head list;
> +	char name[IFNAMSIZ];
> +	atomic_t state;
> +	spinlock_t snic_lock;
> +	u32 in_remove;
> +	struct completion *remove_wait;
> +	u32 stop_link_events:1;		/* stop processing link events */
Please use 'bool' here; 'in_remove' should probably also be 'bool'

> +
> +	/* discovery related */
> +	struct snic_disc disc;
> +
> +	/* Scsi Host info */
> +	struct Scsi_Host *shost;
> +
> +	/* vnic related structures */
> +	struct vnic_dev_bar bar0;
> +
> +	struct vnic_stats *stats;
> +	unsigned long stats_time;
> +	unsigned long stats_reset_time;
> +
> +	struct vnic_nic_cfg *nic_cfg;
> +	struct vnic_dev *vdev;
> +
> +	/* hw resource info */
> +	unsigned int wq_count;
> +	unsigned int cq_count;
> +	unsigned int intr_count;
> +	unsigned int err_intr_offset;
> +
> +	unsigned int link_intr_offset;
> +	int link_status; /* retrieved from vnic_dev_link_status() */
> +	u32 link_down_cnt;
> +
> +	struct timer_list notify_timer; /* used for MSI interrupts  (??) */
> +
> +	/* pci related */
> +	struct pci_dev *pdev;
> +	struct msix_entry msix_entry[SNIC_MSIX_INTR_MAX];
> +	struct snic_msix_entry msix[SNIC_MSIX_INTR_MAX];
> +
> +	/* io related info */
> +	mempool_t *req_pool[SNIC_REQ_MAX_CACHES]; /* (??) */
> +	____cacheline_aligned spinlock_t io_req_lock[SNIC_IO_LOCKS];
> +
> +	/* Maintain snic specific commands, cmds with no tag in spl_cmd_lis=
t */
> +	____cacheline_aligned spinlock_t spl_cmd_lock;
> +	struct list_head spl_cmd_list;
> +
> +	unsigned int max_tag_id;
> +	atomic_t ios_inflight;		/* io in flight counter */
> +	u32 _reserved;
Huh? Where's the point in keeping a 'reserved' field here?
Is the structure matched to the hardware?

> +
> +	struct vnic_snic_config config;
> +
> +	struct work_struct link_work;
> +	struct work_struct frame_work;
> +	struct sk_buff_head frame_queue;
> +	struct sk_buff_head tx_queue;
> +
> +	struct snic_host_tag *tags;
> +
> +	/* firmware information */
> +	struct snic_fw_info fwinfo;
> +
> +	/* Work for processing Target related work */
> +	struct work_struct tgt_work;
> +
> +	/* Work for processing Discovery */
> +	struct work_struct disc_work;
> +
> +	/* stats related */
> +	unsigned int reset_stats;
> +	atomic64_t io_cmpl_skip;
> +	struct snic_stats s_stats;	/* Per SNIC driver stats */
> +
> +	/* platform specific */
> +
> +	struct dentry *stats_host;	/* Per snic debugfs root */
> +	struct dentry *stats_file;	/* Per snic debugfs file */
> +	struct dentry *reset_stats_file;/* Per snic reset stats file */
> +
> +	/* completion queue cache line section */
> +	____cacheline_aligned struct vnic_cq cq[SNIC_CQ_MAX];
> +
> +	/* work queue cache line section */
> +	____cacheline_aligned struct vnic_wq wq[SNIC_WQ_MAX];
> +	spinlock_t wq_lock[SNIC_WQ_MAX];
> +
> +	/* interrupt resource cache line section */
> +	____cacheline_aligned struct vnic_intr intr[SNIC_MSIX_INTR_MAX];
> +}; /* end of snic structure */
> +
> +/*
> + * SNIC Driver's Global Data
> + */
> +struct snic_global {
> +	struct list_head snic_list;
> +	spinlock_t snic_list_lock;
> +
> +	struct kmem_cache *req_cache[SNIC_REQ_MAX_CACHES];
> +
> +	struct workqueue_struct *event_q;
> +
> +	/* debugfs related global data */
> +	struct dentry *trc_root;
> +	struct dentry *stats_root;
> +
> +	struct snic_trc trc ____cacheline_aligned;
> +
> +	/* FIXME: IOCTL interface for hwsepcifc info retrieval ex:logs*/
> +};
> +
> +extern struct snic_global *snic_glob;
> +
> +int snic_glob_init(void);
> +void snic_glob_cleanup(void);
> +
> +extern struct workqueue_struct *snic_event_queue;
> +
> +int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
> +int snic_abort_cmd(struct scsi_cmnd *);
> +int snic_device_reset(struct scsi_cmnd *);
> +int snic_host_reset(struct scsi_cmnd *);
> +int snic_reset(struct Scsi_Host *, struct scsi_cmnd *);
> +void snic_shutdown_scsi_cleanup(struct snic *);
> +
> +
> +int snic_request_intr(struct snic *);
> +void snic_free_intr(struct snic *);
> +int snic_set_intr_mode(struct snic *);
> +void snic_clear_intr_mode(struct snic *);
> +
> +int snic_fwcq_cmpl_handler(struct snic *, int);
> +int snic_wq_cmpl_handler(struct snic *, int);
> +void snic_free_wq_buf(struct vnic_wq *, struct vnic_wq_buf *);
> +
> +
> +void snic_log_q_error(struct snic *);
> +void snic_handle_link_event(struct snic *);
> +void snic_handle_link(struct work_struct *);
> +
> +int snic_queue_exch_ver_req(struct snic *);
> +int snic_io_exch_ver_cmpl_handler(struct snic *, struct snic_fw_req =
*);
> +
> +int snic_queue_wq_desc(struct snic *, void *os_buf, u16 len);
> +
> +void snic_handle_untagged_req(struct snic *, struct snic_req_info *)=
;
> +void snic_release_untagged_req(struct snic *, struct snic_req_info *=
);
> +void snic_free_all_untagged_reqs(struct snic *);
> +int snic_get_conf(struct snic *);
> +void snic_set_state(struct snic *, enum snic_state);
> +int snic_get_state(struct snic *);
> +const char *snic_state_to_str(unsigned int);
> +void snic_hex_dump(char *, char *, int);
> +void snic_print_desc(const char *fn, char *os_buf, int len);
> +const char *show_opcode_name(int val);
> +#endif /* _SNIC_H */
> diff --git a/drivers/scsi/snic/snic_attrs.c b/drivers/scsi/snic/snic_=
attrs.c
> new file mode 100644
> index 0000000..ac6dbda
> --- /dev/null
> +++ b/drivers/scsi/snic/snic_attrs.c
> @@ -0,0 +1,80 @@
> +/*
> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + * [Insert appropriate license here when releasing outside of Cisco]
> + *
> + */
> +
> +#include <linux/string.h>
> +#include <linux/device.h>
> +
> +#include "snic.h"
> +#include "snic_os.h"
> +
> +static ssize_t
> +snic_show_sym_name(struct device *dev,
> +		struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct snic *snic =3D shost_priv(class_to_shost(dev));
> +
> +	return snprintf(buf, PAGE_SIZE, "%s\n", snic->name);
> +}
> +
> +static ssize_t
> +snic_show_state(struct device *dev,
> +		struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct snic *snic =3D shost_priv(class_to_shost(dev));
> +
> +	return snprintf(buf, PAGE_SIZE, "%s\n",
> +			snic_state_str[snic_get_state(snic)]);
> +}
> +
> +static ssize_t
> +snic_show_drv_version(struct device *dev,
> +		      struct device_attribute *attr,
> +		      char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%s\n", SNIC_DRV_VERSION);
> +}
> +
> +static ssize_t
> +snic_show_link_state(struct device *dev,
> +		     struct device_attribute *attr,
> +		     char *buf)
> +{
> +	struct snic *snic =3D shost_priv(class_to_shost(dev));
> +
> +	if (snic->config.xpt_type =3D=3D SNIC_DAS)
> +		snic->link_status =3D vnic_dev_link_status(snic->vdev);
> +
> +	return snprintf(buf, PAGE_SIZE, "%s\n",
> +			(snic->link_status) ? "Link Up" : "Link Down");
> +}
> +
> +static DEVICE_ATTR(snic_sym_name, S_IRUGO, snic_show_sym_name, NULL)=
;
> +static DEVICE_ATTR(snic_state, S_IRUGO, snic_show_state, NULL);
> +static DEVICE_ATTR(drv_version, S_IRUGO, snic_show_drv_version, NULL=
);
> +static DEVICE_ATTR(link_state, S_IRUGO, snic_show_link_state, NULL);
> +
> +struct device_attribute *snic_attrs[] =3D {
> +	&dev_attr_snic_sym_name,
> +	&dev_attr_snic_state,
> +	&dev_attr_drv_version,
> +	&dev_attr_link_state,
> +	NULL,
> +};
> diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_m=
ain.c
> new file mode 100644
> index 0000000..d45de0e
> --- /dev/null
> +++ b/drivers/scsi/snic/snic_main.c
> @@ -0,0 +1,1010 @@
> +/*
> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/mempool.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/pci.h>
> +#include <linux/skbuff.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <linux/workqueue.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> +
> +#include "snic.h"
> +#include "snic_os.h"
> +#include "snic_fwint.h"
> +
> +#define PCI_DEVICE_ID_CISCO_SNIC	0x0046
> +
> +/* Supported devices by snic module */
> +static struct pci_device_id snic_id_table[] =3D {
> +	{PCI_DEVICE(PCI_VENDOR_ID_CISCO, PCI_DEVICE_ID_CISCO_SNIC) },
> +	{ 0, }	/* end of table */
> +};
> +
> +unsigned int snic_log_level =3D 0x0;
> +module_param(snic_log_level, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(snic_log_level, "bitmask for snic logging levels");
> +
> +unsigned int snic_trace_max_pages =3D 16;
> +module_param(snic_trace_max_pages, uint, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(snic_trace_max_pages,
> +		"Total allocated memory pages for snic trace buffer");
> +
> +unsigned int snic_max_qdepth =3D SNIC_DFLT_QUEUE_DEPTH;
> +module_param(snic_max_qdepth, uint, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(snic_max_qdepth, "Queue depth to report for each LU=
N");
> +
> +/*
> + * snic_slave_alloc : callback function to SCSI Mid Layer, called on
> + * scsi device initialization.
> + */
> +static int
> +snic_slave_alloc(struct scsi_device *sdev)
> +{
> +	u32 qdepth =3D 0, max_ios =3D 0;
> +	struct snic_tgt *tgt =3D starget_to_tgt(scsi_target(sdev));
> +
> +	if (!tgt || snic_tgt_chkready(tgt))
> +		return -ENXIO;
> +
> +	max_ios =3D snic_max_qdepth;
> +	max_ios =3D snic_max_qdepth;
> +	qdepth =3D min_t(u32, max_ios, SNIC_MAX_QUEUE_DEPTH);
> +	scsi_change_queue_depth(sdev, qdepth);
> +
> +	return 0;
> +}
> +
> +static int
> +snic_slave_configure(struct scsi_device *sdev)
> +{
> +	struct snic *snic =3D shost_priv(sdev->host);
> +	int tmo =3D SNIC_DFLT_CMD_TIMEOUT * HZ;
> +
> +	if (snic->fwinfo.io_tmo > 1)
> +		tmo =3D snic->fwinfo.io_tmo * HZ;
> +
> +	/* FW requires extended timeouts */
> +	blk_queue_rq_timeout(sdev->request_queue, tmo);
> +
> +	return 0;
> +}
> +
> +static int
> +snic_change_queue_depth(struct scsi_device *sdev, int qdepth)
> +{
> +	int qsz =3D 0;
> +
> +	qsz =3D min_t(u32, qdepth, SNIC_MAX_QUEUE_DEPTH);
> +	scsi_change_queue_depth(sdev, qsz);
> +	SNIC_INFO("QDepth Changed to %d\n", sdev->queue_depth);
> +
> +	return sdev->queue_depth;
> +}
> +
> +static struct scsi_host_template snic_host_template =3D {
> +	.module =3D THIS_MODULE,
> +	.name =3D SNIC_DRV_NAME,
> +	.queuecommand =3D snic_queuecommand,
> +	.eh_abort_handler =3D snic_abort_cmd,
> +	.eh_device_reset_handler =3D snic_device_reset,
> +	.eh_host_reset_handler =3D snic_host_reset,
> +	.slave_alloc =3D snic_slave_alloc,
> +	.slave_configure =3D snic_slave_configure,
> +	.change_queue_depth =3D snic_change_queue_depth,
> +	.this_id =3D -1,
> +	.cmd_per_lun =3D 3,
> +	.can_queue =3D SNIC_MAX_IO_REQ,
> +	.use_clustering =3D ENABLE_CLUSTERING,
> +	.sg_tablesize =3D SNIC_MAX_SG_DESC_CNT,
> +	.max_sectors =3D 0x800,
> +	.shost_attrs =3D snic_attrs,
> +	.use_blk_tags =3D 1,
> +	.track_queue_depth =3D 1,
> +};
> +
> +/*
> + * snic_handle_link_event : Handles link events such as link up/down=
/error
> + */
> +void
> +snic_handle_link_event(struct snic *snic)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&snic->snic_lock, flags);
> +	if (snic->stop_link_events) {
> +		spin_unlock_irqrestore(&snic->snic_lock, flags);
> +
> +		return;
> +	}
> +	spin_unlock_irqrestore(&snic->snic_lock, flags);
> +
> +	queue_work(snic_glob->event_q, &snic->link_work);
> +} /* end of snic_handle_link_event */
> +
> +/*
> + * snic_notify_set : sets notification area
> + * This notification area is to receive events from fw
> + * Note: snic supports only MSIX interrupts, in which we can just ca=
ll
> + *  vnic_dev_notify_set directly
> + */
> +static int
> +snic_notify_set(struct snic *snic)
> +{
> +	int ret =3D 0;
> +	enum vnic_dev_intr_mode intr_mode;
> +
> +	intr_mode =3D vnic_dev_get_intr_mode(snic->vdev);
> +
> +	if (intr_mode =3D=3D VNIC_DEV_INTR_MODE_MSIX) {
> +		ret =3D vnic_dev_notify_set(snic->vdev, SNIC_MSIX_ERR_NOTIFY);
> +	} else {
> +		SNIC_HOST_ERR(snic->shost,
> +			      "Interrupt mode should be setup before devcmd notify set %d=
\n",
> +			      intr_mode);
> +		ret =3D -1;
> +	}
> +
> +	return ret;
> +} /* end of snic_notify_set */
> +
> +/*
> + * snic_dev_wait : polls vnic open status.
> + */
> +static int
> +snic_dev_wait(struct vnic_dev *vdev,
> +		int (*start)(struct vnic_dev *, int),
> +		int (*finished)(struct vnic_dev *, int *),
> +		int arg)
> +{
> +	unsigned long time;
> +	int ret, done;
> +	int retry_cnt =3D 0;
> +
> +	ret =3D start(vdev, arg);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Wait for func to complete...2 seconds max.
> +	 *
> +	 * Sometimes schedule_timeout_uninterruptible take long	time
> +	 * to wakeup, which results skipping retry. The retry counter
> +	 * ensures to retry at least two times.
> +	 */
> +	time =3D jiffies + HZ + 2;
> +	do {
> +		ret =3D finished(vdev, &done);
> +		if (ret)
> +			return ret;
> +
> +		if (done)
> +			return 0;
> +		schedule_timeout_uninterruptible(HZ/10);
> +		++retry_cnt;
> +	} while (time_after(time, jiffies) || (retry_cnt < 3));
> +
> +	return -ETIMEDOUT;
> +} /* end of snic_dev_wait */
> +
> +/*
> + * snic_cleanup: called by snic_remove
> + * Stops the snic device, masks all interrupts, Completed CQ entries=
 are
> + * drained. Posted WQ/RQ/Copy-WQ entries are cleanup
> + */
> +static int
> +snic_cleanup(struct snic *snic)
> +{
> +	unsigned int i;
> +	int ret;
> +
> +	vnic_dev_disable(snic->vdev);
> +	for (i =3D 0; i < snic->intr_count; i++)
> +		vnic_intr_mask(&snic->intr[i]);
> +
> +	for (i =3D 0; i < snic->wq_count; i++) {
> +		ret =3D vnic_wq_disable(&snic->wq[i]);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/* Clean up completed IOs */
> +	snic_fwcq_cmpl_handler(snic, -1);
> +
> +	snic_wq_cmpl_handler(snic, -1);
> +
> +	/* Clean up the IOs that have not completed */
> +	for (i =3D 0; i < snic->wq_count; i++)
> +		vnic_wq_clean(&snic->wq[i], snic_free_wq_buf);
> +
> +	for (i =3D 0; i < snic->cq_count; i++)
> +		vnic_cq_clean(&snic->cq[i]);
> +
> +	for (i =3D 0; i < snic->intr_count; i++)
> +		vnic_intr_clean(&snic->intr[i]);
> +
> +	/* Cleanup snic specific requests */
> +	snic_free_all_untagged_reqs(snic);
> +
> +	/* Cleanup Pending SCSI commands */
> +	snic_shutdown_scsi_cleanup(snic);
> +
> +	for (i =3D 0; i < SNIC_REQ_MAX_CACHES; i++)
> +		mempool_destroy(snic->req_pool[i]);
> +
> +	return 0;
> +} /* end of snic_cleanup */
> +
> +
> +static void
> +snic_iounmap(struct snic *snic)
> +{
> +	if (snic->bar0.vaddr)
> +		iounmap(snic->bar0.vaddr);
> +}
> +
> +/*
> + * snic_vdev_open_done : polls for vnic_dev_open cmd completion.
> + */
> +static int
> +snic_vdev_open_done(struct vnic_dev *vdev, int *done)
> +{
> +	struct snic *snic =3D vnic_dev_priv(vdev);
> +	int ret;
> +	int nretries =3D 5;
> +
> +	do {
> +		ret =3D vnic_dev_open_done(vdev, done);
> +		if (ret =3D=3D 0)
> +			break;
> +
> +		SNIC_HOST_INFO(snic->shost, "VNIC_DEV_OPEN Timedout.\n");
> +	} while (nretries--);
> +
> +	return ret;
> +} /* end of snic_vdev_open_done */
> +
> +/*
> + * snic_add_host : registers scsi host with ML
> + */
> +static int
> +snic_add_host(struct Scsi_Host *shost, struct pci_dev *pdev)
> +{
> +	int ret =3D 0;
> +
> +	ret =3D scsi_add_host(shost, &pdev->dev);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "snic: scsi_add_host failed. %d\n",
> +			      ret);
> +
> +		return ret;
> +	}
> +
> +	ret =3D snic_add_host_workq(shost);
> +
> +	return ret;
> +} /* end of snic_add_host */
> +
> +static void
> +snic_del_host(struct Scsi_Host *shost)
> +{
> +	snic_del_host_workq(shost);
> +	scsi_remove_host(shost);
> +}
> +
> +int
> +snic_get_state(struct snic *snic)
> +{
> +	return atomic_read(&snic->state);
> +}
> +
> +void
> +snic_set_state(struct snic *snic, enum snic_state state)
> +{
> +	SNIC_HOST_INFO(snic->shost, "snic state change from %s to %s\n",
> +		       snic_state_to_str(snic_get_state(snic)),
> +		       snic_state_to_str(state));
> +
> +	atomic_set(&snic->state, state);
> +}
> +
> +/*
> + * snic_probe : Initialize the snic interface.
> + */
> +static int
> +snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	struct Scsi_Host *shost;
> +	struct snic *snic;
> +	mempool_t *pool;
> +	unsigned long flags;
> +	u32 max_ios =3D 0;
> +	int ret, i;
> +
> +	/* Device Information */
> +	SNIC_INFO("snic device %4x:%4x:%4x:%4x: ",
> +		  pdev->vendor, pdev->device, pdev->subsystem_vendor,
> +		  pdev->subsystem_device);
> +
> +	SNIC_INFO("snic device bus %x: slot %x: fn %x\n",
> +		  pdev->bus->number, PCI_SLOT(pdev->devfn),
> +		  PCI_FUNC(pdev->devfn));
> +
> +	/*
> +	 * Allocate SCSI Host and setup association between host, and snic
> +	 */
> +	shost =3D scsi_host_alloc(&snic_host_template, sizeof(struct snic))=
;
> +	if (!shost) {
> +		SNIC_ERR("Unable to alloc scsi_host\n");
> +		ret =3D -ENOMEM;
> +
> +		goto prob_end;
> +	}
> +	snic =3D shost_priv(shost);
> +	snic->shost =3D shost;
> +
> +	snprintf(snic->name, sizeof(snic->name) - 1, "%s%d", SNIC_DRV_NAME,
> +		 shost->host_no);
> +
> +	SNIC_HOST_INFO(shost,
> +		       "snic%d =3D %p shost =3D %p device bus %x: slot %x: fn %x\n=
",
> +		       shost->host_no, snic, shost, pdev->bus->number,
> +		       PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
> +
> +	/* Per snic debugfs init */
> +	ret =3D snic_stats_debugfs_init(snic);
> +	if (ret) {
> +		SNIC_HOST_ERR(snic->shost,
> +			      "Failed to initialize debugfs stats\n");
> +		snic_stats_debugfs_remove(snic);
> +	}
> +
Please use a separate CONFIG variable here to disable debugfs at
compile-time.

> +	/* Setup PCI Resources */
> +	pci_set_drvdata(pdev, snic);
> +	snic->pdev =3D pdev;
> +
> +	ret =3D pci_enable_device(pdev);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "Cannot enable PCI Resources, aborting : %d\n",
> +			      ret);
> +
> +		goto err_free_snic;
> +	}
> +
> +	ret =3D pci_request_regions(pdev, SNIC_DRV_NAME);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "Cannot obtain PCI Resources, aborting : %d\n",
> +			      ret);
> +
> +		goto err_pci_disable;
> +	}
> +
> +	pci_set_master(pdev);
> +
> +	/*
> +	 * Query PCI Controller on system for DMA addressing
> +	 * limitation for the device. Try 43-bit first, and
> +	 * fail to 32-bit.
> +	 */

43-bit DMA mask? Are you serious?

> +	ret =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(43));
> +	if (ret) {
> +		ret =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +		if (ret) {
> +			SNIC_HOST_ERR(shost,
> +				      "No Usable DMA Configuration, aborting %d\n",
> +				      ret);
> +
> +			goto err_rel_regions;
> +		}
> +
> +		ret =3D pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
> +		if (ret) {
> +			SNIC_HOST_ERR(shost,
> +				      "Unable to obtain 32-bit DMA for consistent allocations, a=
borting: %d\n",
> +				      ret);
> +
> +			goto err_rel_regions;
> +		}
> +	} else {
> +		ret =3D pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(43));
> +		if (ret) {
> +			SNIC_HOST_ERR(shost,
> +				      "Unable to obtain 43-bit DMA for consistent allocations. a=
borting: %d\n",
> +				      ret);
> +
> +			goto err_rel_regions;
> +		}
> +	}
> +
> +
> +	/* Map vNIC resources from BAR0 */
> +	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
> +		SNIC_HOST_ERR(shost, "BAR0 not memory mappable aborting.\n");
> +
> +		ret =3D -ENODEV;
> +		goto err_rel_regions;
> +	}
> +
> +	snic->bar0.vaddr =3D pci_iomap(pdev, 0, 0);
> +	if (!snic->bar0.vaddr) {
> +		SNIC_HOST_ERR(shost,
> +			      "Cannot memory map BAR0 res hdr aborting.\n");
> +
> +		ret =3D -ENODEV;
> +		goto err_rel_regions;
> +	}
> +
> +	snic->bar0.bus_addr =3D pci_resource_start(pdev, 0);
> +	snic->bar0.len =3D pci_resource_len(pdev, 0);
> +	SNIC_BUG_ON(snic->bar0.bus_addr =3D=3D 0);
> +
> +	/* Devcmd2 Resource Allocation and Initialization */
> +	snic->vdev =3D vnic_dev_alloc_discover(NULL, snic, pdev, &snic->bar=
0, 1);
> +	if (!snic->vdev) {
> +		SNIC_HOST_ERR(shost, "vNIC Resource Discovery Failed.\n");
> +
> +		ret =3D -ENODEV;
> +		goto err_iounmap;
> +	}
> +
> +	ret =3D vnic_dev_cmd_init(snic->vdev, 0);
> +	if (ret) {
> +		SNIC_HOST_INFO(shost, "Devcmd2 Init Failed. err =3D %d\n", ret);
> +
> +		goto err_vnic_unreg;
> +	}
> +
> +	ret =3D snic_dev_wait(snic->vdev, vnic_dev_open, snic_vdev_open_don=
e, 0);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "vNIC dev open failed, aborting. %d\n",
> +			      ret);
> +
> +		goto err_vnic_unreg;
> +	}
> +
> +	ret =3D vnic_dev_init(snic->vdev, 0);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "vNIC dev init failed. aborting. %d\n",
> +			      ret);
> +
> +		goto err_dev_close;
> +	}
> +
> +	/* Get vNIC information */
> +	ret =3D snic_get_vnic_config(snic);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "Get vNIC configuration failed, aborting. %d\n",
> +			      ret);
> +
> +		goto err_dev_close;
> +	}
> +
> +	/* Configure Maximum Outstanding IO reqs */
> +	max_ios =3D snic->config.io_throttle_count;
> +	if (max_ios !=3D SNIC_UCSM_DFLT_THROTTLE_CNT_BLD)
> +		shost->can_queue =3D min_t(u32, SNIC_MAX_IO_REQ,
> +					 max_t(u32, SNIC_MIN_IO_REQ, max_ios));
> +
> +	snic->max_tag_id =3D shost->can_queue;
> +
> +	ret =3D scsi_init_shared_tag_map(shost, snic->max_tag_id);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "Unable to alloc shared tag map. %d\n",
> +			      ret);
> +
> +		goto err_dev_close;
> +	}
> +
> +	shost->max_lun =3D snic->config.luns_per_tgt;
> +	shost->max_id =3D SNIC_MAX_TARGET;
> +
> +	shost->max_cmd_len =3D MAX_COMMAND_SIZE; /*defined in scsi_cmnd.h*/
> +
> +	snic_get_res_counts(snic);
> +
> +	/*
> +	 * Assumption: Only MSIx is supported
> +	 */
> +	ret =3D snic_set_intr_mode(snic);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "Failed to set intr mode aborting. %d\n",
> +			      ret);
> +
> +		goto err_dev_close;
> +	}
> +
> +	ret =3D snic_alloc_vnic_res(snic);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "Failed to alloc vNIC resources aborting. %d\n",
> +			      ret);
> +
> +		goto err_clear_intr;
> +	}
> +
> +	/* Initialize specific lists */
> +	INIT_LIST_HEAD(&snic->list);
> +
> +	/*
> +	 * spl_cmd_list for maintaining snic specific cmds
> +	 * such as EXCH_VER_REQ, REPORT_TARGETS etc
> +	 */
> +	INIT_LIST_HEAD(&snic->spl_cmd_list);
> +	spin_lock_init(&snic->spl_cmd_lock);
> +
> +	/* initialize all snic locks */
> +	spin_lock_init(&snic->snic_lock);
> +
> +	for (i =3D 0; i < SNIC_WQ_MAX; i++)
> +		spin_lock_init(&snic->wq_lock[i]);
> +
> +	for (i =3D 0; i < SNIC_IO_LOCKS; i++)
> +		spin_lock_init(&snic->io_req_lock[i]);
> +
> +	pool =3D mempool_create_slab_pool(2,
> +				snic_glob->req_cache[SNIC_REQ_CACHE_DFLT_SGL]);
> +	if (!pool) {
> +		SNIC_HOST_ERR(shost, "dflt sgl pool creation failed\n");
> +
> +		goto err_free_res;
> +	}
> +
> +	snic->req_pool[SNIC_REQ_CACHE_DFLT_SGL] =3D pool;
> +
> +	pool =3D mempool_create_slab_pool(2,
> +				snic_glob->req_cache[SNIC_REQ_CACHE_MAX_SGL]);
> +	if (!pool) {
> +		SNIC_HOST_ERR(shost, "max sgl pool creation failed\n");
> +
> +		goto err_free_dflt_sgl_pool;
> +	}
> +
> +	snic->req_pool[SNIC_REQ_CACHE_MAX_SGL] =3D pool;
> +
> +	pool =3D mempool_create_slab_pool(2,
> +				snic_glob->req_cache[SNIC_REQ_TM_CACHE]);
> +	if (!pool) {
> +		SNIC_HOST_ERR(shost, "snic tmreq info pool creation failed.\n");
> +
> +		goto err_free_max_sgl_pool;
> +	}
> +
> +	snic->req_pool[SNIC_REQ_TM_CACHE] =3D pool;
> +
> +	/* Initialize snic state */
> +	atomic_set(&snic->state, SNIC_INIT);
> +
> +	atomic_set(&snic->ios_inflight, 0);
> +
> +	/* Setup notification buffer area */
> +	ret =3D snic_notify_set(snic);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "Failed to alloc notify buffer aborting. %d\n",
> +			      ret);
> +
> +		goto err_free_tmreq_pool;
> +	}
> +
> +	/*
> +	 * Initialization done with PCI system, hardware, firmware.
> +	 * Add shost to SCSI
> +	 */
> +	ret =3D snic_add_host(shost, pdev);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "Adding scsi host Failed ... exiting. %d\n",
> +			      ret);
> +
> +		goto err_notify_unset;
> +	}
> +
> +	spin_lock_irqsave(&snic_glob->snic_list_lock, flags);
> +	list_add_tail(&snic->list, &snic_glob->snic_list);
> +	spin_unlock_irqrestore(&snic_glob->snic_list_lock, flags);
> +
> +	snic_disc_init(&snic->disc);
> +	INIT_WORK(&snic->tgt_work, snic_handle_tgt_disc);
> +	INIT_WORK(&snic->disc_work, snic_handle_disc);
> +	INIT_WORK(&snic->link_work, snic_handle_link);
> +
> +	/* Enable all queues */
> +	for (i =3D 0; i < snic->wq_count; i++)
> +		vnic_wq_enable(&snic->wq[i]);
> +
> +	ret =3D vnic_dev_enable_wait(snic->vdev);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "vNIC dev enable failed w/ error %d\n",
> +			      ret);
> +
> +		goto err_vdev_enable;
> +	}
> +
> +	ret =3D snic_request_intr(snic);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost, "Unable to request irq. %d\n", ret);
> +
> +		goto err_req_intr;
> +	}
> +
> +	for (i =3D 0; i < snic->intr_count; i++)
> +		vnic_intr_unmask(&snic->intr[i]);
> +
> +	snic_set_state(snic, SNIC_ONLINE);
> +
> +	/* Get snic params */
> +	ret =3D snic_get_conf(snic);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost,
> +			      "Failed to get snic io config from FW w err %d\n",
> +			      ret);
> +
> +		goto err_get_conf;
> +	}
> +
> +	ret =3D snic_disc_start(snic);
> +	if (ret) {
> +		SNIC_HOST_ERR(shost, "snic_probe:Discovery Failed w err =3D %d\n",
> +			      ret);
> +
> +		goto err_get_conf;
> +	}
> +
> +	SNIC_HOST_INFO(shost, "SNIC Device Probe Successful.\n");
> +
> +	return 0;
> +
> +err_get_conf:
> +	snic_free_all_untagged_reqs(snic);
> +
> +	for (i =3D 0; i < snic->intr_count; i++)
> +		vnic_intr_mask(&snic->intr[i]);
> +
> +	snic_free_intr(snic);
> +
> +err_req_intr:
> +	vnic_dev_disable(snic->vdev);
> +
> +err_vdev_enable:
> +	for (i =3D 0; i < snic->wq_count; i++) {
> +		int rc =3D 0;
> +
> +		rc =3D vnic_wq_disable(&snic->wq[i]);
> +		if (rc) {
> +			SNIC_HOST_ERR(shost,
> +				      "WQ Disable Failed w/ err =3D %d\n", rc);
> +
> +			 break;
> +		}
> +	}
> +	snic_del_host(snic->shost);
> +
> +err_notify_unset:
> +	vnic_dev_notify_unset(snic->vdev);
> +
> +err_free_tmreq_pool:
> +	mempool_destroy(snic->req_pool[SNIC_REQ_TM_CACHE]);
> +
> +err_free_max_sgl_pool:
> +	mempool_destroy(snic->req_pool[SNIC_REQ_CACHE_MAX_SGL]);
> +
> +err_free_dflt_sgl_pool:
> +	mempool_destroy(snic->req_pool[SNIC_REQ_CACHE_DFLT_SGL]);
> +
> +err_free_res:
> +	snic_free_vnic_res(snic);
> +
> +err_clear_intr:
> +	snic_clear_intr_mode(snic);
> +
> +err_dev_close:
> +	vnic_dev_close(snic->vdev);
> +
> +err_vnic_unreg:
> +	vnic_dev_unregister(snic->vdev);
> +
> +err_iounmap:
> +	snic_iounmap(snic);
> +
> +err_rel_regions:
> +	pci_release_regions(pdev);
> +
> +err_pci_disable:
> +	pci_disable_device(pdev);
> +
> +err_free_snic:
> +	snic_stats_debugfs_remove(snic);
> +	scsi_host_put(shost);
> +	pci_set_drvdata(pdev, NULL);
> +
> +prob_end:
> +	SNIC_INFO("sNIC device : bus %d: slot %d: fn %d Registration Failed=
=2E\n",
> +		  pdev->bus->number, PCI_SLOT(pdev->devfn),
> +		  PCI_FUNC(pdev->devfn));
> +
> +	return ret;
> +} /* end of snic_probe */
> +
> +
> +/*
> + * snic_remove : invoked on unbinding the interface to cleanup the
> + * resources allocated in snic_probe on initialization.
> + */
> +static void
> +snic_remove(struct pci_dev *pdev)
> +{
> +	struct snic *snic =3D pci_get_drvdata(pdev);
> +	unsigned long flags;
> +
> +	if (!snic) {
> +		SNIC_INFO("sNIC dev: bus %d slot %d fn %d snic inst is null.\n",
> +			  pdev->bus->number, PCI_SLOT(pdev->devfn),
> +			  PCI_FUNC(pdev->devfn));
> +
> +		return;
> +	}
> +
> +	/*
> +	 * Mark state so that the workqueue thread stops forwarding
> +	 * received frames and link events. ISR and other threads
> +	 * that can queue work items will also stop creating work
> +	 * items on the snic workqueue
> +	 */
> +	snic_set_state(snic, SNIC_OFFLINE);
> +	spin_lock_irqsave(&snic->snic_lock, flags);
> +	snic->stop_link_events =3D 1;
> +	spin_unlock_irqrestore(&snic->snic_lock, flags);
> +
> +	flush_workqueue(snic_glob->event_q);
> +	snic_disc_term(snic);
> +
> +	spin_lock_irqsave(&snic->snic_lock, flags);
> +	snic->in_remove =3D 1;
> +	spin_unlock_irqrestore(&snic->snic_lock, flags);
> +
> +	/*
> +	 * This stops the snic device, masks all interrupts, Completed
> +	 * CQ entries are drained. Posted WQ/RQ/Copy-WQ entries are
> +	 * cleanup
> +	 */
> +	snic_cleanup(snic);
> +
> +	spin_lock_irqsave(&snic_glob->snic_list_lock, flags);
> +	list_del(&snic->list);
> +	spin_unlock_irqrestore(&snic_glob->snic_list_lock, flags);
> +
> +	snic_tgt_del_all(snic);
> +	snic_stats_debugfs_remove(snic);
> +	snic_del_host(snic->shost);
> +
> +	vnic_dev_notify_unset(snic->vdev);
> +	snic_free_intr(snic);
> +	snic_free_vnic_res(snic);
> +	snic_clear_intr_mode(snic);
> +	vnic_dev_close(snic->vdev);
> +	vnic_dev_unregister(snic->vdev);
> +	snic_iounmap(snic);
> +	pci_release_regions(pdev);
> +	pci_disable_device(pdev);
> +	pci_set_drvdata(pdev, NULL);
> +
> +	/* this frees Scsi_Host and snic memory (continuous chunk) */
> +	scsi_host_put(snic->shost);
> +} /* end of snic_remove */
> +
> +
> +struct snic_global *snic_glob;
> +
> +/*
> + * snic_global_data_init: Initialize SNIC Global Data
> + * Notes: All the global lists, variables should be part of global d=
ata
> + * this helps in debugging.
> + */
> +static int
> +snic_global_data_init(void)
> +{
> +	int ret =3D 0;
> +	struct kmem_cache *cachep;
> +	ssize_t len =3D 0;
> +
> +	snic_glob =3D kzalloc(sizeof(*snic_glob), GFP_KERNEL);
> +
> +	if (!snic_glob) {
> +		SNIC_ERR("Failed to allocate Global Context.\n");
> +
> +		ret =3D -ENOMEM;
> +		goto gdi_end;
> +	}
> +
> +	/* Debugfs related Initialization */
> +	/* Create debugfs entries for snic */
> +	ret =3D snic_debugfs_init();
> +	if (ret < 0) {
> +		SNIC_ERR("Failed to create sysfs dir for tracing and stats.\n");
> +		snic_debugfs_term();
> +		/* continue even if it fails */
> +	}
> +
Same here; please make it optional during compile-time.

> +	/* Trace related Initialization */
> +	/* Allocate memory for trace buffer */
> +	ret =3D snic_trc_init();
> +	if (ret < 0) {
> +		SNIC_ERR("Trace buffer init failed, SNIC tracing disabled\n");
> +		snic_trc_free();
> +		/* continue even if it fails */
> +	}
> +
And this probably warrants a separate CONFIG option, too.

> +	INIT_LIST_HEAD(&snic_glob->snic_list);
> +	spin_lock_init(&snic_glob->snic_list_lock);
> +
> +	/* Create a cache for allocation of snic_host_req+default size ESGL=
s */
> +	len =3D sizeof(struct snic_req_info);
> +	len +=3D sizeof(struct snic_host_req) + sizeof(struct snic_dflt_sgl=
);
> +	cachep =3D snic_cache_create("snic_req_dfltsgl",
> +				   len + SNIC_SG_DESC_ALIGN);
> +	if (!cachep) {
> +		SNIC_ERR("Failed to create snic default sgl slab\n");
> +		ret =3D -ENOMEM;
> +
> +		goto err_dflt_req_slab;
> +	}
> +	snic_glob->req_cache[SNIC_REQ_CACHE_DFLT_SGL] =3D cachep;
> +
> +	/* Create a cache for allocation of max size Extended SGLs */
> +	len =3D sizeof(struct snic_req_info);
> +	len +=3D sizeof(struct snic_host_req) + sizeof(struct snic_max_sgl)=
;
> +	cachep =3D snic_cache_create("snic_req_maxsgl",
> +				   len + SNIC_SG_DESC_ALIGN);
> +	if (!cachep) {
> +		SNIC_ERR("Failed to create snic max sgl slab\n");
> +		ret =3D -ENOMEM;
> +
> +		goto err_max_req_slab;
> +	}
> +	snic_glob->req_cache[SNIC_REQ_CACHE_MAX_SGL] =3D cachep;
> +
> +	len =3D sizeof(struct snic_host_req);
> +	cachep =3D snic_cache_create("snic_tm_req",
> +				   len + SNIC_SG_DESC_ALIGN);
> +	if (!cachep) {
> +		SNIC_ERR("Failed to create snic tm req slab\n");
> +		ret =3D -ENOMEM;
> +
> +		goto err_tmreq_slab;
> +	}
> +	snic_glob->req_cache[SNIC_REQ_TM_CACHE] =3D cachep;
> +
> +	/* snic_event queue */
> +	snic_glob->event_q =3D create_singlethread_workqueue("snic_event_wq=
");
> +	if (!snic_glob->event_q) {
> +		SNIC_ERR("snic event queue create failed\n");
> +		ret =3D -ENOMEM;
> +
> +		goto err_eventq;
> +	}
> +
> +	return ret;
> +
> +err_eventq:
> +	kmem_cache_destroy(snic_glob->req_cache[SNIC_REQ_TM_CACHE]);
> +
> +err_tmreq_slab:
> +	kmem_cache_destroy(snic_glob->req_cache[SNIC_REQ_CACHE_MAX_SGL]);
> +
> +err_max_req_slab:
> +	kmem_cache_destroy(snic_glob->req_cache[SNIC_REQ_CACHE_DFLT_SGL]);
> +
> +err_dflt_req_slab:
> +	snic_trc_free();
> +	snic_debugfs_term();
> +	kfree(snic_glob);
> +	snic_glob =3D NULL;
> +
> +gdi_end:
> +	return ret;
> +} /* end of snic_glob_init */
> +
> +/*
> + * snic_global_data_cleanup : Frees SNIC Global Data
> + */
> +static void
> +snic_global_data_cleanup(void)
> +{
> +	SNIC_BUG_ON(snic_glob =3D=3D NULL);
> +
> +	destroy_workqueue(snic_glob->event_q);
> +	kmem_cache_destroy(snic_glob->req_cache[SNIC_REQ_TM_CACHE]);
> +	kmem_cache_destroy(snic_glob->req_cache[SNIC_REQ_CACHE_MAX_SGL]);
> +	kmem_cache_destroy(snic_glob->req_cache[SNIC_REQ_CACHE_DFLT_SGL]);
> +
> +	/* Freeing Trace Resources */
> +	snic_trc_free();
> +
> +	/* Freeing Debugfs Resources */
> +	snic_debugfs_term();
> +
> +	kfree(snic_glob);
> +	snic_glob =3D NULL;
> +} /* end of snic_glob_cleanup */
> +
> +static struct pci_driver snic_driver =3D {
> +	.name =3D SNIC_DRV_NAME,
> +	.id_table =3D snic_id_table,
> +	.probe =3D snic_probe,
> +	.remove =3D snic_remove,
> +};
> +
> +static int __init
> +snic_init_module(void)
> +{
> +	int ret =3D 0;
> +
> +	SNIC_INFO("%s, ver %s\n", SNIC_DRV_DESCRIPTION, SNIC_DRV_VERSION);
> +
> +	ret =3D snic_global_data_init();
> +	if (ret) {
> +		SNIC_ERR("Failed to Initialize Global Data.\n");
> +
> +		return ret;
> +	}
> +
> +	ret =3D pci_register_driver(&snic_driver);
> +	if (ret < 0) {
> +		SNIC_ERR("PCI driver register error\n");
> +
> +		goto err_pci_reg;
> +	}
> +
> +	return ret;
> +
> +err_pci_reg:
> +	snic_global_data_cleanup();
> +
> +	return ret;
> +}
> +
> +static void __exit
> +snic_cleanup_module(void)
> +{
> +	pci_unregister_driver(&snic_driver);
> +	snic_global_data_cleanup();
> +}
> +
> +module_init(snic_init_module);
> +module_exit(snic_cleanup_module);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION(SNIC_DRV_DESCRIPTION);
> +MODULE_VERSION(SNIC_DRV_VERSION);
> +MODULE_DEVICE_TABLE(pci, snic_id_table);
> +MODULE_AUTHOR("Narsimhulu Musini <nmusini@cisco.com>, "
> +	      "Sesidhar Baddela <sebaddel@cisco.com>");
> diff --git a/drivers/scsi/snic/snic_os.h b/drivers/scsi/snic/snic_os.=
h
> new file mode 100644
> index 0000000..4a6e542
> --- /dev/null
> +++ b/drivers/scsi/snic/snic_os.h
> @@ -0,0 +1,85 @@
> +/*
> + * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES O=
=46
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDE=
RS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN A=
N
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef __SNIC_OS_H
> +#define __SNIC_OS_H_
> +
> +#ifndef PCI_VENDOR_ID_CISCO
> +#define PCI_VENDOR_ID_CISCO     0x1137
> +#endif
> +
> +#define SNIC_OS_TYPE	SNIC_OS_LINUX
> +#define snic_cmd_tag(sc)	(((struct scsi_cmnd *) sc)->request->tag)
> +
> +/* scsi result error codes */
> +#define SNIC_ABTS_CMPL_ERR	DID_ERROR
> +#define SNIC_IO_CMPL_ABTSTATUS	DID_ERROR
> +
> +extern struct device_attribute *snic_attrs[];
> +
> +static inline struct kmem_cache *
> +snic_cache_create(const char *cache_name, const int sz)
> +{
> +	void *cp;
> +
> +	cp =3D kmem_cache_create(cache_name, sz, SNIC_SG_DESC_ALIGN,
> +			       SLAB_HWCACHE_ALIGN, NULL);
> +
> +	return (struct kmem_cache *) cp;
> +}
> +
> +#define snic_data_dump(s, d, l)	 print_hex_dump_bytes(s, DUMP_PREFIX=
_NONE, d, l)
> +
> +/*
> + * snic_add_host_workq : adds workq to scsi host
> + */
> +static inline int
> +snic_add_host_workq(struct Scsi_Host *shost)
> +{
> +	SNIC_BUG_ON(shost->work_q !=3D NULL);
> +	snprintf(shost->work_q_name, sizeof(shost->work_q_name), "scsi_wq_%=
d",
> +		 shost->host_no);
> +	shost->work_q =3D create_singlethread_workqueue(shost->work_q_name)=
;
> +	if (!shost->work_q) {
> +		SNIC_HOST_ERR(shost, "Failed to Create ScsiHost wq.\n");
> +
> +		return  -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * snic_del_host_workq - deletes workq from scsi host
> + */
> +
> +static inline void
> +snic_del_host_workq(struct Scsi_Host *shost)
> +{
> +	if (!shost->work_q)
> +		return;
> +
> +	destroy_workqueue(shost->work_q);
> +	shost->work_q =3D NULL;
> +}
> +
> +static inline char *
> +snic_get_task_name(void)
> +{
> +	return current->comm;
> +}
> +#endif /* end of __SNIC_OS_H_ */
>=20

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
