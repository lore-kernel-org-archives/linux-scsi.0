From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 18:31:02 +0200
Message-ID: <519CF2C6.4020906@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com> <519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org> <519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org> <519C9CBC.3050003@redhat.com> <1369224435.1811.22.camel@dabdike> <519430357.5931281.1369231627092.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <519430357.5931281.1369231627092.JavaMail.root@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 22/05/2013 16:07, Paolo Bonzini ha scritto:
>> Finally, the patch for the feature I think you actually want, which is
>> 13/14, could have been implemented fairly simply as a single patch and
>> doesn't have to be part of this series.
> 
> It was, and it was ignored.  I sent it together because of the common
> dependency on the first patch.
> 
> However, it is not the only feature I need; that patch should be just for things
> like reservations or vendor-specific commands.  I also need that SG_IO works
> well without any privileges, neither CAP_SYS_RAWIO (needed for a process to
> bypass the whitelist) neither CAP_SYS_ADMIN (needed for a process to disable
> the whitelist for others as in patch 13/14).  I need that at least for disks,
> tapes and media changers.

In fact,  I'd much rather go back to userspace-configurable filters
(http://thread.gmane.org/gmane.linux.scsi/77783/focus=1378071); then
policy can be implemented entirely in userspace based on INQUIRY data.
There was a patch here for the bitmaps:
http://permalink.gmane.org/gmane.linux.kernel/1378071

IIRC turning it into a full implementation requires exposing the queue
parameters for all SCSI devices in sysfs, even for those devices that
are not visible as block devices.  (Again IIRC) non-block devices such
as tapes do not have a /sys/bus/scsi/devices/h:c:i:l/block directory,
hence they also have no block/queue to export the whitelist knobs.

You can then add a kernel config knob that would enable only the bare
minimum set of commands (basically INQUIRY, REPORT LUNS, TEST UNIT
READY; maybe also some of these: REQUEST SENSE, START STOP UNIT, MODE
SENSE, LOG SENSE).  If people know that udev (or something else) is new
enough to know how to initialize the required bitmaps, they can enable
the knob.

Paolo
