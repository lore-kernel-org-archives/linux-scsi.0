From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [BUGFIX 1/2] gdth: scan for scsi devices
Date: Tue, 12 Feb 2008 19:35:22 +0200
Message-ID: <47B1D8DA.6000109@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com> <47B1D7A8.8010108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:52058 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945AbYBLRgY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2008 12:36:24 -0500
In-Reply-To: <47B1D7A8.8010108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>, linux-scsi <"linux-scsi"@vger.kernel.org>, James Bottomley <"James.Bottomley"@HansenPartnership.com>, Christoph Hellwig <hch@infrade>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>


The patch: "gdth: switch to modern scsi host registration"

missed one simple fact when moving a way from scsi_module.c.
That is to call scsi_scan_host() on the probed host.
With this the gdth driver from 2.6.24 is again able to
see drives and boot.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Tested-by: Joerg Dorchain: <joerg@dorchain.net>
Tested-by: Stefan Priebe <s.priebe@allied-internet.ag>
Tested-by: Jon Chelton <jchelton@ffpglobal.com>
---
 drivers/scsi/gdth.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index b253b8c..8eb78be 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4838,6 +4838,9 @@ static int __init gdth_isa_probe_one(ulong32 isa_bios)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+
+	scsi_scan_host(shp);
+
 	return 0;
 
  out_free_coal_stat:
@@ -4965,6 +4968,9 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+
+	scsi_scan_host(shp);
+
 	return 0;
 
  out_free_ccb_phys:
@@ -5102,6 +5108,9 @@ static int __init gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+
+	scsi_scan_host(shp);
+
 	return 0;
 
  out_free_coal_stat:
-- 
1.5.3.3


