From: Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] [SCSI] scsi_pm: Argument to scsi_device_resume should be scsi_device pointer
Date: Mon, 21 May 2012 12:32:00 +0200
Message-ID: <1337596320-32330-1-git-send-email-emilgoode@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The call to scsi_device_resume expects a struct scsi_device pointer.
We should use the to_scsi_device macro here.

Sparse is warning about this:
drivers/scsi/scsi_pm.c:30:5: warning:
	passing argument 1 of =E2=80=98scsi_device_resume=E2=80=99
	from incompatible pointer type [enabled by default]
	include/scsi/scsi_device.h:368:13: note:
	expected =E2=80=98struct scsi_device *=E2=80=99
	but argument is of type =E2=80=98struct device *=E2=80=99

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/scsi/scsi_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 9bd2c41..d4201de 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -27,7 +27,7 @@ static int scsi_dev_type_suspend(struct device *dev, =
pm_message_t msg)
 		if (drv && drv->suspend) {
 			err =3D drv->suspend(dev, msg);
 			if (err)
-				scsi_device_resume(dev);
+				scsi_device_resume(to_scsi_device(dev));
 		}
 	}
 	dev_dbg(dev, "scsi suspend: %d\n", err);
--=20
1.7.10
