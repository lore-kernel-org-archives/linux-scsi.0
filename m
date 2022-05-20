Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D7BC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 01:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344249AbiETBJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 21:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344225AbiETBJ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 21:09:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8188129EF2;
        Thu, 19 May 2022 18:09:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K0IsKC005482;
        Fri, 20 May 2022 01:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=WqmnPfMrOmzIWVYKWpQlgrLi2FWRYuSK1sSU+Vv2QBs=;
 b=xb2E6scXMyOOYtxFVFCWav3AIcomyHu63T6DDerQbz5Yw6dnIGsDiDUKZdXyR3RQoE4Z
 Cipkz0Xw6mv0raYoz9jhSpzJmkI2ZcJ1Qh9YXhn8x+Fk1MeBsubL/RjZS/zmaf0YHigC
 msX9OZ/EqUPfNm5gJIxpEDIYavpRzD924uS7VS3jDcnxVDyAFda6qjAKrIkDi+TPNxoz
 sojmJnjQ8gWTFx3AJgbxFJkg/CXPBuZ+YWl0pUYb2b9nrK8biVAOKfGF4WisGmBz0tyl
 CPHheKLU/rJFTRTDSr6pboNvUa0wRc3/xUihM5jvd+UzVgKfe/Ieg+RJMoadv9UMYrk2 Dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucddqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:09:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24K15nhB020150;
        Fri, 20 May 2022 01:09:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crytke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:09:20 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24K19GKB030710;
        Fri, 20 May 2022 01:09:20 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crythd-4;
        Fri, 20 May 2022 01:09:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Bodo Stroesser <bostroesser@gmail.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: target: tcmu: Avoid holding XArray lock when calling lock_page
Date:   Thu, 19 May 2022 21:09:03 -0400
Message-Id: <165300891233.11465.9872844420692746335.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220517192913.21405-1-bostroesser@gmail.com>
References: <20220517192913.21405-1-bostroesser@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: J3AuiTAaLuLJM5VAvSNtHkk1mjE6pSF6
X-Proofpoint-ORIG-GUID: J3AuiTAaLuLJM5VAvSNtHkk1mjE6pSF6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 17 May 2022 21:29:13 +0200, Bodo Stroesser wrote:

> In tcmu_blocks_release, lock_page() is called to prevent a race causing
> possible data corruption. Since lock_page() might sleep, calling it
> while holding XArray lock is a bug.
> 
> To fix the bug switch to XArray normal API by replacing the xas_for_each
> with xa_for_each_range. Since normal API does its own handling of
> XArray locking, now the xas_lock and xas_unlock around the loop are
> obsolete.
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Avoid holding XArray lock when calling lock_page
      https://git.kernel.org/mkp/scsi/c/325d5c5fb216

-- 
Martin K. Petersen	Oracle Linux Engineering
