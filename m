Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63E01CF8A
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2024 06:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717999818; cv=none; b=QytmgMK1gpyefAREmcjp+IDlivg0cX3rC2xYpRWdfOjtJ3LmQlELJjbtz1nxPt8ougUieNqb8HYcUjsfKLzp173qBZYm04LcFdBZQIfXn9xkHPBUYGJ5sobO1H3dIHz7HIj9UO4nrcmlUqunMDRKuQN9Hkvr7UnawIvqsJSzbgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717999818; c=relaxed/simple;
	bh=+DzG+bydVH+wbKVxr/TK8el6RmfDThXhYLgEf0inddA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kp3W6LdX+brsIbonMJE0yKt2ySdlc99jkhx0eH5wymf9RJFGihB3wbSo9Z4hjdj/FjVwgIwFV8DD+X76yZIBO3zFae48dS5/t6cRZJMQtJJohZfTAjVney4k4Yw7jbkd/W7egNvJBIFEgDn2iPHZGYDOR+jKRo9AT++jr3EXNnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YK6+9dEN; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YK6+9dEN"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-57c76497cefso1200566a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 09 Jun 2024 23:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717999813; x=1718604613; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IJs6GrDBKE+1ux08sur8X57W+usxmZyYiCgID0s64mw=;
        b=YK6+9dEN7yyXHhLY1wsd8QOD7CWUMsJapNzf+pYDiz1MXVcDs2869xh1+6FIh1mwkx
         IhDZsgtoiVYA4+P0cDoRTLf08AelTDzkjnEr/Khd/LDLDSPyF+pOC8Uy9pqL9+ypJOo4
         Xx9yzTVd/yHtjyi0qxJKeOsWioZ+jSxPmdzF7SeGZXumuL7bFubgargbDUedXqmCtKL+
         SuLagQESAiCNQPQ8X4/cuGT/cNgrIvMz79E6THyDHtzWtRV8ZtSBMKePQuvaPmHdmIV8
         yd9reyhR2E6mySwORF0kGlbEReN/WcnF2pByWeGiy6/yDCxzPMtlRyzVO0ToAq6UCTzH
         d7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717999813; x=1718604613;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IJs6GrDBKE+1ux08sur8X57W+usxmZyYiCgID0s64mw=;
        b=B5EEkS6DX8Phsy8KgjH3BLmdQERWzGce9SOhX+z3Hv9RCtb3lILU3qhi+LX+Cunz2Y
         DFsMqK6dk8aQebTFz10fCChGfXWamva1Se65bszwAoZ8VPf4VXC+5BCntFCBX24lZ6XW
         q2DScSdvQFgd7kr9Ypev8tqHpj0jFz3zcz5ebks3vPF7ezIi8as8PVGwVKwK04sRZf5P
         qULT264otcJs6ZNeHNRs9ymnQr9qW9pDPTILtiL37xsKhuqCSEckuYK6xAEOnLJ8iNte
         dgb/00A+9jilTFJ4pwSnX6cdEEhzxxLdBPa9iPPqJD4Myun3EPE9Bs8slg8J1iLqUwcr
         UCFQ==
X-Gm-Message-State: AOJu0YzxjYTRsA2nlLjDS12HKf7GiTkUg91oKECY3afhP8mohfOeZ+dH
	xFklp4a2O9mnrcvdVPgE7Ej9PQdiBaXcFNto715glVZ/BBtQC25gmzQmhAadkG6ctFX3qzuF19b
	s0o8=
X-Google-Smtp-Source: AGHT+IGomYFs8EnqAgqMWqaoEOaLRwdyPRO07bdaNNFnYXcNU/XKjsw7LimjdBuLKSXI2liXwKBCQw==
X-Received: by 2002:a50:a68f:0:b0:57a:2fe7:6699 with SMTP id 4fb4d7f45d1cf-57c508ee85bmr4966515a12.14.1717999813166;
        Sun, 09 Jun 2024 23:10:13 -0700 (PDT)
