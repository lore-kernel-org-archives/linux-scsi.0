Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1450C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Mar 2022 12:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiCRMyR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 08:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiCRMyR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 08:54:17 -0400
Received: from VLXDG1SPAM1.ramaxel.com (email.ramaxel.com [221.4.138.186])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF812C213E
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2022 05:52:49 -0700 (PDT)
Received: from V12DG1MBS01.ramaxel.local (v12dg1mbs01.ramaxel.local [172.26.18.31])
        by VLXDG1SPAM1.ramaxel.com with ESMTPS id 22ICq5Jd002508
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Mar 2022 20:52:05 +0800 (GMT-8)
        (envelope-from songyl@ramaxel.com)
Received: from localhost (192.168.150.185) by V12DG1MBS01.ramaxel.local
 (172.26.18.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2375.17; Fri, 18
 Mar 2022 20:52:04 +0800
Date:   Fri, 18 Mar 2022 20:52:02 +0800
From:   Yanling Song <songyl@ramaxel.com>
To:     John Garry <john.garry@huawei.com>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <bvanassche@acm.org>
Subject: Re: [PATCH v5] scsi:spraid: initial commit of Ramaxel spraid driver
Message-ID: <20220318204645.00000e67@ramaxel.com>
In-Reply-To: <ecf79a5c-49f4-cf0e-edf4-9363c8b60bb5@huawei.com>
References: <20220314025315.96674-1-songyl@ramaxel.com>
 <ecf79a5c-49f4-cf0e-edf4-9363c8b60bb5@huawei.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="GB18030"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.150.185]
X-ClientProxiedBy: V12DG1MBS03.ramaxel.local (172.26.18.33) To
 V12DG1MBS01.ramaxel.local (172.26.18.31)
X-DNSRBL: 
X-MAIL: VLXDG1SPAM1.ramaxel.com 22ICq5Jd002508
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Mar 2022 14:43:35 +0000
John Garry <john.garry@huawei.com> wrote:

> On 14/03/2022 02:53, Yanling Song wrote:
> 
> Some initial comments from me.
> 
> > This initial commit contains Ramaxel's spraid module.  
> 
> It would be useful to give brief overview of the HW and driver.
> 
More contents will be included in the next version.

> > 
> > Signed-off-by: Yanling Song <songyl@ramaxel.com>
> >   
> 
> I think that you require a '---' here
> 
Yes. '----' will be included in the next version

> > Changes from V4:
> > Rebased and retested on top of the latest for-next tree
> > 
> > Changes from V3:
> > 1. Use macro to repalce scmd_tmout_nonpt module parameter.
> > 
> > Changes from V2:
> > 1. Change "depends BLK_DEV_BSGLIB" to "select BLK_DEV_BSGLIB".
> > 2. Add more descriptions in help.
> > 3. Use pr_debug() instead of introducing dev_log_dbg().
> > 4. Use get_unaligned_be*() in spraid_setup_rw_cmd();
> > 5. Remove some unncessarry module parameters:
> >     scmd_tmout_pt, wait_abl_tmout, use_sgl_force
> > 6. Some module parameters will be changed in the next version:
> >     admin_tmout, scmd_tmout_nonpt
> > 
> > Changes from V1:
> > 1. Use BSG module to replace with ioctrl
> > 2. Use author's email as MODULE_AUTHOR
> > 3. Remove "default=m" in drivers/scsi/spraid/Kconfig
> > 4. To be changed in the next version:
> >     a. Use get_unaligned_be*() in spraid_setup_rw_cmd();
> >     b. Use pr_debug() instead of introducing dev_log_dbg().
> > 
> > Signed-off-by: Yanling Song <songyl@ramaxel.com>  
> 
> 2x Signed off - why?
>
Will be removed in the next version.
 
> > ---
> >   Documentation/scsi/spraid.rst     |   16 +
> >   MAINTAINERS                       |    7 +
> >   drivers/scsi/Kconfig              |    1 +
> >   drivers/scsi/Makefile             |    1 +
> >   drivers/scsi/spraid/Kconfig       |   13 +
> >   drivers/scsi/spraid/Makefile      |    7 +
> >   drivers/scsi/spraid/spraid.h      |  695 ++++++
> >   drivers/scsi/spraid/spraid_main.c | 3266
> > +++++++++++++++++++++++++++++ 8 files changed, 4006 insertions(+)
> >   create mode 100644 Documentation/scsi/spraid.rst
> >   create mode 100644 drivers/scsi/spraid/Kconfig
> >   create mode 100644 drivers/scsi/spraid/Makefile
> >   create mode 100644 drivers/scsi/spraid/spraid.h
> >   create mode 100644 drivers/scsi/spraid/spraid_main.c  
> 
> I'm not sure why this driver cannot be located in
> drivers/scsi/spraid.c since it could be contained in a single C file
> 
For current code, yes. But more features will be added later and single
C file may be not enough. So it is better to keep current layout.

> > 
> > diff --git a/Documentation/scsi/spraid.rst
> > b/Documentation/scsi/spraid.rst new file mode 100644
> > index 000000000000..f87b02a6907b
> > --- /dev/null
> > +++ b/Documentation/scsi/spraid.rst
> > @@ -0,0 +1,16 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +==============================================
> > +SPRAID - Ramaxel SCSI Raid Controller driver
> > +==============================================
> > +
> > +This file describes the spraid SCSI driver for Ramaxel
> > +raid controllers. The spraid driver is the first generation raid
> > driver for  
> 
> capitalize acronyms, like RAID
> 
Ok. Changes will be included in the next version.

> > +Ramaxel Corp.
> > +
> > +For Ramaxel spraid controller support, enable the spraid driver
> > +when configuring the kernel.
> > +
> > +Supported devices
> > +=================
> > +<Controller names to be added as they become publicly available.>  
> 
> there's not really much in this file...so I doubt its use
> 
More contents will be added in the next version.

> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index ea3e6c914384..cf3bb776b615 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -18221,6 +18221,13 @@ F:	include/dt-bindings/spmi/spmi.h
> >   F:	include/linux/spmi.h
> >   F:	include/trace/events/spmi.h
> >   
> > +SPRAID SCSI/Raid DRIVERS
> > +M:	Yanling Song <yanling.song@ramaxel.com>
> > +L:	linux-scsi@vger.kernel.org
> > +S:	Maintained
> > +F:	Documentation/scsi/spraid.rst
> > +F:	drivers/scsi/spraid/
> > +
> >   SPU FILE SYSTEM
> >   M:	Jeremy Kerr <jk@ozlabs.org>
> >   L:	linuxppc-dev@lists.ozlabs.org
> > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > index 6e3a04107bb6..3da5d26e1e11 100644
> > --- a/drivers/scsi/Kconfig
> > +++ b/drivers/scsi/Kconfig
> > @@ -501,6 +501,7 @@ source "drivers/scsi/mpt3sas/Kconfig"
> >   source "drivers/scsi/mpi3mr/Kconfig"
> >   source "drivers/scsi/smartpqi/Kconfig"
> >   source "drivers/scsi/ufs/Kconfig"
> > +source "drivers/scsi/spraid/Kconfig"  
> 
> alphabetic ordering
> 
Ok. Changes will be included in the next version.


> >   
> >   config SCSI_HPTIOP
> >   	tristate "HighPoint RocketRAID 3xxx/4xxx Controller
> > support" diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> > index 19814c26c908..192f8fb10a19 100644
> > --- a/drivers/scsi/Makefile
> > +++ b/drivers/scsi/Makefile
> > @@ -96,6 +96,7 @@ obj-$(CONFIG_SCSI_ZALON)	+= zalon7xx.o
> >   obj-$(CONFIG_SCSI_DC395x)	+= dc395x.o
> >   obj-$(CONFIG_SCSI_AM53C974)	+= esp_scsi.o	am53c974.o
> >   obj-$(CONFIG_CXLFLASH)		+= cxlflash/
> > +obj-$(CONFIG_RAMAXEL_SPRAID)	+= spraid/
> >   obj-$(CONFIG_MEGARAID_LEGACY)	+= megaraid.o
> >   obj-$(CONFIG_MEGARAID_NEWGEN)	+= megaraid/
> >   obj-$(CONFIG_MEGARAID_SAS)	+= megaraid/
> > diff --git a/drivers/scsi/spraid/Kconfig
> > b/drivers/scsi/spraid/Kconfig new file mode 100644
> > index 000000000000..bfbba3db8db0
> > --- /dev/null
> > +++ b/drivers/scsi/spraid/Kconfig
> > @@ -0,0 +1,13 @@
> > +#
> > +# Ramaxel driver configuration
> > +#
> > +
> > +config RAMAXEL_SPRAID  
> 
> many SCSI-related configs are in form CONFIG_SCSI_XXX
>
Ok. Changes will be included in the next version.
 
> > +	tristate "Ramaxel spraid Adapter"
> > +	depends on PCI && SCSI
> > +	select BLK_DEV_BSGLIB
> > +	depends on ARM64 || X86_64  
> 
> why only 2x architectures?
> 
Currently we only tested SPRAID on the above two architectures.

> and what about COMPILE_TEST?
> 
SPRAID is a raid driver and the reliability is the most important thing.
We only claim the architectures which have been tested and it is not
needed to compile the driver on a unsupported platform. So COMPILE_TEST
is not needed here.

> > +	help
> > +	This driver supports Ramaxel SPRxxx serial
> > +	raid controller, which has PCIE Gen4 interface
> > +	with host and supports SAS/SATA Hdd/ssd.
> > diff --git a/drivers/scsi/spraid/Makefile
> > b/drivers/scsi/spraid/Makefile new file mode 100644
> > index 000000000000..ad2c2a84ddaf
> > --- /dev/null
> > +++ b/drivers/scsi/spraid/Makefile
> > @@ -0,0 +1,7 @@
> > +#
> > +# Makefile for the Ramaxel device drivers.
> > +#
> > +
> > +obj-$(CONFIG_RAMAXEL_SPRAID) += spraid.o
> > +
> > +spraid-objs := spraid_main.o
> > diff --git a/drivers/scsi/spraid/spraid.h
> > b/drivers/scsi/spraid/spraid.h  
> 
> why do you need a separate header file? why not put all this in the
> only C file?
> 
The C file is going to grow bigger and bigger when adding new features.
Maybe new C files will be added when there is too much new code. For
the flexibility and expansibility, it is better to have a separate
header file now.

> > new file mode 100644
> > index 000000000000..617f5c2cdb82
> > --- /dev/null
> > +++ b/drivers/scsi/spraid/spraid.h
> > @@ -0,0 +1,695 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/* Copyright(c) 2021 Ramaxel Memory Technology, Ltd */
> > +
> > +#ifndef __SPRAID_H_
> > +#define __SPRAID_H_
> > +
> > +#define SPRAID_CAP_MQES(cap) ((cap) & 0xffff)
> > +#define SPRAID_CAP_STRIDE(cap) (((cap) >> 32) & 0xf)
> > +#define SPRAID_CAP_MPSMIN(cap) (((cap) >> 48) & 0xf)
> > +#define SPRAID_CAP_MPSMAX(cap) (((cap) >> 52) & 0xf)
> > +#define SPRAID_CAP_TIMEOUT(cap) (((cap) >> 24) & 0xff)
> > +#define SPRAID_CAP_DMAMASK(cap) (((cap) >> 37) & 0xff)
> > +
> > +#define SPRAID_DEFAULT_MAX_CHANNEL 4
> > +#define SPRAID_DEFAULT_MAX_ID 240
> > +#define SPRAID_DEFAULT_MAX_LUN_PER_HOST 8
> > +#define MAX_SECTORS 2048
> > +
> > +#define IO_SQE_SIZE sizeof(struct spraid_ioq_command)
> > +#define ADMIN_SQE_SIZE sizeof(struct spraid_admin_command)
> > +#define SQE_SIZE(qid) (((qid) > 0) ? IO_SQE_SIZE : ADMIN_SQE_SIZE)
> > +#define CQ_SIZE(depth) ((depth) * sizeof(struct spraid_completion))
> > +#define SQ_SIZE(qid, depth) ((depth) * SQE_SIZE(qid))
> > +
> > +#define SENSE_SIZE(depth)	((depth) * SCSI_SENSE_BUFFERSIZE)
> > +
> > +#define SPRAID_AQ_DEPTH 128
> > +#define SPRAID_NR_AEN_COMMANDS 16
> > +#define SPRAID_AQ_BLK_MQ_DEPTH (SPRAID_AQ_DEPTH -
> > SPRAID_NR_AEN_COMMANDS) +#define SPRAID_AQ_MQ_TAG_DEPTH
> > (SPRAID_AQ_BLK_MQ_DEPTH - 1) +
> > +#define SPRAID_ADMIN_QUEUE_NUM 1
> > +#define SPRAID_PTCMDS_PERQ 1
> > +#define SPRAID_IO_BLK_MQ_DEPTH (hdev->shost->can_queue)
> > +#define SPRAID_NR_IOQ_PTCMDS (SPRAID_PTCMDS_PERQ *
> > hdev->shost->nr_hw_queues) +
> > +#define FUA_MASK 0x08
> > +#define SPRAID_MINORS BIT(MINORBITS)
> > +
> > +#define COMMAND_IS_WRITE(cmd) ((cmd)->common.opcode & 1)  
> 
> This is not used. Anything that is not used may be dropped.
> 
Ok. Changes will be included in the next version.

