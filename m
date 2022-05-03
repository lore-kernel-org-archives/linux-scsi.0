Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF1F0C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 23:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244227AbiECX0L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 19:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbiECX0K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 19:26:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CDA2B183;
        Tue,  3 May 2022 16:22:37 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242Kw9JP004338;
        Tue, 3 May 2022 00:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=67vHh+9Az8hZpxHAY/BM8W9RVLA1/ucOi1HkxzLhVCU=;
 b=qMhkNMilbwY5PFLuDhq90RhXvv6VkCZvYp9itxvtVnboYLrAZfPwn/czFi2EwupweCVJ
 c6u8sgSkz8vyigR/wdTMe6vlvIGuNR0ElPxdUBSGwTg3pBMGYYfudTnpmdQMjEbWY/rB
 19llN+A751B4P7t9yp2fKfd0DctKp8OzwAKbfjo+pXpiyLVGLs24A6UdVlIjB2yc6Ecx
 lTuP2xjvqsoDj7foZyUm+9H0EggvxtCZc1ziFkEMrOJgrFrpSFRR3fn9a+8DUa93erWF
 +Hnlqu+I7UORWoWxcIsiJpbVUGJtyVfsgdJbEXDkFBNINYrSGCbS2CjTHMWu++2Wifjk bg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruq0cp5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430opCX008935;
        Tue, 3 May 2022 00:51:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:59 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430pljc010389;
        Tue, 3 May 2022 00:51:58 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-21;
        Tue, 03 May 2022 00:51:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Lee Duncan <lduncan@suse.com>,
        Mike Christie <michael.christie@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        open-iscsi@googlegroups.com, kernel-janitors@vger.kernel.org,
        Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: iscsi: fix harmless double shift bug
Date:   Mon,  2 May 2022 20:51:31 -0400
Message-Id: <165153836358.24053.4874594014985340234.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <YmFyWHf8nrrx+SHa@kili>
References: <YmFyWHf8nrrx+SHa@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: nkmbSd8g0PsL4igKT8S8RWQY_Emg_LFC
X-Proofpoint-GUID: nkmbSd8g0PsL4igKT8S8RWQY_Emg_LFC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 21 Apr 2022 18:03:52 +0300, Dan Carpenter wrote:

> These flags are supposed to be bit numbers.  Right now they cause a
> double shift bug where we use BIT(BIT(2)) instead of BIT(2).
> Fortunately, the bit numbers are small and it's done consistently so it
> does not cause an issue at run time.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: iscsi: fix harmless double shift bug
      https://git.kernel.org/mkp/scsi/c/565138ac5f8a

-- 
Martin K. Petersen	Oracle Linux Engineering
