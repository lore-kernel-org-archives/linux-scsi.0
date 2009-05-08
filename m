From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/4] mvsas: Set Hardware Bit for TMF
Date: Fri, 08 May 2009 15:47:28 +0000
Message-ID: <1241797648.3327.55.camel@mulgrave.int.hansenpartnership.com>
References: <20090508061704.GA1888@jason.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56232 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763465AbZEHPr3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2009 11:47:29 -0400
In-Reply-To: <20090508061704.GA1888@jason.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ying Chu <jasonchu@marvell.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org

On Fri, 2009-05-08 at 14:17 +0800, Ying Chu wrote:
> -	hdr->flags = cpu_to_le32(flags |
> -				 (tei->n_elem << MCH_PRD_LEN_SHIFT) |
> -				 (MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT));
> +	if (is_tmf)
> +		flags |= (MCH_SSP_FR_TASK << MCH_SSP_FR_TYPE_SHIFT);
> +	hdr->flags = cpu_to_le32(flags | (tei->n_elem << MCH_PRD_LEN_SHIFT));

If is_tmf isn't set, shouldn't we be setting the command frame
indicator, like the old code was? (I know it's sort of irrelevant
because MCH_SSP_FR_CMD is defined to be zero, so if you're just dumping
the definition MCH_SSP_FR_CMD, that's fine too).

James


