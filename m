Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E24C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 12:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbiBOMST (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 07:18:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiBOMSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 07:18:18 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AF81074E1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 04:18:08 -0800 (PST)
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220215121802epoutp03da81657c70a55eab2173c09e726520dd~T9NR5vPm00686206862epoutp03U
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 12:18:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220215121802epoutp03da81657c70a55eab2173c09e726520dd~T9NR5vPm00686206862epoutp03U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1644927482;
        bh=gFH/O+Wwc4cOaRG+Ce3cxW3yMZxYDCdcbdpfz+GoqEI=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=jXCJwOE5sTQnteFunbis4gvquuLY4r+Fc++uZfECXWhSZHbCjnx8iKJaya1fe8GQC
         WHqo4O6+qGPL7R8IjRF8aarMdqH5xsKCAjMxctUdpR5s9Mg6BYICwUTccQCglkCUey
         wRoqw01oQUGub6pazRizoou1csXo6U4rEnpMovUM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20220215121801epcas3p2104ee63750619de84afdcdec064da235~T9NRYlWeI1114711147epcas3p2X;
        Tue, 15 Feb 2022 12:18:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4Jyg8n5CJLz4x9Pp; Tue, 15 Feb 2022 12:18:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Remove wlun_dev_to_hba()
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01644927481711.JavaMail.epsvc@epcpadp4>
Date:   Tue, 15 Feb 2022 20:40:02 +0900
X-CMS-MailID: 20220215114002epcms2p1eb4e53507c96e0f24770af16aedcf5c6
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20220215114002epcms2p1eb4e53507c96e0f24770af16aedcf5c6
References: <CGME20220215114002epcms2p1eb4e53507c96e0f24770af16aedcf5c6@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit edc0596cc04b ("scsi: ufs: core: Stop clearing UNIT ATTENTIONS")
removed all callers of wlun_dev_to_hba(). Hence also remove the macro itself.

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 41d85b69fa50..1243d73d669b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -83,8 +83,6 @@
 /* Polling time to wait for fDeviceInit */
 #define FDEVICEINIT_COMPL_TIMEOUT 1500 /* millisecs */
 
-#define wlun_dev_to_hba(dv) shost_priv(to_scsi_device(dv)->host)
-
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
-- 
2.17.1

