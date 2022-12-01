Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC65C4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiLADqN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiLADp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:45:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5193792A0C
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:45:54 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1297He022941;
        Thu, 1 Dec 2022 03:45:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=lChkuJ/VglMK3AWvOJGhkWP9FmAcEYhzT+yr9oS0sKU=;
 b=LHSG9L7e1Spj48T3dpP2BSbDmvWn9okl1mQurkJeKNK2wCSwpIoCKR6RTIfNkKb4GGzO
 TqVp1w3WmhCvg2oWvuHqPGAvjZ3jPC+1XJv+Najvi/gwZ5KgEaQtQuQKAfmAYmMD+t0Z
 pHgHkjKVxvyqjtRZZx85uZyyZYDIW9yaZI0MePAG99H3ZUMy0ar8nw8pJicWC/A/JKpy
 lbF6/zjHsxwtyvPjlbD8Lj6rEqFZn45bIzMLEWwKXmilz57m3dk07Oxt24ng0I9h3z6q
 CQiMzBwuSkO2Aph1mVA7kIYA2wit2R0xlYB8049OwWETnQbBx4mErOWQNX6nk2XBtGI8 6A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3xhtbnqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:50 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B110D3b007662;
        Thu, 1 Dec 2022 03:45:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2cs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:50 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbpk033801;
        Thu, 1 Dec 2022 03:45:49 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-13;
        Thu, 01 Dec 2022 03:45:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Gleb Chesnokov <gleb.chesnokov@scst.dev>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] qla2xxx: Initialize vha->unknown_atio_[list, work] for NPIV hosts
Date:   Thu,  1 Dec 2022 03:45:14 +0000
Message-Id: <166986602288.2101055.4262680155258064264.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <376c89a2-a9ac-bcf9-bf0f-dfe89a02fd4b@scst.dev>
References: <376c89a2-a9ac-bcf9-bf0f-dfe89a02fd4b@scst.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=908 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010022
X-Proofpoint-GUID: R9x8_DlMN7QhuwPeYMNmjj9QtXjfQaY2
X-Proofpoint-ORIG-GUID: R9x8_DlMN7QhuwPeYMNmjj9QtXjfQaY2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Nov 2022 12:38:08 +0300, Gleb Chesnokov wrote:

> Initialization of vha->unknown_atio_list and vha->unknown_atio_work
> only happens for base_vha in qla_probe_one_stage1(). But there is no
> initialization for NPIV hosts that are created in qla24xx_vport_create().
> 
> This causes a crash when trying to access these NPIV host fields.
> 
> Fix this by adding initialization to qla_vport_create().
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[2/2] qla2xxx: Initialize vha->unknown_atio_[list, work] for NPIV hosts
      https://git.kernel.org/mkp/scsi/c/95da5e58172c

-- 
Martin K. Petersen	Oracle Linux Engineering
