Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4EFC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbiGFXek (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiGFXei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:34:38 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA6D2C671;
        Wed,  6 Jul 2022 16:34:37 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id ACEACC06E8;
        Wed,  6 Jul 2022 23:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150477; bh=wr713SSi0TL3kWN+vsfQtgS+wGCjHIK8hmLX+enppoQ=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=QMQ+Dp0SMxqwn9Kb0udb3Y4+cJ5Y6J8rgS+Bm2MVc3amxN/Bs8N3X30tkxhRFOQG9
         g/Otr0mkgVPcQ7O9hPckzq2C+GiCZ2fGgkIDiOtEjtJgIqdNoj+SILn4o7eShnd2Fm
         hkT4jg0Eg2OURlxnu4BKBchfu3rD8GZAzWWeap4OtiHHU38G3Hx21/mxLL4NDx2bVv
         Jc0vRYFkroH5L7AysLoUuNhvgyGxPDOncFaPHoup6bIGWx7J61zRNthZ+LC9tGkboW
         N/NfQLSgblkSWRiL1Dp2xz7MIq6FiFiS/yHo/OsYwddvTlmJiK0EvH1cS+4i6pcRHp
         Rko4j9UwZg2AA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 77439A006F;
        Wed,  6 Jul 2022 23:34:35 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:34:35 -0700
Date:   Wed, 06 Jul 2022 16:34:35 -0700
Message-Id: <c8f63dbfdf1d5e2c7e3b4ed55f91142f77192f14.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 02/36] target: Add overlapped response to tmrsp_table
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>, linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add TMR_OVERLAPPED_TAG_ATTEMPTED response to tmrsp_table.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 include/target/target_core_base.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c2b36f7d917d..8e3da143a1ce 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -223,6 +223,7 @@ enum tcm_tmrsp_table {
 	TMR_LUN_DOES_NOT_EXIST		= 3,
 	TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED	= 4,
 	TMR_FUNCTION_REJECTED		= 5,
+	TMR_OVERLAPPED_TAG_ATTEMPTED	= 6,
 };
 
 /*
-- 
2.28.0

