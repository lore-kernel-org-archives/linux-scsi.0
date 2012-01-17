From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v4 07/10] libsas: don't recover 'gone' devices in
 sas_ata_hard_reset()
Date: Mon, 16 Jan 2012 21:11:38 -0800
Message-ID: <20120117051137.22344.94760.stgit@localhost6.localdomain6>
References: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29345 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab2AQFLi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2012 00:11:38 -0500
In-Reply-To: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

The commands that timeout when a disk is forcibly removed may trigger
libata to attempt recovery of the device.  If libsas has decided to
remove the device don't permit ata to continue to issue resets to its
last known phy.

The primary motivation for this patch is hotplug testing by writing 0 to
/sys/class/sas_phy/phyX/enable.  Without this check this test leads to
libata issuing a reset and re-enabling the device that wants to be torn
down.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 92f7e78..0cb538f 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -326,6 +326,9 @@ static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
 	struct domain_device *dev = ap->private_data;
 	struct sas_internal *i = dev_to_sas_internal(dev);
 
+	if (test_bit(SAS_DEV_GONE, &dev->state))
+		return -ENODEV;
+
 	res = i->dft->lldd_I_T_nexus_reset(dev);
 
 	if (res != TMF_RESP_FUNC_COMPLETE)

