Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D22C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6734A2075D
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XvYZgv3l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgHEBTl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:19:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52752 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgHEBTk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 21:19:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751IRXw151208;
        Wed, 5 Aug 2020 01:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=1jOtOQA1LUi7mTwyvg/5FCv9knqOxllAIOSH8yhMBDc=;
 b=XvYZgv3ltEDC8a6D4D3s8QAxkj109id18i03iaBcBDigVdLcRVUz4bwIKpg4a7a4ph8t
 RrHuFV2Nddylgq2uF8WpH/VeFN9yfssikMKeLMHFatJgo2cLGUG4WvmKU4o6TA5LqDX8
 cbKTtdVlLEUgKMzB8JWXoGoCbUVBXaL7A3+kbf6VuwhcYfTW36ZwHLNRAl/dgpeYcPe4
 FG9Sr69DyANw0hjQtGj2ORYOdbl8w0im21pRcnOCuri0ZwFF5H5wS1PomAR9Y9LLOgEd
 3pHnBoEiOuzb1HHSE4YyGsmVQJ7/02Ff7yxGXOnBNDHZaHFlVunj1+rsoL92WCiMvcY3 Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32n11n7atk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 01:19:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 075192ZS177679;
        Wed, 5 Aug 2020 01:17:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32pdhd72hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 01:17:38 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0751Hbej002269;
        Wed, 5 Aug 2020 01:17:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Aug 2020 18:17:36 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH 0/2] qedf: Memory leak fixes for fcoe and libfc.
Date:   Tue,  4 Aug 2020 21:17:30 -0400
Message-Id: <159659019688.15726.14848382518927575613.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200729081824.30996-1-jhasan@marvell.com>
References: <20200729081824.30996-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Jul 2020 01:18:22 -0700, Javed Hasan wrote:

> This series has fixes for memory leaks report by
> KMEMLEAK tool.
> 
> Kindly apply this series to scsi-queue at your earliest convenience.
> 
> Thanks,
> Javed Hasan
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: libfc: Free skb in fc_disc_gpn_id_resp() for valid cases
      https://git.kernel.org/mkp/scsi/c/ec007ef40abb
[2/2] scsi: fcoe: Memory leak fix in fcoe_sysfs_fcf_del()
      https://git.kernel.org/mkp/scsi/c/e95b4789ff43

-- 
Martin K. Petersen	Oracle Linux Engineering
