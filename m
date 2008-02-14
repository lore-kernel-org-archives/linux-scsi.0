From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/5] gdth: scan for scsi devices
Date: Thu, 14 Feb 2008 20:52:18 +0200
Message-ID: <47B48DE2.7070604@panasas.com>
References: <47B48CAE.2020705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:18314 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756319AbYBNSxU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 13:53:20 -0500
In-Reply-To: <47B48CAE.2020705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, James Bottomley <James.Bottomley@HansenPartn>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Milter <davemilter@gmail.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>


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
index 5f0e054..4959037 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4841,6 +4841,9 @@ static int __init gdth_isa_probe_one(ulong32 isa_bios)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+
+	scsi_scan_host(shp);
+
 	return 0;
 
  out_free_coal_stat:
@@ -4968,6 +4971,9 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+
+	scsi_scan_host(shp);
+
 	return 0;
 
  out_free_ccb_phys:
@@ -5105,6 +5111,9 @@ static int __init gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
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


