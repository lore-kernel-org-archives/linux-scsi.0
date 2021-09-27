Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BB5C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 05:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C2C961157
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 05:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhI0FYn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 01:24:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64570 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbhI0FYn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 01:24:43 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210927052303epoutp045bfad99f3017009cc96b93b6d3269e0e~olltHaIoa1159011590epoutp04K
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 05:23:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210927052303epoutp045bfad99f3017009cc96b93b6d3269e0e~olltHaIoa1159011590epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632720183;
        bh=/RDKfJgvo+6//ygW4W4RIWBqKDZbDkV0kobmwpDGfrc=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=RwrrYotsEW3d3VYEumwby3MgZBQxD225Eu/DKz2/vNh4TW2RYbA14qa1GJVjl6+Al
         rD9HI2DEUX5MrPtt2VWL8ZYL81HhqxUGP/xJpb/LtTvZjGBf0C5vLONgVorPizYCNx
         rqpyEQUGN0fK0/TVJkd5ELfMFCgIph/Hl8nenwrk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210927052303epcas3p4993f1f266e63c7bb4485fca7ed84192c~ollsfhaxk0142001420epcas3p4m;
        Mon, 27 Sep 2021 05:23:03 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4HHrd301XPz4x9Q3; Mon, 27 Sep 2021 05:23:03 +0000
        (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210927051540epcas1p1c2a893b9a1b476ee64dda652c16fd549~olfQnrYCi1112811128epcas1p1C;
        Mon, 27 Sep 2021 05:15:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210927051540epsmtrp1f4b0d7fd83563e85eeb3c46de4912518~olfQmarD_2735827358epsmtrp16;
        Mon, 27 Sep 2021 05:15:40 +0000 (GMT)
X-AuditID: b6c32a29-d87ff70000002383-6d-6151537ce3ca
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.39.09091.C7351516; Mon, 27 Sep 2021 14:15:40 +0900 (KST)
Received: from [10.113.221.211] (unknown [10.113.221.211]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210927051540epsmtip232a42143de2ef234f3a0500d6311ee6e~olfQTKmxp0178101781epsmtip2e;
        Mon, 27 Sep 2021 05:15:40 +0000 (GMT)
Subject: Re: [PATCH v3 03/17] scsi: ufs: ufs-exynos: change pclk available
 max value
To:     Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        cpgs@samsung.com
From:   Inki Dae <inki.dae@samsung.com>
Message-ID: <878274034.81632720182984.JavaMail.epsvc@epcpadp4>
Date:   Mon, 27 Sep 2021 14:25:58 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
        Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210917065436.145629-4-chanho61.park@samsung.com>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWy7bCSvG5NcGCiwe8TGhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17Z4eUjTomens8XpCYuYLJ6sn8VssejGNiaLjW9/
        MFnMOL+PyaL7+g42i+XH/zE5CHhcvuLtMauhl83jcl8vk8fmFVoei/e8ZPLYtKqTzWPCogOM
        Ht/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwXwRHHZpKTmZJalFunbJXBl9LacYS44yl7xbMEn
        tgbGqWxdjBwcEgImElPm5ncxcnIICexmlPi01AQiLCGxZSsHhCkscfhwcRcjF1DFW0aJCRuW
        s4OUCwuESSz8/5gJJCEiMItJ4srDJ8wgCWaBe0wSDUe1IDpOMkq0b33FCJJgE1CVmLjiPhuI
        zStgJ/H8/CWwBhageEf3JbC4qECkRNOJrVA1ghInZz5hAbE5BRwkHsxazAqxQF3iz7xLUMvE
        JW49mc8EYctLNG+dzTyBUWgWkvZZSFpmIWmZhaRlASPLKkbJ1ILi3PTcYsMCw7zUcr3ixNzi
        0rx0veT83E2M4EjW0tzBuH3VB71DjEwcjIcYJTiYlUR4g1n8E4V4UxIrq1KL8uOLSnNSiw8x
        SnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgOu40+1rae9swkTXbpuy4XPNsYzj3wob9
        NYvLkzICDC9HZnw6cVKv9bvV3KXv2j7ufa4tsnru56tz55eXxaz5o/yg//PSxEk2/gcWaYvU
        hn4773JkaZ9i/6wDv39M2Cr6YZ2Y0Nzas9L+5/X5rAscKpZvMAm+e26G8i4vx44P1XNK/ber
        75gdzHNi86Rdc/sN/z3LuLxlwd7uFueNelsNPj7p7rf3YThg+fKOR06NwbLJr57P+bvUQfVt
        ip79Cau1L4S0YnfM+nYjj6WzOvy6bf7K9wfX/Gmc1fhCZAK32syJ3/enzf6tNfmWXrFxknry
        pwT/UFMTHzatt7W6W6VM168WE1+/Q2H7pYDK5XNWvp2nxFKckWioxVxUnAgAWNu9WVMDAAA=
X-CMS-MailID: 20210927051540epcas1p1c2a893b9a1b476ee64dda652c16fd549
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210917065522epcas2p26f56b37c3f7505b9d0e34bc2162fdbbd
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065522epcas2p26f56b37c3f7505b9d0e34bc2162fdbbd@epcas2p2.samsung.com>
        <20210917065436.145629-4-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Chanho,

21. 9. 17. 오후 3:54에 Chanho Park 이(가) 쓴 글:
> To support 167MHz PCLK, we need to adjust the maximum value.
> 
> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  drivers/scsi/ufs/ufs-exynos.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
> index dadf4fd10dd8..0a31f77a5f48 100644
> --- a/drivers/scsi/ufs/ufs-exynos.h
> +++ b/drivers/scsi/ufs/ufs-exynos.h
> @@ -99,7 +99,7 @@ struct exynos_ufs;
>  #define PA_HIBERN8TIME_VAL	0x20
>  
>  #define PCLK_AVAIL_MIN	70000000
> -#define PCLK_AVAIL_MAX	133000000
> +#define PCLK_AVAIL_MAX	167000000
>  

I'm not sure but doesn't the maximum clock frequency depend on a given machine? Is it true for all machines using different SoC?

Thanks,
Inki Dae

>  struct exynos_ufs_uic_attr {
>  	/* TX Attributes */
> 

