Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9767C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 04:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiCIEPW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 23:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiCIEPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 23:15:19 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E7E3B3F9;
        Tue,  8 Mar 2022 20:14:17 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228M9Opt010816;
        Wed, 9 Mar 2022 04:14:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=Ee8V5JTFr5ipyfP0/LnKk12lN6jSMRmDSRlUrIwmcaQ=;
 b=SrbdUig5uK8FtXQUYYiFMdU7+OCF66U6vZL/3TtZFBpXZZJITjOl+dKhKCKxUcSkknfg
 AM7P2hVCkBffep31MZmXUFCBBm69LBMcQB9kGxK/6zFhp9lcrYi+GUTar5FEzxRGIDEs
 QMtKomqa4aUI1Z+axQiqYvSv/3Zxm5e4fKY6nsLVz3H+Fm3vfFWqOoJj0kBZxoLXjpYb
 RGSbDI1mU5crqW9YVe4xQR3gz3jEXxSFuW+32DWBDV+C7YQXU8z26N+r644t/6EHMBIW
 26vn/ZgF93FjAZzXcWEoVAbD96AmFoov2zYg64+g8KoiclHNcjKkeyj4G8vfZiBGg3TX Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyrarhvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 04:14:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22947CNu166749;
        Wed, 9 Mar 2022 04:14:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3ekyp2qdeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 04:14:14 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2294EAeN174884;
        Wed, 9 Mar 2022 04:14:13 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3ekyp2qddd-5;
        Wed, 09 Mar 2022 04:14:13 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Zheyu Ma <zheyuma97@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: wd719x: Return proper error code when dma_set_mask() fails
Date:   Tue,  8 Mar 2022 23:14:09 -0500
Message-Id: <164679903743.29335.13151374172045636513.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1646060055-11361-1-git-send-email-zheyuma97@gmail.com>
References: <1646060055-11361-1-git-send-email-zheyuma97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 9IvUjNjLmE3ra5bt1neXgimORnAUbO6Z
X-Proofpoint-ORIG-GUID: 9IvUjNjLmE3ra5bt1neXgimORnAUbO6Z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 28 Feb 2022 14:54:15 +0000, Zheyu Ma wrote:

> During the process of driver probing, the probe function should return < 0
> for failure, otherwise, the kernel will treat value >= 0 as success.
> 
> 

Applied to 5.18/scsi-queue, thanks!

[1/1] scsi: wd719x: Return proper error code when dma_set_mask() fails
      https://git.kernel.org/mkp/scsi/c/98cdcd6c6b4a

-- 
Martin K. Petersen	Oracle Linux Engineering
