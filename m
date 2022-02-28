Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37FA0C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 03:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbiB1DoU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 22:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbiB1DoR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 22:44:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66913A1A4;
        Sun, 27 Feb 2022 19:43:39 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21RN6iMX030439;
        Mon, 28 Feb 2022 03:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=cGeTb2RuP2oaCX6gUNMtqAjcd1HT1sSNAQ3gzIXHkjM=;
 b=oW0+ymhrKEa9jL5RBdE6KXkg8zDE4Ql71nTbfC2aFQ+h3ENFDs3JxHEHgoz9pLuZ/WtQ
 TcnX1lmQYEocsN/eRsfxDDlpFi6Q5nHXiroVS3pUjMm46iET3vR/5AjZEdENCKFJ9PkJ
 x4a6WFvt+TnRuJke86fFoMBtonKYoznI64/8va2/7qG09XpxAd8qXPvqW6Qg/JnnqvZd
 vh/gj+nKIxrNg5ipDub9aSahZFw8MG3MmlzzfHX81qqBRXl9oDNuPFJMwrmlkD4XJ6xm
 0dqWuA4DlnmjwgncCs27uTp90LuLAfw2dzhGJXgboV7XufHwRwnLGzVW4qFUi/sHoDEH wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efamcb0p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:43:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S3b93E157706;
        Mon, 28 Feb 2022 03:43:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3efa8bxnug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 03:43:29 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21S3hPvs165853;
        Mon, 28 Feb 2022 03:43:29 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3efa8bxnt3-5;
        Mon, 28 Feb 2022 03:43:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        target-devel@vger.kernel.org, manoj@linux.ibm.com,
        Christoph Hellwig <hch@lst.de>, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, axboe@kernel.dk, philipp.reisner@linbit.com,
        lars.ellenberg@linbit.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com
Subject: Re: remove REQ_OP_WRITE_SAME v2
Date:   Sun, 27 Feb 2022 22:43:19 -0500
Message-Id: <164601967778.4503.10049578815707749914.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220209082828.2629273-1-hch@lst.de>
References: <20220209082828.2629273-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Hzm0aRNfu-eOe-59CsGUww_0uF29UVaY
X-Proofpoint-GUID: Hzm0aRNfu-eOe-59CsGUww_0uF29UVaY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 9 Feb 2022 09:28:21 +0100, Christoph Hellwig wrote:

> Now that we are using REQ_OP_WRITE_ZEROES for all zeroing needs in the
> kernel there is very little use left for REQ_OP_WRITE_SAME.  We only
> have two callers left, and both just export optional protocol features
> to remote systems: DRBD and the target code.
> 
> For the target code the only real use case was zeroing offload, which
> is kept with this series, and for DRBD I suspect the same based on the
> usage.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/7] cxlflash: query write_zeroes limit for zeroing
      https://git.kernel.org/mkp/scsi/c/898cd34607eb
[2/7] drbd: drop REQ_OP_WRITE_SAME support
      https://git.kernel.org/mkp/scsi/c/a34592ff6b78
[3/7] rnbd: drop WRITE_SAME support
      https://git.kernel.org/mkp/scsi/c/ebd04737637b
[4/7] sd: remove write same support
      https://git.kernel.org/mkp/scsi/c/e383e16e84e9
[5/7] md: drop WRITE_SAME support
      https://git.kernel.org/mkp/scsi/c/10fa225c33a9
[6/7] dm: remove write same support
      https://git.kernel.org/mkp/scsi/c/a773187e37fa
[7/7] block: remove REQ_OP_WRITE_SAME support
      https://git.kernel.org/mkp/scsi/c/73bd66d9c834

-- 
Martin K. Petersen	Oracle Linux Engineering
