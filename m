From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Regarding ordered-tag support.
Date: Wed, 08 Feb 2006 11:07:31 -0600
Message-ID: <1139418451.3003.37.camel@mulgrave.il.steeleye.com>
References: <43E99248.7090505@gmail.com>
	 <1139413766.3003.19.camel@mulgrave.il.steeleye.com>
	 <43EA17E6.4000800@gmail.com> <43EA1B75.40008@emulex.com>
	 <43EA2313.9030506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:18904 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030231AbWBHRHh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 12:07:37 -0500
In-Reply-To: <43EA2313.9030506@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun <htejun@gmail.com>
Cc: James.Smart@Emulex.Com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2006-02-09 at 01:57 +0900, Tejun wrote:
> I intentionally wrote 'driver' because if a SCSI device determines that 
> it's busy, it would report via CHECK CONDITION.  Depending on QErr, the 
> whole task set will be terminated, and such case falls into EH 
> requeueing case (would require changes in scsi_softirq though).

No, it wouldn't.  BUSY is a SPI Message (deprecated on non-SPI
transports) and QUEUE_FULL is a status return.  The device is entitled
to think of the transaction as logically complete (and not impacting
error recovery) after either of these returns.

> > You're making the assumption that you can set QErr... It's under device control. 
> 
> Was it ro field?  Didn't know that.  I will check it tomorrow.  If a 
> device doesn't abort whole taskset, we just can't use ordered-tag for 
> barriers.

His point is that it's a field in the mode page of a device.  Some
devices only have read only mode pages ... still more may not act on
this field correctly even if set.  Basically it's opening a can of
worms.

James


