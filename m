Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 210FAC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAFD56121E
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344809AbhDMSAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 14:00:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237095AbhDMSAJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Apr 2021 14:00:09 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DHYN4I162081;
        Tue, 13 Apr 2021 13:59:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=U7nzWoa4Un2bPY5SsxrTo5OO8NLlM3No+tvWVrBkyto=;
 b=Yvmsh+oEVqfjg9fldlxYCT55ZYoqaQUWGx6h6eSdZHb6YHL44w2nCcNHEePIQzjExiLi
 ciGx6Ajb2NCA0zLMEafhGmxXhz9MVa5PA2DjynIdJbJDuRmzhONq2j+Oi3VAYrbC3VEM
 lzBL7A0ScGjJqm+KogNP//CUDnKRza2LHOKDm1lKRwmMwcBR6ArGgworSdP4wpmquvQd
 iaPVaux7mPc92qSmoGzvn/XjvWB33F3ciKKThtG34l1vi4s+23ONAXrscYlxZLd3py6h
 GSInov3oXM5mmmc9eh5Z9/HdcH+gBbN+Wv+YmnhnsmjBv/BH13OPqd58JkJvGPMCkgRT hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkdhb0cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 13:59:35 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13DHYOUf162202;
        Tue, 13 Apr 2021 13:59:35 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkdhb0cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 13:59:35 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13DHr1KG025438;
        Tue, 13 Apr 2021 17:59:34 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 37u3n99cd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 17:59:34 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13DHxXRN33816964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 17:59:33 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34E4678064;
        Tue, 13 Apr 2021 17:59:33 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD2627805C;
        Tue, 13 Apr 2021 17:59:31 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.203.222])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 17:59:31 +0000 (GMT)
Message-ID: <605ae0b2be96ccaf15dc515dd67b4f32b289ba92.camel@linux.vnet.ibm.com>
Subject: Re: [PATCH 09/20] iscsi: Suppress two clang format mismatch warnings
From:   James Bottomley <jejb@linux.vnet.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Date:   Tue, 13 Apr 2021 10:59:30 -0700
In-Reply-To: <20210413170714.2119-10-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
         <20210413170714.2119-10-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PMCMrPjc2qor4ziP1CTRbpxyrjLNcpPS
X-Proofpoint-ORIG-GUID: sBVwAOMZUD8LtHCHpzFbeQ_WZHLrOZCQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_12:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 phishscore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130120
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-04-13 at 10:07 -0700, Bart Van Assche wrote:
> Suppress two instances of the following clang compiler warning:
> 
> warning: format specifies type 'unsigned short'
>       but the argument has type 'int' [-Wformat]
> 
> Cc: Lee Duncan <lduncan@suse.com>
> Cc: Chris Leech <cleech@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/libiscsi.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 7ad11e42306d..0c3082d09712 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3587,10 +3587,11 @@ int iscsi_conn_get_addr_param(struct
> sockaddr_storage *addr,
>  	case ISCSI_PARAM_CONN_PORT:
>  	case ISCSI_PARAM_LOCAL_PORT:
>  		if (sin)
> -			len = sprintf(buf, "%hu\n", be16_to_cpu(sin-
> >sin_port));
> +			len = sprintf(buf, "%hu\n",
> +				      (u16)be16_to_cpu(sin->sin_port));
>  		else
>  			len = sprintf(buf, "%hu\n",
> -				      be16_to_cpu(sin6->sin6_port));
> +				      (u16)be16_to_cpu(sin6-
> 

This looks odd: the generic definition of be16_to_cpu on le is

#define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))

and __swab16 is

#define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))

So why doesn't clang see the existing __u16 as short?  This smells like
a problem in the compiler file.

James


