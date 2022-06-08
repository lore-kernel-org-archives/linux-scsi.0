Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3839CCA47B
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 07:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbiFHHSv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 03:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348125AbiFHF6P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 01:58:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEFA100502
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 21:26:00 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257MCHJh005933;
        Wed, 8 Jun 2022 02:28:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=fO7giX1WXeMlTYm2fVOIPCeyluEjhJ8iB51ek+hxQKw=;
 b=jnPVRwCyt/MXt6CmxKZe5DQ2P/70NREVRqYIckzKVtm6aH3WMuLEYfQpdLMSfct7cz5V
 xwxOT71YDuPQcoSjIdNNHVlGHc2pv5PMbby3Tx8xVdSdL+eLp8fAaWnBvMde1RKcwnm6
 8EJLjzqWWTb7yQz3LcRSDPn2jUAuoKipEBl0B3sePeRcWHOhr2g4SmQQu+HxA9QB2nLt
 5Gs/ibs8ZxhyZMz51/tthaFdJrI5wTp+tkzPOVmKTf+kD82FuMUfguHLpv61x80W3kG8
 BKRGPRO6EmyUi2w5AbjbQenJ9tRsZMHJjPJxCG1Ynf4iRhhjTTNFvJ8PPBwcrrKs9yLO Og== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghexecnms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 02:28:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2582AUT6037992;
        Wed, 8 Jun 2022 02:28:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu334ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 02:28:04 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2582RxlX032073;
        Wed, 8 Jun 2022 02:28:03 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu33499-5;
        Wed, 08 Jun 2022 02:28:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Matt Wang <wwentao@vmware.com>, Vishal Bhakta <vbhakta@vmware.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dingyan Li <ldingyan@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        Elaine Zhao <yzhao@vmware.com>, linux-scsi@vger.kernel.org,
        Carrie Yang <yangm@vmware.com>
Subject: Re: [PATCH] vmw_pvscsi: expand vcpuHint to 16 bit.
Date:   Tue,  7 Jun 2022 22:27:57 -0400
Message-Id: <165465514542.8982.9798888503343942870.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <EF35F4D5-5DCC-42C5-BCC4-29DF1729B24C@vmware.com>
References: <EF35F4D5-5DCC-42C5-BCC4-29DF1729B24C@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: X_zoK-s4qPKS8JxHOzYZPedOkl1RXyYP
X-Proofpoint-ORIG-GUID: X_zoK-s4qPKS8JxHOzYZPedOkl1RXyYP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2 Jun 2022 08:57:00 +0000, Matt Wang wrote:

> From 444507afb19f0384a3ad82fde04b78f439b42f0b Mon Sep 17 00:00:00 2001
> From: Wentao Wang <wwentao@vmware.com>
> Date: Thu, 2 Jun 2022 11:42:44 -0400
> Subject: [PATCH] vmw_pvscsi: expand vcpuHint to 16 bit.
> 
> vcpuHint has been expanded to 16 bit on host to enable to route to
> more CPUs, guest side should align with the change.
> This change has been tested with hosts with 8 bit and 16 bit
> vcpuHint, on both platform host side can get correct value.
> 
> [...]

Applied to 5.19/scsi-fixes, thanks!

[1/1] vmw_pvscsi: expand vcpuHint to 16 bit.
      https://git.kernel.org/mkp/scsi/c/cf71d59c2ece

-- 
Martin K. Petersen	Oracle Linux Engineering
