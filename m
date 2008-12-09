From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/2 2.6.29] cxgb3i - accelerating open-iscsi initiator
Date: Tue, 09 Dec 2008 16:37:58 +0200
Message-ID: <493E82C6.5030609@panasas.com>
References: <200812082030.mB8KUOMD029251@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:18396 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752976AbYLIOiK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2008 09:38:10 -0500
In-Reply-To: <200812082030.mB8KUOMD029251@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

Karen Xie wrote:
> [PATCH 2/2 2.6.29] cxgb3i - accelerating open-iscsi initiator
> 
> From: Karen Xie <kxie@chelsio.com> 
> 
> Add cxgb3i iSCSI driver.
> 
> This patch implements the cxgb3i iscsi connection acceleration for the
> open-iscsi initiator.
> 
> The cxgb3i driver offers the iscsi PDU based offload:
> - digest insertion and verification
> - payload direct-placement into host memory buffer.
> 
> Signed-off-by: Karen Xie <kxie@chelsio.com>
> ---
> 
>  drivers/scsi/Kconfig                 |    2 
>  drivers/scsi/Makefile                |    1 
>  drivers/scsi/cxgb3i/Kconfig          |    7 
>  drivers/scsi/cxgb3i/Makefile         |    4 
>  drivers/scsi/cxgb3i/cxgb3i.h         |  138 +++
>  drivers/scsi/cxgb3i/cxgb3i_ddp.c     |  770 ++++++++++++++
>  drivers/scsi/cxgb3i/cxgb3i_ddp.h     |  306 ++++++
>  drivers/scsi/cxgb3i/cxgb3i_init.c    |  107 ++
>  drivers/scsi/cxgb3i/cxgb3i_iscsi.c   |  955 ++++++++++++++++++
>  drivers/scsi/cxgb3i/cxgb3i_offload.c | 1810 ++++++++++++++++++++++++++++++++++
>  drivers/scsi/cxgb3i/cxgb3i_offload.h |  231 ++++
>  drivers/scsi/cxgb3i/cxgb3i_pdu.c     |  400 ++++++++
>  drivers/scsi/cxgb3i/cxgb3i_pdu.h     |   59 +
>  13 files changed, 4790 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/cxgb3i/Kconfig
>  create mode 100644 drivers/scsi/cxgb3i/Makefile
>  create mode 100644 drivers/scsi/cxgb3i/cxgb3i.h
>  create mode 100644 drivers/scsi/cxgb3i/cxgb3i_ddp.c
>  create mode 100644 drivers/scsi/cxgb3i/cxgb3i_ddp.h
>  create mode 100644 drivers/scsi/cxgb3i/cxgb3i_init.c
>  create mode 100644 drivers/scsi/cxgb3i/cxgb3i_iscsi.c
>  create mode 100644 drivers/scsi/cxgb3i/cxgb3i_offload.c
>  create mode 100644 drivers/scsi/cxgb3i/cxgb3i_offload.h
>  create mode 100644 drivers/scsi/cxgb3i/cxgb3i_pdu.c
>  create mode 100644 drivers/scsi/cxgb3i/cxgb3i_pdu.h
> 
> 
> diff --git a/Documentation/scsi/cxgb3i.txt b/Documentation/scsi/cxgb3i.txt
> new file mode 100644
> index 0000000..033d2f0
> --- /dev/null
> +++ b/Documentation/scsi/cxgb3i.txt
> @@ -0,0 +1,81 @@
> +Chelsio S3 iSCSI Driver for Linux
> +
> +Introduction
> +============
> +
> +The Chelsio T3 ASIC based Adapters (S310, S320, S302, S304, Mezz cards, etc.
> +series of products) supports iSCSI acceleration and iSCSI Direct Data Placement
> +(DDP) where the hardware handles the expensive byte touching operations, such
> +as CRC computation and verification, and direct DMA to the final host memory
> +destination:
> +
> +	- iSCSI PDU digest generation and verification
> +
> +	  On transmitting, Chelsio S3 h/w computes and inserts the Header and
> +	  Data digest into the PDUs.
> +	  On receiving, Chelsio S3 h/w computes and verifies the Header and
> +	  Data digest of the PDUs.
> +
> +	- Direct Data Placement (DDP)
> +
> +	  S3 h/w can directly place the iSCSI Data-In or Data-Out PDU's
> +	  payload into pre-posted final destination host-memory buffers based
> +	  on the Initiator Task Tag (ITT) in Data-In or Target Task Tag (TTT)
> +	  in Data-Out PDUs.
> +
> +	- PDU Transmit and Recovery
> +
> +	  On transmitting, S3 h/w accepts the complete PDU (header + data)
> +	  from the host driver, computes and inserts the digests, decomposes
> +	  the PDU into multiple TCP segments if necessary, and transmit all
> +	  the TCP segments onto the wire. It handles TCP retransmission if
> +	  needed.
> +
> +	  On receving, S3 h/w recovers the iSCSI PDU by reassembling TCP
> +	  segments, separating the header and data, calculating and verifying
> +	  the digests, then forwards the header to the host. The payload data,
> +	  if possible, will be directly placed into the pre-posted host DDP
> +	  buffer. Otherwise, the payload data will be sent to the host too.
> +
> +The cxgb3i driver interfaces with open-iscsi initiator and provides the iSCSI
> +acceleration through Chelsio hardware wherever applicable.
> +
> +Using the cxgb3i Driver
> +=======================
> +
> +The following steps need to be taken to accelerates the open-iscsi initiator:
> +
> +1. Load the cxgb3i driver: "modprobe cxgb3i"
> +
> +   The cxgb3i module registers a new transport class "cxgb3i" with open-iscsi.
> +
> +   * in the case of recompiling the kernel, the cxgb3i selection is located at
> +	Device Drivers
> +		SCSI device support --->
> +			[*] SCSI low-level drivers  --->
> +				<M>   Chelsio S3xx iSCSI support
> +
> +2. Create an interface file located under /etc/iscsi/ifaces/ for the new
> +   transport class "cxgb3i".
> +
> +   The content of the file should be in the following format:
> +	iface.transport_name = cxgb3i
> +	iface.net_ifacename = <ethX>
> +	iface.ipaddress = <iscsi ip address>
> +
> +   * if iface.ipaddress is specified, <iscsi ip address> needs to be either the
> +	same as the ethX's ip address or an address on the same subnet. Make
> +	sure the ip address is unique in the network.
> +
> +3. edit /etc/iscsi/iscsid.conf
> +   The default setting for MaxRecvDataSegmentLength (131072) is too big, search
> +   and replace all occurances of "xxx.iscsi.MaxRecvDataSegmentLength" to be a
> +   value no bigger than 15360 (for example 8192):
> +
> +	discovery.sendtargets.iscsi.MaxRecvDataSegmentLength = 8192
> +	node.conn[0].iscsi.MaxRecvDataSegmentLength = 8192
> +

What happens if you don't do this? it will then not use acceleration and fall back
to SW tcp? or it will not work at all? Can the driver limit that no matter what the user
put?

> +4. To direct open-iscsi traffic to go through cxgb3i's accelerated path,
> +   "-I <iface file name>" option needs to be specified with most of the
> +   iscsiadm command. <iface file name> is the transport interface file created
> +   in step 2.
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 403ecad..c91e840 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -352,6 +352,8 @@ config ISCSI_TCP
>  
>  	 http://open-iscsi.org
>  
> +source "drivers/scsi/cxgb3i/Kconfig"
> +
>  config SGIWD93_SCSI
>  	tristate "SGI WD93C93 SCSI Driver"
>  	depends on SGI_HAS_WD93 && SCSI
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index b89aedf..3ef7664 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -124,6 +124,7 @@ obj-$(CONFIG_SCSI_HPTIOP)	+= hptiop.o
>  obj-$(CONFIG_SCSI_STEX)		+= stex.o
>  obj-$(CONFIG_SCSI_MVSAS)	+= mvsas.o
>  obj-$(CONFIG_PS3_ROM)		+= ps3rom.o
> +obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+= libiscsi.o libiscsi_tcp.o cxgb3i/
>  
>  obj-$(CONFIG_ARM)		+= arm/
>  
> diff --git a/drivers/scsi/cxgb3i/Kconfig b/drivers/scsi/cxgb3i/Kconfig
> new file mode 100644
> index 0000000..f2a83ac
> --- /dev/null
> +++ b/drivers/scsi/cxgb3i/Kconfig
> @@ -0,0 +1,7 @@
> +config SCSI_CXGB3_ISCSI
> +	tristate "Chelsio S3xx iSCSI support"
> +	select CHELSIO_T3
> +	select SCSI_ISCSI_ATTRS
> +	select ISCSI_TCP

Looks like you don't need ISCSI_TCP since Mike's last changes. ISCSI_TCP will
give you iscsi_tcp.ko, but all you need is libiscsi_tcp.ko which will be enabled
by default. (I think)

> +	---help---
> +	This driver supports iSCSI offload for the Chelsio S3 series devices.
> diff --git a/drivers/scsi/cxgb3i/Makefile b/drivers/scsi/cxgb3i/Makefile

It's better to put this in a Kbuild file. It is not a real Makefile anyway.

> new file mode 100644
> index 0000000..ee7d6d2
> --- /dev/null
> +++ b/drivers/scsi/cxgb3i/Makefile
> @@ -0,0 +1,4 @@
> +EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/cxgb3
> +

+ccflags-y += -I$(TOPDIR)/drivers/net/cxgb3

Make Sam's life easier.

> +cxgb3i-y := cxgb3i_init.o cxgb3i_iscsi.o cxgb3i_pdu.o cxgb3i_offload.o
> +obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i_ddp.o cxgb3i.o
> diff --git a/drivers/scsi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgb3i/cxgb3i.h
> new file mode 100644
> index 0000000..5459e74
> --- /dev/null
> +++ b/drivers/scsi/cxgb3i/cxgb3i.h
> @@ -0,0 +1,138 @@
> +/*
> + * cxgb3i.h: Chelsio S3xx iSCSI driver.
> + *
> + * Copyright (c) 2008 Chelsio Communications, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + *
> + * Written by: Karen Xie (kxie@chelsio.com)
> + */
> +
> +#ifndef __CXGB3I_H__
> +#define __CXGB3I_H__
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/errno.h>
> +#include <linux/types.h>
> +#include <linux/list.h>
> +#include <linux/netdevice.h>
> +#include <linux/scatterlist.h>
> +#include <scsi/libiscsi_tcp.h>
> +
> +/* from cxgb3 LLD */
> +#include "common.h"
> +#include "t3_cpl.h"
> +#include "t3cdev.h"
> +#include "cxgb3_ctl_defs.h"
> +#include "cxgb3_offload.h"
> +#include "firmware_exports.h"
> +
> +#include "cxgb3i_offload.h"
> +#include "cxgb3i_ddp.h"
> +
> +#define CXGB3I_SCSI_QDEPTH_DFLT	128
> +#define CXGB3I_MAX_TARGET	CXGB3I_MAX_CONN
> +#define CXGB3I_MAX_LUN		512
> +#define ISCSI_PDU_HEADER_MAX	(56 + 256) /* bhs + digests + ahs */
> +

Actually sizeof(iscsi_sw_tcp_hdrbuf), which is ? I'm not sure a bit
less I think like 308. 
or:
+#define ISCSI_PDU_HEADER_MAX \
+	sizeof(struct iscsi_hdr) + ISCSI_MAX_AHS_SIZE + ISCSI_DIGEST_SIZE;

It looks like you reserve space for big Header but only use a much smaller
one. (Look in comments below)

