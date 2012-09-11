From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Tue, 11 Sep 2012 13:01:50 -0700
Message-ID: <20120911200150.GV7677@google.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>
 <20120911165953.GK7677@google.com>
 <504F7B65.9090603@redhat.com>
 <20120911182904.GS7677@google.com>
 <504F88CB.6030105@redhat.com>
 <20120911191325.GU7677@google.com>
 <504F8FF0.3000408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <504F8FF0.3000408@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-scsi@vger.kernel.org

Hello, Paolo.

On Tue, Sep 11, 2012 at 09:24:32PM +0200, Paolo Bonzini wrote:
> > Couldn't it intercept some of them - e.g. RWs and discards?
> > What's the benifit / use case of doing pure bypass?
> 
> Basically, using the same storage technology for bare metal and
> virtualized systems.  IMHO losing sense data is a no-no, but the above
> solution could be feasible too.

Most of my experience with storage devices comes from SATA where error
data is more of the deal "take some hints if you really want but
there's pretty good chance it's completely bogus", so my perception
about the importance of sense data might not match the fancy SCSI
land.  I don't know.

Either way, with or without virtualization, making detailed error
information to userland is a valid goal.  I *think* we're finally
getting there after years of talking via structured printk.  I don't
know much about the details but heard about exposing sense data via
printk.  cc'ing Kay.  Kay, could that be useful for virtualization use
cases too?  They want to obtain the sense data after command failure.
I suppose there would be some challenge in matching actions and error
logs tho and it could be too clunky to use this way.

> > Can't you make use of the existing disk events mechanism for that?
> > Block layer already knows how to watch readiness of a device and tell
> > the userland about it via uevent.
> 
> How?  But anyway i don't want to divert the discussion from the actual
> topic...

Disk events mechanism is there to watch (either via async notification
or polling) media change and device readiness and generates the usual
uevents when it detects them.  For sd devices, it basically issues TUR
periodically, so it's already doing pretty much what you need.

I guess the repeating question is whether to solve the problem within
the framework the underlying OS is providing or having direct access
to the raw hardware.  I don't know the answer.

Accessing the "raw" hardware does have its advantages but managing
multiple users so that they don't step on each other's foot is one of
the main reasons we have this kernel thing after all, so there's
natural tension between "wanting raw" and "multiuser security/whatever
concerns".  Beyond certain point, I think it essentially becomes
wanting the cake and eating it too.

I personally hope "raw" to be strictly confined to specific areas
where performance impact of having kernel inbetween is prohibitive but
that's just me hoping.

Thanks.

-- 
tejun
