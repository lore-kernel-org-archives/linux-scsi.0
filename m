From: Bryan Henderson <hbryan@us.ibm.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Wed, 8 Dec 2004 15:26:10 -0800
Message-ID: <OF6622B9F8.AFAA0D79-ON85256F64.00800FC4-88256F64.008074C9@us.ibm.com>
References: <0E3FA95632D6D047BA649F95DAB60E57057A1A53@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59063 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261407AbULHX03 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2004 18:26:29 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id iB8NQDBX021712
	for <linux-scsi@vger.kernel.org>; Wed, 8 Dec 2004 18:26:13 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iB8NQDeZ140730
	for <linux-scsi@vger.kernel.org>; Wed, 8 Dec 2004 18:26:13 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id iB8NQCAa029277
	for <linux-scsi@vger.kernel.org>; Wed, 8 Dec 2004 18:26:13 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57057A1A53@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: 'Andrew Morton' <akpm@osdl.org>, 'Arjan van de Ven' <arjan@infradead.org>, "Mukker, Atul" <Atulm@lsil.com>, brking@us.ibm.com, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, "Doelfel, Hardy" <hdoelfel@lsil.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'Matthew Wilcox' <matthew@wil.cx>, 'Matt Domsch' <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>

>My basics tell me that compiler would align the structure using the
>alignment restriction of the biggest member,

The compiler doesn't align the structure in the common case that it is 
dynamically allocated.

Apparently, the compiler assumes, with a naked struct declaration, that 
the user has done this, though.  With __attribute__((packed)), it does 
not.  And that seems reasonable to me.  These two properties of a struct 
(not allocated aligned and no alignment padding within) tend to go 
together.

>can only be good because the applications and
>driver could be compiled on different archs.

I'm having a hard time imagining where the application and the kernel 
could reasonably have been compiled for different architectures.  They're 
running on the same machine, aren't they?

>How much overhead can there be, it's just some data sent by the driver to
>application via ioctl?

This is the relevant point.  With the extra cycles being unnoticeable in 
this case, we should all but ignore that in favor of making code portable, 
readable, and hard for programmers to misunderstand.  It's not entirely 
clear that the packed structure is more portable, though.

