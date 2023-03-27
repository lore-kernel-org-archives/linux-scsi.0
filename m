Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6E1C76195
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Mar 2023 13:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbjC0N1W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Mar 2023 09:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbjC0N1A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2023 09:27:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDB146B8
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 06:25:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 073F421F48;
        Mon, 27 Mar 2023 13:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679923514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qPWpNNIEQMOT6kQ1gtBA2LpRfXOfJ7h5kEDv8LsOpGc=;
        b=X7MPI+bxYJa7iyyI/GgfvOxPzns6z/UYG0DsCkLm/Vd5FltDVAl/LD2e3JntV/bTHTLySA
        JdJY0tQ6tpjZvjjwVh2piAFlECjyCo1aJCLWWCTr22mbDBW/7s3Qx7Po/HDPSaVH10HLAV
        Uq5P+Qr7qleaGe0ECVCUVYH4jYITP+w=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9FD6613329;
        Mon, 27 Mar 2023 13:25:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oD8UJTmZIWTobgAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 27 Mar 2023 13:25:13 +0000
From:   mwilck@suse.com
To:     Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Franck Bui <fbui@suse.de>, dm-devel@redhat.com,
        linux-scsi@vger.kernel.org,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/3] 55-scsi-sg3_id.rules: don't set unreliable device ID by default
Date:   Mon, 27 Mar 2023 15:24:57 +0200
Message-Id: <20230327132459.29531-2-mwilck@suse.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327132459.29531-1-mwilck@suse.com>
References: <20230327132459.29531-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Some of the methods to determine the SCSI device ID are known to be
unreliable and, and possibly cause dm-multipath to falsely detect
a multipath setup and cause data corruption. These methods will
only be used if the known reliable device IDs (like NAA registered)
are unavailable.

Don't apply these methods by default. Make the methods to use configurable
instead. Configuration is done by setting the udev property
".SCSI_ID_SERIAL_SRC" to any combination of the letters T, L, V, S:

  T: T10 vendor ID ("1...")
  L: NAA local ("33...")
  V: vendor-specific ("0...")
  S: vendor/model/serial number ("S...")

The ordering of the letters in .SCSI_ID_SERIAL_SRC doesn't matter,
the precedence is always T, L, V, S.

Regardless of using these properties for ID_SERIAL, we can infer that
if any of these properties is set, it's correct to set ID_BUS="scsi".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 scripts/55-scsi-sg3_id.rules | 53 +++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/scripts/55-scsi-sg3_id.rules b/scripts/55-scsi-sg3_id.rules
index 453210b..33b2ad3 100644
--- a/scripts/55-scsi-sg3_id.rules
+++ b/scripts/55-scsi-sg3_id.rules
@@ -99,11 +99,56 @@ ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_NAA_REG}=="?*", ENV{ID_BUS}="scsi", ENV
 ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_NAA_EXT}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="3$env{SCSI_IDENT_LUN_NAA_EXT}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_NAA_EXT}"
 ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_EUI64}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="2$env{SCSI_IDENT_LUN_EUI64}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_EUI64}"
 ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_NAME}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="8$env{SCSI_IDENT_LUN_NAME}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_NAME}"
-ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="1$env{SCSI_IDENT_LUN_T10}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_T10}"
-ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="3$env{SCSI_IDENT_LUN_NAA_LOCAL}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_NAA_LOCAL}"
-ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="0$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_LUN_VENDOR}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_VENDOR}"
-ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_SERIAL}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="S$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_SERIAL}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_SERIAL}"
 
 # Compat ID_SCSI_SERIAL setting
 ENV{ID_SCSI_SERIAL}!="?*", ENV{SCSI_IDENT_SERIAL}=="?*", ENV{ID_SCSI_SERIAL}="$env{SCSI_IDENT_SERIAL}"
+
+# Enable or disable possibly ambiguous SCSI device ID sources for setting ID_SERIAL
+#
+# .SCSI_ID_SERIAL_SRC can be any combination of the characters "TLVS":
+#   T: T10 vendor ID ("1...") from VPD 0x83
+#   L: NAA local ("33...") from VPD 0x83
+#   V: vendor-specific ("0...") from VPD 0x83
+#   S: vendor/model/serial number ("S...") from VPD 0x80
+# The ordering of the letters doesn't matter, the precedence is always T, L, V, S
+# NAA (except "local") and EUI-64 IDs (see below), as well as ATA IDs, always take precedence over
+# the sources configured here.
+#
+# This only needs to be changed if there are legacy SCSI devices that don't provide any reliable
+# device identifiers, and some subsystem like multipath requires that ID_SERIAL is set.
+# Be aware that multipath actually needs unique identifiers, though.
+# Using ambiguous identifiers for ID_SERIAL can cause data corruption with multipath.
+#
+# To configure this, add an early rule (e.g. /etc/udev/rules.d/00-scsi-serial.rules) e.g. like this:
+# ACTION!="remove", KERNEL=="sd*|sr*|st*|nst*|cciss*", ENV{.SCSI_ID_SERIAL_SRC}="TLVS"
+#
+# By default, only T10 vendor ID is allowed.
+ENV{.SCSI_ID_SERIAL_SRC}!="?*", ENV{.SCSI_ID_SERIAL_SRC}="T"
+
+ENV{ID_SERIAL}=="?*", GOTO="sg3_utils_id_end"
+ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{ID_BUS}="scsi"
+ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{.SCSI_ID_SERIAL_SRC}=="*T*", \
+    ENV{ID_SERIAL}="1$env{SCSI_IDENT_LUN_T10}", \
+    ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_T10}"
+
+ENV{ID_SERIAL}=="?*", GOTO="sg3_utils_id_end"
+ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{ID_BUS}="scsi"
+ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{.SCSI_ID_SERIAL_SRC}=="*L*", \
+    ENV{ID_SERIAL}="3$env{SCSI_IDENT_LUN_NAA_LOCAL}", \
+    ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_NAA_LOCAL}"
+
+ENV{ID_SERIAL}=="?*", GOTO="sg3_utils_id_end"
+ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{ID_BUS}="scsi"
+ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{.SCSI_ID_SERIAL_SRC}=="*V*", \
+    ENV{ID_SERIAL}="0$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_LUN_VENDOR}", \
+    ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_VENDOR}"
+
+ENV{ID_SERIAL}=="?*", GOTO="sg3_utils_id_end"
+ENV{SCSI_IDENT_SERIAL}=="?*", ENV{ID_BUS}="scsi"
+ENV{SCSI_IDENT_SERIAL}=="?*", ENV{.SCSI_ID_SERIAL_SRC}=="*S*", \
+    ENV{ID_SERIAL}="S$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_SERIAL}", \
+    ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_SERIAL}"
+
 LABEL="sg3_utils_id_end"
+ENV{ID_SERIAL}!="?*", ENV{DEVTYPE}=="disk", \
+    PROGRAM="/bin/logger -t 55-scsi-sg3_id.rules -p daemon.warning \"WARNING: SCSI device %k has no device ID, consider changing .SCSI_ID_SERIAL_SRC in 00-scsi-sg3_config.rules\""
-- 
2.39.2

