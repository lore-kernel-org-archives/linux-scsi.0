Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45284C43457
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 20:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4D8322241
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 20:54:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rx0mdCEy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730814AbgJHUyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 16:54:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58896 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgJHUyp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2020 16:54:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098Ko1ik177988;
        Thu, 8 Oct 2020 20:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0UrPukTFX1Z7kaEleosD+wgwp8yeWbRUVs/KYLs/Wx4=;
 b=Rx0mdCEym/ZOjzA5qv+8tVgkyMjyZISU+doDjT8jD88Q4FIvBeOy1NJbHW/xRyGkBOIO
 n6bIsrqnYcQDeQ+NOrzjQnT9bOmBg4x4+XasIpB1rN5eQn09dbAOLxyvTUHW8r6aztAG
 w3nd0uOKXfAotzHWB0VZxXZcuJQKcCIdzJmDaghXdlBZ7+LJ8A/WX0tGoKdNhASbdE6J
 PlDu+TJTkt5F6OLn3al2FmjYNxPVkSH7uS844B7ttYGeagaqnGxn9QWHPewhBzC9N1+U
 RzzqhCpi/EznCIqi9CWFwpP0OsgWu/Ofb0m56Yziv0npIeuzWaMt/yXxeRl1eyhlXqJK 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3429jur7jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 20:54:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098KkE6X048228;
        Thu, 8 Oct 2020 20:54:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3429k0989b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 20:54:38 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098KsbAe016639;
        Thu, 8 Oct 2020 20:54:38 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 13:54:37 -0700
Subject: Re: [PATCH v2 1/1] scsi: libiscsi: fix NOP race condition
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com,
        martin.petersen@oracle.com, mchristi@redhat.com, hare@suse.com
References: <cover.1601058301.git.lduncan@suse.com>
 <02b452b2e33d0728091d27d44794934c134a803e.1601058301.git.lduncan@suse.com>
 <5e1fb4eb-dd10-dbad-3da9-e8affc4f5cf0@oracle.com>
Message-ID: <47eca384-b54e-63cc-0f84-7ed6501f427e@oracle.com>
Date:   Thu, 8 Oct 2020 15:54:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5e1fb4eb-dd10-dbad-3da9-e8affc4f5cf0@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=2 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010080147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 bulkscore=0 suspectscore=2 lowpriorityscore=0 spamscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010080147
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/8/20 12:11 PM, Mike Christie wrote:
> On 9/25/20 1:41 PM, lduncan@suse.com wrote:
>> From: Lee Duncan <lduncan@suse.com>
>>
>> iSCSI NOPs are sometimes "lost", mistakenly sent to the
>> user-land iscsid daemon instead of handled in the kernel,
>> as they should be, resulting in a message from the daemon like:
>>
>>> iscsid: Got nop in, but kernel supports nop handling.
>>
>> This can occur because of the forward- and back-locks
>> in the kernel iSCSI code, and the fact that an iSCSI NOP
>> response can be processed before processing of the NOP send
>> is complete. This can result in "conn->ping_task" being NULL
>> in iscsi_nop_out_rsp(), when the pointer is actually in
>> the process of being set.
>>
>> To work around this, we add a new state to the "ping_task"
>> pointer. In addition to NULL (not assigned) and a pointer
>> (assigned), we add the state "being set", which is signaled
>> with an INVALID pointer (using "-1").
>>
>> Signed-off-by: Lee Duncan <lduncan@suse.com>
>> ---
>>  drivers/scsi/libiscsi.c | 13 ++++++++++---
>>  include/scsi/libiscsi.h |  3 +++
>>  2 files changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 1e9c3171fa9f..cade108c33b6 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -738,6 +738,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>>  						   task->conn->session->age);
>>  	}
>>  
>> +	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
>> +		WRITE_ONCE(conn->ping_task, task);
>> +
>>  	if (!ihost->workq) {
>>  		if (iscsi_prep_mgmt_task(conn, task))
>>  			goto free_task;
> 
> I think the API gets a little weird now where in some cases
> __iscsi_conn_send_pdu checks the opcode to see what type of request
> it is but above we the caller sets the ping_task.
> 
> For login, tmfs and passthrough, we assume the __iscsi_conn_send_pdu
> has sent or cleaned up everything. I think it might be nicer to just
> have __iscsi_conn_send_pdu set the ping_task field before doing the
> xmit/queue call. It would then work similar to the conn->login_task
> case where that function knows about that special task too.
> 
> So in __iscsi_conn_send_pdu add a "if (opcode == ISCSI_OP_NOOP_OUT)",
> and check if it's a nop we need to track. If so set conn->ping_task.
> 
Ignore this. It won't work nicely either. To figure out if the nop is
our internal transport test ping vs a userspace ping that also needs
a reply, we would need to do something like you did above so there is
no point.
