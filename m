Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A767C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 04:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0397620771
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 04:32:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qXbsdmtJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgGVEch (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 00:32:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgGVEch (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 00:32:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M4WIs6047454;
        Wed, 22 Jul 2020 04:32:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=tp6tdBHBpJR6JE4Frp8m2gMHq6jVvxiYCj//YcAmygI=;
 b=qXbsdmtJ+KIGn1yJV9Ym2uGxL0I7IbJhaKF/ELhxHqpI+PIIi8yq46hA4K7UpoQjEg50
 dZZnVp5kjgZWBn9NxNO1njhUSiNOsCFnFr+2MiTUNG0iB/Q/pio64xrmUsH2FnGZY0yd
 35Pe5k9OAIQ48XkeymtweVjQMgJ/KQ9qSBIrZ1aGRYqQEx09vnZ8L3aPz5gFkqF3BEJM
 dhp9feefP4B0LFjgtPRRdd2oGxo8fpUgTuZoByRGrD1fb+VrRarZ1hfce8erUkV/809b
 QuYEz8F6+1/Q7z1+hIg7GeQZAHDiAm/eEkde/6oIp8vb/p3ga6k8bIOdrkny2qzOoFwG 3Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32d6ksn212-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jul 2020 04:32:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M4S2Es028421;
        Wed, 22 Jul 2020 04:28:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32eberx739-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jul 2020 04:28:36 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06M4SWVL007842;
        Wed, 22 Jul 2020 04:28:33 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jul 2020 04:28:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org, linux-scsi@vger.kernel.org,
        avri.altman@wdc.com, sfr@canb.auug.org.au
Subject: Re: [PATCH -next] scsi: ufs: Fix 'unmet direct dependencies' config warning
Date:   Wed, 22 Jul 2020 00:28:28 -0400
Message-Id: <159539205428.31352.7267329919056051728.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200721172021.28922-1-alim.akhtar@samsung.com>
References: <CGME20200721174310epcas5p2a448e38c6e4d5e36e9f0417f5ddced6d@epcas5p2.samsung.com> <20200721172021.28922-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 21 Jul 2020 22:50:21 +0530, Alim Akhtar wrote:

> With !CONFIG_OF and SCSI_UFS_EXYNOS selected, the below
> warning is given:
> 
> WARNING: unmet direct dependencies detected for PHY_SAMSUNG_UFS
>   Depends on [n]: OF [=n] && (ARCH_EXYNOS || COMPILE_TEST [=y])
>   Selected by [y]:
>   - SCSI_UFS_EXYNOS [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && SCSI_UFSHCD_PLATFORM [=y] && (ARCH_EXYNOS || COMPILE_TEST [=y])
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: ufs: Fix 'unmet direct dependencies' config warning
      https://git.kernel.org/mkp/scsi/c/7f1c8efd28f7

-- 
Martin K. Petersen	Oracle Linux Engineering
