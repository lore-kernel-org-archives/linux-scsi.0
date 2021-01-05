Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F7FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 23:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E548C22EBF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 23:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbhAEXZ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 18:25:28 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:32772 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbhAEXZ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 18:25:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105NErnk170357;
        Tue, 5 Jan 2021 23:24:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZBW3pwOBv/fdklRu4enUTniZsVjePEFf8bTgLcvodaw=;
 b=W/PmZunNY0SOBftwNMYZE38wIZWLUlAIkJNuxQu9TqLHrr7yoZmI9d012nX+wQqrt4Lt
 aOVzlXWNkyrNAqoXkOoR1osXdO8N0PN7y7erb2g+cQvibg6hRmRbio5ds3O2bLKNGPjx
 ofJdvbq/VWFUAKwtKyOV7sdgGZJ0AUgFnzgO4fzXo9BwziFtDE8rjRsJGBCSH/AEIxwx
 EDfA8NaZsoZl98uuL0H/lmEm4uNPyjV5FvT7Riq8QWyGEgAu5ImCZ98zITKm8rB32pzk
 F71gmZJc0MynxOwAxxD4OO3Z5LXH8ChQAKqW/1TQw0+0g8RxRh66UXJ/5QzfUBqLk7Sd 7g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35tebau8w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 23:24:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105NGPjN147340;
        Tue, 5 Jan 2021 23:22:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35v4rbyjuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 23:22:34 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 105NMVPv006926;
        Tue, 5 Jan 2021 23:22:31 GMT
Received: from [20.15.0.204] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 15:22:30 -0800
Subject: Re: [PATCH 5/6 V3] iscsi_tcp: fix shost can_queue initialization
To:     Lee Duncan <lduncan@suse.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
 <1608518226-30376-6-git-send-email-michael.christie@oracle.com>
 <25e548a1-7407-726e-0db0-fb593aa4370d@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <3c6e505b-1c4a-695f-3474-e77182434c73@oracle.com>
Date:   Tue, 5 Jan 2021 17:22:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <25e548a1-7407-726e-0db0-fb593aa4370d@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050133
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/5/21 4:55 PM, Lee Duncan wrote:
> On 12/20/20 6:37 PM, Mike Christie wrote:
>> We are setting the shost's can_queue after we add the host which is
>> too late, because scsi-ml will have allocated the tag set based on
>> the can_queue value at that time. This patch has us use the
>> iscsi_host_get_max_scsi_cmds helper to figure out the number of
>> scsi cmds, so we can set it properly. We should now not be limited
>> to 128 cmds per session.
>>
>> It also fixes up the template can_queue so it reflects the max scsi
>> cmds we can support like how other drivers work.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/scsi/iscsi_tcp.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
>> index df47557..7a5aec7 100644
>> --- a/drivers/scsi/iscsi_tcp.c
>> +++ b/drivers/scsi/iscsi_tcp.c
>> @@ -847,6 +847,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
>>  	struct iscsi_session *session;
>>  	struct iscsi_sw_tcp_host *tcp_sw_host;
>>  	struct Scsi_Host *shost;
>> +	int rc;
>>  
>>  	if (ep) {
>>  		printk(KERN_ERR "iscsi_tcp: invalid ep %p.\n", ep);
>> @@ -864,6 +865,11 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
>>  	shost->max_channel = 0;
>>  	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
>>  
>> +	rc = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
>> +	if (rc < 0)
>> +		goto free_host;
> 
> Same question as in Patch 4: Is having "0" max scsi commands ok?
> 

This could hit zero. I think before we would end up where no cmds
would be executed. They would just be stuck in the queues because
the target->can_queue limit would always be hit. I'll fix that up too.
