Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477C5C76195
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Mar 2023 13:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbjC0N0x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Mar 2023 09:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbjC0N0k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2023 09:26:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6346D6EBA
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 06:25:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8F5881F8BB;
        Mon, 27 Mar 2023 13:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679923513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=YCLvf3G4U2EpDXHukl05E+eaKD4jfUE2SeIWyyKCaXU=;
        b=LKRpZhr/YLQcyMc0A1x/O+JIuY8jtkQ1pThmHjFTgf5vTGngLj2Nk/wd/7Oy3l4gf6jFjq
        NWrY06KEPFt+aUwlqekcgsKp12YyUzLG3hu4ZtNB0Ts3WQc3Yy5rcm+txKxpLh2GGrxckw
        6Vkq2Zh3BAXZ78+xn9JSrM2lD0gzA7c=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3A42713329;
        Mon, 27 Mar 2023 13:25:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 20FmDDmZIWTobgAAMHmgww
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
Subject: [RFC PATCH 0/3] sg3_utils: udev rules: restrict use of ambiguous device IDs
Date:   Mon, 27 Mar 2023 15:24:56 +0200
Message-Id: <20230327132459.29531-1-mwilck@suse.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Most modern SCSI devices provide VPD page 83 with at least one highly
reliable device identifier, like NAA Registered Extended or EUI-64, or
the ata-id identifier. Other device identifier types have shown to be less
reliable and possibly ambiguous. Ambiguity in particular is a problem with
multipath-tools, which may group unrelated devices together in a multipath
map, causing possible data corruption.

The device identifiers are used in two independent ways by the udev rules:
a) to set ID_SERIAL for subsystems like multipath, and b) to create
/dev/disk/by-id/scsi-... symlinks. Our udev rules have traditionally created
symlinks for every device identifier obtained from either VPD 83 or 80. This
may cause issues, especially on large installments with storage devices that
exhibit the same identifier for many logical units. At the same time, these
symlinks are rarely used.

Avoid using unreliable identifiers for setting ID_SERIAL, and don't create
symlinks for these identifiers. Add a configuration method that allows
users to easily re-enable these methods and symlinks if they need to
(this might be the case on systems with legacy devices that are referenced
in /etc/crypttab, lvm.conf, or the like). This is done by introducing
environment variables .SCSI_ID_SERIAL_SRC and .SCSI_ID_SYMLINK_SRC, to
control use of device identifiers for determining ID_SERIAL and for creating
symlinks, respectively. Both variables can contain the letters "T", "L", "V",
and "S" to enable T10-vendor ID, NAA local ID, vendor-specific ID, and VPD 80
based ID, respectively.

Distributions can change the defaults for these environment variables
to provide backward compatibility for their users, while offering users
an easy way to change the settings.

I'm sending this as RFC, because I expect that not everyone will agree
which identifiers should be enabled by default.


Martin Wilck (3):
  55-scsi-sg3_id.rules: don't set unreliable device ID by default
  58-scsi-sg3_symlink.rules: don't create extra by-id symlinks by
    default
  udev: add 00-scsi-sg3_config.rules for user configuration

 Makefile.am                       |  1 +
 scripts/00-scsi-sg3_config.rules  | 23 ++++++++++++++
 scripts/55-scsi-sg3_id.rules      | 53 ++++++++++++++++++++++++++++---
 scripts/58-scsi-sg3_symlink.rules | 46 +++++++++++++++++++++------
 4 files changed, 109 insertions(+), 14 deletions(-)
 create mode 100644 scripts/00-scsi-sg3_config.rules

-- 
2.39.2

