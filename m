Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A782BC7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 02:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjDLCFH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 22:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjDLCFF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 22:05:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341F4359A
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 19:05:05 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLIwYs019697;
        Wed, 12 Apr 2023 02:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=BqrStF6einvFlvFwTBym7Bg+kCLspGh5ieWoXYCUMuA=;
 b=B3HCmUsZAgoR8KGJspi2i5yw2nqobrykPZ6KafHSoN6NP7DqDwqH6l8+iBNR3oQToRNp
 jFHWsrMTG/7eGbQCXdFbx0Qe0/dgFK/oPbwvbK7Na3ao+GXz7yMyo7JVGqA6GDUnzz6w
 NzGGHAXDWJ0EhrvvOeEiYXXPxNpIcJ8hHkbJsvcm93qtXzDD5SsOaAa1IVKqwDLBPGVt
 r2+t5/2y70QM6xSUuXz2Y8OxVyv8bQvogf6uF0Gk0tuFISfw+x6mx8e2INJVMZxk+YOF
 uaRjIZXX3+YnMvae1+6Fzr1eUZBUQRn3Mt47FN7Bem6xylQcbxyrKvTD7gaWwDO0S/yk 6Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b2xwxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 02:05:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BNh7ks008112;
        Wed, 12 Apr 2023 02:05:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc54ttg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 02:04:59 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33C24xeM031283;
        Wed, 12 Apr 2023 02:04:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3puwc54tqc-1;
        Wed, 12 Apr 2023 02:04:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Lunar Lake
Date:   Tue, 11 Apr 2023 22:04:41 -0400
Message-Id: <168126077053.185856.7324387839039800638.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328105832.3495-1-adrian.hunter@intel.com>
References: <20230328105832.3495-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=843 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304120016
X-Proofpoint-GUID: Zj3NZZcaH-YDsiapqSlVDRnK0CT47uUm
X-Proofpoint-ORIG-GUID: Zj3NZZcaH-YDsiapqSlVDRnK0CT47uUm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Mar 2023 13:58:32 +0300, Adrian Hunter wrote:

> Add PCI ID to support Intel Lunar Lake, same as MTL.
> 
> 

Applied to 6.4/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-pci: Add support for Intel Lunar Lake
      https://git.kernel.org/mkp/scsi/c/0a07d3c7a1d2

-- 
Martin K. Petersen	Oracle Linux Engineering
