From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux kernel security issuse scsi_report_lun_scan report
Date: Fri, 20 Nov 2015 12:57:04 -0800
Message-ID: <1448053024.2168.45.camel@HansenPartnership.com>
References: <8159e011-35a9-4952-a0ef-be4dfb13983f.chengmiao.cj@alibaba-inc.com>
	 <CA+55aFyn44rDnv3E9sSg_YGfeqhExvGz8yeAANU-BVghDHRFdA@mail.gmail.com>
	 <1448044014.2168.34.camel@HansenPartnership.com>
	 <CA+55aFzi2mgOx1m2qYZoM+dW-f9G+EhA_MDw7zQZ-Jb_2nfQvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42594 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753193AbbKTU5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 15:57:12 -0500
In-Reply-To: <CA+55aFzi2mgOx1m2qYZoM+dW-f9G+EhA_MDw7zQZ-Jb_2nfQvA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, 2015-11-20 at 12:33 -0800, Linus Torvalds wrote:
> On Fri, Nov 20, 2015 at 10:26 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > We can look at it, but the analysis shouldn't be correct.
> 
> Just take the five seconds to check the freeing path, please. The last
> free is this:

I did ... it can only be something freed the device while we were
scanning it because it can't be a device we allocated (unless there's an
unbalanced put somewhere).  I can't see how it can happen, but moving
the put to after the if should fix it.  I'd just like confirmation it
does in case this is actually caused by something else entirely.

James

> > INFO: Freed in scsi_device_dev_release_usercontext+0x23d/0x2d7 age=4 cpu=0 pid=1
> >   free_debug_processing+0x188/0x207 mm/slub.c:1108
> >   scsi_device_dev_release_usercontext+0x23d/0x2d7 drivers/scsi/scsi_sysfs.c:429
> >   __slab_free+0x4a/0x27a mm/slub.c:2587
> >   mempool_free_slab+0x0/0x13 mm/mempool.c:453
> >   ida_remove+0xc6/0x159 lib/idr.c:1042
> >   __raw_callee_save___pv_queued_spin_unlock+0x11/0x1e ??:?
> >   __read_once_size include/linux/compiler.h:218
> >   atomic_read ./arch/x86/include/asm/atomic.h:27
> >   __rcu_is_watching+0x18/0x1f kernel/rcu/tree.c:987
> >   scsi_device_dev_release_usercontext+0x23d/0x2d7 drivers/scsi/scsi_sysfs.c:429
> >   scsi_device_dev_release_usercontext+0x23d/0x2d7 drivers/scsi/scsi_sysfs.c:429
> >   scsi_device_dev_release_usercontext+0x0/0x2d7 drivers/scsi/scsi_sysfs.c:438
> >   execute_in_process_context+0x24/0x82 kernel/workqueue.c:2969
> >   device_release+0x44/0xde drivers/base/core.c:247
> >   kobject_cleanup lib/kobject.c:631
> >   kobject_release lib/kobject.c:660
> >   kref_sub include/linux/kref.h:74
> >   kref_put include/linux/kref.h:99
> >   kobject_put+0xbc/0xcf lib/kobject.c:677
> >   scsi_report_lun_scan+0x27f/0x434 drivers/scsi/scsi_scan.c:1458
> >   scsi_report_lun_scan+0x0/0x434 drivers/scsi/scsi_scan.c:1053
> 
> so clearly the device *was* freed by scsi_report_lun_scan() doing the
> scsi_device_put().
> 
> >                              This device
> > is the one we first used to issue the report lun scan.  Either it's an
> > existing device, or we created it specially for the purpose.  If it's an
> > existing one, that put just releases our reference, but the core still
> > has one  (there'd have to be a very unusual scan destroy race for the
> > core to be releasing a reference to an object it was in process of
> > scanning).
> 
> A race it may be. Or maybe it's even a kasan bug. But so far, those
> kasan reports have been pretty much on the money.
> 
> It may be that a possible race is widened by kasan itself slowing things down.
> 
>                 Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



