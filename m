Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12762C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 18:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D02BB64E85
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 18:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhBPSoU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Feb 2021 13:44:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229912AbhBPSoR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Feb 2021 13:44:17 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11GIWDlZ173635;
        Tue, 16 Feb 2021 13:43:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=V1xU+saz9w4xiE659/nYzU7asqdKegzxMTqU8mFL/EU=;
 b=VSUZDZmuDejsM9+YVG+Q1nR+xPVfbS3+TRCWqLYBb0Um4A8GTLO5Co0D50p6VCTYqOGW
 BJl4Be8LnfIrCV6UuxzWNtPnRN6dtr5Nkz9Ha2otr88hWwZR7OL1irT8x1MSlpX+nzsw
 foSyBHz45yR3Sz0+++/C6/VdQVdNzKz6mYCAPrTTSotpYUIJ1NlbOHq4x9C2BAl5MoFk
 /ITuT3b3B58mXwvsDMJfG+nkHQ3fFWyH3L37p9l8lWPI1KHLOh93ndfcGkhMyssdqncD
 2i4sAfoWysZIZu9qZMIfxLMpja9wgOPeJ62bM1DLeb2++pZTPy5mCvIgL67m7RxvxnNX LQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36rhtdusc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 13:43:30 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11GIaX6F016141;
        Tue, 16 Feb 2021 18:43:29 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 36p6d9pf0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 18:43:29 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11GIhTAJ7799706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Feb 2021 18:43:29 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02B7328066;
        Tue, 16 Feb 2021 18:43:29 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D7D428058;
        Tue, 16 Feb 2021 18:43:26 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.160.70.200])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Feb 2021 18:43:25 +0000 (GMT)
Subject: Re: [PATCH 4/4] ibmvfc: store return code of H_FREE_SUB_CRQ during
 cleanup
To:     Brian King <brking@linux.vnet.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20210211185742.50143-1-tyreld@linux.ibm.com>
 <20210211185742.50143-5-tyreld@linux.ibm.com>
 <94321ded-7970-258c-cee9-222f7b2b511f@linux.vnet.ibm.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <f5821413-f390-f759-a8a4-764c7f69537c@linux.ibm.com>
Date:   Tue, 16 Feb 2021 10:43:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <94321ded-7970-258c-cee9-222f7b2b511f@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_08:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 phishscore=0 spamscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160153
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/16/21 6:58 AM, Brian King wrote:
> On 2/11/21 12:57 PM, Tyrel Datwyler wrote:
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index ba6fcf9cbc57..23b803ac4a13 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -5670,7 +5670,7 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
>>  
>>  irq_failed:
>>  	do {
>> -		plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
>> +		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
>>  	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
> 
> Other places in the driver where we get a busy return code back we have an msleep(100).
> Should we be doing that here as well?

Indeed, and actually even better would be to use rtas_busy_delay() which will
perform the sleep with the correct ms delay, and marks itself with the
might_sleep() macro.

-Tyrel

> 
> Thanks,
> 
> Brian
> 

