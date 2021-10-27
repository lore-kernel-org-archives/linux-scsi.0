Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD49C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 04:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 977A3610A0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 04:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhJ0EDA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 00:03:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38968 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhJ0EC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 00:02:58 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R0mt5N018073;
        Wed, 27 Oct 2021 04:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=0zN70XnDR4xSrlm2vCblgUMMsm6a+fNIpMHrHh5OWd8=;
 b=QPDlnaXxlneCFxDoWKZ6ve3MExTmgHT42nYIIs9agRcLseNCs6UU0PyBShLbuC4eMzSV
 +ECReDqRJ37zrETTJ2fX26XYOV2RoRiC69apbLO1VNajlJniXGGGOVQEcDzrOSmJUp7Q
 Iv5x54nKwVM67mtONlTnfDI/jtCVerM30M/7PJfbE90hJ1QhPWsQ5zN3oyZmMD2/M4qa
 C2XZ4vYNlt3Wv4L4gEXlNezS58MFPxxZHKdmpEhnoOPGj+3F0vWd31f7wwx5eK8Qy9JN
 cO0M8MyiHby0Em/UjuDM25KNYya1OYnpsKl5E8H2LTfEj1PXVHekvCguy9XNYES+dIt7 PQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4g17hc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 04:00:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19R3xvP6068675;
        Wed, 27 Oct 2021 04:00:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3bx4gqcnb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 04:00:27 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19R40O5I070915;
        Wed, 27 Oct 2021 04:00:27 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3bx4gqcn88-4;
        Wed, 27 Oct 2021 04:00:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        avri.altman@wdc.com, jejb@linux.ibm.com, alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sthumma@codeaurora.org, linux-kernel@vger.kernel.org,
        draviv@codeaurora.org, linux-scsi@vger.kernel.org,
        bjorn.andersson@linaro.org
Subject: Re: [PATCH] scsi: ufs: ufshcd-pltfrm: fix memory leak due to probe defer
Date:   Wed, 27 Oct 2021 00:00:22 -0400
Message-Id: <163530706458.10775.11084247794290021262.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210914092214.6468-1-srinivas.kandagatla@linaro.org>
References: <20210914092214.6468-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: lKgz3QUk1KiXLUhmQVxsos7MrjTKakfO
X-Proofpoint-GUID: lKgz3QUk1KiXLUhmQVxsos7MrjTKakfO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Sep 2021 10:22:14 +0100, Srinivas Kandagatla wrote:

> UFS drivers that probe defer will endup leaking memory allocated for
> clk and regulator names via kstrdup because the structure that is
> holding this memory is allocated via devm_* variants which will be
> freed during probe defer but the names are never freed.
> 
> Use same devm_* variant of kstrdup to free the memory allocated to
> name when driver probe defers.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: ufs: ufshcd-pltfrm: fix memory leak due to probe defer
      https://git.kernel.org/mkp/scsi/c/b6ca770ae7f2

-- 
Martin K. Petersen	Oracle Linux Engineering
