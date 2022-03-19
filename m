Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC6EC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Mar 2022 03:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242064AbiCSD65 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 23:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242015AbiCSD6s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 23:58:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A0710BBFE;
        Fri, 18 Mar 2022 20:57:27 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22J2t7Kc014720;
        Sat, 19 Mar 2022 03:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=ENMKUrHCZOudvRHtAehTfcBN0mWzmRD42cEDUwxZdLg=;
 b=kdxZab/XQ2yhdFvwYR3e3g78cDh9jCTGOKJx2PXIZFnsQTB0onjwmRN2e5bbyywKD7wr
 /adTQzJi3/QI4XABQYkWlB+FXZewiaWRVRksqRfYzpSVOgQcsBdqaLKlmrVaZtwRBzBX
 NDY3w8UPpJRwxJpYfwGkIQuvt9nob7NS3DkJGtnbTmiO3Z6vYJVo/IDx+BvEXodqBOhu
 0KIgoiIrigFLFHPJKHEGFxrmUpnOOG+9eJ4WF9p47CNI2a66v4jAq5tzIHRzUPDdSBMN
 wdKzoh+8nOcDK7zfLVHvI/XKwfDRbFEwZunIhf29d5nx6D1ACu1f+w9O1DmVLtbDsNv/ vw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss0176-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22J3vKAV007347;
        Sat, 19 Mar 2022 03:57:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:20 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22J3v5R0007126;
        Sat, 19 Mar 2022 03:57:19 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshmn-12;
        Sat, 19 Mar 2022 03:57:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Yang Li <yang.lee@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] scsi: Remove ignoring unreachable code warning
Date:   Fri, 18 Mar 2022 23:57:02 -0400
Message-Id: <164766213031.31329.18166732732178921996.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220301080448.112813-1-yang.lee@linux.alibaba.com>
References: <20220301080448.112813-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: wYmM5p4msxaHkJOR8g4Tj3ruIKrHTtOM
X-Proofpoint-GUID: wYmM5p4msxaHkJOR8g4Tj3ruIKrHTtOM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 1 Mar 2022 16:04:48 +0800, Yang Li wrote:

> The smatch tool reported the following warning:
> drivers/scsi/scsi_error.c:1988 scsi_decide_disposition() warn: ignoring
> unreachable code.
> 
> Remove the "default:return FAILED;" instead of "return FAILED;" reported
> by smatch, because compilers can provide more useful diagnostics about
> switch/case statements that do not have a default statement, especially
> if the "switch" applies to a value with enumeration type.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] scsi: Remove ignoring unreachable code warning
      https://git.kernel.org/mkp/scsi/c/e1b353e7a31d

-- 
Martin K. Petersen	Oracle Linux Engineering
