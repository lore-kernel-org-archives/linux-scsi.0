Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC5BC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 21:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99FDA20936
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 21:51:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Etyt4ep5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgIOVu4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 17:50:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49118 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728118AbgIOVua (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 17:50:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKApmF178727;
        Tue, 15 Sep 2020 20:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=l5Xi/C8aaybK1Dc/nZ423mkSftz9BwpE+EYiCy9WCYo=;
 b=Etyt4ep5ZT7t/odhrnUeEuahCvdxq+O/2Snma7d1YF3F1Ey/JjYpDTnTLIzkGmuMSnJc
 U1y/CTkqm1VqvtkAFQ63lWJ9J8pT3cN0uuqAWoQH+EVV4NBXmGWuJL1MhQ/M2DpoRCDU
 i7C/P/qyqc7EOj/6K2IZSlc4aUSop2h0xb/EJrFHRT2VSV1Onj6Bjzt8OxhO/44aNqdn
 YeUNgiXBTiBoYQc5rHSHXMlcKLqH8mzKsjnKQ4QNE24asEYF/wqaU9f6dw260N6WxbZo
 W+XSnwr+hyijySctYoDoCr0AiXRPZ4mIXioSv3U0Pz6JX+ZV+5lSnBEZLkti4GO2oUjM JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dh0yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 20:16:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKFvSx127227;
        Tue, 15 Sep 2020 20:16:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33h7wppqdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 20:16:38 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08FKGbi1007837;
        Tue, 15 Sep 2020 20:16:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 20:16:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org, avri.altman@wdc.com, sfr@canb.auug.org.au,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: ufs: Fix 'unmet direct dependencies' config warning
Date:   Tue, 15 Sep 2020 16:16:22 -0400
Message-Id: <160020074003.8134.16280505616303761957.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200721172021.28922-1-alim.akhtar@samsung.com>
References: <CGME20200721174310epcas5p2a448e38c6e4d5e36e9f0417f5ddced6d@epcas5p2.samsung.com> <20200721172021.28922-1-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150157
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

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: ufs: Fix 'unmet direct dependencies' config warning
      https://git.kernel.org/mkp/scsi/c/09fd5f0ddf32

-- 
Martin K. Petersen	Oracle Linux Engineering
