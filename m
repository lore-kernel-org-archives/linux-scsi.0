Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C24FC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09A96208B3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgGTCHT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 22:07:19 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42042 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbgGTCHT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jul 2020 22:07:19 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 559488765EB5FCFC14C9;
        Mon, 20 Jul 2020 10:07:16 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.16) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 10:07:01 +0800
Subject: Re: [PATCH v2] scsi: scsi_transport_sas: add missing newline when
 printing 'enable' by sysfs
To:     Bart Van Assche <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <john.garry@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <guohanjun@huawei.com>
References: <1594975472-12486-1-git-send-email-wangxiongfeng2@huawei.com>
 <88b08a41-55b2-ae5d-fbe5-24439429855f@acm.org>
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
Message-ID: <be74553e-24a1-5d2b-beb6-59cca1599450@huawei.com>
Date:   Mon, 20 Jul 2020 10:07:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <88b08a41-55b2-ae5d-fbe5-24439429855f@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.16]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 2020/7/19 4:25, Bart Van Assche wrote:
> On 2020-07-17 01:44, Xiongfeng Wang wrote:
>> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
>> index 182fd25..e443dee 100644
>> --- a/drivers/scsi/scsi_transport_sas.c
>> +++ b/drivers/scsi/scsi_transport_sas.c
>> @@ -563,7 +563,7 @@ static ssize_t do_sas_phy_enable(struct device *dev,
>>  {
>>  	struct sas_phy *phy = transport_class_to_phy(dev);
>>  
>> -	return snprintf(buf, 20, "%d", phy->enabled);
>> +	return snprintf(buf, 20, "%d\n", phy->enabled);
>>  }
> 
> For future sysfs show function patches, please use PAGE_SIZE as second
> snprintf() argument or use sprintf() instead of snprintf() because in
> this case it is clear that no output buffer overflow will happen. Using

Thanks for your advice. I will follow it in the future patches.

> any other size argument than PAGE_SIZE makes patches like the above
> harder to verify than necessary. Anyway:
> 
> Reviewed-by: Bart van Assche <bvanassche@acm.org>

Thanks,
Xiongfeng

> 

