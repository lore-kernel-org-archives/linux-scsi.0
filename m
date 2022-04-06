Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC775C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 14:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbiDFO7K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 10:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235458AbiDFO67 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 10:58:59 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0144232280B
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 20:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649214329; x=1680750329;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8EAF3+y8CzL5zCCqpWFDAI2tbRm+ByBQdiNkhAW+tuo=;
  b=aMGvfPSMm6V7+QZPrmg79kgY9lbVdyvdna4qW+5f1J1VxzBf01PWGTT/
   m0rqiAAlm/NSitDFe1zOe/9diA6aOB6z1iOTKOKd7nEncl0rSSkOQJ86N
   1XGUicSm9PyPZSPC7sDOTclx+scJ0de0DSAW5ZcGE2F3qeeOGymxmPRTn
   6750/r+K9IwPzAFKwSpKCVeBQPzTL7oiCsrO72C3p0ii23vw1G3NbgHwX
   QS2PkiBz/fp//HxPGRi5nYUrP4DblbUd0+Te63UcymczrNlaMldeCGSpg
   18PNUJdpljmZodIMBkReQqaaRPT9ktAxi86QlRIxXl3CWoAHP2oFSCveH
   A==;
X-IronPort-AV: E=Sophos;i="5.90,238,1643644800"; 
   d="scan'208";a="198095868"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Apr 2022 11:05:26 +0800
IronPort-SDR: c9HCbv/dNf2HTdIvkKl6Pi5ewfRUYNzZoCNIZs+npkc1J30fhdTAl648ST0oUHlXBt2WCck+ZF
 VWMyJ0lN7pvGOHmUx4loF7TGf/7egtg+ZTTeZyaRaKjHeOgBkzcNHZvR8xUu4pzj6gi3oXGQKg
 e280x4PFf9SoUjaMRZcvx5AOx9xtwPSqmKqMXSdT90h8ZGYVShdupHPGKgmCfeSR0GFaknLIy3
 knO0c5qycdLUf8MwsUNNJ8qsXF28z4LNWSYDCFnwVORpcxiD7gp1onA/3ayzfhHAG/FE8+0f9k
 yGPUthAURLhjs977Oc/55RRo
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Apr 2022 19:36:08 -0700
IronPort-SDR: PPzJ54V6tCjnEG3+iy3mF5EIrg61pjnZXDwQHlAQjIdbfwWuw8LGwXawWOZiaDNTD/RGfrMubS
 JbZUexDdueF9c2vfl70WpviRib00KjNinDP1ijwESffWjq3nzEV0OewLIcU0iqrvGzobEzoDGo
 pdcHQv5nKi2A8Sbq6VXJfFg68LCE50TDI3H6xN3kBhA5D5wwqhUd2QUexj0jHKbwuxxSDulKVb
 Z8T10hPPKAnWueysDYqQ9xQL7qdcjUO7gzXZnB+GnN0nnPzuwju3p+Yoxtba8en/dEA81jNox4
 FoQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Apr 2022 20:05:27 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KY8X567sjz1SVnx
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 20:05:25 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649214325; x=1651806326; bh=8EAF3+y8CzL5zCCqpWFDAI2tbRm+ByBQdiN
        khAW+tuo=; b=iC3JJSk61QDTJZHUgTSDknPosaEACooM+CowZReypPGyJZT627K
        S4hQ0pqhQcFmJIIFHjbW2+BfXfab2/Pt6ERNrq6bLQIVPG49552vfHIVVO9vcrn2
        hfS/zKOi7grsbm0OHzVr11ad36MagrsOrSjby6su7eMd0IfoYPlB1KNgUtkAzqDD
        Mi+ole2nbIo4S3BVdjUfsQBUZi1GRiUmp0ayaUA/f5umbkqLBfth2Cu0UQh6d9vv
        oKE5p+RpJSLcN9zi1/G7hROqSmiI/FF9Ekk8mnmcqZqA6u0kdofX2y1H5oQOEaoi
        HMFcYvhbr+lnWtzB/GVyW6LBdLfvc4AKPCg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ALgd_Gd3wduw for <linux-scsi@vger.kernel.org>;
        Tue,  5 Apr 2022 20:05:25 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KY8X43dQRz1Rvlx;
        Tue,  5 Apr 2022 20:05:24 -0700 (PDT)
Message-ID: <866fd2b3-80f9-5696-e564-bcea08e64701@opensource.wdc.com>
Date:   Wed, 6 Apr 2022 12:05:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/2] scsi: pm80xx: enable upper inbound, outbound
 queues
Content-Language: en-US
To:     Ajish Koshy <Ajish.Koshy@microchip.com>, linux-scsi@vger.kernel.org
Cc:     Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        john.garry@huawei.com, Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20220405092833.83335-1-Ajish.Koshy@microchip.com>
 <20220405092833.83335-3-Ajish.Koshy@microchip.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220405092833.83335-3-Ajish.Koshy@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/5/22 18:28, Ajish Koshy wrote:
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
> Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
> ---
>   drivers/scsi/pm8001/pm80xx_hwi.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 3e6413e21bfe..c41c24a4b906 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -766,6 +766,10 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
>   	pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity	= 0x01;
>   	pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt		= 0x01;
>   
> +	/* Enable higher IQs and OQs, 32 to 63, bit 16*/

Nit: space missing before "*/"

> +	if (pm8001_ha->max_q_num > 32)
> +		pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt |=
> +							1 << 16;
>   	/* Disable end to end CRC checking */
>   	pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump = (0x1 << 16);
>   
> @@ -1027,6 +1031,8 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
>   	if (0x0000 != gst_len_mpistate)
>   		return -EBUSY;
>   
> +	msleep(500);
> +
>   	return 0;
>   }
>   

Otherwise, looks OK.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Note: My test box with the pm80xx HBA has 16 cores/32 threads only so I 
cannot really test this.

-- 
Damien Le Moal
Western Digital Research