> > +
> > +#define SPRAID_IO_IOSQES 7
> > +#define SPRAID_IO_IOCQES 4
> > +#define PRP_ENTRY_SIZE 8
> > +
> > +#define SMALL_POOL_SIZE 256
> > +#define MAX_SMALL_POOL_NUM 16
> > +#define MAX_CMD_PER_DEV 64
> > +#define MAX_CDB_LEN 32
> > +
> > +#define SPRAID_UP_TO_MULTY4(x) (((x) + 4) & (~0x03))
> > +
> > +#define CQE_STATUS_SUCCESS (0x0)
> > +
> > +#define PCI_VENDOR_ID_RAMAXEL_LOGIC 0x1E81
> > +
> > +#define SPRAID_SERVER_DEVICE_HBA_DID		0x2100
> > +#define SPRAID_SERVER_DEVICE_RAID_DID		0x2200
> > +
> > +#define IO_6_DEFAULT_TX_LEN 256
> > +
> > +#define SPRAID_INT_PAGES 2
> > +#define SPRAID_INT_BYTES(hdev) (SPRAID_INT_PAGES *
> > (hdev)->page_size) +
> > +enum {
> > +	SPRAID_REQ_CANCELLED = (1 << 0),
> > +	SPRAID_REQ_USERCMD = (1 << 1),
> > +};
> > +
> > +enum {
> > +	SPRAID_SC_SUCCESS = 0x0,
> > +	SPRAID_SC_INVALID_OPCODE = 0x1,
> > +	SPRAID_SC_INVALID_FIELD  = 0x2,
> > +
> > +	SPRAID_SC_ABORT_LIMIT = 0x103,
> > +	SPRAID_SC_ABORT_MISSING = 0x104,
> > +	SPRAID_SC_ASYNC_LIMIT = 0x105,
> > +
> > +	SPRAID_SC_DNR = 0x4000,
> > +};
> > +
> > +enum {
> > +	SPRAID_REG_CAP  = 0x0000,
> > +	SPRAID_REG_CC   = 0x0014,
> > +	SPRAID_REG_CSTS = 0x001c,
> > +	SPRAID_REG_AQA  = 0x0024,
> > +	SPRAID_REG_ASQ  = 0x0028,
> > +	SPRAID_REG_ACQ  = 0x0030,
> > +	SPRAID_REG_DBS  = 0x1000,
> > +};
> > +
> > +enum {
> > +	SPRAID_CC_ENABLE     = 1 << 0,
> > +	SPRAID_CC_CSS_NVM    = 0 << 4,
> > +	SPRAID_CC_MPS_SHIFT  = 7,
> > +	SPRAID_CC_AMS_SHIFT  = 11,
> > +	SPRAID_CC_SHN_SHIFT  = 14,
> > +	SPRAID_CC_IOSQES_SHIFT = 16,
> > +	SPRAID_CC_IOCQES_SHIFT = 20,
> > +	SPRAID_CC_AMS_RR       = 0 << SPRAID_CC_AMS_SHIFT,
> > +	SPRAID_CC_SHN_NONE     = 0 << SPRAID_CC_SHN_SHIFT,
> > +	SPRAID_CC_IOSQES       = SPRAID_IO_IOSQES <<
> > SPRAID_CC_IOSQES_SHIFT,
> > +	SPRAID_CC_IOCQES       = SPRAID_IO_IOCQES <<
> > SPRAID_CC_IOCQES_SHIFT,
> > +	SPRAID_CC_SHN_NORMAL   = 1 << SPRAID_CC_SHN_SHIFT,
> > +	SPRAID_CC_SHN_MASK     = 3 << SPRAID_CC_SHN_SHIFT,
> > +	SPRAID_CSTS_CFS_SHIFT  = 1,
> > +	SPRAID_CSTS_SHST_SHIFT = 2,
> > +	SPRAID_CSTS_PP_SHIFT   = 5,
> > +	SPRAID_CSTS_RDY	       = 1 << 0,
> > +	SPRAID_CSTS_SHST_CMPLT = 2 << 2,
> > +	SPRAID_CSTS_SHST_MASK  = 3 << 2,
> > +	SPRAID_CSTS_CFS_MASK   = 1 << SPRAID_CSTS_CFS_SHIFT,
> > +	SPRAID_CSTS_PP_MASK    = 1 << SPRAID_CSTS_PP_SHIFT,
> > +};
> > +
> > +enum {
> > +	SPRAID_ADMIN_DELETE_SQ = 0x00,
> > +	SPRAID_ADMIN_CREATE_SQ = 0x01,
> > +	SPRAID_ADMIN_DELETE_CQ = 0x04,
> > +	SPRAID_ADMIN_CREATE_CQ = 0x05,
> > +	SPRAID_ADMIN_ABORT_CMD = 0x08,
> > +	SPRAID_ADMIN_SET_FEATURES = 0x09,
> > +	SPRAID_ADMIN_ASYNC_EVENT = 0x0c,
> > +	SPRAID_ADMIN_GET_INFO = 0xc6,
> > +	SPRAID_ADMIN_RESET = 0xc8,
> > +};
> > +
> > +enum {
> > +	SPRAID_GET_INFO_CTRL = 0,
> > +	SPRAID_GET_INFO_DEV_LIST = 1,
> > +};
> > +
> > +enum {
> > +	SPRAID_RESET_TARGET = 0,
> > +	SPRAID_RESET_BUS = 1,
> > +};
> > +
> > +enum {
> > +	SPRAID_AEN_ERROR = 0,
> > +	SPRAID_AEN_NOTICE = 2,
> > +	SPRAID_AEN_VS = 7,
> > +};
> > +
> > +enum {
> > +	SPRAID_AEN_DEV_CHANGED = 0x00,
> > +	SPRAID_AEN_HOST_PROBING = 0x10,
> > +};
> > +
> > +enum {
> > +	SPRAID_AEN_TIMESYN = 0x07
> > +};
> > +
> > +enum {
> > +	SPRAID_CMD_WRITE = 0x01,
> > +	SPRAID_CMD_READ = 0x02,
> > +
> > +	SPRAID_CMD_NONIO_NONE = 0x80,
> > +	SPRAID_CMD_NONIO_TODEV = 0x81,
> > +	SPRAID_CMD_NONIO_FROMDEV = 0x82,
> > +};
> > +
> > +enum {
> > +	SPRAID_QUEUE_PHYS_CONTIG = (1 << 0),
> > +	SPRAID_CQ_IRQ_ENABLED = (1 << 1),
> > +
> > +	SPRAID_FEAT_NUM_QUEUES = 0x07,
> > +	SPRAID_FEAT_ASYNC_EVENT = 0x0b,
> > +	SPRAID_FEAT_TIMESTAMP = 0x0e,
> > +};
> > +
> > +enum spraid_state {
> > +	SPRAID_NEW,
> > +	SPRAID_LIVE,
> > +	SPRAID_RESETTING,
> > +	SPRAID_DELETING,
> > +	SPRAID_DEAD,
> > +};
> > +
> > +enum {
> > +	SPRAID_CARD_HBA,
> > +	SPRAID_CARD_RAID,
> > +};
> > +
> > +enum spraid_cmd_type {
> > +	SPRAID_CMD_ADM,
> > +	SPRAID_CMD_IOPT,
> > +};
> > +
> > +struct spraid_completion {
> > +	__le32 result;  
> 
> I think that __le32 is used for userspace common defines, while we
> use le32 for internal to kernel
> 
I saw your new update. So ignore it.

> > +	union {
> > +		struct {
> > +			__u8	sense_len;
> > +			__u8	resv[3];
> > +		};
> > +		__le32	result1;
> > +	};
> > +	__le16 sq_head;
> > +	__le16 sq_id;
> > +	__u16  cmd_id;
> > +	__le16 status;
> > +};
> > +
> > +struct spraid_ctrl_info {
> > +	__le32 nd;
> > +	__le16 max_cmds;
> > +	__le16 max_channel;
> > +	__le32 max_tgt_id;
> > +	__le16 max_lun;
> > +	__le16 max_num_sge;
> > +	__le16 lun_num_in_boot;
> > +	__u8   mdts;
> > +	__u8   acl;
> > +	__u8   aerl;
> > +	__u8   card_type;
> > +	__u16  rsvd;
> > +	__u32  rtd3e;
> > +	__u8   sn[32];
> > +	__u8   fr[16];
> > +	__u8   rsvd1[4020];
> > +};
> > +
> > +struct spraid_dev {
> > +	struct pci_dev *pdev;
> > +	struct device *dev;  
> 
> do you really need both, as one can be derived from the other?
> 
The pointer of dev is from struct pci_dev. It is saved in struct
spraid_dev just for convenience: so that we do not need to get the
dev from pci_dev every time when using dev.

> > +	struct Scsi_Host *shost;
> > +	struct spraid_queue *queues;
> > +	struct dma_pool *prp_page_pool;
> > +	struct dma_pool *prp_small_pool[MAX_SMALL_POOL_NUM];
> > +	mempool_t *iod_mempool;
> > +	void __iomem *bar;
> > +	u32 max_qid;
> > +	u32 num_vecs;
> > +	u32 queue_count;
> > +	u32 ioq_depth;
> > +	int db_stride;
> > +	u32 __iomem *dbs;
> > +	struct rw_semaphore devices_rwsem;
> > +	int numa_node;
> > +	u32 page_size;
> > +	u32 ctrl_config;
> > +	u32 online_queues;
> > +	u64 cap;
> > +	int instance;
> > +	struct spraid_ctrl_info *ctrl_info;
> > +	struct spraid_dev_info *devices;
> > +
> > +	struct spraid_cmd *adm_cmds;
> > +	struct list_head adm_cmd_list;
> > +	spinlock_t adm_cmd_lock;
> > +
> > +	struct spraid_cmd *ioq_ptcmds;
> > +	struct list_head ioq_pt_list;
> > +	spinlock_t ioq_pt_lock;
> > +
> > +	struct work_struct scan_work;
> > +	struct work_struct timesyn_work;
> > +	struct work_struct reset_work;
> > +
> > +	enum spraid_state state;
> > +	spinlock_t state_lock;
> > +	struct request_queue *bsg_queue;
> > +};
> > +
> > +struct spraid_sgl_desc {
> > +	__le64 addr;
> > +	__le32 length;
> > +	__u8   rsvd[3];
> > +	__u8   type;
> > +};
> > +
> > +union spraid_data_ptr {
> > +	struct {
> > +		__le64 prp1;
> > +		__le64 prp2;
> > +	};
> > +	struct spraid_sgl_desc sgl;
> > +};
> > +
> > +struct spraid_admin_common_command {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	command_id;
> > +	__le32	hdid;
> > +	__le32	cdw2[4];
> > +	union spraid_data_ptr	dptr;
> > +	__le32	cdw10;
> > +	__le32	cdw11;
> > +	__le32	cdw12;
> > +	__le32	cdw13;
> > +	__le32	cdw14;
> > +	__le32	cdw15;
> > +};
> > +
> > +struct spraid_features {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	command_id;
> > +	__le32	hdid;
> > +	__u64	rsvd2[2];
> > +	union spraid_data_ptr dptr;
> > +	__le32	fid;
> > +	__le32	dword11;
> > +	__le32	dword12;
> > +	__le32	dword13;
> > +	__le32	dword14;
> > +	__le32	dword15;
> > +};
> > +
> > +struct spraid_create_cq {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	command_id;
> > +	__u32	rsvd1[5];
> > +	__le64	prp1;
> > +	__u64	rsvd8;
> > +	__le16	cqid;
> > +	__le16	qsize;
> > +	__le16	cq_flags;
> > +	__le16	irq_vector;
> > +	__u32	rsvd12[4];
> > +};
> > +
> > +struct spraid_create_sq {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	command_id;
> > +	__u32	rsvd1[5];
> > +	__le64	prp1;
> > +	__u64	rsvd8;
> > +	__le16	sqid;
> > +	__le16	qsize;
> > +	__le16	sq_flags;
> > +	__le16	cqid;
> > +	__u32	rsvd12[4];
> > +};
> > +
> > +struct spraid_delete_queue {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	command_id;
> > +	__u32	rsvd1[9];
> > +	__le16	qid;
> > +	__u16	rsvd10;
> > +	__u32	rsvd11[5];
> > +};
> > +
> > +struct spraid_get_info {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	command_id;
> > +	__le32	hdid;
> > +	__u32	rsvd2[4];
> > +	union spraid_data_ptr	dptr;
> > +	__u8	type;
> > +	__u8	rsvd10[3];
> > +	__le32	cdw11;
> > +	__u32	rsvd12[4];
> > +};
> > +
> > +struct spraid_usr_cmd {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	command_id;
> > +	__le32	hdid;
> > +	union {
> > +		struct {
> > +			__le16 subopcode;
> > +			__le16 rsvd1;
> > +		} info_0;
> > +		__le32 cdw2;
> > +	};
> > +	union {
> > +		struct {
> > +			__le16 data_len;
> > +			__le16 param_len;
> > +		} info_1;
> > +		__le32 cdw3;
> > +	};
> > +	__u64 metadata;
> > +	union spraid_data_ptr	dptr;
> > +	__le32 cdw10;
> > +	__le32 cdw11;
> > +	__le32 cdw12;
> > +	__le32 cdw13;
> > +	__le32 cdw14;
> > +	__le32 cdw15;
> > +};
> > +
> > +enum {
> > +	SPRAID_CMD_FLAG_SGL_METABUF = (1 << 6),
> > +	SPRAID_CMD_FLAG_SGL_METASEG = (1 << 7),
> > +	SPRAID_CMD_FLAG_SGL_ALL     = SPRAID_CMD_FLAG_SGL_METABUF
> > | SPRAID_CMD_FLAG_SGL_METASEG,  
> 
> about SPRAID_CMD_FLAG_SGL_ALL, this is the second item I checked for 
> being referenced and second item which I find is not referenced -
> please don't add stuff which is not referenced
> 
We will check and remove the items which are not referenced. Changes
will be included in the next version.

> > +};
> > +
> > +enum spraid_cmd_state {
> > +	SPRAID_CMD_IDLE = 0,
> > +	SPRAID_CMD_IN_FLIGHT = 1,
> > +	SPRAID_CMD_COMPLETE = 2,
> > +	SPRAID_CMD_TIMEOUT = 3,
> > +	SPRAID_CMD_TMO_COMPLETE = 4,
> > +};
> > +
> > +struct spraid_abort_cmd {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	command_id;
> > +	__le32	hdid;
> > +	__u64	rsvd2[4];
> > +	__le16	sqid;
> > +	__le16	cid;
> > +	__u32	rsvd11[5];
> > +};
> > +
> > +struct spraid_reset_cmd {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	command_id;
> > +	__le32	hdid;
> > +	__u64	rsvd2[4];
> > +	__u8	type;
> > +	__u8	rsvd10[3];
> > +	__u32	rsvd11[5];
> > +};
> > +
> > +struct spraid_admin_command {
> > +	union {
> > +		struct spraid_admin_common_command common;
> > +		struct spraid_features features;
> > +		struct spraid_create_cq create_cq;
> > +		struct spraid_create_sq create_sq;
> > +		struct spraid_delete_queue delete_queue;
> > +		struct spraid_get_info get_info;
> > +		struct spraid_abort_cmd abort;
> > +		struct spraid_reset_cmd reset;
> > +		struct spraid_usr_cmd usr_cmd;
> > +	};
> > +};
> > +
> > +struct spraid_ioq_common_command {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	command_id;
> > +	__le32	hdid;
> > +	__le16	sense_len;
> > +	__u8	cdb_len;
> > +	__u8	rsvd2;
> > +	__le32	cdw3[3];
> > +	union spraid_data_ptr	dptr;
> > +	__le32	cdw10[6];
> > +	__u8	cdb[32];
> > +	__le64	sense_addr;
> > +	__le32	cdw26[6];
> > +};
> > +
> > +struct spraid_rw_command {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	command_id;
> > +	__le32	hdid;
> > +	__le16	sense_len;
> > +	__u8	cdb_len;
> > +	__u8	rsvd2;
> > +	__u32	rsvd3[3];
> > +	union spraid_data_ptr	dptr;
> > +	__le64	slba;
> > +	__le16	nlb;
> > +	__le16	control;
> > +	__u32	rsvd13[3];
> > +	__u8	cdb[32];
> > +	__le64	sense_addr;
> > +	__u32	rsvd26[6];
> > +};
> > +
> > +struct spraid_scsi_nonio {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	command_id;
> > +	__le32	hdid;
> > +	__le16	sense_len;
> > +	__u8	cdb_length;
> > +	__u8	rsvd2;
> > +	__u32	rsvd3[3];
> > +	union spraid_data_ptr	dptr;
> > +	__u32	rsvd10[5];
> > +	__le32	buffer_len;
> > +	__u8	cdb[32];
> > +	__le64	sense_addr;
> > +	__u32	rsvd26[6];
> > +};
> > +
> > +struct spraid_ioq_command {
> > +	union {
> > +		struct spraid_ioq_common_command common;
> > +		struct spraid_rw_command rw;
> > +		struct spraid_scsi_nonio scsi_nonio;
> > +	};
> > +};
> > +
> > +struct spraid_passthru_common_cmd {
> > +	__u8	opcode;
> > +	__u8	flags;
> > +	__u16	rsvd0;
> > +	__u32	nsid;
> > +	union {
> > +		struct {
> > +			__u16 subopcode;
> > +			__u16 rsvd1;
> > +		} info_0;
> > +		__u32 cdw2;
> > +	};
> > +	union {
> > +		struct {
> > +			__u16 data_len;
> > +			__u16 param_len;
> > +		} info_1;
> > +		__u32 cdw3;
> > +	};
> > +	__u64 metadata;
> > +
> > +	__u64 addr;
> > +	__u64 prp2;
> > +
> > +	__u32 cdw10;
> > +	__u32 cdw11;
> > +	__u32 cdw12;
> > +	__u32 cdw13;
> > +	__u32 cdw14;
> > +	__u32 cdw15;
> > +	__u32 timeout_ms;
> > +	__u32 result0;
> > +	__u32 result1;
> > +};
> > +
> > +struct spraid_ioq_passthru_cmd {
> > +	__u8  opcode;
> > +	__u8  flags;
> > +	__u16 rsvd0;
> > +	__u32 nsid;
> > +	union {
> > +		struct {
> > +			__u16 res_sense_len;
> > +			__u8  cdb_len;
> > +			__u8  rsvd0;
> > +		} info_0;
> > +		__u32 cdw2;
> > +	};
> > +	union {
> > +		struct {
> > +			__u16 subopcode;
> > +			__u16 rsvd1;
> > +		} info_1;
> > +		__u32 cdw3;
> > +	};
> > +	union {
> > +		struct {
> > +			__u16 rsvd;
> > +			__u16 param_len;
> > +		} info_2;
> > +		__u32 cdw4;
> > +	};
> > +	__u32 cdw5;
> > +	__u64 addr;
> > +	__u64 prp2;
> > +	union {
> > +		struct {
> > +			__u16 eid;
> > +			__u16 sid;
> > +		} info_3;
> > +		__u32 cdw10;
> > +	};
> > +	union {
> > +		struct {
> > +			__u16 did;
> > +			__u8  did_flag;
> > +			__u8  rsvd2;
> > +		} info_4;
> > +		__u32 cdw11;
> > +	};
> > +	__u32 cdw12;
> > +	__u32 cdw13;
> > +	__u32 cdw14;
> > +	__u32 data_len;
> > +	__u32 cdw16;
> > +	__u32 cdw17;
> > +	__u32 cdw18;
> > +	__u32 cdw19;
> > +	__u32 cdw20;
> > +	__u32 cdw21;
> > +	__u32 cdw22;
> > +	__u32 cdw23;
> > +	__u64 sense_addr;
> > +	__u32 cdw26[4];
> > +	__u32 timeout_ms;
> > +	__u32 result0;
> > +	__u32 result1;
> > +};
> > +
> > +struct spraid_bsg_request {
> > +	u32  msgcode;
> > +	u32 control;
> > +	union {
> > +		struct spraid_passthru_common_cmd admcmd;
> > +		struct spraid_ioq_passthru_cmd    ioqcmd;
> > +	};
> > +};
> > +
> > +enum {
> > +	SPRAID_BSG_ADM,
> > +	SPRAID_BSG_IOQ,
> > +};
> > +
> > +struct spraid_cmd {
> > +	int qid;
> > +	int cid;
> > +	u32 result0;
> > +	u32 result1;
> > +	u16 status;
> > +	void *priv;
> > +	enum spraid_cmd_state state;
> > +	struct completion cmd_done;
> > +	struct list_head list;
> > +};
> > +
> > +struct spraid_queue {
> > +	struct spraid_dev *hdev;
> > +	spinlock_t sq_lock; /* spinlock for lock handling */  
> 
> such comments are of little use
> 
Ok. Comments will be improved in the next version.

> > +
> > +	spinlock_t cq_lock ____cacheline_aligned_in_smp; /*
> > spinlock for lock handling */ +
> > +	void *sq_cmds;
> > +
> > +	struct spraid_completion *cqes;
> > +
> > +	dma_addr_t sq_dma_addr;
> > +	dma_addr_t cq_dma_addr;
> > +	u32 __iomem *q_db;
> > +	u8 cq_phase;
> > +	u8 sqes;
> > +	u16 qid;
> > +	u16 sq_tail;
> > +	u16 cq_head;
> > +	u16 last_cq_head;
> > +	u16 q_depth;
> > +	s16 cq_vector;
> > +	void *sense;
> > +	dma_addr_t sense_dma_addr;
> > +	struct dma_pool *prp_small_pool;
> > +};
> > +
> > +struct spraid_iod {
> > +	struct spraid_queue *spraidq;
> > +	enum spraid_cmd_state state;
> > +	int npages;
> > +	u32 nsge;
> > +	u32 length;
> > +	bool use_sgl;
> > +	bool sg_drv_mgmt;
> > +	dma_addr_t first_dma;
> > +	void *sense;
> > +	dma_addr_t sense_dma;
> > +	struct scatterlist *sg;
> > +	struct scatterlist inline_sg[0];
> > +};
> > +
> > +#define SPRAID_DEV_INFO_ATTR_BOOT(attr) ((attr) & 0x01)
> > +#define SPRAID_DEV_INFO_ATTR_VD(attr) (((attr) & 0x02) == 0x0)
> > +#define SPRAID_DEV_INFO_ATTR_PT(attr) (((attr) & 0x22) == 0x02)
> > +#define SPRAID_DEV_INFO_ATTR_RAWDISK(attr) ((attr) & 0x20)
> > +
> > +#define SPRAID_DEV_INFO_FLAG_VALID(flag) ((flag) & 0x01)
> > +#define SPRAID_DEV_INFO_FLAG_CHANGE(flag) ((flag) & 0x02)
> > +
> > +struct spraid_dev_info {
> > +	__le32	hdid;
> > +	__le16	target;
> > +	__u8	channel;
> > +	__u8	lun;
> > +	__u8	attr;
> > +	__u8	flag;
> > +	__le16	max_io_kb;
> > +};
> > +
> > +#define MAX_DEV_ENTRY_PER_PAGE_4K	340
> > +struct spraid_dev_list {
> > +	__le32	dev_num;
> > +	__u32	rsvd0[3];
> > +	struct spraid_dev_info
> > devices[MAX_DEV_ENTRY_PER_PAGE_4K]; +};
> > +
> > +struct spraid_sdev_hostdata {
> > +	u32 hdid;
> > +};
> > +
> > +#endif
> > diff --git a/drivers/scsi/spraid/spraid_main.c
> > b/drivers/scsi/spraid/spraid_main.c new file mode 100644
> > index 000000000000..7edce06b62a4
> > --- /dev/null
> > +++ b/drivers/scsi/spraid/spraid_main.c
> > @@ -0,0 +1,3266 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright(c) 2021 Ramaxel Memory Technology, Ltd */
> > +
> > +/* Ramaxel Raid SPXXX Series Linux Driver */
> > +
> > +#define pr_fmt(fmt) "spraid: " fmt
> > +
> > +#include <linux/sched/signal.h>
> > +#include <linux/pci.h>
> > +#include <linux/aer.h>
> > +#include <linux/module.h>
> > +#include <linux/ioport.h>
> > +#include <linux/device.h>
> > +#include <linux/delay.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/cdev.h>
> > +#include <linux/sysfs.h>
> > +#include <linux/gfp.h>
> > +#include <linux/types.h>
> > +#include <linux/ratelimit.h>
> > +#include <linux/once.h>
> > +#include <linux/debugfs.h>
> > +#include <linux/io-64-nonatomic-lo-hi.h>
> > +#include <linux/blkdev.h>
> > +#include <linux/bsg-lib.h>
> > +#include <asm/unaligned.h>  
> 
> alphabetic ordering preferred
> 
Ok. Changes will be included in the next version.

