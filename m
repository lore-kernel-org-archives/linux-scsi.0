Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD02CCA473
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 02:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356140AbiFVCK0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 22:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356136AbiFVCKY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 22:10:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C7B3135F
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2022 19:10:22 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25M0J8wn011432;
        Wed, 22 Jun 2022 02:10:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=CPdIrXjE3aGgHkMYCDXOLMMSbtnKi3wKtwhm2ltKohU=;
 b=LM9WRRP7FpjhUSflRHWGDAzCO5PvIaSVtbfsKY8DKQW1ew30udoElntBJUSIhlAj3RVp
 JMA3wJI//g+dE636FMUtkRlW9myM+DbXqS7a9XOzpLQBjenAj8fBT9iwDS3iuOUqyzB+
 4ovm3FTya5fMDdQi+z6ECsUb5taZ07fnK6Zveb6+dQug58rdzAiYpO8IPmFjWyaDIcr4
 x/fZHMPwD9KiKTZUh9a8EjyEsO+s8nMRh63BqZLxBuPK5lX+LjRRwpINaDw6HSR15hgS
 /TheluUQSIRcEGLcr+tvsJ0XdZ5ZHEmcTW2/j4zXFYFL/dTjSC5T0+geo+DKCxyCt7CR rg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs6kf72ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 02:10:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25M26XcB037986;
        Wed, 22 Jun 2022 02:10:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9usx47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 02:10:20 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25M29Biu002724;
        Wed, 22 Jun 2022 02:10:19 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9usx36-5;
        Wed, 22 Jun 2022 02:10:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v2 00/11] qla2xxx bug fixes
Date:   Tue, 21 Jun 2022 22:10:15 -0400
Message-Id: <165586371838.21830.14000074152214400704.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220616053508.27186-1-njavali@marvell.com>
References: <20220616053508.27186-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: r9-pRjrnKh0WZFQAbi6zsNU3JZpOx3VD
X-Proofpoint-GUID: r9-pRjrnKh0WZFQAbi6zsNU3JZpOx3VD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 15 Jun 2022 22:34:57 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver bug fixes to the scsi tree at your
> earliest convenience.
> 
> v2:
> - For 05/11, additionally return failure in case of qla2xxx_eh_target_reset too.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[01/11] qla2xxx: Fix excessive IO error messages by default
        https://git.kernel.org/mkp/scsi/c/bff4873c7090
[02/11] qla2xxx: Add a new v2 dport diagnostic feature
        https://git.kernel.org/mkp/scsi/c/476da8faa336
[03/11] qla2xxx: Wind down adapter after pcie error
        https://git.kernel.org/mkp/scsi/c/d3117c83ba31
[04/11] qla2xxx: Turn off multi-queue for 8G adapter
        https://git.kernel.org/mkp/scsi/c/5304673bdb16
[05/11] qla2xxx: Fix crash due to stale srb access around IO timeouts
        https://git.kernel.org/mkp/scsi/c/c39587bc0aba
[06/11] qla2xxx: Fix losing FCP-2 targets during port perturbation tests
        https://git.kernel.org/mkp/scsi/c/58d1c124cd79
[07/11] qla2xxx: Fix losing target when it reappears during delete
        https://git.kernel.org/mkp/scsi/c/118b0c863c8f
[08/11] qla2xxx: Add debug prints in the device remove path
        https://git.kernel.org/mkp/scsi/c/f12d2d130efc
[09/11] qla2xxx: Fix losing FCP-2 targets on long port disable with IOs
        https://git.kernel.org/mkp/scsi/c/2416ccd3815b
[10/11] qla2xxx: Fix erroneous mailbox timeout after pci error inject
        https://git.kernel.org/mkp/scsi/c/f260694e6463
[11/11] qla2xxx: Update version to 10.02.07.700-k
        https://git.kernel.org/mkp/scsi/c/4de0d18da901

-- 
Martin K. Petersen	Oracle Linux Engineering
