Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F78C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62DE221655
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:37:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mzj4D58W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfLSXhH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:37:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53092 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbfLSXhG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 18:37:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNTnmt096649;
        Thu, 19 Dec 2019 23:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=lXC88CeuJumpWhrYqVXy3Wn+OqgIQdMtht7Ikw4+6Bc=;
 b=mzj4D58WY7cy1xhr9gLspHYKzhw/fl8cDbWiTpU8U9aPF0qBsvCKYNTMatQ3bEnersS7
 TvgBW0BrvY9X/AElcDHvUtinby6d7AdSR5bc9RzdAou29KMaZrLoLtMDwSVyfVJP5rO1
 u6jPcZyWazkSijB5Gvi1B8vXgItvjOdjnV2RyG47DNkPcj5pd+Rb/slps/h3AOi7X2DD
 savd+avxl1RYusPL58rCFYbjvRVl+Mg24+37UX14Fytt1kTg7A5AgE1UKlyV7VjoAzCC
 tOO5difA8GDdLHwt5t5yNY1JHqafjoRhzDbNrHmfrMJaQ3VjlzhUySTG9g+wIJw0AIJx ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x01jadu2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:37:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNYFWr181141;
        Thu, 19 Dec 2019 23:37:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x04ms6nkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:37:02 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBJNaxse019855;
        Thu, 19 Dec 2019 23:37:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Dec 2019 15:36:59 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Fix a compiler warning triggered by the SCSI logging code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191209174205.190025-1-bvanassche@acm.org>
Date:   Thu, 19 Dec 2019 18:36:57 -0500
In-Reply-To: <20191209174205.190025-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Mon, 9 Dec 2019 09:42:05 -0800")
Message-ID: <yq1lfr7c2g6.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912190173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912190173
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch fixes the following compiler warning:
>
> In file included from drivers/scsi/scsi_error.c:46:
> drivers/scsi/scsi_error.c: In function 'scsi_eh_target_reset':
> drivers/scsi/scsi_logging.h:65:81: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
>    65 | LOGGING(SCSI_LOG_ERROR_SHIFT, SCSI_LOG_ERROR_BITS, LEVEL,CMD);
>       |                                                              ^

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
