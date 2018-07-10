From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] sg, bsg: mitigate read/write abuse, block uaccess in release
Date: Tue, 10 Jul 2018 13:53:02 -0700
Message-ID: <CAG48ez0ahgHZAEYHt_J_MAanRNX+PXN+2MwtR-VM=gm8Ym30kg@mail.gmail.com>
References: <20180615152335.208202-1-jannh@google.com> <20180615164009.GD30522@ZenIV.linux.org.uk>
 <90063ef3-68fa-e983-9b47-838e6076b0f4@interlog.com> <813e817b-bb2f-4a47-6225-9e39f19be278@kernel.dk>
 <20180621123431.GA558@infradead.org> <36a641db-fb1d-6c4c-7f1b-172f2b1cde32@kernel.dk>
 <20180708145840.GA22949@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kernel-hardening-return-13750-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180708145840.GA22949@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, Douglas Gilbert <dgilbert@interlog.com>, Al Viro <viro@zeniv.linux.org.uk>, fujita.tomonori@lab.ntt.co.jp, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, security@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jul 8, 2018 at 7:58 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Jun 21, 2018 at 08:07:23AM -0600, Jens Axboe wrote:
> > I'd be fine with that, if we knew that nobody uses it. But that's
> > really hard to figure out. I did see Jann's source code scan, which
> > even if non-exhaustive, still shows at least one user of it.
>
> One is an example, and the other looks very close to an example,
> as far as I can tell it was Nic doing a bsg read/write WIP for a
> tgt module without anyone every picking up on it.  I did add the tgt
> list to Cc and no one seemed to care about the bsg read/write support.
> Adding the tgt list back, but I doubt anyone ever actually used it.
>
> > How about we just make the write interface sync? Then any copy can
> > happen while the we block the task, and the read side is just
> > copying the header info back, or dumping it if the task didn't
> > read it before it went away.
>
> How is that going to work?  As far as I can tell each I/O using
> bsg read/write needs a write and a read, so they need to pair
> and thus can't be a purely sync interface.
>
> It also doesn't help with the issue that bsg_write may possible
> write to user memory, which is highly unusal and asking for security
> issues itself.
>
> Either way, we should probably at very least apply a respun version
> of the patch from Jann to 4.18-rc and -stable while we keep discussing
> this.
>
> Jann, can you respin the bsg patch with the same changes as the now
> included sg one?

With the error messages like in my sg patch or like with Linus'
proposed patch (https://lore.kernel.org/lkml/CA+55aFwg-2GP4ASTdd1pusmZkF7c8AN9febVDCaioDxzYJSLfw@mail.gmail.com/)
applied?
