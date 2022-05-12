Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE4AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 23:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359399AbiELXNQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 19:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359384AbiELXNO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 19:13:14 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C9022EA4C
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 16:13:12 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id z126so5945050qkb.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 16:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OvDFCBR6ozIUK82Bb27c6nxi3B6XJLKPaTvHWVZd6VA=;
        b=Cy5E05VYkbdTjoO8mtBO5/abUoUZ8JPbxgpLNoAecBk+B3Nfx5P6AZ3UzBYdGFsxr3
         TqwORbgMIbvLgtkD8jzQxBQ7qseD8EpPrKCUtUWw9ZhjMOqwo8FzNhsOMydI3Zoay/c1
         1vnc79sMrOGT/NKU6LhcPF8eKu3lezzdYjqoSe/ZfWse3MSD5CKt/YvAa0sAlYD2Su/k
         92QfU4lfdjxaO/bcZClIy3hUIzwZWciGEyWv8B0Y/hMS7mF1K13fLG2wkQ8+5TjiQT4s
         w+G33LIFscTRcNUlif3nENd2cfiN1XOXkKywl4+IqhkgR7i+8HCbgFSlKT5MT75LXJ5O
         GyPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OvDFCBR6ozIUK82Bb27c6nxi3B6XJLKPaTvHWVZd6VA=;
        b=SSJQIjInRZdQ0OXZMmTRY2pE+OvC4LImxrrXlzTxlM8OKxeK3RMEIBwv3jxNVgt2JY
         o5bSvNOa4H+oBWYN0pkexDQjF2njHeW107avgeOtpSN3PL9sIbkYQOd58Py3HO6Skzks
         se28FEWoU+Nz0/z4r2mdDSVkXBn0gM5L+PxbYdwxfeg+BAysbS/DffIzyzepH9j1iG0Z
         b/OBI95T7qylt/X8Gb6slwHOMlWw4MwKv6PiyOIlVdoFzkR+fit6bPAK79Ko9cPoiw9R
         stn1n+tMuLv9YfZyT9WitNUDtaM4urG2L0zGXI6ZhEr2gc41En+0Q0pqTFxsnIwxXk5g
         usZw==
X-Gm-Message-State: AOAM533c8Njy/45l/a1peTb33FQbBQVbdenckpusgGNh+vsWsceLMYto
        Pp7J7cE7VAb6Kp0Snd62fwVaM1/U/U6UaA==
X-Google-Smtp-Source: ABdhPJwlYfcKdgN0hcLBmdwa2Vxf1EHY0CNQVX39rTfgmHVvxsCU0phlL0RLu34BxOTmm4yVnHOWsA==
X-Received: by 2002:a05:620a:1a01:b0:69c:fda:7404 with SMTP id bk1-20020a05620a1a0100b0069c0fda7404mr1837829qkb.522.1652397191601;
        Thu, 12 May 2022 16:13:11 -0700 (PDT)
Received: from [10.30.1.34] (sw.attotech.com. [208.69.85.34])
        by smtp.gmail.com with ESMTPSA id h65-20020a376c44000000b0069fc13ce226sm456841qkc.87.2022.05.12.16.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 16:13:11 -0700 (PDT)
Message-ID: <e0b7f888-89fc-6117-fe27-114bcbb3d4cc@gmail.com>
Date:   Thu, 12 May 2022 19:13:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] scsi: lpfc: Add support for ATTO Fibre Channel devices
Content-Language: en-US
To:     linux-scsi@vger.kernel.org
Cc:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Jason Seba <jseba@attotech.com>, bradley.grove@gmail.com
References: <20220512164032.47943-1-bgrove@attotech.com>
From:   "Grove, Bradley" <bradley.grove@gmail.com>
In-Reply-To: <20220512164032.47943-1-bgrove@attotech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


We'd like to withdraw this patch request while we work out an issue on 
our end.

Bradley Grove

