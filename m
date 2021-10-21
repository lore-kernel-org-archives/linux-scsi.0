Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 205F9C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 051C061186
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhJUDm7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:42:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37370 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231378AbhJUDms (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:42:48 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L1PdI5020879;
        Thu, 21 Oct 2021 03:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=CzkR8azGvsNKNaGoumA0wTwBAEpNzSC1uNRPsZ/Le6g=;
 b=OUvCTCHd4/5BR89oWiEN7brBM8OQC5yuid7uORVbKMvCzh2gcrlMvdjYi8cAr26074Bs
 2uK9B6ibVaGVecqWHX/GQRopnkLT+d4gFZF6/4QfispkaXT9OaMgrICznwWrB0ZA2KjY
 LNuR8wGXSGn1kw9Mjv3g33Ys/EFTDyBJs0rEB5o2Sbre7WtLo/f658KAroKcm9f04eeH
 dDR6kgMNGitFOSf0B7PkrlNfdzTy/UCTW2SSZPGssWWNZLDKMejWhe8BUzrsX33gkHUT
 h5gXIDpiRcE+epVUAH0vmFc4WOPlohzUBgvko+c8r1IrOtq/zLL9i7xSRTj1GyuP2DVK NQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9v8ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:40:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3Lb3G083822;
        Thu, 21 Oct 2021 03:40:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3br8gv83mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:40:21 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3eJZB135272;
        Thu, 21 Oct 2021 03:40:21 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3br8gv83k1-2;
        Thu, 21 Oct 2021 03:40:20 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH] scsi: ufs: ufs-exynos: correct timeout value setting registers
Date:   Wed, 20 Oct 2021 23:40:18 -0400
Message-Id: <163478760939.6923.10515267994162668841.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018062841.18226-1-chanho61.park@samsung.com>
References: <CGME20211018063117epcas2p28bfc50a5d793abadf37291942e139448@epcas2p2.samsung.com> <20211018062841.18226-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Oms91wQnADQJI_GDVLIMUvL-Q9Vk2oD7
X-Proofpoint-GUID: Oms91wQnADQJI_GDVLIMUvL-Q9Vk2oD7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Oct 2021 15:28:41 +0900, Chanho Park wrote:

> PA_PWRMODEUSERDATA0 -> DL_FC0PROTTIMEOUTVAL
> PA_PWRMODEUSERDATA1 -> DL_TC0REPLAYTIMEOUTVAL
> PA_PWRMODEUSERDATA2 -> DL_AFC0REQTIMEOUTVAL
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: ufs: ufs-exynos: correct timeout value setting registers
      https://git.kernel.org/mkp/scsi/c/282da7cef078

-- 
Martin K. Petersen	Oracle Linux Engineering
