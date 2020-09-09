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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613FFC433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 314BC216C4
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:18:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TtuiMv01"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgIICSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:18:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44500 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIICR4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:17:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892FS7e170492;
        Wed, 9 Sep 2020 02:17:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=m/XtdR2vdX0S+4GesAuOfitLWHLAR3IRXFT8oo8F0AQ=;
 b=TtuiMv01+Bv43iANYfLI4/qp4u69vy/tiSKztF2MpxC4+xcAEF11bnd/PQNNtpa303S4
 FzU/hgUPYNuvS7/e/7NaWURLeXGdQek8hWY+FgJSpnHlDMZspUEWq0kwjto11jouk/A4
 mAHS1uUIl2R2dI+pa2t6aHGKYbpOwU6B/KsATqDaKl/kALmKvvX4Ki1JUpL8ZfFsSxWH
 WcOKZSrTONb0jEeqv4AsjQOIm7OE0mddrhbv2cWOaARRXRl/AdsxGh0OtKJ6kWrccUfv
 LLO9/zHLJeKHC8RZ8wLDM4pgUbcYbUT7RskITvKXanWo+pfmXFa9P1o6LxNxMPbi6hgG cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33c3amxuaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:17:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0892F2qE132062;
        Wed, 9 Sep 2020 02:17:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33cmk53yjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:17:45 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0892HhGB025760;
        Wed, 9 Sep 2020 02:17:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:17:43 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        jejb@linux.ibm.com, cang@codeaurora.org, hy50.seo@samsung.com,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        grant.jung@samsung.com, sc.suh@samsung.com, sh425.lee@samsung.com,
        Kiwoong Kim <kwmad.kim@samsung.com>, avri.altman@wdc.com,
        beanhuo@micron.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 0/2] ufs: introduce skipping manual flush for wb
Date:   Tue,  8 Sep 2020 22:17:28 -0400
Message-Id: <159961781205.6233.13227198149445873100.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1599285983.git.kwmad.kim@samsung.com>
References: <CGME20200905061548epcas2p1dc708a23247702c6b1f6c0eedc513a92@epcas2p1.samsung.com> <cover.1599285983.git.kwmad.kim@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=685 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=700 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 5 Sep 2020 15:06:50 +0900, Kiwoong Kim wrote:

> v3 -> v4: migrate these to 5.10
> v2 -> v3: modify some commit messages
> v1 -> v2: enable the quirk in exynos
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
