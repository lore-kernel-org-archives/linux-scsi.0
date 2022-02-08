Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 033FEC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 05:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245224AbiBHFcp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 00:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347031AbiBHEub (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2022 23:50:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4318DC0401DC
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 20:50:30 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2181aSc7020227;
        Tue, 8 Feb 2022 04:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=9K0CQzjVpgjOPliXeFP4BN+tK3/6Nl89AX+BckNu44Q=;
 b=ua9KXh1ZXsZHQnp2eTCW1xN5dbgrd9LeDesUJ67jaDpSxIY7LmtTbyt3RfOrvzBfmDIx
 KJHyrkFPZhP1Fx1R9df26illDE58GkKD/w7zAth9Y7OYnkR991NLeiBayRwOsEubh0vj
 p833bNMCtrZZmidIHi+9A4hEd7HIPZMOc83MVXFs+/dgS6P4s/qR/0HHOzBpFutvU3uX
 yzq8WJHQS2SjYkuu+QHCsd0ILqvaVRwa7kPMJgmJq977AcCoxcvyCFvLuHgzymq8gEtV
 LOMfQOj39lksna1rOFTjSyp5y2iLGxGLO/f7PXG0OJhUYKI7+kl7ZNx5lYBk3+aGwJGK yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e366wsn2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 04:50:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2184fvCa008686;
        Tue, 8 Feb 2022 04:50:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3e1ebycs5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 04:50:27 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2184nxwY033941;
        Tue, 8 Feb 2022 04:50:27 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3e1ebycs5a-1;
        Tue, 08 Feb 2022 04:50:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: Reduce log messages see after successful firmware download
Date:   Mon,  7 Feb 2022 23:50:24 -0500
Message-Id: <164429578052.16306.2376208895043727551.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220207180442.72836-1-jsmart2021@gmail.com>
References: <20220207180442.72836-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: zGKjAgkuwFjyveDiF53O-V9BLRiO2pkZ
X-Proofpoint-ORIG-GUID: zGKjAgkuwFjyveDiF53O-V9BLRiO2pkZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 7 Feb 2022 10:04:42 -0800, James Smart wrote:

> Messages around fw download were incorrectly tagged as being related to
> discovery trace events. Thus, fw download status ended up dumping the
> trace log as well as the fw update message. As there were a couple of
> log messages in this state, the trace log was dumped multiple times.
> 
> Resolved by converting from trace events to sli events.
> 
> [...]

Applied to 5.17/scsi-fixes, thanks!

[1/1] lpfc: Reduce log messages see after successful firmware download
      https://git.kernel.org/mkp/scsi/c/5852ed2a6a39

-- 
Martin K. Petersen	Oracle Linux Engineering
