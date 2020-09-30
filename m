Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC7CC4727C
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 03:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C59E420773
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 03:37:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jm5k0/c3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgI3DhI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 23:37:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50656 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgI3DhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 23:37:08 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3O6oC146628;
        Wed, 30 Sep 2020 03:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=sdwiHpsg0mtuzYoRYPEdkF1mlWyxeqhFFuNURHlyQZo=;
 b=jm5k0/c39pJLie3wK9LW52avPCpQubRezMNchTeOFqpc8Z9RiLQ21wFWZleVayQsCKsV
 EDczJUzMXlcUXri9SegSLaUOm6Twdur7Z+t3yBVwPqGIMHX6J080IbypwD3vhYu5t3de
 O5BxiuKdewNV1IDcU5tGR6OAOmWzAIa+PNoFmWnI/7MZGFU772hxUXcVjwLEZfyGNU5b
 5v9B/jIeAvzn53Jt1Yf00SprsHJ2OHMsApov+0/xWuG5oPcFGznRWHqrwsddpaMRSNOT
 2QT0pSpxF1MsTROW8abFSSe2dbsWWbUx2G+YPq5xAxaVBD+LDxI/Rc/whI86xXZudE0+ 4Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33su5axc7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 03:36:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3QVGQ064737;
        Wed, 30 Sep 2020 03:34:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33tfhygkx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 03:34:57 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08U3YuWG027463;
        Wed, 30 Sep 2020 03:34:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 20:34:56 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] scsi: bnx2i: remove unnecessary mutex_init()
Date:   Tue, 29 Sep 2020 23:34:49 -0400
Message-Id: <160143685413.27701.17988094324324512937.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916062133.191000-1-miaoqinglang@huawei.com>
References: <20200916062133.191000-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 16 Sep 2020 14:21:33 +0800, Qinglang Miao wrote:

> The mutex bnx2i_dev_lock is initialized statically. It is
> unnecessary to initialize by mutex_init().

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: bnx2i: Remove unnecessary mutex_init()
      https://git.kernel.org/mkp/scsi/c/97d0e04d38b4

-- 
Martin K. Petersen	Oracle Linux Engineering
