Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB7EEB64DD
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 02:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjGZCDz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 22:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjGZCDy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 22:03:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA26121
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 19:03:53 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJIteP029500;
        Wed, 26 Jul 2023 02:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=FLs7j/zoVtGKKeD1sq+3qjYLGljhIF0hG+ONI0tI7kQ=;
 b=zBcacpWC1HD9YXhKUdnyyLq81fAkSe8zyADFqaSuEjBcp2jDMzacE2COpqwlUm8fPBKp
 AfKXDfBRJtvpV7FV18D9QJlWfFDkNT7XyNXyFS65IpyU6ye26zBUdC97EjOsFfNgEMbC
 DcU6iVfb46g/VQ3rU9OSyvIbLEFOsELZEJbsMSf5aTtdzYW8USJbpYF37UuvXj0fpKFh
 8NaaigYqpXz5i8ZXhF2FWdInUB+NJ8qLDk9bL590LV3948ue/Wk9OL/3XzBTaaftNQgi
 2EPjKAEYu1xq1GsfWK6G+3JNsQcHSNB1yQvw8DYqN00CNUmChyp52sOMBL3hkfLN2Uy5 zw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05q1xf3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:03:31 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q0HcOZ029445;
        Wed, 26 Jul 2023 02:03:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5jrnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:03:30 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36Q23SLs003192;
        Wed, 26 Jul 2023 02:03:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s05j5jrfj-2;
        Wed, 26 Jul 2023 02:03:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jinpu.wang@cloud.ionos.com, jejb@linux.ibm.com,
        changyuanl@google.com, pranavpp@google.com
Subject: Re: [PATCH] scsi: pm80xx: fix error return code in pm8001_pci_probe()
Date:   Tue, 25 Jul 2023 22:03:07 -0400
Message-Id: <169033697465.2256225.9070672458326273686.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230725125706.566990-1-yangyingliang@huawei.com>
References: <20230725125706.566990-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=994 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260016
X-Proofpoint-GUID: J7eB32Fanl9LjzzAiwD3IS6AYC8GXjpb
X-Proofpoint-ORIG-GUID: J7eB32Fanl9LjzzAiwD3IS6AYC8GXjpb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 25 Jul 2023 20:57:06 +0800, Yang Yingliang wrote:

> If pm8001_init_sas_add() fails, return error code in pm8001_pci_probe().
> 
> 

Applied to 6.5/scsi-fixes, thanks!

[1/1] scsi: pm80xx: fix error return code in pm8001_pci_probe()
      https://git.kernel.org/mkp/scsi/c/d4e026534577

-- 
Martin K. Petersen	Oracle Linux Engineering
