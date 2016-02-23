From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 5/7] hpsa: check for a null phys_disk pointer in ioaccel2
 path
Date: Tue, 23 Feb 2016 15:16:34 -0600
Message-ID: <20160223211634.5968.96070.stgit@brunhilda>
References: <20160223210957.5968.6998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:50255 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212AbcBWVQg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 16:16:36 -0500
In-Reply-To: <20160223210957.5968.6998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

An oops can occur when submitting ioaccel2 commands
when the phys_disk pointer is NULL in hpsa_scsi_ioaccel_raid_map.
Happens when there are configuration changes during I/O operations.

If the phys_disk pointer is NULL, send the command down the RAID path.

Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Reviewed-by: Justin Lindley <justin.lindley@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 589b44e..edbecf8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4981,6 +4981,8 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 		return IO_ACCEL_INELIGIBLE;
 
 	c->phys_disk = dev->phys_disk[map_index];
+	if (!c->phys_disk)
+		return IO_ACCEL_INELIGIBLE;
 
 	disk_handle = dd[map_index].ioaccel_handle;
 	disk_block = le64_to_cpu(map->disk_starting_blk) +

