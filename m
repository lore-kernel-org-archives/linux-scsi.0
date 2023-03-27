Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B411C7619A
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Mar 2023 13:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbjC0N1X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Mar 2023 09:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbjC0N1C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2023 09:27:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D01961A3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 06:25:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5C9D821ECF;
        Mon, 27 Mar 2023 13:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679923514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttijqcen9Gc0l21GNAosmR1SMgukBqDf8b/eLoukYfg=;
        b=Hso0HI9lom6LOScNQbhegTg4YBOaOQPcN/ihi3xdl10TSsXslJkLRoIU4zbuVzU50hemGp
        yJdkFQvx6ctwlisQTl3/Ayys0z+Q7qJvAWskrb9jCvQBMARNzjwO/SKgp6EiD6yobPUTaM
        6SGia6tpB1zyL2QDZjNFzYD7mv4L7ZE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0AF76138ED;
        Mon, 27 Mar 2023 13:25:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mEz3ADqZIWTobgAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 27 Mar 2023 13:25:14 +0000
From:   mwilck@suse.com
To:     Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Franck Bui <fbui@suse.de>, dm-devel@redhat.com,
        linux-scsi@vger.kernel.org,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/3] 58-scsi-sg3_symlink.rules: don't create extra by-id symlinks by default
Date:   Mon, 27 Mar 2023 15:24:58 +0200
Message-Id: <20230327132459.29531-3-mwilck@suse.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327132459.29531-1-mwilck@suse.com>
References: <20230327132459.29531-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

The current code will set device symlinks for every identifier obtained
from VPD pages 0x83 and 0x80. This is seldom useful. Device IDs shouldn't
be used for identifying file systems or high-level objects such as LVs;
it is much more useful to identify these by their respective UUIDs.
Those subsystems that need device IDs, such as LVM, multipath, dm-crypt
etc, just need one identifier. For these use cases, a single symlink
is sufficient, and it should be the most reliable one as selected by
the ID_SERIAL logic in 55-scsi-sg3_id.rules.

On the other hand, especially on large configurations, unreliable and
ambiguous device identifiers can cause trouble when many devices claim
the same symlink. udev's attempts to determine the highest-priority
contender for a given symlink may be very resource-intensive and slow,
especially during boot, when lots of uevents for similar devices have
to be processed in parallel. This can cause udev workers to be killed,
and in the worst case, boot failure.

Avoid these issues by not creating possibly ambiguous /dev/disk/by-id
symlinks any more by default. Users can modify the configuration by
setting the types of symlinks to create in the environment variable
.SCSI_SYMLINK_SRC, which can be a combination of the letters T, L, V, S:

 T: T10 vendor ID ("1...") from VPD 0x83
 L: NAA local ("33...") from VPD 0x83
 V: vendor-specific ("0...") from VPD 0x83
 S: vendor/model/serial number ("S...") from VPD 0x80

In practice, modifying this should only be necessary if legacy devices
that don't provide any reliable identifiers are used as targets for
dm-crypt or LVM.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 scripts/58-scsi-sg3_symlink.rules | 50 +++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/scripts/58-scsi-sg3_symlink.rules b/scripts/58-scsi-sg3_symlink.rules
index fe6b000..99fdc23 100644
--- a/scripts/58-scsi-sg3_symlink.rules
+++ b/scripts/58-scsi-sg3_symlink.rules
@@ -5,10 +5,36 @@ ACTION=="remove", GOTO="sg3_utils_symlink_end"
 SUBSYSTEM!="block", GOTO="sg3_utils_symlink_end"
 ENV{UDEV_DISABLE_PERSISTENT_STORAGE_RULES_FLAG}=="1", GOTO="sg3_utils_symlink_end"
 
-# Select which identifier to use per default
+# Enable or disable possibly ambiguous SCSI device symlinks under /dev/disk/by-id
+#
+# .SCSI_SYMLINK_SRC can be any combination of the letter "TLVS":
+#   T: T10 vendor ID ("1...") from VPD 0x83
+#   L: NAA local ("33...") from VPD 0x83
+#   V: vendor-specific ("0...") from VPD 0x83
+#   S: vendor/model/serial number ("S...") from VPD 0x80
+# Symlinks will be created for every letter included in .SCSI_SYMLINK_SRC.
+# Symlinks for NAA (except "local") and EUI-64 IDs (see below) are always created.
+#
+# NOTE: The default rules in 60-persistent-storage.rules create a symlink
+# "ENV{ID_BUS}-ENV{ID_SERIAL}" symlink anyway, where ID_BUS is "scsi", "ata", "usb", or "cciss".
+# ID_SERIAL is set in 55-scsi-sg3_id.rules from the least ambiguous device identifier.
+# The symlinks created by this file are created *in addition* to the default symlink.
+#
+# This only needs to be changed if some subsystem, like dm-crypt or LVM, depends on the
+# additional symlinks being present for device identification.
+#
+# To configure the behavior, add an early rule (e.g. /etc/udev/rules.d/00-scsi-serial.rules)
+# like this:
+# ACTION!="remove", KERNEL=="sd*|sr*|st*|nst*|cciss*", ENV{.SCSI_SYMLINK_SRC}="TS"
+#
+# By default, no possibly ambiguous additional symlinks will be created.
+ENV{.SCSI_SYMLINK_SRC}!="?*", ENV{.SCSI_SYMLINK_SRC}=""
+
 # 0: vpd page 0x80 identifier
