From: Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH 1/1] scsi: storvsc: Always use blk-mq
Date: Wed, 19 Dec 2018 18:40:49 +0000
Message-ID: <1545243282-10573-1-git-send-email-mikelley@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Long Li <longli@microsoft.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "emilne@redhat.com" <emilne@redhat.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Michael Kelley <mikelley@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

With high IOPS storage being increasingly prevalent for guests
on Hyper-V and in Azure, make blk-mq the default so that the
full performance of the storage can be realized without having
to tweak other configuration settings.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index f03dc03..3dbbd14 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1703,6 +1703,7 @@ static int storvsc_queuecommand(struct Scsi_Host *hos=
t, struct scsi_cmnd *scmnd)
 	.dma_boundary =3D		PAGE_SIZE-1,
 	.no_write_same =3D	1,
 	.track_queue_depth =3D	1,
+	.force_blk_mq =3D		1,
 };
=20
 enum {
--=20
1.8.3.1
