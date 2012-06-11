From: Ben Collins <bcollins@ubuntu.com>
Subject: [PATCH 0/4] SCSI: AACRAID: Fixes issues for PMC SRC on PowerPC
Date: Mon, 11 Jun 2012 18:20:50 -0400
Message-ID: <cover.1339453250.git.bcollins@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59707 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2FKWk3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2012 18:40:29 -0400
Received: by dady13 with SMTP id y13so6004726dad.19
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jun 2012 15:40:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>

While working on getting a PCM SRC card operating on a 32-bit PowerPC
system, I ran into some big-endian and resource size problems (64-bit
resources on 32-bit are not the same as unsigned long).

These patches fix these problems and also a couple bugs that I
encountered in the error paths.

The following changes are available in the git repository at:

  git://github.com/benmcollins/linux.git aacraid

Ben Collins (4):
  SCSI: AACRAID: Use resource_size_t for IO mem pointers and offsets
  SCSI: AACRAID: Better handling of in-flight events on thread stop
  SCSI: AACRAID: Relax the tight timeout loop on fib commands
  SCSI: AACRAID: Fix endian issues in core and SRC portions of driver

 drivers/scsi/aacraid/aacraid.h  |    5 ++--
 drivers/scsi/aacraid/comminit.c |    4 +--
 drivers/scsi/aacraid/commsup.c  |    9 ++++---
 drivers/scsi/aacraid/linit.c    |   14 +++++++++--
 drivers/scsi/aacraid/nark.c     |    4 +--
 drivers/scsi/aacraid/rkt.c      |    2 +-
 drivers/scsi/aacraid/rx.c       |    4 +--
 drivers/scsi/aacraid/sa.c       |    4 +--
 drivers/scsi/aacraid/src.c      |   53 +++++++++++++++++++++++----------------
 9 files changed, 62 insertions(+), 37 deletions(-)

-- 
1.7.9.5

