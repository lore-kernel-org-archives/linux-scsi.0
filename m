From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/5] drivers/scsi: drop redundant memset
Date: Tue, 9 Mar 2010 22:14:34 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1003092214110.4974@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jack_wang@usish.com, lindar_liu@usish.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The region set by the call to memset is immediately overwritten by the
subsequent call to memcpy.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,e3,e4;
@@

- memset(e1,e2,e3);
  memcpy(e1,e4,e3);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/pm8001/pm8001_hwi.c |    1 -
 1 file changed, 1 deletion(-)

diff -u -p a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4389,7 +4389,6 @@ pm8001_chip_fw_flash_update_req(struct p
 				return -ENOMEM;
 		}
 	}
-	memset(buffer, 0, fw_control->len);
 	memcpy(buffer, fw_control->buffer, fw_control->len);
 	flash_update_info.sgl.addr = cpu_to_le64(phys_addr);
 	flash_update_info.sgl.im_len.len = cpu_to_le32(fw_control->len);
