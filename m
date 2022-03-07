Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E85C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 00:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbiCGA4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 19:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiCGA4p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 19:56:45 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847BE4507E
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 16:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646614551; x=1678150551;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nmWt1fzmvUAKgvqkKB/5oOjkEhnHn9g+Bw9Tl/UuTlw=;
  b=h5Gh4Q0MvIaJc07kgzNjgJXn4QY7rCKxcmcdyRH1Jw83EIzyYZ5h5sxx
   f7IAwnoW6gisVF1qM0liCpEfA12beD/k+gmixkojTB5ki1kLHRYxqc76e
   5RoqFIA6X6wrr9Hvjkv+4i/YsXjTBpv4rRx0WRDY53hIyBavH+wiZ4GpP
   zHsQBjc6F+bGUaUDzDStiPFzjG3SD7NHAHt6KHanbK6UihxSRm29klDgp
   sbPle7cUxA/okxpBORgHD8A2hVbu2akP27QWhiqKbIgKmhFzWoCN6vvbX
   NS+vxfmZUlmox24IUF/dvyA4E5Y0F62NrsEcxDPyRMbdWNOfrvl7Pdtsa
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,160,1643644800"; 
   d="scan'208";a="298751984"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Mar 2022 08:55:50 +0800
IronPort-SDR: UutSowMVgycx+FPIqVp3rvIK5fJTj3lcjwV5t+4yerGlYQSJ687B6Z+n/KxpgtDxeJc1GKvcc2
 ojHSFXyDqULLmPmWKl1PcXhb7SyUXy/H2OuxH2gmpB+NjzynmEhWWyD16tOrBrUonTLOmHDDWC
 TTTn5xbQttKypnaUn/ubCOGwjSPROfiPBrFjAhrSw0Y9f85sPGPzLHUePhsHJSoGOdYiNX2dvf
 qU5xpZ1aeDtGE3t1FzLd26oV1FJCCWY/pKwab5q7vN0SwKbPi+JsfFMpg5U6FyssHS5FA6q62G
 QBO5tCwuWWSiu/JYTcmlnIry
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2022 16:28:09 -0800
IronPort-SDR: HBNjT02trf7EuBs7bRylfCyF7kZMxqQ4bl1ksFzv0oO7Y0hvTJy9qwUZoM4c2sUrgjlV3NlhEj
 g7Yb7SdVK2JD/EJBTZSvvYyKo9t3qPwfp1sw6Slza9jBIqpaf5tlD0iZ3rDMxBvTZhQwZaWs6u
 I3L1Y59O+RSE0TOeHakhXeNr1ZKZQF33oZpvd31bJqT8VJaEDgBepUDnpwc7oAQ79WErwFnwsb
 0kEu1Yt9sdv6DfAgHaqByg6grSqCTmJ1YY4fal1/nY0XG2cTc/KbmlbU+4cBlweIBL/phn/ozU
 0CE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2022 16:55:51 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KBg4Q3612z1Rwrw
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 16:55:50 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1646614549; x=1649206550; bh=nmWt1fzmvUAKgvqkKB/5oOjkEhnHn9g+Bw9
        Tl/UuTlw=; b=lwl7YTnp/KwzRiR4/2xzCUH+aRlQ3dT8VSfPDiqmb4Kt8ttFwJC
        JJ8T4FMAFqGJUBbVqeXx48RzUg99aIR+NmGtlQNq+/YVt7n2lgfaqvKYBHlR8E0c
        bcTF4c6oMrDKdj4mN7OvnveOf/NHx3ulViWDoT/0EtuF+POGCHwSUk5ptT2zjTSY
        P/kP0kAIVo8m7K4Y87vZmPUbxL+7yvffvycpHWfbrtpjsjpMii50s068z++nTojB
        GEhXhxbUp2MSs1KdJRrY6Z/4BmnJm5mC/1JxLS9wUQp/hE6leaJmOUCWP2GLyHm3
        H9z21CuqegyDM1CG/DJoMuexHFt4/xV+znQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xxcxMpH8gpAn for <linux-scsi@vger.kernel.org>;
        Sun,  6 Mar 2022 16:55:49 -0800 (PST)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KBg4M43P9z1Rvlx;
        Sun,  6 Mar 2022 16:55:47 -0800 (PST)
Message-ID: <ca924db7-f137-ce48-a83b-e0079995272d@opensource.wdc.com>
Date:   Mon, 7 Mar 2022 09:55:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/4] scsi: libsas and users: Factor out internal abort
 code
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, jinpu.wang@cloud.ionos.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ajish.Koshy@microchip.com, linuxarm@huawei.com,
        Viswas.G@microchip.com, hch@lst.de, liuqi115@huawei.com,
        chenxiang66@hisilicon.com
References: <1646309930-138960-1-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1646309930-138960-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/22 21:18, John Garry wrote:
> This is a follow-on from the series to factor out the TMF code shared
> between libsas LLDDs.
> 
> The hisi_sas and pm8001 have an internal abort feature to abort pending
> commands in the host controller, prior to being sent to the target. The
> driver support implementation is naturally quite similar, so factor it
> out.
> 
> Again, testing and review would be appreciated.

I ran my usual set of tests with fio and also libzbc tests to exercise
the failure/abort path. No problems detected. All good to me.
Feel free to add:

Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

To your V2 with the cosmetic fixes.

> 
> This is based on mkp-scsi 5.18 staging queue @ commit f2ddbbea7780
> 
> John Garry (4):
>   scsi: libsas: Add sas_execute_internal_abort_single()
>   scsi: libsas: Add sas_execute_internal_abort_dev()
>   scsi: pm8001: Use libsas internal abort support
>   scsi: hisi_sas: Use libsas internal abort support
> 
>  drivers/scsi/hisi_sas/hisi_sas.h       |   8 +-
>  drivers/scsi/hisi_sas/hisi_sas_main.c  | 453 +++++++++----------------
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  11 +-
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  18 +-
>  drivers/scsi/libsas/sas_scsi_host.c    |  89 +++++
>  drivers/scsi/pm8001/pm8001_hwi.c       |  27 +-
>  drivers/scsi/pm8001/pm8001_hwi.h       |   5 -
>  drivers/scsi/pm8001/pm8001_sas.c       | 186 ++++------
>  drivers/scsi/pm8001/pm8001_sas.h       |   6 +-
>  drivers/scsi/pm8001/pm80xx_hwi.h       |   5 -
>  include/scsi/libsas.h                  |  24 ++
>  include/scsi/sas.h                     |   2 +
>  12 files changed, 368 insertions(+), 466 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
