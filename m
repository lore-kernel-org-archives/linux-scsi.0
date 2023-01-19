Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1809C677F1
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 00:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjASApG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 19:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjASApC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 19:45:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606FD577C6
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2023 16:45:01 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ILmoNW013700;
        Thu, 19 Jan 2023 00:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=7OF1B9DnI5zqWy7wnFURWEq4s+nIpA5RL03dHLbgWeA=;
 b=RhHRTrQCFOaQnc8D0a3btJULgDnzmP8h9M1oPjrVUjuIbfaUqcLExODI37J7kc7qRDJF
 rIIQvqzkMOPka1MabM9Hx4aMXQGzwxjqgJvbGMZF3Hb/6JajZbdF83wyaV9hx7O/UABR
 T53Pb+gN2EoNjCPltOLcHIfIbJvT7l8PXrqVlN2LfT/92Ce94pIlVWegPRksmQtqMfQv
 7+3fessR7I93Ty/0WNItOuOb0r+f8RVsneEKJEJF7SurAFrXlYwH9DrQNb03OMiAtMeF
 Tb1K+oQp7wogw583Ix8KuL5TE58EzDt7CvODmJJ6+m3QxqHrdVK8SzqQw5hCTEL5ktpz Lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3medh3jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 00:44:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30INQZP6035096;
        Thu, 19 Jan 2023 00:44:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n6rgcdnn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 00:44:47 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30J0ijFx007831;
        Thu, 19 Jan 2023 00:44:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3n6rgcdnm5-2;
        Thu, 19 Jan 2023 00:44:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     quic_asutoshd@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        Can Guo <quic_cang@quicinc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Add support for UFS Event Specific Interrupt
Date:   Wed, 18 Jan 2023 19:44:40 -0500
Message-Id: <167408782520.3511660.2354370414246087533.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <1671073583-10065-1-git-send-email-quic_cang@quicinc.com>
References: <1671073583-10065-1-git-send-email-quic_cang@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 mlxlogscore=867
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190001
X-Proofpoint-ORIG-GUID: aBjhuPKQ6T_XP5EHtMomj8_2EEXWsH-G
X-Proofpoint-GUID: aBjhuPKQ6T_XP5EHtMomj8_2EEXWsH-G
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 14 Dec 2022 19:06:19 -0800, Can Guo wrote:

> UFS Multi-Circular Queue (MCQ) driver is on the way. This patch series is
> to enable Event Specific Interrupt (ESI), which can used in MCQ mode.
> 
> Please note that this series is developed and tested based on the latest MCQ
> driver (v11) pushed by Asutosh Das.
> 
> v2 -> v3:
> - Improved commit msg of patch #2 by incorporating Bart's comment
> 
> [...]

Applied to 6.3/scsi-queue, thanks!

[1/3] ufs: core: Add Event Specific Interrupt configuration vendor specific ops
	https://git.kernel.org/mkp/scsi/c/edb0db05607c
[2/3] ufs: core: mcq: Add Event Specific Interrupt enable and config functions
	https://git.kernel.org/mkp/scsi/c/e02288e0265f
[3/3] ufs-host: qcom: Add MCQ ESI config vendor specific ops
	https://git.kernel.org/mkp/scsi/c/519b6274a777

-- 
Martin K. Petersen	Oracle Linux Engineering
