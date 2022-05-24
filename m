Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3146FC43217
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 18:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240248AbiEXSMD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 14:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240205AbiEXSL4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 14:11:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6472E5DD11
        for <linux-scsi@vger.kernel.org>; Tue, 24 May 2022 11:11:55 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHnrWG022454;
        Tue, 24 May 2022 18:11:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=er/fT+hHbVLthAaXQ4lglw/eYas750EEF7PZIjjVkSg=;
 b=THufrsct6muwiCqGLNE0zXuqOiCTb9EQXld645cwQM5e8SBYh5kGcP/kgWPS0BmQUI3n
 eih3Qo6x+z5CVvZNsfwZ/+i89ObPzXLmgW+bhkA/wSGCjoQ+6X1nBDI9gII1IdghDqL0
 o/PlWr+HVU4SXgLnwSj82o8Xt2sUZg/2gi0iWf0pFiPYnbE1OYLYtR1eO+AjOGEJfE6q
 I6CdETL/PVjJkyHmCLhkdXvAhPwNCl08jzrh1LkC8tO8h2s0dV7ZaxTEJD7pm0HjJspK
 lG4G1pcQWb6EnCUnsalH/3cC5uJQpLCPZHB5em0BbfNhZ1SXhxNbUMXrSRoU5HuHTeS3 6w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tar3fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:11:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OHoI9I016378;
        Tue, 24 May 2022 18:11:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x50s4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:11:45 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24OIAvn0039045;
        Tue, 24 May 2022 18:11:45 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x50s3r-4;
        Tue, 24 May 2022 18:11:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, haowenchao@huawei.com
Subject: Re: [PATCH] sd: don't call blk_cleanup_disk in sd_probe
Date:   Tue, 24 May 2022 14:11:36 -0400
Message-Id: <165341587530.22286.3131420282323524417.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220523083813.227935-1-hch@lst.de>
References: <20220523083813.227935-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: FwK9JeSirJgwL79dmib61CCClCUy8_3n
X-Proofpoint-ORIG-GUID: FwK9JeSirJgwL79dmib61CCClCUy8_3n
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 23 May 2022 10:38:13 +0200, Christoph Hellwig wrote:

> In SCSI the midlayer has ownership of the request_queue, so on probe
> failure we must only put the gendisk, but leave the request_queue alone.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] sd: don't call blk_cleanup_disk in sd_probe
      https://git.kernel.org/mkp/scsi/c/7274ce0558ad

-- 
Martin K. Petersen	Oracle Linux Engineering
