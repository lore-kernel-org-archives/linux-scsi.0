From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Wed, 8 Dec 2004 15:36:22 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57057A1A53@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58826 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261308AbULHUqn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2004 15:46:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Arjan van de Ven' <arjan@infradead.org>, 'Bryan Henderson' <hbryan@us.ibm.com>
Cc: 'Matthew Wilcox' <matthew@wil.cx>, 'Andrew Morton' <akpm@osdl.org>, "Mukker, Atul" <Atulm@lsil.com>, "'brking@us.ibm.com'" <brking@us.ibm.com>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, "Doelfel, Hardy" <hdoelfel@lsil.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Matt Domsch' <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>

> On Wed, 2004-12-08 at 15:08 -0500, Bryan Henderson wrote:
> > >> I would also suggest __attribute__((packed)) since 
> you're sharing 
> > >> with userspace just to ensure you can never get it grown by the 
> > >> compiler (it shouldn't be, but just to be safe).
> > >
> > >That's a bad idea, it forces the compiler to pessimise accesses to 
> > >the struct on most hardware.
> > 
> > How?  We're assuming that it won't actually affect the 
> layout of this 
> > struct, so what does the compiler pessimize?
> 
> it also makes the compiler assume the struct members aren't 
> aligned to the natural alignment and thus it'll emit more 
> expensive access paterns on architectures that care about such things.

My basics tell me that compiler would align the structure using the
alignment restriction of the biggest member, so this structure would still
be same irrespective of __attribute__((packed)) and result in same
instructions. May be wrong. But the point is, it will be an assumption so
specifying proper attributes can only be good because the applications and
driver could be compiled on different archs.

How much overhead can there be, it's just some data sent by the driver to
application via ioctl?

Thanks
-Atul
