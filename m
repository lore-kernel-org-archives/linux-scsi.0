From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH RFC] [PATCH] drivers/scsi/ch.c: Remove BKL in ch_open
Date: Sun, 11 Oct 2009 16:54:08 +0100
Message-ID: <20091011165408.51d4f413@lxorguk.ukuu.org.uk>
References: <alpine.LFD.2.00.0910111443400.3587@localhost.localdomain>
	<20091011153709.4438cf9c@lxorguk.ukuu.org.uk>
	<20091011082917.6ebbd810@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754623AbZJKPyK@vger.kernel.org>
In-Reply-To: <20091011082917.6ebbd810@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Vincent Sanders <vince@simtec.co.uk>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> > I'm not so sure. In fact there are some quite umm interesting
> > questions about this code, and some of them are shared with other
> > modules too.
> > 
> > Consider the following sequence
> > 
> > 		CPU1				CPU2
> > 	register_chrdev
> > 		ok
> > 						open device
> > 						takes lock
> 
> 
> but open does not take the BKL, so the BKL is not protecting you at
> all against this..

But module load/unload does - so while the change doesn't appear to cause
any problems there is an underlying problem here that wants looking at.
