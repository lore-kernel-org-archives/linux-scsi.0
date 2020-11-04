Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A671C2D0A3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 21:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 248FF20870
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 21:37:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OJXYvYb0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgKDVhn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 16:37:43 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37486 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgKDVhn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 16:37:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4L9BEO029826;
        Wed, 4 Nov 2020 21:37:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=P1HGoiNjFAgbuQ2OXKElhEpImKJv9SIECIanK4JrJgk=;
 b=OJXYvYb0IZzPwb+TK8ScFxIUMl18qN46LGXc7eeknbZ5+NRMFrGjuuzRUvKidmCE8r2j
 l4g1IxwjlEP1++y/WFWfrTE/Zdwa76tv46+i9nazw1E20vhlp2+LabqC96LUq3ANf8XV
 50W+5FUZl6mRnckIege15maEHmJb/j59NM2+ms3eLocAw/p+JRlPDhdVY9aFlnD9YuET
 QQz9na6k+CuyWsrBRFa3Pyb0yNQc2fwi9v6yS7bK2+jvM+hLBQx/L6xPsmxvdjsRwFYH
 TTX+3DFzt1SVMEYeHAEjUJZX4RSVdpB3vyNZjneFRjbJ78Ltt/vYvK+fByw1AMg37IsB vA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34hhw2s0y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 04 Nov 2020 21:37:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4LArJd004445;
        Wed, 4 Nov 2020 21:37:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34jf4b1d6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Nov 2020 21:37:36 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A4LbZ6N011032;
        Wed, 4 Nov 2020 21:37:35 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 13:37:35 -0800
Subject: Re: [PATCH] scsi: libiscsi: fix NOP race condition
From:   Mike Christie <michael.christie@oracle.com>
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org
Cc:     open-iscsi@googlegroups.com, Lee Duncan <lduncan@suse.com>
References: <20200918210947.23800-1-leeman.duncan@gmail.com>
 <f0c9b3ff-7d93-9c2b-d405-e52fb4aa8c37@oracle.com>
Message-ID: <e8bc1385-7e8d-40e5-76ab-0086fcd1ea12@oracle.com>
Date:   Wed, 4 Nov 2020 15:37:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <f0c9b3ff-7d93-9c2b-d405-e52fb4aa8c37@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=2 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/20 3:33 PM, Mike Christie wrote:
> On 9/18/20 4:09 PM, Lee Duncan wrote:
>> From: Lee Duncan <lduncan@suse.com>
>>
>> iSCSI NOPs are sometimes "lost", mistakenly sent to the
>> user-land iscsid daemon instead of handled in the kernel,
>> as they should be, resulting in a message from the daemon like:
>>
>>> iscsid: Got nop in, but kernel supports nop handling.
>>
>> This can occur because of the new forward- and back-locks,
>> and the fact that an iSCSI NOP response can occur before
>> processing of the NOP send is complete. This can result
>> in "conn->ping_task" being NULL in iscsi_nop_out_rsp(),
>> when the pointer is actually in the process of being set.
>>
>> To work around this, we add a new state to the "ping_task"
>> pointer. In addition to NULL (not assigned) and a pointer
>> (assigned), we add the state "being set", which is signaled
>> with an INVALID pointer (using "-1").
>>
>> Signed-off-by: Lee Duncan <lduncan@suse.com>
>> ---
>>   drivers/scsi/libiscsi.c | 11 ++++++++++-
>>   include/scsi/libiscsi.h |  3 +++
>>   2 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 1e9c3171fa9f..5eb064787ee2 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -738,6 +738,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, 
>> struct iscsi_hdr *hdr,
>>                              task->conn->session->age);
>>       }
>> +    if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
>> +        WRITE_ONCE(conn->ping_task, task);
>> +
>>       if (!ihost->workq) {
>>           if (iscsi_prep_mgmt_task(conn, task))
>>               goto free_task;
>> @@ -941,6 +944,11 @@ static int iscsi_send_nopout(struct iscsi_conn 
>> *conn, struct iscsi_nopin *rhdr)
>>           struct iscsi_nopout hdr;
>>       struct iscsi_task *task;
>> +    if (!rhdr) {
>> +        if (READ_ONCE(conn->ping_task))
>> +            return -EINVAL;
>> +        WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
>> +    }
>>       if (!rhdr && conn->ping_task)
>>           return -EINVAL;
>> @@ -957,11 +965,12 @@ static int iscsi_send_nopout(struct iscsi_conn 
>> *conn, struct iscsi_nopin *rhdr)
>>       task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, 
>> NULL, 0);
>>       if (!task) {
>> +        if (!rhdr)
>> +            WRITE_ONCE(conn->ping_task, NULL);
> 
> I don't think you need this. If __iscsi_conn_send_pdu returns NULL, it 
> will have done __iscsi_put_task and done this already.

Ignore that. That is iscsi_complete_task that would do it.

> 
>>           iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
>>           return -EIO;
>>       } else if (!rhdr) {
>>           /* only track our nops */
>> -        conn->ping_task = task;
>>           conn->last_ping = jiffies;
>>       }
> 
> Why in the send path do we always use the READ_ONCE/WRITE_ONCE, but in 
> the completion path like in iscsi_complete_task we don't.

