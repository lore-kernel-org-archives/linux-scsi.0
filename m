Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B730C41535
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Oct 2023 15:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbjJ3PfM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Oct 2023 11:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbjJ3PfK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Oct 2023 11:35:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E87EA
        for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2023 08:35:07 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UDcHM5014319;
        Mon, 30 Oct 2023 15:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=YMrjwfiq+FSpm3RRz7RqVWl668BJyKmJ1LC/oKWYRbA=;
 b=wUQGZjLjhBDn6XMDm7zl36elF5RDCAr0Mm7S3osck6hAPEcstRSeN2xKDTr/vfFOyC0f
 QGsEfuSIH2NZ52PUJ7m3l68/YPBiVZNBYHNzTNsnNxhPVIfxYafx6QojTFasGElmu+IG
 bif6Qna7CJs10SJJn5KtL7+5yfz2XgNlzCosLwkcWl+rwUPLyP+gqY3BUymqiF2ij9NU
 94cVQLeyZupLerlIejOFjC27017MscJl79876csMN5pZV5aGNxGwHQXsfYBn0I+g5y+0
 IbQzC3jH5RtqvRRUl9cze1R8+cg3UR1CT5yPmc2cQ/jM4BdxXWQDBVKhfiiFuXsqXY1x nQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0tbdk0p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Oct 2023 15:35:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39UE42NP038141;
        Mon, 30 Oct 2023 15:35:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rran8wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Oct 2023 15:35:00 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39UFVkmE023458;
        Mon, 30 Oct 2023 15:34:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3u0rran8wc-3;
        Mon, 30 Oct 2023 15:34:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] megaraid: fixup debug message in megaraid_abort_and_reset()
Date:   Mon, 30 Oct 2023 11:34:47 -0400
Message-Id: <169868005495.2933713.5608926590163412580.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231023073021.21954-1-hare@suse.de>
References: <20231023073021.21954-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 mlxlogscore=632 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2310300120
X-Proofpoint-GUID: cTQQ6N8l98CviF7my8emewfyvaR5q-Xw
X-Proofpoint-ORIG-GUID: cTQQ6N8l98CviF7my8emewfyvaR5q-Xw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 23 Oct 2023 09:30:21 +0200, Hannes Reinecke wrote:

> Found by Smatch.
> 
> 

Applied to 6.7/scsi-queue, thanks!

[1/1] megaraid: fixup debug message in megaraid_abort_and_reset()
      https://git.kernel.org/mkp/scsi/c/f2d79aa16aee

-- 
Martin K. Petersen	Oracle Linux Engineering
