Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED11C83000
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 13:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45FDD206F0
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 13:28:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DuqLuIjM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgD1N2H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 09:28:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38814 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgD1N2G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 09:28:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SDNGGt022298;
        Tue, 28 Apr 2020 13:28:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dTovGO/qdAKbgiUhE91SR5fqVYU4V+x+t560EnksCrE=;
 b=DuqLuIjMmmrNXvtQxa1YelI8Cd7YbmTPTCp0ru2Ug93/pT5vFbaKKpRt3PEiwtQ4p0Bu
 It+MXOo1wMl66iGDy4DEVsejzpwV9XORMhKoW+7DFG5JQt/q3ntQrl8+1gVsVoZwCjBK
 QZirZGZ1nM9IK//jeCbQEcfMW1pT2+jqLMig89TN+Bk6tyrkSfmzevPkCJRca5ilkA4G
 JNA6pX1ersTWGKXU8Zisyv9qa8uh5chceOT994iSpwChTmBqNKNh9z6pAJKVn6WTxNvy
 ewJCmypgymxyF47w0bOJVUoJ0zMYU+9+adpQlkIdOv992EaHMhi59b6B1g7/Sg7MQItb cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30p2p05a5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 13:27:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SDRtlH146263;
        Tue, 28 Apr 2020 13:27:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30mxwysd0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 13:27:59 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SDRwNb013689;
        Tue, 28 Apr 2020 13:27:58 GMT
Received: from [192.168.1.14] (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 06:27:58 -0700
Subject: Re: [PATCH v2] scsi: iscsi: register sysfs for iscsi workqueue
To:     Julian Wiedmann <jwi@linux.ibm.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
References: <20200417111545.30437-1-bob.liu@oracle.com>
 <3c1e425c-d889-6585-0fd8-620c4d6c0d06@linux.ibm.com>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <87459628-d189-6521-2012-e703af9eff91@oracle.com>
Date:   Tue, 28 Apr 2020 21:27:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <3c1e425c-d889-6585-0fd8-620c4d6c0d06@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=2 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1011
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=2 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280105
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sorry forgot Cc iscsi maintainers.

On 4/28/20 6:56 PM, Julian Wiedmann wrote:
> On 17.04.20 13:15, Bob Liu wrote:
>> Then users can set cpu affinity through "cpumask" for iscsi workqueues, so
>> as to get performance isolation.
>>
>> This patch changes the max number of active worker form 1 to 2,
>> since ordered workqueue wont' be allowed to change "cpumask".
>>
> 
> Won't having 2 workers break the current ordering guarantees?

Yes.

> Did you check that no-one depends on this?
> 

Not quite sure, I'd better add [rfc] to this patch.
But this is the easiest way to set cpu affinity of iscsi workqueue.

>> Signed-off-by: Bob Liu <bob.liu@oracle.com>
>> ---
>>  drivers/scsi/libiscsi.c             | 4 +++-
>>  drivers/scsi/scsi_transport_iscsi.c | 4 +++-
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 70b99c0..adf9bb4 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -2627,7 +2627,9 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
>>  	if (xmit_can_sleep) {
>>  		snprintf(ihost->workq_name, sizeof(ihost->workq_name),
>>  			"iscsi_q_%d", shost->host_no);
>> -		ihost->workq = create_singlethread_workqueue(ihost->workq_name);
>> +		ihost->workq = alloc_workqueue("%s",
>> +			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
>> +			2, ihost->workq_name);
> 
> From looking at the documentation, __WQ_LEGACY doesn't seem to belong here.
> 

Indeed, thanks for the review.

>>  		if (!ihost->workq)
>>  			goto free_host;
>>  	}
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
>> index dfc726f..bdbc4a2 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -4602,7 +4602,9 @@ static __init int iscsi_transport_init(void)
>>  		goto unregister_flashnode_bus;
>>  	}
>>  
>> -	iscsi_eh_timer_workq = create_singlethread_workqueue("iscsi_eh");
>> +	iscsi_eh_timer_workq = alloc_workqueue("%s",
>> +			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
>> +			2, "iscsi_eh");
>>  	if (!iscsi_eh_timer_workq) {
>>  		err = -ENOMEM;
>>  		goto release_nls;
>>
> 

