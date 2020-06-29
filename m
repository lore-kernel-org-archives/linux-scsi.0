Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92BCC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B08DC206E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731644AbgF2WLL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 18:11:11 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2415 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726129AbgF2WLK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 18:11:10 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 993DB76561ED7D5AD258;
        Mon, 29 Jun 2020 15:25:46 +0100 (IST)
Received: from [127.0.0.1] (10.210.170.8) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 29 Jun
 2020 15:25:45 +0100
Subject: Re: [PATCH 03/22] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Don Brace <don.brace@microchip.de>,
        <linux-scsi@vger.kernel.org>
References: <20200625140124.17201-1-hare@suse.de>
 <20200625140124.17201-4-hare@suse.de>
 <863b7da2-bbfc-a32f-87ab-648f8561314c@acm.org>
 <7a52763c-eb51-7c63-8d06-b0cc2eab6630@suse.de>
 <e5964b6d-43c1-a14d-c791-4b5826eb2ee8@acm.org>
 <9793e936-cf51-2d6a-fccd-4a4b9c8cae02@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9a9c6f92-8653-138b-f00b-91a3117bc9e1@huawei.com>
Date:   Mon, 29 Jun 2020 15:24:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <9793e936-cf51-2d6a-fccd-4a4b9c8cae02@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.170.8]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/06/2020 07:32, Hannes Reinecke wrote:
>>
>> That sounds fair to me, but is an example available in this patch series
>> of a call to scsi_put_internal_cmd() from such a common routine? It
>> seems to me that all calls to scsi_put_internal_cmd() introduced in this
>> patch series happen from code paths that handle internal commands only?
>>

Ah, I commented on the same thing in your latest series.

> aacraid.
> The function aac_fib_free() is called unconditionally for every fib, and 
> doesn't have the means to differentiate between 'normal' and 'internal' 
> commands.
> 
Surely some fib structure flag could be set in aac_fib_alloc() for this.

Thanks
