Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197C4C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED40B20734
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:00:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ahvS33MV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgFPEA3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 00:00:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41416 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgFPEA2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 00:00:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3vNlR193977;
        Tue, 16 Jun 2020 04:00:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=9mYnWgmHaH/MeQG/NrcARCrv81ptgulbq0w8SFiNXFQ=;
 b=ahvS33MV2cLeVTuOp5if0A6Ujdk2z2OTVZSWuvtJD1hchox23qMdeucpKP93hKcFafs/
 dAVGcy842hFz7wXKnnXUCoE+fGo5jCSve846yj+IT3GIIrys8jceKflJUuNmehZ71FFX
 mvOTNHTwHBhUqBzp2b1JGyD0ffIGYep15S5Mum9L0ofIfVYzMEq5uPRpaeRpPsJHjyvI
 G+GrokJd3JB2ZwMqekfJd1tdWwW8R1f22mTM22k/L5I6Q5HQEIle7RYlA69mAKy/tS9S
 AaU+NRW4OiJDnJCND3OoYfgrmJyoF9hfuamtv5w5Z3FeXBKGer4PI2KadkV029te/0Qq 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31p6e5vd9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 04:00:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3x2Bf181553;
        Tue, 16 Jun 2020 04:00:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31p6dfarqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 04:00:04 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05G400YL022205;
        Tue, 16 Jun 2020 04:00:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 21:00:00 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>, robh@kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        cang@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        kwmad.kim@samsung.com, avri.altman@wdc.com,
        linux-samsung-soc@vger.kernel.org, krzk@kernel.org, kishon@ti.com
Subject: Re: [RESEND PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
Date:   Mon, 15 Jun 2020 23:59:51 -0400
Message-Id: <159227986421.24883.4622397536612649352.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200613024706.27975-1-alim.akhtar@samsung.com>
References: <CGME20200613030436epcas5p38137bcaddd80ec5eed746a80a1fe31f5@epcas5p3.samsung.com> <20200613024706.27975-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006160027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 13 Jun 2020 08:16:56 +0530, Alim Akhtar wrote:

> This patch-set introduces UFS (Universal Flash Storage) host controller support
> for Samsung family SoC. Mostly, it consists of UFS PHY and host specific driver.
> 
> - Changes since v9
> * fixed the review comments by Rob on ufs dt bindings
> * Addeded Rob's reviwed-by tag on 08/10 patch
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[01/10] scsi: ufs: Add quirk to fix mishandling utrlclr/utmrlclr
        https://git.kernel.org/mkp/scsi/c/871838412adf
[02/10] scsi: ufs: Add quirk to disallow reset of interrupt aggregation
        https://git.kernel.org/mkp/scsi/c/b638b5eb624b
[03/10] scsi: ufs: add quirk to enable host controller without hce
        (no commit info)
[04/10] scsi: ufs: Introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
        https://git.kernel.org/mkp/scsi/c/26f968d7de82
[05/10] scsi: ufs: Add quirk to fix abnormal ocs fatal error
        https://git.kernel.org/mkp/scsi/c/d779a6e90e18
[09/10] scsi: ufs: ufs-exynos: Add UFS host support for Exynos SoCs
        https://git.kernel.org/mkp/scsi/c/55f4b1f73631

-- 
Martin K. Petersen	Oracle Linux Engineering
