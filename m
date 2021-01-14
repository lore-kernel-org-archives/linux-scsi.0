Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB54C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 17:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7374623B54
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 17:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbhANRZ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 12:25:29 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42608 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728580AbhANRZ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 12:25:28 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EH9hvR184364;
        Thu, 14 Jan 2021 12:24:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O2dcG2TjnlorTozOyHjBrG5WVWzj7GSsdgjwEfc4Oqo=;
 b=EFG4XU3+FpG7A1Sit/iwVmQQCiBn1ZtsIg7uMmyzRlPNX/dCjo+9WFpLmymr/XtmIE/8
 1uFBwLRUrXnf3n1dL/sJcFpFi7FkODZLcnYkauJPO2pICACeUtzxfHqK3+swK9Z+M0Mj
 f6uMnLLDcskBjdVlmNcYRsf34z1JbpVDAHf2Y/E0RSQH7nX8bBr6xK6xJHXDYDzn15U+
 7TMnbRYUwKQb7fTCygdyBRxfwATXUNgy4pdloUcEibsFpNCg92BZvvfJft3ZzXdWFrOT
 g4Imw/7cOTjb6KBV7nV+YJ/6rHyFXdSQvkaEJ9dYp3AHUj0czVRjwuf+tHoSpwXFyoB/ Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362s9b25wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 12:24:39 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10EHAR1t186175;
        Thu, 14 Jan 2021 12:24:39 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362s9b25wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 12:24:38 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EHNPFd011309;
        Thu, 14 Jan 2021 17:24:38 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04wdc.us.ibm.com with ESMTP id 35y449es8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 17:24:38 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EHOaKM24445320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 17:24:36 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9EB3C6059;
        Thu, 14 Jan 2021 17:24:36 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E9ABC6055;
        Thu, 14 Jan 2021 17:24:36 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.16.139])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 17:24:36 +0000 (GMT)
Subject: Re: [PATCH v4 01/21] ibmvfc: add vhost fields and defaults for MQ
 enablement
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        james.smart@broadcom.com
References: <20210111231225.105347-1-tyreld@linux.ibm.com>
 <20210111231225.105347-2-tyreld@linux.ibm.com>
 <0525bee7-433f-dcc7-9e35-e8706d6edee5@linux.vnet.ibm.com>
 <a8623705-6d49-2056-09bb-80190e0b6f52@linux.ibm.com>
 <51bfc34b-c2c4-bf14-c903-d37015f65361@linux.vnet.ibm.com>
 <20210114012738.GA237540@T590>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <9c5f7786-cd13-6a49-2d71-d0c438318bcb@linux.vnet.ibm.com>
