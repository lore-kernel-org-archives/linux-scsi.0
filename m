Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52469C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 15:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352579AbiEDPom (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 11:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351200AbiEDPod (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 11:44:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BAE193D7
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 08:40:57 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242MuHJt018680;
        Tue, 3 May 2022 00:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=KVvzl9O3Ak0DzMxonnqPihSxtRrAegmMhwQEvZDE0DI=;
 b=AOqbWkpwMH4+tJLPufddo/bSZRn06bJY3vYaGqAWOEYh8i3Y64P2uZO8fMBpN3eWWJcV
 b133ndgkJxwYUbBq9ImHCBaq+/C+m+Wqm/oLpQraUFcoxDVB4NWFgHlqxNySDcgd6mOj
 ENlYnSRwXMdQfhVCMZtOs13Ri356gf4Z8U9GbGgVuSvsUfdlwXYZPn868Nd+UOTbrTbp
 003NquXOVM7zB5KRD5xYOzmbvrGI4uyFMqv5i5bQ1I7sE+JruJ/yZpxzuwy1hbb/ctjp
 gmOVaCwfKBa7jFOlXfSWN7i/WUyosNTBbmz0cjyeOY0VZE2Z22RQkaYqwP6nSWt/tYOT Cg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwnt4kx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430op62008954;
        Tue, 3 May 2022 00:52:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83xaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:01 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430pljm010389;
        Tue, 3 May 2022 00:52:01 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-26;
        Tue, 03 May 2022 00:52:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: Remove redundant lpfc_sli_prep_wqe() call
Date:   Mon,  2 May 2022 20:51:36 -0400
Message-Id: <165153836364.24053.4963013077474294434.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220427222223.57920-1-jsmart2021@gmail.com>
References: <20220427222223.57920-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Nwew4Zxgu5vLciGisllLnvYlxsvRIF6W
X-Proofpoint-GUID: Nwew4Zxgu5vLciGisllLnvYlxsvRIF6W
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 27 Apr 2022 15:22:23 -0700, James Smart wrote:

> Prior patch added a call to lpfc_sli_prep_wqe prior to lpfc_sli_issue_iocb.
> This call should not have been added as prep_wqe is called within
> the issue_iocb routine. So it's called twice now.
> 
> Remove the redundant prep call.
> 
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/1] lpfc: Remove redundant lpfc_sli_prep_wqe() call
      https://git.kernel.org/mkp/scsi/c/c2024e3b33ee

-- 
Martin K. Petersen	Oracle Linux Engineering