On 5/12/2022 12:40 PM, Bradley Grove wrote:
> Update pci_device_id table and generate reporting strings for ATTO
> Celerity and ThunderLink Fibre Channel devices.
> 
> Co-developed-by: Jason Seba <jseba@attotech.com>
> Signed-off-by: Jason Seba <jseba@attotech.com>
> Signed-off-by: Bradley Grove <bgrove@attotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_hw.h   | 22 +++++++++
>   drivers/scsi/lpfc/lpfc_ids.h  | 30 ++++++++++++
>   drivers/scsi/lpfc/lpfc_init.c | 89 +++++++++++++++++++++++++++++++++++
>   3 files changed, 141 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
> index d6050f3c9efe..74a02586fe55 100644
> --- a/drivers/scsi/lpfc/lpfc_hw.h
> +++ b/drivers/scsi/lpfc/lpfc_hw.h
> @@ -1738,6 +1738,28 @@ struct lpfc_fdmi_reg_portattr {
>   #define PCI_DEVICE_ID_TOMCAT        0x0714
>   #define PCI_DEVICE_ID_SKYHAWK       0x0724
>   #define PCI_DEVICE_ID_SKYHAWK_VF    0x072c
> +#define PCI_VENDOR_ID_ATTO          0x117c
> +#define PCI_DEVICE_ID_CLRY_16XE     0x0064
> +#define PCI_DEVICE_ID_CLRY_161E     0x0063
> +#define PCI_DEVICE_ID_CLRY_162E     0x0064
> +#define PCI_DEVICE_ID_CLRY_164E     0x0065
> +#define PCI_DEVICE_ID_CLRY_16XP     0x0094
> +#define PCI_DEVICE_ID_CLRY_161P     0x00a0
> +#define PCI_DEVICE_ID_CLRY_162P     0x0094
> +#define PCI_DEVICE_ID_CLRY_164P     0x00a1
> +#define PCI_DEVICE_ID_CLRY_32XE     0x0094
> +#define PCI_DEVICE_ID_CLRY_321E     0x00a2
> +#define PCI_DEVICE_ID_CLRY_322E     0x00a3
> +#define PCI_DEVICE_ID_CLRY_324E     0x00ac
> +#define PCI_DEVICE_ID_CLRY_32XP     0x00bb
> +#define PCI_DEVICE_ID_CLRY_321P     0x00bc
> +#define PCI_DEVICE_ID_CLRY_322P     0x00bd
> +#define PCI_DEVICE_ID_CLRY_324P     0x00be
> +#define PCI_DEVICE_ID_TLFC_2        0x0064
> +#define PCI_DEVICE_ID_TLFC_2XX2     0x4064
> +#define PCI_DEVICE_ID_TLFC_3        0x0094
> +#define PCI_DEVICE_ID_TLFC_3162     0x40a6
> +#define PCI_DEVICE_ID_TLFC_3322     0x40a7
>   
>   #define JEDEC_ID_ADDRESS            0x0080001c
>   #define FIREFLY_JEDEC_ID            0x1ACC
> diff --git a/drivers/scsi/lpfc/lpfc_ids.h b/drivers/scsi/lpfc/lpfc_ids.h
> index 6a90e6e53d09..a1b9be245560 100644
> --- a/drivers/scsi/lpfc/lpfc_ids.h
> +++ b/drivers/scsi/lpfc/lpfc_ids.h
> @@ -124,5 +124,35 @@ const struct pci_device_id lpfc_id_table[] = {
>   		PCI_ANY_ID, PCI_ANY_ID, },
>   	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK_VF,
>   		PCI_ANY_ID, PCI_ANY_ID, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_16XE,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_161E, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_16XE,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_162E, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_16XE,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_164E, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_16XP,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_161P, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_16XP,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_162P, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_16XP,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_164P, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_32XE,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_321E, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_32XE,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_322E, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_32XE,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_324E, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_32XP,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_321P, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_32XP,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_322P, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_32XP,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_324P, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_TLFC_2,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_TLFC_2XX2, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_TLFC_3,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_TLFC_3162, },
> +	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_TLFC_3,
> +		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_TLFC_3322, },
>   	{ 0 }
>   };
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 461d333b1b3a..45a71ab55be8 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -2408,6 +2408,90 @@ lpfc_parse_vpd(struct lpfc_hba *phba, uint8_t *vpd, int len)
>   	return(1);
>   }
>   
> +/**
> + * lpfc_get_atto_model_desc - Retrieve ATTO HBA device model name and description
> + * @phba: pointer to lpfc hba data structure.
> + * @mdp: pointer to the data structure to hold the derived model name.
> + * @descp: pointer to the data structure to hold the derived description.
> + *
> + * This routine retrieves HBA's description based on its registered PCI device
> + * ID. The @descp passed into this function points to an array of 256 chars. It
> + * shall be returned with the model name, maximum speed, and the host bus type.
> + * The @mdp passed into this function points to an array of 80 chars. When the
> + * function returns, the @mdp will be filled with the model name.
> + **/
> +static void
> +lpfc_get_atto_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
> +{
> +	uint16_t sub_dev_id = phba->pcidev->subsystem_device;
> +	char *model = "<Unknown>";
> +	int tbolt = 0;
> +
> +	switch (sub_dev_id) {
> +	case PCI_DEVICE_ID_CLRY_161E:
> +		model = "161E";
> +		break;
> +	case PCI_DEVICE_ID_CLRY_162E:
> +		model = "162E";
> +		break;
> +	case PCI_DEVICE_ID_CLRY_164E:
> +		model = "164E";
> +		break;
> +	case PCI_DEVICE_ID_CLRY_161P:
> +		model = "161P";
> +		break;
> +	case PCI_DEVICE_ID_CLRY_162P:
> +		model = "162P";
> +		break;
> +	case PCI_DEVICE_ID_CLRY_164P:
> +		model = "164P";
> +		break;
> +	case PCI_DEVICE_ID_CLRY_321E:
> +		model = "321E";
> +		break;
> +	case PCI_DEVICE_ID_CLRY_322E:
> +		model = "322E";
> +		break;
> +	case PCI_DEVICE_ID_CLRY_324E:
> +		model = "324E";
> +		break;
> +	case PCI_DEVICE_ID_CLRY_321P:
> +		model = "321P";
> +		break;
> +	case PCI_DEVICE_ID_CLRY_322P:
> +		model = "322P";
> +		break;
> +	case PCI_DEVICE_ID_CLRY_324P:
> +		model = "324P";
> +		break;
> +	case PCI_DEVICE_ID_TLFC_2XX2:
> +		model = "2XX2";
> +		tbolt = 1;
> +		break;
> +	case PCI_DEVICE_ID_TLFC_3162:
> +		model = "3162";
> +		tbolt = 1;
> +		break;
> +	case PCI_DEVICE_ID_TLFC_3322:
> +		model = "3322";
> +		tbolt = 1;
> +		break;
> +	default:
> +		model = "Unknown";
> +		break;
> +	}
> +
> +	if (mdp && mdp[0] == '\0')
> +		snprintf(mdp, 79, "%s", model);
> +
> +	if (descp && descp[0] == '\0')
> +		snprintf(descp, 255,
> +			 "ATTO %s%s, Fibre Channel Adapter Initiator, Port %s",
> +			 (tbolt) ? "ThunderLink FC " : "Celerity FC-",
> +			 model,
> +			 phba->Port);
> +}
> +
>   /**
>    * lpfc_get_hba_model_desc - Retrieve HBA device model name and description
>    * @phba: pointer to lpfc hba data structure.
> @@ -2438,6 +2522,11 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
>   		&& descp && descp[0] != '\0')
>   		return;
>   
> +	if (phba->pcidev->vendor == PCI_VENDOR_ID_ATTO) {
> +		lpfc_get_atto_model_desc(phba, mdp, descp);
> +		return;
> +	}
> +
>   	if (phba->lmt & LMT_64Gb)
>   		max_speed = 64;
>   	else if (phba->lmt & LMT_32Gb)
