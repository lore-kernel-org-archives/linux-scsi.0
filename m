Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A10C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbiGFXg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234610AbiGFXgs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:36:48 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA8B2CCBD;
        Wed,  6 Jul 2022 16:36:48 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BBA36C06E8;
        Wed,  6 Jul 2022 23:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150607; bh=YGzx5por/UlZOG67bE/uBBta4HSH9MaY/jMT7mI9Li8=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=fV8JkjJd8JHk0pbIrF/uXrQ9ErQYZEQzgIDmdnkQuKh7wlX65mkFr51aTFkcxydF1
         bnM9mO8GqJidJeeAxqE1/8n8ZFhdOQd9lgHgRc+UZGYczsDQnvkozrbADSFw+mtbH4
         jH+ce+XArG8+1i7cmdbxqaDUY4OJeBSC2BJV6eyLSOGT0ZzGAEsBheNywN1P4w2aQD
         1FvsI6r6oNP41tSLX0AuMTR4PLt3GvHf984VkxnQC9MwNHd++VSlSOdRhlniNQqY89
         m3WN2tsEobyaFwVWn8PvdPEo59Fai6JQ0P3zl7DX33JGEGJHAYO5kJdgkrcNYiEslk
         hq6u/UU+v31Uw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 7EB60A0063;
        Wed,  6 Jul 2022 23:36:46 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:36:46 -0700
Date:   Wed, 06 Jul 2022 16:36:46 -0700
Message-Id: <d8a976c9ca16ebf74babdd10d8da0c482de850ba.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 23/36] usb: gadget: f_tcm: Return ATA cmd direction
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org, Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Check ATA Pass-Through for direction.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/usb/gadget/function/f_tcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 91d853682468..6fea80afe2d7 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -898,6 +898,8 @@ static int get_cmd_dir(const unsigned char *cdb)
 	case READ_TOC:
 	case READ_FORMAT_CAPACITIES:
 	case REQUEST_SENSE:
+	case ATA_12:
+	case ATA_16:
 		ret = DMA_FROM_DEVICE;
 		break;
 
-- 
2.28.0

