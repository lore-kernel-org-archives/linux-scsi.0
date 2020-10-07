Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB060C4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F811208C3
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q/Nzs65h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgJGDs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38630 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbgJGDsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973jV5b167245;
        Wed, 7 Oct 2020 03:48:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=j8fDQTVuwZPa2fmKbSZ3YxbcN9KZ2b+NKOGlC1lF7iQ=;
 b=Q/Nzs65hOxw09W0meVoeQSKZ5fQeMUNv8pqIGOtzRBb7Wac0HNxdju33Evtob6gp/Pf3
 JxaGivTFgAeiNw4jXUXisgAPjUfmIOSBfYog0FzhM6DU+5oyowsDrz+upJdR6DCaQ7h8
 TkY++GmL3RN0ToIFaGMFOEcEg1pVtJ3vx0HDq6efP4QkPk1tMjzbfRuqNmJwbk3luC8H
 +Rz/m3kMbDYXLU+hHVYklcg4cfpWscyfa/lvNQvLWo9+5DGnuJ4744YA0IDEIHy+f3lp
 sgNUmXw4pO7sBV1KIW4+X6oQYquiNp7+VTkVG6apMUbexZp77HnD2eQpHw50Rv/v16B7 SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxmydcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973ipJE194724;
        Wed, 7 Oct 2020 03:48:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3410jy2s44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:18 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0973mG1s025072;
        Wed, 7 Oct 2020 03:48:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:16 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "john.p.donnelly@oracle.com" <john.p.donnelly@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        michael.christie@oracle.com, bstroesser@ts.fujitsu.com
Subject: Re: [PATCH ] scsi: page warning: 'page' may be used uninitialized
Date:   Tue,  6 Oct 2020 23:47:55 -0400
Message-Id: <160204240577.16940.4774209189706661450.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200924001920.43594-1-john.p.donnelly@oracle.com>
References: <20200924001920.43594-1-john.p.donnelly@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=798 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=827 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 23 Sep 2020 17:19:20 -0700, john.p.donnelly@oracle.com wrote:

> corrects: drivers/target/target_core_user.c:688:6: warning: 'page' may be used
> uninitialized
> 
> Fixes: 3c58f737231e ("scsi: target: tcmu: Optimize use of
> flush_dcache_page")

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Fix warning: 'page' may be used uninitialized
      https://git.kernel.org/mkp/scsi/c/61741d8699e1

-- 
Martin K. Petersen	Oracle Linux Engineering
