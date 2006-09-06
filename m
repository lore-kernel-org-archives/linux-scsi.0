From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] aic94xx: Widens the Range of Recognized FLASH Manufactures
Date: Tue, 5 Sep 2006 23:24:38 -0700 (PDT)
Message-ID: <20060906062438.72183.qmail@web31810.mail.mud.yahoo.com>
References: <1157473228.7906.13.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:33666 "HELO
	web31810.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751197AbWIFGYm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Sep 2006 02:24:42 -0400
In-Reply-To: <1157473228.7906.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi@vger.kernel.org

Flash part discovery and interfacing can be *generalized*
in all of the following ways:
        a) by flash part manufacturer, and
        b) by flash part interface (8 or 8/16 bit), and
        c) by how the flash part is connected to the chip.
In other words, there exists flash part discovery and interface code
which is flash part manufacturer agnostic, 8/16 bit part agnostic
and connection agnostic.

For the aic94xx you may not need such an enterprise level solution,
(since you'd need to know intricate details about the HW design),
but you can _still generalize per sequence_, in which case you'd
not need to know anything about the manufacturer of the flash part.
That is, you can at least generalize by manufacturer, so that
you wouldn't need the switch() { case ...} statements at all.


--- Alexis Bruemmer <alexisb@us.ibm.com> wrote:

> The 94xx controller is now being shipped with a wider range of FLASH
> chip manufactures, this patch simply allows the aic94xx driver to
> recognize the new manufacturers ids.
> 
> 
> --Alexis
> 
> 
> 
> Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
> 
> ----
> 
> diff -aNurp linux-2.6.18-rc5-aic94xx-orig/drivers/scsi/aic94xx/aic94xx_sds.c
> linux-2.6.18-rc5-aic94xx-new/drivers/scsi/aic94xx/aic94xx_sds.c
> --- linux-2.6.18-rc5-aic94xx-orig/drivers/scsi/aic94xx/aic94xx_sds.c	2006-08-28
> 14:29:30.000000000 -0700
> +++ linux-2.6.18-rc5-aic94xx-new/drivers/scsi/aic94xx/aic94xx_sds.c	2006-09-05
> 09:11:34.000000000 -0700
> @@ -376,7 +376,10 @@ out:
>  /* ---------- FLASH stuff ---------- */
>  
>  #define FLASH_RESET			0xF0
> -#define FLASH_MANUF_AMD                 1
> +#define FLASH_MANUF_AMD			0x01
> +#define FLASH_MANUF_ST			0x20
> +#define FLASH_MANUF_FUJITSU		0x04
> +#define FLASH_MANUF_MACRONIX		0xC2
>  
>  #define FLASH_SIZE                      0x200000
>  #define FLASH_DIR_COOKIE                "*** ADAPTEC FLASH DIRECTORY *** "
> @@ -663,7 +666,11 @@ static int asd_flash_getid(struct asd_ha
>  	/* Get out of autoselect mode. */
>  	err = asd_reset_flash(asd_ha);
>  
> -	if (asd_ha->hw_prof.flash.manuf == FLASH_MANUF_AMD) {
> +	switch(asd_ha->hw_prof.flash.manuf) {
> +	case FLASH_MANUF_AMD:
> +	case FLASH_MANUF_ST:
> +	case FLASH_MANUF_FUJITSU:
> +	case FLASH_MANUF_MACRONIX:
>  		ASD_DPRINTK("0Found FLASH(%d) manuf:%d, dev_id:0x%x, "
>  			    "sec_prot:%d\n",
>  			    asd_ha->hw_prof.flash.wide ? 16 : 8,
> @@ -671,6 +678,9 @@ static int asd_flash_getid(struct asd_ha
>  			    asd_ha->hw_prof.flash.dev_id,
>  			    asd_ha->hw_prof.flash.sec_prot);
>  		return 0;
> +	default:
> +		break;
> +
>  	}
>  
>  	/* Ok, try the sequence for byte mode of 160B and 800D.
> @@ -684,7 +694,11 @@ static int asd_flash_getid(struct asd_ha
>  	asd_ha->hw_prof.flash.sec_prot = asd_read_reg_byte(asd_ha, reg + 4);
>  	err = asd_reset_flash(asd_ha);
>  
> -	if (asd_ha->hw_prof.flash.manuf == FLASH_MANUF_AMD) {
> +	switch(asd_ha->hw_prof.flash.manuf) {
> +	case FLASH_MANUF_AMD:
> +	case FLASH_MANUF_ST:
> +	case FLASH_MANUF_FUJITSU:
> +	case FLASH_MANUF_MACRONIX:
>  		ASD_DPRINTK("1Found FLASH(%d) manuf:%d, dev_id:0x%x, "
>  			    "sec_prot:%d\n",
>  			    asd_ha->hw_prof.flash.wide ? 16 : 8,
> @@ -692,8 +706,12 @@ static int asd_flash_getid(struct asd_ha
>  			    asd_ha->hw_prof.flash.dev_id,
>  			    asd_ha->hw_prof.flash.sec_prot);
>  		return 0;
> +	default:
> +		break;
> +
>  	}
>  
> +
>  	return -ENOENT;
>  }

