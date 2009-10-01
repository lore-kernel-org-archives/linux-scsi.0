From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi_lib.c: sleeping function called from invalid
 context
Date: Thu, 01 Oct 2009 13:32:16 -0500
Message-ID: <1254421936.3885.53.camel@mulgrave.site>
References: <200909231758.47612.strakh@ispras.ru>
	 <20090924155604.4299aa0a.akpm@linux-foundation.org>
	 <1253841816.5183.361.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34329 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425AbZJASc0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2009 14:32:26 -0400
In-Reply-To: <1253841816.5183.361.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: iceberg <strakh@ispras.ru>, eric@andante.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>

On Thu, 2009-09-24 at 18:23 -0700, James Bottomley wrote:
> On Thu, 2009-09-24 at 15:56 -0700, Andrew Morton wrote:
> > On Wed, 23 Sep 2009 17:58:47 +0000
> > iceberg <strakh@ispras.ru> wrote:
> > 
> > > Driver scsi_lib.c might sleep in atomic context, because it calls 
> > > scsi_device_put under spin_lock_irqsave.
> > > drivers/scsi/scsi_lib.c:356:
> > > 	spin_lock_irqsave(shost->host_lock, flags);
> > > 	scsi_device_put(sdev);
> > > Path to might_sleep macro from scsi_device_put:
> > > 1. scsi_device_put calls put_device at ./drivers/scsi/scsi.c:1111 
> > > 2. put_device calls kobject_put at ./drivers/base/core.c:1038 
> > > 3. kobject_put calls kref_put at ./lib/kobject.c
> > > 4. kref_put may call callback function kobject_release at ./lib/kref.c if 
> > > refcount becomes zero, which might_sleep because it calls user event. Details:
> > > 	4.1 kobject_cleanup calls kobject_uevent at ./lib/kobject.c:555
> > > 	4.2 kobject_uevent calls kobject_uevent_env at  ./lib/kobject_uevent.c:282
> > > 	4.3 kobject_uevent_env calls call_usermodehelper_exec at 
> > > ./include/linux/kmod.h:83
> > > 	4.4 call_usermodehelper_exec calls wait_for_completion at 
> > > ./kernel/kmod.c:481
> > > 	4.5 wait_for_completion calls wait_for_common at ./kernel/sched.c:5710
> > > 	4.5 wait_for_common calls might_sleep at ./kernels/sched.c:5692
> > > 
> > > Found by Linux Driver Verification project.
> > > 
> > > Delete wrong sleeping function calls.
> > > 
> > > Signed-off-by: Alexander Strakh <strakh@ispras.ru>
> > > 
> > > ---
> > > diff --git a/./a/drivers/scsi/scsi_lib.c b/./b/drivers/scsi/scsi_lib.c
> > > index f3c4089..a8f8e2f 100644
> > > --- a/./a/drivers/scsi/scsi_lib.c
> > > +++ b/./b/drivers/scsi/scsi_lib.c
> > > @@ -353,9 +353,9 @@ static void scsi_single_lun_run(struct scsi_device 
> > > *current_sdev)
> > >  
> > >  		spin_unlock_irqrestore(shost->host_lock, flags);
> > >  		blk_run_queue(sdev->request_queue);
> > > -		spin_lock_irqsave(shost->host_lock, flags);
> > >  	
> > > -		scsi_device_put(sdev);
> > > +		scsi_device_put(sdev);	
> > > +		spin_lock_irqsave(shost->host_lock, flags);
> > >  	}
> > >   out:
> > >  	spin_unlock_irqrestore(shost->host_lock, flags);
> > > 
> > 
> > Well this is strange.  afacit all the code to which you refer is
> > ancient, so why did this bug just pop up now?
> 
> No idea.  I think the root cause of this is in the kobject code:  we
> explicitly require the ability to call last put from interrupt context
> (and that includes holding locks).  I'll talks to Greg and Kai about
> this (they're both here at plumbers).  I think the fix is to indirect
> the kobject uevent stuff via a usermode helper so we don't get this
> problem.

Hang on ... I looked at the bug report again: there's no actual kernel
trace, just a theoretical function graph.

Has this actually been seen or is it just the result of an analysis?

If the latter (which I suspect), there's no actual problem.  The
explicit design of the calls is that device_initialize() and
put_device() can be called from interrupt context.  device_add() and
device_del() must be called from user context.

The path you seem to be showing is the put_device() path where there's
been an error in the state model and the caller is doing last put on a
visible device without having first called device_del().

If you see the real kernel message about this, it means there's a bug in
the device model handling somewhere in SCSI.  If you haven't seen the
message, it's just a bug in the static analysis tool.

James


