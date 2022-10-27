Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF31C38A2D
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 02:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbiJ0C6x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 22:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbiJ0C6u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 22:58:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130FB137282
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 19:58:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29R2Qx00032063;
        Thu, 27 Oct 2022 02:58:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=sJ/0cQnRu3eqrx5g4u32JFO6hyNlFUn4TP4A11eDRdI=;
 b=kt73QjyWvZOilWTveOcdoDUFeDx42MXlxCHsqG1hY1VHVOx3ChiAnYNBRxHY9M8C6ox4
 3e5vv+zZLVlQ3O7K0HptOxIT0/QBWGqZtCUcXLesUK+eQTYHzinnFY33GStMP5tqDetz
 nLIqkpuzgvwiH3RtZ70tu742q6aCnScsdXDBJGcOEajHXZoWU13F9G38C0v8slgme/X3
 SvVIqICScflfhCIhcHVE+wyTJNn5/hDv2WRdmMhYwZ5QI8USfr2AUD9RMicixpkeGlEm
 KPXCqgLGqZGJzNQrIoumc9X+DIxa5vH4GL4qiXLqYf9DGyyBZzdW0/AMEARyJXSgcWi8 nQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7rr11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 02:58:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM7D2u006899;
        Thu, 27 Oct 2022 02:58:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggh3fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 02:58:33 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29R2wWsX007945;
        Thu, 27 Oct 2022 02:58:32 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3kfaggh3fk-1;
        Thu, 27 Oct 2022 02:58:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 00/10] Fix a deadlock in the UFS driver
Date:   Wed, 26 Oct 2022 22:58:26 -0400
Message-Id: <166683942545.3791741.16317198796178472040.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221018202958.1902564-1-bvanassche@acm.org>
References: <20221018202958.1902564-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_10,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=888
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270015
X-Proofpoint-GUID: jZqJmEWl1fC7MTJumhdbFW7Pf6Yt77Eg
X-Proofpoint-ORIG-GUID: jZqJmEWl1fC7MTJumhdbFW7Pf6Yt77Eg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 18 Oct 2022 13:29:48 -0700, Bart Van Assche wrote:

> This patch series fixes a deadlock in the UFS driver between the suspend/resume
> code and the SCSI error handler. Please consider this patch series for the next
> merge window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[01/10] scsi: core: Fix a race between scsi_done() and scsi_timeout()
        https://git.kernel.org/mkp/scsi/c/978b7922d3dc
[02/10] scsi: core: Change the return type of .eh_timed_out()
        https://git.kernel.org/mkp/scsi/c/dee7121e8c0a
[03/10] scsi: core: Support failing requests while recovering
        https://git.kernel.org/mkp/scsi/c/310bcaef6d7e
[04/10] scsi: ufs: Remove an outdated comment
        https://git.kernel.org/mkp/scsi/c/1626c7bba1c4
[05/10] scsi: ufs: Use 'else' in ufshcd_set_dev_pwr_mode()
        https://git.kernel.org/mkp/scsi/c/836d322d73cb
[06/10] scsi: ufs: Reduce the START STOP UNIT timeout
        https://git.kernel.org/mkp/scsi/c/dcd5b7637c6d
[07/10] scsi: ufs: Try harder to change the power mode
        https://git.kernel.org/mkp/scsi/c/579a4e9dbd53
[08/10] scsi: ufs: Track system suspend / resume activity
        https://git.kernel.org/mkp/scsi/c/1a547cbc6fdd
[09/10] scsi: ufs: Introduce the function ufshcd_execute_start_stop()
        https://git.kernel.org/mkp/scsi/c/6a354a7e740e
[10/10] scsi: ufs: Fix a deadlock between PM and the SCSI error handler
        https://git.kernel.org/mkp/scsi/c/7029e2151a7c

-- 
Martin K. Petersen	Oracle Linux Engineering
