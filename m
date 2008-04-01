From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI fixes for 2.6.25-rc8
Date: Tue, 01 Apr 2008 15:36:37 -0500
Message-ID: <1207082197.3100.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38503 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756131AbYDAUgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 16:36:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This patch constitutes three bug fixes (the reversion of the BSG queue
fix is the most serious; without it we're getting eventual corruption in
systems).  The other two fix error legs or misleading reporting.  The
remaining 8 patches are all updates to the mvsas driver which was a late
addition at the -rc1 phase, so while they're not truly bug fixes, they
are enhancements to make that unreleased driver more roubust for 2.6.25.

The patch is here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

James Bottomley (2):
      libsas: Warn if ATA device detected but CONFIG_SCSI_SAS_ATA not set
      Revert " fix bsg queue oops with iscsi logout"

James Smart (1):
      hosts.c: fixes for "no error" reported after error scenarios

Ke Wei (8):
      mvsas: check subsystem id
      mvsas: get phy info.
      mvsas: fix the buffer of rx DMA overflow bug
      mvsas: retry aborting task.
      mvsas: check hd whether unplugged
      mvsas : interrupt handling
      mvsas: a tag handler implementation
      mvsas: fill in error info record and phy mode6 bits.

and the diffstat:

 drivers/scsi/hosts.c               |   16 
 drivers/scsi/libsas/sas_discover.c |    5 
 drivers/scsi/mvsas.c               |  711 +++++++++++++++++++++++++------------
 drivers/scsi/scsi_sysfs.c          |    2 
 4 files changed, 497 insertions(+), 237 deletions(-)

James


