Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D426EC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 18:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiLVSFV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Dec 2022 13:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLVSFT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2022 13:05:19 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8082A506;
        Thu, 22 Dec 2022 10:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1671732315;
        bh=8Gvtla9eOExxVtnWvUKbqdIg4zvAE4R1modqbMCzaNU=;
        h=Message-ID:Subject:From:To:Date:From;
        b=lQZPuGoWytIGINrGEwQ2+WwmbVeP9eBXGZ5+/H7p+LKfphTRVGYulQLyoJ6KkLKgf
         SxDsFXVfWio8Rs8Go1yrEUkLCYFNr5ySbAbQ3xwL2Ov1uZLZ790pWl7p8lv0PB9mdv
         d328yMrC6ZT1rzZLunxLpAcgQX1R1FB7vwkp8C3I=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D8B8C1281D7E;
        Thu, 22 Dec 2022 13:05:15 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QHJwNOgMcJhX; Thu, 22 Dec 2022 13:05:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1671732315;
        bh=8Gvtla9eOExxVtnWvUKbqdIg4zvAE4R1modqbMCzaNU=;
        h=Message-ID:Subject:From:To:Date:From;
        b=lQZPuGoWytIGINrGEwQ2+WwmbVeP9eBXGZ5+/H7p+LKfphTRVGYulQLyoJ6KkLKgf
         SxDsFXVfWio8Rs8Go1yrEUkLCYFNr5ySbAbQ3xwL2Ov1uZLZ790pWl7p8lv0PB9mdv
         d328yMrC6ZT1rzZLunxLpAcgQX1R1FB7vwkp8C3I=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2E9291281A28;
        Thu, 22 Dec 2022 13:05:15 -0500 (EST)
Message-ID: <65d488496e9889d1c2d3faf06bfa7c22f3807ef2.camel@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 6.1+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Thu, 22 Dec 2022 13:05:12 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Mostly small bug fixes and small updates.  The only things of note is a
qla2xxx fix for crash on hotplug and timeout and the addition of a user
exposed abstraction layer for persistent reservation error return
handling (which necessitates the conversion of nvme.c as well as SCSI).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Arun Easi (1):
      scsi: qla2xxx: Fix crash when I/O abort times out

Christophe JAILLET (1):
      scsi: libfc: Include the correct header

Johannes Thumshirn (1):
      scsi: sd: sd_zbc: Trace zone append emulation

Mike Christie (4):
      nvme: Convert NVMe errors to PR errors
      scsi: sd: Convert SCSI errors to PR errors
      scsi: core: Rename status_byte to sg_status_byte
      block: Add error codes for common PR failures

And the diffstat:

 drivers/nvme/host/core.c        | 33 +++++++++++++++-
 drivers/scsi/libfc/fc_disc.c    |  2 +-
 drivers/scsi/qla2xxx/qla_init.c | 14 +++++--
 drivers/scsi/scsi_ioctl.c       |  2 +-
 drivers/scsi/sd.c               | 35 ++++++++++++++++-
 drivers/scsi/sd_trace.h         | 84 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd_zbc.c           |  6 +++
 drivers/scsi/sg.c               |  2 +-
 include/scsi/scsi.h             |  1 +
 include/scsi/sg.h               |  2 +-
 include/uapi/linux/pr.h         | 17 +++++++++
 11 files changed, 187 insertions(+), 11 deletions(-)
 create mode 100644 drivers/scsi/sd_trace.h

James


