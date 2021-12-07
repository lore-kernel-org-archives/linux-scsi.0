Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541DAC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 02:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbhLGCFS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 21:05:18 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34222 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhLGCFR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 21:05:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638842507; x=1670378507;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ix/RQUoZeVkdaUFwSXsyUlw6kcWmdQajjNyFczeFYvA=;
  b=FuT5aqFCq4G+XCQH6HeZdmY0Cag1v4G7ZlWBfxcgzH2QYsEE7GOZ6NqD
   Syc5cNN9iT/vXIK0x5w2OPtOXscwApC4vhDBmtMkd6UYR2TpbsluWeYqY
   D2Zy5cxyDTvB8a2mFPSieW4R8xCrdrG2tuefbRvNc9ssnc9sPQp+lNCMP
   /3qL59aLGkiCAC9vPVgFIw6qtLDNE5hAToia+FzGLC4Fo957UUNmaVb0w
   zKHOLob4WV6dtFUm6vy3iyI7xpQQaKgL/St9KMW9x/Aj06pNCk5hOAfDx
   Dmhp/wvKuxs3hr77ihnH7d/0CJvnjTbT++ZhEUfDggV+RX7P4/5owoCzY
   g==;
X-IronPort-AV: E=Sophos;i="5.87,293,1631548800"; 
   d="scan'208";a="187609658"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Dec 2021 10:01:47 +0800
IronPort-SDR: mcDvCk7j/A7/USpPPmcjsRGBoR92K5coU9zKxr5Qt2LONl0m8RLH7UmX/gmrW4G9ufg1k93DWh
 ak1BgKLSxFA9IcuRNgW5S2RScgDCah2kaRV4Hf2G6njJ/QfwLYDIAz9hV/tgTqdMglnfv6UGxB
 1z+zFA5czhC7wRxDvzCmsfJfk0IIg4rQLW0cgj0/RmXUqk0dGKVxWZld/f/4tVNE9dRwOp83rP
 fr1rMrpq1cK3iXRROiVn7Cq+4GnG8fiuc0hKf39bEdpedxpcxTPgeQtpP2IFTT2osAsNzqYAsI
 OQM7YDClZn3zs32OLSuH1vBz
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 17:36:24 -0800
IronPort-SDR: z1buPrPdVUEiiMyvfOia9FVSizij0FPFmQtB9LD1KSIKQPamyxHx2eaZcaNLu4qOoz7ZPTHGM1
 yL3xn6fReGM5ASjuS3ynkg9UkEr4auspQkyZ90wBIrBVGjaoygViEKSVWlKH6Z4mvmQOeE0IAl
 /ttHGub/3V27yTl0Rwzo0y5FIVA28B8ii5BWvGaddzqdzk93i3X38BgNWEW75MqROKvzBJQDTX
 5+wggAolnL2dlhSRi0H3+EFSakee0xLF0ebbDt7/wCuSN67muQ6CiR+KuMKm2oX1cm8lX/4wwS
 tUY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 18:01:47 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J7Np30NYKz1RvTh
        for <linux-scsi@vger.kernel.org>; Mon,  6 Dec 2021 18:01:47 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1638842506; x=1641434507; bh=ix/RQUoZeVkdaUFwSXsyUlw6kcWmdQajjNy
        FczeFYvA=; b=OVVSrBmGZ8/YjUBsHBt4dlf6/YoCS+5+ZYGOJmznXWfsY148fSr
        6JHshf784fpJb36KN+oQBaxzFJYc9kC3s+aqZC5FcMPf0v1HIqVfCBwJtuefAPPJ
        PB6gHkSFiU0+FgVsFhP8SJqOUtMfT3Y+b12a3wNsIYKqf/rI81oKPyTktxyeO2Rj
        cspLCYGBPHiOxIM1lNaz2HeRbMyfHIQIhbgDWU/tC2FE5eNmGYf6ekR7zNGXNWRk
        75ZJwCha7FAdJ8NVFLKy7FZ/X0iySXSIbMmk/jTFD9dJ/So4SOqbFvR5gd6941mp
        Nc1kWuN3nOaPjf6PVMZit13kQTW10ICH0yA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kzvjTHIsHo9a for <linux-scsi@vger.kernel.org>;
        Mon,  6 Dec 2021 18:01:46 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J7Np14B9Dz1RtVG;
        Mon,  6 Dec 2021 18:01:45 -0800 (PST)
Message-ID: <a907332f-0108-4b9a-b228-13f15bf728b9@opensource.wdc.com>
Date:   Tue, 7 Dec 2021 11:01:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v2] scsi: scsi_debug: Fix buffer size of REPORT ZONES
 command
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
References: <20211207010638.124280-1-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211207010638.124280-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/12/07 10:06, Shin'ichiro Kawasaki wrote:
> According to ZBC and SPC specifications, the unit of ALLOCATION LENGTH
> field of REPORT ZONES command is byte. However, current scsi_debug
> implementation handles it as number of zones to calculate buffer size to
> report zones. When the ALLOCATION LENGTH has a large number, this
> results in too large buffer size and causes memory allocation failure.
> Fix the failure by handling ALLOCATION LENGTH as byte unit.
> 
> Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
> Changes from v1:
> * Use kzalloc in place of kcalloc
> 
>  drivers/scsi/scsi_debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 3c0da3770edf..2104973a35cd 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4342,7 +4342,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>  	rep_max_zones = min((alloc_len - 64) >> ilog2(RZONES_DESC_HD),
>  			    max_zones);
>  
> -	arr = kcalloc(RZONES_DESC_HD, alloc_len, GFP_ATOMIC);
> +	arr = kzalloc(alloc_len, GFP_ATOMIC);
>  	if (!arr) {
>  		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>  				INSUFF_RES_ASCQ);
> 

Looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
