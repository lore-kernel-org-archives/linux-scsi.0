From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: linux-2.6.23-mm1 crashed
Date: Sun, 14 Oct 2007 18:26:29 -0400
Message-ID: <1192400789.3351.59.camel@localhost.localdomain>
References: <2a382c6e0710141145j51286bd0o8a2eb307f7455cd@mail.gmail.com>
	 <20071014122144.f8e56ed9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58423 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752361AbXJNW0b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Oct 2007 18:26:31 -0400
In-Reply-To: <20071014122144.f8e56ed9.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Milter <davemilter@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>

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

James

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index e8010a7..7fa22be 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3793,6 +3793,9 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
+    if (list_empty(&gdth_instances))
+	return;
+
     ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
 



