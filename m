Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BE8C727B3
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbjHYBOK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238145AbjHYBNx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:13:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006A319BB
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 18:13:51 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJEJdZ009509;
        Fri, 25 Aug 2023 01:13:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=DvcvUFxxQ2tu8a2n9689kWZ4iSvtMXDysJ8fnFipCds=;
 b=z8Z/rsyXzbd4FOWJn27sx+uwuhcW/naq0Fuq9ZLSlhzA0zZb5mJj/7ssiAjxTPSu3+Jg
 fsda+g5syr1IGV+30OStmJNZhtQDvt/2jZ0wSbqCHvbeWJvL8nhUYB8hl1zRfCRQwixW
 uGjXOklCvlYr5P3hO4x8ughA0CC4eUPT/iiChq44+9bVQsPxaHOn5IFfqcXosU8oW66h
 jQ8LyU0Vq4dhUaJ+OfYL3X+QwdefnKiD8CeTRsY67+NWsBfhMVTuDPoFKEcvCGGBqd6c
 ANkD9p9f2nADp+fi62M7AJ4zlsCS/ZiO0iE+lnizCp1/kXpqEZDUj0XDjoVNeR2z/htv iw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1ytwdyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P0SPnL036014;
        Fri, 25 Aug 2023 01:13:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1ywqfnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:43 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37P1DVEU019787;
        Fri, 25 Aug 2023 01:13:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3sn1ywqf8n-19;
        Fri, 25 Aug 2023 01:13:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Zheng Zengkai <zhengzengkai@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, wangxiongfeng2@huawei.com
Subject: Re: [PATCH -next] scsi: pmcraid: Use pci_dev_id() to simplify the code
Date:   Thu, 24 Aug 2023 21:13:05 -0400
Message-Id: <169292577177.789945.394133020727363992.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811111310.32364-1-zhengzengkai@huawei.com>
References: <20230811111310.32364-1-zhengzengkai@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=825 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250009
X-Proofpoint-ORIG-GUID: D_la_VDA4ptsn4ERqY6dq8Lk0KTbBEe1
X-Proofpoint-GUID: D_la_VDA4ptsn4ERqY6dq8Lk0KTbBEe1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 11 Aug 2023 19:13:10 +0800, Zheng Zengkai wrote:

> PCI core API pci_dev_id() can be used to get the BDF number for a pci
> device. We don't need to compose it manually. Use pci_dev_id() to
> simplify the code a little bit.
> 
> 

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: pmcraid: Use pci_dev_id() to simplify the code
      https://git.kernel.org/mkp/scsi/c/5d344c5eb415

-- 
Martin K. Petersen	Oracle Linux Engineering
