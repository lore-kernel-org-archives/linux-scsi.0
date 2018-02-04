From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] libata: don't try to pass through NCQ commands to non-NCQ devices
Date: Sat,  3 Feb 2018 20:33:51 -0800
Message-ID: <20180204043351.16812-1-ebiggers3@gmail.com>
References: <94eb2c1fae0400ce57055cd4e9bb@google.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <94eb2c1fae0400ce57055cd4e9bb@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, syzkaller-bugs@googlegroups.com, Vinayak Kale <vinayak.kale@seagate.com>, Eric Biggers <ebiggers@google.com>
List-Id: linux-scsi@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

syzkaller hit a WARN() in ata_bmdma_qc_issue() when writing to /dev/sg0.
This happened because it issued an ATA pass-through command (ATA_16)
where the protocol field indicated that NCQ should be used -- but the
device did not support NCQ.

We could just remove the WARN() from libata-sff.c, but the real problem
seems to be that the SCSI -> ATA translation code passes through NCQ
commands without verifying that the device actually supports NCQ.

Fix this by adding the appropriate check to ata_scsi_pass_thru().

Here's reproducer that works in QEMU when /dev/sg0 refers to a disk of
the default type ("82371SB PIIX3 IDE"):

    #include <fcntl.h>
    #include <unistd.h>

    int main()
    {
            char buf[53] = { 0 };

	    buf[36] = 0x85;		/* ATA_16 */
	    buf[37] = (12 << 1);	/* FPDMA */
	    buf[38] = 0x1;		/* Has data */
	    buf[51] = 0xC8;		/* ATA_CMD_READ */
            write(open("/dev/sg0", O_RDWR), buf, sizeof(buf));
    }

Fixes: ee7fb331c3ac ("libata: add support for NCQ commands for SG interface")
Reported-by: syzbot+2f69ca28df61bdfc77cd36af2e789850355a221e@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org> # v4.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ata/libata-scsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 47d421666451c..197e110f8ac75 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3316,6 +3316,12 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 		goto invalid_fld;
 	}
 
+	/* We may not issue NCQ commands to devices not supporting NCQ */
+	if (ata_is_ncq(tf->protocol) && !ata_ncq_enabled(dev)) {
+		fp = 1;
+		goto invalid_fld;
+	}
+
 	/* sanity check for pio multi commands */
 	if ((cdb[1] & 0xe0) && !is_multi_taskfile(tf)) {
 		fp = 1;
-- 
2.16.1

