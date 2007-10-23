From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Sparse fix for scsi_request_fn
Date: Mon, 22 Oct 2007 19:09:56 -0700 (PDT)
Message-ID: <alpine.LFD.0.999.0710221908130.30120@woody.linux-foundation.org>
References: <20071023014845.GN27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbXJWCKK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Oct 2007 22:10:10 -0400
In-Reply-To: <20071023014845.GN27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org



On Mon, 22 Oct 2007, Matthew Wilcox wrote:
>
> Introduce new __holds() macro to tell sparse it's OK to drop and then
> reacquire a lock within a function.  Use it in scsi_request_fn.

Umm. This is why we write things like

	static void double_lock_balance(struct rq *this_rq, struct rq *busiest)
		__releases(this_rq->lock)
		__acquires(busiest->lock)
		__acquires(this_rq->lock)
	{
		...

ie your "__holds()" is nothing new, and should be written as 
a pair of __releases(x) and __acquires(x), which is more readable anyway 
(since it actually says what the function does!)

		Linus
