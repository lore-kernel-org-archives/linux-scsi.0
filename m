Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF75C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 22:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EAC820678
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 22:21:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BdCS0Fbn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgKQWVP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 17:21:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726035AbgKQWVP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 17:21:15 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHM4IkE084056;
        Tue, 17 Nov 2020 17:21:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=x2iXCZSnXRwGxwYhCZK53+Enw+9vEfbC5I+7svBrQUg=;
 b=BdCS0FbnpBYm4zcsLwBpiOzUTXThRIBv9JMGNHCAkUcfFKTWX+RvjyTEgjANPotatxOU
 rzGuk/q7MRnYCypEOOTnS8YGf0mqNTtK2B0MA3W3HpbcSmaynT9p+GPLP0O4SJKeE498
 xeiyKrFIMvkLQQodzNpqB67+gymP9pvfRvyKBC74Ej1IU/etBWwQKmk+qpNMtBJk/SFw
 d8ftNG6GgVq9tegbUSCGZrL6DlVByouMQnCntCr+1xMomk1MjyrN3BkdHaH/lnpILcsN
 4cUZ+lcnCy3FcHCkpIObCxkAbpcufa3hul8ChvOPGL7lDEvHzc7fKcwUPCYB0ez3Txh8 pw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vfd8fb49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 17:21:09 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHMIO3m030818;
        Tue, 17 Nov 2020 22:21:08 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04wdc.us.ibm.com with ESMTP id 34t6v91njk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 22:21:08 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHML1h614025422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 22:21:01 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2442FBE053;
        Tue, 17 Nov 2020 22:21:07 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A676BBE059;
        Tue, 17 Nov 2020 22:21:06 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.40.231])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 22:21:06 +0000 (GMT)
Subject: Re: [PATCH 4/6] ibmvfc: add FC payload retrieval routines for
 versioned vfcFrames
From:   Brian King <brking@linux.vnet.ibm.com>
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201112010442.102589-1-tyreld@linux.ibm.com>
 <20201112010442.102589-4-tyreld@linux.ibm.com>
 <9e38f449-d2e6-6408-4fef-cfb5351393cc@linux.vnet.ibm.com>
Message-ID: <a829840c-6f39-2901-4cdc-9df1d83f3196@linux.vnet.ibm.com>
Date:   Tue, 17 Nov 2020 16:21:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <9e38f449-d2e6-6408-4fef-cfb5351393cc@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_12:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170162
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/17/20 4:14 PM, Brian King wrote:
> On 11/11/20 7:04 PM, Tyrel Datwyler wrote:
>> The FC iu and response payloads are located at different offsets
>> depending on the ibmvfc_cmd version. This is a result of the version 2
>> vfcFrame definition adding an extra 64bytes of reserved space to the
>> structure prior to the payloads.
>>
>> Add helper routines to determine the current vfcFrame version and
>> returning pointers to the proper iu or response structures within that
>> ibmvfc_cmd.
>>
>> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.c | 76 ++++++++++++++++++++++++----------
>>  1 file changed, 53 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index aa3445bec42c..5e666f7c9266 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -138,6 +138,22 @@ static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
>>  
>>  static const char *unknown_error = "unknown error";
>>  
>> +static struct ibmvfc_fcp_cmd_iu *ibmvfc_get_fcp_iu(struct ibmvfc_host *vhost, struct ibmvfc_cmd *vfc_cmd)
>> +{
>> +	if (be64_to_cpu(vhost->login_buf->resp.capabilities) & IBMVFC_HANDLE_VF_WWPN)
> 
> Suggest adding a flag to the vhost structure that you setup after login in order to
> simplify this check and avoid chasing multiple pointers along with a byte swap.
> 
> Maybe something like:
> 
> vhost->is_v2

Even better might be vhost->version which you'd set to 1 or 2 and then you could directly
use that to set the field in the command structures later.


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

