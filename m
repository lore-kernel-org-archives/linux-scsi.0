From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Disk Errors
Date: Thu, 3 Feb 2005 10:50:47 -0800
Message-ID: <OFFD75721E.7EA8AD70-ON88256F9D.00670F64-88256F9D.0067908A@us.ibm.com>
References: <42004F23.10009@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50592 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263680AbVBCSwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2005 13:52:22 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j13IqIbs029420
	for <linux-scsi@vger.kernel.org>; Thu, 3 Feb 2005 13:52:18 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j13IqIcP281670
	for <linux-scsi@vger.kernel.org>; Thu, 3 Feb 2005 13:52:18 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j13IqHNi032550
	for <linux-scsi@vger.kernel.org>; Thu, 3 Feb 2005 13:52:18 -0500
In-Reply-To: <42004F23.10009@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Kit Gerrits <kit@gerritsacc.nl>, linux-scsi@vger.kernel.org, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>

>BTW I noticed that the block layer reads "around" a medium
>error. Say 8 KB is being read and a medium error occurs
>(and the info field is set to the lba of the first failure)
>then several small reads are done to reconstruct as much
>of the original 8 KB as possible (probably with a block of
>zeroes corresponding to the medium error).

The only way that makes sense is if the 8K I/O was in service of multiple 
block requests and the block layer is separating them and retrying in 
order to fail the smallest possible set of them.  The block layer's upper 
interface doesn't provide a means to indicate that the middle of a request 
failed, and it certainly isn't going to substitute zeroes for the 
requested data and call it successful.

