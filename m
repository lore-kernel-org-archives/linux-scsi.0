From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [v2 PATCH 2/5] bnx2fc: Broadcom FCoE offload driver submission
 (header files)
Date: Thu, 13 Jan 2011 16:53:57 -0600
Message-ID: <4D2F8285.8040205@cs.wisc.edu>
References: <1293170552.4676.572.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41004 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab1AMWyG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jan 2011 17:54:06 -0500
In-Reply-To: <1293170552.4676.572.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org, mchan@broadcom.com

On 12/24/2010 12:02 AM, Bhanu Gollapudi wrote:
> diff --git a/drivers/scsi/bnx2fc/57xx_fcoe_constants.h b/drivers/scsi/bnx2fc/57xx_fcoe_constants.h
> new file mode 100644
> index 0000000..c1b4e77
> --- /dev/null
> +++ b/drivers/scsi/bnx2fc/57xx_fcoe_constants.h
> @@ -0,0 +1,261 @@
> +#ifndef __57XX_FCOE_CONSTANTS_H_
> +#define __57XX_FCOE_CONSTANTS_H_
> +
> +/**
> + * This file defines HSI constants for the FCoE flows
> + */
> +


There is a bunch of old defines and maybe structs that are not used. 
Remove them.


> +#endif /* __57XX_FCOE_HSI_LINUX_LE__ */
> diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
> new file mode 100644
> index 0000000..0ba6d2e
> --- /dev/null
> +++ b/drivers/scsi/bnx2fc/bnx2fc.h
> @@ -0,0 +1,545 @@
> +#ifndef _BNX2FC_H_
> +#define _BNX2FC_H_
> +/* bnx2fc.h: Broadcom NetXtreme II Linux FCoE offload driver.
> + *
> + * Copyright (c) 2008 - 2010 Broadcom Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + *
> + * Written by: Bhanu Prakash Gollapudi (bprakash@broadcom.com)
> + */
> +
> +#include<linux/version.h>
> +#include<linux/module.h>
> +#include<linux/moduleparam.h>
> +
> +#include<linux/kernel.h>
> +#include<linux/skbuff.h>
> +#include<linux/netdevice.h>
> +#include<linux/etherdevice.h>
> +#include<linux/ethtool.h>
> +#include<linux/if_ether.h>
> +#include<linux/if_vlan.h>
> +#include<linux/kthread.h>
> +#include<linux/crc32.h>
> +#include<linux/cpu.h>
> +
> +#include<linux/types.h>
> +#include<linux/list.h>
> +#include<linux/delay.h>
> +#include<asm/byteorder.h>
> +#include<linux/timer.h>
> +#include<linux/errno.h>
> +#include<linux/pci.h>
> +#include<linux/init.h>
> +#include<linux/dma-mapping.h>
> +#include<linux/workqueue.h>
> +#include<linux/mutex.h>
> +#include<linux/spinlock.h>
> +#include<linux/bitops.h>
> +#include<linux/log2.h>
> +
> +#include<net/tcp.h>
> +
> +#include<scsi/scsi.h>
> +#include<scsi/scsi_host.h>
> +#include<scsi/scsi_device.h>
> +#include<scsi/scsi_cmnd.h>
> +#include<scsi/scsi_eh.h>
> +#include<scsi/scsi_tcq.h>
> +#include<scsi/fc/fc_fip.h>
> +#include<scsi/fc/fc_fc2.h>
> +#include<scsi/libfc.h>
> +#include<scsi/libfcoe.h>
> +#include<scsi/fc_frame.h>
> +
> +#include<scsi/fc/fc_fcoe.h>
> +
> +#include<scsi/scsi_transport.h>
> +#include<scsi/scsi_transport_fc.h>
> +
> +#include<linux/fs.h>
> +#include<linux/mm.h>
> +#include<linux/interrupt.h>
> +#include<linux/sched.h>
> +#include<linux/uaccess.h>
> +#include<linux/io.h>

These linux includes should be with the other ones.

> +
> +#include "57xx_hsi_bnx2fc.h"
> +
> +#include "bnx2fc_debug.h"
> +#include "../../net/cnic_if.h"
> +
> +#include "fcoe_constants.h"
> +
> +#define BNX2FC_NAME		"bnx2fc"
> +#define BNX2FC_VERSION		"1.0.0"
> +
> +#define PFX			"bnx2fc: "
> +
> +#define BNX2FC_VLAN0FIX		1

Not used.

