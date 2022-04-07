Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C48C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343669AbiDGNhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343690AbiDGNhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D0E2705
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:32 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237BVlOp000752
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=mscIg5fOmWOQ3DRyZVqQffVBdYazqq7dOIR+LBXMZIg=;
 b=FsN+ySu3IoFoKLgTKI3zVcnUpW8gdYRyghUAi85ZHCXte4x71spKhTe2JqyxRqwsdV9K
 helB8C011IRQe37KdMrQ1wFU0Jli5tlCZqXudAbgZpDIFniBb0hyhEhE02L9Cr80si1i
 LidpePt3qRj729u1HOCxkpk16W6MOk3SyrArshslYmEkEkTrof4VKTgtT7hlazXpg7ML
 Nm1kIj62ezllGIHALR2iirkLnfAhl75kINQ5LQI9CGOfXwXAV5pvyypgZNNMA5c4wWuD
 yhb+L6DSXJjcZ6l/n0AT7u7+j6x+HqFexFrCx4DYipAf7O/0PzUUnQD+BuPru/3PU7we XQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3suw2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:31 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVwe036871
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:30 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJMA032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:29 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-15;
        Thu, 07 Apr 2022 13:35:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/9] treewide: eliminate anonymous module_init & module_exit
Date:   Thu,  7 Apr 2022 09:35:14 -0400
Message-Id: <164929679000.15424.2539097595919131160.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220316192010.19001-1-rdunlap@infradead.org>
References: <20220316192010.19001-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: dKu_KGXN49-vQpYiIvbrW4PJ_yVIlJPf
X-Proofpoint-GUID: dKu_KGXN49-vQpYiIvbrW4PJ_yVIlJPf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 16 Mar 2022 12:20:01 -0700, Randy Dunlap wrote:

> There are a number of drivers that use "module_init(init)" and
> "module_exit(exit)", which are anonymous names and can lead to
> confusion or ambiguity when reading System.map, crashes/oops/bugs,
> or an initcall_debug log.
> 
> Give each of these init and exit functions unique driver-specific
> names to eliminate the anonymous names.
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[5/9] virtio-scsi: eliminate anonymous module_init & module_exit
      https://git.kernel.org/mkp/scsi/c/41b8c2a31472

-- 
Martin K. Petersen	Oracle Linux Engineering
