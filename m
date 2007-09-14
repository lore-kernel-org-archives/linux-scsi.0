From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bugme-new] [Bug 9018] New: Kernel bug in aic94xx driver
	shipped with kernel 2.6.21.7
Date: Fri, 14 Sep 2007 16:22:03 -0500
Message-ID: <1189804923.3343.28.camel@localhost.localdomain>
References: <bug-9018-10286@http.bugzilla.kernel.org/>
	 <20070914135600.67f798e3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:42469 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757262AbXINVWG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 17:22:06 -0400
In-Reply-To: <20070914135600.67f798e3.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, bugme-new@lists.osdl.org, martijn@databoss.nl, "Darrick J. Wong" <djwong@us.ibm.com>

On Fri, 2007-09-14 at 13:56 -0700, Andrew Morton wrote:
> On Fri, 14 Sep 2007 07:11:54 -0700 (PDT)
> bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=9018
> > 
> >            Summary: Kernel bug in aic94xx driver shipped with kernel
> >                     2.6.21.7
> >            Product: Drivers
> >            Version: 2.5
> >      KernelVersion: 2.6.21.7
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: Other
> >         AssignedTo: drivers_other@kernel-bugs.osdl.org
> >         ReportedBy: martijn@databoss.nl
> > 
> > 
> > While rebuilding a MD raid5, every time I try to rebuild:
> > 
> > -- START DUMP --
> > RAID5 conf printout:
> >  --- rd:3 wd:2
> >  disk 0, o:1, dev:sdb1
> >  disk 1, o:1, dev:sdc1
> >  disk 2, o:1, dev:sdd1
> > md: recovery of RAID array md0
> > md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> > md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec)
> > for recovery.
> > md: using 128k window, over a total of 71681920 blocks.
> > ------------[ cut here ]------------
> > kernel BUG at drivers/scsi/aic94xx/aic94xx_hwi.h:354!
> 
> whee!  That's BUG_ON(!list_empty(&ascb->list));

Yes; it means the task was still in use when we tried to free it.  I
surmise that this is the tascb not the ascb in asd_abort_task(). What
this seems to indicate is some sort of race between the abort completing
the task and the owning entity taking it off the sequencer list.

I don't understand this piece of the driver enough yet to fix a more
definite cause.

> yet anoher scsi driver with no entry in MAINTAINERS.  Darrick, maybe?

Gilbert Wu should be taking over eventually, but for now it's a bit
unmaintained.

James


