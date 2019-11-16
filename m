Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D09C432C3
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 04:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32BD82072D
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 04:30:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VR2eWIld"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfKPEaj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 23:30:39 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37386 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbfKPEaj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 23:30:39 -0500
Received: by mail-pg1-f196.google.com with SMTP id z24so6919395pgu.4;
        Fri, 15 Nov 2019 20:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=SkujBsob3P6ItMuWCYwuPYMaNG9tU8x/NtegFwuF1go=;
        b=VR2eWIld+o4KDr4HB/rWje8CjMYMcru8OB0BPDIcJ1efZ6uwL0X1dlzpP6z2mANoBs
         L+yzWVxt8gdlWYoyE3FmS3mk5BVvrUZ2Fb/I8TlUs4WvRYLwqFW9GOrH8XnMh92nH9ej
         yRXgAcI3QjnDk0CkZJgt6rJFdA4XqFryfhKTLsMqOzmxt6Jw2llSPGVVjnlpXvoWsvC6
         GcJUzNlXSF7KHK/RtOkewgEBgtyiTiamJTucfXidDm/iL/7PiCI/ZVkyDF/u9nN2go13
         KXaJfhJAzDYyHo7avClnCTGQCR30Z8i0q5Pi67Fen13WOL190brXc1OjfxH0JK2gPKXB
         i8vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=SkujBsob3P6ItMuWCYwuPYMaNG9tU8x/NtegFwuF1go=;
        b=iFN3iA+nFXBgmkjjlCAzfQL7wjDbZhQJRjuB/29xNkM4XQS0nqDUFYlg3a+7yVzvs9
         qM1zkhV29vYSpDpEa3nXk2DjdE76F/bnsg/O0q4NdBMXWDwvD5/+uWpCFgneKkW35E/h
         fhduM5X/JWb+lsPQWyIGstHXFUQb2ono2ZxGrwu8jWElDsdIAiFD8Dk+XSddLpr1ECzI
         HfXecZvPpK0ZNrw9SEzDUWXH/lxFfn9UO3NMHZl3le/CGXZcUmo7vcmn4Psgb9wmuIop
         mChKWWhe4qAbks8ST6NgvyhiMPKP+lp0CqaZvPRC7AdBD5hHJPjq5c/icx6KH1u65QIX
         csDQ==
X-Gm-Message-State: APjAAAVNv/zSBNB8p98eZpXMBOkx8WytmPWd31rmafcHjw65j18ZjAi1
        FEdjTiv3TrbYgokH6lhTMgtscW2s
X-Google-Smtp-Source: APXvYqwBAjrFzq+CixRblcGYoIwET6XjDQ/AO1eSnpQ3N3oWiHgb3PNq29vELRUcbk3WXBDFsTU0Iw==
X-Received: by 2002:a63:6483:: with SMTP id y125mr4392067pgb.444.1573878638701;
        Fri, 15 Nov 2019 20:30:38 -0800 (PST)
Received: from [192.168.1.101] (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id a66sm12640834pfb.166.2019.11.15.20.30.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 20:30:38 -0800 (PST)
Subject: Re: [PATCH] esp_scsi: Clear Transfer Count registers before PIO
 transfers
To:     Finn Thain <fthain@telegraphics.com.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <2bbb6359d542f5882be67c415ecc25ad2d9eeb5e.1573875417.git.fthain@telegraphics.com.au>
Cc:     Kars de Jong <jongk@linux-m68k.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <36712461-b94c-4aff-8664-3896c2cf2524@gmail.com>
Date:   Sat, 16 Nov 2019 17:30:32 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <2bbb6359d542f5882be67c415ecc25ad2d9eeb5e.1573875417.git.fthain@telegraphics.com.au>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

Am 16.11.2019 um 16:36 schrieb Finn Thain:
> The zorro_esp driver uses both PIO and DMA transfers. If a failed DMA
> transfer happened to be followed by a PIO transfer, the TCLOW and TCMED
> registers would not get cleared. It is theoretically possible that the
> stale value from the transfer counter or the TCLOW/TCMED registers
> could then be used by the controller and the driver. Avoid that by
> clearing these registers before each PIO transfer.

I believe you also need to send a DMA NOP command to the ESP:

"Values
written to these two registers will be stored inter-
nally and loaded into the transfer counter by any
DMA command. These values remain unchanged
while the transfer counter decrements. Thus,
successive blocks of equal size may be transferred
without reprogramming the count. They may be
reprogrammed any time after the previous DMA
operation has started, whether it has finished or
not."

"Any DMA command will load the transfer count into
the counter. A DMA NOP (80h) will load the
counter while the non-DMA NOP (OOh) will not."

(53CF64_96-2 data book)

Without the DMA NOP, the transfer counts will remain as they were left 
by the prematurely terminated DMA command.

Cheers,

	Michael

>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Cc: Kars de Jong <jongk@linux-m68k.org>
> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> ---
>  drivers/scsi/esp_scsi.c | 3 +++
>  drivers/scsi/mac_esp.c  | 2 --
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index bb88995a12c7..afbef83f5dd9 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2835,6 +2835,9 @@ void esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
>  	cmd &= ~ESP_CMD_DMA;
>  	esp->send_cmd_error = 0;
>
> +	esp_write8(0, ESP_TCLOW);
> +	esp_write8(0, ESP_TCMED);
> +
>  	if (write) {
>  		u8 *dst = (u8 *)addr;
>  		u8 mask = ~(phase == ESP_MIP ? ESP_INTR_FDONE : ESP_INTR_BSERV);
> diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
> index 1c78bc10c790..797579247e47 100644
> --- a/drivers/scsi/mac_esp.c
> +++ b/drivers/scsi/mac_esp.c
> @@ -361,8 +361,6 @@ static int esp_mac_probe(struct platform_device *dev)
>  	esp->flags = ESP_FLAG_NO_DMA_MAP;
>  	if (mep->pdma_io == NULL) {
>  		printk(KERN_INFO PFX "using PIO for controller %d\n", dev->id);
> -		esp_write8(0, ESP_TCLOW);
> -		esp_write8(0, ESP_TCMED);
>  		esp->flags |= ESP_FLAG_DISABLE_SYNC;
>  		mac_esp_ops.send_dma_cmd = esp_send_pio_cmd;
>  	} else {
>
