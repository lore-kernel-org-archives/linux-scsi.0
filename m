From: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: how to handle QUEUE_FULL/SAM_STAT_TASK_SET_FULL in userspace?
Date: Wed, 14 Nov 2007 11:23:19 -0600
Message-ID: <473B2F07.8060908@nortel.com>
References: <664A4EBB07F29743873A87CF62C26D70B34152@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zrtps0kp.nortel.com ([47.140.192.56]:51847 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbXKNRXa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Nov 2007 12:23:30 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70B34152@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Stephens, Larry" <Larry.Stephens@lsi.com>, linux-scsi@vger.kernel.org, dgilbert@interlog.com, James.Bottomley@SteelEye.com, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Moore, Eric wrote:

> QUEUE_FULL and SAM_STAT_TASK_SET_FULL are not errors.

I consider them errors in the same way that ENOMEM or ENOBUFS (or even 
EAGAIN) are errors.  "There is a shortage of resources and the command 
could not be completed, please try again later."

Also, the behaviour has changed from 2.6.10 with the 3.01.18 fusion 
driver, to 2.6.14 with the 3.02.57 fusion driver.

With 2.6.10 our user app never saw SAM_STAT_TASK_SET_FULL.  I suspect it 
is due to the fact that it's using a queue size of 7, while in 2.6.14 
it's using a queue size of 32 or 64.

Which kernel version is behaving properly?

I've asked seagate what the queue size should be for that hardware, but 
haven't heard back yet.

> SAM_STAT_TASK_SET_FULL returned for the target that handle the number of
> commands, and QUEUE_FULL returned from hba firmware meaning its can't
> handle the number of commands.  Translated, the commands are retried by
> scsiml.    I probably should be calling scsi_track_queue_full which
> would be throttling the command back, however I'm not sure whether it
> matters.

We have a userspace app calling ioctl(...SG_IO...) on /dev/sdX and 
occasionally getting a status of SAM_STAT_TASK_SET_FULL.  I may be 
misreading the code, but it doesn't appear that the midlayer is retrying 
these commands.

If the queue length in 2.6.14 is correct then how do I handle that 
status code?  Maybe delay a bit then retry a few times?  How much delay? 
   How many retries?

Chris