> > +
> > +#include <scsi/scsi.h>
> > +#include <scsi/scsi_cmnd.h>
> > +#include <scsi/scsi_device.h>
> > +#include <scsi/scsi_host.h>
> > +#include <scsi/scsi_transport.h>
> > +#include <scsi/scsi_dbg.h>
> > +#include <scsi/sg.h>
> > +
> > +
> > +#include "spraid.h"
> > +
> > +#define SCMD_TMOUT_RAWDISK 180
> > +
> > +#define SCMD_TMOUT_VD 180
> > +
> > +static int ioq_depth_set(const char *val, const struct
> > kernel_param *kp); +static const struct kernel_param_ops
> > ioq_depth_ops = {
> > +	.set = ioq_depth_set,
> > +	.get = param_get_uint,
> > +};
> > +
> > +static u32 io_queue_depth = 1024;
> > +module_param_cb(io_queue_depth, &ioq_depth_ops, &io_queue_depth,
> > 0644); +MODULE_PARM_DESC(io_queue_depth, "set io queue depth,
> > should >= 2");  
> 
> why do we need a commandline param for this?
> 
The maximum queue depth supported by hardware is 1024. The parameter is
to change the queue depth for different usages to get the best
performance.


> > +
> > +static int small_pool_num_set(const char *val, const struct
> > kernel_param *kp) +{
> > +	u8 n = 0;
> > +	int ret;
> > +
> > +	ret = kstrtou8(val, 10, &n);
> > +	if (ret != 0)
> > +		return -EINVAL;
> > +	if (n > MAX_SMALL_POOL_NUM)
> > +		n = MAX_SMALL_POOL_NUM;
> > +	if (n < 1)
> > +		n = 1;
> > +	*((u8 *)kp->arg) = n;
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct kernel_param_ops small_pool_num_ops = {
> > +	.set = small_pool_num_set,
> > +	.get = param_get_byte,
> > +};
> > +
> > +/* It was found that the spindlock of a single pool conflicts  
> 
> spinlock
> 
Sorry. Typo. Changes will be included in the next version.

> > + * a lot with multiple CPUs.So multiple pools are introduced
> > + * to reduce the conflictions.  
> 
> so what are these small pools used for?
> 
Will add the following to comments: Small pools are used to save PRP
for small IOs. 

> > + */
> > +static unsigned char small_pool_num = 4;
> > +module_param_cb(small_pool_num, &small_pool_num_ops,
> > &small_pool_num, 0644); +MODULE_PARM_DESC(small_pool_num, "set prp
> > small pool num, default 4, MAX 16"); +
> > +static void spraid_free_queue(struct spraid_queue *spraidq);
> > +static void spraid_handle_aen_notice(struct spraid_dev *hdev, u32
> > result); +static void spraid_handle_aen_vs(struct spraid_dev *hdev,
> > u32 result, u32 result1); +
> > +static DEFINE_IDA(spraid_instance_ida);
> > +
> > +static struct class *spraid_class;
> > +
> > +#define SPRAID_CAP_TIMEOUT_UNIT_MS	(HZ / 2)
> > +
> > +static struct workqueue_struct *spraid_wq;
> > +
> > +#define SPRAID_DRV_VERSION	"1.0.0.0"  
> 
> I don't see much value in driver versioning. As I see, the kernel 
> version is the driver version.
> 
OK. Will delete it in the next version.

> > +
> > +#define ADMIN_TIMEOUT		(60 * HZ)
> > +#define ADMIN_ERR_TIMEOUT	32757
> > +
> > +#define SPRAID_WAIT_ABNL_CMD_TIMEOUT	(3 * 2)  
> 
> 6?
> 
OK. Changes will be included in the next version.

> > +
> > +#define SPRAID_DMA_MSK_BIT_MAX	64
> > +
> > +enum FW_STAT_CODE {
> > +	FW_STAT_OK = 0,
> > +	FW_STAT_NEED_CHECK,
> > +	FW_STAT_ERROR,
> > +	FW_STAT_EP_PCIE_ERROR,
> > +	FW_STAT_NAC_DMA_ERROR,
> > +	FW_STAT_ABORTED,
> > +	FW_STAT_NEED_RETRY
> > +};
> > +
> > +static int ioq_depth_set(const char *val, const struct
> > kernel_param *kp) +{
> > +	int n = 0;
> > +	int ret;
> > +
> > +	ret = kstrtoint(val, 10, &n);
> > +	if (ret != 0 || n < 2)
> > +		return -EINVAL;
> > +
> > +	return param_set_int(val, kp);
> > +}
> > +
> > +static int spraid_remap_bar(struct spraid_dev *hdev, u32 size)
> > +{
> > +	struct pci_dev *pdev = hdev->pdev;
> > +
> > +	if (size > pci_resource_len(pdev, 0)) {
> > +		dev_err(hdev->dev, "Input size[%u] exceed bar0
> > length[%llu]\n",
> > +			size, pci_resource_len(pdev, 0));
> > +		return -ENOMEM;
> > +	}
> > +
> > +	if (hdev->bar)
> > +		iounmap(hdev->bar);
> > +
> > +	hdev->bar = ioremap(pci_resource_start(pdev, 0), size);  
> 
> is there a device-managed version of this? pcim_ioremap() maybe?
> 
Under investigation.

> > +	if (!hdev->bar) {
> > +		dev_err(hdev->dev, "ioremap for bar0 failed\n");
> > +		return -ENOMEM;
> > +	}
> > +	hdev->dbs = hdev->bar + SPRAID_REG_DBS;
> > +
> > +	return 0;
> > +}
> > +
> > +static int spraid_dev_map(struct spraid_dev *hdev)
> > +{
> > +	struct pci_dev *pdev = hdev->pdev;
> > +	int ret;
> > +
> > +	ret = pci_request_mem_regions(pdev, "spraid");
> > +	if (ret) {
> > +		dev_err(hdev->dev, "fail to request memory
> > regions\n");
> > +		return ret;
> > +	}
> > +
> > +	ret = spraid_remap_bar(hdev, SPRAID_REG_DBS + 4096);
> > +	if (ret) {
> > +		pci_release_mem_regions(pdev);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void spraid_dev_unmap(struct spraid_dev *hdev)
> > +{
> > +	struct pci_dev *pdev = hdev->pdev;
> > +
> > +	if (hdev->bar) {
> > +		iounmap(hdev->bar);
> > +		hdev->bar = NULL;
> > +	}
> > +	pci_release_mem_regions(pdev);  
> 
> again, please check for devm/pcim version of the alloc/request/enable 
> functions, so that you don't need to do this manually
> 
Under investigation.

> > +}
> > +
> > +static int spraid_pci_enable(struct spraid_dev *hdev)
> > +{
> > +	struct pci_dev *pdev = hdev->pdev;
> > +	int ret = -ENOMEM;
> > +	u64 maskbit = SPRAID_DMA_MSK_BIT_MAX;
> > +
> > +	if (pci_enable_device_mem(pdev)) {
> > +		dev_err(hdev->dev, "Enable pci device memory
> > resources failed\n");
> > +		return ret;
> > +	}
> > +	pci_set_master(pdev);
> > +
> > +	if (readl(hdev->bar + SPRAID_REG_CSTS) == U32_MAX) {
> > +		ret = -ENODEV;
> > +		dev_err(hdev->dev, "Read csts register failed\n");
> > +		goto disable;
> > +	}
> > +
> > +	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
> > +	if (ret < 0) {
> > +		dev_err(hdev->dev, "Allocate one IRQ for setup
> > admin channel failed\n");
> > +		goto disable;
> > +	}
> > +
> > +	hdev->cap = lo_hi_readq(hdev->bar + SPRAID_REG_CAP);
> > +	hdev->ioq_depth = min_t(u32, SPRAID_CAP_MQES(hdev->cap) +
> > 1, io_queue_depth);
> > +	hdev->db_stride = 1 << SPRAID_CAP_STRIDE(hdev->cap);  
> 
> hdev is your host control structure. What is the point of storing
> values in it which can easily be derived from other values in the
> host control structure?
> 
It is for the convenience of later use: do not need to read it from
registers every time. The storing values are used multiple times later. 

> > +
> > +	maskbit = SPRAID_CAP_DMAMASK(hdev->cap);
> > +	if (maskbit < 32 || maskbit > SPRAID_DMA_MSK_BIT_MAX) {
> > +		dev_err(hdev->dev, "err, dma mask invalid[%llu],
> > set to default\n", maskbit);
> > +		maskbit = SPRAID_DMA_MSK_BIT_MAX;
> > +	}
> > +	if (dma_set_mask_and_coherent(&pdev->dev,
> > DMA_BIT_MASK(maskbit))) {
> > +		dev_err(hdev->dev, "set dma mask and coherent
> > failed\n");
> > +		goto disable;
> > +	}
> > +
> > +	dev_info(hdev->dev, "set dma mask[%llu] success\n",
> > maskbit); +
> > +	pci_enable_pcie_error_reporting(pdev);
> > +	pci_save_state(pdev);
> > +
> > +	return 0;
> > +
> > +disable:
> > +	pci_disable_device(pdev);
> > +	return ret;
> > +}
> > +
> > +static int spraid_npages_prp(u32 size, struct spraid_dev *hdev)
> > +{
> > +	u32 nprps = DIV_ROUND_UP(size + hdev->page_size,
> > hdev->page_size); +
> > +	return DIV_ROUND_UP(PRP_ENTRY_SIZE * nprps, PAGE_SIZE -
> > PRP_ENTRY_SIZE); +}
> > +
> > +static int spraid_npages_sgl(u32 nseg)
> > +{
> > +	return DIV_ROUND_UP(nseg * sizeof(struct spraid_sgl_desc),
> > PAGE_SIZE); +}
> > +
> > +static void **spraid_iod_list(struct spraid_iod *iod)
> > +{
> > +	return (void **)(iod->inline_sg + (iod->sg_drv_mgmt ?
> > iod->nsge : 0)); +}
> > +
> > +static u32 spraid_iod_ext_size(struct spraid_dev *hdev, u32 size,
> > u32 nsge,
> > +			       bool sg_drv_mgmt, bool use_sgl)
> > +{
> > +	size_t alloc_size, sg_size;
> > +
> > +	if (use_sgl)
> > +		alloc_size = sizeof(__le64 *) *
> > spraid_npages_sgl(nsge);
> > +	else
> > +		alloc_size = sizeof(__le64 *) *
> > spraid_npages_prp(size, hdev); +
> > +	sg_size = sg_drv_mgmt ? (sizeof(struct scatterlist) *
> > nsge) : 0;
> > +	return sg_size + alloc_size;
> > +}
> > +
> > +static u32 spraid_cmd_size(struct spraid_dev *hdev, bool
> > sg_drv_mgmt, bool use_sgl) +{
> > +	u32 alloc_size = spraid_iod_ext_size(hdev,
> > SPRAID_INT_BYTES(hdev),
> > +				SPRAID_INT_PAGES, sg_drv_mgmt,
> > use_sgl); +
> > +	dev_info(hdev->dev, "sg_drv_mgmt: %s, use_sgl: %s, iod
> > size: %lu, alloc_size: %u\n",
> > +		    sg_drv_mgmt ? "true" : "false", use_sgl ?
> > "true" : "false",
> > +		    sizeof(struct spraid_iod), alloc_size);  
> 
> strange to have a print like this in such a function
> 
OK, It will be deleted in the next version.

> > +
> > +	return sizeof(struct spraid_iod) + alloc_size;
> > +}
> > +
> > +static int spraid_setup_prps(struct spraid_dev *hdev, struct
> > spraid_iod *iod) +{
> > +	struct scatterlist *sg = iod->sg;
> > +	u64 dma_addr = sg_dma_address(sg);  
> 
> this should be dma_addr_t
> 
OK. Changes will be included in the next version.

> > +	int dma_len = sg_dma_len(sg);  
> 
> this should be unsigned int
> 
"int dma_len" will be used in later algorithm since the sign is needed.
and we can guarantee it won¡¯t overflow.

> > +	__le64 *prp_list, *old_prp_list;
> > +	u32 page_size = hdev->page_size;
> > +	int offset = dma_addr & (page_size - 1);
> > +	void **list = spraid_iod_list(iod);
> > +	int length = iod->length;
> > +	struct dma_pool *pool;
> > +	dma_addr_t prp_dma;
> > +	int nprps, i;
> > +  

