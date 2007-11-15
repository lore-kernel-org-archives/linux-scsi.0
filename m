From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: how to handle QUEUE_FULL/SAM_STAT_TASK_SET_FULL in userspace?
Date: Thu, 15 Nov 2007 16:47:53 -0600
Message-ID: <1195166873.9519.11.camel@localhost.localdomain>
References: <664A4EBB07F29743873A87CF62C26D70B34664@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37709 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757188AbXKOWr4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 17:47:56 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70B34664@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Chris Friesen <cfriesen@nortel.com>, "Stephens, Larry" <Larry.Stephens@lsi.com>, linux-scsi@vger.kernel.org, dgilbert@interlog.com, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

On Thu, 2007-11-15 at 15:35 -0700, Moore, Eric wrote:
> > No.  When the command goes via SG_IO it bypasses all return status
> > processing (and QUEUE_FULL/BUSY is a return status).  When it's
> > submitted in the normal way (i.e. via a ULD) then the mid-layer
> > processes these returns to a retry strategy.
> > 
> 
> James - Today I'm working some other customer issue, and my target
> returns SAM_STAT_TASK_SET_FULL when sg_inq is sent.   I see about 10
> retries before the data is finally returned.  Who is issuing the retries
> to my driver?   Doesn't sg_inq (sg3_utils), use SG_IO ->
> scsi_execute_async-> scsi_softirq_done, where SAM_STAT_TASK_SET_FULL is
> translated to ADD_TO_MLQUEUE, then retried, regardless the fact that
> SG_DEFAULT_RETRIES equal zero.   Maybe I'm missing something, but I'm
> seeing retries.

No, you're not ... I'm not thinking straight about the disposition path.
There's another thing at work, which is the command default timeout,
when that exhausts we do return the status back to SG_IO; otherwise we
will follow the retry strategy in all cases.

Jmaes


