Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D694BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 11 May 2022 02:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbiEKCrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 22:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242808AbiEKCiN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 22:38:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB79E1BDADA
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 19:38:12 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AL2nLL019308;
        Wed, 11 May 2022 02:38:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=UkeH7MV+PanIWe22eFBgKxOmKmPQ+dEVK22w40TMb/g=;
 b=TYD7cWXF97TNLVXbMAIdlz8vKBitSqsWSDEraav3rwQPZWHDqgKfZEWtaVkzibOffDhI
 IxZxfHPfJTaR0qPFkRvCd1pXMvpjPDvH1czX0XAjwWs2tAeANqzuMqmDSpDd0RRc/Tpn
 e0wWVUjJaPtELJQbnMKkL9Ld0Te284NrrJyu2rWiNrqbGThYWP5Eds/GsCGh2nuFWmxk
 5qSAdDuVrumUSOaCdyY8AQFIYJF97JG4bVZc60dVrCu0creEk/k+L/UsnrQu9w4E0EMn
 vKMBK2vE/XVpT5npwNILNX/yLS3TwK6+wTh5wLDsIM2gF3o03k3XfwFb6CZjRor/uNuS DQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgn9r3e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:38:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24B2LeZ4015374;
        Wed, 11 May 2022 02:38:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf73sctm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:38:10 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24B2c95Z027764;
        Wed, 11 May 2022 02:38:09 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf73scsr-2;
        Wed, 11 May 2022 02:38:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH] lpfc: Fix split code for FLOGI on FCoE
Date:   Tue, 10 May 2022 22:38:07 -0400
Message-Id: <165223667361.31045.11196517332678119347.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220506205528.61590-1-jsmart2021@gmail.com>
References: <20220506205528.61590-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: nBYzkq8R46IaR0grrNimuZ1TDPeTvJ-6
X-Proofpoint-ORIG-GUID: nBYzkq8R46IaR0grrNimuZ1TDPeTvJ-6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 6 May 2022 13:55:28 -0700, James Smart wrote:

> The refactoring code converted context information from SLI-3 to SLI-4.
> The conversion for the SLI-4 bit field tried to use the old (hacky)
> sli3 high/low bit settings.  Needless to say, it was incorrect.
> 
> Explicitly set the context field to type FCFI and set it in the wqe.
> SLI-4 is now a proper bit field so no need for the shifting/anding.
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/1] lpfc: Fix split code for FLOGI on FCoE
      https://git.kernel.org/mkp/scsi/c/cc28fac16ab7

-- 
Martin K. Petersen	Oracle Linux Engineering
