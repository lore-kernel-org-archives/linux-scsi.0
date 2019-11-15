Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA69C43141
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 02:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90796206F4
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 02:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfKOCJq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 21:09:46 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34742 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfKOCJp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 21:09:45 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 709662A6F6;
        Thu, 14 Nov 2019 21:09:42 -0500 (EST)
Date:   Fri, 15 Nov 2019 13:09:37 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Kars de Jong <jongk@linux-m68k.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        linux-m68k@vger.kernel.org, schmitzmic@gmail.com
Subject: Re: [PATCH v3 2/2] esp_scsi: Add support for FSC chip
In-Reply-To: <20191114222518.2441-3-jongk@linux-m68k.org>
Message-ID: <alpine.LNX.2.21.1.1911151212001.9@nippy.intranet>
References: <20191114215956.21767-1-jongk@linux-m68k.org> <20191114222518.2441-1-jongk@linux-m68k.org> <20191114222518.2441-3-jongk@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Thu, 14 Nov 2019, Kars de Jong wrote:

> The FSC (NCR53CF9x-2 / SYM53CF9x-2) has a different family code than QLogic
> or Emulex parts. This caused it to be detected as a FAS100A.
> 
> Unforunately, this meant the configuration of the CONFIG3 register was
> incorrect. This causes data transfer issues with FAST-SCSI targets.
> 
> The FSC also has the CONFIG4 register. It can be used to enable a feature
> called Active Negation which should always be enabled according to the data
> manual.
> 
> Signed-off-by: Kars de Jong <jongk@linux-m68k.org>

Reviewed-by: Finn Thain <fthain@telegraphics.com.au>

A few observations follow. Not a NAK, just FYI...

