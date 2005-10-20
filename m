From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ips.c warnings
Date: Thu, 20 Oct 2005 18:29:14 +0100
Message-ID: <20051020172914.GA32307@infradead.org>
References: <A121ABA5B472B74EB59076B8E3C8F0190195F824@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60599 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932498AbVJTR3R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 13:29:17 -0400
Content-Disposition: inline
In-Reply-To: <A121ABA5B472B74EB59076B8E3C8F0190195F824@rtpe2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: Matthew Wilcox <matthew@wil.cx>, akmpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, IpsLinux <ipslinux@adaptec.com>

On Thu, Oct 20, 2005 at 01:25:28PM -0400, Hammer, Jack wrote:
> 
> I have no problem trying kmap_atomic() as long as there's a sound,
> technical reason for changing code that's worked well for years.
> 
> What are the advantages/reasons of changing to use kmap_atomic() ?   It
> appears very few SCSI drivers use it.

I think the real question is: what are these checks for.  You should never
get an SG list with a NULL struct page or an SGL entry that points to address
0 from the higher level code, and no other drivers checks for that condition.

