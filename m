Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35869C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Nov 2022 14:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbiK1Ol5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Nov 2022 09:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiK1Olb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2022 09:41:31 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EBC1F637
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2022 06:41:30 -0800 (PST)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NLSnZ5DpRzRpQQ;
        Mon, 28 Nov 2022 22:40:50 +0800 (CST)
Received: from dggpemm500017.china.huawei.com (7.185.36.178) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 28 Nov 2022 22:41:28 +0800
Received: from [10.174.178.220] (10.174.178.220) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 28 Nov 2022 22:41:27 +0800
Message-ID: <ada12c1d-b732-59a9-8dba-1662673b6a5d@huawei.com>
Date:   Mon, 28 Nov 2022 22:41:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [QUESTION]: Why did we clear the lowest bit of SCSI command's
 status in scsi_status_is_good
Content-Language: en-US
To:     <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linfeilong@huawei.com>,
        <yanaijie@huawei.com>, <xuhujie@huawei.com>, <lijinlin3@huawei.com>
References: <6e9ea80e-d4e0-6d52-47c1-8939c13d60a8@huawei.com>
 <ca7e2aba5db5bd6e15182070f26e0c2c77c70927.camel@linux.ibm.com>
From:   Wenchao Hao <haowenchao@huawei.com>
In-Reply-To: <ca7e2aba5db5bd6e15182070f26e0c2c77c70927.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggpeml100023.china.huawei.com (7.185.36.151) To
 dggpemm500017.china.huawei.com (7.185.36.178)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/11/28 20:52, James Bottomley wrote:
> On Mon, 2022-11-28 at 11:58 +0800, Wenchao Hao wrote:
>> static inline bool scsi_status_is_good(int
>> status)                                                              
>>                                                                      
>>                           
>> {
>>         if (status < 0)
>>                 return false;
>>
>>         if (host_byte(status) == DID_NO_CONNECT)
>>                 return false;
>>
>>         /*  
>>          * FIXME: bit0 is listed as reserved in SCSI-2, but is
>>          * significant in SCSI-3.  For now, we follow the SCSI-2
>>          * behaviour and ignore reserved bits.
>>          */
>>         status &= 0xfe;
>>         return ((status == SAM_STAT_GOOD) ||
>>                 (status == SAM_STAT_CONDITION_MET) ||
>>                 /* Next two "intermediate" statuses are obsolete in
>> SAM-4 */
>>                 (status == SAM_STAT_INTERMEDIATE) ||
>>                 (status == SAM_STAT_INTERMEDIATE_CONDITION_MET) ||
>>                 /* FIXME: this is obsolete in SAM-3 */
>>                 (status == SAM_STAT_COMMAND_TERMINATED));
>> }
>> We have function defined in include/scsi/scsi.h as above, which is
>> used to check if the status in result is good.
>>
>> But the function cleared the lowest bit of SCSI command's status,
>> which would translate an undefined status to good in some condition,
>> for example the status is 0x1.
>>
>> This code seems introduced in this patch:
>> https://lore.kernel.org/all/1052403312.2097.35.camel@mulgrave/
>>
>> Is anyone who knows why did we clear the lowest bit? 
> 
> It says why in the comment you quote above ... what is unclear about
> it?
> 
>> We found some firmware or drivers would return status which did not
>> defined in SAM. Now SCSI middle level do not have an uniform behavior
>> for these undefined status. I want to change the logic to return
>> error for all status which did not defined in SAM or define a method
>> in host template to let drivers to judge what to do in this
>> condition.
> 
> Why? The general rule of thumb is be strict in what you emit and
> generous in what you receive (which is why reserved bits are ignored).
> Is the drive you refer to above not working in some way, in which case
> detail it so people can understand the actual problem.
> 
> James
> 
> .


We come with an issue with megaraid_sas driver. Where scsi_cmnd is completed with result's
status byte set to 1, scsi_io_completion() would finish this scsi_cmnd's request with BLK_STS_OK.
The path is:

scsi_io_completion()
	scsi_io_completion_nz_result()
		scsi_status_is_good()	->  return true
		result = 0;
		*blk_statp = BLK_STS_OK
	scsi_end_request() with BLK_STS_OK

While the scsi_cmnd result is actually wrong and should be finished with BLK_STS_IOERR.


What's more, according to code analysis, we found for scsi_cmnd which completed with status byte
undefined in SAM, the scsi_status_is_good() behave differently. For example, if status byte is in
0x1, 0x3, 0x5, 0x9 and so on, it would return true; while for status in other reserved field,
it would return false. 

So I think we should respect the SAM and drop the line "status &= 0xfe" in scsi_status_is_good()
to tell the caller the status is not good for all status which is not defined in SAM, so
scsi_result_to_blk_status() would return BLK_STS_IOERR on this condition.
