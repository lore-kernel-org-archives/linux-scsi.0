Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F56C678D4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 06:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCFG6w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 01:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCFG6v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 01:58:51 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F69BDF0
        for <linux-scsi@vger.kernel.org>; Sun,  5 Mar 2023 22:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678085906; x=1709621906;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S0UqlX2mJzS4ihrcGhn+rrKlVklz2DLXSSkiTRTBrA0=;
  b=YQ6NemkmP/pvlBZBjucvOcotuphcS/nxRN6+mT6OuGaUpEHEZS3zqhyb
   rWcU7iYwigLc2MUCWMQmCRfGkZH1XmTnM/Rj7W0sGiZo5Ys36Si59TbeD
   GGF4B3k4E+tZu2rCkD9K+hPQ5MUn9st5TRzlZ8Bd7tzli+gx8bSr66tmn
   BgkyfTI+7ajB5X0ZZBbsdrKSHzG9LYwUToT5cWCY8Cr2XyngAGl72b3Hi
   Sp7A7nEigquwIxR3FyDQKBu7p8POR8gcaT0UxcL2YaqKzNgpvsm+YJUC2
   1sZh/lUXQtFmapkyIdwq4lWD39qdfbiVixeqYMcVjyinLtkGSYP9BoLfC
   w==;
X-IronPort-AV: E=Sophos;i="5.98,236,1673884800"; 
   d="scan'208";a="329213455"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Mar 2023 14:58:26 +0800
IronPort-SDR: CAvcja1AS20mj5KCiTlixs5+gNmNRemzwbzvb1oLBBAks/3kP87pMXGwH+9u6ECVVf71KKk1yr
 gniL2zux/niVnueVhSi3VYWd4qL1h1oAFz7HqA/1d3PsS+TJfo8NCgroQP8woWrpWmvCUxXVqR
 v+t4s01Dr1DGI4Hhhfc3FNTQ08aUpenp0OhFLUFr+ZdD9itT32EJL+ksVVPGy5YHCXuSCPdqDY
 B4Gq4kEEKgMhPR0qnlfeCsM4JuAF70iWj3sQUGtS9I3beR4Sz2zkIAnW/9/YAHzhn6TKU4yeXO
 tuo=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2023 22:15:07 -0800
IronPort-SDR: LonUngO16Oz4vzIt4HwcwxWz5OiABqdLz5kyc/OIt9T0qyDwv1v79CV/lYdoy6DMo29K4SdEOT
 r2HdgU8lSkBARTUWESK8YmdAZMdbolp2Z3s2Dv8/sHW41uwynuQot10dnbq1fthe6Bxs78Z4mU
 OGkBB0BCgJXkgBKX2QXJDwEYAedpsBRm5u7B59HBIsc5OgdtZdsA6Sr86gnc+v1iSMIhD/LOqX
 jKMOTRPIKcEfKCxrP3OM/LaPZYf/4sxuVreuUD1vP2R8T23g4BcsABpY5BzFws30ZrF4ZOyIa/
 Ams=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2023 22:58:27 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PVTtp0Xq7z1RvTp
        for <linux-scsi@vger.kernel.org>; Sun,  5 Mar 2023 22:58:26 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1678085905; x=1680677906; bh=S0UqlX2mJzS4ihrcGhn+rrKlVklz2DLXSSk
        iTRTBrA0=; b=oXPBpqx3ehd9OLbtP4i1A4PvPUzoiYsiT9P754iXqkIR5jnlzEQ
        rWJ6GIrxk2rp7XOKkZda234IddhfqsnqYmRAUMLLluLMJBshjem7vK5Ut+fAW1lc
        cTCYXD2nglgPfxUmXw34OsjIgcLNOMsy4LkXsWC7HSwPIYArvj0XJnaTIHTDRRbt
        5wqIWlu8Beiz12Ltt7ipCIfLSLr9ZOnQ4FdMGr7BO4Ary5U10vBGX6KohYPAL4ye
        omiQgut7BloTMVkZQjQFxmDmTQVemAIlbCSQgLdve73jDaCcehrNwMCwSh/6YZvN
        GUPsfyzbmkgCUyPS4Ty1+155F5ehQt79KVg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id pOgN0w4nbFEH for <linux-scsi@vger.kernel.org>;
        Sun,  5 Mar 2023 22:58:25 -0800 (PST)
Received: from [10.225.54.64] (unknown [10.225.54.64])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PVTtn0gW0z1RvLy;
        Sun,  5 Mar 2023 22:58:24 -0800 (PST)
Message-ID: <dd09f37a-34c5-93de-c7ad-17489849a329@opensource.wdc.com>
Date:   Mon, 6 Mar 2023 15:58:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH REPOST] scsi: sd: Fix wrong zone_write_granularity value
 at revalidate
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20230306063024.3376959-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230306063024.3376959-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/03/06 15:30, Shin'ichiro Kawasaki wrote:
> When sd driver revalidates host-managed SMR disks, it calls
> disk_set_zoned() which changes the zone_write_granularity attribute
> value to the logical block size regardless of the device type. After
> that, the sd driver overwrites the value in sd_zbc_read_zone() with
> the physical block size, since ZBC/ZAC requires it for the host-managed
> disks. Between the calls to disk_set_zoned() and sd_zbc_read_zone(),
> there exists a window that the attribute shows the logical block size as
> the zone_write_granularity value, which is wrong for the host-managed
> disks. The duration of the window is from 20ms to 200ms, depending on
> report zone command execution time.
> 
> To avoid the wrong zone_write_granularity value between disk_set_zoned()
> and sd_zbc_read_zone(), modify the value not in sd_zbc_read_zone() but
> just after disk_set_zoned() call.
> 
> Fixes: a805a4fa4fa3 ("block: introduce zone_write_granularity limit")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research

