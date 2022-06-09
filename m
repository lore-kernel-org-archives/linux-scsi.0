Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CC0C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 08:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242178AbiFIIqQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 04:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242974AbiFIIoM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 04:44:12 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12111AE7E
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 01:43:14 -0700 (PDT)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LJctm5pL3z689rl;
        Thu,  9 Jun 2022 16:38:24 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 10:43:12 +0200
Received: from [10.47.88.201] (10.47.88.201) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 9 Jun
 2022 09:43:11 +0100
Message-ID: <9a4612db-7cc2-398d-f882-4190bc5d7759@huawei.com>
Date:   Thu, 9 Jun 2022 09:43:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 1/3] scsi: libsas: introduce struct smp_disc_resp
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
 <20220609022456.409087-2-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220609022456.409087-2-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.201]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>   #define DISCOVER_REQ_SIZE  16
> -#define DISCOVER_RESP_SIZE 56
> +#define DISCOVER_RESP_SIZE sizeof(struct smp_disc_resp)

I feel that it would be nice to get rid of these.

Maybe something like:

#define smp_execute_task_wrap(dev, req, resp)\
smp_execute_task(dev, req, sizeof(*req), resp, DISCOVER_REQ_SIZE)


static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 
*disc_req, struct smp_disc_resp *disc_resp, int single)
{
	res = smp_execute_task_wrap(dev, disc_req, disc_resp);

We could even introduce a smp req struct to get rid of DISCOVER_REQ_SIZE 
- the (current) code would be a bit less cryptic then.

But no big deal. Looks ok apart from that.

Thanks,
John
