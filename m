From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: return 0 from driver probe function on success, not 1
Date: Fri, 01 Nov 2013 11:02:25 -0500
Message-ID: <20131101160225.17783.28237.stgit@beardog.cce.hp.com>
References: <20131101155851.17783.73732.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:12571 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab3KAQC0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2013 12:02:26 -0400
In-Reply-To: <20131101155851.17783.73732.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, scott.teel@hp.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

A return value of 1 is interpreted as an error.  See pci_driver.
in local_pci_probe().  If you're wondering how this ever could
have worked, it's because it used to be the case that only return
values less than zero were interpreted as failure.  But even in
the current kernel if the driver registers its various entry
points with the kernel, and then returns a value which is
interpreted as failure, those registrations aren't undone, so
the driver still mostly works.  However, the driver's remove
function wouldn't be called on rmmod, and pci power management
functions wouldn't work.  In the case of Smart Array, since it
has a battery backed cache (or else no cache) even if the driver
is not shut down properly as long as there is no outstanding
i/o, nothing too bad happens, which is why it took so long to
notice.

Requesting backport to stable because the change to pci-driver.c
which requires driver probe functions to return 0 occurred between
2.6.35 and 2.6.36 (the pci power management breakage) and again
between 3.7 and 3.8 (pci_dev->driver getting set to NULL in
local_pci_probe() preventing driver remove function from being
called on rmmod.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 891c86b..3c97974 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4926,7 +4926,7 @@ reinit_after_soft_reset:
 	hpsa_hba_inquiry(h);
 	hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
 	start_controller_lockup_detector(h);
-	return 1;
+	return 0;
 
 clean4:
 	hpsa_free_sg_chain_blocks(h);

