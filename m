Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EFDC61DA4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 02:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjCGC5n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 21:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjCGC5n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 21:57:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D7E64A8E
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 18:57:41 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326NxYWr029949;
        Tue, 7 Mar 2023 02:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=gHWH6yLl1GX7vzJwAu87nhKYZ8l4dB4RYAI/yqkKUhc=;
 b=edKUgz3dYo5av04RUC6llBgXX//wXhkiqpPcmlNVY8a3x5rdOKE624v+Lz8YZyp87vFX
 tkpwA+Ww2Qix5W3IQTvsLgJSoHkBhAlvFMnBk7m6Vyd8MNSX9W/YuPc9TDJSW6bnAU3O
 jFYCCpR86mZANI3MKcRRyF5pYUE8qQIHjUAowXsJrOMmN8CQa+VXdNmGjHD39H82GG6K
 cIczCtu8LQ8zi8aR2IzDezw0TD3j/Jy67XoIIKuISRsxPiCOL3R6Vzg2hNArXxQ42SaC
 4/LfwMOeWi9utEUeZz4V2FDJujqpPfMvvi3P4ymiq8oud/EOuW3xlgQ1SER2Ewh/dH0F KQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418xvh46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3271eQeR037536;
        Tue, 7 Mar 2023 02:57:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4txdvjj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:36 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3272vY2E009567;
        Tue, 7 Mar 2023 02:57:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p4txdvjhj-3;
        Tue, 07 Mar 2023 02:57:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH] qla2xxx: Add option to disable FC2 Target support
Date:   Mon,  6 Mar 2023 21:57:20 -0500
Message-Id: <167815780196.2075334.4292132432766559277.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208152014.109214-1-dwagner@suse.de>
References: <20230208152014.109214-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=594 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070025
X-Proofpoint-GUID: Tahpclp9obWJCmgyCVgjfzxAmwUVKEA2
X-Proofpoint-ORIG-GUID: Tahpclp9obWJCmgyCVgjfzxAmwUVKEA2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 08 Feb 2023 16:20:14 +0100, Daniel Wagner wrote:

> 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target") added
> support for FC2 Targets. Unfortunately, there are older setups which
> break with this new feature enabled.
> 
> Allow to disable it via module option.
> 
> 
> [...]

Applied to 6.3/scsi-fixes, thanks!

[1/1] qla2xxx: Add option to disable FC2 Target support
      https://git.kernel.org/mkp/scsi/c/877b03795fcf

-- 
Martin K. Petersen	Oracle Linux Engineering
