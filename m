From: Pan Bian <bianpan201602@163.com>
Subject: [PATCH 1/1] scsi: csiostor: fix improper reference to variable
Date: Sat,  3 Dec 2016 21:36:10 +0800
Message-ID: <1480772170-6720-1-git-send-email-bianpan201602@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-scsi@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

In function csio_config_device_caps(), returns the value of variable rv
on error paths. However, when validating device capabilities, its value
is reset, and will be 0 on the following error paths. 0 means no error
in this context. It may be better to use variable retval to receive
the return value of function csio_hw_validate_caps().

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188861

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/csiostor/csio_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 622bdab..c7d95ba 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -1372,8 +1372,8 @@ struct t4_vpd_hdr {
 	}
 
 	/* Validate device capabilities */
-	rv = csio_hw_validate_caps(hw, mbp);
-	if (rv != 0)
+	retval = csio_hw_validate_caps(hw, mbp);
+	if (retval != 0)
 		goto out;
 
 	/* Don't config device capabilities if already configured */
-- 
1.9.1
