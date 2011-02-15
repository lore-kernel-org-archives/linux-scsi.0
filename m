From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 5/6] hpsa: Do not attempt kdump if we detect resetting
	controller failed.
Date: Tue, 15 Feb 2011 15:33:08 -0600
Message-ID: <20110215213308.5407.39755.stgit@beardog.cce.hp.com>
References: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:47109 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab1BOVdK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2011 16:33:10 -0500
In-Reply-To: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mike.mikem@beardog.cce.hp.com, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

We can get completions left over from before the attempted reset which
will interfere with the kdump.  Better to just not make the attempt in
that case.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a778cb1..eb6938f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3264,13 +3264,13 @@ static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	 * It means we're on one of those controllers which doesn't support
 	 * the doorbell reset method and on which the PCI power management reset
 	 * method doesn't work (P800, for example.)
-	 * In those cases, pretend the reset worked and hope for the best.
+	 * In those cases, don't try to proceed, as it generally doesn't work.
 	 */
 	active_transport = readl(&cfgtable->TransportActive);
 	if (active_transport & PERFORMANT_MODE) {
 		dev_warn(&pdev->dev, "Unable to successfully reset controller,"
-			" proceeding anyway.\n");
-		rc = -ENOTSUPP;
+			" Ignoring controller.\n");
+		rc = -ENODEV;
 	}
 
 unmap_cfgtable:

