Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65894C76195
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Mar 2023 01:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjCYBQ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 21:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjCYBQ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 21:16:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C7B199FF
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 18:16:56 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32P10H5O009162;
        Sat, 25 Mar 2023 01:16:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=ype9RWPbw7NLYwiC0MBqdHbrRdbht4DJmvwxCKJvPkQ=;
 b=nV8yfrl22cZhm+uAj19RuSGPMulyUPsZZlEFNMGW7gVL/du98zGNgyIbvnkmb5whhGwx
 dXhTSLpURabrDklnwfeoJ5rrfg775cw0H6a9lhnULfhXTMJdecm17bDc9vQzKPHol4K+
 bz8dGGWDcVc5FkQ353fnx+reN16sA2njbzZ4DyzABg3xoGiHVIqubyD8+gUzp0DFpKB7
 YxNv1iTRzEUnPV/wFVQ2GXfXWKiT2JtNjJYI+trCzXni4sKCo35ov0Gt5RcAYj+AWvEj
 zNhe9hh1RBi14/i5hG8UkENxb+g26sgdnbFizj2ckw7XhdnZoRwnnh/uzGmikfS0YAym Qg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phpwd80v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Mar 2023 01:16:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32ONQBNk027798;
        Sat, 25 Mar 2023 01:16:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4xx6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Mar 2023 01:16:52 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32P1GpkC018222;
        Sat, 25 Mar 2023 01:16:51 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pgxk4xx6j-2;
        Sat, 25 Mar 2023 01:16:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com
Subject: Re: [PATCH] scsi: megaraid_sas: fix for a crash after a double completion
Date:   Fri, 24 Mar 2023 21:16:45 -0400
Message-Id: <167970695937.326111.3467035512408182537.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230324150134.14696-1-thenzl@redhat.com>
References: <20230324150134.14696-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=501 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303250007
X-Proofpoint-GUID: 1fR2ap_HXaKAY0hMJuPYfcQJxqQkv-5U
X-Proofpoint-ORIG-GUID: 1fR2ap_HXaKAY0hMJuPYfcQJxqQkv-5U
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 24 Mar 2023 16:01:34 +0100, Tomas Henzl wrote:

> When a physical disk is attached directly "without JBOD MAP support"
> (see megasas_get_tm_devhandle) then there is no real error handling in the
> driver.
> Return FAILED instead of SUCCESS.
> 
> Fixes: 18365b138508 ("megaraid_sas: Task management support")
> 
> [...]

Applied to 6.3/scsi-fixes, thanks!

[1/1] scsi: megaraid_sas: fix for a crash after a double completion
      https://git.kernel.org/mkp/scsi/c/2309df27111a

-- 
Martin K. Petersen	Oracle Linux Engineering
