From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 11:40:12 -0400
Message-ID: <5177FCDC.6010304@interlog.com>
References: <5176E3E8.3000809@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:43703 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab3DXPlZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 11:41:25 -0400
In-Reply-To: <5176E3E8.3000809@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>

On 13-04-23 03:41 PM, Ric Wheeler wrote:
>
> For many years, we have used WCE as an indication that a device has a volatile
> write cache (not just a write cache) and used this as a trigger to send down
> SYNCHRONIZE_CACHE commands as needed.
>
> Some arrays with non-volatile cache seem to have WCE set and simply ignore the
> command.
>
> Some arrays with non-volatile cache seem to not set WCE.
>
> Others arrays with non-volatile cache - our problem arrays - set WCE and do
> something horrible and slow when sent the SYNCHRONIZE_CACHE commands.
>
> Note that for file systems, you can override this behavior by mounting with our
> barriers disabled (mount -o nobarrier .....). There is currently no way do
> disable this for anything using the device directly, not through the file system.
>
> Some applications run against block devices - not through a file system - and
> want not to slow to a crawl when they have an array in my problem set.
>
> Giving them a hook to ignore WCE seems to be a hack, but one that would resolve
> issues with users who won't want to wait months (years?) for us to convince the
> array vendors.
>
> Is this a hook worth doing?
>
> Have we hashed this out in the T10 committee?

Naturally I'm biased, but I tend to think the user space
is usually smarter than the kernel. That assumes skilled
users.

So if the user space issues a SYNCHRONIZE_CACHE with the
IMMED bit set and for the whole disk then the user should
have a way of forcing that command to be issued. The
assumption here is that the skilled user is about to power
down that array or pull some disks or SSDs *.

The more questionable cases are when a file system or the
block layer is issuing a barrier or some such that
translates to a SYNCHRONIZE_CACHE. That should be ignored
in some cases already discussed in this thread.


While working with SoCs I have noticed an interesting
technique. Sub-system sized sections of the memory mapped
IO space (e.g. a bank of GPIOs) can be write protected by
a simple ASCII sequence **. Attempts to change configuration
registers after write protect are ignored and an error
is noted (if anyone cares). The same ACSII sequence can be
used to un-write protect those sub-system configuration
registers. Typically on a SoC if the GPIOs are randomly
re-configured, it's game over.

Back to the SCSI world: a better solution might be if an
LLD could be informed of the reason a SCSI control command
is being issued (a sort of "come from" field). Failing, or
it addition to that, a sysfs interface could be added to
filter out "dangerous" SCSI commands:
   echo "SC" > /sys/class/scsi_device/8:0:0:0/device/filter

   cat /sys/class/scsi_device/8:0:0:0/device/filter
FU SC

If, for whatever reason, we did ignore a SYNCHRONIZE_CACHE
command we could use vendor specific sense data (vendor=Linux)
to indicate that a command had been ignored. That could be
extended to all SCSI commands that are filtered out ***;
better that than EIO, EACCES etc.

Doug Gilbert

*   and if Linux doesn't permit this, then user might be
     advised to run another, more obedient, host OS with
     Linux running as a VM. A "pass-by" rather than a
     "pass-through" ...

**  only the configuration registers are write protected, so
     data can still be written to the GPIOs

*** like me, many pass-through users cannot see why SCSI
     commands injected to the SCSI subsystem (e.g. via
     sg or bsg) are filtered out silently by the block layer.