Date:   Thu, 14 Jan 2021 11:24:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210114012738.GA237540@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_06:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140094
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/13/21 7:27 PM, Ming Lei wrote:
> On Wed, Jan 13, 2021 at 11:13:07AM -0600, Brian King wrote:
>> On 1/12/21 6:33 PM, Tyrel Datwyler wrote:
>>> On 1/12/21 2:54 PM, Brian King wrote:
>>>> On 1/11/21 5:12 PM, Tyrel Datwyler wrote:
>>>>> Introduce several new vhost fields for managing MQ state of the adapter
>>>>> as well as initial defaults for MQ enablement.
>>>>>
>>>>> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
>>>>> ---
>>>>>  drivers/scsi/ibmvscsi/ibmvfc.c | 8 ++++++++
>>>>>  drivers/scsi/ibmvscsi/ibmvfc.h | 9 +++++++++
>>>>>  2 files changed, 17 insertions(+)
>>>>>
>>>>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>>>>> index ba95438a8912..9200fe49c57e 100644
>>>>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>>>>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>>>>> @@ -3302,6 +3302,7 @@ static struct scsi_host_template driver_template = {
>>>>>  	.max_sectors = IBMVFC_MAX_SECTORS,
>>>>>  	.shost_attrs = ibmvfc_attrs,
>>>>>  	.track_queue_depth = 1,
>>>>> +	.host_tagset = 1,
>>>>
>>>> This doesn't seem right. You are setting host_tagset, which means you want a
>>>> shared, host wide, tag set for commands. It also means that the total
>>>> queue depth for the host is can_queue. However, it looks like you are allocating
>>>> max_requests events for each sub crq, which means you are over allocating memory.
>>>
>>> With the shared tagset yes the queue depth for the host is can_queue, but this
>>> also implies that the max queue depth for each hw queue is also can_queue. So,
>>> in the worst case that all commands are queued down the same hw queue we need an
>>> event pool with can_queue commands.
>>>
>>>>
>>>> Looking at this closer, we might have bigger problems. There is a host wide
>>>> max number of commands that the VFC host supports, which gets returned on
>>>> NPIV Login. This value can change across a live migration event.
>>>
>>> From what I understand the max commands can only become less.
>>>
>>>>
>>>> The ibmvfc driver, which does the same thing the lpfc driver does, modifies
>>>> can_queue on the scsi_host *after* the tag set has been allocated. This looks
>>>> to be a concern with ibmvfc, not sure about lpfc, as it doesn't look like
>>>> we look at can_queue once the tag set is setup, and I'm not seeing a good way
>>>> to dynamically change the host queue depth once the tag set is setup. 
>>>>
>>>> Unless I'm missing something, our best options appear to either be to implement
>>>> our own host wide busy reference counting, which doesn't sound very good, or
>>>> we need to add some API to block / scsi that allows us to dynamically change
>>>> can_queue.
>>>
>>> Changing can_queue won't do use any good with the shared tagset becasue each
>>> queue still needs to be able to queue can_queue number of commands in the worst
>>> case.
>>
>> The issue I'm trying to highlight here is the following scenario:
>>
>> 1. We set shost->can_queue, then call scsi_add_host, which allocates the tag set.
>>
>> 2. On our NPIV login response from the VIOS, we might get a lower value than we
>> initially set in shost->can_queue, so we update it, but nobody ever looks at it
>> again, and we don't have any protection against sending too many commands to the host.
>>
>>
>> Basically, we no longer have any code that ensures we don't send more
>> commands to the VIOS than we are told it supports. According to the architecture,
>> if we actually do this, the VIOS will do an h_free_crq, which would be a bit
>> of a bug on our part.
>>
>> I don't think it was ever clearly defined in the API that a driver can
>> change shost->can_queue after calling scsi_add_host, but up until
>> commit 6eb045e092efefafc6687409a6fa6d1dabf0fb69, this worked and now
>> it doesn't. 
> 
> Actually it isn't related with commit 6eb045e092ef, because blk_mq_alloc_tag_set()
> uses .can_queue to create driver tag sbitmap and request pool.
> 
> So even thought without 6eb045e092ef, the updated .can_queue can't work
> as expected because the max driver tag depth has been fixed by blk-mq already.

There are two scenarios here. In the scenario of someone increasing can_queue
after the tag set is allocated, I agree, blk-mq will never take advantage
of this. However, in the scenario of someone *decreasing* can_queue after the
tag set is allocated, prior to 6eb045e092ef, the shost->host_busy code provided
this protection.

> 
> What 6eb045e092ef does is just to remove the double check on max
> host-wide allowed commands because that has been respected by blk-mq
> driver tag allocation already.
> 
>>
>> I started looking through drivers that do this, and so far, it looks like the
>> following drivers do: ibmvfc, lpfc, aix94xx, libfc, BusLogic, and likely others...
>>
>> We probably need an API that lets us change shost->can_queue dynamically.
> 
> I'd suggest to confirm changing .can_queue is one real usecase.

For ibmvfc, the total number of commands that the scsi host supports is very
much a dynamic value. It can increase and it can decrease. Live migrating
a logical partition from one system to another is the usual cause of
such a capability change. For ibmvfc, at least, this only ever happens
when we've self blocked the host and have sent back all outstanding I/O.

However, looking at other drivers that modify can_queue dynamically, this
doesn't always hold true. Looking at libfc, it looks to dynamically ramp
up and ramp down can_queue based on its ability to handle requests.

There are certainly a number of other drivers that change can_queue
after the tag set has been allocated. Some of these drivers could
likely be changed to avoid doing this, but changing them all will likely
be difficult.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

