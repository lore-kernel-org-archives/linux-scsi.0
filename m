Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCEEC43334
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 02:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379732AbiFQCVy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379338AbiFQCVv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 22:21:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E64264D09;
        Thu, 16 Jun 2022 19:21:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25H0a6rS032735;
        Fri, 17 Jun 2022 02:21:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=XzuU00wEn/oMcU0IoMH4V8VEADCDpYRgPmSpYj2eHtI=;
 b=XrAuw/vBYkygOjD1WdltaYPhmoZerGOUZlKHN6O0QV+ldk1brobXjnUfcD+v2QdpgMt8
 I7hSKJ4epYtV3L27kSUOAyazPf6dGBwYkuOrkJt4eoOCAz4dpCfqsH99EDpKmpWM5/Qn
 kDg1ljMFcA/peVYaYM7QDna8KUst7njNxvvhfHAZ1vlYMFkSNkjNI7uDgFZXMxMeujJY
 0qEiYAkqs8hCH2vyLO9VJ2UNrE4yPalvJQ78wBCDI3XhaudzKVb2UrsiidcEs+WmP47t
 1cuZQQBJws5FMvnMZ7kJZv/5ZfX2IUnjlw/rmb6fdTliZjw2MIrtiYpIkXeP4XFaXXia lg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2vv27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 02:21:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25H2G77W029132;
        Fri, 17 Jun 2022 02:21:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr27jd87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 02:21:42 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25H2LejH040352;
        Fri, 17 Jun 2022 02:21:41 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr27jd7c-2;
        Fri, 17 Jun 2022 02:21:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: exynos: constify driver data
Date:   Thu, 16 Jun 2022 22:21:35 -0400
Message-Id: <165543243410.26207.14002828862319128042.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220613101429.114449-1-krzysztof.kozlowski@linaro.org>
References: <20220613101429.114449-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Yz-RNPi0yq4Pa-Huz1TWZeZ56gDSs2-8
X-Proofpoint-ORIG-GUID: Yz-RNPi0yq4Pa-Huz1TWZeZ56gDSs2-8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Jun 2022 12:14:29 +0200, Krzysztof Kozlowski wrote:

> Constify the drv data because it should not be modified (used by
> multiple devices).
> 
> 

Applied to 5.20/scsi-queue, thanks!

[1/1] scsi: ufs: exynos: constify driver data
      https://git.kernel.org/mkp/scsi/c/dcad25cb2500

-- 
Martin K. Petersen	Oracle Linux Engineering
