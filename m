From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: how to handle QUEUE_FULL/SAM_STAT_TASK_SET_FULL in userspace?
Date: Tue, 13 Nov 2007 15:34:22 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70B34152@NAMAIL4.ad.lsil.com>
References: <473A1F53.2050209@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:55793 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbXKMWei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Nov 2007 17:34:38 -0500
Content-class: urn:content-classes:message
In-Reply-To: <473A1F53.2050209@nortel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Friesen <cfriesen@nortel.com>, "Stephens, Larry" <Larry.Stephens@lsi.com>
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com, James.Bottomley@SteelEye.com, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

On Tuesday, November 13, 2007 3:04 PM, Chris Friesen wrote: 
> 
> Chris Friesen wrote:
> 
> > We recently moved from 2.6.10 to 2.6.14 and now we're 
> seeing occasional 
> > QUEUE_FULL/SAM_STAT_TASK_SET_FULL errors being returned to 
> userspace. 
> > These didn't ever show up in 2.6.10.
> 
> I found something that might be interesting.
> 
> With the the 3.01.18 fusion driver the queue length (as shown by 
> "/sys/class/scsi_generic/sgX/device/queue_depth") was set to 7, while 
> with the 3.02.57 fusion driver it was set to either 64 or 32.
> 
> It may be coincidence, but it's interesting that 
> MPT_SCSI_CMD_PER_DEV_LOW is set to 7 in the earlier driver, and 32 in 
> the later one, while MPT_SCSI_CMD_PER_DEV_HIGH went from 31 to 64.
> 


QUEUE_FULL and SAM_STAT_TASK_SET_FULL are not errors.
SAM_STAT_TASK_SET_FULL returned for the target that handle the number of
commands, and QUEUE_FULL returned from hba firmware meaning its can't
handle the number of commands.  Translated, the commands are retried by
scsiml.    I probably should be calling scsi_track_queue_full which
would be throttling the command back, however I'm not sure whether it
matters.

Eric
