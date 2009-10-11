From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH RFC] [PATCH] drivers/scsi/ch.c: Remove BKL in ch_open
Date: Sun, 11 Oct 2009 17:14:03 +0100
Message-ID: <20091011171403.13a018f0@lxorguk.ukuu.org.uk>
References: <alpine.LFD.2.00.0910111443400.3587@localhost.localdomain>
	<20091011153709.4438cf9c@lxorguk.ukuu.org.uk>
	<20091011082917.6ebbd810@infradead.org>
	<20091011165408.51d4f413@lxorguk.ukuu.org.uk>
	<20091011090313.1b8f0eb1@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56868 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754477AbZJKQNs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Oct 2009 12:13:48 -0400
In-Reply-To: <20091011090313.1b8f0eb1@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Vincent Sanders <vince@simtec.co.uk>, linux-scsi@vger.kernel.org

> > But module load/unload does
> 
> it does?
> 
> looking at the code.... so far failing to find where.

Interesting - it used to and there is code that still relies on that.

The more general problem of

	register_chrdev
					open
	do something
	error
	unload
					whoops

definitely needs looking at however.
