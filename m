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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06724C2BC11
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C53A12177B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:18:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xqqrHZd8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgIICSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:18:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46602 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIICR4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:17:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892EU1Z110441;
        Wed, 9 Sep 2020 02:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=0wD2yesqk5pSiJMtBVOyuvHAfACcnxK34z/yqaY/8MA=;
 b=xqqrHZd8m6Q4f0/q8vtmRS3YbX68+fWK6BQgvypg7pZPqZC3vcPzzktcHccUu1mKn5+B
 7osoxfslR0Sq0R6Q1xYYWqisamfHc+noUf+/eOrB6FkdRfC2nbjzTA47OAm+vkXMsjh5
 knmGn5mMDJm/LQkLMu9gyeG04CF2rZWeYXuuG1jJX5bc1z3r/tRlYMBXMkaxNCk4wUAo
 Rk0OSe1G/wmi7BLOtF7sI/7cF2qlHhYRCBHH9t2ywN3hH3WnuMl1LI+tdLwHFFURg/cU
 Lq2RBNPINQT198AZevZhQ4M1todKmBhlIW527H4CawvAGMS6x5yiI/NnWDcoP7nwCTRp RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33c2mkxw9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:17:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892FaiB109619;
        Wed, 9 Sep 2020 02:17:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33dacjqc2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:17:43 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0892HfIU025687;
        Wed, 9 Sep 2020 02:17:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:17:40 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        jejb@linux.ibm.com, cang@codeaurora.org, hy50.seo@samsung.com,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        grant.jung@samsung.com, sh425.lee@samsung.com,
        Kiwoong Kim <kwmad.kim@samsung.com>, sc.suh@samsung.com,
        avri.altman@wdc.com, beanhuo@micron.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/2] ufs: introduce skipping manual flush for wb
Date:   Tue,  8 Sep 2020 22:17:26 -0400
Message-Id: <159961781205.6233.10247748545654822084.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1598319701.git.kwmad.kim@samsung.com>
References: <CGME20200825015200epcas2p2aef1427e960c86e7da08dc4608f20e26@epcas2p2.samsung.com> <cover.1598319701.git.kwmad.kim@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=838 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1011 mlxlogscore=853
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 25 Aug 2020 10:43:14 +0900, Kiwoong Kim wrote:

> v1 -> v2: enable the quirk in exynos
> v2 -> v3: modify some commit messages
> 
> We have two knobs to flush for write booster, i.e.
> fWriteBoosterBufferFlushDuringHibernate and fWriteBoosterBufferFlushEn.
> However, many product makers uses only fWriteBoosterBufferFlushDuringHibernate,
> because this can reportedly cover most scenarios and
> there have been some reports that flush by fWriteBoosterBufferFlushEn
> could lead to raise power consumption thanks to unexpected internal
> operations. So we need a way to enable or disable fWriteBoosterEn
> operations. For those case, this quirk will allow to avoid manual flush
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/2] scsi: ufs: Introduce skipping manual flush for Write Booster
      https://git.kernel.org/mkp/scsi/c/5df6f2def50c
[2/2] scsi: ufs: exynos: Enable UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
      https://git.kernel.org/mkp/scsi/c/7973b8ac669e

-- 
Martin K. Petersen	Oracle Linux Engineering
