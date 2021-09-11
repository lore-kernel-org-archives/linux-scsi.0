Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D8CC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 09:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ED7360F24
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 09:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbhIKJxR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Sep 2021 05:53:17 -0400
Received: from mail-m17642.qiye.163.com ([59.111.176.42]:34804 "EHLO
        mail-m17642.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbhIKJxQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Sep 2021 05:53:16 -0400
Received: from 2CD-RMPB.local (unknown [113.116.176.115])
        by mail-m17642.qiye.163.com (Hmail) with ESMTPA id 1370B22012B;
        Sat, 11 Sep 2021 17:52:02 +0800 (CST)
Subject: Re: [PATCH 2/3] scsi: libiscsi: fix invalid pointer dereference in
 iscsi_eh_session_reset
To:     Mike Christie <michael.christie@oracle.com>, lduncan@suse.com,
        cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210910010220.24073-1-dinghui@sangfor.com.cn>
 <20210910010220.24073-3-dinghui@sangfor.com.cn>
 <302af74d-5b72-5b2f-050a-33f0978e321f@oracle.com>
From:   Ding Hui <dinghui@sangfor.com.cn>
Message-ID: <2863c857-7121-1e96-0c28-d7f697b99ef7@sangfor.com.cn>
Date:   Sat, 11 Sep 2021 17:52:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <302af74d-5b72-5b2f-050a-33f0978e321f@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWRpMTUNWQ00ZGkJPHR0dTU
        8ZVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PT46Qzo5DD4LAhxCGD48Ikg6
        I0owFClVSlVKTUhKSE5IQklJTU1PVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKSkhVSkpNVUpMTVVKSk5ZV1kIAVlBSE1DTDcG
X-HM-Tid: 0a7bd4456332d998kuws1370b22012b
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/9/11 12:38 上午, Mike Christie wrote:
> On 9/9/21 8:02 PM, Ding Hui wrote:
>> like commit 5db6dd14b313 ("scsi: libiscsi: Fix NULL pointer dereference in
>> iscsi_eh_session_reset"), access conn->persistent_address here is not safe
>> too.
>>
>> The persistent_address is independent of conn refcount, so maybe
>> already freed by iscsi_conn_teardown(), also we put the refcount of conn
>> above, the conn pointer may be invalid.
> 
> This shouldn't happen like you describe above, because when we wake up
> we will see the session->state is ISCSI_STATE_TERMINATE. We will then
> not reference the conn in that code below.
> 
> However, it looks like we could hit an issue where if a user was resetting
> the persistent_address or targetname via iscsi_set_param -> iscsi_switch_str_param
> then we could be accessing freed memory. I think we need the frwd_lock when swapping
> the strings in iscsi_switch_str_param.
> 

Thanks for your detailed explanation, I'll drop 2/3 and 3/3 in v2 patch.
I expect that the persistent_address issue be fixed in your future patchset.

Sorry for my ignorance.

> 
>>
>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>> ---
>>   drivers/scsi/libiscsi.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 712a45368385..69b3b2148328 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -2531,8 +2531,8 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
>>   	spin_lock_bh(&session->frwd_lock);
>>   	if (session->state == ISCSI_STATE_LOGGED_IN) {
>>   		ISCSI_DBG_EH(session,
>> -			     "session reset succeeded for %s,%s\n",
>> -			     session->targetname, conn->persistent_address);
>> +			     "session reset succeeded for %s\n",
>> +			     session->targetname);
>>   	} else
>>   		goto failed;
>>   	spin_unlock_bh(&session->frwd_lock);
>>
> 


-- 
Thanks,
-dinghui
