Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB09AC63777
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64AA720866
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:25:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oxSJ8ybs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgKXDZS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:25:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgKXDZR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:25:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3Aa9x070454;
        Tue, 24 Nov 2020 03:25:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=mhHx85ik1onY5BRd3YDTxLGB4IyUoU/YipJlzt03SOU=;
 b=oxSJ8ybsXh3nTcR/zNM+GtrhsqfoNwdqBWy82KvwKboXdQTwfZtHZnW7nT6v2cf/A/qh
 KbUZfv5LS5BgJnnastog/wZwkzRpM5epZwpJGNEXZtiOtojuz/z7rM5vlG4ryBj48ovD
 1gcCsaZeSK1nY5ZM5MWPxVelV8XYyDIIwiJwnl5W4XsKC4dAxsLD4zoQZfiuzWDZAHwS
 pU9BYjJbRG4hU7G8yfb3qDz/eR02wISXDySMBLxZHDsGz9NWK2DGwb0tkrheTdj2D815
 JsaeV2AHlPrPemOk9ORNyg9EKXOKVqLpPQUOGI7b2lsk+9uQQJX4asm0+yG0qy6n28hY 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34xtum0c5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:25:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO39mYC160846;
        Tue, 24 Nov 2020 03:23:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34yx8j9avb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:23:09 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AO3N7lg013849;
        Tue, 24 Nov 2020 03:23:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:23:07 -0800
To:     Joe Perches <joe@perches.com>
Cc:     linux-scsi@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: pm8001: logging neatening
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1ojmoa5.fsf@ca-mkp.ca.oracle.com>
References: <cover.1605914030.git.joe@perches.com>
Date:   Mon, 23 Nov 2020 22:23:05 -0500
In-Reply-To: <cover.1605914030.git.joe@perches.com> (Joe Perches's message of
        "Fri, 20 Nov 2020 15:16:08 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 mlxlogscore=890 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxlogscore=902 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1015 suspectscore=1 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Joe,

> Reduce code duplication and generic neatening of logging macros

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
