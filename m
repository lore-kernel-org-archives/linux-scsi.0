Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D34BC43141
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 02:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C88B206F4
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 02:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfKOCNS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 21:13:18 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34812 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKOCNS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 21:13:18 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id EF5C72A6F8;
        Thu, 14 Nov 2019 21:13:15 -0500 (EST)
Date:   Fri, 15 Nov 2019 13:13:15 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Kars de Jong <jongk@linux-m68k.org>,
        Hannes Reinecke <hare@suse.com>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        schmitzmic@gmail.com
Subject: Re: [PATCH v2 1/2] esp_scsi: Correct ordering of PCSCSI definition
 in esp_rev enum
In-Reply-To: <20191114222518.2441-2-jongk@linux-m68k.org>
Message-ID: <alpine.LNX.2.21.1.1911151157150.9@nippy.intranet>
References: <20191114215956.21767-1-jongk@linux-m68k.org> <20191114222518.2441-1-jongk@linux-m68k.org> <20191114222518.2441-2-jongk@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


For simplicity, the entire patch series would normally show the same 
version number (v3). Also, the series would normally be a thread unto 
itself, rather than a sub-thread.

On Thu, 14 Nov 2019, Kars de Jong wrote:

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
> the CONFIG3 register when used with FAST-SCSI targets.
> 
> Signed-off-by: Kars de Jong <jongk@linux-m68k.org>

This is Hannes' code so I'll leave it up to him to review this change.

I presume this is untested on PCSCSI hardware. ISTR that there's an 
emulator for that board somewhere...

-- 

> ---
>  drivers/scsi/esp_scsi.c |  2 +-
>  drivers/scsi/esp_scsi.h | 17 +++++++++--------
>  2 files changed, 10 insertions(+), 9 deletions(-)
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
> index 91b32f2a1a1b..f764d64e1f25 100644
> --- a/drivers/scsi/esp_scsi.h
> +++ b/drivers/scsi/esp_scsi.h
> @@ -257,15 +257,16 @@ struct esp_cmd_priv {
>  };
>  #define ESP_CMD_PRIV(CMD)	((struct esp_cmd_priv *)(&(CMD)->SCp))
>  
> +/* NOTE: this enum is ordered based on chip features! */
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
> +	FAS236,
> +	PCSCSI,  /* AM53c974 */
> +	FAS100A,
> +	FAST,
> +	FASHME,
>  };
>  
>  struct esp_cmd_entry {
> 

