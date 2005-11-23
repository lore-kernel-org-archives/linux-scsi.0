From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Fw: [Bugme-new] [Bug 5566] New: scsi_eh_x/scsi_wq_x "zombie" processes in kernel 2.6.13+
Date: Wed, 23 Nov 2005 15:47:52 -0800
Message-ID: <20051123234752.GV2976@andrew-vasquezs-powerbook-g4-15.local>
References: <20051111020619.5a73ad37.akpm@osdl.org> <20051111164111.GB458@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:1860 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751337AbVKWXsg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 18:48:36 -0500
Content-Disposition: inline
In-Reply-To: <20051111164111.GB458@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, James Smart <james.smart@emulex.com>

On Fri, 11 Nov 2005, Andrew Vasquez wrote:

> On Fri, 11 Nov 2005, Andrew Morton wrote:
> 
> > Begin forwarded message:
> > 
> > Date: Mon, 7 Nov 2005 14:49:17 -0800
> > From: bugme-daemon@bugzilla.kernel.org
> > To: bugme-new@lists.osdl.org
> > Subject: [Bugme-new] [Bug 5566] New: scsi_eh_x/scsi_wq_x "zombie" processes in kernel 2.6.13+
> > 
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=5566
> > 
> >            Summary: scsi_eh_x/scsi_wq_x "zombie" processes in kernel 2.6.13+
> >     Kernel Version: 2.6.13+
> >             Status: NEW
> >           Severity: normal
> >              Owner: andrew.vasquez@qlogic.com
> >          Submitter: gator@cs.tu-berlin.de
> > 
> > 
> > Most recent kernel where this bug did not occur: 2.6.12
> > Starting around kernel version 2.6.13, the scsi_eh_x and scsi_wq_x
> > processes that are created per scsi host will not terminate if the
> > driver for the scsi interface is removed. I don't know whether there
> > are any serious problems involved with this, but one thing that is
> > definitely annoying, is that the process list fills very quickly when
> > modules are loaded/unloaded on demand, because 2 new processes will
> > be created every time the driver for a scsi adapter gets loaded.
> > 
> > (I guess, this happens with all scsi host modules - in my case, the
> > "culprit" is a qlogic fibre channel driver that gets loaded only when
> > needed.)
> 
> Seems there appear to be some reference-counting problems here, as the
> task trace:

There's definitely some ref-count problems with all fc_rport aware
drivers.  Basically, an rport->dev is not being torn-down completely
during fc_rport_terminate().  Unfortunately though, I'm going
cross-eyed following the acquisition/release model of the rport->dev
(so please be patient)...

After adding some (less than impressive) debugging codes to follow the
rport-dev tear-down process, I note that after the
transport_destroy_device() call in fc_rport_terminate(), the
rport->dev still maintains a single ref -- the patch below 'fixes' the
problem (and tear-down occurs as it should).  But, I'd still like to
understand 'why' it's needed...

During creation (fc_rport_create()), a reference to rport->dev is
taken during device_init(), another during transport_setup_device(),
two addition refs during device_add(), and another during
transport_add_device(). [side note: refcount is 5].

Several addition refs (4 to be exact) are acquired during
instantiation of the relevant scsi_target (and support) objects.

Now during teardown, the proper number of refs are released during
scsi_remove_target() (via fc_rport_tgt_remove()).  Tear-down continues
with transport_remove_device() [refcount is now 4], then device_del()
[refcount is now 2], and finally transport_destory_device() [refcount
is now 1].

At this point the rport is dropped from its peer list, and the
shost_gendev reference (acquired during fc_rport_create()) is dropped.
Unfortunately, rport->dev is still left dangling.

I've skimmed through similar transport-class tear-down code for some
hints, but am still left wondering why...

James B., James S. -- any ideas.  I know I must be missing something
basic -- please set me straight...

Thanks,
AV

---

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 6cd5931..d9f17fe 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1570,6 +1570,8 @@ fc_rport_terminate(struct fc_rport  *rpo
 	list_del(&rport->peers);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(&shost->shost_gendev);
+
+	put_device(dev);
 }
 
 /**
