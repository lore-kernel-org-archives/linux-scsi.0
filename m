Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F22C678DD
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 23:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355977AbjHQXM0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 19:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355978AbjHQXMR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 19:12:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A082D68
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 16:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA5C615CF
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 23:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEF3C433C7;
        Thu, 17 Aug 2023 23:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692313935;
        bh=cqYoc7ZHeW0+uoUozSfKYsXG6rg2WjTCAKYOv8PD2qE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Vtzoy9m8KQIU+StcD/2x1LeyWzigMSgF/RsvBXrxvC8f17Za8Cf4IBX/zN4Jm/PoF
         f6YbM8F4U/voE2loC9ENYKH1+Ig3IZ8EIYjtpcTsS3PhpI96jhy/GcPblHVpRMV1rJ
         SksoCt6YmBThR96XFvKccAFwIIIyOcRePXHgqoU9WTNuJSb34w8AGh36fzckvYNTN+
         PY2tMACxYbKCMh9gFcP3uqrDX0ZGfmLtNnn+JZHDyfbnNpkRh+aun2Hoy3r8KxVxgl
         Int4PfDQpjgr6FirKADMCiPuEzg6wJ0NN9wlS9P25PlXtC3nAr+NJmwxHTxKUMxdIq
         IvaO61O77DZ7g==
Message-ID: <febb997e-fc77-5ac2-0a58-57f66c20b313@kernel.org>
Date:   Fri, 18 Aug 2023 08:12:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH 3/3] scsi: pm80xx: Set RETFIS when requested by libsas
Content-Language: en-US
To:     Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
References: <20230817214137.462044-1-ipylypiv@google.com>
 <20230817214137.462044-3-ipylypiv@google.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230817214137.462044-3-ipylypiv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/08/18 6:41, Igor Pylypiv wrote:
> By default PM80xx HBAs return FIS only when a drive reports an error.

s/FIS/SDB FIS or even better "Set Device Bits (SDB) FIS" to be clear.

> The RETFIS bit forces the controller to populate FIS even when a drive
> reports no error.

And here s/FIS/SDB FIS

> 
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c |  8 +++++---
>  drivers/scsi/pm8001/pm8001_hwi.h |  2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c | 11 ++++++-----
>  drivers/scsi/pm8001/pm80xx_hwi.h |  2 +-
>  4 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 73cd25f30ca5..255553dcadb9 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -4095,7 +4095,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  	u32 hdr_tag, ncg_tag = 0;
>  	u64 phys_addr;
>  	u32 ATAP = 0x0;
> -	u32 dir;
> +	u32 dir, retfis;
>  	u32  opc = OPC_INB_SATA_HOST_OPSTART;
>  
>  	memset(&sata_cmd, 0, sizeof(sata_cmd));
> @@ -4124,8 +4124,10 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  	sata_cmd.tag = cpu_to_le32(tag);
>  	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
>  	sata_cmd.data_len = cpu_to_le32(task->total_xfer_len);
> -	sata_cmd.ncqtag_atap_dir_m =
> -		cpu_to_le32(((ncg_tag & 0xff)<<16)|((ATAP & 0x3f) << 10) | dir);
> +	retfis = task->ata_task.return_fis_on_success;

While I think this should be OK, I think it would be safer to do:

	u32 dir, retfis = 0;

	...

	if (task->ata_task.return_fis_on_success)
		retfis = 1;

to avoid issues with funky compilers doing some tricky handling of single bit
fields.

> +	sata_cmd.retfis_ncqtag_atap_dir_m =
> +		cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
> +				((ATAP & 0x3f) << 10) | dir);

Please align this line with "(retfis << 24)" above.

>  	sata_cmd.sata_fis = task->ata_task.fis;
>  	if (likely(!task->ata_task.device_control_reg_update))
>  		sata_cmd.sata_fis.flags |= 0x80;/* C=1: update ATA cmd reg */
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
> index 961d0465b923..fc2127dcb58d 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.h
> +++ b/drivers/scsi/pm8001/pm8001_hwi.h
> @@ -515,7 +515,7 @@ struct sata_start_req {
>  	__le32	tag;
>  	__le32	device_id;
>  	__le32	data_len;
> -	__le32	ncqtag_atap_dir_m;
> +	__le32	retfis_ncqtag_atap_dir_m;

Naming this field from what is set in it is unusual... Not sure how the
controller spce named this field, but we should use that and stop changing it's
name whenever we change the bits that are set.

>  	struct host_to_dev_fis	sata_fis;
>  	u32	reserved1;
>  	u32	reserved2;
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 39a12ee94a72..e839fb53f0e3 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -4457,7 +4457,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  	u64 phys_addr, end_addr;
>  	u32 end_addr_high, end_addr_low;
>  	u32 ATAP = 0x0;
> -	u32 dir;
> +	u32 dir, retfis;
>  	u32 opc = OPC_INB_SATA_HOST_OPSTART;
>  	memset(&sata_cmd, 0, sizeof(sata_cmd));
>  
> @@ -4487,6 +4487,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  	sata_cmd.tag = cpu_to_le32(tag);
>  	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
>  	sata_cmd.data_len = cpu_to_le32(task->total_xfer_len);
> +	retfis = task->ata_task.return_fis_on_success;
>  
>  	sata_cmd.sata_fis = task->ata_task.fis;
>  	if (likely(!task->ata_task.device_control_reg_update))
> @@ -4502,8 +4503,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  		opc = OPC_INB_SATA_DIF_ENC_IO;
>  
>  		/* set encryption bit */
> -		sata_cmd.ncqtag_atap_dir_m_dad =
> -			cpu_to_le32(((ncg_tag & 0xff)<<16)|
> +		sata_cmd.retfis_ncqtag_atap_dir_m_dad =
> +			cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
>  				((ATAP & 0x3f) << 10) | 0x20 | dir);

Same comments here.

>  							/* dad (bit 0-1) is 0 */
>  		/* fill in PRD (scatter/gather) table, if any */
> @@ -4569,8 +4570,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
>  			   "Sending Normal SATA command 0x%x inb %x\n",
>  			   sata_cmd.sata_fis.command, q_index);
>  		/* dad (bit 0-1) is 0 */
> -		sata_cmd.ncqtag_atap_dir_m_dad =
> -			cpu_to_le32(((ncg_tag & 0xff)<<16) |
> +		sata_cmd.retfis_ncqtag_atap_dir_m_dad =
> +			cpu_to_le32((retfis << 24) | ((ncg_tag & 0xff) << 16) |
>  					((ATAP & 0x3f) << 10) | dir);
>  
>  		/* fill in PRD (scatter/gather) table, if any */
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index acf6e3005b84..eb8fd37b2066 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -731,7 +731,7 @@ struct sata_start_req {
>  	__le32	tag;
>  	__le32	device_id;
>  	__le32	data_len;
> -	__le32	ncqtag_atap_dir_m_dad;
> +	__le32	retfis_ncqtag_atap_dir_m_dad;
>  	struct host_to_dev_fis	sata_fis;
>  	u32	reserved1;
>  	u32	reserved2;	/* dword 11. rsvd for normal I/O. */

-- 
Damien Le Moal
Western Digital Research

