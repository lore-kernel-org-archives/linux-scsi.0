From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Sparse fix for scsi_request_fn
Date: Tue, 23 Oct 2007 15:13:37 -0600
Message-ID: <20071023211337.GT27248@parisc-linux.org>
References: <20071023014845.GN27248@parisc-linux.org> <alpine.LFD.0.999.0710221908130.30120@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35837 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbXJWVNi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 17:13:38 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710221908130.30120@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Oct 22, 2007 at 07:09:56PM -0700, Linus Torvalds wrote:
> Umm. This is why we write things like
> 
> 	static void double_lock_balance(struct rq *this_rq, struct rq *busiest)
> 		__releases(this_rq->lock)
> 		__acquires(busiest->lock)
> 		__acquires(this_rq->lock)
> 	{
> 		...
> 
> ie your "__holds()" is nothing new, and should be written as 
> a pair of __releases(x) and __acquires(x), which is more readable anyway 
> (since it actually says what the function does!)

Thanks, I hadn't realised that sparse would unify the two declarations.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
