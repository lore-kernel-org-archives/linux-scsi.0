Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0053EC41513
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 02:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjGZCIZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 22:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGZCIY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 22:08:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB152125;
        Tue, 25 Jul 2023 19:08:23 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJIswi025954;
        Wed, 26 Jul 2023 02:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=2CJ8AK5c/kLmtgDFpkjRPa1wxeTnQU5YdOMnAoaW5Iw=;
 b=lUMdW8/DgzBXCUuuf53dBGGzeolKYPhUDgLPb+9ppdYepjwU/ZJVDBxw5Ze64gA2nwfT
 E0tMkgOLkp2oK9iihy495vNnVNhEzahTzm2AFS+marHRcEne4l6NTts+rACHqoKJUK7t
 2bmTRv9PsxIsBMc63zktLMgwsvy47Po2VmfZVa50JGyajQej2WqBzcRf6SITNMOtl7fi
 88cakHVIOIVTYTq804Ya+BthXpNPQ8bZWVSEd0UfkzQY7tXR7Nq5GUl7Df/9dkeuErfH
 ti/mtX2tuoRl46eLkeMlsSVtZUdx3cfV1id1cVA1ewRS144pP72rvOuGhR1HVME212OB Ng== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s075d6ftq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:03:30 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PNt8Oc029422;
        Wed, 26 Jul 2023 02:03:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5jrn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:03:29 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36Q23SLq003192;
        Wed, 26 Jul 2023 02:03:28 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s05j5jrfj-1;
        Wed, 26 Jul 2023 02:03:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH] zfcp: defer fc_rport blocking until after ADISC response
Date:   Tue, 25 Jul 2023 22:03:06 -0400
Message-Id: <169033697463.2256225.1716697055296797756.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230724145156.3920244-1-maier@linux.ibm.com>
References: <20230724145156.3920244-1-maier@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=780 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260016
X-Proofpoint-ORIG-GUID: BBSAzn2WrzbYGXlKZJoMgsNtSOT4IiX_
X-Proofpoint-GUID: BBSAzn2WrzbYGXlKZJoMgsNtSOT4IiX_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 24 Jul 2023 16:51:56 +0200, Steffen Maier wrote:

> Storages are free to send RSCNs, e.g. for internal state changes. If this
> happens on all connected paths, zfcp risks temporarily losing all paths at
> the same time. This has strong requirements on multipath configuration such
> as "no_path_retry queue".
> 
> Avoid such situations by deferring fc_rport blocking until after the ADISC
> response, when any actual state change of the remote port became clear.
> The already existing port recovery triggers explicitly block the fc_rport.
> The triggers are: on ADISC reject or timeout (typical cable pull case), and
> on ADISC indicating that the remote port has changed its WWPN or
> the port is meanwhile no longer open.
> 
> [...]

Applied to 6.5/scsi-fixes, thanks!

[1/1] zfcp: defer fc_rport blocking until after ADISC response
      https://git.kernel.org/mkp/scsi/c/e65851989001

-- 
Martin K. Petersen	Oracle Linux Engineering
