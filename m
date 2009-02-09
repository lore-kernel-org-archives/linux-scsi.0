From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/6] qla2xxx: fixes for 2.6.29-rcX [8.03.00-k3].
Date: Sun,  8 Feb 2009 20:50:10 -0800
Message-ID: <1234155016-6215-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:7132 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbZBIEuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2009 23:50:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

James,

Another round of fixes for 2.6.29-rc4.

The first two commits are larger than I'd normally like, but they do
address some performance regressions in 8gb (and above) ISPs, as well
as help to work nicely with IDC (inter-driver-communication) in
QLogic's 10gb NIC driver, (qlge).

Here's the commits:

* Remove interrupt request bit check in the response processing path
  in multiq mode.
* Properly acknowledge IDC notification messages.
* Correct slab-error overwrite during vport creation and deletion.
* Mask out 'reserved' bits while processing FLT regions.
* Correct Kernel Panic with Qlogic 2472 Card.
* Update version number to 8.03.00-k3.

Thanks, AV

---

 drivers/scsi/qla2xxx/qla_attr.c    |   13 ++++----
 drivers/scsi/qla2xxx/qla_def.h     |    5 +++
 drivers/scsi/qla2xxx/qla_devtbl.h  |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h      |    2 +
 drivers/scsi/qla2xxx/qla_gbl.h     |    9 +++--
 drivers/scsi/qla2xxx/qla_init.c    |    7 ++--
 drivers/scsi/qla2xxx/qla_isr.c     |   58 +++++++++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_mbx.c     |   40 ++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_mid.c     |   12 ++++----
 drivers/scsi/qla2xxx/qla_os.c      |   16 ++++++++++
 drivers/scsi/qla2xxx/qla_sup.c     |    2 +-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 12 files changed, 113 insertions(+), 55 deletions(-)

