Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91CFC433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 03:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A53F6206CD
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 03:08:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GnrspJYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgIBDIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 23:08:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56898 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgIBDIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 23:08:04 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200902030802epoutp01589df022097001794d0dcb2fd6218d68~w2KejgFs-0633006330epoutp01A
        for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2020 03:08:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200902030802epoutp01589df022097001794d0dcb2fd6218d68~w2KejgFs-0633006330epoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599016082;
        bh=slkGBz03LrKgvrUFE9snJ+DtyTGdHUcvDkNGTiZMA04=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=GnrspJYz5FEMiYcNCmfQ6tZxqI618JXuwq4mLg7chgBIy/9KCJzLAHRY306NuyF6T
         A0ySD3oKunN9wHCvc8dHSVAmvp1j8Cp4NR51ELummqoQ6hnteGxB3YF7y+2DYsaHH5
         rxWJmMsko/OlkAhUaDLaYVWoThgQc1N3oQFl0X2Y=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20200902030801epcas1p2da643c4bbf75470a571c436ad5a373f7~w2KeJ1fzf2827628276epcas1p2f;
        Wed,  2 Sep 2020 03:08:01 +0000 (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Fix NOP OUT timeout value
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01599016081767.JavaMail.epsvc@epcpadp2>
Date:   Wed, 02 Sep 2020 11:58:52 +0900
X-CMS-MailID: 20200902025852epcms2p2a2d4ac934f4fc09233d4272c96df9ff1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200902025852epcms2p2a2d4ac934f4fc09233d4272c96df9ff1
References: <CGME20200902025852epcms2p2a2d4ac934f4fc09233d4272c96df9ff1@epcms2p2>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In some Samsung UFS devices, there is some booting fail issue with
low-power UFS device. The reason of this issue is the UFS device has a
little bit longer latency for NOP OUT response. It causes booting fail
because NOP OUT command is issued during initialization to check whether
the device transport protocol is ready or not. This issue is resolved by
releasing NOP_OUT_TIMEOUT value.

NOP_OUT_TIMEOUT: 30ms -> 50ms

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 06e2439d523c..5cbd0e9e4ef8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -36,8 +36,8 @@
 
 /* NOP OUT retries waiting for NOP IN response */
 #define NOP_OUT_RETRIES    10
-/* Timeout after 30 msecs if NOP OUT hangs without response */
-#define NOP_OUT_TIMEOUT    30 /* msecs */
+/* Timeout after 50 msecs if NOP OUT hangs without response */
+#define NOP_OUT_TIMEOUT    50 /* msecs */
 
 /* Query request retries */
 #define QUERY_REQ_RETRIES 3
-- 
2.17.1


