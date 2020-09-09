Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39B9C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 971B2216C4
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZOAvQaMq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgIICTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:19:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33698 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgIICTx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:19:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892JiYY151430;
        Wed, 9 Sep 2020 02:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=j7WP0glQ2ZDDUS2obEoWYicFVU5oFZMWQcI0doLFy7o=;
 b=ZOAvQaMqnVtmIz88QRKcuUwvLK44j4qw9F3wScn2rylASPLYywn3EaY6DqW5Ok57kYPC
 fDqxs1zh2W2C4ZDv3sW/8N/rmslgsMb4KeNrszwUkWiXtP9WUjz5wiGu3VjVC5n/IGrv
 Pemt7K+CpWtKam/c9eNctQycNyESyKsHDlGt4qdMrueKLpsIyw/em/IDuI9mtu3ECkAl
 YgLyoD/R0olZSlvGpvmhRcnDvPFboOdA8P/g9MQItZBm4+4mkSAnZYwX7eJBGN32ivym
 1kB65woUHH5BUllY1Y2NkDkCbkFUFnAcGYGejk/xVHV1y2yoyRW9QAgkwSM5MuKEz121 /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33c23qy125-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:19:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892FRbI026689;
        Wed, 9 Sep 2020 02:17:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33cmerxmrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:17:43 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0892Hg9w015285;
        Wed, 9 Sep 2020 02:17:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:17:42 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        jejb@linux.ibm.com, cang@codeaurora.org, hy50.seo@samsung.com,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        grant.jung@samsung.com, sh425.lee@samsung.com,
        Kiwoong Kim <kwmad.kim@samsung.com>, sc.suh@samsung.com,
        avri.altman@wdc.com, beanhuo@micron.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] ufs: change the way to complete fDeviceInit
Date:   Tue,  8 Sep 2020 22:17:27 -0400
Message-Id: <159961781204.6233.7354150485011455115.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1597053747-75171-1-git-send-email-kwmad.kim@samsung.com>
References: <CGME20200810101054epcas2p2e1a4a550e7f4732e2ad1ee127317b0d2@epcas2p2.samsung.com> <1597053747-75171-1-git-send-email-kwmad.kim@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=758 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=764 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 10 Aug 2020 19:02:27 +0900, Kiwoong Kim wrote:

> Currently, UFS driver checks if fDeviceInit
> is cleared at several times, not period. This patch
> is to wait its completion with the period, not retrying.
> Many device vendors usually provides the specification on
> it with just period, not a combination of a number of retrying
> and period. So it could be proper to regard to the information
> coming from device vendors.
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: ufs: Change fDeviceInit busy wait
      https://git.kernel.org/mkp/scsi/c/29707fab5845

-- 
Martin K. Petersen	Oracle Linux Engineering
