Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A1EE82CC3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 19:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjI0Te7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjI0Tev (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 15:34:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DAD10A
        for <linux-scsi@vger.kernel.org>; Wed, 27 Sep 2023 12:34:45 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RIx6sA006412;
        Wed, 27 Sep 2023 19:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=5BCG74jN6LGsVUwVhB74CEuUsFWQsWSJ9aXxqIcn4sw=;
 b=JOCdWLD4WVQymTzy2ngWUXCdyL7eoPRWpCtUL0DSEvTJPL+5QrUQ29MivkDknZRxtLA+
 aA/OKgl958gWF0DjOgkxbTTiZ1pw0ZDRZYYFw/5S7IwYl1x7/4BWfxj69IniN8+8o7b5
 Y9SsAdzUmsVDPPfxRxa7G+pygj57EmdF86R77bGGTsb2mLNEX3Tnk6pjyA68aqyI5WGE
 Gp8VhdqJ+T3Wr+JqsYP63h0vz9ClJpQd0gIL4g6lv4wAOEG/RwSvCNYmeEjMxtioyFBa
 0xKxrqUAxRHkg0zPC5yllk17TMBHG4Hr2jOlJkXJQ94y6Ohyhuy6UC2upA3+2ZJLUWeW OQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9peeadus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:34:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RJ4B32030602;
        Wed, 27 Sep 2023 19:34:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf8cv1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:34:31 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38RJYTlr010018;
        Wed, 27 Sep 2023 19:34:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t9pf8cuyr-2;
        Wed, 27 Sep 2023 19:34:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.vnet.ibm.com, chenxiang <chenxiang66@hisilicon.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linuxarm@huawei.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/3] Some fixes and optimizations for hisi_sas debugfs
Date:   Wed, 27 Sep 2023 15:34:23 -0400
Message-Id: <169582723795.1126739.13914682429260948814.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <1694571327-78697-1-git-send-email-chenxiang66@hisilicon.com>
References: <1694571327-78697-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_12,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=796 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309270166
X-Proofpoint-ORIG-GUID: Yle8liWnS24XRlaL6naQV7E9KltXvzR_
X-Proofpoint-GUID: Yle8liWnS24XRlaL6naQV7E9KltXvzR_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Sep 2023 10:15:24 +0800, chenxiang wrote:

> The patchset includes:
> - Fix NULL pointer issue when removing debugfs;
> - Directly calling register snapshot instead of workqueue;
> - Allocate debugfs memory during triggering debugfs dump;
> 
> Yihang Li (3):
>   scsi: hisi_sas: Set debugfs_dir pointer to NULL after debugfs remove
>   scsi: hisi_sas: Directly calling register snapshot instead of
>     workqueue
>   scsi: hisi_sas: Allocate DFX memory during dump trigger
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/3] scsi: hisi_sas: Set debugfs_dir pointer to NULL after removing debugfs
      https://git.kernel.org/mkp/scsi/c/6de426f9276c
[2/3] scsi: hisi_sas: Directly calling register snapshot instead of workqueue
      https://git.kernel.org/mkp/scsi/c/2ff07b5c6fe9
[3/3] scsi: hisi_sas: Allocate DFX memory during dump trigger
      https://git.kernel.org/mkp/scsi/c/63f0733d07ce

-- 
Martin K. Petersen	Oracle Linux Engineering
