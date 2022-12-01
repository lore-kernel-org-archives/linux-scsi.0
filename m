Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765AAC43217
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiLADpk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLADpk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:45:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EA49075D
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:45:39 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1297Ha022941;
        Thu, 1 Dec 2022 03:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=KSNhamru3SNwSsSCEP00WoJeNcOmlfUX0KEXEQkLz8o=;
 b=r1i96dQeLCKyHXSZv/M/WBsdfZG/MLO9JU/bVlwtrK7ezi83jgr/N0ii3YEN5L7LUjuX
 GSfy9Nj0/dIUoU0Bf2HEanUywpG/JIkZIy8ptM02vd/LP7/djAfpq/1j0uC4y+PO4MTt
 UsPEZDXstgnhF9cYlhNFE3YG06wBnao9XIiIM7tFrZi6wqQJ770ZF1FhaSEjZMV6+ClV
 KZLyIvAw1p68WkjKSuvL6JSp9MO2rZY43bN4ItF7CpZ7dhg9NzcMTA6+7bX59+Wiev7u
 f4yFg+xZD9POQL7GPtBwJKJ/tNp6GI58VRuMEkhKuY9iiwF7e+Me3Xu5hxrgu5+ehgB7 Ew== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3xhtbnpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B13NYvx007933;
        Thu, 1 Dec 2022 03:45:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2ck8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:37 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbpM033801;
        Thu, 1 Dec 2022 03:45:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-1;
        Thu, 01 Dec 2022 03:45:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Rework how the ALUA driver calls scsi_device_put()
Date:   Thu,  1 Dec 2022 03:45:02 +0000
Message-Id: <166986602290.2101055.17397734326843853911.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221117183626.2656196-1-bvanassche@acm.org>
References: <20221117183626.2656196-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=679 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010022
X-Proofpoint-GUID: tu4KkcYFhn6Z1-i-vUeC2k8eo221pxru
X-Proofpoint-ORIG-GUID: tu4KkcYFhn6Z1-i-vUeC2k8eo221pxru
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 17 Nov 2022 10:36:24 -0800, Bart Van Assche wrote:

> This patch series reworks how the SCSI ALUA device handler calls
> scsi_device_put(). Please consider this patch series for the next merge
> window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/2] scsi: alua: Revert "Move a scsi_device_put() call out of alua_check_vpd()"
      https://git.kernel.org/mkp/scsi/c/a500c4cc06cd
[2/2] scsi: alua: Call scsi_device_put() from non-atomic context
      https://git.kernel.org/mkp/scsi/c/50759b881e1d

-- 
Martin K. Petersen	Oracle Linux Engineering
