Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC61E80AB9
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 14:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbjI0OTt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbjI0OTK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 10:19:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3647619A;
        Wed, 27 Sep 2023 07:19:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D48C433C8;
        Wed, 27 Sep 2023 14:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695824346;
        bh=ivSqt8eYECZ8WOxEKDAq1kGxxTWXRhFriR2bEOYAGzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTRZCKwBLcsiaL4Tik8f751GM38ajk4zuqBWHA6SBC+Lju3ZGYL45PiWe1k9Ockbl
         r/wl51sounotTPX/07PAG50xwxcw0NNWwaZEeTpulW4y4FZ+CAFmJsKHUE5l+yDEmK
         Uh6Ucxe4Jqz6HnAP8YVM7ErX77/M4T2f39cPjl4xHY4x07O0ruCC+srOHJp0ojnpiD
         dGOG7+J2UDlTF2L+xH3M8+YFGS7y9D7LlyQsXpeZbdmuvjHgNoZ3gL/pXVduVx0Fop
         Aw+youhSfP7TeyU4QjbP9wG0mkORQqQlATMR/kf1j1amAMs6gBO4iAdRiGlDHVTWmS
         ymY63Xsgu8G+w==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH v8 21/23] ata: libata-eh: Improve reset error messages
Date:   Wed, 27 Sep 2023 23:18:26 +0900
Message-ID: <20230927141828.90288-22-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230927141828.90288-1-dlemoal@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some drives are really slow to spinup on resume, resulting is a very
slow response to COMRESET and to error messages such as:

ata1: COMRESET failed (errno=-16)
ata1: link is slow to respond, please be patient (ready=0)
ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata1.00: configured for UDMA/133

Given that the slowness of the response is indicated with the message
"link is slow to respond..." and that resets are retried until the
device is detected as online after up to 1min (ata_eh_reset_timeouts),
there is no point in printing the "COMRESET failed" error message. Let's
not scare the user with non fatal errors and only warn about reset
failures in ata_eh_reset() when all reset retries have been exhausted.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-eh.c   | 2 ++
 drivers/ata/libata-sata.c | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5686353e442c..67387d602735 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2909,6 +2909,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		 */
 		if (ata_is_host_link(link))
 			ata_eh_thaw_port(ap);
+		ata_link_warn(link, "%s failed\n",
+			      reset == hardreset ? "hardreset" : "softreset");
 		goto out;
 	}
 
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index 83a9497e48e1..b6656c287175 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -621,7 +621,6 @@ int sata_link_hardreset(struct ata_link *link, const unsigned int *timing,
 		/* online is set iff link is online && reset succeeded */
 		if (online)
 			*online = false;
-		ata_link_err(link, "COMRESET failed (errno=%d)\n", rc);
 	}
 	return rc;
 }
-- 
2.41.0

