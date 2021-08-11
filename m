Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B5F0C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Aug 2021 14:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D6D060231
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Aug 2021 14:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbhHKOBG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Aug 2021 10:01:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55570 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231983AbhHKOBF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Aug 2021 10:01:05 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17BDY8GU062933;
        Wed, 11 Aug 2021 10:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=qxqDArobKXhNLmzZd0Un0J2XWL8vQoD1y4Kd1JMfNrI=;
 b=AVHXqBiNS3yJ00Hjo4LMjL8kKCWQf65vb4aRY2oZIEqgiAju4Bjs+PeQGp7YhKZ40jE9
 aCAUKR0PJwaKbC6msA+DC/kl4427OvDwcOy+wtgPEtlIR8wteHHMWDfU8pvbqZy3/0iX
 UbJTdYmWvhw3RwhH6TI5SgvBHktMa2e2rc6BqV14/Yegsfk3YRYTdYYTJrUn/GcYrGqs
 OL3+im7Rf8XzDjSNfw2W8Fm9Ilc0xyDypXexvJsVDv1PMXiZXLkwyhK0aNokB2DTXXK6
 xRVw0R8XVU3dXDI2kaANP5NdEJwPsP6A/35jbmP0hnk1VqUD6wOeabSp+u1gA6e2Hs58 Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3accthdb53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 10:00:32 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17BDYnap065054;
        Wed, 11 Aug 2021 10:00:31 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3accthdb4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 10:00:31 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17BDwiWg008050;
        Wed, 11 Aug 2021 14:00:30 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 3ab3ya6m5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 14:00:29 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17BDwYa037552528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Aug 2021 13:58:34 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23E757805E;
        Wed, 11 Aug 2021 13:58:34 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5732478076;
        Wed, 11 Aug 2021 13:58:32 +0000 (GMT)
Received: from [IPv6:2601:600:8280:66d1::c447] (unknown [9.160.128.78])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 11 Aug 2021 13:58:32 +0000 (GMT)
Message-ID: <1d6b8e045353c98c22ae7963d16d91c5a5421fd8.camel@linux.ibm.com>
Subject: Re: [PATCH] [SCSI] megaraid_sas: Fix possible divide-by-zero bugs
 in megaraid_sas_fp.c
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Tuo Li <islituo@gmail.com>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        TOTE Robot <oslab@tsinghua.edu.cn>
Date:   Wed, 11 Aug 2021 06:58:31 -0700
In-Reply-To: <20210811131647.9300-1-islituo@gmail.com>
References: <20210811131647.9300-1-islituo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: k6nze7vx9CRNzu5cyg_SOcsJGu-mQPRz
X-Proofpoint-ORIG-GUID: 8gJILk89flD7diQPRHRZ8xGM-NAW_-QC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-11_04:2021-08-11,2021-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1011
 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108110091
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-08-11 at 06:16 -0700, Tuo Li wrote:
> In the function mega_mod64(). the variable is checked in:
>   if (!divisor)
> 
> This indicates that divisor can be zero.
> If so, a divide-by-zero bug will occur:
>   remainder = do_div(d, divisor);
> 
> Also, in the function mega_div64_32(), a divide-by-zero bug can also
> occur if divisor is NULL.
> 
> To fix these divide-by-zero bugs, the functions return 0 if divisor
> is zero.

How exactly is this fixing anything?  Simply returning zero because
there is a dividion by zero isn't a fix unless you know what that
return is going to do.  If you look at the inputs to all the
mega_div/mod functions, they're already checked for zero divisor before
calling, so the error handling is already being done correctly and this
"fix" would add nothing to that.  You can argue that the check and
print is pointless since the condition never occurs, but it's not
exactly fast path code.

James




