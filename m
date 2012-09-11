From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Tue, 11 Sep 2012 11:29:04 -0700
Message-ID: <20120911182904.GS7677@google.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>
 <20120911165953.GK7677@google.com>
 <504F7B65.9090603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <504F7B65.9090603@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Paolo.

On Tue, Sep 11, 2012 at 07:56:53PM +0200, Paolo Bonzini wrote:
> Understood; unfortunately, there is another major user of it
> (virtualization).  If you are passing "raw" LUNs down to a virtual
> machine, there's no possibility at all to use a properly encapsulated

Is there still command filtering issue when you're passing "raw" LUNs
down?

> interface and still be able to pass sense data etc. back to the virtual
> machine.  And it's only going to grow now that people are starting to
> use virtio-scsi.
> 
> The set of use cases is so variable that no single filter can accomodate
> all of them: high availability people want persistent reservations, NAS
> people want trim/discard, but these are just two groups.  Someone is
> using a Windows VM to run vendor tools and wants to have access to
> vendor-specific commands.
> 
> You can tell this last group to use root, but not everyone else who is
> already relying on Unix permissions, SELinux and/or device cgroups to
> confine their virtual machines.

You listed three - HA w/ persistent reservation, NAS w/ trim/discard
and the third which you said that using root would be fine.  Dunno
much about persistent reservation but I don't see why trim/discard
can't use existing block layer facilities whether from userland or
virtio-scsi?

> A generic filter (see
> http://article.gmane.org/gmane.linux.kernel/1312326 for a proposal)
> would be satisfactory for everyone, but it's also a major undertaking
> and so far I've not received a single comment about it.

Maybe I'm just not familiar with the problem space but I really hope
things don't come to that.  It's not like kernel by itself has to
support every single possible use cases.

> > So, it wouldn't be a good idea to abuse SG_IO filtering for exposing
> > trim/discard.  It's something which should be retired or at least
> > severely restricted in time.  I don't think we want to be developing
> > new uses of it.
> > 
> > I think trim/discards are fairly easy to abstract and common enough to
> > justify having properly abstracted interface.  In fact, we already
> > have block layer interface for it - BLKDISCARD.  If it's lacking,
> > let's improve that.
> 
> I do want to improve the block layer interfaces to avoid that people use
> SG_IO.  But unfortunately this is for a completely different use case.

Hmmm?  This was about discard, no?

Thanks.

-- 
tejun
