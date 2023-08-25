Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D914C727B1
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbjHYBOL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238148AbjHYBNy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:13:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277091BFE
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 18:13:52 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJEULP007524;
        Fri, 25 Aug 2023 01:13:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=w4GIjBsVmnnySqQkFe/ubSMCKY/IcHoNA1ldLQfYKvU=;
 b=UG/wklp9NSFrnQilIQQ4Io5apSFLztd3YhUzwGn5jy5qtMLq2MHjAa62dG/8BYJcVQRu
 VY+0myipCfu4gCnWfl/DiWaWrzth4hvcL4RFfQ21STWW0rcQj7mFQwXezV/4GQNqAE/P
 4aUrEpgwvuwwsvMi3E/z6tOjRVBl9wy9VPLcJ4tWNKSN8NweFD4SDRrlUEMZZkz34BTY
 WCwaCshGAgEAylSiSAURxZ9jS9pxMX1BRVTtn0kXb7zwmP6nRdQp40ol78S5CbRLU348
 GviLBJ/vqIBwJceBM4JLsXlx5t0aB/MyP4SvZMdqcsg9HlF/MO8tBifL/fgd3scy/YZf /A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1yvwcp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P0Ovtx036084;
        Fri, 25 Aug 2023 01:13:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1ywqfnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:42 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37P1DVES019787;
        Fri, 25 Aug 2023 01:13:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3sn1ywqf8n-18;
        Fri, 25 Aug 2023 01:13:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        Jialin Zhang <zhangjialin11@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        liwei391@huawei.com, wangxiongfeng2@huawei.com
Subject: Re: [PATCH 0/3] scsi: Use pci_dev_id() to simplify the code
Date:   Thu, 24 Aug 2023 21:13:04 -0400
Message-Id: <169292577161.789945.12137916905793427518.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230815025419.3523236-1-zhangjialin11@huawei.com>
References: <20230815025419.3523236-1-zhangjialin11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=716 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250009
X-Proofpoint-ORIG-GUID: MGEa1sdnU8Fgg6OmzmO-q13eqPoAL8ci
X-Proofpoint-GUID: MGEa1sdnU8Fgg6OmzmO-q13eqPoAL8ci
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Aug 2023 10:54:16 +0800, Jialin Zhang wrote:

> PCI core API pci_dev_id() can be used to get the BDF number for a pci
> device. Use the API to simplify the code.
> 
> Jialin Zhang (3):
>   scsi: mvumi: Use pci_dev_id() to simplify the code
>   scsi: megaraid_sas: Use pci_dev_id() to simplify the code
>   scsi: megaraid: Use pci_dev_id() to simplify the code
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/3] scsi: mvumi: Use pci_dev_id() to simplify the code
      https://git.kernel.org/mkp/scsi/c/48e590218d1b
[2/3] scsi: megaraid_sas: Use pci_dev_id() to simplify the code
      https://git.kernel.org/mkp/scsi/c/a46421fdf7e9
[3/3] scsi: megaraid: Use pci_dev_id() to simplify the code
      https://git.kernel.org/mkp/scsi/c/bb1459cb84da

-- 
Martin K. Petersen	Oracle Linux Engineering
