Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A35C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13E3D61AED
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhKSETw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:19:52 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8426 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229812AbhKSETw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:19:52 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2a3Nx019268;
        Fri, 19 Nov 2021 04:16:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=9NggQVwdIjN3vsXLW5blYXZFo8Q7T5oYufE6wjanflI=;
 b=q0uLNyxeNaP0514muw+oH2cwen8uffJjIr3hsTjlXv8Hejw6g/EyL/Zini5zdHCSFvw4
 NqXA5HmOTSlFkTdnuTV9AyCjbCaTfCfgG4zxR1DQ16T2pyjT5+pkscqGZa5WS0SiJevW
 9kUuYR5FJXOFo2LIPk3ZWfTrHKt7YkxO4x5FdZ8PEabjg+ht0ibdPYT3uxe58XofBk3d
 7BcP+Nsi59j8oJgr593Ceku7pc29FysG6GiHUOGnZHJJ10tmSy1S5oCIZRuXswo5cW0F
 qmCyn8H8wUear+42S8NTfuN4tEDbJhGJquhZLmEbkLgqe4OPjmFXtaOR/80lQwWDNJ8O tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd2w93kb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FBMm020341;
        Fri, 19 Nov 2021 04:16:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7c0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:48 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4GiwN024731;
        Fri, 19 Nov 2021 04:16:48 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-5;
        Fri, 19 Nov 2021 04:16:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH] target/configfs: delete unnecessary checks for NULL
Date:   Thu, 18 Nov 2021 23:16:34 -0500
Message-Id: <163729506338.21244.1697148412821112593.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211118084900.GA24550@kili>
References: <20211118084900.GA24550@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 2xHiodOVnZ3Oct1bQtMqDqgKiPHL_uNC
X-Proofpoint-ORIG-GUID: 2xHiodOVnZ3Oct1bQtMqDqgKiPHL_uNC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Nov 2021 11:49:00 +0300, Dan Carpenter wrote:

> The "item" pointer is always going to be valid pointer and does not
> need to be checked.
> 
> But if "item" were NULL then item_to_lun() would not return a NULL, but
> instead, the container_of() pointer math would return a value in the
> error pointer range.  This confuses static checkers since it looks like
> a NULL vs IS_ERR() bug.
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] target/configfs: delete unnecessary checks for NULL
      https://git.kernel.org/mkp/scsi/c/9c6603e1faf8

-- 
Martin K. Petersen	Oracle Linux Engineering
