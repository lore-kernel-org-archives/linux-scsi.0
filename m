From: Brett Russ <russb@emc.com>
Subject: Re: [PATCH] libata: scsi error handling, lk 2.6.14-rc1
Date: Thu, 22 Sep 2005 15:21:02 -0400
Message-ID: <4333041E.9000405@emc.com>
References: <432E7A6A.4090209@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:22478 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP
	id S1751148AbVIVTVV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 15:21:21 -0400
In-Reply-To: <432E7A6A.4090209@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com

Douglas Gilbert wrote:
> Jeff,
> This is a retransmission (and resync against lk 2.6.14-rc1)
> of a patch that I sent on 2005/8/28 . I haven't seen a reply.
> 
> If it has be applied, then my following patch
> ("[PATCH] libata: ATA Information VPD page, lk 2.6.14-rc1")
> should apply.
> 
> This patch adds more general error processing, typically for
> problems (or an early finish) detected while a
> SCSI command is being processed prior to an ATA
> command being executed.
> 
> Changelog:
>   - add extern ata_scsi_set_sense() to build SCSI
>     sense data and corresponding status
>   - this allows removal of extern ata_scsi_badcmd()
>     and static inline ata_bad_scsiop() and ata_bad_cdb()
>   - change "xlat" functions in libata-scsi so they
>     are responsible for SCSI status and sense data
>     when they return 1. This allows GOOD status or a
>     specialized error to be set.
>   - set DRIVER_SENSE when SAM_STAT_CHECK_CONDITION
>     is flagged in scsi_cmnd::result
>   - yield an error for mode sense requests for saved
>     values [sat-r05]
>   - change recent rw_zero_length patch to do nothing
>     (yield GOOD status) when transfer_length==0 for
>     10 and 16 byte READ and WRITE commands (SBC-2).


Hi Doug,

In March I got a bunch of patches in this same area into libata-dev; I'm 
not sure where they sit now (definitely not in 2.6.14-rc).  Jeff would 
probably know.

See start of thread:
http://lkml.org/lkml/2005/3/17/157

So there would be conflicts if my stuff went forward--a lot of the 
changes are similar.  I think the best bet would be to find the tree 
with my patches and for you to look at it and find problems that you 
solved in this patch that I didn't address.

BR
