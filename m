From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention
 conditions
Date: Tue, 17 Jul 2012 14:32:10 +0100
Message-ID: <1342531930.3039.74.camel@dabdike.int.hansenpartnership.com>
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>
	     <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>
	     <50044D56.6000400@redhat.com>
	    <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com>
	    <50052390.7030908@redhat.com>
	   <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com>
	   <5005285E.8060706@redhat.com>
	  <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com>
	  <5005302D.6010805@redhat.com>
	 <1342527693.3039.64.camel@dabdike.int.hansenpartnership.com>
	 <50055B19.8090101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50055B19.8090101@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-07-17 at 14:31 +0200, Paolo Bonzini wrote:
> Il 17/07/2012 14:21, James Bottomley ha scritto:
> >> Yes, I realize failing only on specific sense codes as I did it in the
> >> patch is not going to work.  However, the other way round is not
> >> problematic (explicitly allow some sense codes, fail on all others).
> > 
> > Heh, I once thought that, but there's no end to the strange ideas USB
> > manufacturers get.
> 
> :)
> 
> >> > Another example is "target operating conditions have changed".  QEMU
> >> > cannot report such changes because scsi_error prints a warning (fine)
> >> > and then passes the unit attention upwards.  With removable drives, this
> >> > has the same problem as resizing.
> > Why would a removable device ever use any of the codes under this ASC
> > when the medium hasn't changed?  They're all for arrays (well except
> > 0x10 and 0x11 ... and they're only supposed to apply to tape changers
> > with autoload support declared in the control mode page).
> 
> There are also a couple of generic ones such as "reported luns have
> changed".  I also considered briefly using "inquiry data has changed" to
> reload the unmap parameters after live snapshot or storage migration.  I
> dropped the idea, please don't put me in the same bin as the USB
> manufacturers.

I'm not ... but at the same time removable functionality in sd.c is
special cased in quite a few areas which makes it fragile but exercised.
Its fragility is somewhat mitigated by the fact that a lot of the
special casing separates the removable from the non-removable paths.

I don't want to increase that fragility by entangling the removable and
non-removable paths without a good reason for doing so.

James
