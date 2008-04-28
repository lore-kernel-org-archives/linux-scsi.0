From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] qla2xxx: firmware semaphore to mutex
Date: Mon, 28 Apr 2008 13:04:25 -0600
Message-ID: <20080428190425.GY14990@parisc-linux.org>
References: <20080428174742.163523860@mvista.com> <20080428180846.GX14990@parisc-linux.org> <1209409033.12461.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47639 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937452AbYD1TE0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2008 15:04:26 -0400
Content-Disposition: inline
In-Reply-To: <1209409033.12461.64.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Walker <dwalker@mvista.com>
Cc: James.Bottomley@HansenPartnership.com, mingo@elte.hu, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

On Mon, Apr 28, 2008 at 11:57:13AM -0700, Daniel Walker wrote:
> On Mon, 2008-04-28 at 12:08 -0600, Matthew Wilcox wrote:
> > On Mon, Apr 28, 2008 at 10:47:42AM -0700, Daniel Walker wrote:
> > > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> > 
> > I did this one too ... my version had a nice little twist.
> > 
> > > @@ -2813,7 +2814,7 @@ qla2x00_request_firmware(scsi_qla_host_t
> > >  		blob = &qla_fw_blobs[FW_ISP25XX];
> > >  	}
> > >  
> > > -	down(&qla_fw_lock);
> > > +	mutex_lock(&qla_fw_lock);
> > >  	if (blob->fw)
> > >  		goto out;
> > >  
> > 
> > This one we can do as:
> > 
> > -       down(&qla_fw_lock);
> > +       if (mutex_lock_killable(&qla_fw_lock))
> > +               return NULL;
> 
> I'm not sure what mutex_lock_killable() does, so I would imagine that
> should be in it's own patch .. I don't like doubling up on changes
> because I feel it's harder to review, and harder on git bisect once it's
> in mainline.. That's why I was saying "one lock per patch." ..

mutex_lock_killable() is documented.  Basically, if you receive a _fatal_
signal while trying to acquire the lock, it returns -EINTR and it's
up to the caller to handle it and unwind back to userspace.  ie it's
halfway between mutex_lock_interruptible() (any signal) and mutex_lock()
(no signal).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
