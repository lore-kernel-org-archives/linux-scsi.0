From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC] [PATCH] drivers/scsi/ch.c: Remove BKL in ch_open
Date: Sun, 11 Oct 2009 08:29:17 -0700
Message-ID: <20091011082917.6ebbd810@infradead.org>
References: <alpine.LFD.2.00.0910111443400.3587@localhost.localdomain>
	<20091011153709.4438cf9c@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbZJKP31 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Oct 2009 11:29:27 -0400
In-Reply-To: <20091011153709.4438cf9c@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Vincent Sanders <vince@simtec.co.uk>, linux-scsi@vger.kernel.org

On Sun, 11 Oct 2009 15:37:09 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sun, 11 Oct 2009 15:45:16 +0200 (CEST)
> John Kacur <jkacur@redhat.com> wrote:
> 
> [linux-scsi cc'd]
> 
> > Locking in ch_open is covered by the spin_lock, it serializes the
> > calls to idr_find and scsi_device_get. The BKL appears redundant to
> > me here.
> 
> I'm not so sure. In fact there are some quite umm interesting
> questions about this code, and some of them are shared with other
> modules too.
> 
> Consider the following sequence
> 
> 		CPU1				CPU2
> 	register_chrdev
> 		ok
> 						open device
> 						takes lock


but open does not take the BKL, so the BKL is not protecting you at
all against this..



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
