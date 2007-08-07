From: David Miller <davem@davemloft.net>
Subject: Re: An MCA ESP driver
Date: Tue, 07 Aug 2007 00:26:04 -0700 (PDT)
Message-ID: <20070807.002604.78735512.davem@davemloft.net>
References: <20070806232458.GC9732@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42815
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753583AbXHGH0G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 03:26:06 -0400
In-Reply-To: <20070806232458.GC9732@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Date: Mon, 6 Aug 2007 17:24:58 -0600

> @@ -514,11 +514,14 @@ struct esp {
>  
>  	struct completion	*eh_reset;
>  
> -	struct sbus_dma		*dma;
> +	union {
> +		struct sbus_dma	*sbus_dma;
> +		unsigned int	x86_dma;
> +	};
>  };

Feel free to make this a "void *dma_cookie" or similar.
It's private to the bus front-end.
