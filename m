Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A915C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 May 2022 11:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358025AbiEELkF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 07:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357832AbiEELkA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 07:40:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67AE517C4;
        Thu,  5 May 2022 04:36:19 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242M53jn024988;
        Tue, 3 May 2022 00:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=B/ZCpUfbmhzSiF7ieDYPWwj9pCPeWlzH681Bf7sSbz4=;
 b=EI44Jvh9QXZXwIaOw1PvkrD198SPGUaF8eQBip+GgpxNIDZmF0ASrjVGpSLfXbQC7ilS
 gJQU+iDA/kCjJmmZvb5kuPueXRwcc8QnQjUsgzAu9+mCGBfe4Scm2eNriFm6nUF1FKaM
 H+Jd0dyuobR6qgs9twyCA6HRISiLOmNKrsrQGnfBaVPA7XuzXfeDv8jJLkU2icIQtrms
 uKnoujwkLo/hIjG0EYEIRcrWiUIsifHgWBNjeDXtX81eBk/UvbTPev8ASrFGoRyZlHzi
 GWWnekI6+J/jevQBxy5qN8MOsv+VPxxx7hHc7KtBoSSPF+N//fgNZs2tn3GfZyEcS5Vr Qg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruw2cnx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430op5s008954;
        Tue, 3 May 2022 00:51:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:50 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430plj6010389;
        Tue, 3 May 2022 00:51:49 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-5;
        Tue, 03 May 2022 00:51:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     brking@us.ibm.com, Haowen Bai <baihaowen@meizu.com>,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ipr: Directly return instead of using local ret variable
Date:   Mon,  2 May 2022 20:51:15 -0400
Message-Id: <165153836361.24053.6859780075804868056.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <1648433103-24308-1-git-send-email-baihaowen@meizu.com>
References: <1648433103-24308-1-git-send-email-baihaowen@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: SCrhp4oUmQaSxjoBBukr1NCP79zL9yhe
X-Proofpoint-ORIG-GUID: SCrhp4oUmQaSxjoBBukr1NCP79zL9yhe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 28 Mar 2022 10:05:03 +0800, Haowen Bai wrote:

> fixes coccinelle warning:
> ./drivers/scsi/ipr.c:10095:13-15: Unneeded variable: "rc". Return
> "IRQ_HANDLED" on line 10104
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: ipr: Directly return instead of using local ret variable
      https://git.kernel.org/mkp/scsi/c/391b8dac5577

-- 
Martin K. Petersen	Oracle Linux Engineering
