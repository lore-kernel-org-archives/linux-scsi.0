Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE69C32771
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 03:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiIPDCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 23:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiIPDCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 23:02:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD3A9D8C9
        for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2022 20:02:03 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28G1wxCE029399;
        Fri, 16 Sep 2022 03:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=gguWgL0/iVs2DLlr1uJfcIILp0TQVUzWqoof59hAVF0=;
 b=KczlQKbX0ICC0f9n+mNo8PS0hAtZ/wqP1DOVitshgr/HfO85/iaON4YgyNNl8LmkkQ9W
 SdnBZ8qd7kpjPkDtAMnYlyvwq7gkrTTA5IJAjfyVtshLJXsseKe7bElJCB3eHJ9554GN
 vMJx86vb4n+s0bLkPwdqL4ZGsWGWSF2exMgDvItAM0EgqHZl41lSpQKo5CZ+JEuJ6lh5
 DFtCKCn31zmF6UVKr/KjhPwNoapJk+MREyEt34J/nTW7qVS20qxvsv5nyUOphsdA2Yg1
 IIDpnEk/IRwpi5L2yAwxdfrLNJGMIm5fcloioJ61ztZKd/4dK1pATCOXuT6LE72Nqth9 Lw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jm8xc9783-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 03:02:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28G0SoTu016059;
        Fri, 16 Sep 2022 03:02:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jm8x8pjxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 03:02:01 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28G31xOc014516;
        Fri, 16 Sep 2022 03:02:01 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3jm8x8pjv1-3;
        Fri, 16 Sep 2022 03:02:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/1] mpt3sas: Fix return value check of dma_get_required_mask
Date:   Thu, 15 Sep 2022 23:01:57 -0400
Message-Id: <166329729478.12731.9168707240620600112.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220913120538.18759-1-sreekanth.reddy@broadcom.com>
References: <20220913120538.18759-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209160020
X-Proofpoint-ORIG-GUID: IW4TEAolK456HJhzIs9xu9R4cmU2NYyD
X-Proofpoint-GUID: IW4TEAolK456HJhzIs9xu9R4cmU2NYyD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 13 Sep 2022 17:35:37 +0530, Sreekanth Reddy wrote:

> Fix the incorrect return value check of dma_get_required_mask().
> Due to this incorrect check, the driver was always setting the
> dma mask to 63 bit.
> 
> Sreekanth Reddy (1):
>   mpt3sas: Fix return value check of dma_get_required_mask
> 
> [...]

Applied to 6.0/scsi-fixes, thanks!

[1/1] mpt3sas: Fix return value check of dma_get_required_mask
      https://git.kernel.org/mkp/scsi/c/e0e0747de0ea

-- 
Martin K. Petersen	Oracle Linux Engineering
