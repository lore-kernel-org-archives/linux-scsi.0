Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DDA0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 19:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 255A061163
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 19:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238220AbhJOTj7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 15:39:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22364 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235167AbhJOTj6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Oct 2021 15:39:58 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19FJ4pG9029837;
        Fri, 15 Oct 2021 15:37:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=oDp3dOssZ/ZMIY8oFvtJNRMWMZCWwIJIIF8edqCySCI=;
 b=o91m6fsjb9FxOoBUtzw9NoyFstUXUW9LSDhG1L83t8/0HLzUD/82HZ7gX5A0yJsnQ6Ao
 F88YetpbCtyPglj4WjR1kYySLn78+dMwR7q5wKFMc64xdPKLyIWw+vZRnv6OJwfNLbLD
 rR1+sQ3IsYzQZJEvDxwDLUSnufv/X9tX26M+BIT5NFQWD0YjzZBM7+sCo7pVgOh28Spz
 HV/HUDHNM8+vyh4jd1wTieJY1/rnNBibVeugSYBBCXHieQGKCYeNUrXHqio41QRjuPvv
 Vh0vI2wWH7F7vadMgCfmqxi3Rm69UpHyNDcYk8t31IiYZ+6NKu+/rbLUu3pURu+SdqIs XA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bpurnt6wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Oct 2021 15:37:40 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19FJXv7D008928;
        Fri, 15 Oct 2021 19:37:39 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3bk2qeb3hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Oct 2021 19:37:39 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19FJbcFP38732222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Oct 2021 19:37:38 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68B616A04D;
        Fri, 15 Oct 2021 19:37:38 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19BC46A061;
        Fri, 15 Oct 2021 19:37:37 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.160.55.194])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 15 Oct 2021 19:37:36 +0000 (GMT)
Subject: Re: [PATCH] ibmvscsi: use GFP_KERNEL with dma_alloc_coherent in
 initialize_event_pool
To:     Michael Ellerman <mpe@ellerman.id.au>, tyreld@linux.vnet.ibm.com
Cc:     brking@linux.vnet.ibm.com, james.bottomley@hansenpartnership.com,
        linuxppc-dev@lists.ozlabs.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
References: <1547089149-20577-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <bbab1043-ee3a-6d5b-7ff5-ea5ed84e9fb8@linux.ibm.com>
 <878ryuykd3.fsf@mpe.ellerman.id.au>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <16d410ce-994e-0480-b764-27d0b21e51f3@linux.ibm.com>
Date:   Fri, 15 Oct 2021 12:37:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <878ryuykd3.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ieISpWbKp-l-vFQV4Gt_0e47RDQ_YG79
X-Proofpoint-ORIG-GUID: ieISpWbKp-l-vFQV4Gt_0e47RDQ_YG79
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-15_06,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 suspectscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 mlxlogscore=880 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110150119
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/14/21 9:36 PM, Michael Ellerman wrote:
> Tyrel Datwyler <tyreld@linux.ibm.com> writes:
>> Just stumbled upon this trivial little patch that looks to have gotten lost in
>> the shuffle. Seems it even got a reviewed-by from Brian [1].
>>
>> So, uh I guess after almost 3 years...ping?
> 
> It's marked "Changes Requested" here:
> 
>   https://patchwork.kernel.org/project/linux-scsi/patch/1547089149-20577-1-git-send-email-tyreld@linux.vnet.ibm.com/

Interesting

> 
> 
> If it isn't picked up in a few days you should probably do a resend so
> that it reappears in patchwork.

Fair enough

-Tyrel

> 
> cheers
> 

