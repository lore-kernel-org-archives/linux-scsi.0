From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Tue, 11 Sep 2012 15:02:18 -0700
Message-ID: <20120911220218.GH7677@google.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>
 <20120911165953.GK7677@google.com>
 <504F7B65.9090603@redhat.com>
 <20120911182904.GS7677@google.com>
 <504F88CB.6030105@redhat.com>
 <20120911191325.GU7677@google.com>
 <504F8FF0.3000408@redhat.com>
 <20120911200150.GV7677@google.com>
 <504FB22E.4090707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <504FB22E.4090707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

Hello, Paolo.

On Tue, Sep 11, 2012 at 11:50:38PM +0200, Paolo Bonzini wrote:
> > Either way, with or without virtualization, making detailed error
> > information to userland is a valid goal.  I *think* we're finally
> > getting there after years of talking via structured printk.  I don't
> > know much about the details but heard about exposing sense data via
> > printk.
> 
> Wait wait, there is already a perfectly 1:1 solution for this, and it's
> SG_IO.
> 
> I think error processing falls roughly in two categories: "I need each
> command's precise state" and "I need to know if/when something bad
> happens".  Luckily, I/O also falls roughly in the same two categories:
> "I need precise control of each commands" and "I just care of getting
> this to disk".  The former can use SG_IO, the latter can use logs.

SG_IO itself is a bypassing interface.  It bypasses most of block
layer and the kernel doesn't have any idea (apart from the adhoc
filtering) about what's going on.  The problem can be approached from
both directions (make use of OS IO layer improving it as needed or add
more intelligence to the bypass thing) and I'm not sure at all adding
more capability to the adhoc filtering is the better direction.

So, what I wanna say is that if you can get by with the adhoc thing we
already have in place for cd/dvd, that's great; otherwise, it's not
clear at all whether expanding that adhoc filtering is a good idea.

Thanks.

-- 
tejun