> +
> +#define BNX2X_DOORBELL_PCI_BAR                  2
> +
> +#define BNX2FC_MAX_BD_LEN		0xffff
> +#define BNX2FC_BD_SPLIT_SZ		0x8000
> +#define BNX2FC_MAX_BDS_PER_CMD		256
> +#define MAX_PAGES_PER_EXCHG_CTX_POOL	1024
> +
> +#define BNX2FC_SQ_WQES_MAX	256
> +
> +#define BNX2FC_SCSI_MAX_SQES	((3 * BNX2FC_SQ_WQES_MAX) / 8)
> +#define BNX2FC_TM_MAX_SQES	((BNX2FC_SQ_WQES_MAX) / 2)
> +#define BNX2FC_ELS_MAX_SQES	(BNX2FC_TM_MAX_SQES - 1)
> +
> +#define BNX2FC_RQ_WQES_MAX	16
> +#define BNX2FC_CQ_WQES_MAX	(BNX2FC_SQ_WQES_MAX + BNX2FC_RQ_WQES_MAX)
> +
> +#define BNX2FC_MAX_SESS		2048

Not used.

> +#define BNX2FC_NUM_MAX_SESS	128


What is the difference between this and BNX2FC_MAX_FCP_TGT below? Should 
they be the same? Seems low if you are using multipath too.



> +#define BNX2FC_NUM_MAX_SESS_LOG	(ilog2(BNX2FC_NUM_MAX_SESS))
> +
> +#ifdef CONFIG_X86_64
> +#define BNX2FC_MAX_OUTSTANDING_CMNDS	4096
> +#else
> +#define BNX2FC_MAX_OUTSTANDING_CMNDS	1024
> +#endif

Why is this different for other archs?


> +#define BNX2FC_MIN_PAYLOAD		256
> +#define BNX2FC_MAX_PAYLOAD		2048
> +
> +#define BNX2FC_RQ_BUF_SZ		256
> +#define BNX2FC_RQ_BUF_LOG_SZ		(ilog2(BNX2FC_RQ_BUF_SZ))
> +
> +#define BNX2FC_SQ_WQE_SIZE		(sizeof(struct fcoe_sqe))
> +#define BNX2FC_CQ_WQE_SIZE		(sizeof(struct fcoe_cqe))
> +#define BNX2FC_RQ_WQE_SIZE		(BNX2FC_RQ_BUF_SZ)
> +#define BNX2FC_XFERQ_WQE_SIZE		(sizeof(struct fcoe_xfrqe))
> +#define BNX2FC_CONFQ_WQE_SIZE		(sizeof(struct fcoe_confqe))
> +#define BNX2FC_5771X_DB_PAGE_SIZE	128
> +
> +#define BNX2FC_MAX_TASKS		BNX2FC_MAX_OUTSTANDING_CMNDS
> +#define BNX2FC_TASK_SIZE		128
> +/*#define BNX2FC_TASK_SIZE		(sizeof(struct fcoe_task_ctx_entry)) */
> +#define	BNX2FC_TASKS_PER_PAGE		(PAGE_SIZE/BNX2FC_TASK_SIZE)
> +#define BNX2FC_TASK_CTX_ARR_SZ		(BNX2FC_MAX_TASKS/BNX2FC_TASKS_PER_PAGE)
> +
> +#define BNX2FC_MAX_ROWS_IN_HASH_TBL	8
> +#define BNX2FC_HASH_TBL_CHUNK_SIZE	(16 * 1024)
> +
> +#define BNX2FC_MAX_SEQS			255
> +
> +#define  SIMPLE_QUEUE			0x00
> +#define  HEAD_OF_QUEUE			0x01
> +#define  ORDERED_QUEUE			0x02
> +#define  ACA_QUEUE			0x04


these look like fc_fcp.h defs.

> +#define  UNTAGGED			0x05
> +
> +#define FCP_TMF_TGT_RESET		0x20
> +

fc_fcp.h defs.


> +#define FC_SRB_READ			(1<<  1)
> +#define FC_SRB_WRITE			(1<<  0)
> +
> +#define BNX2FC_MIN_XID			0
> +#define BNX2FC_MAX_XID			(BNX2FC_MAX_OUTSTANDING_CMNDS - 1)
> +#define FCOE_MIN_XID			(BNX2FC_MAX_OUTSTANDING_CMNDS)
> +#define FCOE_MAX_XID		\
> +			(BNX2FC_MAX_OUTSTANDING_CMNDS + (nr_cpu_ids * 256))
> +#define BNX2FC_MAX_LUN			0xFFFF


Is this a hw limit?

For bnx2i it is only 512. Should one be fixed or does the fcoe function 
support a higher value?



> +#define BNX2FC_MAX_FCP_TGT		256
> +#define BNX2FC_MAX_CMD_LEN		16
> +#define BNX2FC_IOS_PER_WORK		24


Not used.



> +#define IP_V4 0
> +#define IP_V6 1

What are these for?


Could you go through the headers and removed unused stuff. I noted some 
that had interesting names to me so I was looking at them, but there are 
probably more.


