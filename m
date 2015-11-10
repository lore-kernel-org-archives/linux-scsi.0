From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V2 2/3] scsi: fix compiler warning for sg
Date: Tue, 10 Nov 2015 11:09:48 +0100
Message-ID: <6427533.oLIG8d5C7c@wuerfel>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org> <564177D7.7070103@codeaurora.org> <5641783D.3030108@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5641783D.3030108@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Timur Tabi <timur@codeaurora.org>, Sinan Kaya <okaya@codeaurora.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>, jcm@redhat.com, Andy Gross <agross@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 09 November 2015 22:53:17 Timur Tabi wrote:
> Sinan Kaya wrote:
> >
> > The code says it is using these macros for small integers only which
> > can't overflow. I was trying to get rid of compiler warning and it seems
> > to have disappeared.
> 
> I would double-check the assembly code, if I were you.  I don't like it 
> when warnings just go away like that.
> 
> Besides, we *should* be using do_div() for 64-bit division.

I stared at this code for some time and couldn't figure out whether it
is actually safe or not. The point here is that it doesn't actually do
a 64-bit division here:

	MULDIV(INT_MAX, USER_HZ, HZ)

where all arguments are 32bit and it tries to figure out whether the
ioctl argument is too big to fit into a 32-bit number

but it does a 'long' division that happens to be 64-bit long on
architectures with the respective register size when it then does

	sfp->timeout = MULDIV (val, HZ, USER_HZ);

to scale up the argument from USER_HZ to the possibly larger in-kernel
HZ value. So I think it's safe as is, but I'm still not entirely sure.

	Arnd
