From: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
Subject: [PATCH 1/1] scsi: storvsc: Increase cmd_per_lun for higher speed
 devices
Date: Wed, 24 Jan 2018 22:49:57 +0000
Message-ID: <1516834132-26273-1-git-send-email-mikelley@ntdev.microsoft.com>
Reply-To: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0092.outbound.protection.outlook.com ([104.47.33.92]:26803
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932845AbeAXWt7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jan 2018 17:49:59 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Long Li <longli@microsoft.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>

Increase cmd_per_lun to allow more I/Os in progress per device,
particularly for NVMe's.  The Hyper-V host side can handle the
higher count with no issues.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index f3264c4..6205107 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1657,7 +1657,7 @@ static int storvsc_queuecommand(struct Scsi_Host *hos=
t, struct scsi_cmnd *scmnd)
 	.eh_timed_out =3D		storvsc_eh_timed_out,
 	.slave_alloc =3D		storvsc_device_alloc,
 	.slave_configure =3D	storvsc_device_configure,
-	.cmd_per_lun =3D		255,
+	.cmd_per_lun =3D		2048,
 	.this_id =3D		-1,
 	.use_clustering =3D	ENABLE_CLUSTERING,
 	/* Make sure we dont get a sg segment crosses a page boundary */
--=20
1.8.3.1
