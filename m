From: Marc Dietrich <marvin24@gmx.de>
Subject: Re: [PATCH 1/2] SCSI: nsp32: replace large udelay by mdelay
Date: Wed, 22 May 2013 22:33:18 +0200
Message-ID: <3402164.UHqBT8YQpR@fb07-iapwap2.physik.uni-giessen.de>
References: <cover.1369251478.git.marvin24@gmx.de> <495d02a8263a553dd3f67b354f5ec9beb784a5d3.1369251478.git.marvin24@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58396 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab3EVUd0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 16:33:26 -0400
Received: from mailout-de.gmx.net ([10.1.76.12]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Ly8b5-1UQs2S2DO1-015cE6 for
 <linux-scsi@vger.kernel.org>; Wed, 22 May 2013 22:33:25 +0200
In-Reply-To: <495d02a8263a553dd3f67b354f5ec9beb784a5d3.1369251478.git.marvin24@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Looks like Arndt already send a fix for this. Sorry for the noise.

Am Mittwoch, 22. Mai 2013, 21:48:41 schrieb Marc Dietrich:
> ARM has a maximum of 2000 usec delay. Use mdelay for larger delays.
> This affects distro kernels mostly.
> 
> Cc: GOTO Masanori <gotom@debian.or.jp>
> Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Marc Dietrich <marvin24@gmx.de>
> ---
>  drivers/scsi/nsp32.c |    2 +-
>  drivers/scsi/nsp32.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index 1e3879d..e2f796f 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -2899,7 +2899,7 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
>  	 * reset SCSI bus
>  	 */
>  	nsp32_write1(base, SCSI_BUS_CONTROL, BUSCTL_RST);
> -	udelay(RESET_HOLD_TIME);
> +	mdelay(RESET_HOLD_TIME);
>  	nsp32_write1(base, SCSI_BUS_CONTROL, 0);
>  	for(i = 0; i < 5; i++) {
>  		intrdat = nsp32_read2(base, IRQ_STATUS); /* dummy read */
> diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
> index c022182..b2b3dc6 100644
> --- a/drivers/scsi/nsp32.h
> +++ b/drivers/scsi/nsp32.h
> @@ -605,7 +605,7 @@ typedef struct _nsp32_hw_data {
>  /*
>   * TIME definition
>   */
> -#define RESET_HOLD_TIME		10000	/* reset time in us (SCSI-2 says the
> +#define RESET_HOLD_TIME		10	/* reset time in ms (SCSI-2 says the
>  					   minimum is 25us) */
>  #define SEL_TIMEOUT_TIME	10000	/* 250ms defined in SCSI specification
>  					   (25.6us/1unit) */
