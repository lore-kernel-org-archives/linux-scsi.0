Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC4BCDB465
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 01:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbjJQBQe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 21:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjJQBQd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 21:16:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CFE9B
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 18:16:32 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKO4nD027764;
        Tue, 17 Oct 2023 01:12:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=opnExgwbbL1TNsd4q1u0OvZXeCsyuI9xelnxo5wUzj0=;
 b=F0S48YwnX2g5IEITg60c+onhuzMPETjCam9/JZF3i1uEg7tdRMldNAqrp6t9Ji+rf2GU
 cD/lnYtZPapUaUJCm8r7R6LseHrNkLjWQGGtynNtrz80BS4GyphHOkn5CFJvNQ4Q3rNb
 pKq1tDx4Y74qwU4QNOWkip9vOSqZrKU16LFEUTS68ThNif3Jqk+xsKbluJ3ZnYiRzkV6
 xrz9WZYW644ZH72BTDDgrMNo10xI42uY8hYj1CNDz6/R7z6VIKHhjvntX+bOuUjLY50h
 TxQ4Ep2b8CdBbOrFnAuZnQJRITFiwcngj/mP0ObFJAA2mWuPH2QWQKOffEESfoXC/1Ih Gw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cc2kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GMeXsj027313;
        Tue, 17 Oct 2023 01:12:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg5366s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:13 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39H1C3sw039761;
        Tue, 17 Oct 2023 01:12:13 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3trg5366mf-9;
        Tue, 17 Oct 2023 01:12:13 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        peter.wang@mediatek.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
Subject: Re: [PATCH v2 0/3] Fix abnormal clock scaling behaviors
Date:   Mon, 16 Oct 2023 21:11:56 -0400
Message-Id: <169750286898.2183937.14025381804375591209.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230831130826.5592-1-peter.wang@mediatek.com>
References: <20230831130826.5592-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=919 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170008
X-Proofpoint-ORIG-GUID: Krpi_kbYhiiJotK72Z1Mddkto6w1PVPk
X-Proofpoint-GUID: Krpi_kbYhiiJotK72Z1Mddkto6w1PVPk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 31 Aug 2023 21:08:23 +0800, peter.wang@mediatek.com wrote:

> This patch fix abnormal clock scaling behaviors.
> 
> Peter Wang (3):
>   ufs: core: only suspend clock scaling if scale down
>   ufs: core: fix abnormal scale up after last cmd finish
>   ufs: core: fix abnormal scale up after scale down
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/3] ufs: core: only suspend clock scaling if scale down
      https://git.kernel.org/mkp/scsi/c/1d969731b87f
[2/3] ufs: core: fix abnormal scale up after last cmd finish
      https://git.kernel.org/mkp/scsi/c/6fd53da45bbc
[3/3] ufs: core: fix abnormal scale up after scale down
      https://git.kernel.org/mkp/scsi/c/b50d9c27a31e

-- 
Martin K. Petersen	Oracle Linux Engineering
