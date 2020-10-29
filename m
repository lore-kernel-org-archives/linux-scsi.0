Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDF0C388F7
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 01:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA2262076E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 01:28:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I5wVyzUM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391264AbgJ2B2l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Oct 2020 21:28:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731690AbgJ2B2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Oct 2020 21:28:39 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09T11IjI175015;
        Wed, 28 Oct 2020 21:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8d3tL3+CWG6reyVHWOsX5v+g3AMRGFiqPzn7EwvoYgc=;
 b=I5wVyzUMz6OYb3aGV+CfyOohDqyn0zHNhJo51cIEn/U/tQtMT1EZVf9mbbhFs2GqOjFo
 W0LSS3A9nOz+gpwGRn3RA3C8VOW3L65yddYmCoP2sAznLW+19/L8yuoNiQ4CnArlJBnU
 mOlD9DYqFSTkX70u+2Vp7xwl7U6JUTczC1nZ9LabLkswCbPTDf2h5MYtTmAaTb/H0L+4
 TrVHZiYO/Jg+UvviVKmJgiF4pfmWVmQe//Jr29B/HQ3qqs3RwJ2d+SDr2io9kqFQhXm7
 5O1u6H7nCzCUNObXHfoEMYaVQDFz2Y0vodBVgAtiCuCKSB6BPw1loEIKbW9/hdXqA1qV vw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34feghhhhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 21:28:24 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09T1QbdE016052;
        Thu, 29 Oct 2020 01:28:24 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 34etf94a4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Oct 2020 01:28:24 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09T1SNAY14025070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 01:28:23 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07F7FC605A;
        Thu, 29 Oct 2020 01:28:23 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8228DC605D;
        Thu, 29 Oct 2020 01:28:21 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.160.55.172])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 29 Oct 2020 01:28:21 +0000 (GMT)
Subject: Re: [PATCH] ibmvscsi: fix race potential race after loss of transport
To:     Michael Ellerman <mpe@ellerman.id.au>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
References: <20201025001355.4527-1-tyreld@linux.ibm.com>
 <87o8knvsb1.fsf@mpe.ellerman.id.au>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <d527dffd-1af2-7da0-d1f1-1f192a537aed@linux.ibm.com>
Date:   Wed, 28 Oct 2020 18:28:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87o8knvsb1.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_09:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 phishscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290000
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/20 10:21 PM, Michael Ellerman wrote:
> Tyrel Datwyler <tyreld@linux.ibm.com> writes:
>> After a loss of tranport due to an adatper migration or crash/disconnect from
>> the host partner there is a tiny window where we can race adjusting the
>> request_limit of the adapter. The request limit is atomically inc/dec to track
>> the number of inflight requests against the allowed limit of our VIOS partner.
>> After a transport loss we set the request_limit to zero to reflect this state.
>> However, there is a window where the adapter may attempt to queue a command
>> because the transport loss event hasn't been fully processed yet and
>> request_limit is still greater than zero. The hypercall to send the event will
>> fail and the error path will increment the request_limit as a result. If the
>> adapter processes the transport event prior to this increment the request_limit
>> becomes out of sync with the adapter state and can result in scsi commands being
>> submitted on the now reset connection prior to an SRP Login resulting in a
>> protocol violation.
>>
>> Fix this race by protecting request_limit with the host lock when changing the
>> value via atomic_set() to indicate no transport.
>>
>> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvscsi.c | 36 +++++++++++++++++++++++---------
>>  1 file changed, 26 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> index b1f3017b6547..188ed75417a5 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> @@ -806,6 +806,22 @@ static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
>>  	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
>>  }
>>  
>> +/**
>> + * ibmvscsi_set_request_limit - Set the adapter request_limit in response to
>> + * an adapter failure, reset, or SRP Login. Done under host lock to prevent
>> + * race with scsi command submission.
>> + * @hostdata:	adapter to adjust
>> + * @limit:	new request limit
>> + */
>> +static void ibmvscsi_set_request_limit(struct ibmvscsi_host_data *hostdata, int limit)
>> +{
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(hostdata->host->host_lock, flags);
>> +	atomic_set(&hostdata->request_limit, limit);
>> +	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
>> +}
>> +
>>  /**
>>   * ibmvscsi_reset_host - Reset the connection to the server
>>   * @hostdata:	struct ibmvscsi_host_data to reset
> ...
>> @@ -2137,12 +2153,12 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
>>  	}
>>  
>>  	hostdata->action = IBMVSCSI_HOST_ACTION_NONE;
>> +	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
> 
> You drop the lock ...
> 
>>  	if (rc) {
>> -		atomic_set(&hostdata->request_limit, -1);
>> +		ibmvscsi_set_request_limit(hostdata, -1);
> 
> .. then retake it, then drop it again in ibmvscsi_set_request_limit().
> 
> Which introduces the possibility that something else gets the lock
> before you can set the limit to -1.
> 
> I'm not sure that's a bug, but it's not obviously correct either?

Yeah, I'd already moved the request_limit update into its own function before I
got to this case which made me a bit uneasy when I realized I had to drop the
lock because my new function takes the lock. However, we only need to protect
ourselves from from racing with queuecommand() which is locked for its entire
call. Further, if we've gotten here it means we were either resetting or
re-enabling the adapter which would have already set request_limit to zero. At
this point the transport was already gone and we've further failed to reset it.
Also, we've blocked any new scsi requests at this point.

-Tyrel

> 
> cheers
> 
>>  		dev_err(hostdata->dev, "error after %s\n", action);
>>  	}
>> -	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
>>  
>>  	scsi_unblock_requests(hostdata->host);
>>  }

