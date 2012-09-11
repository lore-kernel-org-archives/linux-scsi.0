From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Tue, 11 Sep 2012 19:56:53 +0200
Message-ID: <504F7B65.9090603@redhat.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com> <20120911165953.GK7677@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120911165953.GK7677@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

Il 11/09/2012 18:59, Tejun Heo ha scritto:
> FWIW, I don't think this is the right way to expose functionality
> which needs management in terms of access control, interpretation
> (stacking drivers) and serving concurrent users.  SG_IO filtering was
> mostly for cd/dvd burning and other removeable devices.

Understood; unfortunately, there is another major user of it
(virtualization).  If you are passing "raw" LUNs down to a virtual
machine, there's no possibility at all to use a properly encapsulated
interface and still be able to pass sense data etc. back to the virtual
machine.  And it's only going to grow now that people are starting to
use virtio-scsi.

The set of use cases is so variable that no single filter can accomodate
all of them: high availability people want persistent reservations, NAS
people want trim/discard, but these are just two groups.  Someone is
using a Windows VM to run vendor tools and wants to have access to
vendor-specific commands.

You can tell this last group to use root, but not everyone else who is
already relying on Unix permissions, SELinux and/or device cgroups to
confine their virtual machines.

A generic filter (see
http://article.gmane.org/gmane.linux.kernel/1312326 for a proposal)
would be satisfactory for everyone, but it's also a major undertaking
and so far I've not received a single comment about it.

> So, it wouldn't be a good idea to abuse SG_IO filtering for exposing
> trim/discard.  It's something which should be retired or at least
> severely restricted in time.  I don't think we want to be developing
> new uses of it.
> 
> I think trim/discards are fairly easy to abstract and common enough to
> justify having properly abstracted interface.  In fact, we already
> have block layer interface for it - BLKDISCARD.  If it's lacking,
> let's improve that.

I do want to improve the block layer interfaces to avoid that people use
SG_IO.  But unfortunately this is for a completely different use case.

Paolo
