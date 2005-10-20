From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: ips.c warnings
Date: Thu, 20 Oct 2005 13:38:30 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01C09D9E@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:26811 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932501AbVJTRif convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 13:38:35 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: IpsLinux <ipslinux@adaptec.com>, Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, akmpm@osdl.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Jack, do not forget legacy kernels. Christoph is notorious for dealing
only with latest kernel only.

Christoph, has this always been true? I believe it to be, but just in
case ...

Sincerely -- Mark Salyzyn


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of IpsLinux
Sent: Thursday, October 20, 2005 1:33 PM
To: Christoph Hellwig
Cc: Matthew Wilcox; akmpm@osdl.org; James.Bottomley@steeleye.com;
linux-scsi@vger.kernel.org; IpsLinux
Subject: RE: ips.c warnings


Sounds good to me.  That's easy enough to do.

I was just hesitant to take out an error check ( in code I didn't
originate ) without a 100% guarantee that it's OK without it.

I'll send a new patch and totally eliminate the checks and extra macros
...

Thanks.



-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Thursday, October 20, 2005 1:29 PM
To: Hammer, Jack
Cc: Matthew Wilcox; akmpm@osdl.org; James.Bottomley@steeleye.com;
linux-scsi@vger.kernel.org; IpsLinux
Subject: Re: ips.c warnings

On Thu, Oct 20, 2005 at 01:25:28PM -0400, Hammer, Jack wrote:
> 
> I have no problem trying kmap_atomic() as long as there's a sound,
> technical reason for changing code that's worked well for years.
> 
> What are the advantages/reasons of changing to use kmap_atomic() ?
It
> appears very few SCSI drivers use it.

I think the real question is: what are these checks for.  You should
never get an SG list with a NULL struct page or an SGL entry that points
to address 0 from the higher level code, and no other drivers checks for
that condition.



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
