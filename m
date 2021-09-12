Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27E5C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 22:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C090860F6F
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 22:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhILWLz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 18:11:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1870 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235898AbhILWLz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Sep 2021 18:11:55 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18CM1tr8004784;
        Sun, 12 Sep 2021 18:10:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Q8DcEF1Ktdol74dMRHxgEz1eiQ1gRuE4K1C3AcydNS8=;
 b=TP9Ii6h5sK3qrkPhUHT5DRo+L/WkK+aYu3Ii88r9qIo+KgHqi4hFNMtC5gsh/pFYWJY+
 u+fRpFglw2zTx6ZDJaeA/4MS708EnRzRlpU1e28NXhE3lpUijyKPad19uklsPzlb22iQ
 5DFqYR29spcbdzIOQaY8/x7AqgFz9vYCEYD5zWlOvTjeZhj5KUIbXlP/QFpVshy7AW/N
 dN/TNvxIDQxi48Su83RfwVDOxSX5oYKc9tObmhoj/vrNElkFmGn41czH+Wmek2jvq2h/
 3tZ4JA5N9Dujcg6+W5VncfkPgLJNxUnLNK2ew5veE7M8aVqZ3YmLWdsXAIddX/7NS+3M +Q== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b19h9btb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Sep 2021 18:10:29 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18CMAOol030299;
        Sun, 12 Sep 2021 22:10:28 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02dal.us.ibm.com with ESMTP id 3b0m39ghqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Sep 2021 22:10:28 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18CMA0Bk26870212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Sep 2021 22:10:00 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3100378064;
        Sun, 12 Sep 2021 22:10:00 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A25F57805C;
        Sun, 12 Sep 2021 22:09:59 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.211.54.195])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 12 Sep 2021 22:09:59 +0000 (GMT)
Message-ID: <3e8ba5d8400969270e040d886a1b65c81974ff14.camel@linux.ibm.com>
Subject: Re: [PATCH 1/3] scsi: aic7xxx: fix building with -Werror (missing
 include)
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Adam Borowski <kilobyte@angband.pl>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Date:   Sun, 12 Sep 2021 15:09:58 -0700
In-Reply-To: <20210912213212.12169-1-kilobyte@angband.pl>
References: <20210912213212.12169-1-kilobyte@angband.pl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ahXAjpm7Kw15wZnHApNX9qakLRZXbshp
X-Proofpoint-ORIG-GUID: ahXAjpm7Kw15wZnHApNX9qakLRZXbshp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 clxscore=1011
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109120025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2021-09-12 at 23:32 +0200, Adam Borowski wrote:
> This is an userland helper tool to generate data rather than
> something compiled into the kernel, thus it wants regular POSIX
> functions.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
>  drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
> b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
> index 975fcfcc0d8f..2cd87ea86dfc 100644
> --- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
> +++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
> @@ -45,6 +45,7 @@
>  #include <sys/types.h>
>  
>  #include "aicdb.h"
> +#include <ctype.h>

I'm really dubious about trying to get aicasm to compile with -Werror
... the driver is dying and we have prebuilt firmware headers in the
tree so it's not like it's required.

I'm also curious: if you compiled with -Werror how did you get around
the missing function declarations induced by the -p mm in the bison
command line?

James


