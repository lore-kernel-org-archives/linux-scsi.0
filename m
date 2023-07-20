Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4473CC0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 07:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjGTHaX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 03:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjGTHaT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 03:30:19 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409F026A3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2023 00:30:18 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R648g5NfzzBRDsM
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jul 2023 15:30:11 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689838211; x=1692430212; bh=riTBeHrMPd5g6L5XhUECy8BoPnc
        cer1JenOUs/hrE1g=; b=E1fmti9RP21Zs3EGXcvLnEUAHBNPTLSPNUfg029s7f3
        xZYWT7+dF1f/ucpLQCbzHq02LsKiThTzlt9s79mHyisEo9UW485xMkXcW4V+ANA6
        KiBxuu7Xypip7m/uI10QBkHsHh+u5WNgtyQY/H11vvsayMAAuL2ZbGqB9mMTV7DA
        ag4Ng14jYODSZPvvNBlMFRV/ugo53G2D00KhpxsUESu33kMKdftl2+aRDTLUqXI+
        Eu8MimO7tDXJYU0iYWk29kiISvvUjXBR5+fEKbChAE3etsWyt5U+r58P/8NNwUv0
        As+7nSxbWyR1MQX9ZzIv2lPEZglSQEqVhD6q3Ofp3hQ==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sGCLLhOy9Rdl for <linux-scsi@vger.kernel.org>;
        Thu, 20 Jul 2023 15:30:11 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R648g3JDszBRDs1;
        Thu, 20 Jul 2023 15:30:11 +0800 (CST)
MIME-Version: 1.0
Date:   Thu, 20 Jul 2023 15:30:11 +0800
From:   sunran001@208suo.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: csiostor: fix coccicheck.log errors
In-Reply-To: <20230720072905.3109-1-xujianghui@cdjrlc.com>
References: <20230720072905.3109-1-xujianghui@cdjrlc.com>
User-Agent: Roundcube Webmail
Message-ID: <a7615ad729a19a581d5425ded0456915@208suo.com>
X-Sender: sunran001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

./drivers/scsi/csiostor/csio_mb.c:1554:46-52: ERROR: application of
sizeof to pointer

Signed-off-by: Ran Sun <sunran001@208suo.com>
---
  drivers/scsi/csiostor/csio_mb.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_mb.c 
b/drivers/scsi/csiostor/csio_mb.c
index 94810b19e747..4df8a4df4408 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -1551,7 +1551,7 @@ csio_mb_isr_handler(struct csio_hw *hw)
  		 * Enqueue event to EventQ. Events processing happens
  		 * in Event worker thread context
  		 */
-		if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(mbp)))
+		if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(*mbp)))
  			CSIO_INC_STATS(hw, n_evt_drop);

  		return 0;
