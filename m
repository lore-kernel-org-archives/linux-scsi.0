Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82115C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 17:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A0C260ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 17:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhGWQj2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 12:39:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53170 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229492AbhGWQj1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jul 2021 12:39:27 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NHDP0Q132756;
        Fri, 23 Jul 2021 13:19:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=VEAq6iynjckKWvoAaVOTkw1tJE3g63YroYl1HxSpEHw=;
 b=femDne3KXi4SzQkac/6+bwL6whs/LZFGzPwAmU2AAmyt4uD2dPTsE0zcxpmUi5MIabMi
 jljnxj8IAFAxH9gEOnfPB99KoPvHQXnGserhdiaWIHHB0uLKRlfWsJV0CkY3zov8XBJj
 GFJe5T2ZOdBFOr39McSv1/QlcJpneZHyTUZSf+DIAk/A7TwrHhfYU46/SKweI20YJjFI
 snAVUFSz9osPyG2+CiIJTuUqXVo00Bq4YcDFGaG+PjCojkzsCxAnOeds8HKV6JRZbKHm
 UNwRqgQlL5XwRbtTVAyb+Y4cvP5Bj0makvthMxKrxvEiPkUs5Qv/RL1Ob/ASC/u0f9yZ Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a01yq050r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:19:57 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16NHFG0R140257;
        Fri, 23 Jul 2021 13:19:56 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a01yq0500-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:19:56 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16NHITph030182;
        Fri, 23 Jul 2021 17:19:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 39xhx49b97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 17:19:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16NHJqPS28901852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 17:19:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE9D74C04E;
        Fri, 23 Jul 2021 17:19:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A8EE4C04A;
        Fri, 23 Jul 2021 17:19:51 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com (unknown [9.145.176.214])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Jul 2021 17:19:51 +0000 (GMT)
Subject: Re: [RESEND] scsi: aacraid: aachba: replace if with max()
From:   Steffen Maier <maier@linux.ibm.com>
To:     Salah Triki <salah.triki@gmail.com>, aacraid@microsemi.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        gregkh@linuxfoundation.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210722173212.GA5685@pc>
 <09202d04-d066-a552-7a33-6c4c3b669107@linux.ibm.com>
Message-ID: <923d4bad-ef51-c4d7-ac40-d2df5954d866@linux.ibm.com>
Date:   Fri, 23 Jul 2021 19:19:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <09202d04-d066-a552-7a33-6c4c3b669107@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rPYkOtP_ukyFwL_VRPXfl62pD-pLmGYK
X-Proofpoint-ORIG-GUID: 80k7ehWkwUwil_whvc5FvklnXbS_zJyf
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_09:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107230102
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/23/21 6:56 PM, Steffen Maier wrote:
> On 7/22/21 7:32 PM, Salah Triki wrote:
>> Replace if with max() in order to make code more clean.
>>
>> Signed-off-by: Salah Triki <salah.triki@gmail.com>
>> ---
>>   drivers/scsi/aacraid/aachba.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
>> index 46b8dffce2dd..330224f08fd3 100644
>> --- a/drivers/scsi/aacraid/aachba.c
>> +++ b/drivers/scsi/aacraid/aachba.c
>> @@ -485,8 +485,8 @@ int aac_get_containers(struct aac_dev *dev)
>>       if (status != -ERESTARTSYS)
>>           aac_fib_free(fibptr);
>>
>> -    if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
>> -        maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
>> +    maximum_num_containers = max(maximum_num_containers, 
>> MAXIMUM_NUM_CONTAINERS);
>> +
> 
> Haven't really looked closely, but isn't the old code more like a min() rather 
> than a max()? maximum_num_containers being at least MAXIMUM_NUM_CONTAINERS or 
> higher?

Sorry, scratch that, it was nonsense.


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
