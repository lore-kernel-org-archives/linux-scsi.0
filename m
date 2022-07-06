Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B1EC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiGFXhV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbiGFXhP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:37:15 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0FE2CDCF;
        Wed,  6 Jul 2022 16:37:14 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0C1A440787;
        Wed,  6 Jul 2022 23:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150634; bh=hc+Kg8C/uliaa9f3+AzFdNq64S4itgFWRR5PyNmRGCk=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=KhSoMam4EvxPgGOx+cQKtdirJjUpHbiZ1JSk6p4L2hq+JecxHK3NhyQNwcefYvEkl
         zgeCxJJ7ucND/3kT6IafD/ZutZJxtMMGoAtprNZw5ag4uMvbCNPGUuiWNdtp99IGMd
         n9ougeuZOkshj+Y2ApRdiHFvNuQLu8yh9A0xvYY9D72Z5u/xkGBiSCsOxUR+zuRVgJ
         FYKbrcixAW6rVG0xYds1uuaJdO3ThC2z4/++NWlv7AVBjI6yKPOuz52/WMf2q6KAjq
         qiqYyuF1gFlXGbtugpvS6MM67WvdUkKLe+remgo0MuYGwjz+2M8fzSVBDfNyxsKQuO
         hxOUbzh9sLEeA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 201BCA006F;
        Wed,  6 Jul 2022 23:37:12 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:37:12 -0700
Date:   Wed, 06 Jul 2022 16:37:12 -0700
Message-Id: <342c691002b7d39f72ed1a51bc3907c57b2954b6.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 27/36] usb: gadget: f_tcm: Translate error to sense
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org, Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Mike Christie <michael.christie@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Christoph Hellwig <hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When respond with check_condition error status, clear from_transport
input so the target layer can translate the sense reason reported by
f_tcm.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/gadget/function/f_tcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index cace5746c0f9..28b560ab44fd 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1044,7 +1044,7 @@ static void usbg_cmd_work(struct work_struct *work)
 
 out:
 	transport_send_check_condition_and_sense(se_cmd,
-			TCM_UNSUPPORTED_SCSI_OPCODE, 1);
+			TCM_UNSUPPORTED_SCSI_OPCODE, 0);
 }
 
 static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
@@ -1160,7 +1160,7 @@ static void bot_cmd_work(struct work_struct *work)
 
 out:
 	transport_send_check_condition_and_sense(se_cmd,
-				TCM_UNSUPPORTED_SCSI_OPCODE, 1);
+				TCM_UNSUPPORTED_SCSI_OPCODE, 0);
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
-- 
2.28.0

