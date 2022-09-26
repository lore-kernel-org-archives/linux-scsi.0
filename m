Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239E6C07E9D
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 13:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbiIZNQv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 09:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbiIZNQX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 09:16:23 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA75C58DFD;
        Mon, 26 Sep 2022 04:44:30 -0700 (PDT)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Mbgk446V2z687qR;
        Mon, 26 Sep 2022 19:38:20 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 13:43:18 +0200
Received: from [10.48.156.245] (10.48.156.245) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 12:43:18 +0100
Message-ID: <88299002-3aa1-d208-0451-d5b8601c0edc@huawei.com>
Date:   Mon, 26 Sep 2022 12:43:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2 6/8] scsi: libsas: use sas_phy_match_dev_addr() instead
 of open coded
To:     Jason Yan <yanaijie@huawei.com>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.com>, <hch@lst.de>, <bvanassche@acm.org>,
        <jinpu.wang@cloud.ionos.com>
References: <20220924073455.2186805-1-yanaijie@huawei.com>
 <20220924073455.2186805-7-yanaijie@huawei.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220924073455.2186805-7-yanaijie@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.156.245]
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/09/2022 08:34, Jason Yan wrote:
> @@ -2115,8 +2109,7 @@ int sas_find_attached_phy(struct expander_device *ex_dev,
>   
>   	for (phy_id = 0; phy_id < ex_dev->num_phys; phy_id++) {
>   		phy = &ex_dev->ex_phy[phy_id];
> -		if (SAS_ADDR(phy->attached_sas_addr)
> -			== SAS_ADDR(dev->sas_addr))
> +		if (sas_phy_match_dev_addr(dev, phy))

It would be nice if the series was arranged such that 
sas_phy_match_dev_addr() is available when you introduce 
sas_phy_match_dev_addr()

>   			return phy_id;
>   	}

Thanks,
John
