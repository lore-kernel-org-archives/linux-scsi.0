From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: ips.c warnings
Date: Thu, 20 Oct 2005 13:54:54 -0400
Message-ID: <1129830894.3327.11.camel@mulgrave>
References: <A121ABA5B472B74EB59076B8E3C8F0190195F824@rtpe2k01.adaptec.com>
	 <20051020172914.GA32307@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:38631 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932508AbVJTRzJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 13:55:09 -0400
In-Reply-To: <20051020172914.GA32307@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Hammer, Jack" <Jack_Hammer@adaptec.com>, Matthew Wilcox <matthew@wil.cx>, akmpm@osdl.org, linux-scsi@vger.kernel.org, IpsLinux <ipslinux@adaptec.com>

On Thu, 2005-10-20 at 18:29 +0100, Christoph Hellwig wrote:
> I think the real question is: what are these checks for.  You should never
> get an SG list with a NULL struct page or an SGL entry that points to address
> 0 from the higher level code, and no other drivers checks for that condition.

Actually, no, that's not the problem.

The macro is taking page_address((sgl)->page).  That can be null if the
page isn't mapped into the kernel.  According to my reading of the code
it's doing this for some type of buffering reasons which require an
in-kernel memcpy().  If it finds page_address() to be NULL then it
simply doesn't do the operation.  Scatter/Gather lists, by and large,
come from a user so this operation should be failing all the time in any
x86 machine that has > 1GB of memory, I would have thought.

That's why I advocated using kmap (or kmap_atomic) because you need to
make the page exist in the kernel while you do the copy (and then unmap
it afterwards).  We've been having to add this operation to quite a lot
of raid drivers recently because of the changes to SCSI that make all
operations go via block layer scatter/gather lists.

James


