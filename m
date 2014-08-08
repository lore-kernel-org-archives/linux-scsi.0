From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [RFC PATCH 02/10] scsi/constants: Cleanup printk message in
 scsi_decode_sense_extras()
Date: Fri, 08 Aug 2014 11:50:09 +0000
Message-ID: <20140808115009.6768.60285.stgit@yuno-kbuild.novalocal>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

If sense_flags and fixed_valid are zero, the kernel does not need to
output a printk message. So, if those conditions are met, it just returns.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 drivers/scsi/constants.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index a0e8159..9c38b8d 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1438,6 +1438,9 @@ scsi_decode_sense_extras(struct scsi_device *sdev, const char *name,
 			sense_flags |= ucp[3] & 0xe0;
 	}
 
+	if (!sense_flags && !fixed_valid)
+		return;
+
 	res = 0;
 	memset(buff, 0, sizeof(buff));
 	blen = sizeof(buff) - 1;
