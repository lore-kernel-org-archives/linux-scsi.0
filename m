Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF2CFC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbiGFXgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiGFXgA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:36:00 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74992CC82;
        Wed,  6 Jul 2022 16:35:58 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A15EEC06E7;
        Wed,  6 Jul 2022 23:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150558; bh=coRozXGBdbR7RSe6uUMa2STttmf3UXA5ykQYkUIgaII=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=UoMhhGOF5/oFsgrHI6yKi/owvhjNvpl7iSo6uLEPcn1UpYUFx0guBU7CXyJEA8I/+
         9dwSc6uXote6jnkMV/XothSHWx31isb1MzNqtSfoSET5R63eEUuKbAJUeXC7vQMP4e
         2a/PH6ChlMEuSJgoNepQKnnYmHWJnKQ0zFhVjGFErsBhTkLLQ2mao9wnCUa70pZAT2
         GVJ4PZNwm4ahl+5oq5qR1FqlEYpxnhdohc1qJWgf4l3bI1r8bN/D76fBsgUkSwB3tb
         M3vUyn0KA4qbBkDWgo0KIMJvicvm2meWbDgfrT8yE8Owo5CxLpZDmAb1jfJ3aE3jEC
         524vXZqc/fTrw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 65EE0A0065;
        Wed,  6 Jul 2022 23:35:57 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:35:57 -0700
Date:   Wed, 06 Jul 2022 16:35:57 -0700
Message-Id: <2557ef61dddba5056b9d89d73248bf4140e92f19.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 15/36] target: Include INQUIRY length
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The INQUIRY data length is minimum 36 bytes plus additional length
jindicated in the descriptor. See SPC4-r37 section 6.6.2. The "len" here
is the total length of the INQUIRY data. Make sure to include the 36
initial bytes.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_spc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index dd799158609d..1801e10cd575 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -756,7 +756,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		}
 
 		ret = spc_emulate_inquiry_std(cmd, buf);
-		len = buf[4] + 5;
+		len = buf[4] + 5 + INQUIRY_LEN;
 		goto out;
 	}
 
-- 
2.28.0

