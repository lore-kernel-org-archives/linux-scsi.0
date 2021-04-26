Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E5DC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AB71611ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhDZDR5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:17:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43279 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZDR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:17:57 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210426031714epoutp0346945f72f996af2e329367e8afc11d51~5Sh4Zfe9R2641826418epoutp03t
        for <linux-scsi@vger.kernel.org>; Mon, 26 Apr 2021 03:17:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210426031714epoutp0346945f72f996af2e329367e8afc11d51~5Sh4Zfe9R2641826418epoutp03t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619407034;
        bh=jetcUXmyBIvfGxke4lcV/g8Ksv9OTamwlbKq7aTUCGk=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=smj0KJNcglSlCFETHIHw/7hKtIVS4kEXt1ekna5t0K1o/0MExK1xcq5D6kyrMyJWj
         gisTKe/VtRlux45mvGAk+FVftFrqtoorZNw+BfVJS/wYNIRsQ0ZoYFnKBJtkKolQLT
         E5eDi7axN2kyAQ4C9jVPhfnd7lyj0AZvRePFIpjk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210426031713epcas2p25c9798e3d2dbcdbcb95c84e2de4dce05~5Sh3zpnbC2133921339epcas2p2F;
        Mon, 26 Apr 2021 03:17:13 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.184]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4FT96w3Fhgz4x9Pp; Mon, 26 Apr
        2021 03:17:12 +0000 (GMT)
X-AuditID: b6c32a46-e01ff700000025de-ac-608630b804b1
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        45.57.09694.8B036806; Mon, 26 Apr 2021 12:17:12 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH v1 2/3] scsi: ufs: Cancel rpm_dev_flush_recheck_work
 during system suspend
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "ziqichen@codeaurora.org" <ziqichen@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        open list <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <1619403878-28330-3-git-send-email-cang@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210426031711epcms2p2b64c07ab98332429204dac7ba920abf2@epcms2p2>
Date:   Mon, 26 Apr 2021 12:17:11 +0900
X-CMS-MailID: 20210426031711epcms2p2b64c07ab98332429204dac7ba920abf2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMJsWRmVeSWpSXmKPExsWy7bCmhe4Og7YEg55zQhYP5m1js9jbdoLd
        4uXPq2wWBx92slh8Wr+M1eLarflsFi8PaVqsehBucfrZO3aLJ+tnMVssurGNyWLHdhGLy7vm
        sFl0X9/BZrH8+D8mi49dsxktlm69CSRuPmd3EPLYtnsbq8flvl4mj02rOtk8Jiw6wOjRcnI/
        i8f39R1sHh+f3mLx6NuyitHj8yY5j/YD3UwBXFE5NhmpiSmpRQqpecn5KZl56bZK3sHxzvGm
        ZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAPykplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVS
        C1JyCgwNC/SKE3OLS/PS9ZLzc60MDQyMTIEqE3Iyrv6fy1qwkq1i48EfLA2MH1m6GDk5JARM
        JG7/2QRkc3EICexglOic38HWxcjBwSsgKPF3hzCIKSyQIHHsqRRIuZCAksT6i7PYQWxhAT2J
        Ww/XMILYbAI6EtNP3AeLiwgsZpaY9tIExGYW+MokcaFVEWIVr8SM9qdQa6Ulti/fCtbLKeAi
        0ftuNhtEXEPix7JeZghbVOLm6rfsMPb7Y/MZIWwRidZ7Z6FqBCUe/NwNFZeUOLb7AxOEXS+x
        9c4vRpC3JAR6GCUO77zFCpHQl7jWsRHsCF4BX4kfPRALWARUJbZ82Q21zEXicNN2FogH5CW2
        v53DDAoHZgFNifW79EFMCQFliSO3WGDeatj4mx2dzSzAJ9Fx+C9cfMe8J1CnqUms+7meaQKj
        8ixEOM9CsmsWwq4FjMyrGMVSC4pz01OLjQqMkKN2EyM4dWu57WCc8vaD3iFGJg7GQ4wSHMxK
        Irxsu1oThHhTEiurUovy44tKc1KLDzGaAn05kVlKNDkfmD3ySuINTY3MzAwsTS1MzYwslMR5
        f6bWJQgJpCeWpGanphakFsH0MXFwSjUwOfrJiNRNjEg31H0W9HjexYlzC28UKR6+GlF3+Vh7
        9pxDDHG/maKzt03L85yg2berhPN80ZYjnAvYpztHr10SNvtNw6112vddzed16Is4/k5bErnP
        1SHks/USluJ3RssF+k44L1C6Xc5w+cyX/1PW8s/ZYTIxIerIR+uJCWIneV5/Mb4o9fSkeuq6
        WF4ZjkOq1/UTUxq3vbP5uOMF477Wd686mUy1uDIP7dV3tTuS3qt9kdW+4pm0UoSAAG/tqr2G
        yyqOn+iZoCy1/qn/iUUz+S/myhwuXvo2+jPDpMg0868XrKonVnJ5bO3/u7Pz0e9o75On/+pH
        7ZAK2Tw77VrKJp70Oz7fpBjmy7oHzG7aocRSnJFoqMVcVJwIAA4uq/xmBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210426022700epcas2p298d2b9e6dd30781db9bf1e998f80eca1
References: <1619403878-28330-3-git-send-email-cang@codeaurora.org>
        <1619403878-28330-1-git-send-email-cang@codeaurora.org>
        <CGME20210426022700epcas2p298d2b9e6dd30781db9bf1e998f80eca1@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can Guo,

>diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>index 7ab6b12..090b654 100644
>--- a/drivers/scsi/ufs/ufshcd.c
>+++ b/drivers/scsi/ufs/ufshcd.c
>@@ -9058,11 +9058,12 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
>         if (!hba->is_powered)
>                 return 0;
> 
>+        cancel_delayed_work_sync(&hba->rpm_dev_flush_recheck_work);
>+
>         if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
>              hba->curr_dev_pwr_mode) &&
>             (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
>-             hba->uic_link_state) &&
>-             !hba->dev_info.b_rpm_dev_flush_capable)
I think it should not be removed.
It prevents power drain when runtime suspend and system suspend have same
power mode.

Thanks,
Daejun
