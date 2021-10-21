Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A71C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEF93611CB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhJUDqJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:46:09 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55342 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231283AbhJUDp3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:29 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L2ffsi029728;
        Thu, 21 Oct 2021 03:43:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=s8EFWlNG4FT7Hf5BAo9DiZluvpxY/fDa24ig9OdhYq8=;
 b=tKGXq2zr9pj3zMOfnyDYFxMm/iwA5AeAGAjFp3SUow32Tla/RxrdCH5fKkyUFx3PT/5D
 CHs4z9Tp54JCFLg6yAWARh2YkDEOJEogm04jLibvbI/Z44ZfM7KiIKJtFwuxWzRLp4yg
 YxYpOlDGfxGufJ0c3souVWSOnCTKx6pVPBPc7TLIH6pP5gstnKqkSh8HkC0wzPQQGK1d
 J6Jmmcg+ppdMSPND36V4L82u1GosOiqNImjXtVaN5QvXwvsO2JjHVUminEqzIo6YRty3
 wUK6DeFgyb7vp6c5dNSJJdjV7c+1XHYFYIDefR7Jah+N4ZdB+35zAS+QYdrUr53alHu0 xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj3wvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3etvd078225;
        Thu, 21 Oct 2021 03:43:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:04 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu88082116;
        Thu, 21 Oct 2021 03:43:04 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-12;
        Thu, 21 Oct 2021 03:43:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, bvanassche@acm.org, dgilbert@interlog.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: print write through due to no caching mode page as warning
Date:   Wed, 20 Oct 2021 23:42:43 -0400
Message-Id: <163478764103.7011.16778626175296198522.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013075050.3870354-1-martin.kepplinger@puri.sm>
References: <20211013075050.3870354-1-martin.kepplinger@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: vBhmZBQcQgT4-9AQhxKKrE2D-MBuJRV2
X-Proofpoint-GUID: vBhmZBQcQgT4-9AQhxKKrE2D-MBuJRV2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Oct 2021 09:50:50 +0200, Martin Kepplinger wrote:

> For SD cardreaders it's extremely common not to find cache on disk.
> The following error messages are thus very common and don't point
> to a real error one could try to fix but rather describe how the disk
> works:
> 
> sd 0:0:0:0: [sda] No Caching mode page found
> sd 0:0:0:0: [sda] Assuming drive cache: write through
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: sd: print write through due to no caching mode page as warning
      https://git.kernel.org/mkp/scsi/c/c4da1205752d

-- 
Martin K. Petersen	Oracle Linux Engineering
