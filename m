Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933C0C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343712AbiDGNiC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343679AbiDGNhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB1421A6
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:26 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237DVe29014690
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=SfNR0aLCnzLV1Vsz+4mk+JUPeV82Hyg5zRb5GrM7Rws=;
 b=l0tNXtB0i8JoPT13HCsPAnoCu1nY9Tku9uKOyQRz2/EH7Tl0cEZjZSyJh402SPDGVODp
 SIosMDUR3nHiVCbirTbsd4xj+BPP3O89dFot2aPHi7NXLq+V4bgFdvI7/Vx1XPcrPiX7
 Lr95avF87WkEuEyJFCAy+HkRMCJRQZ+9ZmpZAELRPtLcT5ahJsNP9PPHv1aWWj5SMUI2
 +YXNQnp/Otj26PD4hA4oxq5qswAk3kDT8SVrV5876UsuMKUfwISWQqAlxB+M4bxnJjxW
 cBx2gqX45Imz5K4IH8T194dNQbFOpEVkAM/o7ACrfpDY+OnymbDukXXEkCYuwnjG4pam HA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9up2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVR7036890
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:23 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJLq032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:23 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-6;
        Thu, 07 Apr 2022 13:35:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aha152x: Stop using struct scsi_pointer
Date:   Thu,  7 Apr 2022 09:35:05 -0400
Message-Id: <164929678999.15424.7742354832067450267.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <bdc1264b6dd331150bffb737958cab8c9c068fa1.1648070977.git.fthain@linux-m68k.org>
References: <bdc1264b6dd331150bffb737958cab8c9c068fa1.1648070977.git.fthain@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: LISZLecErQ-Ud6HYqsmZuUX2wJTc_Ubp
X-Proofpoint-ORIG-GUID: LISZLecErQ-Ud6HYqsmZuUX2wJTc_Ubp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 24 Mar 2022 08:29:37 +1100, Finn Thain wrote:

> Remove aha152x_cmd_priv.scsi_pointer by moving the necessary members
> into aha152x_cmd_priv proper.
> 
> Tested with an Adaptec SlimSCSI APA-1460A card.
> 
> 

Applied to 5.18/scsi-fixes, thanks!

[1/1] aha152x: Stop using struct scsi_pointer
      https://git.kernel.org/mkp/scsi/c/63221571ef77

-- 
Martin K. Petersen	Oracle Linux Engineering
