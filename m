Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4899FC7EE23
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 01:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbjFHBnR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 21:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbjFHBnG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 21:43:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C949226B0
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 18:42:48 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357N4j1G007978;
        Thu, 8 Jun 2023 01:42:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=638gyNiIJPXgeRZvbHUMVl+30zUKfFetnkrNEvdda7g=;
 b=Xq39f0kZPpu9j+E7ZngbZGDp3fHlXyXmE7RJmQmEyfDwBIKmRe+sdXT7Ec7qwlhz0z2F
 Uwwplqtt03pSwv0t50CnMFZ+dx7tGehEDs82bjy5xpqnY7QClRC9XDWowWlHNzNY9xJL
 uTHaq9rAl5rlaxfZnwychuizYPwtZFsadK+J6sBM9TY2vZdBRhQYvCPNOF/9ONVZkkA1
 lPClG8s1sIf19lBtqn6HK1w+X6EIYKEjU6fw2RfJLCN+HSzWnGM2llwhYnJpVKtIY9W6
 zlZGzjKrTndiv5z6grOThwbgYV/OfP26R0gWD7tqDHMIfyZKDTeGtFyE2A80oxOKTQnN pQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6rk4v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:38 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 357N13ec037208;
        Thu, 8 Jun 2023 01:42:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6hyt87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:42:37 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3581gQUt031871;
        Thu, 8 Jun 2023 01:42:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3r2a6hyt3a-9;
        Thu, 08 Jun 2023 01:42:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 0/5] ufs: Do not requeue while ungating the clock
Date:   Wed,  7 Jun 2023 21:42:13 -0400
Message-Id: <168618844258.2636448.11837319348501853272.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529202640.11883-1-bvanassche@acm.org>
References: <20230529202640.11883-1-bvanassche@acm.org>
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
X-Proofpoint-ORIG-GUID: In4m6kK7DZGS5vFZpXlm0S8C7DXHKxQI
X-Proofpoint-GUID: In4m6kK7DZGS5vFZpXlm0S8C7DXHKxQI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 29 May 2023 13:26:35 -0700, Bart Van Assche wrote:

> In the traces we recorded while testing zoned storage we noticed that UFS
> commands are requeued while the clock is being ungated. Command requeueing
> makes it harder than necessary to preserve the command order. Hence this
> patch series that modifies the SCSI core and also the UFS driver such that
> clock ungating does not trigger command requeueing.
> 
> Please consider this patch series for the next merge window.
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/5] scsi: core: Rework scsi_host_block()
      https://git.kernel.org/mkp/scsi/c/c854bcdf5e18
[2/5] scsi: core: Support setting BLK_MQ_F_BLOCKING
      https://git.kernel.org/mkp/scsi/c/b125bb99559e
[3/5] scsi: ufs: Conditionally enable the BLK_MQ_F_BLOCKING flag
      https://git.kernel.org/mkp/scsi/c/6c03c8e9b729
[4/5] scsi: ufs: Declare ufshcd_{hold,release}() once
      https://git.kernel.org/mkp/scsi/c/4b68b7f9c46d
[5/5] scsi: ufs: Ungate the clock synchronously
      https://git.kernel.org/mkp/scsi/c/078f4f4b34d6

-- 
Martin K. Petersen	Oracle Linux Engineering
