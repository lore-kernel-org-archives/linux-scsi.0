From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SPI transport class and generic Domain Validation for
	fusion
Date: Tue, 09 Aug 2005 09:47:10 -0500
Message-ID: <1123598830.5170.19.camel@mulgrave>
References: <1123537590.8235.4.camel@mulgrave>
	 <20050809091353.GA11397@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:25223 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964800AbVHIOr0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 10:47:26 -0400
In-Reply-To: <20050809091353.GA11397@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-08-09 at 10:13 +0100, Christoph Hellwig wrote:
>  - there's a stale printk("HERE2\n"); in mptscsih_writeSDP1.

Yes, sorry, I'll remove it

>  - the #undef MPTSCSIH_ENABLE_DOMAIN_VALIDATION is probably not needed

There's actually an awful lot of other cruft besides this that can come
out of the driver (inquiry snooping leaps to mind).

>  - the hd == NULL check in mptspi_target_alloc isn't needed

Yes, OK.

>  - should the driver print a warning about too old firmware when we can't
>    access page 0?

I'll defer to LSI on this one.  We can't attach the transport classes in
this case ... which is what I do.  But on the other hand, LSI didn't do
DV in this case either, so the current situation is identical to what we
had previously.

But yes, this type of situation seems quite common.  The fusion card HP
sent me initially had this problem, and it does seem to be possible to
upgrade all the problem cards, so reporting the issue and recommending
an upgrade seems to be a good approach.

James


