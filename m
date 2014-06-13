From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: virtio-scsi issues duplicate tags when async_abort is enabled
Date: Fri, 13 Jun 2014 12:29:52 -0700
Message-ID: <1402687792.2224.67.camel@dabdike.int.hansenpartnership.com>
References: <CAHdzE-8k6A6kVB7DnOc6_XKg6DANLRFmP9+f4oXE1vPoLhOK=g@mail.gmail.com>
	 <20140613185221.GA11872@infradead.org>
	 <1402686574.2224.61.camel@dabdike.int.hansenpartnership.com>
	 <CAHdzE-8kNKgKXyHUwO+HSMnvoHzb-pKW6PLWWLKohk2d+=gqyQ@mail.gmail.com>
	 <1402687105.2224.64.camel@dabdike.int.hansenpartnership.com>
	 <20140613193123.GA25432@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45940 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbaFMT3x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 15:29:53 -0400
In-Reply-To: <20140613193123.GA25432@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Venkatesh Srinivas <venkateshs@google.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Fri, 2014-06-13 at 12:31 -0700, Greg KH wrote:
> On Fri, Jun 13, 2014 at 12:18:25PM -0700, James Bottomley wrote:
> > On Fri, 2014-06-13 at 12:15 -0700, Venkatesh Srinivas wrote:
> > > On Fri, Jun 13, 2014 at 12:09 PM, James Bottomley
> > > <James.Bottomley@hansenpartnership.com> wrote:
> > > > On Fri, 2014-06-13 at 11:52 -0700, Christoph Hellwig wrote:
> > > >> On Fri, Jun 13, 2014 at 10:58:22AM -0700, Venkatesh Srinivas wrote:
> > > >> > CC-ing stable as 3.14 and 3.15 are affected; a conservative fix is to
> > > >> > enable no_async_abort until the problem is better-understood.
> > > >>
> > > >> No patch attached.  Nevermind this is not a consdervative fix, but a
> > > >> band aid.  The proper fix is to figure out what's actually going on
> > > >> here.
> > > >>
> > > >> >From your trace above it very much looks like a double completion of
> > > >> some sort.
> > > >>
> > > >> I've looked at the virtio-scsi code a bit, and one odd thing it does
> > > >> that comes in handy here is that it doesn't really use a traditional
> > > >> tag, but rather the address of the scsi command.
> > > >
> > > > What kernel version?  This is the exact signature of the original USB
> > > > REQUEST_SENSE problem.
> > > 
> > > Mix of kernels, all 3.14-based. Debian 3.14-0.bpo, Gentoo's 3.14,
> > > upstream from git as of a few days ago.
> > > 
> > > Distribution 3.13 and earlier kernels (Debian's 3.2.0-4, Debian
> > > 3.13-0.bpo.1, Gentoo 3.13.6) do not hit this issue with the same
> > > workload.
> > 
> > OK, I've no idea what's in distro kernels, so you're looking for this
> > fix:
> > 
> > commit d555a2abf3481f81303d835046a5ec2c4fb3ca8e
> > Author: James Bottomley <JBottomley@Parallels.com>
> > Date:   Fri Mar 28 10:50:17 2014 -0700
> > 
> >     [SCSI] Fix spurious request sense in error handling
> > 
> > It went into v3.15-rc3.  It looks like it wasn't backported to stable.
> 
> That would be because no one asked it to be backported, why didn't you
> tag it as such?

Because it was a fix for a recently introduced problem with async aborts
at the time.  The fact that it may fix other problems is only just
becoming clear.

James


