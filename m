From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [V2 PATCH 1/4] scsi:stex.c Support to Pegasus series.
Date: Wed, 12 Nov 2014 02:43:00 -0800
Message-ID: <20141112104300.GA31213@infradead.org>
References: <5462D366.5030106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49723 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaKLKnB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 05:43:01 -0500
Content-Disposition: inline
In-Reply-To: <5462D366.5030106@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Charles Chiou <ch1102chiou@gmail.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> +	u8  yellowstone;

Calling this flag yellowstone seems a bit confusing as there already
is a st_yel card type, and this only seems a subset of those.  Maybe
a ->support_pm flag or similar would be useful?

> +	u32 subID;

We don't use camelCaps, but I don't think you even need this variable at
all..

> 
>  	hba->cardtype = (unsigned int) id->driver_data;
>  	ci = &stex_card_info[hba->cardtype];
> +	subID = id->subdevice;
> +	if ((subID == 0x4221 || subID == 0x4222 ||
> +	    subID == 0x4223 || subID == 0x4224 ||
> +	    subID == 0x4225 || subID == 0x4226 ||
> +	    subID == 0x4227 || subID == 0x4261 ||
> +	    subID == 0x4262 || subID == 0x4263 ||
> +	    subID == 0x4264 || subID == 0x4265) &&
> +	    (hba->cardtype == st_yel)) {
> +		hba->yellowstone = 1;
> +	} else if (hba->cardtype == st_yel) {
> +		hba->yellowstone = 0;
> +	}

Just write this as

	switch (id->subdevice) {
	case 0x4221:
	case 0x4222:
	case 0x4223:
	case 0x4224:
	case 0x4225:
	case 0x4226:
	case 0x4227:
	case 0x4261:
	case 0x4262:
	case 0x4263:
	case 0x4264:
	case 0x4265:
		if (hba->cardtype == st_yel) {
			hba->supports_pm = 1;
			break;
		}
	default:
		hba->supports_pm = 0;
	}

