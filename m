From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] add extra inquiry byte 56 data to struct scsi_device
Date: Fri, 20 Aug 2004 23:21:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4126BFCC.2000702@pobox.com>
References: <1093053368.3318.569.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:8682 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268832AbUHUDV7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 23:21:59 -0400
In-Reply-To: <1093053368.3318.569.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> +	if (sdev->inquiry_len > 56) {
> +		if (inq_result[56] & 0x04)
> +			sdev->ppr = 1;
> +		if ((inq_result[56] & 0x0c) == 0x04)
> +			sdev->dt_only = 1;
> +		if (inq_result[56] & 0x01)
> +			sdev->ius = 1;
> +		if (inq_result[56] & 0x02)
> +			sdev->qas = 1;
> +	}


Do you forsee ever adding more feature bits like this?

It seems to me that a more maintainable approach is to cache relevant 
INQUIRY data in a buffer, and then create accessor macros for 
programmers' use.

That way you don't have to keep adding members (really, mnemonics) to a 
data structure, and associated initialization code, each time the 
mid-layer or some low-level drivers want to test a new feature bit. 
Initialization via memcpy is easy and automatic.

	Jeff


