Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C87C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 05:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345032AbiCOFuT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 01:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239142AbiCOFuS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 01:50:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1F011A25
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 22:49:06 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F3FKZV008045;
        Tue, 15 Mar 2022 05:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=RL/G0+aDiiLsnGyCWesUSUg4AlNTV+8ozNJLmd/LEbg=;
 b=J0tchOyQMahH5okKqIXvpcdJkFOtQjSccstPtWELItT4W+YRAPd4Ld5TLv8sHIh7BNKk
 7l2MsoLp1jP15ImuvTg9tZA18yVa0XNSA2G6DPDbivFeDuK7DL8yiv2STMkNw6HVyvBP
 u7D0xzcqMRuQ6KrEu/pRC7D0SdphQFz2pPKmRhYqy6LS2m/sgk83fAuUot9n74QvJjtH
 yHuPnA6ip5nAuThei8sthMpAGcxwCEvJh2jiSN19bizs7eU8gXKpgjBTID2gL6O3Tsf1
 qIJVYZCZMImlCYCMM8SzZM6rsXJZ9nSvIN/cefcnLirEWkCVmkDIrJJseJf3NAv/eme0 Kg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6j20b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 05:02:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22F51Kiq004963;
        Tue, 15 Mar 2022 05:02:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3erhy25wu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 05:02:38 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22F52cq3007094;
        Tue, 15 Mar 2022 05:02:38 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3erhy25wts-1;
        Tue, 15 Mar 2022 05:02:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 0/2] Fix sparse warnings in scsi_debug
Date:   Tue, 15 Mar 2022 01:02:31 -0400
Message-Id: <164732052812.23186.17202627326295023642.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220301113009.595857-1-damien.lemoal@opensource.wdc.com>
References: <20220301113009.595857-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: qFigEiqFmH400iu2npdwsq4M_G9AQJRM
X-Proofpoint-ORIG-GUID: qFigEiqFmH400iu2npdwsq4M_G9AQJRM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 1 Mar 2022 20:30:07 +0900, Damien Le Moal wrote:

> A couple of patches to suppress sparse warnings in scsi_debug. No
> functional changes.
> 
> Changes from v1:
> * Added Acked-by tag to patch 1
> * Fixed patch 2 (find_next_bit() call and break comment)
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/2] scsi: scsi_debug: silence sparse unexpected unlock warnings
      https://git.kernel.org/mkp/scsi/c/e9c478014b60
[2/2] scsi: scsi_debug: fix qc_lock use in sdebug_blk_mq_poll()
      https://git.kernel.org/mkp/scsi/c/3fd07aecb750

-- 
Martin K. Petersen	Oracle Linux Engineering
