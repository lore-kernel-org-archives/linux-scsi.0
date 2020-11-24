Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB384C63798
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FA0A2080A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jXccEQFQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgKXDOs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:14:48 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51172 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgKXDOs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:14:48 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO39tXa008956;
        Tue, 24 Nov 2020 03:14:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=ldFF5IXY6CEUyzmGNh6fCsABJDF4qn+Dj5jqif4qb+M=;
 b=jXccEQFQLTLbLD9YRyqy7OwzYmr8Hb0Ap5Hhm8t9DdYAcbPWSNTWEz3MQ0nrETqpzBU0
 qnwlstZXvrwafWyNIxodyOG9/vV7EftB4jU9jku5/X7GuNGG4iurwJnQCY17An9A9J/y
 T55QGwzFc85goHVqms9LyJIKCLm9vnLp9ffUSYKQPdyTnINeUYDKO7M2Og5iidUwHfYm
 81pgfFoN+GP+Qw9SgKQKdAJY4zv5hxW0UItOcJ3m16bSBwooIezhLLVKqLzHHeGLy7Ux
 f5wEM7hOZ0Z2GHmVWm71ckORoZoT9nYNE1WHkMO+591IQL11b8YmmuiZmM1ysbPAbhtH KQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34xrdarhpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:14:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO39vrx043513;
        Tue, 24 Nov 2020 03:14:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34ycfmq9ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:14:41 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AO3EeT5010062;
        Tue, 24 Nov 2020 03:14:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:14:40 -0800
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi/NCR5380: Reduce NCR5380_maybe_release_dma_irq()
 call sites
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1360zo38o.fsf@ca-mkp.ca.oracle.com>
References: <c1317ae8fdcb498460de5d7ea0bd62a42f5eeca8.1605847196.git.fthain@telegraphics.com.au>
Date:   Mon, 23 Nov 2020 22:14:38 -0500
In-Reply-To: <c1317ae8fdcb498460de5d7ea0bd62a42f5eeca8.1605847196.git.fthain@telegraphics.com.au>
        (Finn Thain's message of "Fri, 20 Nov 2020 15:39:56 +1100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=1 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Finn,

> Refactor to avoid needless calls to NCR5380_maybe_release_dma_irq().
> This makes the machine code smaller and the source more readable.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
