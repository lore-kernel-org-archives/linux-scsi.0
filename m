From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] 2.6 aacraid: endian cleanup
Date: Mon, 28 Mar 2005 18:02:10 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BF698DE@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:12525 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262108AbVC1XCS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 18:02:18 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

The new cardtype was a documentation. Could have been handled separately
I agree.

*I* have to support the broken port for reasons of expediency. Dropping
this behavior from the kernel.org patch is perfectly fine by me. I was
not sure how extensive this problem was.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Monday, March 28, 2005 5:00 PM
To: Mark Haverkamp
Cc: James Bottomley; linux-scsi; Salyzyn, Mark
Subject: Re: [PATCH] 2.6 aacraid: endian cleanup

On Mon, Mar 21, 2005 at 10:41:23AM -0800, Mark Haverkamp wrote:
> A patch from Adaptec with byte order changes:
>  - drop byte swapping on all 0's and all 1's content
>  - fix up missing swapping directives
>  - ensure swapping on 16 bit values does not use 32 bit swap
>  - reconcile the readl/writel auto-swapping in only most of the
> configurations.

that last bit is bogus.  readl/writel are defined to swap bytes on
big endian systems.  Whatever broken Mvista/Windriver or whatever port
doesn't do that should be fixed.

Also please remove unrelated changes like the new cardtypes from the
patch,
follow normal kernel codingstyle (e.g. ||, && at the end of the line)
and
switch to __le* types for harware structures and make sure it's passing
sparse -Wbitwise.

