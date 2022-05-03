Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C6DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  5 May 2022 05:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244051AbiEEGBI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 02:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiEEGBH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 02:01:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFA22A714
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 22:57:29 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242LrpKB032436;
        Tue, 3 May 2022 00:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=yhrZuwb/5D2krRXn9I8Y8Pkd6iCM71q/lHHSdJCD7Mo=;
 b=OH8VtnFlF35/Wb1Od+UdpEotU+AWdC4WcG8wwrL3E0ML1KW7M7ACvLKqpjKIRYBpOxiV
 g3lTSsoBRKiiZacOpnortgcU+GnXYb8+w/zaBR1mD92Bk+Z+tqMDEZf3jotUJ+MnHKpr
 cru0A0jJLyxHlnghLNbOQEfhfKxNAChbvyI7uFwwUgxXoBAqB2V8wsvl5TP42f95W8Hy
 pr+3inld3C3VbZRkh1cumNmiHss6yenjDxyt50IzHmWA+G6Z710tzuK94Yoy8zFW3z1D
 HKGV8ASBqCGSj9IxIVRcD70oPIjoFcnQ0BVDw/daNvmpM7BEtKqlhqaOzh+0UoFcdFNb cA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0amhjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:03 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430opQ5008913;
        Tue, 3 May 2022 00:52:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83xaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:02 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430pljo010389;
        Tue, 3 May 2022 00:52:01 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-27;
        Tue, 03 May 2022 00:52:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lpfc: Remove unnecessary null ndlp check in lpfc_sli_prep_wqe()
Date:   Mon,  2 May 2022 20:51:37 -0400
Message-Id: <165153836363.24053.11949291827125057534.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220426181315.8990-1-jsmart2021@gmail.com>
References: <20220426181315.8990-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: cEBwUsUlP_smLfMgCWRTZinqTYDCSZdi
X-Proofpoint-ORIG-GUID: cEBwUsUlP_smLfMgCWRTZinqTYDCSZdi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 26 Apr 2022 11:13:15 -0700, James Smart wrote:

> Smatch had the following warning:
> drivers/scsi/lpfc/lpfc_sli.c:22305 lpfc_sli_prep_wqe() error: we previously assumed 'ndlp' could be null (see line 22298)
> 
> Remove the unnecessary null check
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] lpfc: Remove unnecessary null ndlp check in lpfc_sli_prep_wqe()
      https://git.kernel.org/mkp/scsi/c/3d1d34ec1fbc

-- 
Martin K. Petersen	Oracle Linux Engineering
