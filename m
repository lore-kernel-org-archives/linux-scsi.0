Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73197C54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Sep 2022 22:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiITWDn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Sep 2022 18:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiITWDm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2022 18:03:42 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C27760D1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2022 15:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1663711420; x=1695247420;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+hPpgbC5aTpEknoMOIocfRrMBJmIwKssPL6d+jJ3i58=;
  b=MNIl2A/nkU7KWxq7UhIxsrBAPHPgo1GoJ+0Q0ZSUiWO3DH7AZMhYHFUf
   nPQVRodbufg5O2aL1Tlb53i3Lv/HKCHU7mm0cqT1h+2DZlrCssudOWxJN
   SdiRUKjAMZUCFO9Pr8sseAuo4vKsE6nbxhBYGcfZhF7jpDejd7q1YMXoK
   XfWhC04oWq1oHDHYvWIXnBf7nhUXELhplIpnQr1HrouV2J6YzwMsckcyF
   x88oiRTbj9qglxbDqu7hlrKHXUfg2IH1Oadd2ZzyJxTHNGfM8Bh6hArrj
   yX3/cf7dTVeQRZx8LSBw6HQ7jzPnxJ1J2ancqomNCnIscX/RUtbnjuNC4
   A==;
X-IronPort-AV: E=Sophos;i="5.93,331,1654531200"; 
   d="scan'208";a="217030194"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2022 06:03:39 +0800
IronPort-SDR: UrZibAnIpWmvs6ekbbLDtzObRgAbSr1kY8oLrIfYONVQM7PPqlQHbb5icBiwIRpM9u/vR0h9Dr
 fK8N2cpxlRvJFmWeOx9pBcZbGfdOUIxVC5NoQGmB0IqgekzoJcrYBsXq2Ra4HAQ4rOC8S4wQCP
 wLCiZNmjgfAxVD6z5YM0FcuP0N0enP9TwyZ58axcp6FpZ8SIZ76WfJQRIMm78k4QMUIrREb1iB
 tW13z6xEaSOWEye7l6rRKTBP0MoehQ6HmxYZpGbgvnAXToZoRO7/3q03iAeWg0W1oTIDvzizdH
 qVan9H5GelGxxu2KQNtLec4W
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Sep 2022 14:18:15 -0700
IronPort-SDR: 1Qt1mq9GixETQMcXopREmi+Ou72QkrpS9I7O3ZLKoOyu7THU8eaUPlInORT9+BC2gG6/SP3ZfG
 bnPaWX8ZTO6vHyMfcatNWocQtP7SBD9ptmd0wAbymXcaBfl53uoxGTGu9uE8D5zZS2lpqScw0S
 bxW1/5gBSCQ0NPbq+3tTws8vuyZZVIK0UIUx8Z5g2qgRPlCT36dhPjBfDt4/XBT67Wxouppu0F
 pXcqFS40L+IcsxRvShIXlBfr2SqNArm59IvxTzoqxxF/UALvxbTXR4Zvq81bmRhBOsVUGFwiki
 dUk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Sep 2022 15:03:40 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MXFtM3WWDz1RwvL
        for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2022 15:03:39 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1663711418; x=1666303419; bh=+hPpgbC5aTpEknoMOIocfRrMBJmIwKssPL6
        d+jJ3i58=; b=RlpUBSmgP2MlKTyHdrVMvy2qbkj0Lc/Bti0ZF3d+/hbaUkGAfnk
        QjhquYKhKYvkpZeSmmUlIG4wEmXCo+09kSc1ebtRKQCxQXaF1k7twbLYAnq0Qc2Q
        kfdUPzWmLH0gNwM6cUpBiVIE5wVWUONHnJJpUMpuWhf2E2zyqV8L6KYx0kOh7OL6
        CtOudvjp1J1YV536kRmzaYiABTZdCe1jPDkscPd8RbxhzR9oqqSdfuYPXTPH45Fr
        n6FGHPzGSAjSyAAYd2Z5WpNzdKAmZb0yInrtgUxWyRzYZGtUiU1+ZDFKyTt0sfbJ
        t9eI8JWRTtPuHKhADdyiAdQamcznsN0Psdw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9XeqDMGr6kkJ for <linux-scsi@vger.kernel.org>;
        Tue, 20 Sep 2022 15:03:38 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MXFtH54PRz1RvLy;
        Tue, 20 Sep 2022 15:03:35 -0700 (PDT)
Message-ID: <67b11e85-3e4e-beb7-4a2b-ef856207b227@opensource.wdc.com>
Date:   Wed, 21 Sep 2022 07:03:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 1/6] scsi: core: Use SCSI_SCAN_RESCAN in
 __scsi_add_device()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hare@suse.de, hch@lst.de
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, brking@us.ibm.com
References: <1663669630-21333-1-git-send-email-john.garry@huawei.com>
 <1663669630-21333-2-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1663669630-21333-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/20/22 19:27, John Garry wrote:
> Instead of using hardcoded '1' as the __scsi_add_device() ->
> scsi_probe_and_add_lun() rescan arg, use proper macro SCSI_SCAN_RESCAN.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/scsi/scsi_scan.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index ac6059702d13..3759b1a77504 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1588,7 +1588,8 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
>   		scsi_complete_async_scans();
>   
>   	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) == 0) {
> -		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
> +		scsi_probe_and_add_lun(starget, lun, NULL, &sdev,
> +				       SCSI_SCAN_RESCAN, hostdata);
>   		scsi_autopm_put_host(shost);
>   	}
>   	mutex_unlock(&shost->scan_mutex);

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

