From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Add transport class and domain validation to ncr53c8xx
Date: Tue, 5 Oct 2004 21:31:31 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0410052116000.5094@poirot.grange>
References: <1096992032.2173.30.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:31150 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263117AbUJEUPP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2004 16:15:15 -0400
In-Reply-To: <1096992032.2173.30.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 5 Oct 2004, James Bottomley wrote:

> @@ -6235,10 +6243,13 @@
>  
>  		case NS_SYNC:
>  			ncr_setsync (np, cp, 0, 0xe0);
> +			spi_period(starget) = 0;
> +			spi_offset(starget) = 0;

Documentation/CodingStyle:

<quote>
Things to avoid when using macros:

....

3) macros with arguments that are used as l-values: FOO(x) = y; will
bite you if somebody e.g. turns FOO into an inline function.
</quote>

A trivial alternative would be to
#define spi_set_period(st, val) spi_period(st) = (val)
#define spi_set_offset(st, val) spi_offset(st) = (val)
....

Not too important, but, looks a bit nicer:

> +			spi_set_period(starget, 0);
> +			spi_set_offset(starget, 0);

Thanks
Guennadi
---
Guennadi Liakhovetski

