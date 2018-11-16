From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Fri, 16 Nov 2018 12:43:52 -0500
Message-ID: <20181116174352.GH20617@thunk.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <20181111131445.GB25441@infradead.org>
 <20181111134241.GA2447@thunk.org>
 <20181112082013.GA9307@infradead.org>
 <79d7d4b2-e9b3-00b4-2ad0-789888f7ee36@redhat.com>
 <20181116093225.GA17033@infradead.org>
 <fa3ed175-13a3-bedf-ebf9-ddf46a2decd5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fa3ed175-13a3-bedf-ebf9-ddf46a2decd5@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 16, 2018 at 10:45:11AM +0100, Paolo Bonzini wrote:
> On 16/11/18 10:32, Christoph Hellwig wrote:
> > On Mon, Nov 12, 2018 at 11:17:29AM +0100, Paolo Bonzini wrote:
> >>> Well, that's what we have the security_file_ioctl() LSM hook for so that
> >>> your security model can arbitrate access to ioctls.
> >>
> >> Doesn't that have TOC-TOU races by design?
> > 
> > If you want to look at the command - yes.  If you just want to filter
> > read vs write vs ioctl, no.
> 
> Yeah, but looking at the command is what Ted wants.  The thing that we
> did in RHEL was a single sysfs bool that allows unfiltered access,
> because it was sort of enough and made the delta very small.  But for
> upstream I want to do it right, even if that means learning all that
> new-fangled BPF stuff. :)

I'd argue that a purpose-built eBPF access control facility is
superior to the security_file_ioctl() LSM hook because it can make
available to the authorization function access to the cached results
of the SCSI INQUIRY command, and it avoids needing to duplicate
knowledge of how to parse the parameters of the SG_IO ioctl in the LSM
module as well as in the SCSI stack.

Just because you *could* implement anything in terms of a turing
machine tape doesn't mean that it is good idea.  Similarly, just
because you *can* implement something as an LSM hook doesn't mean that
it's the best design.

> >> Also, what about SG_IO giving write access to files that are only opened
> >> read-only (and only have read permissions)?
> > 
> > Allowing SG_IO on read-only permissions sounds like a reall bad idea,
> > filtering or not.
> 
> I would even agree, however it's allowed right now and I would be
> surprised if no one was relying on it in good faith ("I'm just doing an
> INQUIRY, why do I need to open O_RDWR").  And indeed:
> 
> $ sudo chmod a+r /dev/sda
> $ strace -e openat sg_inq /dev/sda
> openat(AT_FDCWD, "/dev/sda", O_RDONLY|O_NONBLOCK) = 3
>                              ^^^^^^^^
> 
> So it would be a regression.

Ugh, that's... unfortunate.  I suppose we could try to figure out all
of the SCSI commands that would have to be white-listed to be allowed
using O_RDONLY from historical usage, but that would be a huge job,
and it's highly likely we would miss some anyway.  OTOH, this could be
called a security botch that should be fixed, and if we make a best
effort to white list all of the innocuous cases such as SCSI INQUIRY,
maybe that would be acceptible.

					- Ted
