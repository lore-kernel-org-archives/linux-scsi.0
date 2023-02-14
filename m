Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB82C6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 16:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbjBNQ6A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 11:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjBNQ5x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 11:57:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2793A4EE3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 08:57:52 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31EGYIdf009051;
        Tue, 14 Feb 2023 16:57:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=GvB8z7O4AyWfVWXlmumaI+hqgCPYRENXFro+Nn6j8nM=;
 b=LFHadtZkMIqRWcDcXe64FagZ+HGaJncuCmKdyHLMduD6/KOgIMaOFJe1GDXxMxUEw4Cr
 3AYOsz6azzgj6FtDEqkEH+tOp05GiEd9E/O+wBlvZk1QtAMU6eEnU22zc+7yW8OYMv3s
 zeQ+a4Rl3s/PLBGyTTxC7be9nOtx8ho37HQLlgA+FKhg22cBLBY0wdTAvVNk0cDUoz/P
 lDlKJ8gXkeILSRBsh+oBFmnyFj+LW74TPpr9zRq7xCWM/iQ25qY8fB7Ae78rOeZsM7z+
 5BZYMjR11oD5TcAmeS5m+AogNirV716l77gzdywFvCbXbBlHIW5ULwUrAM04b5Qfr0vD 4Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2w9wyan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 16:57:49 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31EGtkSO009613;
        Tue, 14 Feb 2023 16:57:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f5uum4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Feb 2023 16:57:47 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31EGuHow039739;
        Tue, 14 Feb 2023 16:57:47 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3np1f5uuff-11;
        Tue, 14 Feb 2023 16:57:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com
Subject: Re: [PATCH] mpt3sas: fix a memory leak
Date:   Tue, 14 Feb 2023 11:57:37 -0500
Message-Id: <167639371127.486235.972397501077513405.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207152159.18627-1-thenzl@redhat.com>
References: <20230207152159.18627-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_11,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=674 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140144
X-Proofpoint-GUID: 3P24oiazwwKCOUM2mbqUWa0MzFPRoCpF
X-Proofpoint-ORIG-GUID: 3P24oiazwwKCOUM2mbqUWa0MzFPRoCpF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 07 Feb 2023 16:21:59 +0100, Tomas Henzl wrote:

> Add a forgotten kfree
> 
> 

Applied to 6.3/scsi-queue, thanks!

[1/1] mpt3sas: fix a memory leak
      https://git.kernel.org/mkp/scsi/c/54dd96015e8d

-- 
Martin K. Petersen	Oracle Linux Engineering
