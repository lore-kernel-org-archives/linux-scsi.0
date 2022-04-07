Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC12C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343693AbiDGNhq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343677AbiDGNhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8EC2181
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:30 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237BB7io006378
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=reVjCmtOIpw36bVfS1lmKQMQcrmPDKU5RFXExUmLjJ0=;
 b=H+d3CvwEWksEHJKYE1j35wVqVhxHO6dhWr7tyyC0k6MHdWO8jTlOgst09qjol0BMyTP5
 ZCDl1ihNyjmGwFXiglV6krFzSYwRgzMqQyRX/nTDOdkEqERFKXhmYUQE3bgKNMCN6Rv8
 nAY2OwvWhj8X0YoKUPUspKife3+dELv3XejRqYa55YOVHvL0ZCi9RLTYP3j401JWxuHT
 DbWwlNpFaSHuq0bxnIfzbULVM4c13i/FM7HAyct0k37JZj4DwrjSMOKbeRCjrpfnbHrM
 t0BQz+cb3DI8CNVUv1275+vFYmk6kLB3dPleEhxJtNABrIXpjCVrFYyOdQz8lkfVp5j4 2g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31m0t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVNG036916
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:28 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJM6032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:28 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-13;
        Thu, 07 Apr 2022 13:35:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] ufs: qcom: drop custom Android boot parameters
Date:   Thu,  7 Apr 2022 09:35:12 -0400
Message-Id: <164929679001.15424.778862771638266623.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220321151853.24138-1-krzk@kernel.org>
References: <20220321151853.24138-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: veQxKhNds4lMWmA0xWHu9KAyoKaLmzQS
X-Proofpoint-ORIG-GUID: veQxKhNds4lMWmA0xWHu9KAyoKaLmzQS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Mar 2022 16:18:53 +0100, Krzysztof Kozlowski wrote:

> The QCOM UFS driver requires an androidboot.bootdevice command line
> argument matching the UFS device name.  If the name is different, it
> refuses to probe.  This androidboot.bootdevice is provided by
> stock/vendor (from an Android-based device) bootloader.
> 
> This does not make sense from Linux point of view.  Driver should be
> able to boot regardless of bootloader.  Driver should not depend on some
> Android custom environment data.
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/1] ufs: qcom: drop custom Android boot parameters
      https://git.kernel.org/mkp/scsi/c/5ca0faf9c292

-- 
Martin K. Petersen	Oracle Linux Engineering