> ---
>  drivers/scsi/esp_scsi.c | 19 ++++++++++++-------
>  drivers/scsi/esp_scsi.h | 24 ++++++++++++++++--------
>  2 files changed, 28 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 4fc3eee3138b..e887ea3e514a 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -243,7 +243,7 @@ static void esp_set_all_config3(struct esp *esp, u8 val)
>  /* Reset the ESP chip, _not_ the SCSI bus. */
>  static void esp_reset_esp(struct esp *esp)
>  {
> -	u8 family_code, version;
> +	u8 family_code;
>  

This is not the best scope for this variable. You have to touch both lines 
(declaration and initialization) anyway, so you can easily improve this.

>  	/* Now reset the ESP chip */
>  	scsi_esp_cmd(esp, ESP_CMD_RC);
> @@ -257,13 +257,16 @@ static void esp_reset_esp(struct esp *esp)
>  	 */
>  	esp->max_period = ((35 * esp->ccycle) / 1000);
>  	if (esp->rev == FAST) {
> -		version = esp_read8(ESP_UID);
> -		family_code = (version & 0xf8) >> 3;
> -		if (family_code == 0x02)
> +		family_code = ESP_FAMILY(esp_read8(ESP_UID));
> +		if (family_code == ESP_UID_F236)
>  			esp->rev = FAS236;
> -		else if (family_code == 0x0a)
> +		else if (family_code == ESP_UID_HME)
>  			esp->rev = FASHME; /* Version is usually '5'. */
> -		else
> +		else if (family_code == ESP_UID_FSC) {
> +			esp->rev = FSC;
> +			/* Enable Active Negation */
> +			esp_write8(ESP_CONFIG4_RADE, ESP_CFG4);
> +		} else
>  			esp->rev = FAS100A;
>  		esp->min_period = ((4 * esp->ccycle) / 1000);
>  	} else {
> @@ -308,7 +311,8 @@ static void esp_reset_esp(struct esp *esp)
>  
>  	case FAS236:
>  	case PCSCSI:
> -		/* Fast 236, AM53c974 or HME */
> +	case FSC:
> +		/* Fast 236, AM53c974, FSC or HME */

This comment merely re-states the logic in the case labels. If you don't 
delete the comment, it has to be maintained along with the case labels. 
Consequently this patch is longer than it needs to be.

>  		esp_write8(esp->config2, ESP_CFG2);
>  		if (esp->rev == FASHME) {
>  			u8 cfg3 = esp->target[0].esp_config3;
> @@ -2374,6 +2378,7 @@ static const char *esp_chip_names[] = {
>  	"ESP236",
>  	"FAS236",
>  	"AM53C974",
> +	"FSC",
>  	"FAS100A",
>  	"FAST",
>  	"FASHME",
> diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
> index f764d64e1f25..a673dec1b8a1 100644
> --- a/drivers/scsi/esp_scsi.h
> +++ b/drivers/scsi/esp_scsi.h
> @@ -78,12 +78,14 @@
>  #define ESP_CONFIG3_IMS       0x80     /* ID msg chk'ng        (esp/fas236)  */
>  #define ESP_CONFIG3_OBPUSH    0x80     /* Push odd-byte to dma (hme)         */
>  
> -/* ESP config register 4 read-write, found only on am53c974 chips */
> -#define ESP_CONFIG4_RADE      0x04     /* Active negation */
> -#define ESP_CONFIG4_RAE       0x08     /* Active negation on REQ and ACK */
> -#define ESP_CONFIG4_PWD       0x20     /* Reduced power feature */
> -#define ESP_CONFIG4_GE0       0x40     /* Glitch eater bit 0 */
> -#define ESP_CONFIG4_GE1       0x80     /* Glitch eater bit 1 */
> +/* ESP config register 4 read-write, found on am53c974 and FSC chips */
> +#define ESP_CONFIG4_BBTE      0x01     /* Back-to-back transfers     (fsc)   */
> +#define ESP_CONGIG4_TEST      0x02     /* Transfer counter test mode (fsc)   */
> +#define ESP_CONFIG4_RADE      0x04     /* Active negation   (am53c974/fsc)   */
> +#define ESP_CONFIG4_RAE       0x08     /* Act. negation REQ/ACK (am53c974)   */
> +#define ESP_CONFIG4_PWD       0x20     /* Reduced power feature (am53c974)   */
> +#define ESP_CONFIG4_GE0       0x40     /* Glitch eater bit 0    (am53c974)   */
> +#define ESP_CONFIG4_GE1       0x80     /* Glitch eater bit 1    (am53c974)   */
>  

You've added "(FSC)" and "(am53c974)" here, which is fine but you've 
repeated yourself in the comment, "found on am53c974 and FSC chips". The 
DRY principle applies here too (Don't Repeat Yourself).

>  #define ESP_CONFIG_GE_12NS    (0)
>  #define ESP_CONFIG_GE_25NS    (ESP_CONFIG_GE1)
> @@ -209,10 +211,15 @@
>  #define ESP_TEST_TS           0x04     /* Tristate test mode */
>  
>  /* ESP unique ID register read-only, found on fas236+fas100a only */
> +#define ESP_UID_FAM           0xf8     /* ESP family bitmask */
> +
> +#define ESP_FAMILY(uid) (((uid) & ESP_UID_FAM) >> 3)
> +
> +/* Values for the ESP family bits */
>  #define ESP_UID_F100A         0x00     /* ESP FAS100A  */
>  #define ESP_UID_F236          0x02     /* ESP FAS236   */
> -#define ESP_UID_REV           0x07     /* ESP revision */
> -#define ESP_UID_FAM           0xf8     /* ESP family   */
> +#define ESP_UID_HME           0x0a     /* FAS HME      */
> +#define ESP_UID_FSC           0x14     /* NCR/Symbios Logic FSC */
>  
>  /* ESP fifo flags register read-only */
>  /* Note that the following implies a 16 byte FIFO on the ESP. */
> @@ -264,6 +271,7 @@ enum esp_rev {
>  	ESP236,
>  	FAS236,
>  	PCSCSI,  /* AM53c974 */
> +	FSC,     /* NCR/Symbios Logic FSC */

Is there a difference between "FSC" and "NCR/Symbios Logic FSC"? The 
reader has to infer that not all "FSC" chips are equivalent and that the 
brand name is significant. Whereas, there is real value in putting a part 
code here (as in the line above).

-- 

>  	FAS100A,
>  	FAST,
>  	FASHME,
> 
