Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEF4C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 05:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKIFSP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 00:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKIFSO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 00:18:14 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772B71B9C4
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 21:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667971093; x=1699507093;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bKwahzj5F8dCN41hLqT1grBgs7ObhamPlJF/pDlUBI0=;
  b=cBdEND3vouBPOe2pY3EO8GmkYY1EurUsS1V+FpKOriBastjevwEBiK2Q
   4IcDRg5pLzjeyEwpZQrb89+JGT8K2TOPyvTMkVgDWSYxmoQzRqFI7mHPu
   Meyjn+hewkcK5UssoYxnFEb7bWyiCEqa1rqcuNKhWmlqUXI8c1vPVsXk5
   +tnmJjLf+xtpBiiH8B4ehpP1xo5oab8wpfuFAapkJnHDw6NG70pmNJsbf
   4g4Gev12fZPc9JwUxQqN/K/4Z1aNwsfL4bWWAN4diE/FalBEXXv4KP+Tk
   HYd35LwPDmUZsM3NrS6Vubpg1b8nkZsXORQsnQq+DH21rgQdid6p0z946
   w==;
X-IronPort-AV: E=Sophos;i="5.96,149,1665417600"; 
   d="scan'208";a="320165009"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2022 13:18:12 +0800
IronPort-SDR: ZP8x7dwzIoNR3r1jQSK4Kan3kXbdp3atzX0HE7kYz7RWqTkV4ZvtC3n6FL/gH4064b8gzNtrUP
 uD3scvFr19LI+OaGn3hzQ7wuhmP6kY/gbKkl2BEiv74246uWODr2aR29arvr8ENIw8T/6SoWYC
 ls6LRxGBtQ1uDJmjn6HVJVzEH4y6mNz9ZwRSRoarrKKbyqI50kxWWzv6wT733tsRVeX7QQgLew
 /SDW93u1aHkHWAAVUgLPBDu3Hf29roFhrdtWqOtncG9aFQIZm6jnJ2x2BSBrC99Uy1IS3oTEh3
 XOU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 20:31:33 -0800
IronPort-SDR: Ok0uEZL0GBeFUxKtZ/ahKa0IUDdbO8RYhgBgkayekyzg1FwqJNFBgbGAXMya44DRAHr9qFAAHt
 UpbXqEpj00SPeVz5MrGHBJNTi2tdFLgEUu/u7xYkiBPD49wLIGu5B83nmwf+z6xlACH8re97Go
 yEjY+qHP2KyySTEH0wf0bFxmXp4ypQ1+WmkUAkghRa6nnJqxKQTgIYk2WmK1Bk0GJueFPotoBf
 DHcufF1nPLWooyuaHAo7sf0DrxrTeZV2ewybaab6Gm1I5JkG84Ge7ZAuMaT2CbjCI1sYefQiXW
 YJg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 21:18:14 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4N6YC85YKLz1RvTp
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 21:18:12 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1667971092; x=1670563093; bh=bKwahzj5F8dCN41hLqT1grBgs7ObhamPlJF
        /pDlUBI0=; b=uLdgUZ98j3NMiCA3StmqrDFfN5zF4KO/6lPQFZKoU57lfrFZe7q
        2qumQEtbuqhw1jgU8oKP6nPZAZLbQjg4BWp5ysozCl6L8Uh8+ol+LVugA1UlCvax
        l8+CbG7cVeHe1qyPIyG0Of8rxhrrwhJatV875tpN/i08fhVs5JU7uIyt/PWyvbpf
        L+DM8uKH5skrfas8/Isi+0ri7CL21vHpEnDMc4Ow4vaav7IVDZxsfDGXFo3peNnu
        QtdArnIz7z88keUmda6o/rhaKFOEUuriTR/q0DP9O8E4f97k3Tq5hVsxHJn42XcL
        Y2qhvU1YdRS3gn8TLWPWrRuAUviyHw4uyRg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id svKLKdf3OAYT for <linux-scsi@vger.kernel.org>;
        Tue,  8 Nov 2022 21:18:12 -0800 (PST)
