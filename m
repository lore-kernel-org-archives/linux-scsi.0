Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D9BC17440
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 23:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDEBE21D7F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 23:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfKLXHC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 18:07:02 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33174 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKLXHC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 18:07:02 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 8E44329910;
        Tue, 12 Nov 2019 18:06:58 -0500 (EST)
Date:   Wed, 13 Nov 2019 10:07:01 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Kars de Jong <jongk@linux-m68k.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        linux-m68k@vger.kernel.org, schmitzmic@gmail.com
Subject: Re: [PATCH 1/2] esp_scsi: Correct ordering of PCSCSI definition in
 esp_rev enum
In-Reply-To: <20191112185710.23988-2-jongk@linux-m68k.org>
Message-ID: <alpine.LNX.2.21.1.1911130946410.13@nippy.intranet>
References: <20191029220503.7553-1-jongk@linux-m68k.org> <20191112185710.23988-1-jongk@linux-m68k.org> <20191112185710.23988-2-jongk@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Nov 2019, Kars de Jong wrote:

> The order of the definitions in the esp_rev enum is important. The values
> are used in comparisons for chip features.
> 
> Add a comment to the enum explaining this.
> 
> Also, the actual values for the enum fields are irrelevant, so remove the
> explicit values (suggested by Geert Uytterhoeven). This makes adding a new
> field in the middle of the enum easier.
> 
> Finally, move the PCSCSI definition to the right place in the enum. In its
> previous location, at the end of the enum, the wrong values are written to
> the CONFIG3 register when used with FAST-SCSI targets. Add comments to the
> enum explaining this.
> 
> Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
> ---
>  drivers/scsi/esp_scsi.c |  2 +-
>  drivers/scsi/esp_scsi.h | 19 +++++++++++--------
>  2 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index bb88995a12c7..4fc3eee3138b 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2373,10 +2373,10 @@ static const char *esp_chip_names[] = {
>  	"ESP100A",
>  	"ESP236",
>  	"FAS236",
> +	"AM53C974",
>  	"FAS100A",
>  	"FAST",
>  	"FASHME",
> -	"AM53C974",
>  };
>  
>  static struct scsi_transport_template *esp_transport_template;
> diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
> index 91b32f2a1a1b..b96cbda03d2d 100644
> --- a/drivers/scsi/esp_scsi.h
> +++ b/drivers/scsi/esp_scsi.h
> @@ -257,15 +257,18 @@ struct esp_cmd_priv {
>  };
>  #define ESP_CMD_PRIV(CMD)	((struct esp_cmd_priv *)(&(CMD)->SCp))
>  
> +/* NOTE: this enum is ordered based on chip features! */

Fair enough, that has been overlooked before.

>  enum esp_rev {
> -	ESP100     = 0x00,  /* NCR53C90 - very broken */
> -	ESP100A    = 0x01,  /* NCR53C90A */
> -	ESP236     = 0x02,
> -	FAS236     = 0x03,
> -	FAS100A    = 0x04,
> -	FAST       = 0x05,
> -	FASHME     = 0x06,
> -	PCSCSI     = 0x07,  /* AM53c974 */
> +	ESP100,  /* NCR53C90 - very broken */
> +	ESP100A, /* NCR53C90A */
> +	ESP236,
> +	/* Chips below this line use ESP_CONFIG3_FSCSI to enable FAST SCSI */
> +	FAS236,
> +	PCSCSI,  /* AM53c974 */
> +	/* Chips below this line use ESP_CONFIG3_FAST to enable FAST SCSI */
> +	FAS100A,
> +	FAST,
> +	FASHME,
>  };
>  
>  struct esp_cmd_entry {
> 

FAS100A, FAST and FASHME are below both lines, which is a bit confusing.

In general, I don't like to see comments that merely re-state the explicit 
logic in the algorithm. Such comments add no value.

(At best this redundancy creates a maintenance burden and at worst the 
commentary becomes neglected until it creates contradictions.)

Aside from that:
Reviewed-by: Finn Thain <fthain@telegraphics.com.au>

-- 
