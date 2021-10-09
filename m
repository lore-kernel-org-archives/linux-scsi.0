Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A5DC433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 13:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E50D60F57
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 13:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhJINei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 09:34:38 -0400
Received: from email.ramaxel.com ([221.4.138.186]:15578 "EHLO
        VLXDG1SPAM1.ramaxel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233209AbhJINei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2021 09:34:38 -0400
Received: from V12DG1MBS01.ramaxel.local (v12dg1mbs01.ramaxel.local [172.26.18.31])
        by VLXDG1SPAM1.ramaxel.com with ESMTPS id 199DW9YY023061
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 9 Oct 2021 21:32:09 +0800 (GMT-8)
        (envelope-from songyl@ramaxel.com)
Received: from songyl (10.64.10.54) by V12DG1MBS01.ramaxel.local
 (172.26.18.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Sat, 9
 Oct 2021 21:32:08 +0800
Date:   Sat, 9 Oct 2021 13:32:07 +0000
From:   Yanling Song <songyl@ramaxel.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <songyl@ramaxel.com>
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Message-ID: <20211009133207.789ad116@songyl>
In-Reply-To: <526271c5-a745-7666-6b18-9eb61898f1db@acm.org>
References: <20210930034752.248781-1-songyl@ramaxel.com>
        <526271c5-a745-7666-6b18-9eb61898f1db@acm.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.10.54]
X-ClientProxiedBy: V12DG1MBS03.ramaxel.local (172.26.18.33) To
 V12DG1MBS01.ramaxel.local (172.26.18.31)
X-DNSRBL: 
X-MAIL: VLXDG1SPAM1.ramaxel.com 199DW9YY023061
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 8 Oct 2021 20:58:17 -0700
Bart Van Assche <bvanassche@acm.org> wrote:

> On 9/29/21 20:47, Yanling Song wrote:
> > +#define dev_log_dbg(dev, fmt, ...)	do { \
> > +	if (unlikely(log_debug_switch))	\
> > +		dev_info(dev, "[%s] [%d] " fmt,	\
> > +			__func__, __LINE__, ##__VA_ARGS__);
> > \ +} while (0)  
> 
> Please use pr_debug() instead of introducing dev_log_dbg().

Ok. Will use pr_debug in the next version.

> 
> > +static inline
> > +struct spraid_admin_request *spraid_admin_req(struct request *req)
> > +{
> > +	return blk_mq_rq_to_pdu(req);
> > +}  
> 
> Please read the section with the title "The inline disease" in 
> Documentation/process/coding-style.rst.

Ok. Will use MACRO to replace inline in the next version.

> 
> > +static inline bool spraid_is_rw_scmd(struct scsi_cmnd *scmd)
> > +{
> > +	switch (scmd->cmnd[0]) {
> > +	case READ_6:
> > +	case READ_10:
> > +	case READ_12:
> > +	case READ_16:
> > +	case READ_32:
> > +	case WRITE_6:
> > +	case WRITE_10:
> > +	case WRITE_12:
> > +	case WRITE_16:
> > +	case WRITE_32:
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}  
> 
> Please use op_is_write() instead of reimplementing it.

op_is_write() does not meet our requirement: Both read and write
commands have to be checked, not just write command.

> 
> > +	if (scmd->sc_data_direction == DMA_TO_DEVICE) {
> > +		rw->opcode = SPRAID_CMD_WRITE;
> > +	} else if (scmd->sc_data_direction == DMA_FROM_DEVICE) {
> > +		rw->opcode = SPRAID_CMD_READ;
> > +	} else {
> > +		dev_err(hdev->dev, "Invalid IO for unsupported
> > data direction: %d\n",
> > +			scmd->sc_data_direction);
> > +		WARN_ON(1);
> > +	}
> > +
> > +	/* 6-byte READ(0x08) or WRITE(0x0A) cdb */
> > +	if (scmd->cmd_len == 6) {
> > +		datalength = (u32)(scmd->cmnd[4] == 0 ?
> > +				IO_6_DEFAULT_TX_LEN :
> > scmd->cmnd[4]);
> > +		start_lba_lo = ((u32)scmd->cmnd[1] << 16) |
> > +				((u32)scmd->cmnd[2] << 8) |
> > (u32)scmd->cmnd[3]; +
> > +		start_lba_lo &= 0x1FFFFF;
> > +	}
> > +
> > +	/* 10-byte READ(0x28) or WRITE(0x2A) cdb */
> > +	else if (scmd->cmd_len == 10) {
> > +		datalength = (u32)scmd->cmnd[8] |
> > ((u32)scmd->cmnd[7] << 8);
> > +		start_lba_lo = ((u32)scmd->cmnd[2] << 24) |
> > +				((u32)scmd->cmnd[3] << 16) |
> > +				((u32)scmd->cmnd[4] << 8) |
> > (u32)scmd->cmnd[5]; +
> > +		if (scmd->cmnd[1] & FUA_MASK)
> > +			control |= SPRAID_RW_FUA;
> > +	}
> > +
> > +	/* 12-byte READ(0xA8) or WRITE(0xAA) cdb */
> > +	else if (scmd->cmd_len == 12) {
> > +		datalength = ((u32)scmd->cmnd[6] << 24) |
> > +				((u32)scmd->cmnd[7] << 16) |
> > +				((u32)scmd->cmnd[8] << 8) |
> > (u32)scmd->cmnd[9];
> > +		start_lba_lo = ((u32)scmd->cmnd[2] << 24) |
> > +				((u32)scmd->cmnd[3] << 16) |
> > +				((u32)scmd->cmnd[4] << 8) |
> > (u32)scmd->cmnd[5]; +
> > +		if (scmd->cmnd[1] & FUA_MASK)
> > +			control |= SPRAID_RW_FUA;
> > +	}
> > +	/* 16-byte READ(0x88) or WRITE(0x8A) cdb */
> > +	else if (scmd->cmd_len == 16) {
> > +		datalength = ((u32)scmd->cmnd[10] << 24) |
> > +			((u32)scmd->cmnd[11] << 16) |
> > +			((u32)scmd->cmnd[12] << 8) |
> > (u32)scmd->cmnd[13];
> > +		start_lba_lo = ((u32)scmd->cmnd[6] << 24) |
> > +			((u32)scmd->cmnd[7] << 16) |
> > +			((u32)scmd->cmnd[8] << 8) |
> > (u32)scmd->cmnd[9];
> > +		start_lba_hi = ((u32)scmd->cmnd[2] << 24) |
> > +			((u32)scmd->cmnd[3] << 16) |
> > +			((u32)scmd->cmnd[4] << 8) |
> > (u32)scmd->cmnd[5]; +
> > +		if (scmd->cmnd[1] & FUA_MASK)
> > +			control |= SPRAID_RW_FUA;
> > +	}
> > +	/* 32-byte READ(0x88) or WRITE(0x8A) cdb */
> > +	else if (scmd->cmd_len == 32) {
> > +		datalength = ((u32)scmd->cmnd[28] << 24) |
> > +			((u32)scmd->cmnd[29] << 16) |
> > +			((u32)scmd->cmnd[30] << 8) |
> > (u32)scmd->cmnd[31];
> > +		start_lba_lo = ((u32)scmd->cmnd[16] << 24) |
> > +			((u32)scmd->cmnd[17] << 16) |
> > +			((u32)scmd->cmnd[18] << 8) |
> > (u32)scmd->cmnd[19];
> > +		start_lba_hi = ((u32)scmd->cmnd[12] << 24) |
> > +			((u32)scmd->cmnd[13] << 16) |
> > +			((u32)scmd->cmnd[14] << 8) |
> > (u32)scmd->cmnd[15]; +
> > +		if (scmd->cmnd[10] & FUA_MASK)
> > +			control |= SPRAID_RW_FUA;
> > +	}  
> 
> Please remove all of the above code and use blk_rq_pos(), 
> blk_rq_sectors() and rq->cmd_flags & REQ_FUA instead.

I did not quite get your point. The above is commonly used in many
similar use cases. For example: megasas_build_ldio() in
megaraid_sas_base.c. 
What's the benefit to switch to another way: use
blk_rq_pos(),blk_rq_sectors()?

> 
> > +	spraid_wq = alloc_workqueue("spraid-wq", WQ_UNBOUND |
> > WQ_MEM_RECLAIM | WQ_SYSFS, 0);
> > +	if (!spraid_wq)
> > +		return -ENOMEM;  
> 
> Why does this driver create a workqueue? Why is system_wq not good
> enough?

In my opinion, there is not much difference by using system_wq or using
a dedicated wq to execute a work.
but the dedicated wq is must to execute some serial works. It is easy
to add more serial works later if using a dedicated wq here.

> 
> Thanks,
> 
> Bart.