Received: from ?IPV6:2001:a61:2af3:b401:94f2:dbdc:f338:d51c? ([2001:a61:2af3:b401:94f2:dbdc:f338:d51c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57aae20234csm6823890a12.65.2024.06.09.23.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jun 2024 23:10:12 -0700 (PDT)
Message-ID: <58217b4a-d731-4bc2-b625-9a5f0b9b17c0@suse.com>
Date: Mon, 10 Jun 2024 08:10:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: add missing MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Jeff Johnson <quic_jjohnson@quicinc.com>,
 Khalid Aziz <khalid@gonehiking.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Finn Thain <fthain@linux-m68k.org>,
 Michael Schmitz <schmitzmic@gmail.com>,
 James Smart <james.smart@broadcom.com>,
 Ram Vegesna <ram.vegesna@broadcom.com>,
 Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
 "Juergen E. Fischer" <fischer@norbit.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20240608-md-drivers-scsi-v2-1-d00d652e5d34@quicinc.com>
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20240608-md-drivers-scsi-v2-1-d00d652e5d34@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/8/24 17:33, Jeff Johnson wrote:
> On x86, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/scsi_common.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/advansys.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/BusLogic.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/aha1740.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/isci/isci.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/elx/efct.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/atp870u.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/ppa.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/imm.o
> 
> Add all missing invocations of the MODULE_DESCRIPTION() macro.
> 
> This updates all files which have a MODULE_LICENSE() but which do not
> have a MODULE_DESCRIPTION(), even ones which did not produce the x86
> allmodconfig warnings.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
> Changes in v2:
> - Updated descriptions of atari_scsi.c, g_NCR5380.c, mac_scsi.c per Finn Thain
>    & Michael Schmitz
> - Removed unnecessary modifications to initio.c and sr.c
> - Link to v1: https://lore.kernel.org/r/20240607-md-drivers-scsi-v1-1-17ae31cc4fe5@quicinc.com
> ---
>   drivers/scsi/BusLogic.c             | 1 +
>   drivers/scsi/advansys.c             | 1 +
>   drivers/scsi/aha1542.c              | 1 +
>   drivers/scsi/aha1740.c              | 1 +
>   drivers/scsi/atari_scsi.c           | 1 +
>   drivers/scsi/atp870u.c              | 1 +
>   drivers/scsi/elx/efct/efct_driver.c | 1 +
>   drivers/scsi/g_NCR5380.c            | 1 +
>   drivers/scsi/imm.c                  | 1 +
>   drivers/scsi/isci/init.c            | 1 +
>   drivers/scsi/mac_scsi.c             | 1 +
>   drivers/scsi/pcmcia/aha152x_stub.c  | 1 +
>   drivers/scsi/ppa.c                  | 1 +
>   drivers/scsi/scsi_common.c          | 1 +
>   drivers/scsi/sun3_scsi.c            | 1 +
>   15 files changed, 15 insertions(+)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 72ceaf650b0d..2135a2b3e2d0 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -78,6 +78,7 @@ static struct blogic_drvr_options blogic_drvr_options[BLOGIC_MAX_ADAPTERS];
>     BusLogic can be assigned a string by insmod.
>   */
>   
> +MODULE_DESCRIPTION("BusLogic MultiMaster and FlashPoint SCSI Host Adapter driver");
>   MODULE_LICENSE("GPL");
>   #ifdef MODULE
>   static char *BusLogic;
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index ab066bb27a57..fd4fcb37863d 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -11545,6 +11545,7 @@ static void __exit advansys_exit(void)
>   module_init(advansys_init);
>   module_exit(advansys_exit);
>   
> +MODULE_DESCRIPTION("AdvanSys SCSI Adapter driver");
>   MODULE_LICENSE("GPL");
>   MODULE_FIRMWARE("advansys/mcode.bin");
>   MODULE_FIRMWARE("advansys/3550.bin");
> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> index 9503996c6325..add10098a569 100644
> --- a/drivers/scsi/aha1542.c
> +++ b/drivers/scsi/aha1542.c
> @@ -1009,6 +1009,7 @@ static int aha1542_biosparam(struct scsi_device *sdev,
>   
>   	return 0;
>   }
> +MODULE_DESCRIPTION("Adaptec AHA-1542 SCSI host adapter driver");
>   MODULE_LICENSE("GPL");

Please add a newline before the MODULE_DESCRIPTION line.

>   
>   static int aha1542_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
> index 3d18945abaf7..be7ebbbb9ba8 100644
> --- a/drivers/scsi/aha1740.c
> +++ b/drivers/scsi/aha1740.c
> @@ -681,4 +681,5 @@ static __exit void aha1740_exit (void)
>   module_init (aha1740_init);
>   module_exit (aha1740_exit);
>   
> +MODULE_DESCRIPTION("Adaptec AHA1740 SCSI host adapter driver");
>   MODULE_LICENSE("GPL");
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index 742625ac7d99..98a1b966a0b0 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -894,4 +894,5 @@ static struct platform_driver atari_scsi_driver __refdata = {
>   module_platform_driver_probe(atari_scsi_driver, atari_scsi_probe);
>   
>   MODULE_ALIAS("platform:" DRV_MODULE_NAME);
> +MODULE_DESCRIPTION("Atari TT/Falcon NCR5380 SCSI driver");
>   MODULE_LICENSE("GPL");
> diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
> index 2a748af269c2..3f006b2f39a6 100644
> --- a/drivers/scsi/atp870u.c
> +++ b/drivers/scsi/atp870u.c
> @@ -1724,6 +1724,7 @@ static void atp870u_remove (struct pci_dev *pdev)
>   	atp870u_free_tables(pshost);
>   	scsi_host_put(pshost);
>   }
> +MODULE_DESCRIPTION("ACARD SCSI host adapter driver");
>   MODULE_LICENSE("GPL");

Again, missing newline.

>   
>   static const struct scsi_host_template atp870u_template = {
> diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
> index 49fd2cfed70c..55d2301bfd7d 100644
> --- a/drivers/scsi/elx/efct/efct_driver.c
> +++ b/drivers/scsi/elx/efct/efct_driver.c
> @@ -778,5 +778,6 @@ static void __exit efct_exit(void)
>   module_init(efct_init);
>   module_exit(efct_exit);
>   MODULE_VERSION(EFCT_DRIVER_VERSION);
> +MODULE_DESCRIPTION("Emulex Fibre Channel Target driver");
>   MODULE_LICENSE("GPL");
>   MODULE_AUTHOR("Broadcom");
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index f6305e3e60f4..270eae7ac427 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -110,6 +110,7 @@ module_param_array(card, int, NULL, 0);
>   MODULE_PARM_DESC(card, "card type (0=NCR5380, 1=NCR53C400, 2=NCR53C400A, 3=DTC3181E, 4=HP C2502)");
>   
>   MODULE_ALIAS("g_NCR5380_mmio");
> +MODULE_DESCRIPTION("Generic NCR5380/NCR53C400 SCSI driver");
>   MODULE_LICENSE("GPL");
>   
>   static void g_NCR5380_trigger_irq(struct Scsi_Host *instance)
> diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
> index 21339da505f1..6e779bb14d98 100644
> --- a/drivers/scsi/imm.c
> +++ b/drivers/scsi/imm.c
> @@ -1279,4 +1279,5 @@ static struct parport_driver imm_driver = {
>   };
>   module_parport_driver(imm_driver);
>   
> +MODULE_DESCRIPTION("IOMEGA MatchMaker parallel port SCSI host adapter driver");
>   MODULE_LICENSE("GPL");
> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
> index de2aefcf2089..d31884f82f2a 100644
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -758,6 +758,7 @@ static __exit void isci_exit(void)
>   	sas_release_transport(isci_transport_template);
>   }
>   
> +MODULE_DESCRIPTION("Intel(R) C600 Series Chipset SAS Controller driver");
>   MODULE_LICENSE("Dual BSD/GPL");
>   MODULE_FIRMWARE(ISCI_FW_NAME);
>   module_init(isci_init);
> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
> index a402c4dc4645..53ee8f84d094 100644
> --- a/drivers/scsi/mac_scsi.c
> +++ b/drivers/scsi/mac_scsi.c
> @@ -550,4 +550,5 @@ static struct platform_driver mac_scsi_driver __refdata = {
>   module_platform_driver_probe(mac_scsi_driver, mac_scsi_probe);
>   
>   MODULE_ALIAS("platform:" DRV_MODULE_NAME);
> +MODULE_DESCRIPTION("Macintosh NCR5380 SCSI driver");
>   MODULE_LICENSE("GPL");
> diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
> index 6a6621728c69..1b54ba51a485 100644
> --- a/drivers/scsi/pcmcia/aha152x_stub.c
> +++ b/drivers/scsi/pcmcia/aha152x_stub.c
> @@ -75,6 +75,7 @@ module_param(synchronous, int, 0);
>   module_param(reset_delay, int, 0);
>   module_param(ext_trans, int, 0);
>   
> +MODULE_DESCRIPTION("Adaptec AHA152X-compatible PCMCIA SCSI card driver");
>   MODULE_LICENSE("Dual MPL/GPL");
>   
>   /*====================================================================*/
> diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
> index 8300f0bdddb3..2d9fcc45ad85 100644
> --- a/drivers/scsi/ppa.c
> +++ b/drivers/scsi/ppa.c
> @@ -1155,4 +1155,5 @@ static struct parport_driver ppa_driver = {
>   };
>   module_parport_driver(ppa_driver);
>   
> +MODULE_DESCRIPTION("IOMEGA PPA3 parallel port SCSI host adapter driver");
>   MODULE_LICENSE("GPL");
> diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
> index 9c14fdf61037..04749fde1636 100644
> --- a/drivers/scsi/scsi_common.c
> +++ b/drivers/scsi/scsi_common.c
> @@ -12,6 +12,7 @@
>   #include <asm/unaligned.h>
>   #include <scsi/scsi_common.h>
>   
> +MODULE_DESCRIPTION("SCSI functions used by both the initiator and the target code");
>   MODULE_LICENSE("GPL v2");
>   
>   /* Command group 3 is reserved and should never be used.  */
> diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
> index 4a8cc2e8238e..f51702893306 100644
> --- a/drivers/scsi/sun3_scsi.c
> +++ b/drivers/scsi/sun3_scsi.c
> @@ -666,4 +666,5 @@ static struct platform_driver sun3_scsi_driver = {
>   module_platform_driver_probe(sun3_scsi_driver, sun3_scsi_probe);
>   
>   MODULE_ALIAS("platform:" DRV_MODULE_NAME);
> +MODULE_DESCRIPTION("Sun3 NCR5380 SCSI controller driver");
>   MODULE_LICENSE("GPL");
> 
> ---
> base-commit: 19ca0d8a433ff37018f9429f7e7739e9f3d3d2b4
> change-id: 20240607-md-drivers-scsi-e3364073e9b9
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

