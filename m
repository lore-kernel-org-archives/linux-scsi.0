Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76379C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 03:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiB1Do1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 22:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbiB1DoW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 22:44:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2443C73B
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 19:43:44 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21RMWjOU008194;
        Mon, 28 Feb 2022 03:43:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=weHtFUJxo/jcKnCzL5Nu2YhPXNzAg6qMsziS/KGJQaY=;
 b=PKQldEVRY4hJrLLRxZk7BKbP1DBXDSTwNSCi5FJ1Xp61dUuz4nHqu6b7Q7xOdPrjdQS7
 lwAr+4uGT0F+6/mWd73rAvF9udMHUIV8ow92stST8Ofnvj3oROIjX2n3M9X5MtwGTVFz
 PzP8ymOq8W74mvD2GfCvPxQ4Q9Kp3jnH7ho0BLCtySP0uedpQML5vv/IpeJCLKGokT6p
 jZb6w/6uWIgTKGgu8mlRlgIy3+jLy+0sF19IcdIaZa+GYdE1prDE0s7YHgvhatGXtBc7
 EySEZBU0Szgsq9kCEG2LZsN6RzztSnrVH6W0nXZI1CQt0ZTD/pIpaP2ar6k3VY46vDAI VQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02k1qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:43:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S3bBKV157758;
        Mon, 28 Feb 2022 03:43:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3efa8bxnu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:43:28 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21S3hPvq165853;
        Mon, 28 Feb 2022 03:43:27 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3efa8bxnt3-4;
        Mon, 28 Feb 2022 03:43:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jack Wang <jinpu.wang@ionos.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: Re: [PATCH v6 00/31] libsas and pm8001 fixes
Date:   Sun, 27 Feb 2022 22:43:18 -0500
Message-Id: <164601967779.4503.6253375243735364450.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: YmsvlO8Sa00OzVxT3wW0dv_H_Bm8kov9
X-Proofpoint-ORIG-GUID: YmsvlO8Sa00OzVxT3wW0dv_H_Bm8kov9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 20 Feb 2022 12:17:39 +0900, Damien Le Moal wrote:

> This first part of this series (patches 1 to 24) fixes handling of NCQ
> NON DATA commands in libsas and many bugs in the pm8001 driver.
> 
> The fixes for the pm8001 driver include:
> * Suppression of all sparse warnings, fixing along the way many le32
>   handling bugs for big-endian architectures
> * Fix handling of NCQ NON DATA commands
> * Fix of tag values handling (0 *is* a valid tag value)
> * Fix many tag iand memory leaks in error path
> * Fix NCQ error recovery (abort all task execution) that was causing a
>   crash
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[01/31] scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
        https://git.kernel.org/mkp/scsi/c/8454563e4c2a
[02/31] scsi: pm8001: Fix __iomem pointer use in pm8001_phy_control()
        https://git.kernel.org/mkp/scsi/c/d2ed913b9a42
[03/31] scsi: pm8001: Fix pm8001_update_flash() local variable type
        https://git.kernel.org/mkp/scsi/c/c58e935e809a
[04/31] scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
        https://git.kernel.org/mkp/scsi/c/1a37b6738b58
[05/31] scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
        https://git.kernel.org/mkp/scsi/c/3762d8f6edcd
[06/31] scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
        https://git.kernel.org/mkp/scsi/c/cd2268a18011
[07/31] scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
        https://git.kernel.org/mkp/scsi/c/bb225b12dbcc
[08/31] scsi: pm8001: Fix le32 values handling in pm80xx_set_sas_protocol_timer_config()
        https://git.kernel.org/mkp/scsi/c/ca374f5d92b8
[09/31] scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()
        https://git.kernel.org/mkp/scsi/c/f8b12dfb476d
[10/31] scsi: pm8001: Fix le32 values handling in pm80xx_chip_ssp_io_req()
        https://git.kernel.org/mkp/scsi/c/970404cc5744
[11/31] scsi: pm8001: Fix le32 values handling in pm80xx_chip_sata_req()
        https://git.kernel.org/mkp/scsi/c/fd6d0e376211
[12/31] scsi: pm8001: Fix use of struct set_phy_profile_req fields
        https://git.kernel.org/mkp/scsi/c/e5039a92f150
[13/31] scsi: pm8001: Remove local variable in pm8001_pci_resume()
        https://git.kernel.org/mkp/scsi/c/23c486d19a6c
[14/31] scsi: pm8001: Fix NCQ NON DATA command task initialization
        https://git.kernel.org/mkp/scsi/c/aa028141ab0b
[15/31] scsi: pm8001: Fix NCQ NON DATA command completion handling
        https://git.kernel.org/mkp/scsi/c/1d6736c3e162
[16/31] scsi: pm8001: Fix abort all task initialization
        https://git.kernel.org/mkp/scsi/c/7f12845c8389
[17/31] scsi: pm8001: Fix pm8001_tag_alloc() failures handling
        https://git.kernel.org/mkp/scsi/c/f17c599a44fc
[18/31] scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
        https://git.kernel.org/mkp/scsi/c/7e6b7e740add
[19/31] scsi: pm8001: Fix tag values handling
        https://git.kernel.org/mkp/scsi/c/7fb23a785ba3
[20/31] scsi: pm8001: Fix task leak in pm8001_send_abort_all()
        https://git.kernel.org/mkp/scsi/c/f90a74892f3a
[21/31] scsi: pm8001: Fix tag leaks on error
        https://git.kernel.org/mkp/scsi/c/4c8f04b1905c
[22/31] scsi: pm8001: fix memory leak in pm8001_chip_fw_flash_update_req()
        https://git.kernel.org/mkp/scsi/c/f792a3629f4c
[23/31] scsi: libsas: Simplify sas_ata_qc_issue() detection of NCQ commands
        https://git.kernel.org/mkp/scsi/c/a1e7c7991923
[24/31] scsi: pm8001: Cleanup pm8001_exec_internal_task_abort()
        https://git.kernel.org/mkp/scsi/c/0c4ad6c3d3b8
[25/31] scsi: pm8001: Simplify pm8001_get_ncq_tag()
        https://git.kernel.org/mkp/scsi/c/bf67e693fc40
[26/31] scsi: pm8001: Introduce ccb alloc/free helpers
        https://git.kernel.org/mkp/scsi/c/99df0edb5a98
[27/31] scsi: pm8001: Simplify pm8001_mpi_build_cmd() interface
        https://git.kernel.org/mkp/scsi/c/f91767a35f09
[28/31] scsi: pm8001: Simplify pm8001_task_exec()
        https://git.kernel.org/mkp/scsi/c/e29c47fe8946
[29/31] scsi: pm8001: Simplify pm8001_ccb_task_free()
        https://git.kernel.org/mkp/scsi/c/304fe11bdc25
[30/31] scsi: pm8001: improve pm80XX_send_abort_all()
        https://git.kernel.org/mkp/scsi/c/ca44f98d6194
[31/31] scsi: pm8001: Fix pm8001_info() message format
        https://git.kernel.org/mkp/scsi/c/b709a4caa9d0

-- 
Martin K. Petersen	Oracle Linux Engineering
