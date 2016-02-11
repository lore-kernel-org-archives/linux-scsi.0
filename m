From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH RESEND] scsi: sim710: fix build warning
Date: Thu, 11 Feb 2016 10:29:03 +0530
Message-ID: <1455166743-3572-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: linux-scsi@vger.kernel.org

We are getting build warning about:
 "Section mismatch in reference from the variable sim710_eisa_driver to
 the function .init.text:sim710_eisa_probe()
 The variable sim710_eisa_driver references the function __init
 sim710_eisa_probe()"

sim710_eisa_probe() was having __init but that was being referenced from
sim710_eisa_driver.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

patch first sent on 4th Sept.2015. There is no review or ACK yet.
warning is still there with next-20160209,
build log is at:
https://travis-ci.org/sudipm-mukherjee/parport/jobs/107948115

 drivers/scsi/sim710.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index 3b3b56f..82ed998 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -176,8 +176,7 @@ static struct eisa_device_id sim710_eisa_ids[] = {
 };
 MODULE_DEVICE_TABLE(eisa, sim710_eisa_ids);
 
-static __init int
-sim710_eisa_probe(struct device *dev)
+static int sim710_eisa_probe(struct device *dev)
 {
 	struct eisa_device *edev = to_eisa_device(dev);
 	unsigned long io_addr = edev->base_addr;
-- 
1.9.1
