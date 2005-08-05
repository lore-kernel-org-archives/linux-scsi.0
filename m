From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 7/7] aacraid: sgraw command support
Date: Fri, 5 Aug 2005 11:57:27 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01800A71@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:40896 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262379AbVHEP7b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2005 11:59:31 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

The size is to match the 64 bit address space command packet to the
adapter. A dma_addr_t is assigned to an u64 which ends up in a pair of
__le32's. We also issue 32 bit address space command packets where the
dma_addr_t is (truncated) into an u32 and placed into a single __le32.
The code style remains roughly the same for all three paths (32 bit
address io, 64 bit address io, 64 bit raw io) to cover all the different
generations of adapters.

The 'addr' is a hardware sized cpu ordered placeholder.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Arjan van de Ven [mailto:arjan@infradead.org] 
Sent: Friday, August 05, 2005 10:45 AM
To: Mark Haverkamp
Cc: Salyzyn, Mark; linux-scsi; James Bottomley
Subject: RE: [PATCH 7/7] aacraid: sgraw command support

On Fri, 2005-08-05 at 07:24 -0700, Mark Haverkamp wrote:
> On Thu, 2005-08-04 at 07:40 -0400, Salyzyn, Mark wrote:
> > In these cases, the 'addr' is an u64, so is it necessary to perform
this
> > modification?
> 
> Arjan,
> 
> Do you agree with the above?  If so, is the patch OK as is?

Ok you're ok then. I just then in turn question why addr is actually a
u64, and not say, a dma_addr_t or something..




