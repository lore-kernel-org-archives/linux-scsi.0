From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.23-rc5
Date: Thu, 06 Sep 2007 15:42:27 +0100
Message-ID: <1189089747.3466.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45998 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751742AbXIFOmc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Sep 2007 10:42:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

These are basically three sets of bug fixes for drivers (qla2xxx, iscsi
and zfcp) including a blocking show stopper for zfcp.  The patch is
available at:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Andrew Vasquez (6):
      qla2xxx: Update version number to 8.02.00-k3.
      qla2xxx: Correct mailbox register dump for FWI2 capable ISPs.
      qla2xxx: Correct 8GB iIDMA support.
      qla2xxx: Correct management-server login-state synchronization issue.
      qla2xxx: Don't modify parity bits during ISP25XX restart.
      qla2xxx: Allocate enough space for the full PCI descriptor.

Heiko Carstens (3):
      zfcp: fix the data buffer accessor patch
      zfcp: allocate gid_pn_data objects from gid_pn_cache
      zfcp: fix memory leak

Mike Christie (2):
      libiscsi: sync up iscsi and scsi eh's access to the connection
      libiscsi: fix null ptr regression when aborting a command with data to transfer

and the diffstat:

 drivers/s390/scsi/zfcp_aux.c       |    4 +-
 drivers/s390/scsi/zfcp_qdio.c      |   10 +----
 drivers/s390/scsi/zfcp_scsi.c      |    4 +-
 drivers/scsi/libiscsi.c            |   65 +++++++++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_dbg.c     |   21 +++++------
 drivers/scsi/qla2xxx/qla_def.h     |    1 
 drivers/scsi/qla2xxx/qla_gs.c      |   28 ++++++++++-----
 drivers/scsi/qla2xxx/qla_init.c    |   51 ++++++++---------------------
 drivers/scsi/qla2xxx/qla_isr.c     |    1 
 drivers/scsi/qla2xxx/qla_os.c      |    2 -
 drivers/scsi/qla2xxx/qla_version.h |    2 -
 include/scsi/libiscsi.h            |    7 +++
 12 files changed, 113 insertions(+), 83 deletions(-)

James


