From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/11]  lpfc 8.1.1: Miscellaneous Cleanups
Date: Mon, 28 Nov 2005 19:35:40 +0000
Message-ID: <20051128193540.GB25722@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C45@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40335 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932203AbVK1Tfl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 14:35:41 -0500
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C45@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

>  #ifdef __BIG_ENDIAN_BITFIELD
>  			uint8_t nameType:4;	/* FC Word 0, bit 28:31 */
> -			uint8_t IEEEextMsn:4;	/* FC Word 0, bit 24:27, bit 8:11 of IEEE ext */
> +			uint8_t IEEEextMsn:4;	/* FC Word 0, bit 24:27, bit
> +						   8:11 of IEEE ext */
>  #else	/*  __LITTLE_ENDIAN_BITFIELD */
> -			uint8_t IEEEextMsn:4;	/* FC Word 0, bit 24:27, bit 8:11 of IEEE ext */
> +			uint8_t IEEEextMsn:4;	/* FC Word 0, bit 24:27, bit
> +						   8:11 of IEEE ext */
>  			uint8_t nameType:4;	/* FC Word 0, bit 28:31 */
>  #endif

Once you start touching these could we please get rid of the bitfield for
hardware registers abuse?  These should be proper 8/16/32 bit members and
then using bitmask as in all proper written drivers.

That beeing said there's tons of sparse warnings in lpfc, in large parts
due to things like this.  Would be nice if someone at emulex could get the
driver sparse and endianess clean.

