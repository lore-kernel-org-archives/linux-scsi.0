Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8451CC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CAD723426
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:59:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QvlXEEss"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgFTD7u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 23:59:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49820 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFTD7t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 23:59:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3xYGG069386;
        Sat, 20 Jun 2020 03:59:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=jCH3I8fpRAneS91Ia94tA1cV8cpC1hPLFvD4x1EGC0k=;
 b=QvlXEEss6T6r9k7y0sfcxvKYyepruSnUGRqIoK9/XJtFSLs1IsxQIjS69RSblTNsEGwJ
 Pu6HKtZL+eixxjGe9i8SrbSscHYWUUDlt7SkL5ShyCD4nS8IWusT7RFGqVK+rMUjnE4a
 Z3Zy7iKnDvaufjGPag6kxCfwCg4OW/VlR80eIgjk/Ph4jiW/WLA1x/wZ2kcTPH2zPadI
 /UhJQwxGetGZsuW+3hnJi2eJ4gKepn8EODjg7HU/bcVIz8+uybD4OLHMwGL1U328LP61
 RcgaaO1Op12eJa+pkqDrTaIOQc+X0kRwlYzOwyW9m8LIko5o0OSnxNu0Uw9jU7NtP9AU Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31s9vqr37g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 20 Jun 2020 03:59:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3vT10097770;
        Sat, 20 Jun 2020 03:59:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31sa8ykcyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Jun 2020 03:59:33 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05K3xTn1023442;
        Sat, 20 Jun 2020 03:59:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 20:26:46 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, Stanley Chu <stanley.chu@mediatek.com>,
        jejb@linux.ibm.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, asutoshd@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        bvanassche@acm.org, kuohong.wang@mediatek.com,
        chun-hung.wu@mediatek.com, chaotian.jing@mediatek.com,
        matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org,
        peter.wang@mediatek.com, cc.chou@mediatek.com,
        andy.teng@mediatek.com, linux-mediatek@lists.infradead.org,
        beanhuo@micron.com, linux-kernel@vger.kernel.org,
        cang@codeaurora.org
Subject: Re: [PATCH] scsi: ufs-mediatek: Make ufs_mtk_wait_link_state as static function
Date:   Fri, 19 Jun 2020 23:26:38 -0400
Message-Id: <159262354733.7800.6869131850805388311.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200616095120.14570-1-stanley.chu@mediatek.com>
References: <20200616095120.14570-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006200026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 phishscore=0 cotscore=-2147483648 spamscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006200026
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 16 Jun 2020 17:51:20 +0800, Stanley Chu wrote:

> Fix build warning reported by kernel test robot:
> Make ufs_mtk_wait_link_state() as static functon.
> 
> Warning:
> >> drivers/scsi/ufs/ufs-mediatek.c:181:5: warning: no previous prototype
> >> for 'ufs_mtk_wait_link_state' [-Wmissing-prototypes]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: ufs-mediatek: Make ufs_mtk_wait_link_state static
      https://git.kernel.org/mkp/scsi/c/9a3cd470f8e3

-- 
Martin K. Petersen	Oracle Linux Engineering