-ENV{SCSI_IDENT_SERIAL}=="?*", ENV{DEVTYPE}=="disk", SYMLINK+="disk/by-id/scsi-S$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_SERIAL}"
-ENV{SCSI_IDENT_SERIAL}=="?*", ENV{DEVTYPE}=="partition", SYMLINK+="disk/by-id/scsi-S$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_SERIAL}-part%n"
+ENV{.SCSI_SYMLINK_SRC}=="*S*", ENV{SCSI_IDENT_SERIAL}=="?*", ENV{DEVTYPE}=="disk", \
+    SYMLINK+="disk/by-id/scsi-S$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_SERIAL}"
+ENV{.SCSI_SYMLINK_SRC}=="*S*", ENV{SCSI_IDENT_SERIAL}=="?*", ENV{DEVTYPE}=="partition", \
+    SYMLINK+="disk/by-id/scsi-S$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_SERIAL}-part%n"
 # NAA identifier (prefix 3)
 # 1: IEEE Registered Extended first
 ENV{SCSI_IDENT_LUN_NAA_REGEXT}=="?*", ENV{DEVTYPE}=="disk", SYMLINK+="disk/by-id/scsi-3$env{SCSI_IDENT_LUN_NAA_REGEXT}"
@@ -26,13 +52,19 @@ ENV{SCSI_IDENT_LUN_EUI64}=="?*", ENV{DEVTYPE}=="partition", SYMLINK+="disk/by-id
 ENV{SCSI_IDENT_LUN_NAME}=="?*", ENV{DEVTYPE}=="disk", SYMLINK+="disk/by-id/scsi-8$env{SCSI_IDENT_LUN_NAME}"
 ENV{SCSI_IDENT_LUN_NAME}=="?*", ENV{DEVTYPE}=="partition", SYMLINK+="disk/by-id/scsi-8$env{SCSI_IDENT_LUN_NAME}-part%n"
 # 6: T10 Vendor identifier (prefix 1)
-ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{DEVTYPE}=="disk", SYMLINK+="disk/by-id/scsi-1$env{SCSI_IDENT_LUN_T10}"
-ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{DEVTYPE}=="partition", SYMLINK+="disk/by-id/scsi-1$env{SCSI_IDENT_LUN_T10}-part%n"
+ENV{.SCSI_SYMLINK_SRC}=="*T*", ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{DEVTYPE}=="disk", \
+    SYMLINK+="disk/by-id/scsi-1$env{SCSI_IDENT_LUN_T10}"
+ENV{.SCSI_SYMLINK_SRC}=="*T*", ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{DEVTYPE}=="partition", \
+    SYMLINK+="disk/by-id/scsi-1$env{SCSI_IDENT_LUN_T10}-part%n"
 # 7: IEEE Locally assigned
-ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{DEVTYPE}=="disk", SYMLINK+="disk/by-id/scsi-3$env{SCSI_IDENT_LUN_NAA_LOCAL}"
-ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{DEVTYPE}=="partition", SYMLINK+="disk/by-id/scsi-3$env{SCSI_IDENT_LUN_NAA_LOCAL}-part%n"
+ENV{.SCSI_SYMLINK_SRC}=="*L*", ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{DEVTYPE}=="disk", \
+    SYMLINK+="disk/by-id/scsi-3$env{SCSI_IDENT_LUN_NAA_LOCAL}"
+ENV{.SCSI_SYMLINK_SRC}=="*L*", ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{DEVTYPE}=="partition", \
+    SYMLINK+="disk/by-id/scsi-3$env{SCSI_IDENT_LUN_NAA_LOCAL}-part%n"
 # 8: Vendor-specific identifier (prefix 0)
-ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{DEVTYPE}=="disk", SYMLINK+="disk/by-id/scsi-0$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_LUN_VENDOR}"
-ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{DEVTYPE}=="partition", SYMLINK+="disk/by-id/scsi-0$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_LUN_VENDOR}-part%n"
+ENV{.SCSI_SYMLINK_SRC}=="*V*", ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{DEVTYPE}=="disk", \
+    SYMLINK+="disk/by-id/scsi-0$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_LUN_VENDOR}"
+ENV{.SCSI_SYMLINK_SRC}=="*V*", ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{DEVTYPE}=="partition", \
+    SYMLINK+="disk/by-id/scsi-0$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_LUN_VENDOR}-part%n"
 
 LABEL="sg3_utils_symlink_end"
-- 
2.39.2

