Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F303AC197A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Nov 2023 07:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjKTHfa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Nov 2023 02:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjKTHf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2023 02:35:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29811D4C
        for <linux-scsi@vger.kernel.org>; Sun, 19 Nov 2023 23:35:26 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F94C433C8;
        Mon, 20 Nov 2023 07:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700465725;
        bh=pyk6gGONqFth5PLxUaWaOTJmkFQyQCI3acwFRh3eMd8=;
        h=From:To:Cc:Subject:Date:From;
        b=NyTPikx1/6H1ySiEqpx7LPDo/kb7fenKCKixJcdpX6rccBJmFYhDqBiyt3XmbH1zi
         gqWIBUeUzncBg3OiibbnGQBI2EgAdlc8blUttZ10DtG2KsDXCp07KqxmrrbUZyiugK
         4ZkaKVqdVLokLjd7pmFVC4AVSfw6HdDnDqbpAYq3rpbYS+3p++0nLLhjhj3K04qtpy
         wUWXgIV/RfERLdsN2r8QBG5ncPdYApwE6aR7M8Xu6H85+3g2eXBSo8CUBQJ2CxbRGN
         sQRyoy65+GNMX22ccqfcoczugyS4NqEO1/PgkJIgQvUbs9FD27k5PLbmQX4frTbJTi
         lG9aN2GtgHOZQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Phillip Susi <phill@thesusis.net>
Subject: [PATCH 0/2] Fix runtime suspended device resume
Date:   Mon, 20 Nov 2023 16:35:20 +0900
Message-ID: <20231120073522.34180-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first patch changes the use of the bool type back to the regular
unsigned:1 for the manage_xxx scsi device flags. This is marked as a fix
and CC-stable to avoid issues with later eventual fixes in this area.

The second patch addresses an issue with system resume with devices that
were runtime suspended. For ATA devices, this leads to a disk still
being reported as suspended while it is in fact spun up due to how ATA
resume is done (port reset).

Damien Le Moal (2):
  scsi: Change scsi device boolean fields to single bit flags
  scsi: sd: fix system start for ATA devices

 drivers/ata/libata-scsi.c  |  9 +++++++--
 drivers/firewire/sbp2.c    |  6 +++---
 drivers/scsi/sd.c          |  9 ++++++++-
 include/scsi/scsi_device.h | 12 +++++++++---
 4 files changed, 27 insertions(+), 9 deletions(-)

-- 
2.42.0

