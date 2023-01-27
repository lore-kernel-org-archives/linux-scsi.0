Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50710C54EAA
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 03:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbjA0DWn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Jan 2023 22:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbjA0DWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jan 2023 22:22:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CFF611C2
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2023 19:22:36 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30R0Ngco009751;
        Fri, 27 Jan 2023 03:22:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=I3Z2ntnupFy9PfDCQQhwHLCEFo20PHpg9aRDWmPygCE=;
 b=DrWM1R/0Jzfmu01VGlrDCRTzZ4LTOHZSaAN3/fZsMYvUVhHmRnbb6ncmEYrvttUdtSus
 I2lKVzbysxBExczkIlVQFbZXUN7UJwaoirJVjbdoYv5/Fngppzxi2ELYuCYVmY79G/m6
 /0k7Iy2L1/e0MBkCinibgGFeHD8qgmy4Mu9KRx/8/go8ww/FA8iiXvxWg39yhBzimmxW
 9NSEWpwbMT0qzvOu2FVH7l49tzDY+oi3pxrKK5IMdOYEq9c69iXAsWp4SVLDPu+/BDWl
 bDbGpuuxbCvldQ7W9fs23RpQ5QmVP7GGIVT9FcfzLGfR90E+f7sZbRwg0aYGBuZQYOzO qQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87ntbvm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 03:22:22 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30R36FQj034490;
        Fri, 27 Jan 2023 03:22:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g91sb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 03:22:20 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30R3MJpu000968;
        Fri, 27 Jan 2023 03:22:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3n86g91sb3-1;
        Fri, 27 Jan 2023 03:22:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: Fix the scsi_device_put() might_sleep annotation
Date:   Thu, 26 Jan 2023 22:22:12 -0500
Message-Id: <167478903314.4070509.17553562843256554477.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230125194311.249553-1-bvanassche@acm.org>
References: <20230125194311.249553-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_09,2023-01-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=823 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301270028
X-Proofpoint-ORIG-GUID: CpB2pBTdowcdO70vKP6Q3HuW-44Mglb0
X-Proofpoint-GUID: CpB2pBTdowcdO70vKP6Q3HuW-44Mglb0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 25 Jan 2023 11:43:11 -0800, Bart Van Assche wrote:

> Although most calls of scsi_device_put() happen from non-atomic context,
> alua_rtpg_queue() calls this function from atomic context if
> alua_rtpg_queue() itself is called from atomic context. alua_rtpg_queue()
> is always called from contexts where the caller must hold at least one
> reference to the scsi device in question. This means that the reference
> taken by alua_rtpg_queue() itself can't be the last one, and thus can be
> dropped without entering the code path in which scsi_device_put() might
> actually sleep. Hence move the might_sleep() annotation from
> scsi_device_put() into scsi_device_dev_release().
> 
> [...]

Applied to 6.2/scsi-fixes, thanks!

[1/1] scsi: core: Fix the scsi_device_put() might_sleep annotation
      https://git.kernel.org/mkp/scsi/c/2542fc9578d4

-- 
Martin K. Petersen	Oracle Linux Engineering
