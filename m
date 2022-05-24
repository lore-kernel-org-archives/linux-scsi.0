Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA794C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 03:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiEXD1m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 23:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiEXD1j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 23:27:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFCD50E3A
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 20:27:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NMhkRs009825;
        Tue, 24 May 2022 03:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=QB9HakrPODATRYjV+YIPkVtUi0ajsNPiMWhjRoM+8ys=;
 b=ZPBNDIeZh3VW5i4O2DEhaJm7E/LrnRYo3dwZWEOE/eYi6Lve2bBZ+CR9cEdziv8rKv0s
 3A/3aJ4tpYZ90jDnv6TEFJHtdHwu9quZ3TAfpOWx18ofdz6JQA6FZzh5erljqVJKVN9P
 05UZAfPch39C2KpFDY4B5ZNNgQmrbf/Ocl7+itgherhrjsgOIlS+dm8eTALVNxJF3Csg
 OZTY/zXXL2L3pI7/cG3I6xOUcfoGDilyBWDo8ZW95rSuJHnLWf7bTCTx9dpsynSgc/nj
 PH/HDOg9jTpGLPigWlYHHoCAd3Howa72/giPrvjf+Uce3LqG2/BOOLtxDfzLz7VvjRnn jg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6pgbn3yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 03:27:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24O3C2Xv028121;
        Tue, 24 May 2022 03:27:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph1y34k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 03:27:23 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24O3P61J012957;
        Tue, 24 May 2022 03:27:23 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph1y349-1;
        Tue, 24 May 2022 03:27:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Keoseong Park <keosung.park@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] scsi: ufs: Split the drivers/scsi/ufs directory
Date:   Mon, 23 May 2022 23:27:19 -0400
Message-Id: <165336281523.11823.17184976636621749123.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220511212552.655341-1-bvanassche@acm.org>
References: <20220511212552.655341-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: m1N_GMEeT-R53FDhRJGpAswUfTAAQz1R
X-Proofpoint-GUID: m1N_GMEeT-R53FDhRJGpAswUfTAAQz1R
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 11 May 2022 14:25:52 -0700, Bart Van Assche wrote:

> Split the drivers/scsi/ufs directory into 'core' and 'host' directories
> under the drivers/ufs/ directory. Move shared header files into the
> include/ufs/ directory. This separation makes it clear which header
> files UFS drivers are allowed to include (include/ufs/*.h) and which
> header files UFS drivers are not allowed to include
> (drivers/ufs/core/*.h).
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: ufs: Split the drivers/scsi/ufs directory
      https://git.kernel.org/mkp/scsi/c/dd11376b9f1b

-- 
Martin K. Petersen	Oracle Linux Engineering
