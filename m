From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 36/48] hpsa: guard against overflowing raid map array
Date: Fri, 23 Jan 2015 16:44:14 -0600
Message-ID: <20150123224414.14919.59442.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:35533 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbbAWWpI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:45:08 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

In the code that translates logical drive LBAs to physical
drive LBAs if we overflow the raid map disk data array we
will get the wrong answers.  We do not expect that to happen,
but best to be on the safe side and guard against it anyway.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index afd192d..03fae8a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3921,6 +3921,9 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 		return IO_ACCEL_INELIGIBLE;
 	}
 
+	if (unlikely(map_index >= RAID_MAP_MAX_ENTRIES))
+		return IO_ACCEL_INELIGIBLE;
+
 	c->phys_disk = dev->phys_disk[map_index];
 
 	disk_handle = dd[map_index].ioaccel_handle;

