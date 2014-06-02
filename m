From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V2] sd: Reduce log level to KERN_NOTICE for missing
 caching mode page
Date: Mon, 02 Jun 2014 12:14:33 -0700
Message-ID: <1401736473.12939.10.camel@dabdike.int.hansenpartnership.com>
References: <1401734883-9540-1-git-send-email-a.c.kalker@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55828 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348AbaFBTOj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 15:14:39 -0400
In-Reply-To: <1401734883-9540-1-git-send-email-a.c.kalker@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alain Kalker <a.c.kalker@gmail.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On Mon, 2014-06-02 at 20:48 +0200, Alain Kalker wrote:
> Reduce the lernel log level to KERN_NOTICE for messages related
> to a missing caching mode page.
> 
> Reasons why I think this change is justified:
> - The condition is not an error; the existing workaround of assuming
>   a write through cache doesn't limit functionality in any way.

That's not actually correct.  The condition may be an error.  We have
some USB attached storage devices with writeback caches which don't
supply caching information.  Treating a writeback device as writethrough
is a potential error because you may lose data as a result of it.

The error is that we've made an assumption which may damage your data.

The problem for us is that we can't tell if the assumption is going to
be fatal or not ... the message is harmless for older USB devices.

> - It doesn't warrant a warning either: as it is most likely
>   a hardware limitation, there is little that an ordinary user can do
>   about it besides replacing the affected hardware.
>   Making it a warning would still break quiet boot (kernel commandline
>   parameter 'quiet'), and may still trip log monitoring software
>   unneccessarily, either on every boot or whenever an affected
>   external device is plugged in.
> - It should be a notice, for it is a normal but significant condition,
>   as it may impact write performance. This would bring it on par with
>   the log messages in the same function.

But this message may serve a purpose:  If you see it and you find you do
have a USB device with a writeback cache, you can set the boot system to
correct the cache type assumption and we'll send the correcting
synchronize cache commands.

It certainly helps bug triagers identify issues which may require adding
a particular device to the list that need to be treated as writeback.

James


