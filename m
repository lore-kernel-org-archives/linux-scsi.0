From: Daniel Wagner <wagi@monom.org>
Subject: [PATCH 0/3] wireless: Use complete() instead complete_all()
Date: Tue, 13 Sep 2016 10:58:47 +0200
Message-ID: <1473757130-14751-1-git-send-email-wagi@monom.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org, Daniel Wagner <daniel.wagner@bmw-carit.de>
List-Id: linux-scsi@vger.kernel.org

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Hi,

Using complete_all() is not wrong per se but it suggest that there
might be more than one waiter. For -rt I am reviewing all
complete_all() users and would like to leave only the real ones in the
tree. The main problem for -rt about complete_all() is that it can be
uses inside IRQ context and that can lead to unbounded amount work
inside the interrupt handler. That is a no no for -rt.

The patches grouped per subsystem and in small batches to allow
reviewing.

Patch #1 fixes a minor bug in the completion API usage. The current code
works but it could work better.

cheers,
daniel

Daniel Wagner (3):
  csiostor: fix completion usage
  sym53c8xx_2: use complete() instead complete_all()
  virtio_scsi: use complete() instead complete_all()

 drivers/scsi/csiostor/csio_scsi.c   | 5 ++---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 2 +-
 drivers/scsi/virtio_scsi.c          | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

-- 
2.7.4
