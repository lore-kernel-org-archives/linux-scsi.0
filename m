From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/8] megaraid_sas : Endianness related bug fixes and code optimization
Date: Thu, 08 Jan 2015 10:15:51 -0500
Message-ID: <yq1mw5t2ti0.fsf@sermon.lab.mkp.net>
References: <201501051440.t05Ee0Ld029960@palmhbs0.lsi.com>
	<20150108103842.GA600@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31835 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbAHPQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2015 10:16:26 -0500
In-Reply-To: <20150108103842.GA600@infradead.org> (Christoph Hellwig's message
	of "Thu, 8 Jan 2015 02:38:42 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org, martin.petersen@oracle.com, jbottomley@parallels.com, kashyap.desai@avagotech.com

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

> -#if   defined(__BIG_ENDIAN_BITFIELD)
> -	u32     MessageAddress1:24; /* bits 31:8*/
> -	u32     RequestFlags:8;
> -#else
>  	u32     RequestFlags:8;
> -	u32     MessageAddress1:24; /* bits 31:8*/
> -#endif
> -	u32     MessageAddress2;      /* bits 61:32 */
> +	u32     MessageAddress1:24;
> +	u32     MessageAddress2;

Christoph> Doesn't this break architectures that set
Christoph> __BIG_ENDIAN_BITFIELD?

We went back and forth a few times in debugging this issue. This
particular struct is always little endian and consists of an 8-bit LSB
flags field plus a 56-bit pointer.

I am not a fan of wedging these values into a u32 universe (which also
causes grief when the struct is being filled out). But the Avago folks
did it this way because they want to keep things in sync with their
firmware.

In any case the code works fine on big endian with this patch in place.

-- 
Martin K. Petersen	Oracle Linux Engineering
