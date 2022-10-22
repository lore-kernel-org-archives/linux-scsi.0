Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF41BC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Oct 2022 03:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJVDwc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 23:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJVDw3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 23:52:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B06728E04A
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 20:52:28 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29M2tRVZ015955;
        Sat, 22 Oct 2022 03:52:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=ItjWv2C1RdjGXyGboynZUJ1HrBJeMeiYmuBy4JS9MJk=;
 b=Jh7gNmiFSSIrx2OsOduWcneNg+NKCV5Vg7Y1M/9rRUkDSF9ulK8/PhOosbKf4KM2BWmf
 VA9kGCGvXfFuLI5NNZ6vBhwwXyW5UBTQSgGkp/azJMy4gqcMyxHk+Yuf5Dt8E43vc2Il
 byByXdET+z6oj/Fp9w4JCtatP5wOkf5tWOffYowlj3MtlvddD77lEQDHj4JDzeFjRh/z
 iPEURt+WThR2YdtuMVILmACgLVOLhdpoVS5bBwcn2DnPcm7prdeGpW2j7fGacE1goDB6
 7aDEVguSeTZKsP+4wmUG2cflrEKt0z9vBBN7WMUOcbnv26En0u4rACQRxcAXYB8EW8G4 Tg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84sr13w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:52:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29M1XeAF015806;
        Sat, 22 Oct 2022 03:52:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8hk7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:52:25 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29M3qOME004796;
        Sat, 22 Oct 2022 03:52:24 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kc6y8hk7g-1;
        Sat, 22 Oct 2022 03:52:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 0/8] Prepare for constifying SCSI host templates
Date:   Fri, 21 Oct 2022 23:52:16 -0400
Message-Id: <166641056340.3488251.275208041460729736.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221015002418.30955-1-bvanassche@acm.org>
References: <20221015002418.30955-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=582 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210220021
X-Proofpoint-ORIG-GUID: X88j60Pf-RsGXqjOVX-VTQrqgNl9sOvj
X-Proofpoint-GUID: X88j60Pf-RsGXqjOVX-VTQrqgNl9sOvj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 14 Oct 2022 17:24:10 -0700, Bart Van Assche wrote:

> This patch series prepares for constifying SCSI host templates by moving the
> members that are not constant out of the SCSI host template. Please consider
> this patch series for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/8] scsi: esas2r: Initialize two host template members implicitly
      https://git.kernel.org/mkp/scsi/c/b6da92356cd6
[2/8] scsi: esas2r: Introduce scsi_template_proc_dir()
      https://git.kernel.org/mkp/scsi/c/77916da7e4a0
[3/8] scsi: core: Fail host creation if creating the proc directory fails
      https://git.kernel.org/mkp/scsi/c/ecca3f9b1636
[4/8] scsi: core: Introduce a new list for SCSI proc directory entries
      https://git.kernel.org/mkp/scsi/c/036abd614007
[5/8] scsi: core: Rework scsi_single_lun_run()
      https://git.kernel.org/mkp/scsi/c/d460f6240592
[6/8] scsi: ufs: Simplify ufshcd_set_dev_pwr_mode()
      https://git.kernel.org/mkp/scsi/c/6d1aa3b0589b
[7/8] scsi: core: Remove the put_device() call from scsi_device_get()
      https://git.kernel.org/mkp/scsi/c/195fae206ef2
[8/8] scsi: core: Release SCSI devices synchronously
      https://git.kernel.org/mkp/scsi/c/f93ed747e2c7

-- 
Martin K. Petersen	Oracle Linux Engineering
