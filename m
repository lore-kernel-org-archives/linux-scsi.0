Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5387CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C29020781
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:40:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VrN3W22b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgGBBj7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:39:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60000 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgGBBj7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 21:39:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621bd21037967;
        Thu, 2 Jul 2020 01:39:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=K0cjENwJfofYHwlQl6+HWAzbZOpEktHjcP+nnYxMS/w=;
 b=VrN3W22bCCTntPV24UDnn774HrICI4xJP506Q4bI+CG1xgmubcM5kQB6tONVU9QP5ppq
 jnvTBUM0A5VICzPq3DPGchsrR3PlVwyPoy4j6C4yzhLANV0HQZw+5iNLNynx2bRZpzUV
 qK+MK7bxb5Bf6OZdGRVjzgWWra0tQAtwRqLYd7n1SV85030kRHbBQmeXTOB4XV+VvHC9
 BBPBTiOlgbbFGDKZKMBd/ErbXTt5lUCaVrV2PwV37lpK5SqAi9nkHnaBcHiRaLsD8enA
 5uX4j383/ut7Ynu1Kdv7kfltGJtdp4vAb/QQLjzGh4kHKyV67s/l/Lz2vG6puicGaqWg Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31ywrbuw2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 01:39:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621bqvX181510;
        Thu, 2 Jul 2020 01:37:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31xg204p7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 01:37:52 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0621bj9f019766;
        Thu, 2 Jul 2020 01:37:45 GMT
Received: from [20.15.0.2] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 01:37:44 +0000
Subject: Re: [PATCH 2/3] iscsi class: optimize work queue flush use
To:     Lee Duncan <lduncan@suse.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <1593632868-6808-1-git-send-email-michael.christie@oracle.com>
 <1593632868-6808-3-git-send-email-michael.christie@oracle.com>
 <aec9871e-838c-731c-11ff-7b7ae04bffe9@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <64d3519b-6343-c20a-1d72-e5cf0e9a67ab@oracle.com>
Date:   Wed, 1 Jul 2020 20:37:43 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <aec9871e-838c-731c-11ff-7b7ae04bffe9@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/1/20 3:55 PM, Lee Duncan wrote:
> On 7/1/20 12:47 PM, Mike Christie wrote:
>> There is no need for one session to flush the entire
>> iscsi_eh_timer_workq when removing/unblocking a session. During removal
>> we need to make sure our works are not running anymore. And
>> iscsi_unblock_session only needs to make sure it's work is done. The
>> unblock work function will flush/cancel the works it has conflicts with.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/scsi/scsi_transport_iscsi.c | 15 +++++++--------
>>  1 file changed, 7 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
>> index 2cd2610ecfaf..80b442a2b4c8 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -1978,10 +1978,11 @@ void iscsi_unblock_session(struct iscsi_cls_session *session)
>>  {
>>  	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
>>  	/*
>> -	 * make sure all the events have completed before tell the driver
>> -	 * it is safe
>> +	 * Blocking the session can be done from any context so we only
>> +	 * queue the block work. Make sure the unblock work has completed
>> +	 * because it flushes/cancels the other works and updates the state.
>>  	 */
>> -	flush_workqueue(iscsi_eh_timer_workq);
>> +	flush_work(&session->unblock_work);
>>  }
>>  EXPORT_SYMBOL_GPL(iscsi_unblock_session);
>>  
>> @@ -2205,11 +2206,9 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
>>  	list_del(&session->sess_list);
>>  	spin_unlock_irqrestore(&sesslock, flags);
>>  
>> -	/* make sure there are no blocks/unblocks queued */
>> -	flush_workqueue(iscsi_eh_timer_workq);
>> -	/* make sure the timedout callout is not running */
>> -	if (!cancel_delayed_work(&session->recovery_work))
>> -		flush_workqueue(iscsi_eh_timer_workq);
>> +	flush_work(&session->block_work);
>> +	flush_work(&session->unblock_work);
>> +	cancel_delayed_work_sync(&session->recovery_work);
>>  	/*
>>  	 * If we are blocked let commands flow again. The lld or iscsi
>>  	 * layer should set up the queuecommand to fail commands.
>>
> 
> Is the error handler timer work queue still get flushed? (Sorry if this
> is a dumb question), or is that covered in the other flush()es?

No. We don't flush the entire workqueue anymore with this patch. Everyone flushes their specific work on the work queue.

On rmmod the destroy call does a flush, but there shouldn't be any thing on there.
