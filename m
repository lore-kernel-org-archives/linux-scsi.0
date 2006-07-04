From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] scsi/io-elevator held lock freed.
Date: Tue, 4 Jul 2006 17:15:04 +0200
Message-ID: <20060704151504.GA10779@elte.hu>
References: <1152024854.29262.5.camel@c-67-180-134-207.hsd1.ca.comcast.net> <1152026010.3109.66.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:54704 "EHLO mx2.mail.elte.hu")
	by vger.kernel.org with ESMTP id S1750815AbWGDPTl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jul 2006 11:19:41 -0400
Content-Disposition: inline
In-Reply-To: <1152026010.3109.66.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 2006-07-04 at 07:54 -0700, Daniel Walker wrote:
> > I got this during boot. I booted the same kernel several times, and only
> > saw it once. The kernel was 2.6.17-mm5 .
> > 
> > Daniel
> > 
> > 
> > =========================
> > [ BUG: held lock freed! ]
> > -------------------------
> > swapper/1 is freeing memory f73a8580-f73a867f, with a lock still held there!
> > 2 locks held by swapper/1:
> >  #0:  (&shost->scan_mutex){--..}, at: [<c0419098>] mutex_lock+0x8/0x10
> >  #1:  (&eq->sysfs_lock){--..}, at: [<c0419098>] mutex_lock+0x8/0x10
> 
> blargh.. it'd be more useful if lockdep actually printed which lock it 
> is that it thinks is about to get freed.....

i think it's eq->sysfs_lock that is being freed here.

> this patch ought to make it do that; could you at least add this to 
> your kernel?
> 
> Ingo, is this the right approach?

yeah, that's OK.

	Ingo
