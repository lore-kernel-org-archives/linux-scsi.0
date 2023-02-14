Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB952C61DA4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 16:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbjBNQ5y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 11:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjBNQ5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 11:57:50 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EAF213D;
        Tue, 14 Feb 2023 08:57:48 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31EGYKRT009085;
        Tue, 14 Feb 2023 16:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=8BndkDXDJmua3bIGB06MmOv7VgP307GShGW7ZyqrEMI=;
 b=rOLj7WYO2LsNHRBJG8TZJa1k+sqsfzbRTJevWjZ5riCyXb/9y7sbmSq218RxNvm4o2mq
 ACUnVEDBbcpbTcZitdeV8rjYoYXOhhsY/eVYpnTrTIXAvfx0nHf2lzUCsSqgOg23b1/B
 spIDawKI5+C0B7ydhPQPgOAOc7Yd1BDt5IBlndn/ipHNlk3mWR9vAhvpuw4G1ejhCr8O
 T8USMzW6FADtTyD/ZqzzNCjZY4WK1hB/8OgnPjfNgdNzla36UAsB8KOvCcfEZgY1O1S8
 HqNkBkygUpqOopaFaOKHhxgmAmKB64xwdDyBf82YEkuf+/Hio/Ka/qNr8LpHtmU/+G9r dQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2w9wyah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 16:57:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31EGuAV0009532;
        Tue, 14 Feb 2023 16:57:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f5uugr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 16:57:42 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31EGuHoh039739;
        Tue, 14 Feb 2023 16:57:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3np1f5uuff-4;
        Tue, 14 Feb 2023 16:57:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3][next] scsi: smartpqi: Replace one-element array with flexible-array member
Date:   Tue, 14 Feb 2023 11:57:30 -0500
Message-Id: <167639371128.486235.8328339793561034733.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <Y+LJz/r6+UeLqnV3@work>
References: <Y+LJz/r6+UeLqnV3@work>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_11,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=736 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140144
X-Proofpoint-GUID: 3GtV5H2wPxDJNlsXjhEFdrCDqlz4RxVR
X-Proofpoint-ORIG-GUID: 3GtV5H2wPxDJNlsXjhEFdrCDqlz4RxVR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 07 Feb 2023 15:59:43 -0600, Gustavo A. R. Silva wrote:

> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct report_log_lun_list.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
> on memcpy().
> 
> [...]

Applied to 6.3/scsi-queue, thanks!

[1/1] scsi: smartpqi: Replace one-element array with flexible-array member
      https://git.kernel.org/mkp/scsi/c/ead821268c14

-- 
Martin K. Petersen	Oracle Linux Engineering
