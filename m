From: James Smart <James.Smart@Emulex.Com>
Subject: Re: how to handle QUEUE_FULL/SAM_STAT_TASK_SET_FULL in userspace?
Date: Thu, 15 Nov 2007 14:43:47 -0500
Message-ID: <473CA173.7080902@emulex.com>
References: <664A4EBB07F29743873A87CF62C26D70B3443F@NAMAIL4.ad.lsil.com> <473C997A.90404@nortel.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39882 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbXKOToO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 14:44:14 -0500
In-Reply-To: <473C997A.90404@nortel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Friesen <cfriesen@nortel.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "Stephens, Larry" <Larry.Stephens@lsi.com>, linux-scsi@vger.kernel.org, dgilbert@interlog.com, James.Bottomley@SteelEye.com, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>



Chris Friesen wrote:
> Moore, Eric wrote:
> 
>> You already figured out the problem, I don't understand why your asking
>> if the kernel verison is behaving properly.   You said between those
>> driver versions the device queue depth increased from 32 to 64, and that
>> is exactly what happened.   The reason for the increase is some customer
>> ask for the increase queue_depth which helps with performance. We are
>> not going to decrease it back.
> 
> My impression is that the per-device queue is supposed to be decreased 
> at runtime to match the actual size that the hardware can handle.  In 
> the earlier version we're seeing the queue set to 7 at runtime, while 
> the more recent version is showing a queue depth of 32 or 64 and is 
> giving QUEUE_FULL errors to the userspace apps.

The midlayer doesn't do this automatically. The LLDD has to note the
QUEUE_FULL/TASK_SET_FULL status, then call scsi_adjust_queue_depth()
to manipulate things. And this gets really hairy to decrease load, then
ramp back up.

> I just wanted to make sure that 2.6.14 was working correctly (ie, this 
> wasn't a bug that has been fixed in a more recent version).
> 
>> SAM_STAT_TASK_SET_FULL in /usr/src/linux/scsi/scsi.h, is the same as
>> QUEUE_FULL.  If you look in scsi_error.c searching for QUEUE_FULL, you
>> will see that it will translate to ADD_TO_MLQUEUE, which means it will
>> reposted to the request queue.
> 
> I don't know the scsi code very well, so maybe I'm missing something 
> obvious here.  If so, I apologize.
> 
> Our userspace apps are getting a status of TASK_SET_FULL on completion 
> of an ioctl() call.

If you're using sgio, you will always be susceptible to getting these
statuses, even if the driver adjusts queue depth.

> Does this status mean that the command needs to be retried by the 
> userspace app, that it has already been retried by the lower levels and 
> is now completed, or something else entirely?

The status means you can retry again, hoping that the queue is not as
busy at that time. The recommendation is that you delay 1 or more seconds
before attempting again. But, even that is a general recommendation.
SAM-4 gives some basic guidance on how long to delay before the retry
(see table 26).

It would be bad form for the lower levels or driver to retry the command.
Some commands are not retryable without affecting device state. Since you
use sgio, it's up to you to retry.

-- james s
