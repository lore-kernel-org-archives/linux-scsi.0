From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.25-rc1
Date: Wed, 13 Feb 2008 18:02:44 -0600
Message-ID: <1202947364.3109.96.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38536 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764600AbYBNACu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 19:02:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This one's not too bad given the number of patches we had in the merge
window.  We have the advansys fix, a gdth severe problem fix (wouldn't
scan any devices) a bug fix series for lpfc and a few other odds and
ends.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Boaz Harrosh (3):
      gdth: scan for scsi devices
      aic94xx: fix ABORT_TASK define conflict
      fas216: Use scsi_eh API for REQUEST_SENSE invocation

FUJITA Tomonori (1):
      advansys: fix overrun_buf aligned bug

James Bottomley (2):
      sym53c416: fix module parameters
      update SG_ALL to avoid causing chaining

James Smart (6):
      lpfc 8.2.5 : Update lpfc driver version to 8.2.5
      lpfc 8.2.5 : Fix buffer leaks
      lpfc 8.2.5 : Miscellaneous discovery Fixes
      lpfc 8.2.5 : Add MSI-X single message support
      lpfc 8.2.5 : Miscellaneous Fixes
      lpfc 8.2.5 : Correct ndlp referencing issues

Prakash, Sathya (2):
      mpt fusion: Request I/O resources only when required
      mpt fusion: Avoid racing when mptsas and mptcl module are loaded in parall

Salyzyn, Mark (3):
      aacraid: informational sysfs value corrections
      aacraid: ignore adapter reset check polarity
      aacraid: add optional MSI support

Sergio Luis (1):
      gdth: update deprecated pci_find_device

Thomas Horsten (1):
      MegaRAID driver management char device moved to misc

Yinghai Lu (1):
      ses: fix memory leaks

And the diffstat:

 drivers/message/fusion/mptbase.c    |   54 ++++-
 drivers/message/fusion/mptbase.h    |    1 
 drivers/scsi/Kconfig                |    2 
 drivers/scsi/aacraid/aachba.c       |   70 ++++--
 drivers/scsi/aacraid/aacraid.h      |    2 
 drivers/scsi/aacraid/commsup.c      |    2 
 drivers/scsi/aacraid/linit.c        |   47 ++--
 drivers/scsi/aacraid/rx.c           |    5 
 drivers/scsi/aacraid/sa.c           |    5 
 drivers/scsi/advansys.c             |   13 +
 drivers/scsi/aic94xx/aic94xx_sas.h  |    2 
 drivers/scsi/aic94xx/aic94xx_tmf.c  |    2 
 drivers/scsi/arm/fas216.c           |   16 -
 drivers/scsi/arm/fas216.h           |    3 
 drivers/scsi/gdth.c                 |   16 +
 drivers/scsi/lpfc/lpfc.h            |   19 +
 drivers/scsi/lpfc/lpfc_attr.c       |   19 +
 drivers/scsi/lpfc/lpfc_crtn.h       |    6 
 drivers/scsi/lpfc/lpfc_ct.c         |   41 ++-
 drivers/scsi/lpfc/lpfc_disc.h       |   66 ++++--
 drivers/scsi/lpfc/lpfc_els.c        |  384 +++++++++++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_hbadisc.c    |  328 +++++++++++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_hw.h         |   18 +
 drivers/scsi/lpfc/lpfc_init.c       |  154 ++++++++++++--
 drivers/scsi/lpfc/lpfc_logmsg.h     |   10 
 drivers/scsi/lpfc/lpfc_mem.c        |   13 +
 drivers/scsi/lpfc/lpfc_nportdisc.c  |   55 +++--
 drivers/scsi/lpfc/lpfc_scsi.c       |    4 
 drivers/scsi/lpfc/lpfc_sli.c        |  105 +++++++++
 drivers/scsi/lpfc/lpfc_version.h    |    2 
 drivers/scsi/lpfc/lpfc_vport.c      |   70 ++++++
 drivers/scsi/megaraid/megaraid_mm.c |   20 +
 drivers/scsi/megaraid/megaraid_mm.h |    1 
 drivers/scsi/ses.c                  |   23 +-
 drivers/scsi/sym53c416.c            |   16 -
 include/scsi/scsi_host.h            |    8 
 36 files changed, 1232 insertions(+), 370 deletions(-)

James