> +struct cxgb3i_adapter;
> +struct cxgb3i_hba;
> +struct cxgb3i_endpoint;
> +
> +/**
> + * struct cxgb3i_hba - cxgb3i iscsi structure (per port)
> + *
> + * @snic:	cxgb3i adapter containing this port
> + * @ndev:	pointer to netdev structure
> + * @shost:	pointer to scsi host structure
> + */
> +struct cxgb3i_hba {
> +	struct cxgb3i_adapter *snic;
> +	struct net_device *ndev;
> +	struct Scsi_Host *shost;
> +};
> +
> +/**
> + * struct cxgb3i_adapter - cxgb3i adapter structure (per pci)
> + *
> + * @listhead:	list head to link elements
> + * @lock:	lock for this structure
> + * @tdev:	pointer to t3cdev used by cxgb3 driver
> + * @pdev:	pointer to pci dev
> + * @hba_cnt:	# of hbas (the same as # of ports)
> + * @hba:	all the hbas on this adapter
> + * @tx_max_size: max. tx packet size supported
> + * @rx_max_size: max. rx packet size supported
> + * @tag_format: ddp tag format settings
> + */
> +struct cxgb3i_adapter {
> +	struct list_head list_head;
> +	spinlock_t lock;
> +	struct t3cdev *tdev;
> +	struct pci_dev *pdev;
> +	unsigned char hba_cnt;
> +	struct cxgb3i_hba *hba[MAX_NPORTS];
> +
> +	unsigned int tx_max_size;
> +	unsigned int rx_max_size;
> +
> +	struct cxgb3i_tag_format tag_format;
> +};
> +
> +/**
> + * struct cxgb3i_conn - cxgb3i iscsi connection
> + *
> + * @listhead:	list head to link elements
> + * @cep:	pointer to iscsi_endpoint structure
> + * @conn:	pointer to iscsi_conn structure
> + * @hba:	pointer to the hba this conn. is going through
> + * @task_idx_bits: # of bits needed for session->cmds_max
> + */
> +struct cxgb3i_conn {
> +	struct list_head list_head;
> +	struct cxgb3i_endpoint *cep;
> +	struct iscsi_conn *conn;
> +	struct cxgb3i_hba *hba;
> +	unsigned int task_idx_bits;
> +};
> +
> +/**
> + * struct cxgb3i_endpoint - iscsi tcp endpoint
> + *
> + * @c3cn:	the h/w tcp connection representation
> + * @hba:	pointer to the hba this conn. is going through
> + * @cconn:	pointer to the associated cxgb3i iscsi connection
> + */
> +struct cxgb3i_endpoint {
> +	struct s3_conn *c3cn;
> +	struct cxgb3i_hba *hba;
> +	struct cxgb3i_conn *cconn;
> +};
> +
> +int cxgb3i_iscsi_init(void);
> +void cxgb3i_iscsi_cleanup(void);
> +
> +struct cxgb3i_adapter *cxgb3i_adapter_add(struct t3cdev *);
> +void cxgb3i_adapter_remove(struct t3cdev *);
> +int cxgb3i_adapter_ulp_init(struct cxgb3i_adapter *);
> +void cxgb3i_adapter_ulp_cleanup(struct cxgb3i_adapter *);
> +
> +struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *);
> +struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *,
> +				       struct net_device *);
> +void cxgb3i_hba_host_remove(struct cxgb3i_hba *);
> +
> +int cxgb3i_pdu_init(void);
> +void cxgb3i_pdu_cleanup(void);
> +void cxgb3i_conn_cleanup_task(struct iscsi_task *);
> +int cxgb3i_conn_alloc_pdu(struct iscsi_task *, u8);
> +int cxgb3i_conn_init_pdu(struct iscsi_task *, unsigned int, unsigned int);
> +int cxgb3i_conn_xmit_pdu(struct iscsi_task *);
> +
> +void cxgb3i_release_itt(struct iscsi_task *task, itt_t hdr_itt);
> +int cxgb3i_reserve_itt(struct iscsi_task *task, itt_t *hdr_itt);
> +
> +#endif
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
> new file mode 100644
> index 0000000..1a41f04
> --- /dev/null
> +++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
> @@ -0,0 +1,770 @@
> +/*
> + * cxgb3i_ddp.c: Chelsio S3xx iSCSI DDP Manager.
> + *
> + * Copyright (c) 2008 Chelsio Communications, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + *
> + * Written by: Karen Xie (kxie@chelsio.com)
> + */
> +
> +#include <linux/skbuff.h>
> +
> +/* from cxgb3 LLD */
> +#include "common.h"
> +#include "t3_cpl.h"
> +#include "t3cdev.h"
> +#include "cxgb3_ctl_defs.h"
> +#include "cxgb3_offload.h"
> +#include "firmware_exports.h"
> +
> +#include "cxgb3i_ddp.h"
> +
> +#define DRV_MODULE_NAME         "cxgb3i_ddp"
> +#define DRV_MODULE_VERSION      "1.0.0"
> +#define DRV_MODULE_RELDATE      "Dec. 1, 2008"
> +
> +static char version[] =
> +	"Chelsio S3xx iSCSI DDP " DRV_MODULE_NAME
> +	" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
> +
> +MODULE_AUTHOR("Karen Xie <kxie@chelsio.com>");
> +MODULE_DESCRIPTION("cxgb3i ddp pagepod manager");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(DRV_MODULE_VERSION);
> +
> +#define ddp_log_error(fmt...) printk(KERN_ERR "cxgb3i_ddp: ERR! " fmt)
> +#define ddp_log_warn(fmt...)  printk(KERN_WARNING "cxgb3i_ddp: WARN! " fmt)
> +#define ddp_log_info(fmt...)  printk(KERN_INFO "cxgb3i_ddp: " fmt)
> +
> +#ifdef __DEBUG_CXGB3I_DDP__
> +#define ddp_log_debug(fmt, args...) \
> +	printk(KERN_INFO "cxgb3i_ddp: %s - " fmt, __func__ , ## args)
> +#else
> +#define ddp_log_debug(fmt...)
> +#endif
> +
> +/*
> + * iSCSI Direct Data Placement
> + *
> + * T3 h/w can directly place the iSCSI Data-In or Data-Out PDU's payload into
> + * pre-posted final destination host-memory buffers based on the Initiator
> + * Task Tag (ITT) in Data-In or Target Task Tag (TTT) in Data-Out PDUs.
> + *
> + * The host memory address is programmed into h/w in the format of pagepod
> + * entries.
> + * The location of the pagepod entry is encoded into ddp tag which is used or
> + * is the base for ITT/TTT.
> + */
> +
> +#define DDP_PGIDX_MAX		4
> +#define DDP_THRESHOLD	2048
> +static unsigned char ddp_page_order[DDP_PGIDX_MAX] = {0, 1, 2, 4};
> +static unsigned char ddp_page_shift[DDP_PGIDX_MAX] = {12, 13, 14, 16};
> +static unsigned char page_idx = DDP_PGIDX_MAX;
> +
> +static LIST_HEAD(cxgb3i_ddp_list);
> +static DEFINE_RWLOCK(cxgb3i_ddp_rwlock);
> +
> +/*
> + * functions to program the pagepod in h/w
> + */
> +static inline void ulp_mem_io_set_hdr(struct sk_buff *skb, unsigned int addr)
> +{
> +	struct ulp_mem_io *req = (struct ulp_mem_io *)skb->head;
> +
> +	req->wr.wr_lo = 0;
> +	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_BYPASS));
> +	req->cmd_lock_addr = htonl(V_ULP_MEMIO_ADDR(addr >> 5) |
> +				   V_ULPTX_CMD(ULP_MEM_WRITE));
> +	req->len = htonl(V_ULP_MEMIO_DATA_LEN(PPOD_SIZE >> 5) |
> +			 V_ULPTX_NFLITS((PPOD_SIZE >> 3) + 1));
> +}
> +
> +static int set_ddp_map(struct cxgb3i_ddp_info *ddp, struct pagepod_hdr *hdr,
> +		       unsigned int idx, unsigned int npods,
> +		       struct cxgb3i_gather_list *gl)
> +{
> +	unsigned int pm_addr = (idx << PPOD_SIZE_SHIFT) + ddp->llimit;
> +	int i;
> +
> +	for (i = 0; i < npods; i++, idx++, pm_addr += PPOD_SIZE) {
> +		struct sk_buff *skb = ddp->gl_skb[idx];
> +		struct pagepod *ppod;
> +		int j, pidx;
> +
> +		/* hold on to the skb until we clear the ddp mapping */
> +		skb_get(skb);
> +
> +		ulp_mem_io_set_hdr(skb, pm_addr);
> +		ppod = (struct pagepod *)
> +		       (skb->head + sizeof(struct ulp_mem_io));
> +		memcpy(&(ppod->hdr), hdr, sizeof(struct pagepod));
> +		for (pidx = 4 * i, j = 0; j < 5; ++j, ++pidx)
> +			ppod->addr[j] = pidx < gl->nelem ?
> +				     cpu_to_be64(gl->phys_addr[pidx]) : 0UL;
> +
> +		skb->priority = CPL_PRIORITY_CONTROL;
> +		cxgb3_ofld_send(ddp->tdev, skb);
> +	}
> +	return 0;
> +}
> +
> +static int clear_ddp_map(struct cxgb3i_ddp_info *ddp, unsigned int idx,
> +			 unsigned int npods)
> +{
> +	unsigned int pm_addr = (idx << PPOD_SIZE_SHIFT) + ddp->llimit;
> +	int i;
> +
> +	for (i = 0; i < npods; i++, idx++, pm_addr += PPOD_SIZE) {
> +		struct sk_buff *skb = ddp->gl_skb[idx];
> +
> +		ddp->gl_skb[idx] = NULL;
> +		memset((skb->head + sizeof(struct ulp_mem_io)), 0, PPOD_SIZE);
> +		ulp_mem_io_set_hdr(skb, pm_addr);
> +		skb->priority = CPL_PRIORITY_CONTROL;
> +		cxgb3_ofld_send(ddp->tdev, skb);
> +	}
> +	return 0;
> +}
> +
> +static inline int ddp_find_unused_entries(struct cxgb3i_ddp_info *ddp,
> +					  int start, int max, int count,
> +					  struct cxgb3i_gather_list *gl)
> +{
> +	unsigned int i, j;
> +
> +	spin_lock(&ddp->map_lock);
> +	for (i = start; i <= max;) {
> +		for (j = 0; j < count; j++) {
> +			if (ddp->gl_map[i + j])
> +				break;
> +		}
> +		if (j == count) {
> +			for (j = 0; j < count; j++)
> +				ddp->gl_map[i + j] = gl;
> +			spin_unlock(&ddp->map_lock);
> +			return i;
> +		}
> +		i += j + 1;
> +	}
> +	spin_unlock(&ddp->map_lock);
> +	return -EBUSY;
> +}
> +
> +static inline void ddp_unmark_entries(struct cxgb3i_ddp_info *ddp,
> +				      int start, int count)
> +{
> +	spin_lock(&ddp->map_lock);
> +	memset(&ddp->gl_map[start], 0,
> +	       count * sizeof(struct cxgb3i_gather_list *));
> +	spin_unlock(&ddp->map_lock);
> +}
> +
> +static inline void ddp_free_gl_skb(struct cxgb3i_ddp_info *ddp,
> +				   int idx, int count)
> +{
> +	int i;
> +
> +	for (i = 0; i < count; i++, idx++)
> +		if (ddp->gl_skb[idx]) {
> +			kfree_skb(ddp->gl_skb[idx]);
> +			ddp->gl_skb[idx] = NULL;
> +		}
> +}
> +
> +static inline int ddp_alloc_gl_skb(struct cxgb3i_ddp_info *ddp, int idx,
> +				   int count, gfp_t gfp)
> +{
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		struct sk_buff *skb = alloc_skb(sizeof(struct ulp_mem_io) +
> +						PPOD_SIZE, gfp);
> +		if (skb) {
> +			ddp->gl_skb[idx + i] = skb;
> +			skb_put(skb, sizeof(struct ulp_mem_io) + PPOD_SIZE);
> +		} else {
> +			ddp_free_gl_skb(ddp, idx, i);
> +			return -ENOMEM;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/**
> + * cxgb3i_ddp_find_page_index - return ddp page index for a given page size.
> + * @pgsz: page size
> + * return the ddp page index, if no match is found return DDP_PGIDX_MAX.
> + */
> +int cxgb3i_ddp_find_page_index(unsigned long pgsz)
> +{
> +	int i;
> +
> +	for (i = 0; i < DDP_PGIDX_MAX; i++) {
> +		if (pgsz == (1UL << ddp_page_shift[i]))
> +			return i;
> +	}
> +	ddp_log_debug("ddp page size 0x%lx not supported.\n", pgsz);
> +	return DDP_PGIDX_MAX;
> +}
> +EXPORT_SYMBOL_GPL(cxgb3i_ddp_find_page_index);
> +
> +static inline void ddp_gl_unmap(struct pci_dev *pdev,
> +				struct cxgb3i_gather_list *gl)
> +{
> +	int i;
> +
> +	for (i = 0; i < gl->nelem; i++)
> +		pci_unmap_page(pdev, gl->phys_addr[i], PAGE_SIZE,
> +			       PCI_DMA_FROMDEVICE);
> +}
> +
> +static inline int ddp_gl_map(struct pci_dev *pdev,
> +			     struct cxgb3i_gather_list *gl)
> +{
> +	int i;
> +
> +	for (i = 0; i < gl->nelem; i++) {
> +		gl->phys_addr[i] = pci_map_page(pdev, gl->pages[i], 0,
> +						PAGE_SIZE,
> +						PCI_DMA_FROMDEVICE);
> +		if (unlikely(pci_dma_mapping_error(pdev, gl->phys_addr[i])))
> +			goto unmap;
> +	}
> +
> +	return i;
> +
> +unmap:
> +	if (i) {
> +		unsigned int nelem = gl->nelem;
> +
> +		gl->nelem = i;
> +		ddp_gl_unmap(pdev, gl);
> +		gl->nelem = nelem;
> +	}
> +	return -ENOMEM;
> +}
> +
> +/**
> + * cxgb3i_ddp_make_gl - build ddp page buffer list
> + * @xferlen: total buffer length
> + * @sgl: page buffer scatter-gather list
> + * @sgcnt: # of page buffers
> + * @pdev: pci_dev, used for pci map
> + * @gfp: allocation mode
> + *
> + * construct a ddp page buffer list from the scsi scattergather list.
> + * coalesce buffers as much as possible, and obtain dma addresses for
> + * each page.
> + *
> + * Return the cxgb3i_gather_list constructed from the page buffers if the
> + * memory can be used for ddp. Return NULL otherwise.
> + */
> +struct cxgb3i_gather_list *cxgb3i_ddp_make_gl(unsigned int xferlen,
> +					      struct scatterlist *sgl,
> +					      unsigned int sgcnt,
> +					      struct pci_dev *pdev,
> +					      gfp_t gfp)
> +{
> +	struct cxgb3i_gather_list *gl;
> +	struct scatterlist *sg = sgl;
> +	struct page *sgpage = sg_page(sg);
> +	unsigned int sglen = sg->length;
> +	unsigned int sgoffset = sg->offset;
> +	unsigned int npages = (xferlen + sgoffset + PAGE_SIZE - 1) >>
> +			      PAGE_SHIFT;
> +	int i = 1, j = 0;
> +
> +	if (xferlen < DDP_THRESHOLD) {
> +		ddp_log_debug("xfer %u < threshold %u, no ddp.\n",
> +			      xferlen, DDP_THRESHOLD);
> +		return NULL;
> +	}
> +
> +	gl = kzalloc(sizeof(struct cxgb3i_gather_list) +
> +		     npages * (sizeof(dma_addr_t) + sizeof(struct page *)),
> +		     gfp);
> +	if (!gl)
> +		return NULL;
> +
> +	gl->pages = (struct page **)&gl->phys_addr[npages];
> +	gl->length = xferlen;
> +	gl->offset = sgoffset;
> +	gl->pages[0] = sgpage;
> +
> +	sg = sg_next(sg);
> +	while (sg) {
> +		struct page *page = sg_page(sg);
> +
> +		if (sgpage == page && sg->offset == sgoffset + sglen)
> +			sglen += sg->length;
> +		else {
> +			/* make sure the sgl is fit for ddp:
> +			 * each has the same page size, and
> +			 * all of the middle pages are used completely
> +			 */
> +			if ((j && sgoffset) ||
> +			    ((i != sgcnt - 1) &&
> +			     ((sglen + sgoffset) & ~PAGE_MASK)))
> +				goto error_out;
> +
> +			j++;
> +			if (j == gl->nelem || sg->offset)
> +				goto error_out;
> +			gl->pages[j] = page;
> +			sglen = sg->length;
> +			sgoffset = sg->offset;
> +			sgpage = page;
> +		}
> +		i++;
> +		sg = sg_next(sg);
> +	}
> +	gl->nelem = ++j;
> +
> +	if (ddp_gl_map(pdev, gl) < 0)
> +		goto error_out;
> +
> +	return gl;
> +
> +error_out:
> +	kfree(gl);
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(cxgb3i_ddp_make_gl);
> +
> +/**
> + * cxgb3i_ddp_release_gl - release a page buffer list
> + * @gl: a ddp page buffer list
> + * @pdev: pci_dev used for pci_unmap
> + * free a ddp page buffer list resulted from cxgb3i_ddp_make_gl().
> + */
> +void cxgb3i_ddp_release_gl(struct cxgb3i_gather_list *gl,
> +			   struct pci_dev *pdev)
> +{
> +	ddp_gl_unmap(pdev, gl);
> +	kfree(gl);
> +}
> +EXPORT_SYMBOL_GPL(cxgb3i_ddp_release_gl);
> +
> +/**
> + * cxgb3i_ddp_tag_reserve - set up ddp for a data transfer
> + * @tdev: t3cdev adapter
> + * @tid: connection id
> + * @tformat: tag format
> + * @tagp: the s/w tag, if ddp setup is successful, it will be updated with
> + *	  ddp/hw tag
> + * @gl: the page momory list
> + * @gfp: allocation mode
> + *
> + * ddp setup for a given page buffer list and construct the ddp tag.
> + * return 0 if success, < 0 otherwise.
> + */
> +int cxgb3i_ddp_tag_reserve(struct t3cdev *tdev, unsigned int tid,
> +			   struct cxgb3i_tag_format *tformat, u32 *tagp,
> +			   struct cxgb3i_gather_list *gl, gfp_t gfp)
> +{
> +	struct cxgb3i_ddp_info *ddp = tdev->ulp_iscsi;
> +	struct pagepod_hdr hdr;
> +	unsigned int npods;
> +	int idx = -1, idx_max;
> +	int err = -ENOMEM;
> +	u32 sw_tag = *tagp;
> +	u32 tag;
> +
> +	if (page_idx >= DDP_PGIDX_MAX || !ddp || !gl || !gl->nelem ||
> +		gl->length < DDP_THRESHOLD) {
> +		ddp_log_debug("pgidx %u, xfer %u/%u, NO ddp.\n",
> +			      page_idx, gl->length, DDP_THRESHOLD);
> +		return -EINVAL;
> +	}
> +
> +	npods = (gl->nelem + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
> +	idx_max = ddp->nppods - npods + 1;
> +
> +	if (ddp->idx_last == ddp->nppods)
> +		idx = ddp_find_unused_entries(ddp, 0, idx_max, npods, gl);
> +	else {
> +		idx = ddp_find_unused_entries(ddp, ddp->idx_last + 1,
> +					      idx_max, npods, gl);
> +		if (idx < 0 && ddp->idx_last >= npods)
> +			idx = ddp_find_unused_entries(ddp, 0,
> +						      ddp->idx_last - npods + 1,
> +						      npods, gl);
> +	}
> +	if (idx < 0) {
> +		ddp_log_debug("xferlen %u, gl %u, npods %u NO DDP.\n",
> +			      gl->length, gl->nelem, npods);
> +		return idx;
> +	}
> +
> +	err = ddp_alloc_gl_skb(ddp, idx, npods, gfp);
> +	if (err < 0)
> +		goto unmark_entries;
> +
> +	tag = cxgb3i_ddp_tag_base(tformat, sw_tag);
> +	tag |= idx << PPOD_IDX_SHIFT;
> +
> +	hdr.rsvd = 0;
> +	hdr.vld_tid = htonl(F_PPOD_VALID | V_PPOD_TID(tid));
> +	hdr.pgsz_tag_clr = htonl(tag & ddp->rsvd_tag_mask);
> +	hdr.maxoffset = htonl(gl->length);
> +	hdr.pgoffset = htonl(gl->offset);
> +
> +	err = set_ddp_map(ddp, &hdr, idx, npods, gl);
> +	if (err < 0)
> +		goto free_gl_skb;
> +
> +	ddp->idx_last = idx;
> +	ddp_log_debug("xfer %u, gl %u,%u, tid 0x%x, 0x%x -> 0x%x(%u,%u).\n",
> +		      gl->length, gl->nelem, gl->offset, tid, sw_tag, tag,
> +		      idx, npods);
> +	*tagp = tag;
> +	return 0;
> +
> +free_gl_skb:
> +	ddp_free_gl_skb(ddp, idx, npods);
> +unmark_entries:
> +	ddp_unmark_entries(ddp, idx, npods);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(cxgb3i_ddp_tag_reserve);
> +
> +/**
> + * cxgb3i_ddp_tag_release - release a ddp tag
> + * @tdev: t3cdev adapter
> + * @tag: ddp tag
> + * ddp cleanup for a given ddp tag and release all the resources held
> + */
> +void cxgb3i_ddp_tag_release(struct t3cdev *tdev, u32 tag)
> +{
> +	struct cxgb3i_ddp_info *ddp = tdev->ulp_iscsi;
> +	u32 idx;
> +
> +	if (!ddp) {
> +		ddp_log_error("release ddp tag 0x%x, ddp NULL.\n", tag);
> +		return;
> +	}
> +
> +	idx = (tag >> PPOD_IDX_SHIFT) & ddp->idx_mask;
> +	if (idx < ddp->nppods) {
> +		struct cxgb3i_gather_list *gl = ddp->gl_map[idx];
> +		unsigned int npods;
> +
> +		if (!gl) {
> +			ddp_log_error("release ddp 0x%x, idx 0x%x, gl NULL.\n",
> +				      tag, idx);
> +			return;
> +		}
> +		npods = (gl->nelem + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
> +		ddp_log_debug("ddp tag 0x%x, release idx 0x%x, npods %u.\n",
> +			      tag, idx, npods);
> +		clear_ddp_map(ddp, idx, npods);
> +		ddp_unmark_entries(ddp, idx, npods);
> +		cxgb3i_ddp_release_gl(gl, ddp->pdev);
> +	} else
> +		ddp_log_error("ddp tag 0x%x, idx 0x%x > max 0x%x.\n",
> +			      tag, idx, ddp->nppods);
> +}
> +EXPORT_SYMBOL_GPL(cxgb3i_ddp_tag_release);
> +
> +static int setup_conn_pgidx(struct t3cdev *tdev, unsigned int tid, int pg_idx,
> +			    int reply)
> +{
> +	struct sk_buff *skb = alloc_skb(sizeof(struct cpl_set_tcb_field),
> +					GFP_KERNEL);
> +	struct cpl_set_tcb_field *req;
> +	u64 val = pg_idx < DDP_PGIDX_MAX ? pg_idx : 0;
> +
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	/* set up ulp submode and page size */
> +	req = (struct cpl_set_tcb_field *)skb_put(skb, sizeof(*req));
> +	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
> +	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, tid));
> +	req->reply = V_NO_REPLY(reply ? 0 : 1);
> +	req->cpu_idx = 0;
> +	req->word = htons(31);
> +	req->mask = cpu_to_be64(0xF0000000);
> +	req->val = cpu_to_be64(val << 28);
> +	skb->priority = CPL_PRIORITY_CONTROL;
> +
> +	cxgb3_ofld_send(tdev, skb);
> +	return 0;
> +}
> +
> +/**
> + * cxgb3i_setup_conn_host_pagesize - setup the conn.'s ddp page size
> + * @tdev: t3cdev adapter
> + * @tid: connection id
> + * @reply: request reply from h/w
> + * set up the ddp page size based on the host PAGE_SIZE for a connection
> + * identified by tid
> + */
> +int cxgb3i_setup_conn_host_pagesize(struct t3cdev *tdev, unsigned int tid,
> +				    int reply)
> +{
> +	return setup_conn_pgidx(tdev, tid, page_idx, reply);
> +}
> +EXPORT_SYMBOL_GPL(cxgb3i_setup_conn_host_pagesize);
> +
> +/**
> + * cxgb3i_setup_conn_pagesize - setup the conn.'s ddp page size
> + * @tdev: t3cdev adapter
> + * @tid: connection id
> + * @reply: request reply from h/w
> + * @pgsz: ddp page size
> + * set up the ddp page size for a connection identified by tid
> + */
> +int cxgb3i_setup_conn_pagesize(struct t3cdev *tdev, unsigned int tid,
> +				int reply, unsigned long pgsz)
> +{
> +	int pgidx = cxgb3i_ddp_find_page_index(pgsz);
> +
> +	return setup_conn_pgidx(tdev, tid, pgidx, reply);
> +}
> +EXPORT_SYMBOL_GPL(cxgb3i_setup_conn_pagesize);
> +
> +/**
> + * cxgb3i_setup_conn_digest - setup conn. digest setting
> + * @tdev: t3cdev adapter
> + * @tid: connection id
> + * @hcrc: header digest enabled
> + * @dcrc: data digest enabled
> + * @reply: request reply from h/w
> + * set up the iscsi digest settings for a connection identified by tid
> + */
> +int cxgb3i_setup_conn_digest(struct t3cdev *tdev, unsigned int tid,
> +			     int hcrc, int dcrc, int reply)
> +{
> +	struct sk_buff *skb = alloc_skb(sizeof(struct cpl_set_tcb_field),
> +					GFP_KERNEL);
> +	struct cpl_set_tcb_field *req;
> +	u64 val = (hcrc ? 1 : 0) | (dcrc ? 2 : 0);
> +
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	/* set up ulp submode and page size */
> +	req = (struct cpl_set_tcb_field *)skb_put(skb, sizeof(*req));
> +	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
> +	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SET_TCB_FIELD, tid));
> +	req->reply = V_NO_REPLY(reply ? 0 : 1);
> +	req->cpu_idx = 0;
> +	req->word = htons(31);
> +	req->mask = cpu_to_be64(0x0F000000);
> +	req->val = cpu_to_be64(val << 24);
> +	skb->priority = CPL_PRIORITY_CONTROL;
> +
> +	cxgb3_ofld_send(tdev, skb);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(cxgb3i_setup_conn_digest);
> +
> +static int ddp_init(struct t3cdev *tdev)
> +{
> +	struct cxgb3i_ddp_info *ddp;
> +	struct ulp_iscsi_info uinfo;
> +	unsigned int ppmax, bits;
> +	int i, err;
> +	static int vers_printed;
> +
> +	if (!vers_printed) {
> +		printk(KERN_INFO "%s", version);
> +		vers_printed = 1;
> +	}
> +
> +	err = tdev->ctl(tdev, ULP_ISCSI_GET_PARAMS, &uinfo);
> +	if (err < 0) {
> +		ddp_log_error("%s, failed to get iscsi param err=%d.\n",
> +				 tdev->name, err);
> +		return err;
> +	}
> +
> +	ppmax = (uinfo.ulimit - uinfo.llimit + 1) >> PPOD_SIZE_SHIFT;
> +	bits = __ilog2_u32(ppmax) + 1;
> +	if (bits > PPOD_IDX_MAX_SIZE)
> +		bits = PPOD_IDX_MAX_SIZE;
> +	ppmax = (1 << (bits - 1)) - 1;
> +
> +	ddp = cxgb3i_alloc_big_mem(sizeof(struct cxgb3i_ddp_info) +
> +				   ppmax *
> +					(sizeof(struct cxgb3i_gather_list *) +
> +					sizeof(struct sk_buff *)),
> +				   GFP_KERNEL);

>From what I understand so far:
DDP is only used for read of PDU, right? so we only need space for the read DDP.
the writes are made by regular SKBs right?

How is then the acceleration works with out-going data? OK I guess that is a separate
issue. DDP acceleration for reads, and separately, digest accelerations for both.

> +	if (!ddp) {
> +		ddp_log_warn("%s unable to alloc ddp 0x%d, ddp disabled.\n",
> +			     tdev->name, ppmax);
> +		return 0;
> +	}
> +	ddp->gl_map = (struct cxgb3i_gather_list **)(ddp + 1);
> +	ddp->gl_skb = (struct sk_buff **)(((char *)ddp->gl_map) +
> +					  ppmax *
> +					  sizeof(struct cxgb3i_gather_list *));
> +	spin_lock_init(&ddp->map_lock);
> +
> +	ddp->tdev = tdev;
> +	ddp->pdev = uinfo.pdev;
> +	ddp->max_txsz = min_t(unsigned int, uinfo.max_txsz, ULP2_MAX_PKT_SIZE);
> +	ddp->max_rxsz = min_t(unsigned int, uinfo.max_rxsz, ULP2_MAX_PKT_SIZE);

Please note that from what I understand, only the out-going headers can be
big, like iscsi_cmd header. But the in-coming headers are always size_of(struct iscsi_hdr).
So there is no symmetry here. Actually only iscsi_cmd can get big, the other out-going 
data packets are with small headers, but I guess that is an open-iscsi limitation.

Mike correct me if I'm wrong?

> +	ddp->llimit = uinfo.llimit;
> +	ddp->ulimit = uinfo.ulimit;
> +	ddp->nppods = ppmax;
> +	ddp->idx_last = ppmax;
> +	ddp->idx_bits = bits;
> +	ddp->idx_mask = (1 << bits) - 1;
> +	ddp->rsvd_tag_mask = (1 << (bits + PPOD_IDX_SHIFT)) - 1;
> +
> +	uinfo.tagmask = ddp->idx_mask << PPOD_IDX_SHIFT;
> +	for (i = 0; i < DDP_PGIDX_MAX; i++)
> +		uinfo.pgsz_factor[i] = ddp_page_order[i];
> +	uinfo.ulimit = uinfo.llimit + (ppmax << PPOD_SIZE_SHIFT);
> +
> +	err = tdev->ctl(tdev, ULP_ISCSI_SET_PARAMS, &uinfo);
> +	if (err < 0) {
> +		ddp_log_warn("%s unable to set iscsi param err=%d, "
> +			      "ddp disabled.\n", tdev->name, err);
> +		goto free_ddp_map;
> +	}
> +
> +	tdev->ulp_iscsi = ddp;
> +
> +	/* add to the list */
> +	write_lock(&cxgb3i_ddp_rwlock);
> +	list_add_tail(&ddp->list, &cxgb3i_ddp_list);
> +	write_unlock(&cxgb3i_ddp_rwlock);
> +
> +	ddp_log_info("nppods %u (0x%x ~ 0x%x), bits %u, mask 0x%x,0x%x "
> +			"pkt %u,%u.\n",
> +			ppmax, ddp->llimit, ddp->ulimit, ddp->idx_bits,
> +			ddp->idx_mask, ddp->rsvd_tag_mask,
> +			ddp->max_txsz, ddp->max_rxsz);
> +	return 0;
> +
> +free_ddp_map:
> +	cxgb3i_free_big_mem(ddp);
> +	return err;
> +}
> +
> +/**
> + * cxgb3i_adapter_ddp_init - initialize the adapter's ddp resource
> + * @tdev: t3cdev adapter
> + * @tformat: tag format
> + * @txsz: max tx pkt size, filled in by this func.
> + * @rxsz: max rx pkt size, filled in by this func.
> + * initialize the ddp pagepod manager for a given adapter if needed and
> + * setup the tag format for a given iscsi entity
> + */
> +int cxgb3i_adapter_ddp_init(struct t3cdev *tdev,
> +			    struct cxgb3i_tag_format *tformat,
> +			    unsigned int *txsz, unsigned int *rxsz)
> +{
> +	struct cxgb3i_ddp_info *ddp;
> +	unsigned char idx_bits;
> +
> +	if (!tformat)
> +		return -EINVAL;
> +
> +	if (!tdev->ulp_iscsi) {
> +		int err = ddp_init(tdev);
> +		if (err < 0)
> +			return err;
> +	}
> +	ddp = (struct cxgb3i_ddp_info *)tdev->ulp_iscsi;
> +
> +	idx_bits = 32 - tformat->sw_bits;
> +	tformat->rsvd_bits = ddp->idx_bits;
> +	tformat->rsvd_shift = PPOD_IDX_SHIFT;
> +	tformat->rsvd_mask = (1 << tformat->rsvd_bits) - 1;
> +
> +	ddp_log_info("tag format: sw %u, rsvd %u,%u, mask 0x%x.\n",
> +		      tformat->sw_bits, tformat->rsvd_bits,
> +		      tformat->rsvd_shift, tformat->rsvd_mask);
> +
> +	*txsz = ddp->max_txsz;
> +	*rxsz = ddp->max_rxsz;
> +	ddp_log_info("ddp max pkt size: %u, %u.\n",
> +		     ddp->max_txsz, ddp->max_rxsz);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(cxgb3i_adapter_ddp_init);
> +
> +static void ddp_release(struct cxgb3i_ddp_info *ddp)
> +{
> +	int i = 0;
> +	struct t3cdev *tdev = ddp->tdev;
> +
> +	tdev->ulp_iscsi = NULL;
> +	while (i < ddp->nppods) {
> +		struct cxgb3i_gather_list *gl = ddp->gl_map[i];
> +		if (gl) {
> +			int npods = (gl->nelem + PPOD_PAGES_MAX - 1)
> +				     >> PPOD_PAGES_SHIFT;
> +
> +			kfree(gl);
> +			ddp_free_gl_skb(ddp, i, npods);
> +		} else
> +			i++;
> +	}
> +	cxgb3i_free_big_mem(ddp);
> +}
> +
> +/**
> + * cxgb3i_adapter_ddp_cleanup - release the adapter's ddp resource
> + * @tdev: t3cdev adapter
> + * release all the resource held by the ddp pagepod manager for a given
> + * adapter if needed
> + */
> +void cxgb3i_adapter_ddp_cleanup(struct t3cdev *tdev)
> +{
> +	struct cxgb3i_ddp_info *ddp;
> +
> +	/* remove from the list */
> +	write_lock(&cxgb3i_ddp_rwlock);
> +	list_for_each_entry(ddp, &cxgb3i_ddp_list, list) {
> +		if (ddp->tdev == tdev) {
> +			list_del(&ddp->list);
> +			break;
> +		}
> +	}
> +	write_unlock(&cxgb3i_ddp_rwlock);
> +
> +	if (ddp)
> +		ddp_release(ddp);
> +}
> +EXPORT_SYMBOL_GPL(cxgb3i_adapter_ddp_cleanup);
> +
> +/**
> + * cxgb3i_ddp_init_module - module init entry point
> + * initialize any driver wide global data structures
> + */
> +static int __init cxgb3i_ddp_init_module(void)
> +{
> +	page_idx = cxgb3i_ddp_find_page_index(PAGE_SIZE);
> +	ddp_log_info("system PAGE_SIZE %lu, ddp idx %u.\n",
> +		     PAGE_SIZE, page_idx);
> +	return 0;
> +}
> +
> +/**
> + * cxgb3i_ddp_exit_module - module cleanup/exit entry point
> + * go through the ddp list and release any resource held.
> + */
> +static void __exit cxgb3i_ddp_exit_module(void)
> +{
> +	struct cxgb3i_ddp_info *ddp;
> +
> +	/* release all ddp manager if there is any */
> +	write_lock(&cxgb3i_ddp_rwlock);
> +	list_for_each_entry(ddp, &cxgb3i_ddp_list, list) {
> +		list_del(&ddp->list);
> +		ddp_release(ddp);
> +	}
> +	write_unlock(&cxgb3i_ddp_rwlock);
> +}
> +
> +module_init(cxgb3i_ddp_init_module);
> +module_exit(cxgb3i_ddp_exit_module);
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.h b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
> new file mode 100644
> index 0000000..1621dd0
> --- /dev/null
> +++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
> @@ -0,0 +1,306 @@
> +/*
> + * cxgb3i_ddp.h: Chelsio S3xx iSCSI DDP Manager.
> + *
> + * Copyright (c) 2008 Chelsio Communications, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + *
> + * Written by: Karen Xie (kxie@chelsio.com)
> + */
> +
> +#ifndef __CXGB3I_ULP2_DDP_H__
> +#define __CXGB3I_ULP2_DDP_H__
> +
> +/**
> + * struct cxgb3i_tag_format - cxgb3i ulp tag format for an iscsi entity
> + *
> + * @sw_bits:	# of bits used by iscsi software layer
> + * @rsvd_bits:	# of bits used by h/w
> + * @rsvd_shift:	h/w bits shift left
> + * @rsvd_mask:	reserved bit mask
> + */
> +struct cxgb3i_tag_format {
> +	unsigned char sw_bits;
> +	unsigned char rsvd_bits;
> +	unsigned char rsvd_shift;
> +	unsigned char filler[1];
> +	u32 rsvd_mask;
> +};
> +
> +/**
> + * struct cxgb3i_gather_list - cxgb3i direct data placement memory
> + *
> + * @tag:	ddp tag
> + * @length:	total data buffer length
> + * @offset:	initial offset to the 1st page
> + * @nelem:	# of pages
> + * @pages:	page pointers
> + * @phys_addr:	physical address
> + */
> +struct cxgb3i_gather_list {
> +	u32 tag;
> +	unsigned int length;
> +	unsigned int offset;
> +	unsigned int nelem;
> +	struct page **pages;
> +	dma_addr_t phys_addr[0];
> +};
> +
> +/**
> + * struct cxgb3i_ddp_info - cxgb3i direct data placement for pdu payload
> + *
> + * @list:	list head to link elements
> + * @tdev:	pointer to t3cdev used by cxgb3 driver
> + * @max_txsz:	max tx packet size for ddp
> + * @max_rxsz:	max rx packet size for ddp
> + * @llimit:	lower bound of the page pod memory
> + * @ulimit:	upper bound of the page pod memory
> + * @nppods:	# of page pod entries
> + * @idx_last:	page pod entry last used
> + * @idx_bits:	# of bits the pagepod index would take
> + * @idx_mask:	pagepod index mask
> + * @rsvd_tag_mask: tag mask
> + * @map_lock:	lock to synchonize access to the page pod map
> + * @gl_map:	ddp memory gather list
> + * @gl_skb:	skb used to program the pagepod
> + */
> +struct cxgb3i_ddp_info {
> +	struct list_head list;
> +	struct t3cdev *tdev;
> +	struct pci_dev *pdev;
> +	unsigned int max_txsz;
> +	unsigned int max_rxsz;
> +	unsigned int llimit;
> +	unsigned int ulimit;
> +	unsigned int nppods;
> +	unsigned int idx_last;
> +	unsigned char idx_bits;
> +	unsigned char filler[3];
> +	u32 idx_mask;
> +	u32 rsvd_tag_mask;
> +	spinlock_t map_lock;
> +	struct cxgb3i_gather_list **gl_map;
> +	struct sk_buff **gl_skb;
> +};
> +
> +#define ULP2_MAX_PKT_SIZE	16224
> +#define ULP2_MAX_PDU_SIZE	(ULP2_MAX_PKT_SIZE - ISCSI_PDU_HEADER_MAX)

Here it looks like you reserve space for a large command header. But only use
a small header in code. (see other comments)

> +#define PPOD_PAGES_MAX		4
> +#define PPOD_PAGES_SHIFT	2	/* 4 pages per pod */
> +
> +/*
> + * struct pagepod_hdr, pagepod - pagepod format
> + */
> +struct pagepod_hdr {
> +	u32 vld_tid;
> +	u32 pgsz_tag_clr;
> +	u32 maxoffset;
> +	u32 pgoffset;
> +	u64 rsvd;
> +};
> +
> +struct pagepod {
> +	struct pagepod_hdr hdr;
> +	u64 addr[PPOD_PAGES_MAX + 1];
> +};
> +
> +#define PPOD_SIZE		sizeof(struct pagepod)	/* 64 */
> +#define PPOD_SIZE_SHIFT		6
> +
> +#define PPOD_COLOR_SHIFT	0
> +#define PPOD_COLOR_SIZE		6
> +#define PPOD_COLOR_MASK		((1 << PPOD_COLOR_SIZE) - 1)
> +
> +#define PPOD_IDX_SHIFT		PPOD_COLOR_SIZE
> +#define PPOD_IDX_MAX_SIZE	24
> +
> +#define S_PPOD_TID    0
> +#define M_PPOD_TID    0xFFFFFF
> +#define V_PPOD_TID(x) ((x) << S_PPOD_TID)
> +
> +#define S_PPOD_VALID    24
> +#define V_PPOD_VALID(x) ((x) << S_PPOD_VALID)
> +#define F_PPOD_VALID    V_PPOD_VALID(1U)
> +
> +#define S_PPOD_COLOR    0
> +#define M_PPOD_COLOR    0x3F
> +#define V_PPOD_COLOR(x) ((x) << S_PPOD_COLOR)
> +
> +#define S_PPOD_TAG    6
> +#define M_PPOD_TAG    0xFFFFFF
> +#define V_PPOD_TAG(x) ((x) << S_PPOD_TAG)
> +
> +#define S_PPOD_PGSZ    30
> +#define M_PPOD_PGSZ    0x3
> +#define V_PPOD_PGSZ(x) ((x) << S_PPOD_PGSZ)
> +
> +/*
> + * large memory chunk allocation/release
> + * use vmalloc() if kmalloc() fails
> + */
> +static inline void *cxgb3i_alloc_big_mem(unsigned int size,
> +					 gfp_t gfp)
> +{
> +	void *p = kmalloc(size, gfp);
> +	if (!p)
> +		p = vmalloc(size);
> +	if (p)
> +		memset(p, 0, size);
> +	return p;
> +}
> +
> +static inline void cxgb3i_free_big_mem(void *addr)
> +{
> +	if (is_vmalloc_addr(addr))
> +		vfree(addr);
> +	else
> +		kfree(addr);
> +}
> +
> +/*
> + * cxgb3i ddp tag are 32 bits, it consists of reserved bits used by h/w and
> + * non-reserved bits that can be used by the iscsi s/w.
> + * The reserved bits are identified by the rsvd_bits and rsvd_shift fields
> + * in struct cxgb3i_tag_format.
> + *
> + * The upper most reserved bit can be used to check if a tag is ddp tag or not:
> + * 	if the bit is 0, the tag is a valid ddp tag
> + */
> +
> +/**
> + * cxgb3i_is_ddp_tag - check if a given tag is a hw/ddp tag
> + * @tformat: tag format information
> + * @tag: tag to be checked
> + *
> + * return true if the tag is a ddp tag, false otherwise.
> + */
> +static inline int cxgb3i_is_ddp_tag(struct cxgb3i_tag_format *tformat, u32 tag)
> +{
> +	return !(tag & (1 << (tformat->rsvd_bits + tformat->rsvd_shift - 1)));
> +}
> +
> +/**
> + * cxgb3i_sw_tag_usable - check if a given s/w tag has enough bits left for
> + *			  the reserved/hw bits
> + * @tformat: tag format information
> + * @sw_tag: s/w tag to be checked
> + *
> + * return true if the tag is a ddp tag, false otherwise.
> + */
> +static inline int cxgb3i_sw_tag_usable(struct cxgb3i_tag_format *tformat,
> +					u32 sw_tag)
> +{
> +	sw_tag >>= (32 - tformat->rsvd_bits);
> +	return !sw_tag;
> +}
> +
> +/**
> + * cxgb3i_set_non_ddp_tag - mark a given s/w tag as an invalid ddp tag
> + * @tformat: tag format information
> + * @sw_tag: s/w tag to be checked
> + *
> + * insert 1 at the upper most reserved bit to mark it as an invalid ddp tag.
> + */
> +static inline u32 cxgb3i_set_non_ddp_tag(struct cxgb3i_tag_format *tformat,
> +					 u32 sw_tag)
> +{
> +	unsigned char shift = tformat->rsvd_bits + tformat->rsvd_shift - 1;
> +	u32 mask = (1 << shift) - 1;
> +
> +	if (sw_tag && (sw_tag & ~mask)) {
> +		u32 v1 = sw_tag & ((1 << shift) - 1);
> +		u32 v2 = (sw_tag >> (shift - 1)) << shift;
> +
> +		return v2 | v1 | 1 << shift;
> +	}
> +	return sw_tag | 1 << shift;
> +}
> +
> +/**
> + * cxgb3i_ddp_tag_base - shift the s/w tag bits so that reserved bits are not
> + *			 used.
> + * @tformat: tag format information
> + * @sw_tag: s/w tag to be checked
> + */
> +static inline u32 cxgb3i_ddp_tag_base(struct cxgb3i_tag_format *tformat,
> +				      u32 sw_tag)
> +{
> +	u32 mask = (1 << tformat->rsvd_shift) - 1;
> +
> +	if (sw_tag && (sw_tag & ~mask)) {
> +		u32 v1 = sw_tag & mask;
> +		u32 v2 = sw_tag >> tformat->rsvd_shift;
> +
> +		v2 <<= tformat->rsvd_shift + tformat->rsvd_bits;
> +		return v2 | v1;
> +	}
> +	return sw_tag;
> +}
> +
> +/**
> + * cxgb3i_tag_rsvd_bits - get the reserved bits used by the h/w
> + * @tformat: tag format information
> + * @tag: tag to be checked
> + *
> + * return the reserved bits in the tag
> + */
> +static inline u32 cxgb3i_tag_rsvd_bits(struct cxgb3i_tag_format *tformat,
> +				       u32 tag)
> +{
> +	if (cxgb3i_is_ddp_tag(tformat, tag))
> +		return (tag >> tformat->rsvd_shift) & tformat->rsvd_mask;
> +	return 0;
> +}
> +
> +/**
> + * cxgb3i_tag_nonrsvd_bits - get the non-reserved bits used by the s/w
> + * @tformat: tag format information
> + * @tag: tag to be checked
> + *
> + * return the non-reserved bits in the tag.
> + */
> +static inline u32 cxgb3i_tag_nonrsvd_bits(struct cxgb3i_tag_format *tformat,
> +					  u32 tag)
> +{
> +	unsigned char shift = tformat->rsvd_bits + tformat->rsvd_shift - 1;
> +	u32 v1, v2;
> +
> +	if (cxgb3i_is_ddp_tag(tformat, tag)) {
> +		v1 = tag & ((1 << tformat->rsvd_shift) - 1);
> +		v2 = (tag >> (shift + 1)) << tformat->rsvd_shift;
> +	} else {
> +		u32 mask = (1 << shift) - 1;
> +
> +		tag &= ~(1 << shift);
> +		v1 = tag & mask;
> +		v2 = (tag >> 1) & ~mask;
> +	}
> +	return v1 | v2;
> +}
> +
> +int cxgb3i_ddp_tag_reserve(struct t3cdev *, unsigned int tid,
> +			   struct cxgb3i_tag_format *, u32 *tag,
> +			   struct cxgb3i_gather_list *, gfp_t gfp);
> +void cxgb3i_ddp_tag_release(struct t3cdev *, u32 tag);
> +
> +struct cxgb3i_gather_list *cxgb3i_ddp_make_gl(unsigned int xferlen,
> +				struct scatterlist *sgl,
> +				unsigned int sgcnt,
> +				struct pci_dev *pdev,
> +				gfp_t gfp);
> +void cxgb3i_ddp_release_gl(struct cxgb3i_gather_list *gl,
> +				struct pci_dev *pdev);
> +
> +int cxgb3i_setup_conn_host_pagesize(struct t3cdev *, unsigned int tid,
> +				    int reply);
> +int cxgb3i_setup_conn_pagesize(struct t3cdev *, unsigned int tid, int reply,
> +			       unsigned long pgsz);
> +int cxgb3i_setup_conn_digest(struct t3cdev *, unsigned int tid,
> +				int hcrc, int dcrc, int reply);
> +int cxgb3i_ddp_find_page_index(unsigned long pgsz);
> +int cxgb3i_adapter_ddp_init(struct t3cdev *, struct cxgb3i_tag_format *,
> +			    unsigned int *txsz, unsigned int *rxsz);
> +void cxgb3i_adapter_ddp_cleanup(struct t3cdev *);
> +#endif
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
> new file mode 100644
> index 0000000..091ecb4
> --- /dev/null
> +++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
> @@ -0,0 +1,107 @@
> +/* cxgb3i_init.c: Chelsio S3xx iSCSI driver.
> + *
> + * Copyright (c) 2008 Chelsio Communications, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + *
> + * Written by: Karen Xie (kxie@chelsio.com)
> + */
> +
> +#include "cxgb3i.h"
> +
> +#define DRV_MODULE_NAME         "cxgb3i"
> +#define DRV_MODULE_VERSION	"1.0.0"
> +#define DRV_MODULE_RELDATE	"Jun. 1, 2008"
> +
> +static char version[] =
> +	"Chelsio S3xx iSCSI Driver " DRV_MODULE_NAME
> +	" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
> +
> +MODULE_AUTHOR("Karen Xie <kxie@chelsio.com>");
> +MODULE_DESCRIPTION("Chelsio S3xx iSCSI Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(DRV_MODULE_VERSION);
> +
> +static void open_s3_dev(struct t3cdev *);
> +static void close_s3_dev(struct t3cdev *);
> +
> +static cxgb3_cpl_handler_func cxgb3i_cpl_handlers[NUM_CPL_CMDS];
> +static struct cxgb3_client t3c_client = {
> +	.name = "iscsi_cxgb3",
> +	.handlers = cxgb3i_cpl_handlers,
> +	.add = open_s3_dev,
> +	.remove = close_s3_dev,
> +};
> +
> +/**
> + * open_s3_dev - register with cxgb3 LLD
> + * @t3dev:	cxgb3 adapter instance
> + */
> +static void open_s3_dev(struct t3cdev *t3dev)
> +{
> +	static int vers_printed;
> +
> +	if (!vers_printed) {
> +		printk(KERN_INFO "%s", version);
> +		vers_printed = 1;
> +	}
> +
> +	cxgb3i_sdev_add(t3dev, &t3c_client);
> +	cxgb3i_adapter_add(t3dev);
> +}
> +
> +/**
> + * close_s3_dev - de-register with cxgb3 LLD
> + * @t3dev:	cxgb3 adapter instance
> + */
> +static void close_s3_dev(struct t3cdev *t3dev)
> +{
> +	cxgb3i_adapter_remove(t3dev);
> +	cxgb3i_sdev_remove(t3dev);
> +}
> +
> +/**
> + * cxgb3i_init_module - module init entry point
> + *
> + * initialize any driver wide global data structures and register itself
> + *	with the cxgb3 module
> + */
> +static int __init cxgb3i_init_module(void)
> +{
> +	int err;
> +
> +	err = cxgb3i_sdev_init(cxgb3i_cpl_handlers);
> +	if (err < 0)
> +		return err;
> +
> +	err = cxgb3i_iscsi_init();
> +	if (err < 0)
> +		return err;
> +
> +	err = cxgb3i_pdu_init();
> +	if (err < 0)
> +		return err;
> +
> +	cxgb3_register_client(&t3c_client);
> +
> +	return 0;
> +}
> +
> +/**
> + * cxgb3i_exit_module - module cleanup/exit entry point
> + *
> + * go through the driver hba list and for each hba, release any resource held.
> + *	and unregisters iscsi transport and the cxgb3 module
> + */
> +static void __exit cxgb3i_exit_module(void)
> +{
> +	cxgb3_unregister_client(&t3c_client);
> +	cxgb3i_pdu_cleanup();
> +	cxgb3i_iscsi_cleanup();
> +	cxgb3i_sdev_cleanup();
> +}
> +
> +module_init(cxgb3i_init_module);
> +module_exit(cxgb3i_exit_module);
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
> new file mode 100644
> index 0000000..c16cba3
> --- /dev/null
> +++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
> @@ -0,0 +1,955 @@
> +/* cxgb3i_iscsi.c: Chelsio S3xx iSCSI driver.
> + *
> + * Copyright (c) 2008 Chelsio Communications, Inc.
> + * Copyright (c) 2008 Mike Christie
> + * Copyright (c) 2008 Red Hat, Inc.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + *
> + * Written by: Karen Xie (kxie@chelsio.com)
> + */
> +
> +#include <linux/inet.h>
> +#include <linux/crypto.h>
> +#include <net/tcp.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_eh.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi.h>
> +#include <scsi/iscsi_proto.h>
> +#include <scsi/libiscsi.h>
> +#include <scsi/scsi_transport_iscsi.h>
> +
> +#include "cxgb3i.h"
> +#include "cxgb3i_pdu.h"
> +
> +#ifdef __DEBUG_CXGB3I_TAG__
> +#define cxgb3i_tag_debug	cxgb3i_log_debug
> +#else
> +#define cxgb3i_tag_debug(fmt...)
> +#endif
> +
> +#ifdef __DEBUG_CXGB3I_API__
> +#define cxgb3i_api_debug	cxgb3i_log_debug
> +#else
> +#define cxgb3i_api_debug(fmt...)
> +#endif
> +
> +/*
> + * align pdu size to multiple of 512 for better performance
> + */
> +#define align_pdu_size(n) do { n = (n) & (~511); } while (0)
> +
> +static struct scsi_transport_template *cxgb3i_scsi_transport;
> +static struct scsi_host_template cxgb3i_host_template;
> +static struct iscsi_transport cxgb3i_iscsi_transport;
> +static unsigned char sw_tag_idx_bits;
> +static unsigned char sw_tag_age_bits;
> +
> +static LIST_HEAD(cxgb3i_snic_list);
> +static DEFINE_RWLOCK(cxgb3i_snic_rwlock);
> +
> +/**
> + * cxgb3i_adapter_add - init a s3 adapter structure and any h/w settings
> + * @t3dev: t3cdev adapter
> + * return the resulting cxgb3i_adapter struct
> + */
> +struct cxgb3i_adapter *cxgb3i_adapter_add(struct t3cdev *t3dev)
> +{
> +	struct cxgb3i_adapter *snic;
> +	struct adapter *adapter = tdev2adap(t3dev);
> +	int i;
> +
> +	snic = kzalloc(sizeof(*snic), GFP_KERNEL);
> +	if (!snic) {
> +		cxgb3i_api_debug("cxgb3 %s, OOM.\n", t3dev->name);
> +		return NULL;
> +	}
> +	spin_lock_init(&snic->lock);
> +
> +	snic->tdev = t3dev;
> +	snic->pdev = adapter->pdev;
> +	snic->tag_format.sw_bits = sw_tag_idx_bits + sw_tag_age_bits;
> +
> +	if (cxgb3i_adapter_ddp_init(t3dev, &snic->tag_format,
> +				    &snic->tx_max_size,
> +				    &snic->rx_max_size) < 0)
> +		goto free_snic;
> +
> +	for_each_port(adapter, i) {
> +		snic->hba[i] = cxgb3i_hba_host_add(snic, adapter->port[i]);
> +		if (!snic->hba[i])
> +			goto ulp_cleanup;
> +	}
> +	snic->hba_cnt = adapter->params.nports;
> +
> +	/* add to the list */
> +	write_lock(&cxgb3i_snic_rwlock);
> +	list_add_tail(&snic->list_head, &cxgb3i_snic_list);
> +	write_unlock(&cxgb3i_snic_rwlock);
> +
> +	return snic;
> +
> +ulp_cleanup:
> +	cxgb3i_adapter_ddp_cleanup(t3dev);
> +free_snic:
> +	kfree(snic);
> +	return NULL;
> +}
> +
> +/**
> + * cxgb3i_adapter_remove - release all the resources held and cleanup any
> + *	h/w settings
> + * @t3dev: t3cdev adapter
> + */
> +void cxgb3i_adapter_remove(struct t3cdev *t3dev)
> +{
> +	int i;
> +	struct cxgb3i_adapter *snic;
> +
> +	/* remove from the list */
> +	write_lock(&cxgb3i_snic_rwlock);
> +	list_for_each_entry(snic, &cxgb3i_snic_list, list_head) {
> +		if (snic->tdev == t3dev) {
> +			list_del(&snic->list_head);
> +			break;
> +		}
> +	}
> +	write_unlock(&cxgb3i_snic_rwlock);
> +
> +	if (snic) {
> +		for (i = 0; i < snic->hba_cnt; i++) {
> +			if (snic->hba[i]) {
> +				cxgb3i_hba_host_remove(snic->hba[i]);
> +				snic->hba[i] = NULL;
> +			}
> +		}
> +
> +		/* release ddp resources */
> +		cxgb3i_adapter_ddp_cleanup(snic->tdev);
> +		kfree(snic);
> +	}
> +}
> +
> +/**
> + * cxgb3i_hba_find_by_netdev - find the cxgb3i_hba structure with a given
> + *	net_device
> + * @t3dev: t3cdev adapter
> + */
> +struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *ndev)
> +{
> +	struct cxgb3i_adapter *snic;
> +	int i;
> +
> +	read_lock(&cxgb3i_snic_rwlock);
> +	list_for_each_entry(snic, &cxgb3i_snic_list, list_head) {
> +		for (i = 0; i < snic->hba_cnt; i++) {
> +			if (snic->hba[i]->ndev == ndev) {
> +				read_unlock(&cxgb3i_snic_rwlock);
> +				return snic->hba[i];
> +			}
> +		}
> +	}
> +	read_unlock(&cxgb3i_snic_rwlock);
> +	return NULL;
> +}
> +
> +/**
> + * cxgb3i_hba_host_add - register a new host with scsi/iscsi
> + * @snic: the cxgb3i adapter
> + * @ndev: associated net_device
> + */
> +struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *snic,
> +				       struct net_device *ndev)
> +{
> +	struct cxgb3i_hba *hba;
> +	struct Scsi_Host *shost;
> +	int err;
> +
> +	shost = iscsi_host_alloc(&cxgb3i_host_template,
> +				 sizeof(struct cxgb3i_hba),
> +				 CXGB3I_SCSI_QDEPTH_DFLT);
> +	if (!shost) {
> +		cxgb3i_log_info("iscsi_host_alloc failed.\n");
> +		return NULL;
> +	}
> +
> +	shost->transportt = cxgb3i_scsi_transport;
> +	shost->max_lun = CXGB3I_MAX_LUN;
> +	shost->max_id = CXGB3I_MAX_TARGET;
> +	shost->max_channel = 0;
> +	shost->max_cmd_len = 16;
> +
> +	hba = iscsi_host_priv(shost);
> +	hba->snic = snic;
> +	hba->ndev = ndev;
> +	hba->shost = shost;
> +
> +	pci_dev_get(snic->pdev);
> +	err = iscsi_host_add(shost, &snic->pdev->dev);
> +	if (err) {
> +		cxgb3i_log_info("iscsi_host_add failed.\n");
> +		goto pci_dev_put;
> +	}
> +
> +	cxgb3i_api_debug("shost 0x%p, hba 0x%p, no %u.\n",
> +			 shost, hba, shost->host_no);
> +
> +	return hba;
> +
> +pci_dev_put:
> +	pci_dev_put(snic->pdev);
> +	scsi_host_put(shost);
> +	return NULL;
> +}
> +
> +/**
> + * cxgb3i_hba_host_remove - de-register the host with scsi/iscsi
> + * @hba: the cxgb3i hba
> + */
> +void cxgb3i_hba_host_remove(struct cxgb3i_hba *hba)
> +{
> +	cxgb3i_api_debug("shost 0x%p, hba 0x%p, no %u.\n",
> +			 hba->shost, hba, hba->shost->host_no);
> +	iscsi_host_remove(hba->shost);
> +	pci_dev_put(hba->snic->pdev);
> +	iscsi_host_free(hba->shost);
> +}
> +
> +/**
> + * cxgb3i_ep_connect - establish TCP connection to target portal
> + * @dst_addr:		target IP address
> + * @non_blocking:	blocking or non-blocking call
> + *
> + * Initiates a TCP/IP connection to the dst_addr
> + */
> +static struct iscsi_endpoint *cxgb3i_ep_connect(struct sockaddr *dst_addr,
> +						int non_blocking)
> +{
> +	struct iscsi_endpoint *ep;
> +	struct cxgb3i_endpoint *cep;
> +	struct cxgb3i_hba *hba;
> +	struct s3_conn *c3cn = NULL;
> +	int err = 0;
> +
> +	c3cn = cxgb3i_c3cn_create();
> +	if (!c3cn) {
> +		cxgb3i_log_info("ep connect OOM.\n");
> +		err = -ENOMEM;
> +		goto release_conn;
> +	}
> +
> +	err = cxgb3i_c3cn_connect(c3cn, (struct sockaddr_in *)dst_addr);
> +	if (err < 0) {
> +		cxgb3i_log_info("ep connect failed.\n");
> +		goto release_conn;
> +	}
> +	hba = cxgb3i_hba_find_by_netdev(c3cn->dst_cache->dev);
> +	if (!hba) {
> +		err = -ENOSPC;
> +		cxgb3i_log_info("NOT going through cxgbi device.\n");
> +		goto release_conn;
> +	}
> +	if (c3cn_is_closing(c3cn)) {
> +		err = -ENOSPC;
> +		cxgb3i_log_info("ep connect unable to connect.\n");
> +		goto release_conn;
> +	}
> +
> +	ep = iscsi_create_endpoint(sizeof(*cep));
> +	if (!ep) {
> +		err = -ENOMEM;
> +		cxgb3i_log_info("iscsi alloc ep, OOM.\n");
> +		goto release_conn;
> +	}
> +	cep = ep->dd_data;
> +	cep->c3cn = c3cn;
> +	cep->hba = hba;
> +
> +	cxgb3i_api_debug("ep 0x%p, 0x%p, c3cn 0x%p, hba 0x%p.\n",
> +			  ep, cep, c3cn, hba);
> +	return ep;
> +
> +release_conn:
> +	cxgb3i_api_debug("conn 0x%p failed, release.\n", c3cn);
> +	if (c3cn)
> +		cxgb3i_c3cn_release(c3cn);
> +	return ERR_PTR(err);
> +}
> +
> +/**
> + * cxgb3i_ep_poll - polls for TCP connection establishement
> + * @ep:		TCP connection (endpoint) handle
> + * @timeout_ms:	timeout value in milli secs
> + *
> + * polls for TCP connect request to complete
> + */
> +static int cxgb3i_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
> +{
> +	struct cxgb3i_endpoint *cep = ep->dd_data;
> +	struct s3_conn *c3cn = cep->c3cn;
> +
> +	if (!c3cn_is_established(c3cn))
> +		return 0;
> +	cxgb3i_api_debug("ep 0x%p, c3cn 0x%p established.\n", ep, c3cn);
> +	return 1;
> +}
> +
> +/**
> + * cxgb3i_ep_disconnect - teardown TCP connection
> + * @ep:		TCP connection (endpoint) handle
> + *
> + * teardown TCP connection
> + */
> +static void cxgb3i_ep_disconnect(struct iscsi_endpoint *ep)
> +{
> +	struct cxgb3i_endpoint *cep = ep->dd_data;
> +	struct cxgb3i_conn *cconn = cep->cconn;
> +
> +	cxgb3i_api_debug("ep 0x%p, cep 0x%p.\n", ep, cep);
> +
> +	if (cconn && cconn->conn) {
> +		/*
> +		 * stop the xmit path so the xmit_pdu function is
> +		 * not being called
> +		 */
> +		iscsi_suspend_tx(cconn->conn);
> +
> +		write_lock_bh(&cep->c3cn->callback_lock);
> +		cep->c3cn->user_data = NULL;
> +		cconn->cep = NULL;
> +		write_unlock_bh(&cep->c3cn->callback_lock);
> +	}
> +
> +	cxgb3i_api_debug("ep 0x%p, cep 0x%p, release c3cn 0x%p.\n",
> +			 ep, cep, cep->c3cn);
> +	cxgb3i_c3cn_release(cep->c3cn);
> +	iscsi_destroy_endpoint(ep);
> +}
> +
> +/**
> + * cxgb3i_session_create - create a new iscsi session
> + * @cmds_max:		max # of commands
> + * @qdepth:		scsi queue depth
> + * @initial_cmdsn:	initial iscsi CMDSN for this session
> + * @host_no:		pointer to return host no
> + *
> + * Creates a new iSCSI session
> + */
> +static struct iscsi_cls_session *
> +cxgb3i_session_create(struct iscsi_endpoint *ep, u16 cmds_max, u16 qdepth,
> +		      u32 initial_cmdsn, u32 *host_no)
> +{
> +	struct cxgb3i_endpoint *cep;
> +	struct cxgb3i_hba *hba;
> +	struct Scsi_Host *shost;
> +	struct iscsi_cls_session *cls_session;
> +	struct iscsi_session *session;
> +
> +	if (!ep) {
> +		cxgb3i_log_error("%s, missing endpoint.\n", __func__);
> +		return NULL;
> +	}
> +
> +	cep = ep->dd_data;
> +	hba = cep->hba;
> +	shost = hba->shost;
> +	cxgb3i_api_debug("ep 0x%p, cep 0x%p, hba 0x%p.\n", ep, cep, hba);
> +	BUG_ON(hba != iscsi_host_priv(shost));
> +
> +	*host_no = shost->host_no;
> +
> +	cls_session = iscsi_session_setup(&cxgb3i_iscsi_transport, shost,
> +					  cmds_max,
> +					  sizeof(struct iscsi_tcp_task),
> +					  initial_cmdsn, ISCSI_MAX_TARGET);
> +	if (!cls_session)
> +		return NULL;
> +	session = cls_session->dd_data;
> +	if (iscsi_tcp_r2tpool_alloc(session))
> +		goto remove_session;
> +
> +	return cls_session;
> +
> +remove_session:
> +	iscsi_session_teardown(cls_session);
> +	return NULL;
> +}
> +
> +/**
> + * cxgb3i_session_destroy - destroys iscsi session
> + * @cls_session:	pointer to iscsi cls session
> + *
> + * Destroys an iSCSI session instance and releases its all resources held
> + */
> +static void cxgb3i_session_destroy(struct iscsi_cls_session *cls_session)
> +{
> +	cxgb3i_api_debug("sess 0x%p.\n", cls_session);
> +	iscsi_tcp_r2tpool_free(cls_session->dd_data);
> +	iscsi_session_teardown(cls_session);
> +}
> +
> +/**
> + * cxgb3i_conn_max_xmit_dlength -- check the max. xmit pdu segment size,
> + * reduce it to be within the hardware limit if needed
> + * @conn: iscsi connection
> + */
> +static inline int cxgb3i_conn_max_xmit_dlength(struct iscsi_conn *conn)
> +
> +{
> +	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
> +	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
> +	unsigned int max = min_t(unsigned int, ULP2_MAX_PDU_SIZE,
> +				 cconn->hba->snic->tx_max_size -
> +				 ISCSI_PDU_HEADER_MAX);
> +
> +	if (conn->max_xmit_dlength)
> +		conn->max_xmit_dlength = min_t(unsigned int,
> +						conn->max_xmit_dlength, max);
> +	else
> +		conn->max_xmit_dlength = max;
> +	align_pdu_size(conn->max_xmit_dlength);
> +	cxgb3i_log_info("conn 0x%p, max xmit %u.\n",
> +			 conn, conn->max_xmit_dlength);
> +	return 0;
> +}
> +
> +/**
> + * cxgb3i_conn_max_recv_dlength -- check the max. recv pdu segment size against
> + * the hardware limit
> + * @conn: iscsi connection
> + * return 0 if the value is valid, < 0 otherwise.
> + */
> +static inline int cxgb3i_conn_max_recv_dlength(struct iscsi_conn *conn)
> +{
> +	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
> +	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
> +	unsigned int max = min_t(unsigned int, ULP2_MAX_PDU_SIZE,
> +				 cconn->hba->snic->rx_max_size -
> +				 ISCSI_PDU_HEADER_MAX);
> +
> +	align_pdu_size(max);
> +	if (conn->max_recv_dlength) {
> +		if (conn->max_recv_dlength > max) {
> +			cxgb3i_log_error("MaxRecvDataSegmentLength %u too big."
> +					 " Need to be <= %u.\n",
> +					 conn->max_recv_dlength, max);
> +			return -EINVAL;
> +		}
> +		conn->max_recv_dlength = min_t(unsigned int,
> +						conn->max_recv_dlength, max);
> +		align_pdu_size(conn->max_recv_dlength);
> +	} else
> +		conn->max_recv_dlength = max;
> +	cxgb3i_api_debug("conn 0x%p, max recv %u.\n",
> +			 conn, conn->max_recv_dlength);
> +	return 0;
> +}
> +
> +/**
> + * cxgb3i_conn_create - create iscsi connection instance
> + * @cls_session:	pointer to iscsi cls session
> + * @cid:		iscsi cid
> + *
> + * Creates a new iSCSI connection instance for a given session
> + */
> +static struct iscsi_cls_conn *cxgb3i_conn_create(struct iscsi_cls_session
> +						 *cls_session, u32 cid)
> +{
> +	struct iscsi_cls_conn *cls_conn;
> +	struct iscsi_conn *conn;
> +	struct iscsi_tcp_conn *tcp_conn;
> +	struct cxgb3i_conn *cconn;
> +
> +	cxgb3i_api_debug("sess 0x%p, cid %u.\n", cls_session, cid);
> +
> +	cls_conn = iscsi_tcp_conn_setup(cls_session, sizeof(*cconn), cid);
> +	if (!cls_conn)
> +		return NULL;
> +	conn = cls_conn->dd_data;
> +	tcp_conn = conn->dd_data;
> +	cconn = tcp_conn->dd_data;
> +
> +	cconn->conn = conn;
> +	return cls_conn;
> +}
> +
> +/**
> + * cxgb3i_conn_bind - binds iscsi sess, conn and endpoint together
> + * @cls_session:	pointer to iscsi cls session
> + * @cls_conn:		pointer to iscsi cls conn
> + * @transport_eph:	64-bit EP handle
> + * @is_leading:		leading connection on this session?
> + *
> + * Binds together an iSCSI session, an iSCSI connection and a
> + *	TCP connection. This routine returns error code if the TCP
> + *	connection does not belong on the device iSCSI sess/conn is bound
> + */
> +
> +static int cxgb3i_conn_bind(struct iscsi_cls_session *cls_session,
> +			    struct iscsi_cls_conn *cls_conn,
> +			    u64 transport_eph, int is_leading)
> +{
> +	struct iscsi_conn *conn = cls_conn->dd_data;
> +	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
> +	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
> +	struct cxgb3i_adapter *snic;
> +	struct iscsi_endpoint *ep;
> +	struct cxgb3i_endpoint *cep;
> +	struct s3_conn *c3cn;
> +	int err;
> +
> +	ep = iscsi_lookup_endpoint(transport_eph);
> +	if (!ep)
> +		return -EINVAL;
> +
> +	/* setup ddp pagesize */
> +	cep = ep->dd_data;
> +	c3cn = cep->c3cn;
> +	snic = cep->hba->snic;
> +	err = cxgb3i_setup_conn_host_pagesize(snic->tdev, c3cn->tid, 0);
> +	if (err < 0)
> +		return err;
> +
> +	cxgb3i_api_debug("ep 0x%p, cls sess 0x%p, cls conn 0x%p.\n",
> +			 ep, cls_session, cls_conn);
> +
> +	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
> +	if (err)
> +		return -EINVAL;
> +
> +	/* calculate the tag idx bits needed for this conn based on cmds_max */
> +	cconn->task_idx_bits = (__ilog2_u32(conn->session->cmds_max - 1)) + 1;
> +	cxgb3i_api_debug("session cmds_max 0x%x, bits %u.\n",
> +			 conn->session->cmds_max, cconn->task_idx_bits);
> +
> +	read_lock(&c3cn->callback_lock);
> +	c3cn->user_data = conn;
> +	cconn->hba = cep->hba;
> +	cconn->cep = cep;
> +	cep->cconn = cconn;
> +	read_unlock(&c3cn->callback_lock);
> +
> +	cxgb3i_conn_max_xmit_dlength(conn);
> +	cxgb3i_conn_max_recv_dlength(conn);
> +
> +	spin_lock_bh(&conn->session->lock);
> +	sprintf(conn->portal_address, NIPQUAD_FMT,
> +		NIPQUAD(c3cn->daddr.sin_addr.s_addr));
> +	conn->portal_port = ntohs(c3cn->daddr.sin_port);
> +	spin_unlock_bh(&conn->session->lock);
> +
> +	/* init recv engine */
> +	iscsi_tcp_hdr_recv_prep(tcp_conn);
> +
> +	return 0;
> +}
> +
> +/**
> + * cxgb3i_conn_get_param - return iscsi connection parameter to caller
> + * @cls_conn:	pointer to iscsi cls conn
> + * @param:	parameter type identifier
> + * @buf:	buffer pointer
> + *
> + * returns iSCSI connection parameters
> + */
> +static int cxgb3i_conn_get_param(struct iscsi_cls_conn *cls_conn,
> +				 enum iscsi_param param, char *buf)
> +{
> +	struct iscsi_conn *conn = cls_conn->dd_data;
> +	int len;
> +
> +	cxgb3i_api_debug("cls_conn 0x%p, param %d.\n", cls_conn, param);
> +
> +	switch (param) {
> +	case ISCSI_PARAM_CONN_PORT:
> +		spin_lock_bh(&conn->session->lock);
> +		len = sprintf(buf, "%hu\n", conn->portal_port);
> +		spin_unlock_bh(&conn->session->lock);
> +		break;
> +	case ISCSI_PARAM_CONN_ADDRESS:
> +		spin_lock_bh(&conn->session->lock);
> +		len = sprintf(buf, "%s\n", conn->portal_address);
> +		spin_unlock_bh(&conn->session->lock);
> +		break;
> +	default:
> +		return iscsi_conn_get_param(cls_conn, param, buf);
> +	}
> +
> +	return len;
> +}
> +
> +/**
> + * cxgb3i_conn_set_param - set iscsi connection parameter
> + * @cls_conn:	pointer to iscsi cls conn
> + * @param:	parameter type identifier
> + * @buf:	buffer pointer
> + * @buflen:	buffer length
> + *
> + * set iSCSI connection parameters
> + */
> +static int cxgb3i_conn_set_param(struct iscsi_cls_conn *cls_conn,
> +				 enum iscsi_param param, char *buf, int buflen)
> +{
> +	struct iscsi_conn *conn = cls_conn->dd_data;
> +	struct iscsi_session *session = conn->session;
> +	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
> +	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
> +	struct cxgb3i_adapter *snic = cconn->hba->snic;
> +	struct s3_conn *c3cn = cconn->cep->c3cn;
> +	int value, err = 0;
> +
> +	switch (param) {
> +	case ISCSI_PARAM_HDRDGST_EN:
> +		err = iscsi_set_param(cls_conn, param, buf, buflen);
> +		if (!err && conn->hdrdgst_en)
> +			err = cxgb3i_setup_conn_digest(snic->tdev, c3cn->tid,
> +							conn->hdrdgst_en,
> +							conn->datadgst_en, 0);
> +		break;
> +	case ISCSI_PARAM_DATADGST_EN:
> +		err = iscsi_set_param(cls_conn, param, buf, buflen);
> +		if (!err && conn->datadgst_en)
> +			err = cxgb3i_setup_conn_digest(snic->tdev, c3cn->tid,
> +							conn->hdrdgst_en,
> +							conn->datadgst_en, 0);
> +		break;
> +	case ISCSI_PARAM_MAX_R2T:
> +		sscanf(buf, "%d", &value);
> +		if (value <= 0 || !is_power_of_2(value))
> +			return -EINVAL;
> +		if (session->max_r2t == value)
> +			break;
> +		iscsi_tcp_r2tpool_free(session);
> +		err = iscsi_set_param(cls_conn, param, buf, buflen);
> +		if (!err && iscsi_tcp_r2tpool_alloc(session))
> +			return -ENOMEM;
> +	case ISCSI_PARAM_MAX_RECV_DLENGTH:
> +		err = iscsi_set_param(cls_conn, param, buf, buflen);
> +		if (!err)
> +			err = cxgb3i_conn_max_recv_dlength(conn);
> +		break;
> +	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
> +		err = iscsi_set_param(cls_conn, param, buf, buflen);
> +		if (!err)
> +			err = cxgb3i_conn_max_xmit_dlength(conn);
> +		break;
> +	default:
> +		return iscsi_set_param(cls_conn, param, buf, buflen);
> +	}
> +	return err;
> +}
> +
> +/**
> + * cxgb3i_host_set_param - configure host (adapter) related parameters
> + * @shost:	scsi host pointer
> + * @param:	parameter type identifier
> + * @buf:	buffer pointer
> + */
> +static int cxgb3i_host_set_param(struct Scsi_Host *shost,
> +				 enum iscsi_host_param param,
> +				 char *buf, int buflen)
> +{
> +	struct cxgb3i_hba *hba = iscsi_host_priv(shost);
> +
> +	cxgb3i_api_debug("param %d, buf %s.\n", param, buf);
> +
> +	switch (param) {
> +	case ISCSI_HOST_PARAM_IPADDRESS:
> +	{
> +		__be32 addr = in_aton(buf);
> +		cxgb3i_set_private_ipv4addr(hba->ndev, addr);
> +		return 0;
> +	}
> +	case ISCSI_HOST_PARAM_HWADDRESS:
> +	case ISCSI_HOST_PARAM_NETDEV_NAME:
> +		/* ignore */
> +		return 0;
> +	default:
> +		return iscsi_host_set_param(shost, param, buf, buflen);
> +	}
> +}
> +
> +/**
> + * cxgb3i_host_get_param - returns host (adapter) related parameters
> + * @shost:	scsi host pointer
> + * @param:	parameter type identifier
> + * @buf:	buffer pointer
> + */
> +static int cxgb3i_host_get_param(struct Scsi_Host *shost,
> +				 enum iscsi_host_param param, char *buf)
> +{
> +	struct cxgb3i_hba *hba = iscsi_host_priv(shost);
> +	int i;
> +	int len = 0;
> +
> +	cxgb3i_api_debug("hba %s, param %d.\n", hba->ndev->name, param);
> +
> +	switch (param) {
> +	case ISCSI_HOST_PARAM_HWADDRESS:
> +		for (i = 0; i < 6; i++)
> +			len +=
> +			    sprintf(buf + len, "%02x.",
> +				    hba->ndev->dev_addr[i]);
> +		len--;
> +		buf[len] = '\0';
> +		break;
> +	case ISCSI_HOST_PARAM_NETDEV_NAME:
> +		len = sprintf(buf, "%s\n", hba->ndev->name);
> +		break;
> +	case ISCSI_HOST_PARAM_IPADDRESS:
> +	{
> +		__be32 addr;
> +
> +		addr = cxgb3i_get_private_ipv4addr(hba->ndev);
> +		len = sprintf(buf, "%u.%u.%u.%u", NIPQUAD(addr));
> +		break;
> +	}
> +	default:
> +		return iscsi_host_get_param(shost, param, buf);
> +	}
> +	return len;
> +}
> +
> +/**
> + * cxgb3i_conn_get_stats - returns iSCSI stats
> + * @cls_conn:	pointer to iscsi cls conn
> + * @stats:	pointer to iscsi statistic struct
> + */
> +static void cxgb3i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
> +				  struct iscsi_stats *stats)
> +{
> +	struct iscsi_conn *conn = cls_conn->dd_data;
> +
> +	stats->txdata_octets = conn->txdata_octets;
> +	stats->rxdata_octets = conn->rxdata_octets;
> +	stats->scsicmd_pdus = conn->scsicmd_pdus_cnt;
> +	stats->dataout_pdus = conn->dataout_pdus_cnt;
> +	stats->scsirsp_pdus = conn->scsirsp_pdus_cnt;
> +	stats->datain_pdus = conn->datain_pdus_cnt;
> +	stats->r2t_pdus = conn->r2t_pdus_cnt;
> +	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
> +	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
> +	stats->digest_err = 0;
> +	stats->timeout_err = 0;
> +	stats->custom_length = 1;
> +	strcpy(stats->custom[0].desc, "eh_abort_cnt");
> +	stats->custom[0].value = conn->eh_abort_cnt;
> +}
> +
> +/**
> + * cxgb3i_parse_itt - get the idx and age bits from a given tag
> + * @conn:	iscsi connection
> + * @itt:	itt tag
> + * @idx:	task index, filled in by this function
> + * @age:	session age, filled in by this function
> + */
> +static void cxgb3i_parse_itt(struct iscsi_conn *conn, itt_t itt,
> +			     int *idx, int *age)
> +{
> +	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
> +	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
> +	struct cxgb3i_adapter *snic = cconn->hba->snic;
> +	u32 tag = ntohl((__force u32) itt);
> +	u32 sw_bits;
> +
> +	sw_bits = cxgb3i_tag_nonrsvd_bits(&snic->tag_format, tag);
> +	if (idx)
> +		*idx = sw_bits & ((1 << cconn->task_idx_bits) - 1);
> +	if (age)
> +		*age = (sw_bits >> cconn->task_idx_bits) & ISCSI_AGE_MASK;
> +
> +	cxgb3i_tag_debug("parse tag 0x%x/0x%x, sw 0x%x, itt 0x%x, age 0x%x.\n",
> +			 tag, itt, sw_bits, idx ? *idx : 0xFFFFF,
> +			 age ? *age : 0xFF);
> +}
> +
> +/**
> + * cxgb3i_reserve_itt - generate tag for a give task
> + * Try to set up ddp for a scsi read task.
> + * @task: iscsi task
> + * @hdr_itt: tag, filled in by this function
> + */
> +int cxgb3i_reserve_itt(struct iscsi_task *task, itt_t *hdr_itt)
> +{
> +	struct scsi_cmnd *sc = task->sc;
> +	struct iscsi_conn *conn = task->conn;
> +	struct iscsi_session *sess = conn->session;
> +	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
> +	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
> +	struct cxgb3i_adapter *snic = cconn->hba->snic;
> +	struct cxgb3i_tag_format *tformat = &snic->tag_format;
> +	u32 sw_tag = (sess->age << cconn->task_idx_bits) | task->itt;
> +	u32 tag;
> +	int err = -EINVAL;
> +
> +	if (sc && (sc->sc_data_direction == DMA_FROM_DEVICE) &&
> +	    cxgb3i_sw_tag_usable(tformat, sw_tag)) {

OK.
In bidi, sc_data_direction == DMA_TO_DEVICE, but scsi_in(sc) will
return an sdb just the same. So the check here must be on scsi_in(sc) != NULL
or "... && scsi_bidi_cmnd(sc)". Because we do need to initialize a read also
for bidi.

But on the other side, from what I understand in the bidi case, the current code
will just return an cxgb3i_set_non_ddp_tag() which is maybe better. That is, with
bidi commands we don't do DDP. I guess this is a good thing then. Strike out
my comment above.

> +		struct s3_conn *c3cn = cconn->cep->c3cn;
> +		struct cxgb3i_gather_list *gl;
> +
> +		gl = cxgb3i_ddp_make_gl(scsi_in(sc)->length,
> +					scsi_in(sc)->table.sgl,
> +					scsi_in(sc)->table.nents,
> +					snic->pdev,
> +					GFP_ATOMIC);
> +		if (gl) {
> +			tag = sw_tag;
> +			err = cxgb3i_ddp_tag_reserve(snic->tdev, c3cn->tid,
> +						     tformat, &tag,
> +						     gl, GFP_ATOMIC);
> +			if (err < 0)
> +				cxgb3i_ddp_release_gl(gl, snic->pdev);
> +		}
> +	}
> +
> +	if (err < 0)
> +		tag = cxgb3i_set_non_ddp_tag(tformat, sw_tag);
> +	/* the itt need to sent in big-endian order */
> +	*hdr_itt = (__force itt_t)htonl(tag);
> +
> +	cxgb3i_tag_debug("new tag 0x%x/0x%x (itt 0x%x, age 0x%x).\n",
> +			 tag, *hdr_itt, task->itt, sess->age);
> +	return 0;
> +}
> +
> +/**
> + * cxgb3i_release_itt - release the tag for a given task
> + * if the tag is a ddp tag, release the ddp setup
> + * @task:	iscsi task
> + * @hdr_itt:	tag
> + */
> +void cxgb3i_release_itt(struct iscsi_task *task, itt_t hdr_itt)
> +{
> +	struct scsi_cmnd *sc = task->sc;
> +	struct iscsi_tcp_conn *tcp_conn = task->conn->dd_data;
> +	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
> +	struct cxgb3i_adapter *snic = cconn->hba->snic;
> +	struct cxgb3i_tag_format *tformat = &snic->tag_format;
> +	u32 tag = ntohl((__force u32)hdr_itt);
> +
> +	cxgb3i_tag_debug("release tag 0x%x.\n", tag);
> +
> +	if (sc && (sc->sc_data_direction == DMA_FROM_DEVICE) &&
> +	    cxgb3i_is_ddp_tag(tformat, tag))
> +		cxgb3i_ddp_tag_release(snic->tdev, tag);
> +}
> +
> +/**
> + * cxgb3i_host_template -- Scsi_Host_Template structure
> + *	used when registering with the scsi mid layer
> + */
> +static struct scsi_host_template cxgb3i_host_template = {
> +	.module			= THIS_MODULE,
> +	.name			= "Chelsio S3xx iSCSI Initiator",
> +	.proc_name		= "cxgb3i",
> +	.queuecommand		= iscsi_queuecommand,
> +	.change_queue_depth	= iscsi_change_queue_depth,
> +	.can_queue		= 128 * (ISCSI_DEF_XMIT_CMDS_MAX - 1),
> +	.sg_tablesize		= SG_ALL,
> +	.max_sectors		= 0xFFFF,
> +	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
> +	.eh_abort_handler	= iscsi_eh_abort,
> +	.eh_device_reset_handler = iscsi_eh_device_reset,
> +	.eh_target_reset_handler = iscsi_eh_target_reset,
> +	.use_clustering		= DISABLE_CLUSTERING,
> +	.this_id		= -1,
> +};
> +
> +static struct iscsi_transport cxgb3i_iscsi_transport = {
> +	.owner			= THIS_MODULE,
> +	.name			= "cxgb3i",
> +	.caps			= CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_HDRDGST
> +				| CAP_DATADGST | CAP_DIGEST_OFFLOAD |
> +				CAP_PADDING_OFFLOAD,
> +	.param_mask		= ISCSI_MAX_RECV_DLENGTH |
> +				ISCSI_MAX_XMIT_DLENGTH |
> +				ISCSI_HDRDGST_EN |
> +				ISCSI_DATADGST_EN |
> +				ISCSI_INITIAL_R2T_EN |
> +				ISCSI_MAX_R2T |
> +				ISCSI_IMM_DATA_EN |
> +				ISCSI_FIRST_BURST |
> +				ISCSI_MAX_BURST |
> +				ISCSI_PDU_INORDER_EN |
> +				ISCSI_DATASEQ_INORDER_EN |
> +				ISCSI_ERL |
> +				ISCSI_CONN_PORT |
> +				ISCSI_CONN_ADDRESS |
> +				ISCSI_EXP_STATSN |
> +				ISCSI_PERSISTENT_PORT |
> +				ISCSI_PERSISTENT_ADDRESS |
> +				ISCSI_TARGET_NAME | ISCSI_TPGT |
> +				ISCSI_USERNAME | ISCSI_PASSWORD |
> +				ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN |
> +				ISCSI_FAST_ABORT | ISCSI_ABORT_TMO |
> +				ISCSI_LU_RESET_TMO |
> +				ISCSI_PING_TMO | ISCSI_RECV_TMO |
> +				ISCSI_IFACE_NAME | ISCSI_INITIATOR_NAME,
> +	.host_param_mask	= ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
> +			ISCSI_HOST_INITIATOR_NAME | ISCSI_HOST_NETDEV_NAME,
> +	.get_host_param		= cxgb3i_host_get_param,
> +	.set_host_param		= cxgb3i_host_set_param,
> +	/* session management */
> +	.create_session		= cxgb3i_session_create,
> +	.destroy_session	= cxgb3i_session_destroy,
> +	.get_session_param	= iscsi_session_get_param,
> +	/* connection management */
> +	.create_conn		= cxgb3i_conn_create,
> +	.bind_conn		= cxgb3i_conn_bind,
> +	.destroy_conn		= iscsi_tcp_conn_teardown,
> +	.start_conn		= iscsi_conn_start,
> +	.stop_conn		= iscsi_conn_stop,
> +	.get_conn_param		= cxgb3i_conn_get_param,
> +	.set_param		= cxgb3i_conn_set_param,
> +	.get_stats		= cxgb3i_conn_get_stats,
> +	/* pdu xmit req. from user space */
> +	.send_pdu		= iscsi_conn_send_pdu,
> +	/* task */
> +	.init_task		= iscsi_tcp_task_init,
> +	.xmit_task		= iscsi_tcp_task_xmit,
> +	.cleanup_task		= cxgb3i_conn_cleanup_task,
> +
> +	/* pdu */
> +	.alloc_pdu		= cxgb3i_conn_alloc_pdu,
> +	.init_pdu		= cxgb3i_conn_init_pdu,
> +	.xmit_pdu		= cxgb3i_conn_xmit_pdu,
> +	.parse_pdu_itt		= cxgb3i_parse_itt,
> +
> +	/* TCP connect/disconnect */
> +	.ep_connect		= cxgb3i_ep_connect,
> +	.ep_poll		= cxgb3i_ep_poll,
> +	.ep_disconnect		= cxgb3i_ep_disconnect,
> +	/* Error recovery timeout call */
> +	.session_recovery_timedout = iscsi_session_recovery_timedout,
> +};
> +
> +int cxgb3i_iscsi_init(void)
> +{
> +	sw_tag_idx_bits = (__ilog2_u32(ISCSI_ITT_MASK)) + 1;
> +	sw_tag_age_bits = (__ilog2_u32(ISCSI_AGE_MASK)) + 1;
> +	cxgb3i_log_info("tag itt 0x%x, %u bits, age 0x%x, %u bits.\n",
> +			ISCSI_ITT_MASK, sw_tag_idx_bits,
> +			ISCSI_AGE_MASK, sw_tag_age_bits);
> +
> +	cxgb3i_scsi_transport =
> +	    iscsi_register_transport(&cxgb3i_iscsi_transport);
> +	if (!cxgb3i_scsi_transport) {
> +		cxgb3i_log_error("Could not register cxgb3i transport.\n");
> +		return -ENODEV;
> +	}
> +	cxgb3i_api_debug("cxgb3i transport 0x%p.\n", cxgb3i_scsi_transport);
> +	return 0;
> +}
> +
> +void cxgb3i_iscsi_cleanup(void)
> +{
> +	if (cxgb3i_scsi_transport) {
> +		cxgb3i_api_debug("cxgb3i transport 0x%p.\n",
> +				 cxgb3i_scsi_transport);
> +		iscsi_unregister_transport(&cxgb3i_iscsi_transport);
> +	}
> +}
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
> new file mode 100644
> index 0000000..5f16081
> --- /dev/null
> +++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
> @@ -0,0 +1,1810 @@
> +/*
> + * cxgb3i_offload.c: Chelsio S3xx iscsi offloaded tcp connection management
> + *
> + * Copyright (C) 2003-2008 Chelsio Communications.  All rights reserved.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the LICENSE file included in this
> + * release for licensing terms and conditions.
> + *
> + * Written by:	Dimitris Michailidis (dm@chelsio.com)
> + *		Karen Xie (kxie@chelsio.com)
> + */
> +
> +#include <linux/if_vlan.h>
> +#include <linux/version.h>
> +
> +#include "cxgb3_defs.h"
> +#include "cxgb3_ctl_defs.h"
> +#include "firmware_exports.h"
> +#include "cxgb3i_offload.h"
> +#include "cxgb3i_pdu.h"
> +#include "cxgb3i_ddp.h"
> +
> +#ifdef __DEBUG_C3CN_CONN__
> +#define c3cn_conn_debug         cxgb3i_log_info
> +#else
> +#define c3cn_conn_debug(fmt...)
> +#endif
> +
> +#ifdef __DEBUG_C3CN_TX__
> +#define c3cn_tx_debug         cxgb3i_log_debug
> +#else
> +#define c3cn_tx_debug(fmt...)
> +#endif
> +
> +#ifdef __DEBUG_C3CN_RX__
> +#define c3cn_rx_debug         cxgb3i_log_debug
> +#else
> +#define c3cn_rx_debug(fmt...)
> +#endif
> +
> +/*
> + * module parameters releated to offloaded iscsi connection
> + */
> +static int cxgb3_rcv_win = 256 * 1024;
> +module_param(cxgb3_rcv_win, int, 0644);
> +MODULE_PARM_DESC(cxgb3_rcv_win, "TCP receive window in bytes (default=256KB)");
> +
> +static int cxgb3_snd_win = 64 * 1024;
> +module_param(cxgb3_snd_win, int, 0644);
> +MODULE_PARM_DESC(cxgb3_snd_win, "TCP send window in bytes (default=64KB)");
> +
> +static int cxgb3_rx_credit_thres = 10 * 1024;
> +module_param(cxgb3_rx_credit_thres, int, 0644);
> +MODULE_PARM_DESC(rx_credit_thres,
> +		 "RX credits return threshold in bytes (default=10KB)");
> +
> +static unsigned int cxgb3_max_connect = 8 * 1024;
> +module_param(cxgb3_max_connect, uint, 0644);
> +MODULE_PARM_DESC(cxgb3_max_connect, "Max. # of connections (default=8092)");
> +
> +static unsigned int cxgb3_sport_base = 20000;
> +module_param(cxgb3_sport_base, uint, 0644);
> +MODULE_PARM_DESC(cxgb3_sport_base, "starting port number (default=20000)");
> +
> +/*
> + * cxgb3i tcp connection data(per adapter) list
> + */
> +static LIST_HEAD(cdata_list);
> +static DEFINE_RWLOCK(cdata_rwlock);
> +
> +static int c3cn_push_tx_frames(struct s3_conn *c3cn, int req_completion);
> +static void c3cn_release_offload_resources(struct s3_conn *c3cn);
> +
> +/*
> + * iscsi source port management
> + *
> + * Find a free source port in the port allocation map. We use a very simple
> + * rotor scheme to look for the next free port.
> + *
> + * If a source port has been specified make sure that it doesn't collide with
> + * our normal source port allocation map.  If it's outside the range of our
> + * allocation/deallocation scheme just let them use it.
> + *
> + * If the source port is outside our allocation range, the caller is
> + * responsible for keeping track of their port usage.
> + */
> +static int c3cn_get_port(struct s3_conn *c3cn, struct cxgb3i_sdev_data *cdata)
> +{
> +	unsigned int start;
> +	int idx;
> +
> +	if (!cdata)
> +		goto error_out;
> +
> +	if (c3cn->saddr.sin_port != 0) {
> +		idx = ntohs(c3cn->saddr.sin_port) - cxgb3_sport_base;
> +		if (idx < 0 || idx >= cxgb3_max_connect)
> +			return 0;
> +		if (!test_and_set_bit(idx, cdata->sport_map))
> +			return -EADDRINUSE;
> +	}
> +
> +	/* the sport_map_next may not be accurate but that is okay, sport_map
> +	   should be */
> +	start = idx = cdata->sport_map_next;
> +	do {
> +		if (++idx >= cxgb3_max_connect)
> +			idx = 0;
> +		if (!(test_and_set_bit(idx, cdata->sport_map))) {
> +			c3cn->saddr.sin_port = htons(cxgb3_sport_base + idx);
> +			cdata->sport_map_next = idx;
> +			c3cn_conn_debug("%s reserve port %u.\n",
> +					cdata->cdev->name,
> +					cxgb3_sport_base + idx);
> +			return 0;
> +		}
> +	} while (idx != start);
> +
> +error_out:
> +	return -EADDRNOTAVAIL;
> +}
> +
> +static void c3cn_put_port(struct s3_conn *c3cn)
> +{
> +	struct cxgb3i_sdev_data *cdata = CXGB3_SDEV_DATA(c3cn->cdev);
> +
> +	if (c3cn->saddr.sin_port) {
> +		int idx = ntohs(c3cn->saddr.sin_port) - cxgb3_sport_base;
> +
> +		c3cn->saddr.sin_port = 0;
> +		if (idx < 0 || idx >= cxgb3_max_connect)
> +			return;
> +		clear_bit(idx, cdata->sport_map);
> +		c3cn_conn_debug("%s, release port %u.\n",
> +				cdata->cdev->name, cxgb3_sport_base + idx);
> +	}
> +}
> +
> +static inline void c3cn_set_flag(struct s3_conn *c3cn, enum c3cn_flags flag)
> +{
> +	__set_bit(flag, &c3cn->flags);
> +	c3cn_conn_debug("c3cn 0x%p, set %d, s %u, f 0x%lx.\n",
> +			c3cn, flag, c3cn->state, c3cn->flags);
> +}
> +
> +static inline void c3cn_clear_flag(struct s3_conn *c3cn, enum c3cn_flags flag)
> +{
> +	__clear_bit(flag, &c3cn->flags);
> +	c3cn_conn_debug("c3cn 0x%p, clear %d, s %u, f 0x%lx.\n",
> +			c3cn, flag, c3cn->state, c3cn->flags);
> +}
> +
> +static inline int c3cn_flag(struct s3_conn *c3cn, enum c3cn_flags flag)
> +{
> +	if (c3cn == NULL)
> +		return 0;
> +	return test_bit(flag, &c3cn->flags);
> +}
> +
> +static void c3cn_set_state(struct s3_conn *c3cn, int state)
> +{
> +	c3cn_conn_debug("c3cn 0x%p state -> %u.\n", c3cn, state);
> +	c3cn->state = state;
> +}
> +
> +static inline void c3cn_hold(struct s3_conn *c3cn)
> +{
> +	atomic_inc(&c3cn->refcnt);
> +}
> +
> +static inline void c3cn_put(struct s3_conn *c3cn)
> +{
> +	if (atomic_dec_and_test(&c3cn->refcnt)) {
> +		c3cn_conn_debug("free c3cn 0x%p, s %u, f 0x%lx.\n",
> +				c3cn, c3cn->state, c3cn->flags);
> +		kfree(c3cn);
> +	}
> +}
> +
> +static void c3cn_closed(struct s3_conn *c3cn)
> +{
> +	c3cn_conn_debug("c3cn 0x%p, state %u, flag 0x%lx.\n",
> +			 c3cn, c3cn->state, c3cn->flags);
> +
> +	c3cn_put_port(c3cn);
> +	c3cn_release_offload_resources(c3cn);
> +	c3cn_set_state(c3cn, C3CN_STATE_CLOSED);
> +	cxgb3i_conn_closing(c3cn);
> +}
> +
> +/*
> + * CPL (Chelsio Protocol Language) defines a message passing interface between
> + * the host driver and T3 asic.
> + * The section below implments CPLs that related to iscsi tcp connection
> + * open/close/abort and data send/receive.
> + */
> +
> +/*
> + * CPL connection active open request: host ->
> + */
> +static unsigned int find_best_mtu(const struct t3c_data *d, unsigned short mtu)
> +{
> +	int i = 0;
> +
> +	while (i < d->nmtus - 1 && d->mtus[i + 1] <= mtu)
> +		++i;
> +	return i;
> +}
> +
> +static unsigned int select_mss(struct s3_conn *c3cn, unsigned int pmtu)
> +{
> +	unsigned int idx;
> +	struct dst_entry *dst = c3cn->dst_cache;
> +	struct t3cdev *cdev = c3cn->cdev;
> +	const struct t3c_data *td = T3C_DATA(cdev);
> +	u16 advmss = dst_metric(dst, RTAX_ADVMSS);
> +
> +	if (advmss > pmtu - 40)
> +		advmss = pmtu - 40;
> +	if (advmss < td->mtus[0] - 40)
> +		advmss = td->mtus[0] - 40;
> +	idx = find_best_mtu(td, advmss + 40);
> +	return idx;
> +}
> +
> +static inline int compute_wscale(int win)
> +{
> +	int wscale = 0;
> +	while (wscale < 14 && (65535<<wscale) < win)
> +		wscale++;
> +	return wscale;
> +}
> +
> +static inline unsigned int calc_opt0h(struct s3_conn *c3cn)
> +{
> +	int wscale = compute_wscale(cxgb3_rcv_win);
> +	return  V_KEEP_ALIVE(1) |
> +		F_TCAM_BYPASS |
> +		V_WND_SCALE(wscale) |
> +		V_MSS_IDX(c3cn->mss_idx);
> +}
> +
> +static inline unsigned int calc_opt0l(struct s3_conn *c3cn)
> +{
> +	return  V_ULP_MODE(ULP_MODE_ISCSI) |
> +		V_RCV_BUFSIZ(cxgb3_rcv_win>>10);
> +}
> +
> +static void make_act_open_req(struct s3_conn *c3cn, struct sk_buff *skb,
> +			      unsigned int atid, const struct l2t_entry *e)
> +{
> +	struct cpl_act_open_req *req;
> +
> +	c3cn_conn_debug("c3cn 0x%p, atid 0x%x.\n", c3cn, atid);
> +
> +	skb->priority = CPL_PRIORITY_SETUP;
> +	req = (struct cpl_act_open_req *)__skb_put(skb, sizeof(*req));
> +	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
> +	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_ACT_OPEN_REQ, atid));
> +	req->local_port = c3cn->saddr.sin_port;
> +	req->peer_port = c3cn->daddr.sin_port;
> +	req->local_ip = c3cn->saddr.sin_addr.s_addr;
> +	req->peer_ip = c3cn->daddr.sin_addr.s_addr;
> +	req->opt0h = htonl(calc_opt0h(c3cn) | V_L2T_IDX(e->idx) |
> +			   V_TX_CHANNEL(e->smt_idx));
> +	req->opt0l = htonl(calc_opt0l(c3cn));
> +	req->params = 0;
> +}
> +
> +static void fail_act_open(struct s3_conn *c3cn, int errno)
> +{
> +	c3cn_conn_debug("c3cn 0x%p, state %u, flag 0x%lx.\n",
> +			c3cn, c3cn->state, c3cn->flags);
> +	c3cn->err = errno;
> +	c3cn_closed(c3cn);
> +}
> +
> +static void act_open_req_arp_failure(struct t3cdev *dev, struct sk_buff *skb)
> +{
> +	struct s3_conn *c3cn = (struct s3_conn *)skb->sk;
> +
> +	c3cn_conn_debug("c3cn 0x%p, state %u.\n", c3cn, c3cn->state);
> +
> +	c3cn_hold(c3cn);
> +	spin_lock_bh(&c3cn->lock);
> +	if (c3cn->state == C3CN_STATE_CONNECTING)
> +		fail_act_open(c3cn, EHOSTUNREACH);
> +	spin_unlock_bh(&c3cn->lock);
> +	c3cn_put(c3cn);
> +	__kfree_skb(skb);
> +}
> +
> +/*
> + * CPL connection close request: host ->
> + *
> + * Close a connection by sending a CPL_CLOSE_CON_REQ message and queue it to
> + * the write queue (i.e., after any unsent txt data).
> + */
> +static void skb_entail(struct s3_conn *c3cn, struct sk_buff *skb,
> +		       int flags)
> +{
> +	CXGB3_SKB_CB(skb)->seq = c3cn->write_seq;
> +	CXGB3_SKB_CB(skb)->flags = flags;
> +	__skb_queue_tail(&c3cn->write_queue, skb);
> +}
> +
> +static void send_close_req(struct s3_conn *c3cn)
> +{
> +	struct sk_buff *skb = c3cn->cpl_close;
> +	struct cpl_close_con_req *req = (struct cpl_close_con_req *)skb->head;
> +	unsigned int tid = c3cn->tid;
> +
> +	c3cn_conn_debug("c3cn 0x%p, state 0x%x, flag 0x%lx.\n",
> +			c3cn, c3cn->state, c3cn->flags);
> +
> +	c3cn->cpl_close = NULL;
> +
> +	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_OFLD_CLOSE_CON));
> +	req->wr.wr_lo = htonl(V_WR_TID(tid));
> +	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_CLOSE_CON_REQ, tid));
> +	req->rsvd = htonl(c3cn->write_seq);
> +
> +	skb_entail(c3cn, skb, C3CB_FLAG_NO_APPEND);
> +	if (c3cn->state != C3CN_STATE_CONNECTING)
> +		c3cn_push_tx_frames(c3cn, 1);
> +}
> +
> +/*
> + * CPL connection abort request: host ->
> + *
> + * Send an ABORT_REQ message. Makes sure we do not send multiple ABORT_REQs
> + * for the same connection and also that we do not try to send a message
> + * after the connection has closed.
> + */
> +static void abort_arp_failure(struct t3cdev *cdev, struct sk_buff *skb)
> +{
> +	struct cpl_abort_req *req = cplhdr(skb);
> +
> +	c3cn_conn_debug("tdev 0x%p.\n", cdev);
> +
> +	req->cmd = CPL_ABORT_NO_RST;
> +	cxgb3_ofld_send(cdev, skb);
> +}
> +
> +static inline void c3cn_purge_write_queue(struct s3_conn *c3cn)
> +{
> +	struct sk_buff *skb;
> +
> +	while ((skb = __skb_dequeue(&c3cn->write_queue)))
> +		__kfree_skb(skb);
> +}
> +
> +static void send_abort_req(struct s3_conn *c3cn)
> +{
> +	struct sk_buff *skb = c3cn->cpl_abort_req;
> +	struct cpl_abort_req *req;
> +	unsigned int tid = c3cn->tid;
> +
> +	if (unlikely(c3cn->state == C3CN_STATE_ABORTING) || !skb ||
> +		     !c3cn->cdev)
> +		return;
> +
> +	c3cn_set_state(c3cn, C3CN_STATE_ABORTING);
> +
> +	c3cn_conn_debug("c3cn 0x%p, flag ABORT_RPL + ABORT_SHUT.\n", c3cn);
> +
> +	c3cn_set_flag(c3cn, C3CN_ABORT_RPL_PENDING);
> +
> +	/* Purge the send queue so we don't send anything after an abort. */
> +	c3cn_purge_write_queue(c3cn);
> +
> +	c3cn->cpl_abort_req = NULL;
> +	req = (struct cpl_abort_req *)skb->head;
> +
> +	skb->priority = CPL_PRIORITY_DATA;
> +	set_arp_failure_handler(skb, abort_arp_failure);
> +
> +	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_OFLD_HOST_ABORT_CON_REQ));
> +	req->wr.wr_lo = htonl(V_WR_TID(tid));
> +	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_ABORT_REQ, tid));
> +	req->rsvd0 = htonl(c3cn->snd_nxt);
> +	req->rsvd1 = !c3cn_flag(c3cn, C3CN_TX_DATA_SENT);
> +	req->cmd = CPL_ABORT_SEND_RST;
> +
> +	l2t_send(c3cn->cdev, skb, c3cn->l2t);
> +}
> +
> +/*
> + * CPL connection abort reply: host ->
> + *
> + * Send an ABORT_RPL message in response of the ABORT_REQ received.
> + */
> +static void send_abort_rpl(struct s3_conn *c3cn, int rst_status)
> +{
> +	struct sk_buff *skb = c3cn->cpl_abort_rpl;
> +	struct cpl_abort_rpl *rpl = (struct cpl_abort_rpl *)skb->head;
> +
> +	c3cn->cpl_abort_rpl = NULL;
> +
> +	skb->priority = CPL_PRIORITY_DATA;
> +	rpl->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_OFLD_HOST_ABORT_CON_RPL));
> +	rpl->wr.wr_lo = htonl(V_WR_TID(c3cn->tid));
> +	OPCODE_TID(rpl) = htonl(MK_OPCODE_TID(CPL_ABORT_RPL, c3cn->tid));
> +	rpl->cmd = rst_status;
> +
> +	cxgb3_ofld_send(c3cn->cdev, skb);
> +}
> +
> +/*
> + * CPL connection rx data ack: host ->
> + * Send RX credits through an RX_DATA_ACK CPL message. Returns the number of
> + * credits sent.
> + */
> +static u32 send_rx_credits(struct s3_conn *c3cn, u32 credits, u32 dack)
> +{
> +	struct sk_buff *skb;
> +	struct cpl_rx_data_ack *req;
> +
> +	skb = alloc_skb(sizeof(*req), GFP_ATOMIC);
> +	if (!skb)
> +		return 0;
> +
> +	req = (struct cpl_rx_data_ack *)__skb_put(skb, sizeof(*req));
> +	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
> +	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_RX_DATA_ACK, c3cn->tid));
> +	req->credit_dack = htonl(dack | V_RX_CREDITS(credits));
> +	skb->priority = CPL_PRIORITY_ACK;
> +	cxgb3_ofld_send(c3cn->cdev, skb);
> +	return credits;
> +}
> +
> +/*
> + * CPL connection tx data: host ->
> + *
> + * Send iscsi PDU via TX_DATA CPL message. Returns the number of
> + * credits sent.
> + * Each TX_DATA consumes work request credit (wrs), so we need to keep track of
> + * how many we've used so far and how many are pending (i.e., yet ack'ed by T3).
> + */
> +
> +/*
> + * For ULP connections HW may inserts digest bytes into the pdu. Those digest
> + * bytes are not sent by the host but are part of the TCP payload and therefore
> + * consume TCP sequence space.
> + */
> +static const unsigned int cxgb3_ulp_extra_len[] = { 0, 4, 4, 8 };
> +static inline unsigned int ulp_extra_len(const struct sk_buff *skb)
> +{
> +	return cxgb3_ulp_extra_len[skb_ulp_mode(skb) & 3];
> +}
> +
> +static unsigned int wrlen __read_mostly;
> +
> +/*
> + * The number of WRs needed for an skb depends on the number of fragments
> + * in the skb and whether it has any payload in its main body.  This maps the
> + * length of the gather list represented by an skb into the # of necessary WRs.
> + *
> + * The max. length of an skb is controlled by the max pdu size which is ~16K.
> + * Also, assume the min. fragment length is the sector size (512), then add
> + * extra fragment counts for iscsi bhs and payload padding.
> + */
> +#define SKB_WR_LIST_SIZE	(16384/512 + 3)
> +static unsigned int skb_wrs[SKB_WR_LIST_SIZE] __read_mostly;
> +
> +static void s3_init_wr_tab(unsigned int wr_len)
> +{
> +	int i;
> +
> +	if (skb_wrs[1])		/* already initialized */
> +		return;
> +
> +	for (i = 1; i < SKB_WR_LIST_SIZE; i++) {
> +		int sgl_len = (3 * i) / 2 + (i & 1);
> +
> +		sgl_len += 3;
> +		skb_wrs[i] = (sgl_len <= wr_len
> +			      ? 1 : 1 + (sgl_len - 2) / (wr_len - 1));
> +	}
> +
> +	wrlen = wr_len * 8;
> +}
> +
> +static inline void reset_wr_list(struct s3_conn *c3cn)
> +{
> +	c3cn->wr_pending_head = NULL;
> +}
> +
> +/*
> + * Add a WR to a connections's list of pending WRs.  This is a singly-linked
> + * list of sk_buffs operating as a FIFO.  The head is kept in wr_pending_head
> + * and the tail in wr_pending_tail.
> + */
> +static inline void enqueue_wr(struct s3_conn *c3cn,
> +			      struct sk_buff *skb)
> +{
> +	skb->sp = NULL;
> +
> +	/*
> +	 * We want to take an extra reference since both us and the driver
> +	 * need to free the packet before it's really freed. We know there's
> +	 * just one user currently so we use atomic_set rather than skb_get
> +	 * to avoid the atomic op.
> +	 */
> +	atomic_set(&skb->users, 2);
> +
> +	if (!c3cn->wr_pending_head)
> +		c3cn->wr_pending_head = skb;
> +	else
> +		c3cn->wr_pending_tail->sp = (void *)skb;
> +	c3cn->wr_pending_tail = skb;
> +}
> +
> +static inline struct sk_buff *peek_wr(const struct s3_conn *c3cn)
> +{
> +	return c3cn->wr_pending_head;
> +}
> +
> +static inline void free_wr_skb(struct sk_buff *skb)
> +{
> +	kfree_skb(skb);
> +}
> +
> +static inline struct sk_buff *dequeue_wr(struct s3_conn *c3cn)
> +{
> +	struct sk_buff *skb = c3cn->wr_pending_head;
> +
> +	if (likely(skb)) {
> +		/* Don't bother clearing the tail */
> +		c3cn->wr_pending_head = (struct sk_buff *)skb->sp;
> +		skb->sp = NULL;
> +	}
> +	return skb;
> +}
> +
> +static void purge_wr_queue(struct s3_conn *c3cn)
> +{
> +	struct sk_buff *skb;
> +	while ((skb = dequeue_wr(c3cn)) != NULL)
> +		free_wr_skb(skb);
> +}
> +
> +static inline void make_tx_data_wr(struct s3_conn *c3cn, struct sk_buff *skb,
> +				   int len)
> +{
> +	struct tx_data_wr *req;
> +
> +	skb_reset_transport_header(skb);
> +	req = (struct tx_data_wr *)__skb_push(skb, sizeof(*req));
> +	req->wr_hi = htonl(V_WR_OP(FW_WROPCODE_OFLD_TX_DATA));
> +	req->wr_lo = htonl(V_WR_TID(c3cn->tid));
> +	req->sndseq = htonl(c3cn->snd_nxt);
> +	/* len includes the length of any HW ULP additions */
> +	req->len = htonl(len);
> +	req->param = htonl(V_TX_PORT(c3cn->l2t->smt_idx));
> +	/* V_TX_ULP_SUBMODE sets both the mode and submode */
> +	req->flags = htonl(V_TX_ULP_SUBMODE(skb_ulp_mode(skb)) |
> +			   V_TX_SHOVE((skb_peek(&c3cn->write_queue) ? 0 : 1)));
> +
> +	if (!c3cn_flag(c3cn, C3CN_TX_DATA_SENT)) {
> +		req->flags |= htonl(V_TX_ACK_PAGES(2) | F_TX_INIT |
> +				    V_TX_CPU_IDX(c3cn->qset));
> +		/* Sendbuffer is in units of 32KB. */
> +		req->param |= htonl(V_TX_SNDBUF(cxgb3_snd_win >> 15));
> +		c3cn_set_flag(c3cn, C3CN_TX_DATA_SENT);
> +	}
> +}
> +
> +/**
> + * c3cn_push_tx_frames -- start transmit
> + * @c3cn: the offloaded connection
> + * @req_completion: request wr_ack or not
> + *
> + * Prepends TX_DATA_WR or CPL_CLOSE_CON_REQ headers to buffers waiting in a
> + * connection's send queue and sends them on to T3.  Must be called with the
> + * connection's lock held.  Returns the amount of send buffer space that was
> + * freed as a result of sending queued data to T3.
> + */
> +static void arp_failure_discard(struct t3cdev *cdev, struct sk_buff *skb)
> +{
> +	kfree_skb(skb);
> +}
> +
> +static int c3cn_push_tx_frames(struct s3_conn *c3cn, int req_completion)
> +{
> +	int total_size = 0;
> +	struct sk_buff *skb;
> +	struct t3cdev *cdev;
> +	struct cxgb3i_sdev_data *cdata;
> +
> +	if (unlikely(c3cn->state == C3CN_STATE_CONNECTING ||
> +		     c3cn->state == C3CN_STATE_CLOSE_WAIT_1 ||
> +		     c3cn->state == C3CN_STATE_ABORTING)) {
> +		c3cn_tx_debug("c3cn 0x%p, in closing state %u.\n",
> +			      c3cn, c3cn->state);
> +		return 0;
> +	}
> +
> +	cdev = c3cn->cdev;
> +	cdata = CXGB3_SDEV_DATA(cdev);
> +
> +	while (c3cn->wr_avail
> +	       && (skb = skb_peek(&c3cn->write_queue)) != NULL) {
> +		int len = skb->len;	/* length before skb_push */
> +		int frags = skb_shinfo(skb)->nr_frags + (len != skb->data_len);
> +		int wrs_needed = skb_wrs[frags];
> +
> +		if (wrs_needed > 1 && len + sizeof(struct tx_data_wr) <= wrlen)
> +			wrs_needed = 1;
> +
> +		WARN_ON(frags >= SKB_WR_LIST_SIZE || wrs_needed < 1);
> +
> +		if (c3cn->wr_avail < wrs_needed) {
> +			c3cn_tx_debug("c3cn 0x%p, skb len %u/%u, frag %u, "
> +				      "wr %d < %u.\n",
> +				      c3cn, skb->len, skb->datalen, frags,
> +				      wrs_needed, c3cn->wr_avail);
> +			break;
> +		}
> +
> +		__skb_unlink(skb, &c3cn->write_queue);
> +		skb->priority = CPL_PRIORITY_DATA;
> +		skb->csum = wrs_needed;	/* remember this until the WR_ACK */
> +		c3cn->wr_avail -= wrs_needed;
> +		c3cn->wr_unacked += wrs_needed;
> +		enqueue_wr(c3cn, skb);
> +
> +		if (likely(CXGB3_SKB_CB(skb)->flags & C3CB_FLAG_NEED_HDR)) {
> +			len += ulp_extra_len(skb);
> +			make_tx_data_wr(c3cn, skb, len);
> +			c3cn->snd_nxt += len;
> +			if ((req_completion
> +			     && c3cn->wr_unacked == wrs_needed)
> +			    || (CXGB3_SKB_CB(skb)->flags & C3CB_FLAG_COMPL)
> +			    || c3cn->wr_unacked >= c3cn->wr_max / 2) {
> +				struct work_request_hdr *wr = cplhdr(skb);
> +
> +				wr->wr_hi |= htonl(F_WR_COMPL);
> +				c3cn->wr_unacked = 0;
> +			}
> +			CXGB3_SKB_CB(skb)->flags &= ~C3CB_FLAG_NEED_HDR;
> +		}
> +
> +		total_size += skb->truesize;
> +		set_arp_failure_handler(skb, arp_failure_discard);
> +		l2t_send(cdev, skb, c3cn->l2t);
> +	}
> +	return total_size;
> +}
> +
> +/*
> + * process_cpl_msg: -> host
> + * Top-level CPL message processing used by most CPL messages that
> + * pertain to connections.
> + */
> +static inline void process_cpl_msg(void (*fn)(struct s3_conn *,
> +					      struct sk_buff *),
> +				   struct s3_conn *c3cn,
> +				   struct sk_buff *skb)
> +{
> +	spin_lock_bh(&c3cn->lock);
> +	fn(c3cn, skb);
> +	spin_unlock_bh(&c3cn->lock);
> +}
> +
> +/*
> + * process_cpl_msg_ref: -> host
> + * Similar to process_cpl_msg() but takes an extra connection reference around
> + * the call to the handler.  Should be used if the handler may drop a
> + * connection reference.
> + */
> +static inline void process_cpl_msg_ref(void (*fn) (struct s3_conn *,
> +						   struct sk_buff *),
> +				       struct s3_conn *c3cn,
> +				       struct sk_buff *skb)
> +{
> +	c3cn_hold(c3cn);
> +	process_cpl_msg(fn, c3cn, skb);
> +	c3cn_put(c3cn);
> +}
> +
> +/*
> + * Process a CPL_ACT_ESTABLISH message: -> host
> + * Updates connection state from an active establish CPL message.  Runs with
> + * the connection lock held.
> + */
> +
> +static inline void s3_free_atid(struct t3cdev *cdev, unsigned int tid)
> +{
> +	struct s3_conn *c3cn = cxgb3_free_atid(cdev, tid);
> +	if (c3cn)
> +		c3cn_put(c3cn);
> +}
> +
> +static void c3cn_established(struct s3_conn *c3cn, u32 snd_isn,
> +			     unsigned int opt)
> +{
> +	c3cn_conn_debug("c3cn 0x%p, state %u.\n", c3cn, c3cn->state);
> +
> +	c3cn->write_seq = c3cn->snd_nxt = c3cn->snd_una = snd_isn;
> +
> +	/*
> +	 * Causes the first RX_DATA_ACK to supply any Rx credits we couldn't
> +	 * pass through opt0.
> +	 */
> +	if (cxgb3_rcv_win > (M_RCV_BUFSIZ << 10))
> +		c3cn->rcv_wup -= cxgb3_rcv_win - (M_RCV_BUFSIZ << 10);
> +
> +	dst_confirm(c3cn->dst_cache);
> +
> +	smp_mb();
> +
> +	c3cn_set_state(c3cn, C3CN_STATE_ESTABLISHED);
> +}
> +
> +static void process_act_establish(struct s3_conn *c3cn, struct sk_buff *skb)
> +{
> +	struct cpl_act_establish *req = cplhdr(skb);
> +	u32 rcv_isn = ntohl(req->rcv_isn);	/* real RCV_ISN + 1 */
> +
> +	c3cn_conn_debug("c3cn 0x%p, state %u, flag 0x%lx.\n",
> +			c3cn, c3cn->state, c3cn->flags);
> +
> +	if (unlikely(c3cn->state != C3CN_STATE_CONNECTING))
> +		cxgb3i_log_error("TID %u expected SYN_SENT, got EST., s %u\n",
> +				 c3cn->tid, c3cn->state);
> +
> +	c3cn->copied_seq = c3cn->rcv_wup = c3cn->rcv_nxt = rcv_isn;
> +	c3cn_established(c3cn, ntohl(req->snd_isn), ntohs(req->tcp_opt));
> +
> +	__kfree_skb(skb);
> +
> +	if (unlikely(c3cn_flag(c3cn, C3CN_ACTIVE_CLOSE_NEEDED)))
> +		/* upper layer has requested closing */
> +		send_abort_req(c3cn);
> +	else if (c3cn_push_tx_frames(c3cn, 1))
> +		cxgb3i_conn_tx_open(c3cn);
> +}
> +
> +static int do_act_establish(struct t3cdev *cdev, struct sk_buff *skb,
> +			    void *ctx)
> +{
> +	struct cpl_act_establish *req = cplhdr(skb);
> +	unsigned int tid = GET_TID(req);
> +	unsigned int atid = G_PASS_OPEN_TID(ntohl(req->tos_tid));
> +	struct s3_conn *c3cn = ctx;
> +	struct cxgb3i_sdev_data *cdata = CXGB3_SDEV_DATA(cdev);
> +
> +	c3cn_conn_debug("rcv, tid 0x%x, c3cn 0x%p, s %u, f 0x%lx.\n",
> +			tid, c3cn, c3cn->state, c3cn->flags);
> +
> +	c3cn->tid = tid;
> +	c3cn_hold(c3cn);
> +	cxgb3_insert_tid(cdata->cdev, cdata->client, c3cn, tid);
> +	s3_free_atid(cdev, atid);
> +
> +	c3cn->qset = G_QNUM(ntohl(skb->csum));
> +
> +	process_cpl_msg(process_act_establish, c3cn, skb);
> +	return 0;
> +}
> +
> +/*
> + * Process a CPL_ACT_OPEN_RPL message: -> host
> + * Handle active open failures.
> + */
> +static int act_open_rpl_status_to_errno(int status)
> +{
> +	switch (status) {
> +	case CPL_ERR_CONN_RESET:
> +		return ECONNREFUSED;
> +	case CPL_ERR_ARP_MISS:
> +		return EHOSTUNREACH;
> +	case CPL_ERR_CONN_TIMEDOUT:
> +		return ETIMEDOUT;
> +	case CPL_ERR_TCAM_FULL:
> +		return ENOMEM;
> +	case CPL_ERR_CONN_EXIST:
> +		cxgb3i_log_error("ACTIVE_OPEN_RPL: 4-tuple in use\n");
> +		return EADDRINUSE;
> +	default:
> +		return EIO;
> +	}
> +}
> +
> +static void act_open_retry_timer(unsigned long data)
> +{
> +	struct sk_buff *skb;
> +	struct s3_conn *c3cn = (struct s3_conn *)data;
> +
> +	c3cn_conn_debug("c3cn 0x%p, state %u.\n", c3cn, c3cn->state);
> +
> +	spin_lock_bh(&c3cn->lock);
> +	skb = alloc_skb(sizeof(struct cpl_act_open_req), GFP_ATOMIC);
> +	if (!skb)
> +		fail_act_open(c3cn, ENOMEM);
> +	else {
> +		skb->sk = (struct sock *)c3cn;
> +		set_arp_failure_handler(skb, act_open_req_arp_failure);
> +		make_act_open_req(c3cn, skb, c3cn->tid, c3cn->l2t);
> +		l2t_send(c3cn->cdev, skb, c3cn->l2t);
> +	}
> +	spin_unlock_bh(&c3cn->lock);
> +	c3cn_put(c3cn);
> +}
> +
> +static void process_act_open_rpl(struct s3_conn *c3cn, struct sk_buff *skb)
> +{
> +	struct cpl_act_open_rpl *rpl = cplhdr(skb);
> +
> +	c3cn_conn_debug("c3cn 0x%p, state %u, flag 0x%lx.\n",
> +			c3cn, c3cn->state, c3cn->flags);
> +
> +	if (rpl->status == CPL_ERR_CONN_EXIST &&
> +	    c3cn->retry_timer.function != act_open_retry_timer) {
> +		c3cn->retry_timer.function = act_open_retry_timer;
> +		if (!mod_timer(&c3cn->retry_timer, jiffies + HZ / 2))
> +			c3cn_hold(c3cn);
> +	} else
> +		fail_act_open(c3cn, act_open_rpl_status_to_errno(rpl->status));
> +	__kfree_skb(skb);
> +}
> +
> +static int do_act_open_rpl(struct t3cdev *cdev, struct sk_buff *skb, void *ctx)
> +{
> +	struct s3_conn *c3cn = ctx;
> +	struct cpl_act_open_rpl *rpl = cplhdr(skb);
> +
> +	c3cn_conn_debug("rcv, status 0x%x, c3cn 0x%p, s %u, f 0x%lx.\n",
> +			rpl->status, c3cn, c3cn->state, c3cn->flags);
> +
> +	if (rpl->status != CPL_ERR_TCAM_FULL &&
> +	    rpl->status != CPL_ERR_CONN_EXIST &&
> +	    rpl->status != CPL_ERR_ARP_MISS)
> +		cxgb3_queue_tid_release(cdev, GET_TID(rpl));
> +
> +	process_cpl_msg_ref(process_act_open_rpl, c3cn, skb);
> +	return 0;
> +}
> +
> +/*
> + * Process PEER_CLOSE CPL messages: -> host
> + * Handle peer FIN.
> + */
> +static void process_peer_close(struct s3_conn *c3cn, struct sk_buff *skb)
> +{
> +	c3cn_conn_debug("c3cn 0x%p, state %u, flag 0x%lx.\n",
> +			c3cn, c3cn->state, c3cn->flags);
> +
> +	if (c3cn_flag(c3cn, C3CN_ABORT_RPL_PENDING))
> +		goto out;
> +
> +	switch (c3cn->state) {
> +	case C3CN_STATE_ESTABLISHED:
> +		c3cn_set_state(c3cn, C3CN_STATE_PASSIVE_CLOSE);
> +		break;
> +	case C3CN_STATE_ACTIVE_CLOSE:
> +		c3cn_set_state(c3cn, C3CN_STATE_CLOSE_WAIT_2);
> +		break;
> +	case C3CN_STATE_CLOSE_WAIT_1:
> +		c3cn_closed(c3cn);
> +		break;
> +	case C3CN_STATE_ABORTING:
> +		break;
> +	default:
> +		cxgb3i_log_error("%s: peer close, TID %u in bad state %u\n",
> +				 c3cn->cdev->name, c3cn->tid, c3cn->state);
> +	}
> +
> +	cxgb3i_conn_closing(c3cn);
> +out:
> +	__kfree_skb(skb);
> +}
> +
> +static int do_peer_close(struct t3cdev *cdev, struct sk_buff *skb, void *ctx)
> +{
> +	struct s3_conn *c3cn = ctx;
> +
> +	c3cn_conn_debug("rcv, c3cn 0x%p, s %u, f 0x%lx.\n",
> +			c3cn, c3cn->state, c3cn->flags);
> +	process_cpl_msg_ref(process_peer_close, c3cn, skb);
> +	return 0;
> +}
> +
> +/*
> + * Process CLOSE_CONN_RPL CPL message: -> host
> + * Process a peer ACK to our FIN.
> + */
> +static void process_close_con_rpl(struct s3_conn *c3cn, struct sk_buff *skb)
> +{
> +	struct cpl_close_con_rpl *rpl = cplhdr(skb);
> +
> +	c3cn_conn_debug("c3cn 0x%p, state %u, flag 0x%lx.\n",
> +			c3cn, c3cn->state, c3cn->flags);
> +
> +	c3cn->snd_una = ntohl(rpl->snd_nxt) - 1;	/* exclude FIN */
> +
> +	if (c3cn_flag(c3cn, C3CN_ABORT_RPL_PENDING))
> +		goto out;
> +
> +	switch (c3cn->state) {
> +	case C3CN_STATE_ACTIVE_CLOSE:
> +		c3cn_set_state(c3cn, C3CN_STATE_CLOSE_WAIT_1);
> +		break;
> +	case C3CN_STATE_CLOSE_WAIT_1:
> +	case C3CN_STATE_CLOSE_WAIT_2:
> +		c3cn_closed(c3cn);
> +		break;
> +	case C3CN_STATE_ABORTING:
> +		break;
> +	default:
> +		cxgb3i_log_error("%s: close_rpl, TID %u in bad state %u\n",
> +				 c3cn->cdev->name, c3cn->tid, c3cn->state);
> +	}
> +
> +out:
> +	kfree_skb(skb);
> +}
> +
> +static int do_close_con_rpl(struct t3cdev *cdev, struct sk_buff *skb,
> +			    void *ctx)
> +{
> +	struct s3_conn *c3cn = ctx;
> +
> +	c3cn_conn_debug("rcv, c3cn 0x%p, s %u, f 0x%lx.\n",
> +			 c3cn, c3cn->state, c3cn->flags);
> +
> +	process_cpl_msg_ref(process_close_con_rpl, c3cn, skb);
> +	return 0;
> +}
> +
> +/*
> + * Process ABORT_REQ_RSS CPL message: -> host
> + * Process abort requests.  If we are waiting for an ABORT_RPL we ignore this
> + * request except that we need to reply to it.
> + */
> +
> +static int abort_status_to_errno(struct s3_conn *c3cn, int abort_reason,
> +				 int *need_rst)
> +{
> +	switch (abort_reason) {
> +	case CPL_ERR_BAD_SYN: /* fall through */
> +	case CPL_ERR_CONN_RESET:
> +		return c3cn->state > C3CN_STATE_ESTABLISHED ?
> +			EPIPE : ECONNRESET;
> +	case CPL_ERR_XMIT_TIMEDOUT:
> +	case CPL_ERR_PERSIST_TIMEDOUT:
> +	case CPL_ERR_FINWAIT2_TIMEDOUT:
> +	case CPL_ERR_KEEPALIVE_TIMEDOUT:
> +		return ETIMEDOUT;
> +	default:
> +		return EIO;
> +	}
> +}
> +
> +static void process_abort_req(struct s3_conn *c3cn, struct sk_buff *skb)
> +{
> +	int rst_status = CPL_ABORT_NO_RST;
> +	const struct cpl_abort_req_rss *req = cplhdr(skb);
> +
> +	c3cn_conn_debug("c3cn 0x%p, state %u, flag 0x%lx.\n",
> +			c3cn, c3cn->state, c3cn->flags);
> +
> +	if (!c3cn_flag(c3cn, C3CN_ABORT_REQ_RCVD)) {
> +		c3cn_set_flag(c3cn, C3CN_ABORT_REQ_RCVD);
> +		c3cn_set_state(c3cn, C3CN_STATE_ABORTING);
> +		__kfree_skb(skb);
> +		return;
> +	}
> +
> +	c3cn_clear_flag(c3cn, C3CN_ABORT_REQ_RCVD);
> +	send_abort_rpl(c3cn, rst_status);
> +
> +	if (!c3cn_flag(c3cn, C3CN_ABORT_RPL_PENDING)) {
> +		c3cn->err =
> +		    abort_status_to_errno(c3cn, req->status, &rst_status);
> +		c3cn_closed(c3cn);
> +	}
> +}
> +
> +static int do_abort_req(struct t3cdev *cdev, struct sk_buff *skb, void *ctx)
> +{
> +	const struct cpl_abort_req_rss *req = cplhdr(skb);
> +	struct s3_conn *c3cn = ctx;
> +
> +	c3cn_conn_debug("rcv, c3cn 0x%p, s 0x%x, f 0x%lx.\n",
> +			c3cn, c3cn->state, c3cn->flags);
> +
> +	if (req->status == CPL_ERR_RTX_NEG_ADVICE ||
> +	    req->status == CPL_ERR_PERSIST_NEG_ADVICE) {
> +		__kfree_skb(skb);
> +		return 0;
> +	}
> +
> +	process_cpl_msg_ref(process_abort_req, c3cn, skb);
> +	return 0;
> +}
> +
> +/*
> + * Process ABORT_RPL_RSS CPL message: -> host
> + * Process abort replies.  We only process these messages if we anticipate
> + * them as the coordination between SW and HW in this area is somewhat lacking
> + * and sometimes we get ABORT_RPLs after we are done with the connection that
> + * originated the ABORT_REQ.
> + */
> +static void process_abort_rpl(struct s3_conn *c3cn, struct sk_buff *skb)
> +{
> +	c3cn_conn_debug("c3cn 0x%p, state %u, flag 0x%lx.\n",
> +			c3cn, c3cn->state, c3cn->flags);
> +
> +	if (c3cn_flag(c3cn, C3CN_ABORT_RPL_PENDING)) {
> +		if (!c3cn_flag(c3cn, C3CN_ABORT_RPL_RCVD))
> +			c3cn_set_flag(c3cn, C3CN_ABORT_RPL_RCVD);
> +		else {
> +			c3cn_clear_flag(c3cn, C3CN_ABORT_RPL_RCVD);
> +			c3cn_clear_flag(c3cn, C3CN_ABORT_RPL_PENDING);
> +			if (c3cn_flag(c3cn, C3CN_ABORT_REQ_RCVD))
> +				cxgb3i_log_error("%s tid %u, ABORT_RPL_RSS\n",
> +						 c3cn->cdev->name, c3cn->tid);
> +			c3cn_closed(c3cn);
> +		}
> +	}
> +	__kfree_skb(skb);
> +}
> +
> +static int do_abort_rpl(struct t3cdev *cdev, struct sk_buff *skb, void *ctx)
> +{
> +	struct cpl_abort_rpl_rss *rpl = cplhdr(skb);
> +	struct s3_conn *c3cn = ctx;
> +
> +	c3cn_conn_debug("rcv, status 0x%x, c3cn 0x%p, s %u, 0x%lx.\n",
> +			rpl->status, c3cn, c3cn ? c3cn->state : 0,
> +			c3cn ? c3cn->flags : 0UL);
> +
> +	/*
> +	 * Ignore replies to post-close aborts indicating that the abort was
> +	 * requested too late.  These connections are terminated when we get
> +	 * PEER_CLOSE or CLOSE_CON_RPL and by the time the abort_rpl_rss
> +	 * arrives the TID is either no longer used or it has been recycled.
> +	 */
> +	if (rpl->status == CPL_ERR_ABORT_FAILED)
> +		goto discard;
> +
> +	/*
> +	 * Sometimes we've already closed the connection, e.g., a post-close
> +	 * abort races with ABORT_REQ_RSS, the latter frees the connection
> +	 * expecting the ABORT_REQ will fail with CPL_ERR_ABORT_FAILED,
> +	 * but FW turns the ABORT_REQ into a regular one and so we get
> +	 * ABORT_RPL_RSS with status 0 and no connection.
> +	 */
> +	if (!c3cn)
> +		goto discard;
> +
> +	process_cpl_msg_ref(process_abort_rpl, c3cn, skb);
> +	return 0;
> +
> +discard:
> +	__kfree_skb(skb);
> +	return 0;
> +}
> +
> +/*
> + * Process RX_ISCSI_HDR CPL message: -> host
> + * Handle received PDUs, the payload could be DDP'ed. If not, the payload
> + * follow after the bhs.
> + */
> +static void process_rx_iscsi_hdr(struct s3_conn *c3cn, struct sk_buff *skb)
> +{
> +	struct cpl_iscsi_hdr *hdr_cpl = cplhdr(skb);
> +	struct cpl_iscsi_hdr_norss data_cpl;
> +	struct cpl_rx_data_ddp_norss ddp_cpl;
> +	unsigned int hdr_len, data_len, status;
> +	unsigned int len;
> +	int err;
> +
> +	if (unlikely(c3cn->state >= C3CN_STATE_PASSIVE_CLOSE)) {
> +		if (c3cn->state != C3CN_STATE_ABORTING)
> +			send_abort_req(c3cn);
> +		__kfree_skb(skb);
> +		return;
> +	}
> +
> +	CXGB3_SKB_CB(skb)->seq = ntohl(hdr_cpl->seq);
> +	CXGB3_SKB_CB(skb)->flags = 0;
> +
> +	skb_reset_transport_header(skb);
> +	__skb_pull(skb, sizeof(struct cpl_iscsi_hdr));
> +
> +	len = hdr_len = ntohs(hdr_cpl->len);
> +	/* msg coalesce is off or not enough data received */
> +	if (skb->len <= hdr_len) {
> +		cxgb3i_log_error("%s: TID %u, ISCSI_HDR, skb len %u < %u.\n",
> +				 c3cn->cdev->name, c3cn->tid,
> +				 skb->len, hdr_len);
> +		goto abort_conn;
> +	}
> +
> +	err = skb_copy_bits(skb, skb->len - sizeof(ddp_cpl), &ddp_cpl,
> +			    sizeof(ddp_cpl));
> +	if (err < 0)
> +		goto abort_conn;
> +
> +	skb_ulp_mode(skb) = ULP2_FLAG_DATA_READY;
> +	skb_ulp_pdulen(skb) = ntohs(ddp_cpl.len);
> +	skb_ulp_ddigest(skb) = ntohl(ddp_cpl.ulp_crc);
> +	status = ntohl(ddp_cpl.ddp_status);
> +
> +	c3cn_rx_debug("rx skb 0x%p, len %u, pdulen %u, ddp status 0x%x.\n",
> +		      skb, skb->len, skb_ulp_pdulen(skb), status);
> +
> +	if (status & (1 << RX_DDP_STATUS_HCRC_SHIFT))
> +		skb_ulp_mode(skb) |= ULP2_FLAG_HCRC_ERROR;
> +	if (status & (1 << RX_DDP_STATUS_DCRC_SHIFT))
> +		skb_ulp_mode(skb) |= ULP2_FLAG_DCRC_ERROR;
> +	if (status & (1 << RX_DDP_STATUS_PAD_SHIFT))
> +		skb_ulp_mode(skb) |= ULP2_FLAG_PAD_ERROR;
> +
> +	if (skb->len > (hdr_len + sizeof(ddp_cpl))) {
> +		err = skb_copy_bits(skb, hdr_len, &data_cpl, sizeof(data_cpl));
> +		if (err < 0)
> +			goto abort_conn;
> +		data_len = ntohs(data_cpl.len);
> +		len += sizeof(data_cpl) + data_len;
> +	} else if (status & (1 << RX_DDP_STATUS_DDP_SHIFT))
> +		skb_ulp_mode(skb) |= ULP2_FLAG_DATA_DDPED;
> +
> +	c3cn->rcv_nxt = ntohl(ddp_cpl.seq) + skb_ulp_pdulen(skb);
> +	__pskb_trim(skb, len);
> +	__skb_queue_tail(&c3cn->receive_queue, skb);
> +	cxgb3i_conn_pdu_ready(c3cn);
> +
> +	return;
> +
> +abort_conn:
> +	send_abort_req(c3cn);
> +	__kfree_skb(skb);
> +}
> +
> +static int do_iscsi_hdr(struct t3cdev *t3dev, struct sk_buff *skb, void *ctx)
> +{
> +	struct s3_conn *c3cn = ctx;
> +
> +	process_cpl_msg(process_rx_iscsi_hdr, c3cn, skb);
> +	return 0;
> +}
> +
> +/*
> + * Process TX_DATA_ACK CPL messages: -> host
> + * Process an acknowledgment of WR completion.  Advance snd_una and send the
> + * next batch of work requests from the write queue.
> + */
> +static void process_wr_ack(struct s3_conn *c3cn, struct sk_buff *skb)
> +{
> +	struct cpl_wr_ack *hdr = cplhdr(skb);
> +	unsigned int credits = ntohs(hdr->credits);
> +	u32 snd_una = ntohl(hdr->snd_una);
> +
> +	c3cn->wr_avail += credits;
> +	if (c3cn->wr_unacked > c3cn->wr_max - c3cn->wr_avail)
> +		c3cn->wr_unacked = c3cn->wr_max - c3cn->wr_avail;
> +
> +	while (credits) {
> +		struct sk_buff *p = peek_wr(c3cn);
> +
> +		if (unlikely(!p)) {
> +			cxgb3i_log_error("%u WR_ACK credits for TID %u with "
> +					 "nothing pending, state %u\n",
> +					 credits, c3cn->tid, c3cn->state);
> +			break;
> +		}
> +		if (unlikely(credits < p->csum)) {
> +			p->csum -= credits;
> +			break;
> +		} else {
> +			dequeue_wr(c3cn);
> +			credits -= p->csum;
> +			free_wr_skb(p);
> +		}
> +	}
> +
> +	if (unlikely(before(snd_una, c3cn->snd_una)))
> +		goto out_free;
> +
> +	if (c3cn->snd_una != snd_una) {
> +		c3cn->snd_una = snd_una;
> +		dst_confirm(c3cn->dst_cache);
> +	}
> +
> +	if (skb_queue_len(&c3cn->write_queue) && c3cn_push_tx_frames(c3cn, 0))
> +		cxgb3i_conn_tx_open(c3cn);
> +out_free:
> +	__kfree_skb(skb);
> +}
> +
> +static int do_wr_ack(struct t3cdev *cdev, struct sk_buff *skb, void *ctx)
> +{
> +	struct s3_conn *c3cn = ctx;
> +
> +	process_cpl_msg(process_wr_ack, c3cn, skb);
> +	return 0;
> +}
> +
> +/*
> + * for each connection, pre-allocate skbs needed for close/abort requests. So
> + * that we can service the request right away.
> + */
> +static void c3cn_free_cpl_skbs(struct s3_conn *c3cn)
> +{
> +	if (c3cn->cpl_close)
> +		kfree_skb(c3cn->cpl_close);
> +	if (c3cn->cpl_abort_req)
> +		kfree_skb(c3cn->cpl_abort_req);
> +	if (c3cn->cpl_abort_rpl)
> +		kfree_skb(c3cn->cpl_abort_rpl);
> +}
> +
> +static int c3cn_alloc_cpl_skbs(struct s3_conn *c3cn)
> +{
> +	c3cn->cpl_close = alloc_skb(sizeof(struct cpl_close_con_req),
> +				   GFP_KERNEL);
> +	if (!c3cn->cpl_close)
> +		return -ENOMEM;
> +	skb_put(c3cn->cpl_close, sizeof(struct cpl_close_con_req));
> +
> +	c3cn->cpl_abort_req = alloc_skb(sizeof(struct cpl_abort_req),
> +					GFP_KERNEL);
> +	if (!c3cn->cpl_abort_req)
> +		goto free_cpl_skbs;
> +	skb_put(c3cn->cpl_abort_req, sizeof(struct cpl_abort_req));
> +
> +	c3cn->cpl_abort_rpl = alloc_skb(sizeof(struct cpl_abort_rpl),
> +					GFP_KERNEL);
> +	if (!c3cn->cpl_abort_rpl)
> +		goto free_cpl_skbs;
> +	skb_put(c3cn->cpl_abort_rpl, sizeof(struct cpl_abort_rpl));
> +
> +	return 0;
> +
> +free_cpl_skbs:
> +	c3cn_free_cpl_skbs(c3cn);
> +	return -ENOMEM;
> +}
> +
> +/**
> + * c3cn_release_offload_resources - release offload resource
> + * @c3cn: the offloaded iscsi tcp connection.
> + * Release resources held by an offload connection (TID, L2T entry, etc.)
> + */
> +static void c3cn_release_offload_resources(struct s3_conn *c3cn)
> +{
> +	struct t3cdev *cdev = c3cn->cdev;
> +	unsigned int tid = c3cn->tid;
> +
> +	if (!cdev)
> +		return;
> +
> +	c3cn->qset = 0;
> +
> +	c3cn_free_cpl_skbs(c3cn);
> +
> +	if (c3cn->wr_avail != c3cn->wr_max) {
> +		purge_wr_queue(c3cn);
> +		reset_wr_list(c3cn);
> +	}
> +
> +	if (c3cn->l2t) {
> +		l2t_release(L2DATA(cdev), c3cn->l2t);
> +		c3cn->l2t = NULL;
> +	}
> +
> +	if (c3cn->state == C3CN_STATE_CONNECTING) /* we have ATID */
> +		s3_free_atid(cdev, tid);
> +	else {		/* we have TID */
> +		cxgb3_remove_tid(cdev, (void *)c3cn, tid);
> +		c3cn_put(c3cn);
> +	}
> +
> +	c3cn->cdev = NULL;
> +}
> +
> +/**
> + * cxgb3i_c3cn_create - allocate and initialize an s3_conn structure
> + * returns the s3_conn structure allocated.
> + */
> +struct s3_conn *cxgb3i_c3cn_create(void)
> +{
> +	struct s3_conn *c3cn;
> +
> +	c3cn = kzalloc(sizeof(*c3cn), GFP_KERNEL);
> +	if (!c3cn)
> +		return NULL;
> +
> +	/* pre-allocate close/abort cpl, so we don't need to wait for memory
> +	   when close/abort is requested. */
> +	if (c3cn_alloc_cpl_skbs(c3cn) < 0)
> +		goto free_c3cn;
> +
> +	c3cn_conn_debug("alloc c3cn 0x%p.\n", c3cn);
> +
> +	c3cn->flags = 0;
> +	spin_lock_init(&c3cn->lock);
> +	atomic_set(&c3cn->refcnt, 1);
> +	skb_queue_head_init(&c3cn->receive_queue);
> +	skb_queue_head_init(&c3cn->write_queue);
> +	setup_timer(&c3cn->retry_timer, NULL, (unsigned long)c3cn);
> +	rwlock_init(&c3cn->callback_lock);
> +
> +	return c3cn;
> +
> +free_c3cn:
> +	kfree(c3cn);
> +	return NULL;
> +}
> +
> +static void c3cn_active_close(struct s3_conn *c3cn)
> +{
> +	int data_lost;
> +	int close_req = 0;
> +
> +	c3cn_conn_debug("c3cn 0x%p, state %u, flag 0x%lx.\n",
> +			 c3cn, c3cn->state, c3cn->flags);
> +
> +	dst_confirm(c3cn->dst_cache);
> +
> +	c3cn_hold(c3cn);
> +	spin_lock_bh(&c3cn->lock);
> +
> +	data_lost = skb_queue_len(&c3cn->receive_queue);
> +	__skb_queue_purge(&c3cn->receive_queue);
> +
> +	switch (c3cn->state) {
> +	case C3CN_STATE_CLOSED:
> +	case C3CN_STATE_ACTIVE_CLOSE:
> +	case C3CN_STATE_CLOSE_WAIT_1:
> +	case C3CN_STATE_CLOSE_WAIT_2:
> +	case C3CN_STATE_ABORTING:
> +		/* nothing need to be done */
> +		break;
> +	case C3CN_STATE_CONNECTING:
> +		/* defer until cpl_act_open_rpl or cpl_act_establish */
> +		c3cn_set_flag(c3cn, C3CN_ACTIVE_CLOSE_NEEDED);
> +		break;
> +	case C3CN_STATE_ESTABLISHED:
> +		close_req = 1;
> +		c3cn_set_state(c3cn, C3CN_STATE_ACTIVE_CLOSE);
> +		break;
> +	case C3CN_STATE_PASSIVE_CLOSE:
> +		close_req = 1;
> +		c3cn_set_state(c3cn, C3CN_STATE_CLOSE_WAIT_2);
> +		break;
> +	}
> +
> +	if (close_req) {
> +		if (data_lost)
> +			/* Unread data was tossed, zap the connection. */
> +			send_abort_req(c3cn);
> +		else
> +			send_close_req(c3cn);
> +	}
> +
> +	spin_unlock_bh(&c3cn->lock);
> +	c3cn_put(c3cn);
> +}
> +
> +/**
> + * cxgb3i_c3cn_release - close and release an iscsi tcp connection and any
> + * 	resource held
> + * @c3cn: the iscsi tcp connection
> + */
> +void cxgb3i_c3cn_release(struct s3_conn *c3cn)
> +{
> +	c3cn_conn_debug("c3cn 0x%p, s %u, f 0x%lx.\n",
> +			c3cn, c3cn->state, c3cn->flags);
> +	if (likely(c3cn->state != C3CN_STATE_CONNECTING))
> +		c3cn_active_close(c3cn);
> +	else
> +		c3cn_set_flag(c3cn, C3CN_ACTIVE_CLOSE_NEEDED);
> +	c3cn_put(c3cn);
> +}
> +
> +static int is_cxgb3_dev(struct net_device *dev)
> +{
> +	struct cxgb3i_sdev_data *cdata;
> +
> +	write_lock(&cdata_rwlock);
> +	list_for_each_entry(cdata, &cdata_list, list) {
> +		struct adap_ports *ports = &cdata->ports;
> +		int i;
> +
> +		for (i = 0; i < ports->nports; i++)
> +			if (dev == ports->lldevs[i]) {
> +				write_unlock(&cdata_rwlock);
> +				return 1;
> +			}
> +	}
> +	write_unlock(&cdata_rwlock);
> +	return 0;
> +}
> +
> +/**
> + * cxgb3_egress_dev - return the cxgb3 egress device
> + * @root_dev: the root device anchoring the search
> + * @c3cn: the connection used to determine egress port in bonding mode
> + * @context: in bonding mode, indicates a connection set up or failover
> + *
> + * Return egress device or NULL if the egress device isn't one of our ports.
> + */
> +static struct net_device *cxgb3_egress_dev(struct net_device *root_dev,
> +					   struct s3_conn *c3cn,
> +					   int context)
> +{
> +	while (root_dev) {
> +		if (root_dev->priv_flags & IFF_802_1Q_VLAN)
> +			root_dev = vlan_dev_real_dev(root_dev);
> +		else if (is_cxgb3_dev(root_dev))
> +			return root_dev;
> +		else
> +			return NULL;
> +	}
> +	return NULL;
> +}
> +
> +static struct rtable *find_route(__be32 saddr, __be32 daddr,
> +				 __be16 sport, __be16 dport)
> +{
> +	struct rtable *rt;
> +	struct flowi fl = {
> +		.oif = 0,
> +		.nl_u = {
> +			 .ip4_u = {
> +				   .daddr = daddr,
> +				   .saddr = saddr,
> +				   .tos = 0 } },
> +		.proto = IPPROTO_TCP,
> +		.uli_u = {
> +			  .ports = {
> +				    .sport = sport,
> +				    .dport = dport } } };
> +
> +	if (ip_route_output_flow(&init_net, &rt, &fl, NULL, 0))
> +		return NULL;
> +	return rt;
> +}
> +
> +/*
> + * Assign offload parameters to some connection fields.
> + */
> +static void init_offload_conn(struct s3_conn *c3cn,
> +			      struct t3cdev *cdev,
> +			      struct dst_entry *dst)
> +{
> +	BUG_ON(c3cn->cdev != cdev);
> +	c3cn->wr_max = c3cn->wr_avail = T3C_DATA(cdev)->max_wrs;
> +	c3cn->wr_unacked = 0;
> +	c3cn->mss_idx = select_mss(c3cn, dst_mtu(dst));
> +
> +	reset_wr_list(c3cn);
> +}
> +
> +static int initiate_act_open(struct s3_conn *c3cn, struct net_device *dev)
> +{
> +	struct cxgb3i_sdev_data *cdata = NDEV2CDATA(dev);
> +	struct t3cdev *cdev = cdata->cdev;
> +	struct dst_entry *dst = c3cn->dst_cache;
> +	struct sk_buff *skb;
> +
> +	c3cn_conn_debug("c3cn 0x%p, state %u, flag 0x%lx.\n",
> +			c3cn, c3cn->state, c3cn->flags);
> +	/*
> +	 * Initialize connection data.  Note that the flags and ULP mode are
> +	 * initialized higher up ...
> +	 */
> +	c3cn->dev = dev;
> +	c3cn->cdev = cdev;
> +	c3cn->tid = cxgb3_alloc_atid(cdev, cdata->client, c3cn);
> +	if (c3cn->tid < 0)
> +		goto out_err;
> +
> +	c3cn->qset = 0;
> +	c3cn->l2t = t3_l2t_get(cdev, dst->neighbour, dev);
> +	if (!c3cn->l2t)
> +		goto free_tid;
> +
> +	skb = alloc_skb(sizeof(struct cpl_act_open_req), GFP_KERNEL);
> +	if (!skb)
> +		goto free_l2t;
> +
> +	skb->sk = (struct sock *)c3cn;
> +	set_arp_failure_handler(skb, act_open_req_arp_failure);
> +
> +	c3cn_hold(c3cn);
> +
> +	init_offload_conn(c3cn, cdev, dst);
> +	c3cn->err = 0;
> +
> +	make_act_open_req(c3cn, skb, c3cn->tid, c3cn->l2t);
> +	l2t_send(cdev, skb, c3cn->l2t);
> +	return 0;
> +
> +free_l2t:
> +	l2t_release(L2DATA(cdev), c3cn->l2t);
> +free_tid:
> +	s3_free_atid(cdev, c3cn->tid);
> +	c3cn->tid = 0;
> +out_err:
> +	return -1;
> +}
> +
> +
> +/**
> + * cxgb3i_c3cn_connect - initiates an iscsi tcp connection to a given address
> + * @c3cn: the iscsi tcp connection
> + * @usin: destination address
> + *
> + * return 0 if active open request is sent, < 0 otherwise.
> + */
> +int cxgb3i_c3cn_connect(struct s3_conn *c3cn, struct sockaddr_in *usin)
> +{
> +	struct rtable *rt;
> +	struct net_device *dev;
> +	struct cxgb3i_sdev_data *cdata;
> +	struct t3cdev *cdev;
> +	__be32 sipv4;
> +	int err;
> +
> +	if (usin->sin_family != AF_INET)
> +		return -EAFNOSUPPORT;
> +
> +	c3cn->daddr.sin_port = usin->sin_port;
> +	c3cn->daddr.sin_addr.s_addr = usin->sin_addr.s_addr;
> +
> +	rt = find_route(c3cn->saddr.sin_addr.s_addr,
> +			c3cn->daddr.sin_addr.s_addr,
> +			c3cn->saddr.sin_port,
> +			c3cn->daddr.sin_port);
> +	if (rt == NULL) {
> +		c3cn_conn_debug("NO route to 0x%x, port %u.\n",
> +				c3cn->daddr.sin_addr.s_addr,
> +				ntohs(c3cn->daddr.sin_port));
> +		return -ENETUNREACH;
> +	}
> +
> +	if (rt->rt_flags & (RTCF_MULTICAST | RTCF_BROADCAST)) {
> +		c3cn_conn_debug("multi-cast route to 0x%x, port %u.\n",
> +				c3cn->daddr.sin_addr.s_addr,
> +				ntohs(c3cn->daddr.sin_port));
> +		ip_rt_put(rt);
> +		return -ENETUNREACH;
> +	}
> +
> +	if (!c3cn->saddr.sin_addr.s_addr)
> +		c3cn->saddr.sin_addr.s_addr = rt->rt_src;
> +
> +	/* now commit destination to connection */
> +	c3cn->dst_cache = &rt->u.dst;
> +
> +	/* try to establish an offloaded connection */
> +	dev = cxgb3_egress_dev(c3cn->dst_cache->dev, c3cn, 0);
> +	if (dev == NULL) {
> +		c3cn_conn_debug("c3cn 0x%p, egress dev NULL.\n", c3cn);
> +		return -ENETUNREACH;
> +	}
> +	cdata = NDEV2CDATA(dev);
> +	cdev = cdata->cdev;
> +
> +	/* get a source port if one hasn't been provided */
> +	err = c3cn_get_port(c3cn, cdata);
> +	if (err)
> +		return err;
> +
> +	c3cn_conn_debug("c3cn 0x%p get port %u.\n",
> +			c3cn, ntohs(c3cn->saddr.sin_port));
> +
> +	sipv4 = cxgb3i_get_private_ipv4addr(dev);
> +	if (!sipv4) {
> +		c3cn_conn_debug("c3cn 0x%p, iscsi ip not configured.\n", c3cn);
> +		sipv4 = c3cn->saddr.sin_addr.s_addr;
> +		cxgb3i_set_private_ipv4addr(dev, sipv4);
> +	} else
> +		c3cn->saddr.sin_addr.s_addr = sipv4;
> +
> +	c3cn_conn_debug("c3cn 0x%p, %u.%u.%u.%u,%u-%u.%u.%u.%u,%u SYN_SENT.\n",
> +			c3cn, NIPQUAD(c3cn->saddr.sin_addr.s_addr),
> +			ntohs(c3cn->saddr.sin_port),
> +			NIPQUAD(c3cn->daddr.sin_addr.s_addr),
> +			ntohs(c3cn->daddr.sin_port));
> +
> +	c3cn_set_state(c3cn, C3CN_STATE_CONNECTING);
> +	if (!initiate_act_open(c3cn, dev))
> +		return 0;
> +
> +	/*
> +	 * If we get here, we don't have an offload connection so simply
> +	 * return a failure.
> +	 */
> +	err = -ENOTSUPP;
> +
> +	/*
> +	 * This trashes the connection and releases the local port,
> +	 * if necessary.
> +	 */
> +	c3cn_conn_debug("c3cn 0x%p -> CLOSED.\n", c3cn);
> +	c3cn_set_state(c3cn, C3CN_STATE_CLOSED);
> +	ip_rt_put(rt);
> +	c3cn_put_port(c3cn);
> +	c3cn->daddr.sin_port = 0;
> +	return err;
> +}
> +
> +/**
> + * cxgb3i_c3cn_rx_credits - ack received tcp data.
> + * @c3cn: iscsi tcp connection
> + * @copied: # of bytes processed
> + *
> + * Called after some received data has been read.  It returns RX credits
> + * to the HW for the amount of data processed.
> + */
> +void cxgb3i_c3cn_rx_credits(struct s3_conn *c3cn, int copied)
> +{
> +	struct t3cdev *cdev;
> +	int must_send;
> +	u32 credits, dack = 0;
> +
> +	if (c3cn->state != C3CN_STATE_ESTABLISHED)
> +		return;
> +
> +	credits = c3cn->copied_seq - c3cn->rcv_wup;
> +	if (unlikely(!credits))
> +		return;
> +
> +	cdev = c3cn->cdev;
> +
> +	if (unlikely(cxgb3_rx_credit_thres == 0))
> +		return;
> +
> +	dack = F_RX_DACK_CHANGE | V_RX_DACK_MODE(1);
> +
> +	/*
> +	 * For coalescing to work effectively ensure the receive window has
> +	 * at least 16KB left.
> +	 */
> +	must_send = credits + 16384 >= cxgb3_rcv_win;
> +
> +	if (must_send || credits >= cxgb3_rx_credit_thres)
> +		c3cn->rcv_wup += send_rx_credits(c3cn, credits, dack);
> +}
> +
> +/**
> + * cxgb3i_c3cn_send_pdus - send the skbs containing iscsi pdus
> + * @c3cn: iscsi tcp connection
> + * @skb: skb contains the iscsi pdu
> + *
> + * Add a list of skbs to a connection send queue. The skbs must comply with
> + * the max size limit of the device and have a headroom of at least
> + * TX_HEADER_LEN bytes.
> + * Return # of bytes queued.
> + */
> +int cxgb3i_c3cn_send_pdus(struct s3_conn *c3cn, struct sk_buff *skb)
> +{
> +	struct sk_buff *next;
> +	int err, copied = 0;
> +
> +	spin_lock_bh(&c3cn->lock);
> +
> +	if (c3cn->state != C3CN_STATE_ESTABLISHED) {
> +		c3cn_tx_debug("c3cn 0x%p, not in est. state %u.\n",
> +			      c3cn, c3cn->state);
> +		err = -EAGAIN;
> +		goto out_err;
> +	}
> +
> +	err = -EPIPE;
> +	if (c3cn->err) {
> +		c3cn_tx_debug("c3cn 0x%p, err %d.\n", c3cn, c3cn->err);
> +		goto out_err;
> +	}
> +
> +	while (skb) {
> +		int frags = skb_shinfo(skb)->nr_frags +
> +				(skb->len != skb->data_len);
> +
> +		if (unlikely(skb_headroom(skb) < TX_HEADER_LEN)) {
> +			c3cn_tx_debug("c3cn 0x%p, skb head.\n", c3cn);
> +			err = -EINVAL;
> +			goto out_err;
> +		}
> +
> +		if (frags >= SKB_WR_LIST_SIZE) {
> +			cxgb3i_log_error("c3cn 0x%p, tx frags %d, len %u,%u.\n",
> +					 c3cn, skb_shinfo(skb)->nr_frags,
> +					 skb->len, skb->data_len);
> +			err = -EINVAL;
> +			goto out_err;
> +		}
> +
> +		next = skb->next;
> +		skb->next = NULL;
> +		skb_entail(c3cn, skb, C3CB_FLAG_NO_APPEND | C3CB_FLAG_NEED_HDR);
> +		copied += skb->len;
> +		c3cn->write_seq += skb->len + ulp_extra_len(skb);
> +		skb = next;
> +	}
> +done:
> +	if (likely(skb_queue_len(&c3cn->write_queue)))
> +		c3cn_push_tx_frames(c3cn, 1);
> +	spin_unlock_bh(&c3cn->lock);
> +	return copied;
> +
> +out_err:
> +	if (copied == 0 && err == -EPIPE)
> +		copied = c3cn->err ? c3cn->err : -EPIPE;
> +	goto done;
> +}
> +
> +static void sdev_data_cleanup(struct cxgb3i_sdev_data *cdata)
> +{
> +	struct adap_ports *ports = &cdata->ports;
> +	int i;
> +
> +	for (i = 0; i < ports->nports; i++)
> +		NDEV2CDATA(ports->lldevs[i]) = NULL;
> +	cxgb3i_free_big_mem(cdata);
> +}
> +
> +void cxgb3i_sdev_cleanup(void)
> +{
> +	struct cxgb3i_sdev_data *cdata;
> +
> +	write_lock(&cdata_rwlock);
> +	list_for_each_entry(cdata, &cdata_list, list) {
> +		list_del(&cdata->list);
> +		sdev_data_cleanup(cdata);
> +	}
> +	write_unlock(&cdata_rwlock);
> +}
> +
> +int cxgb3i_sdev_init(cxgb3_cpl_handler_func *cpl_handlers)
> +{
> +	cpl_handlers[CPL_ACT_ESTABLISH] = do_act_establish;
> +	cpl_handlers[CPL_ACT_OPEN_RPL] = do_act_open_rpl;
> +	cpl_handlers[CPL_PEER_CLOSE] = do_peer_close;
> +	cpl_handlers[CPL_ABORT_REQ_RSS] = do_abort_req;
> +	cpl_handlers[CPL_ABORT_RPL_RSS] = do_abort_rpl;
> +	cpl_handlers[CPL_CLOSE_CON_RPL] = do_close_con_rpl;
> +	cpl_handlers[CPL_TX_DMA_ACK] = do_wr_ack;
> +	cpl_handlers[CPL_ISCSI_HDR] = do_iscsi_hdr;
> +
> +	if (cxgb3_max_connect > CXGB3I_MAX_CONN)
> +		cxgb3_max_connect = CXGB3I_MAX_CONN;
> +	return 0;
> +}
> +
> +/**
> + * cxgb3i_sdev_add - allocate and initialize resources for each adapter found
> + * @cdev:	t3cdev adapter
> + * @client:	cxgb3 driver client
> + */
> +void cxgb3i_sdev_add(struct t3cdev *cdev, struct cxgb3_client *client)
> +{
> +	struct cxgb3i_sdev_data *cdata;
> +	struct ofld_page_info rx_page_info;
> +	unsigned int wr_len;
> +	int mapsize = DIV_ROUND_UP(cxgb3_max_connect,
> +				   8 * sizeof(unsigned long));
> +	int i;
> +
> +	cdata =  cxgb3i_alloc_big_mem(sizeof(*cdata) + mapsize, GFP_KERNEL);
> +	if (!cdata)
> +		return;
> +
> +	if (cdev->ctl(cdev, GET_WR_LEN, &wr_len) < 0 ||
> +	    cdev->ctl(cdev, GET_PORTS, &cdata->ports) < 0 ||
> +	    cdev->ctl(cdev, GET_RX_PAGE_INFO, &rx_page_info) < 0)
> +		goto free_cdata;
> +
> +	s3_init_wr_tab(wr_len);
> +
> +	INIT_LIST_HEAD(&cdata->list);
> +	cdata->cdev = cdev;
> +	cdata->client = client;
> +
> +	for (i = 0; i < cdata->ports.nports; i++)
> +		NDEV2CDATA(cdata->ports.lldevs[i]) = cdata;
> +
> +	write_lock(&cdata_rwlock);
> +	list_add_tail(&cdata->list, &cdata_list);
> +	write_unlock(&cdata_rwlock);
> +
> +	return;
> +
> +free_cdata:
> +	cxgb3i_free_big_mem(cdata);
> +}
> +
> +/**
> + * cxgb3i_sdev_remove - free the allocated resources for the adapter
> + * @cdev:	t3cdev adapter
> + */
> +void cxgb3i_sdev_remove(struct t3cdev *cdev)
> +{
> +	struct cxgb3i_sdev_data *cdata = CXGB3_SDEV_DATA(cdev);
> +
> +	write_lock(&cdata_rwlock);
> +	list_del(&cdata->list);
> +	write_unlock(&cdata_rwlock);
> +
> +	sdev_data_cleanup(cdata);
> +}
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
> new file mode 100644
> index 0000000..5b93d62
> --- /dev/null
> +++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
> @@ -0,0 +1,231 @@
> +/*
> + * cxgb3i_offload.h: Chelsio S3xx iscsi offloaded tcp connection management
> + *
> + * Copyright (C) 2003-2008 Chelsio Communications.  All rights reserved.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the LICENSE file included in this
> + * release for licensing terms and conditions.
> + *
> + * Written by:	Dimitris Michailidis (dm@chelsio.com)
> + *		Karen Xie (kxie@chelsio.com)
> + */
> +
> +#ifndef _CXGB3I_OFFLOAD_H
> +#define _CXGB3I_OFFLOAD_H
> +
> +#include <linux/skbuff.h>
> +#include <net/tcp.h>
> +
> +#include "common.h"
> +#include "adapter.h"
> +#include "t3cdev.h"
> +#include "cxgb3_offload.h"
> +
> +#define cxgb3i_log_error(fmt...) printk(KERN_ERR "cxgb3i: ERR! " fmt)
> +#define cxgb3i_log_warn(fmt...)	 printk(KERN_WARNING "cxgb3i: WARN! " fmt)
> +#define cxgb3i_log_info(fmt...)  printk(KERN_INFO "cxgb3i: " fmt)
> +#define cxgb3i_log_debug(fmt, args...) \
> +	printk(KERN_INFO "cxgb3i: %s - " fmt, __func__ , ## args)
> +
> +/**
> + * struct s3_conn - an iscsi tcp connection structure
> + *
> + * @dev:	net device of with connection
> + * @cdev:	adapter t3cdev for net device
> + * @flags:	see c3cn_flags below
> + * @tid:	connection id assigned by the h/w
> + * @qset:	queue set used by connection
> + * @mss_idx:	Maximum Segment Size table index
> + * @l2t:	ARP resolution entry for offload packets
> + * @wr_max:	maximum in-flight writes
> + * @wr_avail:	number of writes available
> + * @wr_unacked:	writes since last request for completion notification
> + * @wr_pending_head: head of pending write queue
> + * @wr_pending_tail: tail of pending write queue
> + * @cpl_close:	skb for cpl_close_req
> + * @cpl_abort_req: skb for cpl_abort_req
> + * @cpl_abort_rpl: skb for cpl_abort_rpl
> + * @lock:	connection status lock
> + * @refcnt:	reference count on connection
> + * @state:	connection state
> + * @saddr:	source ip/port address
> + * @daddr:	destination ip/port address
> + * @dst_cache:	reference to destination route
> + * @receive_queue: received PDUs
> + * @write_queue: un-pushed pending writes
> + * @retry_timer: retry timer for various operations
> + * @err:	connection error status
> + * @callback_lock: lock for opaque user context
> + * @user_data:	opaque user context
> + * @rcv_nxt:	next receive seq. #
> + * @copied_seq:	head of yet unread data
> + * @rcv_wup:	rcv_nxt on last window update sent
> + * @snd_nxt:	next sequence we send
> + * @snd_una:	first byte we want an ack for
> + * @write_seq:	tail+1 of data held in send buffer
> + */
> +struct s3_conn {
> +	struct net_device *dev;
> +	struct t3cdev *cdev;
> +	unsigned long flags;
> +	int tid;
> +	int qset;
> +	int mss_idx;
> +	struct l2t_entry *l2t;
> +	int wr_max;
> +	int wr_avail;
> +	int wr_unacked;
> +	struct sk_buff *wr_pending_head;
> +	struct sk_buff *wr_pending_tail;
> +	struct sk_buff *cpl_close;
> +	struct sk_buff *cpl_abort_req;
> +	struct sk_buff *cpl_abort_rpl;
> +	spinlock_t lock;
> +	atomic_t refcnt;
> +	volatile unsigned int state;
> +	struct sockaddr_in saddr;
> +	struct sockaddr_in daddr;
> +	struct dst_entry *dst_cache;
> +	struct sk_buff_head receive_queue;
> +	struct sk_buff_head write_queue;
> +	struct timer_list retry_timer;
> +	int err;
> +	rwlock_t callback_lock;
> +	void *user_data;
> +
> +	u32 rcv_nxt;
> +	u32 copied_seq;
> +	u32 rcv_wup;
> +	u32 snd_nxt;
> +	u32 snd_una;
> +	u32 write_seq;
> +};
> +
> +/*
> + * connection state
> + */
> +enum conn_states {
> +	C3CN_STATE_CONNECTING = 1,
> +	C3CN_STATE_ESTABLISHED,
> +	C3CN_STATE_ACTIVE_CLOSE,
> +	C3CN_STATE_PASSIVE_CLOSE,
> +	C3CN_STATE_CLOSE_WAIT_1,
> +	C3CN_STATE_CLOSE_WAIT_2,
> +	C3CN_STATE_ABORTING,
> +	C3CN_STATE_CLOSED,
> +};
> +
> +static inline unsigned int c3cn_is_closing(const struct s3_conn *c3cn)
> +{
> +	return c3cn->state >= C3CN_STATE_ACTIVE_CLOSE;
> +}
> +static inline unsigned int c3cn_is_established(const struct s3_conn *c3cn)
> +{
> +	return c3cn->state == C3CN_STATE_ESTABLISHED;
> +}
> +
> +/*
> + * Connection flags -- many to track some close related events.
> + */
> +enum c3cn_flags {
> +	C3CN_ABORT_RPL_RCVD,	/* received one ABORT_RPL_RSS message */
> +	C3CN_ABORT_REQ_RCVD,	/* received one ABORT_REQ_RSS message */
> +	C3CN_ABORT_RPL_PENDING,	/* expecting an abort reply */
> +	C3CN_TX_DATA_SENT,	/* already sent a TX_DATA WR */
> +	C3CN_ACTIVE_CLOSE_NEEDED,	/* need to be closed */
> +};
> +
> +/**
> + * cxgb3i_sdev_data - Per adapter data.
> + * Linked off of each Ethernet device port on the adapter.
> + * Also available via the t3cdev structure since we have pointers to our port
> + * net_device's there ...
> + *
> + * @list:	list head to link elements
> + * @cdev:	t3cdev adapter
> + * @client:	CPL client pointer
> + * @ports:	array of adapter ports
> + * @sport_map_next: next index into the port map
> + * @sport_map:	source port map
> + */
> +struct cxgb3i_sdev_data {
> +	struct list_head list;
> +	struct t3cdev *cdev;
> +	struct cxgb3_client *client;
> +	struct adap_ports ports;
> +	unsigned int sport_map_next;
> +	unsigned long sport_map[0];
> +};
> +#define NDEV2CDATA(ndev) (*(struct cxgb3i_sdev_data **)&(ndev)->ec_ptr)
> +#define CXGB3_SDEV_DATA(cdev) NDEV2CDATA((cdev)->lldev)
> +
> +void cxgb3i_sdev_cleanup(void);
> +int cxgb3i_sdev_init(cxgb3_cpl_handler_func *);
> +void cxgb3i_sdev_add(struct t3cdev *, struct cxgb3_client *);
> +void cxgb3i_sdev_remove(struct t3cdev *);
> +
> +struct s3_conn *cxgb3i_c3cn_create(void);
> +int cxgb3i_c3cn_connect(struct s3_conn *, struct sockaddr_in *);
> +void cxgb3i_c3cn_rx_credits(struct s3_conn *, int);
> +int cxgb3i_c3cn_send_pdus(struct s3_conn *, struct sk_buff *);
> +void cxgb3i_c3cn_release(struct s3_conn *);
> +
> +/**
> + * cxgb3_skb_cb - control block for received pdu state and ULP mode management.
> + *
> + * @flag:	see C3CB_FLAG_* below
> + * @ulp_mode:	ULP mode/submode of sk_buff
> + * @seq:	tcp sequence number
> + * @ddigest:	pdu data digest
> + * @pdulen:	recovered pdu length
> + * @ulp_data:	scratch area for ULP
> + */
> +struct cxgb3_skb_cb {
> +	__u8 flags;
> +	__u8 ulp_mode;
> +	__u32 seq;
> +	__u32 ddigest;
> +	__u32 pdulen;
> +	__u8 ulp_data[16];
> +};
> +
> +#define CXGB3_SKB_CB(skb)	((struct cxgb3_skb_cb *)&((skb)->cb[0]))
> +
> +#define skb_ulp_mode(skb)	(CXGB3_SKB_CB(skb)->ulp_mode)
> +#define skb_ulp_ddigest(skb)	(CXGB3_SKB_CB(skb)->ddigest)
> +#define skb_ulp_pdulen(skb)	(CXGB3_SKB_CB(skb)->pdulen)
> +#define skb_ulp_data(skb)	(CXGB3_SKB_CB(skb)->ulp_data)
> +
> +enum c3cb_flags {
> +	C3CB_FLAG_NEED_HDR = 1 << 0,	/* packet needs a TX_DATA_WR header */
> +	C3CB_FLAG_NO_APPEND = 1 << 1,	/* don't grow this skb */
> +	C3CB_FLAG_COMPL = 1 << 2,	/* request WR completion */
> +};
> +
> +/**
> + * sge_opaque_hdr -
> + * Opaque version of structure the SGE stores at skb->head of TX_DATA packets
> + * and for which we must reserve space.
> + */
> +struct sge_opaque_hdr {
> +	void *dev;
> +	dma_addr_t addr[MAX_SKB_FRAGS + 1];
> +};
> +
> +/* for TX: a skb must have a headroom of at least TX_HEADER_LEN bytes */
> +#define TX_HEADER_LEN \
> +		(sizeof(struct tx_data_wr) + sizeof(struct sge_opaque_hdr))
> +
> +/*
> + * get and set private ip for iscsi traffic
> + */
> +#define cxgb3i_get_private_ipv4addr(ndev) \
> +	(((struct port_info *)(netdev_priv(ndev)))->iscsi_ipv4addr)
> +#define cxgb3i_set_private_ipv4addr(ndev, addr) \
> +	(((struct port_info *)(netdev_priv(ndev)))->iscsi_ipv4addr) = addr
> +
> +/* max. connections per adapter */
> +#define CXGB3I_MAX_CONN		16384
> +#endif /* _CXGB3_OFFLOAD_H */
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
> new file mode 100644
> index 0000000..8890e5d
> --- /dev/null
> +++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
> @@ -0,0 +1,400 @@
> +/*
> + * cxgb3i_pdu.c: Chelsio S3xx iSCSI driver.
> + *
> + * Copyright (c) 2008 Chelsio Communications, Inc.
> + * Copyright (c) 2008 Mike Christie
> + * Copyright (c) 2008 Red Hat, Inc.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + *
> + * Written by: Karen Xie (kxie@chelsio.com)
> + */
> +
> +#include <linux/skbuff.h>
> +#include <linux/crypto.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_host.h>
> +
> +#include "cxgb3i.h"
> +#include "cxgb3i_pdu.h"
> +
> +#ifdef __DEBUG_CXGB3I_RX__
> +#define cxgb3i_rx_debug		cxgb3i_log_debug
> +#else
> +#define cxgb3i_rx_debug(fmt...)
> +#endif
> +
> +#ifdef __DEBUG_CXGB3I_TX__
> +#define cxgb3i_tx_debug		cxgb3i_log_debug
> +#else
> +#define cxgb3i_tx_debug(fmt...)
> +#endif
> +
> +static struct page *pad_page;
> +
> +/*
> + * pdu receive, interact with libiscsi_tcp
> + */
> +static inline int read_pdu_skb(struct iscsi_conn *conn, struct sk_buff *skb,
> +			       unsigned int offset, int offloaded)
> +{
> +	int status = 0;
> +	int bytes_read;
> +
> +	bytes_read = iscsi_tcp_recv_skb(conn, skb, offset, offloaded, &status);
> +	switch (status) {
> +	case ISCSI_TCP_CONN_ERR:
> +		return -EIO;
> +	case ISCSI_TCP_SUSPENDED:
> +		/* no transfer - just have caller flush queue */
> +		return bytes_read;
> +	case ISCSI_TCP_SKB_DONE:
> +		/*
> +		 * pdus should always fit in the skb and we should get
> +		 * segment done notifcation.
> +		 */
> +		iscsi_conn_printk(KERN_ERR, conn, "Invalid pdu or skb.");
> +		return -EFAULT;
> +	case ISCSI_TCP_SEGMENT_DONE:
> +		return bytes_read;
> +	default:
> +		iscsi_conn_printk(KERN_ERR, conn, "Invalid iscsi_tcp_recv_skb "
> +				  "status %d\n", status);
> +		return -EINVAL;
> +	}
> +}
> +
> +static int cxgb3i_conn_read_pdu_skb(struct iscsi_conn *conn,
> +				    struct sk_buff *skb)
> +{
> +	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
> +	bool offloaded = 0;
> +	unsigned int offset;
> +	int rc;
> +
> +	cxgb3i_rx_debug("conn 0x%p, skb 0x%p, len %u, flag 0x%x.\n",
> +			conn, skb, skb->len, skb_ulp_mode(skb));
> +
> +	if (!iscsi_tcp_recv_segment_is_hdr(tcp_conn)) {
> +		iscsi_conn_failure(conn, ISCSI_ERR_PROTO);
> +		return -EIO;
> +	}
> +
> +	if (conn->hdrdgst_en && (skb_ulp_mode(skb) & ULP2_FLAG_HCRC_ERROR)) {
> +		iscsi_conn_failure(conn, ISCSI_ERR_HDR_DGST);
> +		return -EIO;
> +	}
> +
> +	if (conn->datadgst_en && (skb_ulp_mode(skb) & ULP2_FLAG_DCRC_ERROR)) {
> +		iscsi_conn_failure(conn, ISCSI_ERR_DATA_DGST);
> +		return -EIO;
> +	}
> +
> +	/* iscsi hdr */
> +	rc = read_pdu_skb(conn, skb, 0, 0);
> +	if (rc <= 0)
> +		return rc;
> +
> +	if (iscsi_tcp_recv_segment_is_hdr(tcp_conn))
> +		return 0;
> +
> +	offset = rc;
> +	if (conn->hdrdgst_en)
> +		offset += ISCSI_DIGEST_SIZE;
> +
> +	/* iscsi data */
> +	if (skb_ulp_mode(skb) & ULP2_FLAG_DATA_DDPED) {
> +		cxgb3i_rx_debug("skb 0x%p, opcode 0x%x, data %u, ddp'ed, "
> +				"itt 0x%x.\n",
> +				skb,
> +				tcp_conn->in.hdr->opcode & ISCSI_OPCODE_MASK,
> +				tcp_conn->in.datalen,
> +				ntohl(tcp_conn->in.hdr->itt));
> +		offloaded = 1;
> +	} else {
> +		cxgb3i_rx_debug("skb 0x%p, opcode 0x%x, data %u, NOT ddp'ed, "
> +				"itt 0x%x.\n",
> +				skb,
> +				tcp_conn->in.hdr->opcode & ISCSI_OPCODE_MASK,
> +				tcp_conn->in.datalen,
> +				ntohl(tcp_conn->in.hdr->itt));
> +		offset += sizeof(struct cpl_iscsi_hdr_norss);
> +	}
> +
> +	rc = read_pdu_skb(conn, skb, offset, offloaded);
> +	if (rc < 0)
> +		return rc;
> +	else
> +		return 0;
> +}
> +
> +/*
> + * pdu transmit, interact with libiscsi_tcp
> + */
> +static inline void tx_skb_setmode(struct sk_buff *skb, int hcrc, int dcrc)
> +{
> +	u8 submode = 0;
> +
> +	if (hcrc)
> +		submode |= 1;
> +	if (dcrc)
> +		submode |= 2;
> +	skb_ulp_mode(skb) = (ULP_MODE_ISCSI << 4) | submode;
> +}
> +
> +void cxgb3i_conn_cleanup_task(struct iscsi_task *task)
> +{
> +	struct iscsi_tcp_task *tcp_task = task->dd_data;
> +
> +	/* never reached the xmit task callout */
> +	if (tcp_task->dd_data)
> +		kfree_skb(tcp_task->dd_data);
> +	tcp_task->dd_data = NULL;
> +
> +	/* MNC - Do we need a check in case this is called but
> +	 * cxgb3i_conn_alloc_pdu has never been called on the task */
> +	cxgb3i_release_itt(task, task->hdr_itt);
> +	iscsi_tcp_cleanup_task(task);
> +}
> +
> +/*
> + * We do not support ahs yet
> + */
> +int cxgb3i_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
> +{
> +	struct iscsi_tcp_task *tcp_task = task->dd_data;
> +	struct sk_buff *skb;
> +
> +	task->hdr = NULL;
> +	skb = alloc_skb(sizeof(struct iscsi_hdr) + TX_HEADER_LEN,  GFP_ATOMIC);

BUG: See below
+	skb = alloc_skb(sizeof(struct iscsi_hdr) + ISCSI_DIGEST_SIZE + TX_HEADER_LEN,  GFP_ATOMIC);

> +	if (!skb)
> +		return -ENOMEM;
> +
> +	cxgb3i_tx_debug("task 0x%p, opcode 0x%x, skb 0x%p.\n",
> +			task, opcode, skb);
> +
> +	tcp_task->dd_data = skb;
> +	skb_reserve(skb, TX_HEADER_LEN);
> +	skb_put(skb, sizeof(struct iscsi_hdr));
> +	task->hdr = (struct iscsi_hdr *)skb->data;
> +	task->hdr_max = sizeof(struct iscsi_hdr);
> +

3 things

1. task->hdr_max should be without the digest (4 bytes) but if
digest is enabled then it is assumed that there is place for
it beyond hdr_max. In short:
	task->hdr_max = allocated_size - ISCSI_DIGEST_SIZE.

2. task->hdr_max = sizeof(struct iscsi_hdr); is the very bare
minimum. No bidi and no AHSs. All you need to do to enable them
at the libiscsi level is give them more room here.
See: iscsi_sw_tcp_pdu_alloc() in iscsi_tcp.c

3. At this stage libiscsi does not know what the size of the command header will be
It will only know that later after it prepars the header, just allocated here.
So the above:
+	skb_put(skb, sizeof(struct iscsi_hdr));

Will need to be set later mabe at cxgb3i_conn_init_pdu() and it will need to be
+	skb_put(skb, task->hdr_len);

task->hdr_len starts with Zero, and acumulates the total command header size once
libiscsi::iscsi_prep_scsi_cmd_pdu() is finished.

> +	/* data_out uses scsi_cmd's itt */
> +	if (opcode != ISCSI_OP_SCSI_DATA_OUT)
> +		cxgb3i_reserve_itt(task, &task->hdr->itt);
> +
> +	return 0;
> +}
> +
> +int cxgb3i_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
> +			      unsigned int count)
> +{
> +	struct iscsi_tcp_task *tcp_task = task->dd_data;
> +	struct sk_buff *skb = tcp_task->dd_data;
> +	struct iscsi_conn *conn = task->conn;
> +	struct page *pg;
> +	unsigned int datalen = count;
> +	int i, padlen = iscsi_padding(count);
> +	skb_frag_t *frag;
> +
> +	cxgb3i_tx_debug("task 0x%p,0x%p, offset %u, count %u, skb 0x%p.\n",
> +			task, task->sc, offset, count, skb);
> +
> +	tx_skb_setmode(skb, conn->hdrdgst_en, datalen ? conn->datadgst_en : 0);
> +	if (!count)
> +		return 0;
> +
> +	if (task->sc) {
> +		struct scatterlist *sg;
> +		struct scsi_data_buffer *sdb;
> +		unsigned int sgoffset = offset;
> +		struct page *sgpg;
> +		unsigned int sglen;
> +
> +		sdb = scsi_out(task->sc);
> +		sg = sdb->table.sgl;
> +
> +		for_each_sg(sdb->table.sgl, sg, sdb->table.nents, i) {
> +			cxgb3i_tx_debug("sg %d, page 0x%p, len %u offset %u\n",
> +					i, sg_page(sg), sg->length, sg->offset);
> +
> +			if (sgoffset < sg->length)
> +				break;
> +			sgoffset -= sg->length;
> +		}
> +		sgpg = sg_page(sg);
> +		sglen = sg->length - sgoffset;
> +
> +		do {
> +			int j = skb_shinfo(skb)->nr_frags;
> +			unsigned int copy;
> +
> +			if (!sglen) {
> +				sg = sg_next(sg);
> +				sgpg = sg_page(sg);
> +				sgoffset = 0;
> +				sglen = sg->length;
> +				++i;
> +			}
> +			copy = min(sglen, datalen);
> +			if (j && skb_can_coalesce(skb, j, sgpg,
> +						  sg->offset + sgoffset)) {
> +				skb_shinfo(skb)->frags[j - 1].size += copy;
> +			} else {
> +				get_page(sgpg);
> +				skb_fill_page_desc(skb, j, sgpg,
> +						   sg->offset + sgoffset, copy);
> +			}
> +			sgoffset += copy;
> +			sglen -= copy;
> +			datalen -= copy;
> +		} while (datalen);
> +	} else {
> +		pg = virt_to_page(task->data);
> +
> +		while (datalen) {
> +			i = skb_shinfo(skb)->nr_frags;
> +			frag = &skb_shinfo(skb)->frags[i];
> +
> +			get_page(pg);
> +			frag->page = pg;
> +			frag->page_offset = 0;
> +			frag->size = min((unsigned int)PAGE_SIZE, datalen);
> +
> +			skb_shinfo(skb)->nr_frags++;
> +			datalen -= frag->size;
> +			pg++;
> +		}
> +	}
> +
> +	if (padlen) {
> +		i = skb_shinfo(skb)->nr_frags;
> +		frag = &skb_shinfo(skb)->frags[i];
> +		frag->page = pad_page;
> +		frag->page_offset = 0;
> +		frag->size = padlen;
> +		skb_shinfo(skb)->nr_frags++;
> +	}
> +
> +	datalen = count + padlen;
> +	skb->data_len += datalen;
> +	skb->truesize += datalen;
> +	skb->len += datalen;
> +	return 0;
> +}
> +
> +int cxgb3i_conn_xmit_pdu(struct iscsi_task *task)
> +{
> +	struct iscsi_tcp_task *tcp_task = task->dd_data;
> +	struct sk_buff *skb = tcp_task->dd_data;
> +	struct iscsi_tcp_conn *tcp_conn = task->conn->dd_data;
> +	struct cxgb3i_conn *cconn = tcp_conn->dd_data;
> +	unsigned int datalen;
> +	int err;
> +
> +	if (!skb)
> +		return 0;
> +
> +	datalen = skb->data_len;
> +	tcp_task->dd_data = NULL;
> +	err = cxgb3i_c3cn_send_pdus(cconn->cep->c3cn, skb);
> +	cxgb3i_tx_debug("task 0x%p, skb 0x%p, len %u/%u, rv %d.\n",
> +			task, skb, skb->len, skb->data_len, err);
> +	if (err > 0) {
> +		int pdulen = err;
> +
> +		if (task->conn->hdrdgst_en)
> +			pdulen += ISCSI_DIGEST_SIZE;
> +		if (datalen && task->conn->datadgst_en)
> +			pdulen += ISCSI_DIGEST_SIZE;
> +
> +		task->conn->txdata_octets += pdulen;
> +		return 0;
> +	}
> +
> +	if (err < 0 && err != -EAGAIN) {
> +		kfree_skb(skb);
> +		cxgb3i_tx_debug("itt 0x%x, skb 0x%p, len %u/%u, xmit err %d.\n",
> +				task->itt, skb, skb->len, skb->data_len, err);
> +		iscsi_conn_printk(KERN_ERR, task->conn, "xmit err %d.\n", err);
> +		iscsi_conn_failure(task->conn, ISCSI_ERR_XMIT_FAILED);
> +		return err;
> +	}
> +	/* reset skb to send when we are called again */
> +	tcp_task->dd_data = skb;
> +	return -EAGAIN;
> +}
> +
> +int cxgb3i_pdu_init(void)
> +{
> +	pad_page = alloc_page(GFP_KERNEL);
> +	if (!pad_page)
> +		return -ENOMEM;
> +	memset(page_address(pad_page), 0, PAGE_SIZE);
> +	return 0;
> +}
> +
> +void cxgb3i_pdu_cleanup(void)
> +{
> +	if (pad_page) {
> +		__free_page(pad_page);
> +		pad_page = NULL;
> +	}
> +}
> +
> +void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
> +{
> +	struct sk_buff *skb;
> +	unsigned int read = 0;
> +	struct iscsi_conn *conn = c3cn->user_data;
> +	int err = 0;
> +
> +	cxgb3i_rx_debug("cn 0x%p.\n", c3cn);
> +
> +	read_lock(&c3cn->callback_lock);
> +	if (unlikely(!conn || conn->suspend_rx)) {
> +		cxgb3i_rx_debug("conn 0x%p, id %d, suspend_rx %lu!\n",
> +				conn, conn ? conn->id : 0xFF,
> +				conn ? conn->suspend_rx : 0xFF);
> +		read_unlock(&c3cn->callback_lock);
> +		return;
> +	}
> +	skb = skb_peek(&c3cn->receive_queue);
> +	while (!err && skb) {
> +		__skb_unlink(skb, &c3cn->receive_queue);
> +		read += skb_ulp_pdulen(skb);
> +		err = cxgb3i_conn_read_pdu_skb(conn, skb);
> +		__kfree_skb(skb);
> +		skb = skb_peek(&c3cn->receive_queue);
> +	}
> +	read_unlock(&c3cn->callback_lock);
> +	if (c3cn) {
> +		c3cn->copied_seq += read;
> +		cxgb3i_c3cn_rx_credits(c3cn, read);
> +	}
> +	conn->rxdata_octets += read;
> +}
> +
> +void cxgb3i_conn_tx_open(struct s3_conn *c3cn)
> +{
> +	struct iscsi_conn *conn = c3cn->user_data;
> +
> +	cxgb3i_tx_debug("cn 0x%p.\n", c3cn);
> +	if (conn) {
> +		cxgb3i_tx_debug("cn 0x%p, cid %d.\n", c3cn, conn->id);
> +		scsi_queue_work(conn->session->host, &conn->xmitwork);
> +	}
> +}
> +
> +void cxgb3i_conn_closing(struct s3_conn *c3cn)
> +{
> +	struct iscsi_conn *conn;
> +
> +	read_lock(&c3cn->callback_lock);
> +	conn = c3cn->user_data;
> +	if (conn && c3cn->state != C3CN_STATE_ESTABLISHED)
> +		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
> +	read_unlock(&c3cn->callback_lock);
> +}
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.h b/drivers/scsi/cxgb3i/cxgb3i_pdu.h
> new file mode 100644
> index 0000000..a3f685c
> --- /dev/null
> +++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.h
> @@ -0,0 +1,59 @@
> +/*
> + * cxgb3i_ulp2.h: Chelsio S3xx iSCSI driver.
> + *
> + * Copyright (c) 2008 Chelsio Communications, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + *
> + * Written by: Karen Xie (kxie@chelsio.com)
> + */
> +
> +#ifndef __CXGB3I_ULP2_PDU_H__
> +#define __CXGB3I_ULP2_PDU_H__
> +
> +struct cpl_iscsi_hdr_norss {
> +	union opcode_tid ot;
> +	u16 pdu_len_ddp;
> +	u16 len;
> +	u32 seq;
> +	u16 urg;
> +	u8 rsvd;
> +	u8 status;
> +};
> +
> +struct cpl_rx_data_ddp_norss {
> +	union opcode_tid ot;
> +	u16 urg;
> +	u16 len;
> +	u32 seq;
> +	u32 nxt_seq;
> +	u32 ulp_crc;
> +	u32 ddp_status;
> +};
> +
> +#define RX_DDP_STATUS_IPP_SHIFT		27	/* invalid pagepod */
> +#define RX_DDP_STATUS_TID_SHIFT		26	/* tid mismatch */
> +#define RX_DDP_STATUS_COLOR_SHIFT	25	/* color mismatch */
> +#define RX_DDP_STATUS_OFFSET_SHIFT	24	/* offset mismatch */
> +#define RX_DDP_STATUS_ULIMIT_SHIFT	23	/* ulimit error */
> +#define RX_DDP_STATUS_TAG_SHIFT		22	/* tag mismatch */
> +#define RX_DDP_STATUS_DCRC_SHIFT	21	/* dcrc error */
> +#define RX_DDP_STATUS_HCRC_SHIFT	20	/* hcrc error */
> +#define RX_DDP_STATUS_PAD_SHIFT		19	/* pad error */
> +#define RX_DDP_STATUS_PPP_SHIFT		18	/* pagepod parity error */
> +#define RX_DDP_STATUS_LLIMIT_SHIFT	17	/* llimit error */
> +#define RX_DDP_STATUS_DDP_SHIFT		16	/* ddp'able */
> +#define RX_DDP_STATUS_PMM_SHIFT		15	/* pagepod mismatch */
> +
> +#define ULP2_FLAG_DATA_READY		0x1
> +#define ULP2_FLAG_DATA_DDPED		0x2
> +#define ULP2_FLAG_HCRC_ERROR		0x10
> +#define ULP2_FLAG_DCRC_ERROR		0x20
> +#define ULP2_FLAG_PAD_ERROR		0x40
> +
> +void cxgb3i_conn_closing(struct s3_conn *);
> +void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn);
> +void cxgb3i_conn_tx_open(struct s3_conn *c3cn);
> +#endif
> --

OK It looks like current code is not very far from supporting bidi and extended CDBs.
Just fix the few comments above and you should be set to try them out.
( Don't forget the:
-	shost->max_cmd_len = 16;
+	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
)

This could be added later by an incrimental patch. But please do fix the one bug
mentioned above.

Thanks
Boaz
