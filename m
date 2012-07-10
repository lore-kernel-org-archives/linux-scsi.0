From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Tue, 10 Jul 2012 02:03:55 +0200
Message-ID: <4FFB716B.4010309@matthiasprager.de>
References: <4FE454CA.6080007@matthiasprager.de> <4FFAED4F.3080100@matthiasprager.de> <20120710080831.1bb616fb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:47665 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab2GJAEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2012 20:04:07 -0400
In-Reply-To: <20120710080831.1bb616fb@notabene.brown>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, Matthias Prager <linux@matthiasprager.de>

Am 10.07.2012 00:08, schrieb NeilBrown:
> On Mon, 09 Jul 2012 16:40:15 +0200 Matthias Prager <linux@matthiasprager.de>
> wrote:
> 
>> Even though it says creating aborted it still created md127.
> 
> One of my pet peeves in when people interpret the observations wrongly and
> then report their interpretation instead of their observation.  However
> sometimes it is very hard to separate the two.  You comment above looks
> perfectly reasonable and looks like a clean observation and not and
> interpretation.  Yet it is an interpretation :-)
> 
> The observation would be
>    "Even though it says creating abort, md127 was still created".
> 
> You see, it wasn't this mdadm that created md127 - it certainly shouldn't
> have as you asked it to create md1.
Sry - I jumped to conclusions without knowing what was actually going on.

> 
> I don't know the exact sequence of events, but something - possibly relating
> to the error messages reported below - caused udev to notice /dev/sda.
> udev then ran "mdadm -I /dev/sda" and as it had some metadata on it, it
> created an array with it.  As the name information in that metadata was
> probably "test1" or similar, rather than "1", mdadm didn't know what number
> was wanted for the array, so it chose a free high number - 127.
> 
> This metadata must have been left over from an earlier experiment.
That is correct (as am just realizing now). There is metadata of an
raid1 array left on the disk even though it was used (for a short time)
with zfs on freebsd before doing these experiments.

> 
> So it might have been something like.
> 
> - you run mdadm (call this mdadm-1).
> - mdadm tries to open sda
> - driver notices that device is asleep, and wakes it up
> - the waking up of the device causes a CHANGE uevent to udev
> - this cause udev to run a new mdadm - mdadm-2
> - mdadm-2 reads the metadata, sees old metadata, assembled sda in a new md127
> - mdadm-1 gets scheduled again, tries to get O_EXCL access to sda and fails, 
>   because sda is now part of md127
> 
> Clearly undesirable behaviour.  I'm not sure which bit is "wrong".
As it turns out mdadm is doing everything right. md127 is actually
already present (though inactive) at boot-time. So mdadm is absolutly
correct in saying sda is busy and refusing to do anything further.

> 
> NeilBrown
> 

The real problem seems to be located in some layer below md, which is
not waking up the disk for any i/o (at all - not even for fdisk -l).

Matthias
