Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91954C6FA8F
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345666AbjHaBt2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345647AbjHaBtO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:49:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304C6CD2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:49:11 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0EEF4004204;
        Thu, 31 Aug 2023 01:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=Qa5PMBIFrU87RjvAeNjsJGd54gO2UtMLfA/cUZlrhm0=;
 b=nL+W1rZX3jgRiQgVFsHJ3y2NFlpHOU669RXgUQoL8XBDwGHnbE+AHgP8NkOnz8MWgay4
 VxBi7UFuB2a1v24WSvveGZM1XmIn2lvlxEMu8TrmWAdanjubtcp9KahyCwS0+kYPKvfv
 OzNmiLE7SXypwjnKFDqSbbK9OGhZ7uGU1tru8MEr4+lduLennpFbEKOq8j5r/uM+gJ/0
 sTkdXVCpqlrl1iz++TS2F3bOZG3hesQvNx0OjTLzo+AX+OhwZfgeUXjmfz6Q+1lkNSR/
 XH2Ejs88Q5eBp82WxJoJc2Hr7gdPxECPz3alRE3aBF4xsK4vg1GgAJdxSsqfrMcAFCWK 9Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9mcrr8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:48:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0aYKg032738;
        Thu, 31 Aug 2023 01:48:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6dqtxms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:48:59 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37V1mnKt000352;
        Thu, 31 Aug 2023 01:48:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3sr6dqtxfw-6;
        Thu, 31 Aug 2023 01:48:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, John Meneghini <jmeneghi@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kai.Makisara@kolumbus.fi, loberman@redhat.com, jhutz@cmu.edu
Subject: Re: (subset) [PATCH 1/2] scsi: tape: add third party poweron reset handling
Date:   Wed, 30 Aug 2023 21:48:33 -0400
Message-Id: <169344360113.1293881.4735441763326786302.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230822181413.1210647-1-jmeneghi@redhat.com>
References: <20230822181413.1210647-1-jmeneghi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_01,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=864 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308310014
X-Proofpoint-ORIG-GUID: V_nS_Eby_y3gIIE6oKS13J9-IhAtsTvC
X-Proofpoint-GUID: V_nS_Eby_y3gIIE6oKS13J9-IhAtsTvC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Aug 2023 14:14:12 -0400, John Meneghini wrote:

> Many tape devices will automatically rewind following a poweron/reset.
> This can result in data loss as other operations in the driver can write
> to the tape when the position is unknown. E.g. MTEOM can write a
> filemark at the beginning of the tape. This patch adds code to detect
> poweron/reset unit attentions and prevents the driver from writing to
> the tape when the position could be unknown.
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/2] scsi: tape: add third party poweron reset handling
      https://git.kernel.org/mkp/scsi/c/9604eea5bd3a

-- 
Martin K. Petersen	Oracle Linux Engineering
