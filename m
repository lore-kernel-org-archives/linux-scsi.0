Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB7BC18E5A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 12:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C27D20828
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 12:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgCIMso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 08:48:44 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2526 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725956AbgCIMsn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Mar 2020 08:48:43 -0400
Received: from LHREML711-CAH.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 6D07181F16F24DB3B6A6;
        Mon,  9 Mar 2020 12:48:42 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML711-CAH.china.huawei.com (10.201.108.34) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 9 Mar 2020 12:48:42 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 9 Mar 2020
 12:48:41 +0000
Subject: Re: [PATCH RFC 00/24] scsi: enable reserved commands for LLDDs
From:   John Garry <john.garry@huawei.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, "Ming Lei" <ming.lei@redhat.com>
References: <20190529132901.27645-1-hare@suse.de>
 <e5c2b01a-71d9-ef94-3bf6-0830d866e4cf@huawei.com>
Message-ID: <801604cd-d51f-2a4a-0e68-b6fcff9c9974@huawei.com>
Date:   Mon, 9 Mar 2020 12:48:41 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <e5c2b01a-71d9-ef94-3bf6-0830d866e4cf@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/08/2019 14:26, John Garry wrote:
>>
>> quite some drivers use internal commands for various purposes, most
>> commonly sending TMFs or querying the HBA status.
>> While these commands use the same submission mechanism than normal
>> I/O commands, they will not be counted as outstanding commands,
>> requiring those drivers to implement their own mechanism to figure
>> out outstanding commands.
>> This patchset enables the use of reserved tags for the SCSI midlayer,
>> enabling LLDDs to rely on the block layer for tracking outstanding
>> commands.
>> More importantly, it allows LLDD to request a valid tag from the block
>> layer without having to implement some tracking mechanism within the
>> driver. This removes quite some hacks which were required for some
>> drivers (eg. fnic or snic).
>>
>> As usual, comments and reviews are welcome.
>>
> 
Hi Hannes,

JFYI, I have rebased this series to 5.6-rc4 here:

https://github.com/hisilicon/kernel-dev/tree/private-topic-sas-5.6-resv-commands-v1

I am interested in enabling this for libsas and associated HBAs, so 
there are some patches on top for that.

No review comments have been addressed, apart from removing "block: 
disable elevator for reserved tags"

Please let me know your plan for this series.

Thanks,
John

> 
> I was wondering if you have any plans to progress this series?
> 
> I don't mind helping out...
> 
> Cheers,
> John
> 
>> Hannes Reinecke (24):
>>   block: disable elevator for reserved tags
>>   scsi: add scsi_{get,put}_reserved_cmd()
>>   scsi: add 'nr_reserved_cmds' field to the SCSI host template
>>   csiostor: use reserved command for LUN reset
>>   scsi: add scsi_cmd_from_priv()
>>   virtio_scsi: use reserved commands for TMF
>>   scsi: add host tagset busy iterator
>>   fnic: use reserved commands
>>   fnic: use scsi_host_tagset_busy_iter() to traverse commands
>>   scsi: allocate separate queue for reserved commands
>>   scsi: add scsi_host_get_reserved_cmd()
>>   hpsa: move hpsa_hba_inquiry after scsi_add_host()
>>   hpsa: use reserved commands 