Received: from [10.225.163.37] (unknown [10.225.163.37])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4N6YC75XxYz1RvLy;
        Tue,  8 Nov 2022 21:18:11 -0800 (PST)
Message-ID: <5047a206-644d-553a-fa56-511f1308efb1@opensource.wdc.com>
Date:   Wed, 9 Nov 2022 14:18:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 2/2] scsi: sd: enforce SYNCHRONIZE CACHE (16) on
 host-managed devices
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
References: <20221109025941.1594612-1-shinichiro.kawasaki@wdc.com>
 <20221109025941.1594612-3-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221109025941.1594612-3-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 11:59, Shin'ichiro Kawasaki wrote:
> ZBC Zoned Block Commands specification mandates SYNCHRONIZE CACHE (16)
> for host-managed zoned block devices, but does not mandate SYNCHRONIZE
> CACHE (10). Call SYNCHRONIZE CACHE (16) in place of SYNCHRONIZE CACHE
> (10) to ensure that the command is always supported. For this purpose,
> add use_16_for_sync flag to struct scsi_device in same manner as
> use_16_for_rw flag.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/scsi/sd.c          | 16 ++++++++++++----
>  drivers/scsi/sd_zbc.c      |  3 ++-
>  include/scsi/scsi_device.h |  1 +
>  3 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index eb76ba055021..faa2b55d1a21 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1026,8 +1026,13 @@ static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
>  	/* flush requests don't perform I/O, zero the S/G table */
>  	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
>  
> -	cmd->cmnd[0] = SYNCHRONIZE_CACHE;
> -	cmd->cmd_len = 10;
> +	if (cmd->device->use_16_for_sync) {
> +		cmd->cmnd[0] = SYNCHRONIZE_CACHE_16;
> +		cmd->cmd_len = 16;
> +	} else {
> +		cmd->cmnd[0] = SYNCHRONIZE_CACHE;
> +		cmd->cmd_len = 10;
> +	}
>  	cmd->transfersize = 0;
>  	cmd->allowed = sdkp->max_retries;
>  
> @@ -1587,9 +1592,12 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
>  		sshdr = &my_sshdr;
>  
>  	for (retries = 3; retries > 0; --retries) {
> -		unsigned char cmd[10] = { 0 };
> +		unsigned char cmd[16] = { 0 };
>  
> -		cmd[0] = SYNCHRONIZE_CACHE;
> +		if (sdp->use_16_for_sync)
> +			cmd[0] = SYNCHRONIZE_CACHE_16;
> +		else
> +			cmd[0] = SYNCHRONIZE_CACHE;
>  		/*
>  		 * Leave the rest of the command zero to indicate
>  		 * flush everything.
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 4717a55dbf35..a998f9c091dd 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -921,10 +921,11 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
>  		return 0;
>  	}
>  
> -	/* READ16/WRITE16 is mandatory for host-managed devices */
> +	/* READ16/WRITE16/SYNC16 is mandatory for host-managed devices */
>  	if (sdkp->device->type == TYPE_ZBC) {
>  		sdkp->device->use_16_for_rw = 1;
>  		sdkp->device->use_10_for_rw = 0;
> +		sdkp->device->use_16_for_sync = 1;
>  	}
>  
>  	if (!blk_queue_is_zoned(q)) {
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index c36656d8ac6c..afd2986007a4 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -184,6 +184,7 @@ struct scsi_device {
>  	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
>  	unsigned no_write_same:1;	/* no WRITE SAME command */
>  	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */
> +	unsigned use_16_for_sync:1;	/* Use sync (16) over sync (10) */
>  	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
>  	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
>  	unsigned skip_vpd_pages:1;	/* do not read VPD pages */

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

