From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: bnx2i + bnx2fc: convert to generic workqueue
Date: Fri, 18 Nov 2016 11:10:14 +0100
Message-ID: <20161118101019.2317-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:51348 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbcKRKKq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2016 05:10:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>

This is the second repost + fixups to get the patches applied against v4.9-=
rc4.
mkp's scsi for-next tree can be merged with no conflicts.

The last repost was not merged and stalled after Chad Dupuis said to hold on
because he is testing but never came back with the results [0]. Johannes
confirmed that he did some testing of bnx2fc but he is not sure about bnx2i
[1]. hch asked later about something different but wanted them in since they
were tested as-is [2].

The whole series is also available at
 git://git.kernel.org/pub/scm/linux/kernel/git/bigeasy/hotplug-staging.git =
scsi/bnx2

[0] https://lkml.kernel.org/r/yq137l2mm13.fsf@sermon.lab.mkp.net
[1] https://lkml.kernel.org/r/20161108072434.gnnhmrkkmxroy6dv@linux-x5ow.si=
te
[2] https://lkml.kernel.org/r/20161107191025.GA5357@lst.de

Sebastian Andrzej Siewior (5):
      scsi: bnx2i: convert to kworker
      scsi: bnx2fc: convert per-CPU thread to kworker
      scsi: bnx2fc: clean up header definitions
      scsi: bnx2fc: annoate unlock + release for sparse
      scsi: bnx2fc: convert bnx2fc_l2_rcv_thread() to worker

 drivers/scsi/bnx2fc/bnx2fc.h      |   7 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 233 +++++++---------------------------=
----
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |  28 ++---
 drivers/scsi/bnx2fc/bnx2fc_io.c   |   2 +
 drivers/scsi/bnx2i/bnx2i.h        |  11 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c    | 101 +++++++----------
 drivers/scsi/bnx2i/bnx2i_init.c   | 121 ++------------------
 include/scsi/libfcoe.h            |   1 -
 8 files changed, 111 insertions(+), 393 deletions(-)

