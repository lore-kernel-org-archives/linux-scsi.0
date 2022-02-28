Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB894C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 03:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbiB1DoH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 22:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbiB1DoG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 22:44:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518433982A
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 19:43:28 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21RMXxCa029559;
        Mon, 28 Feb 2022 03:43:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=NhORws0w+J5bWbluZ4DILd4cQRZ5jRtLelQTOgAW0iQ=;
 b=u5NLDbfthXmM67MvpUBsRymOvga/t+FCEhzcC1sZly4jU8w5G+wgnlExy5JuOp8bBJVp
 eu56OcbAc2wtCEvokgya1kjqo25CcTScMZI8lgOClFtfoBsIDt9rzTrQ0tYHDl7b1PjC
 3ZprchXHpFLYyWowM78iigGIKovonc759MQyJDJTcDGGmaYckNNcLdNrDsQWHc359SPi
 EbiQfaJBtuBJc3QEHfrSG1xziXtoVB+c6dNTAh4OTfGN2EXNe1tMYApos3ktKCoEDLsn
 M9Q/f4uKaUhwiw9PxKr5M/+0lxv/ML43MmuNUrr67QlOfmf4gr96ya57KF7yR5u5AL7G Jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efbttayeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:43:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S3bL7F157867;
        Mon, 28 Feb 2022 03:43:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3efa8bxntd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:43:25 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21S3hPvk165853;
        Mon, 28 Feb 2022 03:43:25 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3efa8bxnt3-1;
        Mon, 28 Feb 2022 03:43:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 00/49] Remove the SCSI pointer from struct scsi_cmnd
Date:   Sun, 27 Feb 2022 22:43:15 -0500
Message-Id: <164601967776.4503.7860201636471216473.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: hQBCUSEVsa17m2Wa8kSq_5Xh6AG238NH
X-Proofpoint-ORIG-GUID: hQBCUSEVsa17m2Wa8kSq_5Xh6AG238NH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 18 Feb 2022 11:50:28 -0800, Bart Van Assche wrote:

> The size of struct scsi_cmnd matters for embedded devices. One of the
> largest members of that structure is the SCSI pointer. That structure is
> relevant for SCSI-II drivers but not for modern SCSI drivers. Hence this
> patch series that removes the SCSI pointer from struct scsi_cmnd and moves
> it into driver-private command data.
> 
> Please consider this patch series for kernel v5.18.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[01/49] scsi: ips: Remove an unreachable statement
        https://git.kernel.org/mkp/scsi/c/2cf0e0a9da38
[02/49] scsi: ips: Change the return type of ips_release() into 'void'
        https://git.kernel.org/mkp/scsi/c/be33e2f8d87f
[03/49] scsi: ips: Use true and false instead of TRUE and FALSE
        https://git.kernel.org/mkp/scsi/c/c4858224096f
[04/49] scsi: nsp_cs: Change the return type of two functions into 'void'
        https://git.kernel.org/mkp/scsi/c/72961735f993
[05/49] scsi: nsp_cs: Use true and false instead of TRUE and FALSE
        https://git.kernel.org/mkp/scsi/c/dfab1e53eef4
[06/49] scsi: Remove drivers/scsi/scsi.h
        https://git.kernel.org/mkp/scsi/c/53555fb7bceb
[07/49] scsi: NCR5380: Remove the NCR5380_CMD_SIZE macro
        https://git.kernel.org/mkp/scsi/c/cd614642e1a2
[08/49] scsi: NCR5380: Add SCp members to struct NCR5380_cmd
        https://git.kernel.org/mkp/scsi/c/ff1269cb3d97
[09/49] scsi: arm: Rename arm/scsi.h into arm/arm_scsi.h
        https://git.kernel.org/mkp/scsi/c/8c97e2f390f5
[10/49] scsi: arm: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/dc4175459099
[11/49] scsi: 53c700: Stop clearing SCSI pointer fields
        https://git.kernel.org/mkp/scsi/c/d80624a2aec5
[12/49] scsi: aacraid: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/76a3451b64c6
[13/49] scsi: advansys: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/17d4c2e22aae
[14/49] scsi: aha1542: Remove a set-but-not-used array
        https://git.kernel.org/mkp/scsi/c/ea1c947559d9
[15/49] scsi: aha152x: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/3ac6aba37200
[16/49] scsi: bfa: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/34f5b537a900
[17/49] scsi: csio: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/30564db73b58
[18/49] scsi: dc395x: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/9804db13d3c8
[19/49] scsi: esp_scsi: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/dfae39874f45
[20/49] scsi: fdomain: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/211134c47cfd
[21/49] scsi: fnic: Fix a tracing statement
        https://git.kernel.org/mkp/scsi/c/3032ed77a289
[22/49] scsi: fnic: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/924cb24df4fc
[23/49] scsi: hptiop: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/5c113eb3bc58
[24/49] scsi: imm: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/6b66f09c46a8
[25/49] scsi: iscsi: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/db22de3eb035
[26/49] scsi: initio: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/09cc102bb4d6
[27/49] scsi: libfc: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/5d21aa3636fa
[28/49] scsi: bnx2fc: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/f4b4216f3e52
[29/49] scsi: qedf: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/a33e7925b5e6
[30/49] scsi: mac53c94: Fix a set-but-not-used compiler warning
        https://git.kernel.org/mkp/scsi/c/8c0156b10e4d
[31/49] scsi: mac53c94: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/cb2b62082c3a
[32/49] scsi: megaraid: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/fb597392b1f4
[33/49] scsi: megasas: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/96e77a27431a
[34/49] scsi: mesh: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/57cbd78e61cf
[35/49] scsi: mvsas: Fix a set-but-not-used warning
        https://git.kernel.org/mkp/scsi/c/8d1537342ff2
[36/49] scsi: mvumi: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/af0d3c13e468
[37/49] scsi: nsp32: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/195771c5da10
[38/49] scsi: nsp_cs: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/ea39700fa90c
[39/49] scsi: sym53c500_cs: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/3d75be6de78e
[40/49] scsi: ppa: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/4a938517fbeb
[41/49] scsi: qla1280: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/504540d00fd5
[42/49] scsi: qla2xxx: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/5597616333ea
[43/49] scsi: smartpqi: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/c1ea387d998a
[44/49] scsi: sym53c8xx_2: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/4022bfd63d8e
[45/49] scsi: usb: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/5dfcf1ad933f
[46/49] scsi: wd719x: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/70d1b920af62
[47/49] scsi: wd33c93: Move the SCSI pointer to private command data
        https://git.kernel.org/mkp/scsi/c/dbb2da557a6a
[48/49] scsi: zalon: Stop using the SCSI pointer
        https://git.kernel.org/mkp/scsi/c/31160bd3e538
[49/49] scsi: core: Remove struct scsi_pointer from struct scsi_cmnd
        https://git.kernel.org/mkp/scsi/c/8264aee803a2

-- 
Martin K. Petersen	Oracle Linux Engineering
