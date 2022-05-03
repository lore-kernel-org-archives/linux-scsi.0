Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46277C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 May 2022 13:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379474AbiEENbo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 09:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377471AbiEENbm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 09:31:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C4A56C37
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 06:28:02 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242MkbAY018676;
        Tue, 3 May 2022 00:51:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=VQkZ6AtDt0k9w3ScFeBCyueOiURzraQ8u9aJl4Z5+ZI=;
 b=ZXRU1d5P9Frln25AezJ5Xeg5zwnn2q2umNN3gXN/79sCV7OXDuoQKG260n5lSBOMybnN
 sWrrOoa/4KiSlESyglgfXeJDxgi+6TIe2FzAq1tODKeTivfsy1i7dmGfA4JwEhyDACg0
 pvA/4kpD6m/8VR314PQr3E7ySzPqZRshVJdjvB3RbOZkcpOGH26n27eK/TiI0WeDfSrY
 ii6xq5iAwXnggRn0zal0863EQng7m3sfaUEaROJZAO3TbULG1fIZW6i9SUk6SVGmC0QC
 1E6JLimoQPHEZZCtaLWSu5j38xH8NBqfk9vN6o1YakCWUe2CiQUEyyVfzC9PgunTIxQN Kw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwnt4kwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430op0K008940;
        Tue, 3 May 2022 00:51:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:53 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430pljK010389;
        Tue, 3 May 2022 00:51:53 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-12;
        Tue, 03 May 2022 00:51:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v3 00/28] Split the ufshcd.h header file
Date:   Mon,  2 May 2022 20:51:22 -0400
Message-Id: <165153836359.24053.13374628224071400753.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: wI0v1keK9QRUnNphDimtstqrLkJCLEAz
X-Proofpoint-GUID: wI0v1keK9QRUnNphDimtstqrLkJCLEAz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Apr 2022 15:57:43 -0700, Bart Van Assche wrote:

> This patch series includes the following changes:
> - Split the ufshcd.h header file into two header files - one file that
>   defines the interface with UFS drivers and another file with definitions
>   only used in the core.
> - Multiple source code cleanup patches.
> - A few patches with minor functional changes.
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[01/28] scsi: ufs: Fix a spelling error in a source code comment
        https://git.kernel.org/mkp/scsi/c/2abe58002364
[02/28] scsi: ufs: Declare ufshcd_wait_for_register() static
        https://git.kernel.org/mkp/scsi/c/59a57bb79e10
[03/28] scsi: ufs: Remove superfluous boolean conversions
        https://git.kernel.org/mkp/scsi/c/51d1628fc457
[04/28] scsi: ufs: Simplify statements that return a boolean
        https://git.kernel.org/mkp/scsi/c/a858af9a9e01
[05/28] scsi: ufs: Remove ufshcd_lrb.sense_bufflen
        https://git.kernel.org/mkp/scsi/c/b639b59b44fd
[06/28] scsi: ufs: Remove ufshcd_lrb.sense_buffer
        https://git.kernel.org/mkp/scsi/c/1de4378f6057
[07/28] scsi: ufs: Use get_unaligned_be16() instead of be16_to_cpup()
        https://git.kernel.org/mkp/scsi/c/9d3ab17e840c
[08/28] scsi: ufs: Remove the UFS_FIX() and END_FIX() macros
        https://git.kernel.org/mkp/scsi/c/dd2cf44ff4ec
[09/28] scsi: ufs: Rename struct ufs_dev_fix into ufs_dev_quirk
        https://git.kernel.org/mkp/scsi/c/25eff2f543b1
[10/28] scsi: ufs: Declare the quirks array const
        https://git.kernel.org/mkp/scsi/c/aead21f32ae7
[11/28] scsi: ufs: Invert the return value of ufshcd_is_hba_active()
        https://git.kernel.org/mkp/scsi/c/acbbfe484faa
[12/28] scsi: ufs: Remove unused constants and code
        https://git.kernel.org/mkp/scsi/c/9474c64e83ca
[13/28] scsi: ufs: Switch to aggregate initialization
        https://git.kernel.org/mkp/scsi/c/778d2b0ec6d1
[14/28] scsi: ufs: Make the config_scaling_param calls type safe
        https://git.kernel.org/mkp/scsi/c/c906e8328de8
[15/28] scsi: ufs: Remove the driver version
        https://git.kernel.org/mkp/scsi/c/b4ade33b0d16
[16/28] scsi: ufs: Rename sdev_ufs_device into ufs_device_wlun
        https://git.kernel.org/mkp/scsi/c/e2106584d011
[17/28] scsi: ufs: Use an SPDX license identifier in the Kconfig file
        https://git.kernel.org/mkp/scsi/c/2b10863f7163
[18/28] scsi: ufs: Remove paths from source code comments
        https://git.kernel.org/mkp/scsi/c/d0c1725b1e64
[19/28] scsi: ufs: Remove the TRUE and FALSE definitions
        https://git.kernel.org/mkp/scsi/c/21c2e3418d07
[20/28] scsi: ufs: Remove locking from around single register writes
        https://git.kernel.org/mkp/scsi/c/3fb20fcd93fe
[21/28] scsi: ufs: Introduce ufshcd_clkgate_delay_set()
        https://git.kernel.org/mkp/scsi/c/ad8a647e7729
[22/28] scsi: ufs: qcom: Fix ufs_qcom_resume()
        https://git.kernel.org/mkp/scsi/c/bee40dc167da
[23/28] scsi: ufs: Remove unnecessary ufshcd-crypto.h include directives
        https://git.kernel.org/mkp/scsi/c/c10d52d73ae0
[24/28] scsi: ufs: Fix kernel-doc syntax in ufshcd.h
        https://git.kernel.org/mkp/scsi/c/cff91daf52d3
[25/28] scsi: ufs: Minimize #include directives
        https://git.kernel.org/mkp/scsi/c/3f06f7800b80
[26/28] scsi: ufs: Split the ufshcd.h header file
        https://git.kernel.org/mkp/scsi/c/4bc26113c603
[27/28] scsi: ufs: Move the struct ufs_ref_clk definition
        https://git.kernel.org/mkp/scsi/c/743b09d8541e
[28/28] scsi: ufs: Move the ufs_is_valid_unit_desc_lun() definition
        https://git.kernel.org/mkp/scsi/c/a8b032b5b3ba

-- 
Martin K. Petersen	Oracle Linux Engineering
