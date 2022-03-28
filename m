Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528F1C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Mar 2022 09:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239758AbiC1JYv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Mar 2022 05:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbiC1JYu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2022 05:24:50 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F64B87C
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 02:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648459389; x=1679995389;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9yYSE5Y6C08cvgvTios6SjkIYNOYx/lGroX1NA9pKUY=;
  b=L9xA5ukl4HIqkryMG6dFo4yG7vDJHpShv7cmJzkYgMHmt+eHq9rscf+r
   Bvs/xOAnDtxCNb+yTLeVrOJMvJT0yX+Bdz14e0RsWuduwJjWJel1hJMwN
   yHkyOt12bcNrMgTLxQDeL2SFBr942cWjLCN9AL91+Dtv74lR0FNJfzD4F
   tMdh2PsxKBl7+Znp8yMkjOh1W3hiIBoWp1jYlE8tqa0z9EjWwqnw/Jdhq
   Yg87+hO50tV/k5mSQjKdsuOmw9YlaBlnHoWM3OFrN0xzXf4g1iOhjCj6F
   BxP9zSCD/LMuDuu8dH/WB1+CBMW1YJ4/9SzZwXU10VEbG/DILw8Roi8QF
   w==;
X-IronPort-AV: E=Sophos;i="5.90,217,1643644800"; 
   d="scan'208";a="308386753"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2022 17:23:08 +0800
IronPort-SDR: tx/mcXNYPB/ybh4beLKgYIU/jSMA4CJ2yRdRlryFaC1UBPIj7INW9KJQLDA7Cdd+pVsfgCQ5ow
 E7WqEOeG4d/uZ8YJMGJnI44zNVgS00miWLbLzMTEn7zOreFzYrbgEhv8WUdAPKtTnsWKtLU6+h
 yyMYaSEbmDPoy4C22PuhETeiSTdZK1ET9U4yVlG9UAQpMnEV8q0GsaK8wj+aOxOUeGT67fFEJy
 fmqsrp4KhAF7jTP4DRqJluPMEq+wrhbPceitu8qhg5TvkcV7suFdf9eeE8PlWhMrcuEpeB8va4
 T/U1Hh3G8K+FEmHmjsdZWkzi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Mar 2022 01:54:54 -0700
IronPort-SDR: 4iNYNpbasCjwpyi8vKlN24bWw3SBZg8enhRyeDAoE+1pSBeK0Ld6DJR8lzs5wefM61hxDkbBQw
 V/bA427k3wDrYyENfTrt+WAU1mSMrOLJ77vayQtoyTt22oJTJVfEFxo7T0jDyhXDLKC+5SSRSj
 A1ZYzcEoEcXHaXlv4/+fI36eXeC4lVXvdEjxpSPm8uT4xMhV01U0xIGGAng2m+vvdFoUGDjZUw
 gv5q2vvLCuShI45svPTuz5T7P2m+1UemKzGFj34qd2yGvJB+JnWT3GD/APQEOfmfp3lYG1lePB
 sgs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Mar 2022 02:23:08 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KRnL428j7z1Rwrw
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 02:23:08 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1648459387; x=1651051388; bh=9yYSE5Y6C08cvgvTios6SjkIYNOYx/lGroX
        1NA9pKUY=; b=SsHByRjGN1yqWuXc7SPMn34RwLwqM+HMh+ei5Jq7yz9BQCxhrwe
        XRDpUn5fX8t49cCNosuWNvXm5vuffCTlR2BCePa/kA+f/NCEbSLN+TvaX4f0Cq5f
        4EYafvpMuweWPnxG4uXD66F6rQyHPIv9ii3eP3/dVx1x+JETm67XTg0WurmTiJTD
        OR5GVk6vah33NZsbLAEcPiA6YbmRsEWNvsdfO+Kg1a4DCwZuCDahPX2nL+qADhXt
        qsH28yJQQS+wSLS7u+yhae/6LJaNd/iflygPtAU/YChyAb2Hs25IBPFQuBRLs5Zn
        PUSUHsdh8F6YqKfZgFbFEQysBIIpSqkLQAA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sZ_l_6DsqKeA for <linux-scsi@vger.kernel.org>;
        Mon, 28 Mar 2022 02:23:07 -0700 (PDT)
Received: from [10.225.163.121] (unknown [10.225.163.121])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KRnL26VsSz1Rvlx;
        Mon, 28 Mar 2022 02:23:06 -0700 (PDT)
Message-ID: <99820f1c-10c8-72b3-c5b8-3d7209dc3fde@opensource.wdc.com>
Date:   Mon, 28 Mar 2022 18:23:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] scsi: pm80xx: enable upper inbound, outbound queues
Content-Language: en-US
To:     Ajish Koshy <Ajish.Koshy@microchip.com>, linux-scsi@vger.kernel.org
Cc:     Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        john.garry@huawei.com, Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20220328084243.301493-1-Ajish.Koshy@microchip.com>
 <20220328084243.301493-3-Ajish.Koshy@microchip.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220328084243.301493-3-Ajish.Koshy@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/28/22 17:42, Ajish Koshy wrote:
> Executing driver on servers with more than 32 CPUs were faced with command
> timeouts. This is because we were not geting completions for commands
> submitted on IQ32 - IQ63.
> 
> Set E64Q bit to enable upper inbound and outbound queues 32 to 63 in the
> MPI main configuration table.
> 
> Added 500ms delay after successful MPI initialization as mentioned in
> controller datasheet.
> 
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index b92e82a576e3..f04c6c589615 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -766,6 +766,10 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
>  	pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity	= 0x01;
>  	pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt		= 0x01;
>  
> +	/* Enable higher IQs and OQs, 32 to 63, bit 16*/
> +	if (pm8001_ha->max_q_num > 32)
> +		pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt |=
> +							(1 << 16);

No need for the brackets.

>  	/* Disable end to end CRC checking */
>  	pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump = (0x1 << 16);
>  
> @@ -1027,6 +1031,9 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
>  	if (0x0000 != gst_len_mpistate)
>  		return -EBUSY;
>  
> +	/* Wait for 500ms after successful MPI initialization*/

Is this comment really necessary ? Anybody sees that this will wait. It
may be better to explain *why* the wait is needed.

> +	msleep(500);
> +
>  	return 0;
>  }
>  


-- 
Damien Le Moal
Western Digital Research
