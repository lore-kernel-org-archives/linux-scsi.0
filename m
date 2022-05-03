Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9067C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 18:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376617AbiEDSNb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 14:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376566AbiEDSNY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 14:13:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D0947550
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 10:32:17 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242KZ9w5019152;
        Tue, 3 May 2022 00:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=SdyvkR51NVzoMO2w/hydlGAEHY1Y8NfwRz79OWb7Xb8=;
 b=pFDQXX6sQa1W/hSzyO7Q1tOsgQ49qJ8q1KW2bEhF0zagDbeacvar6WoUL8ba58Opok3R
 ED9FNRkzK4IkulUslm6qrdt3uWwA7iKOwael7X/kc0Edf2AOR7yi6n95n5mGc1yOk/On
 FqrGaj5b8p56VdlJl3bfC5lNGuBXF0dT+YqZ5s7nAy42vBl2w/g1gVrVeE+RET87sX2c
 0Kf0C19r91QlOevy8vxPb8Xv55JAAzg8m4nOPjWw2ZvsJyXU4jCR4iN1/09hg5dn3jIv
 vs8jhLCCtrhTYxswqT4RTxpzyxQeMjEXqh0DvgMiCoquosVpe3tiyaQshJHc3kIqR1xf Cw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0amhjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430ouiX009081;
        Tue, 3 May 2022 00:52:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83xbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:04 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430pljv010389;
        Tue, 3 May 2022 00:52:03 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-31;
        Tue, 03 May 2022 00:52:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 01/14] scsi: mpt3sas: Use cached ATA Information VPD page
Date:   Mon,  2 May 2022 20:51:41 -0400
Message-Id: <165153836364.24053.4220557580879981828.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220302053559.32147-2-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com> <20220302053559.32147-2-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: WgpZgRdSpTwdYUIs4SeKspt1bVE07DNs
X-Proofpoint-ORIG-GUID: WgpZgRdSpTwdYUIs4SeKspt1bVE07DNs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Mar 2022 00:35:46 -0500, Martin K. Petersen wrote:

> We now cache VPD page 0x89 so there is no need to request it from the
> hardware. Make mpt3sas use the cached page.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[01/14] scsi: mpt3sas: Use cached ATA Information VPD page
        https://git.kernel.org/mkp/scsi/c/dc1178767cba
[02/14] scsi: core: Query VPD size before getting full page
        https://git.kernel.org/mkp/scsi/c/c92a6b5d6335
[03/14] scsi: core: Do not truncate INQUIRY data on modern devices
        https://git.kernel.org/mkp/scsi/c/d657700ccac7
[04/14] scsi: core: Pick suitable allocation length in scsi_report_opcode()
        https://git.kernel.org/mkp/scsi/c/e17d63403076
[05/14] scsi: core: Cache VPD pages b0, b1, b2
        https://git.kernel.org/mkp/scsi/c/e60ac0b9e445
[06/14] scsi: sd: Use cached ATA Information VPD page
        https://git.kernel.org/mkp/scsi/c/e38d9e83a376
[07/14] scsi: sd: Switch to using scsi_device VPD pages
        https://git.kernel.org/mkp/scsi/c/7fb019c46eee
[08/14] scsi: sd: Optimal I/O size should be a multiple of reported granularity
        https://git.kernel.org/mkp/scsi/c/631669a256f9
[13/14] scsi: sd: Reorganize DIF/DIX code to avoid calling revalidate twice
        https://git.kernel.org/mkp/scsi/c/1e029397d12f

-- 
Martin K. Petersen	Oracle Linux Engineering
