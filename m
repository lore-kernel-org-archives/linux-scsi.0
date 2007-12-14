From: akpm@linux-foundation.org
Subject: [patch 01/30] git-scsi-misc gdth fix
Date: Thu, 13 Dec 2007 16:14:03 -0800
Message-ID: <200712140014.lBE0E3Rp026168@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45887 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbXLNAOH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:14:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, James.Bottomley@steeleye.com, davemilter@gmail.com

From: James Bottomley <James.Bottomley@SteelEye.com>

On Sun, 2007-10-14 at 12:21 -0700, Andrew Morton wrote:
> On Sun, 14 Oct 2007 22:45:47 +0400 "Dave Milter" <davemilter@gmail.com> wrote:
>
> > I build linux-2.6.23-mm1 and try to boot it using qemu,
> > and it crashed with trace like this:
> > do_page_fault
> > error_code
> > lock_acquire
> > _spin_lock_irqsave
> > gdth_timeout
> > run_timer_softirq
> > __do_softirq
> > do_softirq
> >
> > I have screenshot, but have no idea, is it legal to include it, if I
> > sent copy to lkml.
> > config of kernel in attachment,
> > I apply all three patches from hot-fixes.
> >
>
> The screenshot is here:  http://userweb.kernel.org/~akpm/crash.png
>
> It would appear that gdth_timeout() is passing a bad pointer into
> spin_lock_irqsave().

There's a bug in the gdth rework in that the instance can be deleted
from the list before the actual timer is stopped.  This can be worked
around I think by the following patch; although we really should be
stopping the timer from firing when the list goes empty.


James said:

This is almost certainly the wrong fix for real hardware.  Although it
kills the timer when the list goes empty, nothing will ever restart it
when the list fills again.

Boaz, since you touched all of this, you get to fix it.  The correct fix
will be to control the timer along with the actual list instead of at
entry/exit time.  If you're not going to add this empty check to the
timer routine, make sure you use del_timer_sync() before removing the
last element from the list.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/scsi/gdth.c~git-scsi-misc-gdth-fix drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~git-scsi-misc-gdth-fix
+++ a/drivers/scsi/gdth.c
@@ -3793,6 +3793,9 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
+    if (list_empty(&gdth_instances))
+	return;
+
     ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
_
