Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5759BC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 16:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4151360E8F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 16:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhGWQQ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 12:16:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230367AbhGWQQ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jul 2021 12:16:26 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NGYgDR117999;
        Fri, 23 Jul 2021 12:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=y6haI9X+NGlUkjfD3/I4Gvnj8rC4Xc1Getr/31Nj+OI=;
 b=b6b1CavLQEEKkotZDAKd8GCWvWtO6CZvdveSWYEB+choR/6tcM9PfUtSBT7E20z6jZRH
 Dne+IfGX1iTKFNktu3ICupfMex1+SuIUvjUF9KE4zKFYg09cgjT0Za12eEr1PU4fWBAi
 +xgp7A1CcvkpoVq2RYB57pXnj74TylP+9QUZOM7OVJqWPQCUUgTD2jy7TfkMpuAoICCR
 IfINTY7W+v9IR1VnHARJVrWav9yiqtwTVK47k79pk9PK+aMqQJKC5OIQ9HE2pmjkxY/l
 BrWdg89unamkkS6sTeVVIh8mz6ZNuBvYlbiopbfZJLn/L+Vrb2yTa5Yq5gOPm79d2M2v eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a00pct056-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 12:56:57 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16NGZImT120377;
        Fri, 23 Jul 2021 12:56:56 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a00pct04f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 12:56:56 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16NGrG29000564;
        Fri, 23 Jul 2021 16:56:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 39upu89xgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 16:56:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16NGuqFE31654346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 16:56:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 775754C04E;
        Fri, 23 Jul 2021 16:56:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 149944C050;
        Fri, 23 Jul 2021 16:56:52 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com (unknown [9.145.191.177])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Jul 2021 16:56:51 +0000 (GMT)
Subject: Re: [RESEND] scsi: aacraid: aachba: replace if with max()
To:     Salah Triki <salah.triki@gmail.com>, aacraid@microsemi.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        gregkh@linuxfoundation.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210722173212.GA5685@pc>
From:   Steffen Maier <maier@linux.ibm.com>
Message-ID: <09202d04-d066-a552-7a33-6c4c3b669107@linux.ibm.com>
Date:   Fri, 23 Jul 2021 18:56:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210722173212.GA5685@pc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: o4HPNuLbcKHvbgKRw7goe1qcEwsY_HSt
X-Proofpoint-GUID: x9MOKj7ac6Ab-Stcyf7Q48wFrANDopLw
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_09:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 clxscore=1011 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107230100
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/22/21 7:32 PM, Salah Triki wrote:
> Replace if with max() in order to make code more clean.
> 
> Signed-off-by: Salah Triki <salah.triki@gmail.com>
> ---
>   drivers/scsi/aacraid/aachba.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index 46b8dffce2dd..330224f08fd3 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -485,8 +485,8 @@ int aac_get_containers(struct aac_dev *dev)
>   	if (status != -ERESTARTSYS)
>   		aac_fib_free(fibptr);
> 
> -	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
> -		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
> +	maximum_num_containers = max(maximum_num_containers, MAXIMUM_NUM_CONTAINERS);
> +

Haven't really looked closely, but isn't the old code more like a min() rather 
than a max()? maximum_num_containers being at least MAXIMUM_NUM_CONTAINERS or 
higher?


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
