From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] megaraid_sas : Endianness related bug fixes and code
 optimization
Date: Thu, 8 Jan 2015 02:38:42 -0800
Message-ID: <20150108103842.GA600@infradead.org>
References: <201501051440.t05Ee0Ld029960@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35750 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbbAHKin (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2015 05:38:43 -0500
Content-Disposition: inline
In-Reply-To: <201501051440.t05Ee0Ld029960@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

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

Doesn't this break architectures that set __BIG_ENDIAN_BITFIELD?
