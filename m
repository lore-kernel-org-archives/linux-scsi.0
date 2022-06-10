Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84071C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 17:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350172AbiFJRpT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 13:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350183AbiFJRpQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 13:45:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6D455368
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2022 10:45:15 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25AEOuIs026118;
        Fri, 10 Jun 2022 17:45:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=4nElZWEoX0kDLlF4At8zaQEo+chMXHUQa9E0TbOa/0E=;
 b=pShBoxmoeLmKMQjicAskHoRT1RhOdhcofjJlYlZMBZDimBxihCRbCUoL9Ex2zrZUs4bd
 1UlurUg3QOqKVBEIgFwNhGFk9K8t4F+qtsg4P9LGj0nKRzLKMGLsGB2NUniEeNk6CPo6
 TTjZFYMInc2flbZ9XGNVacHA4Og+oROVKbOH8Mi4Odkk62o7Bo30rHjmh3OgNfKTumWz
 Se1kNRF4skQ40yTY3VcvFDQFdZ13hBTfnLN1+mSsoaMHjhH6oPUM2NTT5hRtKqMtyvn1
 g7IjGebxYk3cItW9iODHE2ytxx5mNHcpz7rdHPWZ/yEZrnjAHWaUiLYXZJhyx/gRUxVk Rw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghvs3hexv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 17:45:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25AHFK8Z034766;
        Fri, 10 Jun 2022 17:45:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwudauqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 17:45:13 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25AHcugl012397;
        Fri, 10 Jun 2022 17:45:12 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwudaunq-3;
        Fri, 10 Jun 2022 17:45:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH 00/11] Misc EDiF bug fixes
Date:   Fri, 10 Jun 2022 13:45:10 -0400
Message-Id: <165488292962.17199.13840246858245024668.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220607044627.19563-1-njavali@marvell.com>
References: <20220607044627.19563-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: JS9QFO_nBGdVDtyDW-2Qxu9vXCF970-N
X-Proofpoint-GUID: JS9QFO_nBGdVDtyDW-2Qxu9vXCF970-N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Jun 2022 21:46:16 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver misc EDiF bug fixes to the scsi tree
> at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[01/11] qla2xxx: edif: Reduce Initiator-Initiator thrashing
        https://git.kernel.org/mkp/scsi/c/9c40c36e75ff
[02/11] qla2xxx: edif: bsg refactor
        https://git.kernel.org/mkp/scsi/c/7a7b0b4865d3
[03/11] qla2xxx: edif: wait for app to ack on sess down
        https://git.kernel.org/mkp/scsi/c/df648afa39da
[04/11] qla2xxx: edif: add bsg interface to read doorbell events
        https://git.kernel.org/mkp/scsi/c/5ecd241bd7b1
[05/11] qla2xxx: edif: Fix potential stuck session in sa update
        https://git.kernel.org/mkp/scsi/c/e0fb8ce2bb9e
[06/11] qla2xxx: edif: Synchronize NPIV deletion with authentication application
        https://git.kernel.org/mkp/scsi/c/cf79716e6636
[07/11] qla2xxx: edif: add retry for els pass through
        https://git.kernel.org/mkp/scsi/c/0b3f3143d473
[08/11] qla2xxx: edif: remove old doorbell interface
        https://git.kernel.org/mkp/scsi/c/1040e5f75ddf
[09/11] qla2xxx: edif: fix n2n discovery issue with secure target
        https://git.kernel.org/mkp/scsi/c/789d54a41786
[10/11] qla2xxx: edif: fix n2n login retry for secure device
        https://git.kernel.org/mkp/scsi/c/aec55325ddec
[11/11] qla2xxx: Update version to 10.02.07.500-k
        https://git.kernel.org/mkp/scsi/c/4dc48a107a14

-- 
Martin K. Petersen	Oracle Linux Engineering
