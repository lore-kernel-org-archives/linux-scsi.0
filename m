Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258D5C433FE
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 00:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF8BA22B40
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 00:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgLEAV2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 19:21:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbgLEAV2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 19:21:28 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B50AgwA039437;
        Fri, 4 Dec 2020 19:20:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GVFvtLr0wQfIy6BAmpv+kOkZFtywXygsijhet2zqiy4=;
 b=FCb54TgWrODArCywRQc5tU6shVvdLY14OgkIWLePvbwP5fnTppuvfJFX2fdQYOdyELD+
 Q+nY+HC5I02vQeFYOO2p3jJAOFgmHw0b+S+7scxdWSKXVsu9rAKOjAZ/UZFdyPWsPd71
 keg26qmaawKQFBn64vKIM9yN2gx1zJhyAFut84PqtgJJk9rL/pf06eRE44Ze4SUFzf5q
 iB3WXusvcg4di3WKN5fxDr0dXEkwGTfnUZIpJOtP3M7hvCC37hRYHbVLkoTuOHFbNalq
 sBF6Wq90RFM77lnHqNOVmL6cPSpwc0NYt0jzOFD8BW/hqeGZbAscIbyEg2Kz8MnCK7Qj XA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357uq6ncq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 19:20:40 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B507b4K017876;
        Sat, 5 Dec 2020 00:20:39 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3569xv299d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 05 Dec 2020 00:20:39 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B50Kcb710682980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 5 Dec 2020 00:20:38 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60068112062;
        Sat,  5 Dec 2020 00:20:38 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72F61112061;
        Sat,  5 Dec 2020 00:20:36 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.65.215.138])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat,  5 Dec 2020 00:20:36 +0000 (GMT)
Subject: Re: [PATCH v3 18/18] ibmvfc: drop host lock when completing commands
 in CRQ
To:     Brian King <brking@linux.vnet.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201203020806.14747-1-tyreld@linux.ibm.com>
 <20201203020806.14747-19-tyreld@linux.ibm.com>
 <b048ede5-e673-4ba9-3c28-df077aa4467a@linux.vnet.ibm.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <6cd6b923-4231-fed2-f691-5ff5d55bc64a@linux.ibm.com>
Date:   Fri, 4 Dec 2020 16:20:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <b048ede5-e673-4ba9-3c28-df077aa4467a@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_13:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040138
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/4/20 1:35 PM, Brian King wrote:
> On 12/2/20 8:08 PM, Tyrel Datwyler wrote:
>> The legacy CRQ holds the host lock the even while completing commands.
>> This presents a problem when in legacy single queue mode and
>> nr_hw_queues is greater than one since calling scsi_done() introduces
>> the potential for deadlock.
>>
>> If nr_hw_queues is greater than one drop the hostlock in the legacy CRQ
>> path when completing a command.
>>
>> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index e499599662ec..e2200bdff2be 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -2969,6 +2969,7 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
>>  {
>>  	long rc;
>>  	struct ibmvfc_event *evt = (struct ibmvfc_event *)be64_to_cpu(crq->ioba);
>> +	unsigned long flags;
>>  
>>  	switch (crq->valid) {
>>  	case IBMVFC_CRQ_INIT_RSP:
>> @@ -3039,7 +3040,12 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
>>  	del_timer(&evt->timer);
>>  	list_del(&evt->queue);
>>  	ibmvfc_trc_end(evt);
>> -	evt->done(evt);
>> +	if (nr_scsi_hw_queues > 1) {
>> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);
>> +		evt->done(evt);
>> +		spin_lock_irqsave(vhost->host->host_lock, flags);
>> +	} else
>> +		evt->done(evt);
> 
> Similar comment here as previously. The flags parameter is an output for
> spin_lock_irqsave but an input for spin_unlock_irqrestore. You'll need
> to rethink the locking here. You could just do a spin_unlock_irq / spin_lock_irq
> here and that would probably be OK, but probably isn't the best. 
> 

Yeah, this will also get its own lock and flags saved in the per-queue struct in
the next spin.

-Tyrel

>>  }
>>  
>>  /**
>>
> 
> 

