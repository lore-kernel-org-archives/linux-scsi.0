Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEDBC7EE2F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 01:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbjFHBmx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 21:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbjFHBmr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 21:42:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E0926B9
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 18:42:42 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357LbxZ7011462;
        Thu, 8 Jun 2023 01:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=mPL891EaOYAUOc695Z8nHJn5vEWge1l2TLYgGx3Gsqk=;
 b=l1aikNbBBu2wl7gUlwfVo7kphRtUsP+zvgZjKE6Y8mvuArXlobWqgA2OMJcpxbsx8erg
 cYesRgrAj0fm9wgAgl5sFpCijmOMmVUWrNwOghu/wXRya56UrO0o9lDdiesjBecelphE
 1vzR5wVBx6MZEZjx7AhDumobkR/yF8/rmqf9qBrgMNd959ytZ9n8KsVDxUDg/hI8E/ZD
 Dk5BXN/TLfzAJzEfmHKL+UD+C4nNpJpcxeBt7xig9Zqw6Mnp0kiTvT4V9y5rjZurZR+W
 ssxRVpEh7XIaQWiAdKI2LMYng9IyfMT7xo34hyURdKlZDmsY/UpE+N/S7tEQ+B6OIoQT dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6uu6pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:36 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35803Rik036504;
        Thu, 8 Jun 2023 01:42:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6hyt7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:36 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3581gQUp031871;
        Thu, 8 Jun 2023 01:42:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3r2a6hyt3a-7;
        Thu, 08 Jun 2023 01:42:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/4] UFS host controller driver patches
Date:   Wed,  7 Jun 2023 21:42:11 -0400
Message-Id: <168618844286.2636448.6734223743204626301.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230524203659.1394307-1-bvanassche@acm.org>
References: <20230524203659.1394307-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_13,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306080011
X-Proofpoint-GUID: e2fTizmhS8yClMJ2fJbK5-VuDRixV6Xv
X-Proofpoint-ORIG-GUID: e2fTizmhS8yClMJ2fJbK5-VuDRixV6Xv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 24 May 2023 13:36:18 -0700, Bart Van Assche wrote:

> Please consider these four UFS host controller driver patches for the next
> merge window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/4] scsi: ufs: Increase the START STOP UNIT timeout from one to ten seconds
      https://git.kernel.org/mkp/scsi/c/fe8637f7708c
[2/4] scsi: ufs: Fix handling of lrbp->cmd
      https://git.kernel.org/mkp/scsi/c/549e91a9bbaa
[3/4] scsi: ufs: Move ufshcd_wl_shutdown()
      https://git.kernel.org/mkp/scsi/c/b251f6c5fe3b
[4/4] scsi: ufs: Simplify driver shutdown
      https://git.kernel.org/mkp/scsi/c/0818a6903c80

-- 
Martin K. Petersen	Oracle Linux Engineering
