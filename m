From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] scsi: convert unrecovered read error to -EILSEQ
Date: Mon,  3 Apr 2017 16:03:48 +0400
Message-ID: <1491221029-1609-1-git-send-email-dmonakhov@openvz.org>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
List-Id: linux-scsi@vger.kernel.org

It is quite easily to get URE after power failure and get scary message.
URE is happens due to internal drive crc mismatch due to partial sector
update. Most people interpret such message as "My drive is dying", which
isreasonable assumption if your dmesg is full of complain from disks and
read(2) return EIO. In fact this error is not fatal. One can fix it easily
by rewriting affected sector.

So we have to handle URE like follows:
- Return EILSEQ to signall caller that this is bad data related problem
- Do not retry command, because this is useless.



### Test case
#Test uses two HDD: disks sdb sdc
#Write_phase
# let fio work ~100sec and then cut the power
fio --ioengine=libaio --direct=1 --rw=write --bs=1M --iodepth=16 \
--time_based=1 --runtime=600 --filesize=1G --size=1T \
--name /dev/sdb --name /dev/sdc

# Check_phase after system goes back
fio --ioengine=libaio --direct=1 --group_reporting --rw=read --bs=1M \
--iodepth=16 --size=1G --filesize=1G
--name=/dev/sdb --name /dev/sdc

More info about URE probability here:
https://plus.google.com/101761226576930717211/posts/Pctq7kk1dLL

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/scsi/scsi_lib.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 19125d7..59d64ad 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -961,6 +961,19 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			/* See SSC3rXX or current. */
 			action = ACTION_FAIL;
 			break;
+		case MEDIUM_ERROR:
+			if (sshdr.asc == 0x11) {
+				/* Handle unrecovered read error */
+				switch (sshdr.ascq) {
+				case 0x00: /* URE */
+				case 0x04: /* URE auto reallocate failed */
+				case 0x0B: /* URE recommend reassignment*/
+				case 0x0C: /* URE recommend rewrite the data */
+					action = ACTION_FAIL;
+					error = -EILSEQ;
+					break;
+				}
+			}
 		default:
 			action = ACTION_FAIL;
 			break;
-- 
2.9.3
