Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC26EC3E8C5
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 18:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92D5821534
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 18:38:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fRwPmm4x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgK0Sh6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 13:37:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53402 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727833AbgK0Sh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Nov 2020 13:37:57 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ARIWJe1138418;
        Fri, 27 Nov 2020 13:37:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=h4wx81vHkvRi+FuCSL6QTzi3gU0LUvvB13sMqP1wjyc=;
 b=fRwPmm4xBJFeGO5xPLuOjea28AERTLLpsm/Z9GZaQRl2Nz8+TBSTjeoinFijnbqpTkZi
 xzUciZ8Yragi9x0jiFQDOO+/2T/zvZ2NXT4VP/lsaPZ74oQ7uCbbsEZFFE241Odz3HlF
 7Eh7zYd0DAqprDOZhN73pT8rK73KW4Nom5nIbBqGJULAOLUyB7bB1WNSvbZ5GySg+em3
 CM0Cy5iuQkseinxzm889sEvrt2CzKM6sVdrnLAGB8wFSTmFJupdibYSLTveDpM/JJ2dL
 lryqdK2Br2yoe2z1WthzfQyCGYUdatf9+7erO4sMCzPKvoPG13cXSgz6P9st/OeuQjx1 NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3536n3rae5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 13:37:49 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ARIWdo7139302;
        Fri, 27 Nov 2020 13:37:49 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3536n3rady-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 13:37:49 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ARIYxJe015304;
        Fri, 27 Nov 2020 18:37:48 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 352xhwk0kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 18:37:48 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ARIblKg20382110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 18:37:47 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D50FB78060;
        Fri, 27 Nov 2020 18:37:47 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C57E978063;
        Fri, 27 Nov 2020 18:37:46 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.194.234])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 27 Nov 2020 18:37:46 +0000 (GMT)
Message-ID: <841ba4da542c338281eab9f335bbf496cb6b3f69.camel@linux.ibm.com>
Subject: Re: [PATCH] [SCSI] sym53c8xx: remove trailing semicolon in macro
 definition
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     trix@redhat.com, willy@infradead.org, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 27 Nov 2020 10:37:45 -0800
In-Reply-To: <20201127182906.2804973-1-trix@redhat.com>
References: <20201127182906.2804973-1-trix@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_10:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 lowpriorityscore=0 spamscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-11-27 at 10:29 -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> The macro use will already have a semicolon.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/scsi/sym53c8xx_2/sym_glue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c
> b/drivers/scsi/sym53c8xx_2/sym_glue.c
> index d9a045f9858c..f3b3345c1766 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> @@ -1001,12 +1001,12 @@ static int is_keyword(char *ptr, int len,
> char *verb)
>  #define SKIP_SPACES(ptr, len)					
> 	\
>  	if ((arg_len = sym_skip_spaces(ptr, len)) < 1)			
> \
>  		return -EINVAL;						
> \
> -	ptr += arg_len; len -= arg_len;
> +	ptr += arg_len; len -= arg_len
>  
>  #define GET_INT_ARG(ptr, len, v)					
> \
>  	if (!(arg_len = get_int_arg(ptr, len, &(v))))			
> \
>  		return -EINVAL;						
> \
> -	ptr += arg_len; len -= arg_len;
> +	ptr += arg_len; len -= arg_len

Those macros have the wrong form which can lead to actual bugs and this
cosmetic change does nothing to fix it.  If the goal here is to get the
code base into better shape, please fix the bugs.

James


