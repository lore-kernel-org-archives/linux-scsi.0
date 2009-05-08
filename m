From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/4] mvsas: Set Hardware Bit for TMF
Date: Fri, 08 May 2009 16:07:58 -0400
Message-ID: <4A04911E.6090409@garzik.org>
References: <20090508061704.GA1888@jason.marvell.com> <1241797648.3327.55.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:48733 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376AbZEHUIC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2009 16:08:02 -0400
In-Reply-To: <1241797648.3327.55.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ying Chu <jasonchu@marvell.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2009-05-08 at 14:17 +0800, Ying Chu wrote:
>> -	hdr->flags = cpu_to_le32(flags |
>> -				 (tei->n_elem << MCH_PRD_LEN_SHIFT) |
>> -				 (MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT));
>> +	if (is_tmf)
>> +		flags |= (MCH_SSP_FR_TASK << MCH_SSP_FR_TYPE_SHIFT);
>> +	hdr->flags = cpu_to_le32(flags | (tei->n_elem << MCH_PRD_LEN_SHIFT));
> 
> If is_tmf isn't set, shouldn't we be setting the command frame
> indicator, like the old code was? (I know it's sort of irrelevant
> because MCH_SSP_FR_CMD is defined to be zero, so if you're just dumping
> the definition MCH_SSP_FR_CMD, that's fine too).

Yeah, it's largely a matter of taste.

But even if MCH_SSP_FR_CMD is never used, its definition should remain, 
because the hardware documentation is not public.

	Jeff




