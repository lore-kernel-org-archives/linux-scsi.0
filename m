Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C644C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 11:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbiBOLKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 06:10:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235732AbiBOLKB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 06:10:01 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C143D107ABF
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 03:09:51 -0800 (PST)
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jydd61Mjvz67y8D;
        Tue, 15 Feb 2022 19:08:58 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 12:09:49 +0100
Received: from [10.47.81.62] (10.47.81.62) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Tue, 15 Feb
 2022 11:09:49 +0000
Message-ID: <7672bdd5-e2e9-0716-6487-5e2f76c8269c@huawei.com>
Date:   Tue, 15 Feb 2022 11:09:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 20/31] scsi: pm8001: Fix tag values handling
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>, <jinpu.wang@ionos.com>,
        Ajish Koshy <Ajish.Koshy@microchip.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-21-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220214021747.4976-21-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.62]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/02/2022 02:17, Damien Le Moal wrote:
> @@ -1685,19 +1683,13 @@ void pm8001_work_fn(struct work_struct *work)
>   		struct task_status_struct *ts;
>   		struct sas_task *task;
>   		int i;
> -		u32 tag, device_id;
> +		u32 device_id;
>   
>   		for (i = 0; ccb = NULL, i < PM8001_MAX_CCB; i++) {
>   			ccb = &pm8001_ha->ccb_info[i];
>   			task = ccb->task;
>   			ts = &task->task_status;
> -			tag = ccb->ccb_tag;
> -			/* check if tag is NULL */
> -			if (!tag) {
> -				pm8001_dbg(pm8001_ha, FAIL,
> -					"tag Null\n");
> -				continue;
> -			}
> +

This looks so dodgy that maybe it is intentional. I think experts on 
this HW/driver need to check this further.

Thanks,
John
