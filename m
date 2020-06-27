Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65ECBC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 03:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4626B20675
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 03:11:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="clKcd3HO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgF0DLq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 23:11:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgF0DLp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 23:11:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R38ong140958;
        Sat, 27 Jun 2020 03:11:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=sQBX73TqNbUyn6ym7VFS9Yl0OeMN/171ugy0yt0jhMs=;
 b=clKcd3HOYRXO9YxZ1hGlZ0IDW/fcbssrGao4BO1MbDP59Hzp8DX80CBAY8r/yzq0ylin
 GxdL/NbosQEq/lA+RSiMgJwLSM09Vlq1envFFeDZ1jrViVl1gGo7XhlMaB3d2STIv8ug
 hOhCIm+2FiXRvQ14RibF1iFvswFaB5wpxrLEEDfGGDV18gHr+PqCVods/6KNDzGUTIst
 5I4CD9BV9Y715qUvA4IGnBj/zWsdA+bqfoVZOb2LKt/JCsXBkIOUQwo3PrXGZNJjPlZ3
 Ov2gdoPnuEnTFF27FRzx/jULeyQcpMNhiVrlp755IoNZswO4dncckNR+YJjglkTp2uQv 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31wg3bkcgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 03:11:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R38As7099359;
        Sat, 27 Jun 2020 03:09:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31wv58tepn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 03:09:30 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05R39QEH010858;
        Sat, 27 Jun 2020 03:09:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 03:09:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, avri.altman@wdc.com
Subject: Re: [PATCH -next] scsi: ufs: ufs-exynos: Fix build warning
Date:   Fri, 26 Jun 2020 23:09:21 -0400
Message-Id: <159322718419.11145.14804520637406365359.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625154405.60448-1-alim.akhtar@samsung.com>
References: <CGME20200625160323epcas5p3f36a90efa2bf7bcbdd71bdccf2a20eb0@epcas5p3.samsung.com> <20200625154405.60448-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 malwarescore=0 cotscore=-2147483648 adultscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 25 Jun 2020 21:14:05 +0530, Alim Akhtar wrote:

> While building for x86_64 allmodconfig, below warning reported
> 
> WARNING: modpost: missing MODULE_LICENSE() in drivers/scsi/ufs/ufs-exynos.o
> 
> Add the missing license/author/description tags.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-exynos: Fix build warning
      https://git.kernel.org/mkp/scsi/c/6c9b3b2aa2df

-- 
Martin K. Petersen	Oracle Linux Engineering
