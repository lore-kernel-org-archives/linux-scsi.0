Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAC2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 18:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240244AbiEXSMC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 14:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240206AbiEXSL4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 14:11:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042715DD17;
        Tue, 24 May 2022 11:11:56 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHntbo016634;
        Tue, 24 May 2022 18:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=VD5R3b32Wt9gf1id9XvUQX1gkmNk9R4zm2sc0+SFSYU=;
 b=Qi+ttpp3ytkgwxk8aCpuYzeMudKb1FV8BqGgNd58jlkmpu9bf1kx0k8pFndFiOMHfzr/
 TnQo8MFV79kYSFI2QQrrfNMKi9guMLDDDKnZKUHf02aLFNuQpZrTCGdOJ0Xw5oAtAYuj
 RcDdW7c4iwIIGlOC3r8MeZomiQk7yBf3baJBk3sO4hJ6g9e2U3EPvqhn+AdocuaYqKmV
 /rfvgojDZS6jHdxWGv4WypXku0OTGt9h0Z/sc0PFvz8b+/rBduBPWVfolmn0iT5LhJ1v
 k6vgmFvxClILBqUBUb7Mf6QJ3Wcf/1CzGhX2Sa4eD218me+wFo+f/xFmtfA/MB1FGQOv Ig== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tdr3ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:11:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OHwNEH039894;
        Tue, 24 May 2022 18:11:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x50s44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:11:44 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24OIAvms039045;
        Tue, 24 May 2022 18:11:43 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x50s3r-1;
        Tue, 24 May 2022 18:11:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufshcd: delete unnecessary NULL check
Date:   Tue, 24 May 2022 14:11:33 -0400
Message-Id: <165341587530.22286.4324172271777105211.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <YotFotj43TkB8Rid@kili>
References: <YotFotj43TkB8Rid@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: qBCsRe2uHxbCurCPLrhtvr02muHI0WUy
X-Proofpoint-ORIG-GUID: qBCsRe2uHxbCurCPLrhtvr02muHI0WUy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 23 May 2022 11:28:18 +0300, Dan Carpenter wrote:

> The "info" pointer points to somewhere in the middle of the "hba" struct.
> It can't possibly be NULL.  Delete the NULL check.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: ufs: ufshcd: delete unnecessary NULL check
      https://git.kernel.org/mkp/scsi/c/476e45923b5d

-- 
Martin K. Petersen	Oracle Linux Engineering
