Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B33C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Apr 2022 08:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240275AbiDYJCH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 05:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbiDYJCE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 05:02:04 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF0513E20;
        Mon, 25 Apr 2022 01:59:01 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KmzQB4MQmz6801v;
        Mon, 25 Apr 2022 16:56:18 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 25 Apr 2022 10:58:58 +0200
Received: from [10.47.92.213] (10.47.92.213) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.24; Mon, 25 Apr
 2022 09:58:57 +0100
Message-ID: <d09faf74-a52e-8d93-cf26-08b43b12c564@huawei.com>
Date:   Mon, 25 Apr 2022 09:58:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 1/4] scsi: core: constify pointer to scsi_host_template
To:     Christoph Hellwig <hch@infradead.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     "Ewan D. Milne" <emilne@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Doug Gilbert" <dgilbert@interlog.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <james.smart@broadcom.com>
References: <20220408103027.311624-1-krzysztof.kozlowski@linaro.org>
 <2a88a992-641a-b3ff-fe39-7a61fff87cb6@huawei.com>
 <4c3be5b6-50ef-9e9a-6cee-9642df943342@linaro.org>
 <7b3885e3-dbae-ff0b-21dc-c28d635d950b@huawei.com>
 <c121430b1b5c8f5816b2b42b9178d00889260c90.camel@redhat.com>
 <b6af3fe8-db9a-b5dc-199f-21c05d7664a2@huawei.com>
 <Yl+wJ7xSHzWmR+bR@infradead.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <Yl+wJ7xSHzWmR+bR@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.92.213]
X-ClientProxiedBy: lhreml702-chm.china.huawei.com (10.201.108.51) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/04/2022 08:03, Christoph Hellwig wrote:
>> The standard flow is:
>>
>> shost = scsi_host_alloc(sht, )
>>
>> // modify shost, like
>> shost->cmd_per_lun = 5;
>>
>> scsi_add_host(shost)
>>
>> Is there some reason for which those two drivers can't follow that?
> I think they should.  Method tables should not be mutable data.
> .

Hi Krzysztof,

Do you have any interest in going further with your work and trying to 
change all SCSI driver instances of scsi_host_template to be const? I am 
not sure if it has been attempted before...

Thanks,
John
