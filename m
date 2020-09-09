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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DAAC433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDF3320936
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:10:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oJyBWUry"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgIICJz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:09:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55976 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgIICJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:09:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08929fU2130925;
        Wed, 9 Sep 2020 02:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=N2X2IQDgc7o4BIYt/VZH27qWFcrc+h6onPu0wFTYFG4=;
 b=oJyBWUryIkWdN8KyRtnSBuH7KcP8+3zgF7sASa5tAhZ2Z2n2pF5xaFVxSnHixfbcmO5W
 1uouL5pkwNinYKfqG2ZlU3PQNNKrU20e0KqOgwj4c/pKfi43O48Pj6p+PAS+OlfEWKIh
 0jRwCyrH4tBXXPj0EaNPv3mcXWbNlXdIsCrrM8h5cH+615Xp7CUoFGG8a4X9GlRvgiHK
 2dLnoB9p0zOspnOaMaHJMEMFkJsKbKOOzwKZ65GHJv0PR5gxZdcaphWU+Z6UClyjiTk6
 hJiJk1H1K3Yi9qTg5/07rx9/HnOc82FypUHE49NVfJoXCKu/Buo/FFNXPIVWH0yUMHmH 4g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33c23qy0a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:09:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08925Zou069229;
        Wed, 9 Sep 2020 02:09:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33dacjq4km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:09:40 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08929dEO008056;
        Wed, 9 Sep 2020 02:09:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:09:39 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     GR-QLogic-Storage-Upstream@marvell.com, njavali@marvell.com,
        jejb@linux.ibm.com, Xianting Tian <tian.xianting@h3c.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix the return value
Date:   Tue,  8 Sep 2020 22:09:18 -0400
Message-Id: <159961731708.5787.17660244279632783700.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200829075746.19166-1-tian.xianting@h3c.com>
References: <20200829075746.19166-1-tian.xianting@h3c.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=883 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=915 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 29 Aug 2020 15:57:46 +0800, Xianting Tian wrote:

> A negative error code should be returned.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Fix the return value
      https://git.kernel.org/mkp/scsi/c/e5f48ac42cc9

-- 
Martin K. Petersen	Oracle Linux Engineering
