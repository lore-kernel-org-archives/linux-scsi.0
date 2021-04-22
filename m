Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100C1C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 06:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4A6D610A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 06:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhDVGKE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 02:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhDVGKC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 02:10:02 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E4CC06174A
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 23:09:26 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q10so32081044pgj.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 23:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=KvrUSVqEamBXtPZjyb1NAhTiwCV5XenjaFAalJKGx/w=;
        b=cZEy6FsBWY/FH7HGaJ0UP1GF/JFJHqxWF/qKrwajoWHKipg+ZY/iT4dL5O/N5oL1nz
         OrSatlj6oBDcSC2e800cCo6PmfAGIyvzqhKeTvkKMYc96a3V6HO4DskumEkXl/Uma993
         TAEePhEFcH5as3t2YvbBVz1P8KWzPbC4O/N62oyBJv+Scin0G3kry8Of8Vkwv6c97xH9
         yhUa9zyC2wviYuuC8AjllMtzBoO5u0opIECLd8gRAGbtrlif8ocmC1Z0BtOTv+ul31it
         J4LjobxIOQO8Txv5555WxiRL8k5GKMUiWxPEGXucR8Pa3yxknfoSE7uT8IOvR2Lh4wkU
         QFQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=KvrUSVqEamBXtPZjyb1NAhTiwCV5XenjaFAalJKGx/w=;
        b=VByHTlc+vWI9O25dh+i2Z30dxSS/hHFjjQwO/QimpKHsFgLok4NpxtFkySo20p15p9
         e4sVDr5xkJI3pyVRDMPYh+wdSBV5k8cMUJMVfjVNKgAsmxYzuwCctYUFJFyONb53qhsE
         U7F0Ko77M+H/eLeQfEklEpHLxAPWM7jrmwwFV6rVAzbtcnb3guwXir7d6NsyquuXK5zC
         F06VPzEx/AmPmmCExuyb/G00ARcCn/oQfxt8RTBc0jOHB36WCZfg7ifGgEBMJ6qPJsUe
         /Nxu0CXledh+aEWK59BrDihxxHy9rHkQls4jI+/MhTfo5GE2sPK1i9+jrBBLvC1HRekH
         YVIQ==
X-Gm-Message-State: AOAM531t9o3Lg3TSCFaV6NIeSaFnCb4bzhqCkP4YbnQ6PKFnUE/E4qLf
        D6eZTibF/LGpPrsiwKbVblS5ZwSKaf6Exw==
X-Google-Smtp-Source: ABdhPJz1L3Ws7+X9lSj43GvUjHxwZZZPm2MbHXZNx/Yjtxr6SHaBDGV2TycHlqyI0leg3VCnl+Se3Q==
X-Received: by 2002:a62:e402:0:b029:259:baff:e8e5 with SMTP id r2-20020a62e4020000b0290259baffe8e5mr1792295pfh.81.1619071766365;
        Wed, 21 Apr 2021 23:09:26 -0700 (PDT)
Received: from [192.168.1.160] ([2.58.242.44])
        by smtp.gmail.com with ESMTPSA id mj13sm1101137pjb.9.2021.04.21.23.09.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Apr 2021 23:09:26 -0700 (PDT)
From:   =?utf-8?B?546L5paH5rab?= <witallwang@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: [PATCH] Fix 64-bit system enumeration error for Buslogic
Message-Id: <AC748808-586E-469C-BBC1-1CB86D5B4686@gmail.com>
Date:   Thu, 22 Apr 2021 14:09:22 +0800
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Elaine Zhao <yzhao@vmware.com>
To:     Khalid Aziz <khalid@gonehiking.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: matt <wwentao@vmware.com>
Date: Tue, 20 Apr 2021 15:27:48 +0800
Subject: [PATCH] Fix 64-bit system enumeration error for Buslogic

 Commit 391e2f25601e("BusLogic: Port driver to 64-bit") in Buslogic
 driver introduced a serious issue for 64-bit systems. With this
 commit, 64-bit kernel will enumerate 8*15 non-existing disks.  This
 is caused by the broken CCB structure. The change from u32 data to
 void *data increased CCB length on 64-bit system, which introduced
 an extra 4 byte offset of the CDB. This leads to incorrect response
 to Inquiry commands during enumeration.

 This patch fixes the error.

Signed-off-by: matt <wwentao@vmware.com>
---
 drivers/scsi/BusLogic.c | 6 +++---
 drivers/scsi/BusLogic.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index ccb061ab0a0a..7231de2767a9 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3078,11 +3078,11 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 		ccb->opcode = BLOGIC_INITIATOR_CCB_SG;
 		ccb->datalen = count * sizeof(struct blogic_sg_seg);
 		if (blogic_multimaster_type(adapter))
-			ccb->data = (void *)((unsigned int) ccb->dma_handle +
+			ccb->data = (unsigned int) ccb->dma_handle +
 					((unsigned long) &ccb->sglist -
-					(unsigned long) ccb));
+					(unsigned long) ccb);
 		else
-			ccb->data = ccb->sglist;
+			ccb->data = virt_to_32bit_virt(ccb->sglist);
 
 		scsi_for_each_sg(command, sg, count, i) {
 			ccb->sglist[i].segbytes = sg_dma_len(sg);
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 6182cc8a0344..e081ad47d1cf 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -814,7 +814,7 @@ struct blogic_ccb {
 	unsigned char cdblen;				/* Byte 2 */
 	unsigned char sense_datalen;			/* Byte 3 */
 	u32 datalen;					/* Bytes 4-7 */
-	void *data;					/* Bytes 8-11 */
+	u32 data;					/* Bytes 8-11 */
 	unsigned char:8;				/* Byte 12 */
 	unsigned char:8;				/* Byte 13 */
 	enum blogic_adapter_status adapter_status;	/* Byte 14 */
-- 
2.17.1


