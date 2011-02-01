From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] scsi_debug: Fix 32-bit overflow in do_device_access
Date: Mon, 31 Jan 2011 18:47:54 -0800
Message-ID: <20110201024754.GS27190@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

If I create a scsi_debug device that is larger than 4GB, the multiplication of
(block * scsi_debug_sector_size) can produce a 64-bit value.  Unfortunately,
the compiler sees two 32-bit quantities and performs a 32-bit multiplication,
thus truncating the bits above 2^32.  This causes the wrong memory location to
be read or written.  Change block and rest to be unsigned long long.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/scsi_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7b31093..a6b2d72 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1671,7 +1671,7 @@ static int do_device_access(struct scsi_cmnd *scmd,
 			    unsigned long long lba, unsigned int num, int write)
 {
 	int ret;
-	unsigned int block, rest = 0;
+	unsigned long long block, rest = 0;
 	int (*func)(struct scsi_cmnd *, unsigned char *, int);
 
 	func = write ? fetch_to_dev_buffer : fill_from_dev_buffer;
