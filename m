Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35708C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 03:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiKJDyC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiKJDyB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 22:54:01 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6088826482
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 19:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668052440; x=1699588440;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1BeReEfDbrsOuR2jrLihBbhHBYsRmeFMbJ0BnBZcw9c=;
  b=fuLFvAIq/YQhmjAX/Tp6hXoInCiondvJ9UMaQ2ZtoPdF2uPHXsbHzK5x
   CqOyCJdpBQcPbI9Vep9sX9eC2ATAI+hxTKCIgA9EGK15TYBDYHeKyy/y8
   3+TD45whc/2oYeXq/ZRSr1HuZZ5rtPGA1Y6JueVwzUGlMyuabgrvUdUtJ
   JkTHijXpNLCZZMNWlmX4dqYvBxjG3rKnEMBY5PnGO1YsXIIJomd+JcZB9
   iMBJRL3ue1hipU4QdBCRLQE2HDyNDZm2ayGYpjEI5mvT6whqzc5xkX9Qd
   +Sw8KP02x3W/5OpydaElFzQH9ddWq1Fq9Cj18mJ/uoOXhS4s/h/OPGpyk
   g==;
X-IronPort-AV: E=Sophos;i="5.96,152,1665417600"; 
   d="scan'208";a="215921006"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2022 11:53:59 +0800
IronPort-SDR: rdwadjP/LmRDgHhaQdnrZuJCgPTnTmNW0Y7UcZUflE+d5HYqtjKCoTSSMHcRHivHWvMC18WrNX
 P/9P06Pg6GMpSpU1hXsRWVfMzQZLCA20NlJQsJInEUQgApqx9KwTmmV3qaVeeT4hbczhtAhdeF
 7KAZ3luCt8EdeKv7U+A7vhvaJ/Hrd7fKXz+FHkU4qHHkHzXuf3FePHh689B0mDsMK77x3u0aXS
 rGrEzK5pZR1mO1FMTWK5JUTQ/dOxuBFpxQDPe2BVDh/Y1HK6r+Ksh0JQVq1yExffgtenUkyfzN
 jM0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Nov 2022 19:07:19 -0800
IronPort-SDR: Rr7T99R7o+AHBnIKMNA8urlNExuNM67vgAcQ+U3QoiT/B+9BRnHIFc0avRA6GcNyrZbfdNC/n0
 nuPw//Zhcg/ApMavVFG7CS31KtfFg0hdYQUsztWAcKgT42c6/E9AqPcgHrb25EBA+XrWlm8wyP
 rOnRSpwhZgTBQ6Ojw4eugWy9V7w4jYZ0Z7BoO9CPk7QNeA2FBhwKRfe600f9xW1hc3gat8b17i
 Hu266zthYqeUyk4NN4abBFUdqOm6TRYX/sVQxiEf3+rQRgeXaoswtWMJZy/gFaOyH9L6IEH3Bn
 dQU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Nov 2022 19:54:00 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4N77HW46gDz1RvTp
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 19:53:59 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1668052438; x=1670644439; bh=1BeReEfDbrsOuR2jrLihBbhHBYsRmeFMbJ0
        BnBZcw9c=; b=MFJPa8/UCfEquZv5waEGbrb1ydqOf9NN8lLjKkxYz37A1w/LkAs
        A1HDz/C6EBFL4Dz+mBvevjpWxOQwRCx7ApvdNTMBqNMv1ugSDCY3Lq6UpVHCs6VJ
        rBSAgmBgxjHVIyJLmV56zGo8Wdt29j3hMNY3Rp8wH7qOONelMpi/N5wb4PA8/iX6
        j4YcP7FT98e3PzANoRZRK0oTlzh3p3amx+f45UY+sTGNxpIL1Qu9FYTwXBzqCCPe
        pmI08GKzZtAujP/6mji4SuMxvv7e4gOcLfwX9AoEp3Efz90vDwFtp5XDSNc1ZtwS
        fihUQUAq48RYAtXhUR5IHuNf7qhi8XMuh4Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sbBBqO1rIFws for <linux-scsi@vger.kernel.org>;
        Wed,  9 Nov 2022 19:53:58 -0800 (PST)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4N77HT70pQz1RvLy;
        Wed,  9 Nov 2022 19:53:57 -0800 (PST)
Message-ID: <af71867e-c0a1-179f-8c07-7c92afccb0d2@opensource.wdc.com>
Date:   Thu, 10 Nov 2022 12:53:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2] scsi: sd: enforce SYNCHRONIZE CACHE (16) on ZBC
 devices
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
References: <20221110035045.1633965-1-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221110035045.1633965-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/22 12:50, Shin'ichiro Kawasaki wrote:
> ZBC Zoned Block Commands specification mandates SYNCHRONIZE CACHE (16)
> for host-managed zoned block devices, but does not mandate SYNCHRONIZE
> CACHE (10). Call SYNCHRONIZE CACHE (16) in place of SYNCHRONIZE CACHE
> (10) to ensure that the command is always supported. For this purpose,
> add use_16_for_sync flag to struct scsi_device in same manner as
> use_16_for_rw flag.
> 
> To be precise, ZBC does not mandate READ(16), WRITE (16) and SYNCHRONIZE
> CACHE (16) commands for host-aware zoned block devices. However, modern
> devices should support the 16 byte commands. Hence, enforce the 16 byte
> commands on both types of ZBC devices, host-aware and host-managed.
> 
> Of note is that this patch depends on the libata-scsi fix [1], and
> should be merged to upstream after it.
> 
> [1] https://lore.kernel.org/linux-ide/20221107040229.1548793-1-shinichiro.kawasaki@wdc.com/
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opendource.wdc.com>

> ---
> Changes from v1:
> * Dropped the first patch to relax check on host-aware devices
> * Enforce SYNC 16 command on both host-aware and host-managed devices
> 
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
> index bd15624c6322..b163bf936acc 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -921,9 +921,10 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
>  		return 0;
>  	}
>  
> -	/* READ16/WRITE16 is mandatory for ZBC disks */
> +	/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
>  	sdkp->device->use_16_for_rw = 1;
>  	sdkp->device->use_10_for_rw = 0;
> +	sdkp->device->use_16_for_sync = 1;
>  
>  	if (!blk_queue_is_zoned(q)) {
>  		/*
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

-- 
Damien Le Moal
Western Digital Research

