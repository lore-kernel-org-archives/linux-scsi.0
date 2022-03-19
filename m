Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1919DC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Mar 2022 03:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiCSEBO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 00:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242059AbiCSEAv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 00:00:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185726AA65
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2022 20:59:32 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22J3BdZT000630;
        Sat, 19 Mar 2022 03:59:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=jabwnHNVOyTWdI7HmiDhZxlWjnFjGlZB7NdF9g+J7l0=;
 b=mhXeKvrATzs4UF81RxxqCSyuPyTL+PiJqU5Sawe8YNel0vkrLOQVN4Tc/OE5i9RPSBIA
 KYa3/MMpcLMr8M2oCpp2sUQ3wzBNAVIjCnA/srrH/D5E1koGJbXXOnm76YJbtM1+kBuG
 tmaqX2evIkatsT38AcUDDQp4f+Dzbn4pthfobSUBIWyDRq7LuJySk3sYRGRgRco7Q6no
 +1dzwc4n9DxfwgvrhuRt+u1p/1mBKd3vogXi0VnJUgOTwehclaC5gfxhLJCitiMJ7Tfs
 0xBAn5niopA3OKhZSmojqz0lZ4gsLRKL41E7UTisfoiHJQoI3sKGHMfdGyLDRTG289s3 zQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew72a8168-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:59:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22J3ufSb006991;
        Sat, 19 Mar 2022 03:57:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:10 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22J3v5Qk007126;
        Sat, 19 Mar 2022 03:57:09 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshmn-5;
        Sat, 19 Mar 2022 03:57:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH] lpfc: Remove failing soft_wwn support
Date:   Fri, 18 Mar 2022 23:56:55 -0400
Message-Id: <164766213029.31329.2257707690841174483.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220310154845.11125-1-jsmart2021@gmail.com>
References: <20220310154845.11125-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: HJUKagEJXdkddGbUjSxaVU9XBCNESfVb
X-Proofpoint-ORIG-GUID: HJUKagEJXdkddGbUjSxaVU9XBCNESfVb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 10 Mar 2022 07:48:45 -0800, James Smart wrote:

> The soft_wwpn/soft_wwn functionality, which allows the driver to modify
> service parameters in an attempt to override the adapter-assigned WWN,
> was originally attempted to be removed roughly 6 yrs ago as new fabric
> features were being introduced that clashed with the implementation.
> In the end, the feature was left in with the user being responsible if
> things went south.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] lpfc: Remove failing soft_wwn support
      https://git.kernel.org/mkp/scsi/c/2ea3a393bfae

-- 
Martin K. Petersen	Oracle Linux Engineering
