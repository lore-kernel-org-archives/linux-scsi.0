From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: How to add/drop SCSI drives from within the driver?
Date: Wed, 08 Dec 2004 15:14:58 -0500
Message-ID: <1102536897.2830.39.camel@laptop.fenrus.org>
References: <OF92E0C426.585D5E2A-ON85256F64.006E6FA1-88256F64.006E585F@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60859 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261347AbULHUQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2004 15:16:25 -0500
In-Reply-To: <OF92E0C426.585D5E2A-ON85256F64.006E6FA1-88256F64.006E585F@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, 'Andrew Morton' <akpm@osdl.org>, "Mukker, Atul" <Atulm@lsil.com>, brking@us.ibm.com, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, "Doelfel, Hardy" <hdoelfel@lsil.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Matt Domsch <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>

On Wed, 2004-12-08 at 15:08 -0500, Bryan Henderson wrote:
> >> I would also suggest __attribute__((packed)) since you're sharing with
> >> userspace just to ensure you can never get it grown by the compiler
> >> (it shouldn't be, but just to be safe).
> >
> >That's a bad idea, it forces the compiler to pessimise accesses to the
> >struct on most hardware.
> 
> How?  We're assuming that it won't actually affect the layout of this 
> struct, so what does the compiler pessimize?

it also makes the compiler assume the struct members aren't aligned to
the natural alignment and thus it'll emit more expensive access paterns
on architectures that care about such things.
-- 

