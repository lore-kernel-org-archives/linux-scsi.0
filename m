Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8FAC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 01:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344332AbiETBKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 21:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344252AbiETBJq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 21:09:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920531339F3
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 18:09:36 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K0InW3015728;
        Fri, 20 May 2022 01:09:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=ZXDi6E/xZWgrDCDs4Dg5DXRseoF743dOQ8b5xqfFcic=;
 b=hDYPEZFU3Cdq8Of95tKwNC8+sBgVGF7KpoIJZaohhdqtTgEyZ8CknfmBsU20oQawUzl7
 USto4cW2lRN3IB8l4VDM499qwG+flPRg9GX2Nucnh7L2q41mul7XSJ729rteqMEFkHWi
 Qu7THN6/PJrp+8lZx6JY9a+B0kDXahO1VFegY7ovCFJNjCHjMRkW4DpSsd7I3j5ZxcJS
 hT84OPfqYDihJKKeZzjN5qffw+dRyw4plEoJXKb/P2fyPgTIXYpzK1puBgPBFZXSnO/k
 JJdeKqq+ZNLZjv8IVmhTB09vK2Socd7YsJSesHgsucs8lyrMbHnjV/A6P1cM1NK7gVEF 2A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2372614q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:09:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24K15nFi020165;
        Fri, 20 May 2022 01:09:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crytue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:09:34 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24K19GKV030710;
        Fri, 20 May 2022 01:09:34 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crythd-14;
        Fri, 20 May 2022 01:09:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Fix junk chars displayed while printing ChipName
Date:   Thu, 19 May 2022 21:09:13 -0400
Message-Id: <165300891229.11465.17808228697025734882.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220511072621.30657-1-sreekanth.reddy@broadcom.com>
References: <20220511072621.30657-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: bd-IxoSeTHFRxa62oFQnTbZObUUNJCa_
X-Proofpoint-ORIG-GUID: bd-IxoSeTHFRxa62oFQnTbZObUUNJCa_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 11 May 2022 12:56:20 +0530, Sreekanth Reddy wrote:

> Make sure to append '/0' character after copying 16 bytes
> ChipName data from Manufacturing Page0. So that %s won't
> prints any junk characters.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] mpt3sas: Fix junk chars displayed while printing ChipName
      https://git.kernel.org/mkp/scsi/c/8e129add48e0

-- 
Martin K. Petersen	Oracle Linux Engineering
