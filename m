Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FF8C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95A8B20748
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:32:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QOwKTU9c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgGBBcx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:32:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45492 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729371AbgGBBcv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 21:32:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621WfTa136986;
        Thu, 2 Jul 2020 01:32:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vaZaX1ir5Zb1TVHSIoFRZjKaxeNs0OKZeLdBYH3VCtA=;
 b=QOwKTU9caKOjWO0S6h20YfbZFG2YdyB+Br6Ofz2hw+RFQWoHrVXwcL9dp33eQGti2vC5
 uNVHGIuFhlOy0vg3Et0gs2TfaBc7mavPQiuL74Th2u+zho9z4cedq07fb5QO5FGoyhEL
 Mr8dAOjOvv9UDG114mkveRn5GbLLB2tLKS3Z87J7s7eKGHjMhjwvCpHSMJ95b6X+Ga//
 ExRVPcFHrZwbeqaR4hES78SAAn2an/wrQLKvYQCXYO3gieswVZfrJ555MzaRcZIA02rX
 2FuMSBplDVOkyd5SYE8I9gD6oVSgQ1EKZFjYn95Mx2+SdOSTJ2Z5uIMDUieGh5QWwr3O 9w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrndmt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 01:32:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621Nqes099091;
        Thu, 2 Jul 2020 01:32:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31xg204jay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 01:32:43 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0621WdIF018036;
        Thu, 2 Jul 2020 01:32:42 GMT
Received: from [20.15.0.2] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 01:32:39 +0000
Subject: Re: [PATCH 3/3] iscsi class: remove sessdestroylist
To:     Lee Duncan <lduncan@suse.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <1593632868-6808-1-git-send-email-michael.christie@oracle.com>
 <1593632868-6808-4-git-send-email-michael.christie@oracle.com>
 <986df663-f499-9a18-2fb2-d2f06b01c078@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <4f538077-bd06-de66-9b0d-f86ec982beb2@oracle.com>
Date:   Wed, 1 Jul 2020 20:32:38 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <986df663-f499-9a18-2fb2-d2f06b01c078@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/1/20 3:56 PM, Lee Duncan wrote:
> On 7/1/20 12:47 PM, Mike Christie wrote:
>> Just delete the sess from the session list instead of adding it to some
>> list we never use.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/scsi/scsi_transport_iscsi.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
>> index 80b442a2b4c8..60e6bde1e96c 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -1623,7 +1623,6 @@ static DEFINE_MUTEX(rx_queue_mutex);
>>  static DEFINE_MUTEX(conn_mutex);
>>  
>>  static LIST_HEAD(sesslist);
>> -static LIST_HEAD(sessdestroylist);
>>  static DEFINE_SPINLOCK(sesslock);
>>  static LIST_HEAD(connlist);
>>  static LIST_HEAD(connlist_err);
>> @@ -2203,7 +2202,8 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
>>  	ISCSI_DBG_TRANS_SESSION(session, "Removing session\n");
>>  
>>  	spin_lock_irqsave(&sesslock, flags);
>> -	list_del(&session->sess_list);
>> +	if (!list_empty(&session->sess_list))
>> +		list_del(&session->sess_list);
>>  	spin_unlock_irqrestore(&sesslock, flags);
>>  
>>  	flush_work(&session->block_work);
>> @@ -3678,7 +3678,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>>  
>>  			/* Prevent this session from being found again */
>>  			spin_lock_irqsave(&sesslock, flags);
>> -			list_move(&session->sess_list, &sessdestroylist);
>> +			list_del_init(&session->sess_list);
>>  			spin_unlock_irqrestore(&sesslock, flags);
>>  
>>  			queue_work(iscsi_destroy_workq, &session->destroy_work);
>>
> 
> So is sessdestroylist still needed?

Yes. I'm not sure what happened. It got added in a recent patch and that was the only use.
