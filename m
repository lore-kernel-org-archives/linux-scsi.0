Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10AF4C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 11:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391274AbiEFLSE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 07:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391350AbiEFLRj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 07:17:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3881168F8E;
        Fri,  6 May 2022 04:13:56 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242M53jo024988;
        Tue, 3 May 2022 00:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=HHb1zVF2Dw+udU2Ov7LmUB+S58UiMaN2JW9wFG/2hGs=;
 b=k3avzyHbk6W5wmLmUkv4xRqTqjoawpultus8cOKAOWzgUh2QbQ0QrkRLDNnQYi4DC7j8
 tRrPFxfKZi/eQ+/VZqoKI8lb2C8L+J2cyJXAJl/jO42PARSOXb16rPAf/kzHuSFUTok5
 n8LrG9cbpENYuo8u6AHeqejOKCKWT/NJSrABfcJ61xxxAom08hYPTST9r3v8uVhYUABr
 i/9U+wmPDWUh9yGXQm1lJpl8e6o7J9EGkWJslPTOGBvYcbSSad+umj/8WP79U9o14swx
 sCGepDIuh/y5zhki7IDRHJtrnDqa3QD6Q2RALcKqXMTLSTXYaZ0NRTTMI3X1lmG/P52Z Fw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruw2cnx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430op5u008954;
        Tue, 3 May 2022 00:51:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:51 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430pljA010389;
        Tue, 3 May 2022 00:51:50 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-7;
        Tue, 03 May 2022 00:51:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Haowen Bai <baihaowen@meizu.com>,
        Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qedf: Remove useless code
Date:   Mon,  2 May 2022 20:51:17 -0400
Message-Id: <165153836361.24053.2275168348426586735.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <1650536693-13089-1-git-send-email-baihaowen@meizu.com>
References: <1650536693-13089-1-git-send-email-baihaowen@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 6RnAQrQAd4I-QJd0-E4krpV8N5wI7tDj
X-Proofpoint-ORIG-GUID: 6RnAQrQAd4I-QJd0-E4krpV8N5wI7tDj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 21 Apr 2022 18:24:53 +0800, Haowen Bai wrote:

> buf msg only memset but no use at all, so we drop it.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: qedf: Remove useless code
      https://git.kernel.org/mkp/scsi/c/21faafff6abb

-- 
Martin K. Petersen	Oracle Linux Engineering
