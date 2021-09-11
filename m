Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8655EC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 09:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AD5D610F8
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 09:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbhIKJiU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Sep 2021 05:38:20 -0400
Received: from mail-m17642.qiye.163.com ([59.111.176.42]:22156 "EHLO
        mail-m17642.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235513AbhIKJiT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Sep 2021 05:38:19 -0400
Received: from 2CD-RMPB.local (unknown [113.116.176.115])
        by mail-m17642.qiye.163.com (Hmail) with ESMTPA id E3024220121;
        Sat, 11 Sep 2021 17:37:04 +0800 (CST)
Subject: Re: [PATCH 1/3] scsi: libiscsi: move init ehwait to
 iscsi_session_setup()
To:     Mike Christie <michael.christie@oracle.com>, lduncan@suse.com,
        cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210910010220.24073-1-dinghui@sangfor.com.cn>
 <20210910010220.24073-2-dinghui@sangfor.com.cn>
 <03817f8e-8fed-6e7a-e76f-8608f8cfd979@oracle.com>
From:   Ding Hui <dinghui@sangfor.com.cn>
Message-ID: <486018fb-edf9-1f58-d911-ca7c5e9451e2@sangfor.com.cn>
Date:   Sat, 11 Sep 2021 17:37:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <03817f8e-8fed-6e7a-e76f-8608f8cfd979@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWRpOTU1WTENJSE8ZSx1KTR
        ofVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Myo6Kio*DT4TOBw6GU0*Dxo#
        ETowFDpVSlVKTUhKSE5IS0lOTktCVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKSkhVSkpNVUpMTVVKSk5ZV1kIAVlBSE1PSTcG
X-HM-Tid: 0a7bd437b28fd998kuwse3024220121
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/9/11 12:25 上午, Mike Christie wrote:
> On 9/9/21 8:02 PM, Ding Hui wrote:
>> commit ec29d0ac29be ("scsi: iscsi: Fix conn use after free during
>> resets") move member ehwait from conn to session, but left init ehwait
>> in iscsi_conn_setup().
>>
>> Due to one session can be binded by multi conns, the conn after the
> 
> A session can only have 1 conn. There is some code that makes it look
> like we can do multiple conns or swap the single conn, but it was never
> fully implemented/supported upstream.
> 
> However, I like the patch. The init should be done in iscsi_session_setup,
> so could you fix up the commit, so it's correct?
> 

Thanks，I'll update the commit log and send v2 1/3.

>> first will reinit the session->ehwait, move init ehwait to
>> iscsi_session_setup() to fix it.
>>
>> Fixes: ec29d0ac29be ("scsi: iscsi: Fix conn use after free during resets")
>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>> ---
>>   drivers/scsi/libiscsi.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 4683c183e9d4..712a45368385 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -2947,6 +2947,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
>>   	session->tmf_state = TMF_INITIAL;
>>   	timer_setup(&session->tmf_timer, iscsi_tmf_timedout, 0);
>>   	mutex_init(&session->eh_mutex);
>> +	init_waitqueue_head(&session->ehwait);
>>   
>>   	spin_lock_init(&session->frwd_lock);
>>   	spin_lock_init(&session->back_lock);
>> @@ -3074,8 +3075,6 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
>>   		goto login_task_data_alloc_fail;
>>   	conn->login_task->data = conn->data = data;
>>   
>> -	init_waitqueue_head(&session->ehwait);
>> -
>>   	return cls_conn;
>>   
>>   login_task_data_alloc_fail:
>>
> 


-- 
Thanks,
-dinghui
