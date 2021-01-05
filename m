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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD10C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 23:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B07822EBE
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 23:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbhAEXY0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 18:24:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46030 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbhAEXY0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 18:24:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105NErbQ112530;
        Tue, 5 Jan 2021 23:23:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0R7gadghixxyqCUhD09JSvC5e8i0uGu1vptavsLrNRk=;
 b=ZIpQj+wcheTvZnKFGmmRTFNzkxX6E3tv/6IYfciR3aja+cKAN5D5xpW0WklAErvTfpk/
 39FFO+/ePNpUSIxIhRie5s44UyQx2E0Cm4pNnVh5VHS12JD1mZdKVNHINSeL653K6nmR
 rwI7imnIZ1TXJcYdNMPufYvyxhEKIa328/mOVuMnWnl+o8nnuvTlqKyy6lqZAQDNyz1o
 emi6fG54tYnr2EM8Ti8ML8eVaaq2uSzS9noyGYESoYQe2VP3X9dJYbi4vttqtbHc04//
 Y1pKMMJox8MFDD8ihOfKQ/7r/76krsYXAnLliFeMW8RnbRvCug7hQ5bPb94LfCShYTi+ 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35tgsku5jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 23:23:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105NEmQh084852;
        Tue, 5 Jan 2021 23:23:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35v1f96pq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 23:23:27 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 105NIPVK001491;
        Tue, 5 Jan 2021 23:18:26 GMT
Received: from [20.15.0.204] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 15:18:25 -0800
Subject: Re: [PATCH 4/6 V3] libiscsi: add helper to calc max scsi cmds per
 session
To:     Lee Duncan <lduncan@suse.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
 <1608518226-30376-5-git-send-email-michael.christie@oracle.com>
 <f1d5b6b3-d8a8-c584-9081-c58302d580ea@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <063840fe-0b52-fe41-a0d9-c94821be6e5d@oracle.com>
Date:   Tue, 5 Jan 2021 17:18:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f1d5b6b3-d8a8-c584-9081-c58302d580ea@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050133
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/5/21 4:53 PM, Lee Duncan wrote:
> On 12/20/20 6:37 PM, Mike Christie wrote:
>> This patch just breaks out the code that calculates the number
>> of scsi cmds that will be used for a scsi session. It also adds
>> a check that we don't go over the host's can_queue value.
> 
> I'm curious. It's a "good thing" to check the command count in a better
> way now, but was there any known instance of the count miscalculation in
> the current code causing issues?

No one has hit any issues. It's so userspace knows it's not going to
get the requested value.

> 
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/scsi/libiscsi.c | 81 ++++++++++++++++++++++++++++++-------------------
>>  include/scsi/libiscsi.h |  2 ++
>>  2 files changed, 51 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 796465e..f1ade91 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -2648,6 +2648,51 @@ void iscsi_pool_free(struct iscsi_pool *q)
>>  }
>>  EXPORT_SYMBOL_GPL(iscsi_pool_free);
>>  
>> +int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
>> +				 uint16_t requested_cmds_max)
>> +{
>> +	int scsi_cmds, total_cmds = requested_cmds_max;
>> +
>> +	if (!total_cmds)
>> +		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
>> +	/*
>> +	 * The iscsi layer needs some tasks for nop handling and tmfs,
>> +	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
>> +	 * + 1 command for scsi IO.
>> +	 */
>> +	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
>> +		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue must be a power of two that is at least %d.\n",
>> +		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
>> +		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue must be a power of 2 less than or equal to %d.\n",
>> +		       requested_cmds_max, ISCSI_TOTAL_CMDS_MAX);
>> +		total_cmds = ISCSI_TOTAL_CMDS_MAX;
>> +	}
>> +
>> +	if (!is_power_of_2(total_cmds)) {
>> +		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue must be a power of 2.\n",
>> +		       total_cmds);
>> +		total_cmds = rounddown_pow_of_two(total_cmds);
>> +		if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
>> +			return -EINVAL;
>> +		printk(KERN_INFO "iscsi: Rounding can_queue to %d.\n",
>> +		       total_cmds);
>> +	}
>> +
>> +	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
>> +	if (shost->can_queue && scsi_cmds > shost->can_queue) {
>> +		scsi_cmds = shost->can_queue - ISCSI_MGMT_CMDS_MAX;
>> +		printk(KERN_INFO "iscsi: requested cmds_max %u higher than driver limit. Using driver max %u\n",
>> +		       requested_cmds_max, shost->can_queue);
>> +	}
> 
> If the device can queue, what if "can_queue" is equal to or less than
> ISCSI_MGMT_CMDS_MAX?
>

It wouldn't be possible, because the drivers set their can_queue a lot higher
than ISCSI_MGMT_CMDS_MAX, but for this and the other comment I'll fix up the
check/code.
