Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E808C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 10:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A1E619A6
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 10:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbhHPKBv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 06:01:51 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3652 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbhHPKBP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 06:01:15 -0400
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gp8lj6C3Bz6BGZr;
        Mon, 16 Aug 2021 17:59:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 16 Aug 2021 12:00:31 +0200
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 16 Aug 2021 11:00:30 +0100
Subject: Re: [PATCH 2/3] scsi: fnic: Stop setting scsi_cmnd.tag
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        "Bart Van Assche" <bvanassche@acm.org>
CC:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
 <1628862553-179450-3-git-send-email-john.garry@huawei.com>
 <3e5d1bd4-cee9-7fd0-93a4-58d808e198f6@acm.org>
 <20210814073948.GA21536@lst.de>
 <b6216e3f-5339-18e4-ca31-61c7968efbb1@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2e6dd74f-bd5a-22b8-f20b-d4b54fc4ade3@huawei.com>
Date:   Mon, 16 Aug 2021 11:00:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <b6216e3f-5339-18e4-ca31-61c7968efbb1@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/08/2021 13:35, Hannes Reinecke wrote:
> On 8/14/21 9:39 AM, Christoph Hellwig wrote:
>> On Fri, Aug 13, 2021 at 08:17:45PM -0700, Bart Van Assche wrote:
>>> On 8/13/21 6:49 AM, John Garry wrote:
>>>> It is never read. Setting it and the request tag seems dodgy
>>>> anyway.
>>>
>>> This is done because there is code in the SCSI error handler that may
>>> allocate a SCSI command without allocating a tag. See also
>>> scsi_ioctl_reset().

Right, so we just get a loan of the tag of a real request. fnic driver 
comment:

"Really should fix the midlayer to pass in a proper request for ioctls..."

>>
>> Yes.  Hannes had a great series to stop passing the pointless scsi_cmnd
>> to the reset methods.  Hannes, any chance you coul look into
>> resurrecting that?
>>
> Sure.

The latest iteration of that series - at v7 - still passed that fake 
SCSI command to the reset method, and the reset method allocated the 
internal command.

So will we change change scsi_ioctl_reset() to allocate an internal 
command, rather than the LLDD?

Thanks,
John
