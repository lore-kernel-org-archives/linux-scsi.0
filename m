From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Wed, 14 Jul 2004 15:39:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040714153943.31f3c60e.akpm@osdl.org>
References: <200407141751.i6EHprhf009045@harpo.it.uu.se>
	<40F57D14.9030005@pobox.com>
	<20040714143508.3dc25d58.akpm@osdl.org>
	<40F5C42E.1060708@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:31106 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265228AbUGNXy6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 19:54:58 -0400
In-Reply-To: <40F5C42E.1060708@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Jeff Garzik <jgarzik@pobox.com> wrote:
>
> Andrew Morton wrote:
> > Yeah, but doing:
> > 
> > 	static inline foo(void);
> > 
> > 	bar()
> > 	{
> > 		...
> > 		foo();
> > 	}
> > 
> > 	static inline foo(void)
> > 	{
> > 		...
> > 	}
> > 
> > is pretty dumb too.  I don't see any harm if this compiler feature/problem
> > pushes us to fix the above in the obvious way.
> 
> 
> ???  C does not require ordering of function _implementations_, except 
> for this gcc brokenness.

Well.  Other compilers had that restriction iirc, and it's a pretty natural
thing to do.

> The above example allows one to do what one normally does with 
> non-inlines:  order code to enhance readability

I always expect to find those little helper functions earlier in the
compilation unit than their callsites.  Pascal-style.  Plus you don't have
the hassle of keeping the declaration and definition in sync.
