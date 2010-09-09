From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: 2.6.36-rc3: EIP is at scsi_init_io+...
Date: Thu, 09 Sep 2010 07:47:20 -0500
Message-ID: <1284036441.20480.2.camel@mulgrave.site>
References: <20100830184620.GA4818@core2.telecom.by>
	 <AANLkTikyv10vkg1g+G3LW+nu=0omBpc40KehOUH=YXk2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikyv10vkg1g+G3LW+nu=0omBpc40KehOUH=YXk2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jaxboe@fusionio.com>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-09-08 at 17:12 -0700, Linus Torvalds wrote:
> Hmm. No noise about this one.
> 
> Jens, Fujita, James, any comments?
> 
> On Mon, Aug 30, 2010 at 11:46 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > Not much of a calltrace, it scrolled away because of hardlockup detector.
> > On the bright side, radeon KMS worked correctly and actually showed it.
> >
> > $ addr2line -e vmlinux ffffffff812d207b
> > drivers/scsi/scsi_lib.c:1015
> >
> >  1012  err_exit:
> >  1013          scsi_release_buffers(cmd);
> >  1014          scsi_put_command(cmd);
> >  1015  ===>    cmd->request->special = NULL; <===
> >  1016          return error;
> >  1017  }
> >  1018  EXPORT_SYMBOL(scsi_init_io);
> 
> I do have to say that it looks rather wrong that it accesses "cmd"
> after it has done the "scsi_put_command(cmd)" on it.
> 
> I also note that that was introduced pretty recently by commit
> 610a63498f7 ("scsi: fix discard page leak"), merged during this merge
> window. That does look suspicious to me.

It's a use after free:  The put actually frees the cmnd and then we use
it to get to the request.  Most of the time nothing notices, but if you
have poison on free enabled, we may see the problem.  The fix is just to
reverse the put and the set.

James
