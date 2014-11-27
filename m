From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Subject: RE: [PATCH] bfa: switch to mid layer queue full tracking
Date: Thu, 27 Nov 2014 05:46:23 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59FD5764@avmb2.qlogic.org>
References: <1416838712-26219-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_20B1A3CBD98F3845B3F5F56D8597EF59FD5764avmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:27662 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842AbaK0Fq1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Nov 2014 00:46:27 -0500
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id sAR5hqU6022734
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2014 21:46:26 -0800
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1qw5yu1ma5-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2014 21:46:25 -0800
In-Reply-To: <1416838712-26219-1-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--_000_20B1A3CBD98F3845B3F5F56D8597EF59FD5764avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Patch looks good.=20
Thanks!
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: Christoph Hellwig [mailto:hch@lst.de]=20
Sent: 24 November 2014 19:49
To: Anil Gurumurthy; Sudarsana Kalluru
Cc: linux-scsi
Subject: [PATCH] bfa: switch to mid layer queue full tracking

As far as I can tell the queue tracking in the bfa driver is a copy&paste c=
opy of the midlayer version, just without support to configure it through s=
ysfs.

Remove the bfa copy and rely on the mid layer version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/bfa/bfad_im.c | 66 ++----------------------------------------=
----
 drivers/scsi/bfa/bfad_im.h |  6 -----
 2 files changed, 2 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c index =
7223b00..ac55fd9 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -43,8 +43,6 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,  {
 	struct scsi_cmnd *cmnd =3D (struct scsi_cmnd *)dio;
 	struct bfad_s         *bfad =3D drv;
-	struct bfad_itnim_data_s *itnim_data;
-	struct bfad_itnim_s *itnim;
 	u8         host_status =3D DID_OK;
=20
 	switch (io_status) {
@@ -93,19 +91,6 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
 	cmnd->host_scribble =3D NULL;
 	bfa_trc(bfad, cmnd->result);
=20
-	itnim_data =3D cmnd->device->hostdata;
-	if (itnim_data) {
-		itnim =3D itnim_data->itnim;
-		if (!cmnd->result && itnim &&
-			 (bfa_lun_queue_depth > cmnd->device->queue_depth)) {
-			/* Queue depth adjustment for good status completion */
-			bfad_ramp_up_qdepth(itnim, cmnd->device);
-		} else if (cmnd->result =3D=3D SAM_STAT_TASK_SET_FULL && itnim) {
-			/* qfull handling */
-			bfad_handle_qfull(itnim, cmnd->device);
-		}
-	}
-
 	cmnd->scsi_done(cmnd);
 }
=20
@@ -113,8 +98,6 @@ void
 bfa_cb_ioim_good_comp(void *drv, struct bfad_ioim_s *dio)  {
 	struct scsi_cmnd *cmnd =3D (struct scsi_cmnd *)dio;
-	struct bfad_itnim_data_s *itnim_data;
-	struct bfad_itnim_s *itnim;
=20
 	cmnd->result =3D ScsiResult(DID_OK, SCSI_STATUS_GOOD);
=20
@@ -123,17 +106,6 @@ bfa_cb_ioim_good_comp(void *drv, struct bfad_ioim_s *d=
io)
 		scsi_dma_unmap(cmnd);
=20
 	cmnd->host_scribble =3D NULL;
-
-	/* Queue depth adjustment */
-	if (bfa_lun_queue_depth > cmnd->device->queue_depth) {
-		itnim_data =3D cmnd->device->hostdata;
-		if (itnim_data) {
-			itnim =3D itnim_data->itnim;
-			if (itnim)
-				bfad_ramp_up_qdepth(itnim, cmnd->device);
-		}
-	}
-
 	cmnd->scsi_done(cmnd);
 }
=20
@@ -801,6 +773,7 @@ struct scsi_host_template bfad_im_scsi_host_template =
=3D {
 	.max_sectors =3D BFAD_MAX_SECTORS,
 	.vendor_id =3D BFA_PCI_VENDOR_ID_BROCADE,
 	.use_blk_tags =3D 1,
+	.track_queue_depth =3D 1,
 };
=20
 struct scsi_host_template bfad_im_vport_template =3D { @@ -823,6 +796,7 @@=
 struct scsi_host_template bfad_im_vport_template =3D {
 	.shost_attrs =3D bfad_im_vport_attrs,
 	.max_sectors =3D BFAD_MAX_SECTORS,
 	.use_blk_tags =3D 1,
+	.track_queue_depth =3D 1,
 };
=20
 bfa_status_t
@@ -853,42 +827,6 @@ bfad_im_module_exit(void)
 		fc_release_transport(bfad_im_scsi_vport_transport_template);
 }
=20
-void
-bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim, struct scsi_device *sdev) =
-{
-	struct scsi_device *tmp_sdev;
-
-	if (((jiffies - itnim->last_ramp_up_time) >
-		BFA_QUEUE_FULL_RAMP_UP_TIME * HZ) &&
-		((jiffies - itnim->last_queue_full_time) >
-		BFA_QUEUE_FULL_RAMP_UP_TIME * HZ)) {
-		shost_for_each_device(tmp_sdev, sdev->host) {
-			if (bfa_lun_queue_depth > tmp_sdev->queue_depth) {
-				if (tmp_sdev->id !=3D sdev->id)
-					continue;
-				scsi_change_queue_depth(tmp_sdev,
-					tmp_sdev->queue_depth + 1);
-
-				itnim->last_ramp_up_time =3D jiffies;
-			}
-		}
-	}
-}
-
-void
-bfad_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sdev) -{
-	struct scsi_device *tmp_sdev;
-
-	itnim->last_queue_full_time =3D jiffies;
-
-	shost_for_each_device(tmp_sdev, sdev->host) {
-		if (tmp_sdev->id !=3D sdev->id)
-			continue;
-		scsi_track_queue_full(tmp_sdev, tmp_sdev->queue_depth - 1);
-	}
-}
-
 struct bfad_itnim_s *
 bfad_get_itnim(struct bfad_im_port_s *im_port, int id)  { diff --git a/dri=
vers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h index f6c1023..7db2b75=
 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -44,7 +44,6 @@ u32 bfad_im_supported_speeds(struct bfa_s *bfa);  #define=
 BFAD_TARGET_RESET_TMO 60  #define BFAD_LUN_RESET_TMO 60  #define ScsiResul=
t(host_code, scsi_code) (((host_code) << 16) | scsi_code) -#define BFA_QUEU=
E_FULL_RAMP_UP_TIME 120
=20
 /*
  * itnim flags
@@ -94,8 +93,6 @@ struct bfad_itnim_s {
 	u16        scsi_tgt_id;
 	u16	   channel;
 	u16        queue_work;
-	unsigned long	last_ramp_up_time;
-	unsigned long	last_queue_full_time;
 };
=20
 enum bfad_binding_type {
@@ -148,9 +145,6 @@ void bfad_destroy_workq(struct bfad_im_s *im);  void bf=
ad_fc_host_init(struct bfad_im_port_s *im_port);  void bfad_scsi_host_free(=
struct bfad_s *bfad,
 				 struct bfad_im_port_s *im_port);
-void bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim,
-				 struct scsi_device *sdev);
-void bfad_handle_qfull(struct bfad_itnim_s *itnim, struct scsi_device *sde=
v);  struct bfad_itnim_s *bfad_get_itnim(struct bfad_im_port_s *im_port, in=
t id);
=20
 extern struct scsi_host_template bfad_im_scsi_host_template;
--
1.9.1


--_000_20B1A3CBD98F3845B3F5F56D8597EF59FD5764avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
IYM3XHBUPDwI0DZccHyD2i3vffkr7yX2wmAwyW7NsMlmuyZhjeRm/BAIkOgpOXoA363i/RL9yE8b
sw11haCKwOuPpGKEZ2sBZAvojzUns3ePoT4S5nBskN+PpgpEd92WEGu6HDPQtiBn5nDFAPpsYPBn
J7NF35UPlh9Wv29hVwu/ybHxIHXawA9zYndykaLh/vB5fECy+K1jNOWuIDnCwTQ1rjjF5EKg6cWB
b3mUs3FrfmzDfbL/oFgSEexDyYAQgWuPbJujHL3+aGYSQOaAxYp9VGTwK/9IG8V8pZ/iGKBYGI+N
b0/W/1+fqs5Q360/Ta+vf0/Psy//fbK2T6kmat+rv2z+nA8QYPn70HJu/e/+/+vv+9CYF8HkxjEu
OS4xyWXJZQx9fcmwxbAfAEIAAQAAACAAAABBAG4AaQBsACAARwB1AHIAdQBtAHUAcgB0AGgAeQAA
AB8AZQABAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMA
LgBjAG8AbQAAAAAAHwBkAAEAAAAKAAAAUwBNAFQAUAAAAAAAAgFBAAEAAAB4AAAAAAAAAIErH6S+
oxAZnW4A3QEPVAIAAACAQQBuAGkAbAAgAEcAdQByAHUAbQB1AHIAdABoAHkAAABTAE0AVABQAAAA
QQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAC
XQEAAAA2AAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMA
bwBtAAAAAAAfAOVfAQAAAD4AAABzAGkAcAA6AGEAbgBpAGwALgBnAHUAcgB1AG0AdQByAHQAaAB5
AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAaDAEAAAAgAAAAQQBuAGkAbAAgAEcAdQByAHUA
bQB1AHIAdABoAHkAAAAfAB8MAQAAADYAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBA
AHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIBGQwBAAAA
eAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEEAbgBpAGwAIABHAHUAcgB1AG0AdQByAHQAaAB5
AAAAUwBNAFQAUAAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMA
LgBjAG8AbQAAAB8AAV0BAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBs
AG8AZwBpAGMALgBjAG8AbQAAAAAAHwD4PwEAAAAgAAAAQQBuAGkAbAAgAEcAdQByAHUAbQB1AHIA
dABoAHkAAAAfACNAAQAAADYAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABv
AGcAaQBjAC4AYwBvAG0AAAAAAB8AIkABAAAACgAAAFMATQBUAFAAAAAAAAIB+T8BAAAAeAAAAAAA
AACBKx+kvqMQGZ1uAN0BD1QCAAAAgEEAbgBpAGwAIABHAHUAcgB1AG0AdQByAHQAaAB5AAAAUwBN
AFQAUAAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBjAG8A
bQAAAB8ACV0BAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBp
AGMALgBjAG8AbQAAAAAAHwAxQAEAAAACAAAAAAAAAAsAQDoBAAAAHwAwQAEAAAACAAAAAAAAAB8A
GgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDxPwkEAAALAEA6AQAAAAMA/T/kBAAAAgEL
MAEAAAAQAAAABKasVFS++0KPbN/IFrmBEAMAFwABAAAAQAA5AIBh5nkFCtABQAAIMILNFnoFCtAB
CwApAAAAAAALACMAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABs
AGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAAwAAAAAAA
AEYAAAAABoUAAAAAAAAfADcAAQAAAHIAAABSAEUAOgAgAFsAUABBAFQAQwBIAF0AIABiAGYAYQA6
ACAAcwB3AGkAdABjAGgAIAB0AG8AIABtAGkAZAAgAGwAYQB5AGUAcgAgAHEAdQBlAHUAZQAgAGYA
dQBsAGwAIAB0AHIAYQBjAGsAaQBuAGcAAAAAAB8APQABAAAACgAAAFIARQA6ACAAAAAAAAMANgAA
AAAAAwAuAAAAAAAfAEIQAQAAAF4AAAA8ADEANAAxADYAOAAzADgANwAxADIALQAyADYAMgAxADkA
LQAxAC0AZwBpAHQALQBzAGUAbgBkAC0AZQBtAGEAaQBsAC0AaABjAGgAQABsAHMAdAAuAGQAZQA+
AAAAAAACAXEAAQAAABsAAAABAdAH8Y1g2t/LVNlZRYCZC7yResJ4nHPrZjAAHwBwAAEAAABqAAAA
WwBQAEEAVABDAEgAXQAgAGIAZgBhADoAIABzAHcAaQB0AGMAaAAgAHQAbwAgAG0AaQBkACAAbABh
AHkAZQByACAAcQB1AGUAdQBlACAAZgB1AGwAbAAgAHQAcgBhAGMAawBpAG4AZwAAAAAAHwA1EAEA
AAB0AAAAPAAyADAAQgAxAEEAMwBDAEIARAA5ADgARgAzADgANAA1AEIAMwBGADUARgA1ADYARAA4
ADUAOQA3AEUARgA1ADkARgBEADUANwA2ADQAQABhAHYAbQBiADIALgBxAGwAbwBnAGkAYwAuAG8A
cgBnAD4AAAAfADkQAQAAAF4AAAA8ADEANAAxADYAOAAzADgANwAxADIALQAyADYAMgAxADkALQAx
AC0AZwBpAHQALQBzAGUAbgBkAC0AZQBtAGEAaQBsAC0AaABjAGgAQABsAHMAdAAuAGQAZQA+AAAA
AAADAN4/n04AAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAOFAAAAAAAAAwAAgAggBgAAAAAAwAAA
AAAAAEYAAAAAAYUAAAAAAAADAIAQ/////0AABzAiOP93BQrQAQsAAgABAAAAAwAmAAAAAAALACsA
AAAAAAIBRwABAAAALgAAAGM9VVM7YT0gO3A9UUxvZ2ljO2w9QVZNQjItMTQxMTI3MDU0NjIzWi02
MTg5OAAAAAIBEDABAAAARgAAAAAAAACl9rpY+JScQJeq5kM6RFa/BwAgsaPL2Y84RbP19W2Fl+9Z
AAAA9I0YAABnBDGMy3GiSKVd3se6CF95AEt6piEfAAAAAB8A+j8BAAAAIAAAAEEAbgBpAGwAIABH
AHUAcgB1AG0AdQByAHQAaAB5AAAAAwAJWQEAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAAQhQAA
AAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAA6FAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYA
AAAAGIUAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAACChQAAAAAAAB8AAIAIIAYAAAAAAMAA
AAAAAABGAAAAANiFAAABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwANNP0/AAAfAACAhgMC
AAAAAADAAAAAAAAARgEAAAAgAAAAeAAtAG0AcwAtAGgAYQBzAC0AYQB0AHQAYQBjAGgAAAABAAAA
AgAAAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAiAAAAeAAtAG8AcgBpAGcAaQBuAGEAdABp
AG4AZwAtAGkAcAAAAAAAAQAAABgAAABbADEAMAAuADEALgA0AC4AMQAwAF0AAAAfAACAhgMCAAAA
AADAAAAAAAAARgEAAAAWAAAAZABpAHMAYwBsAGEAaQBtAGUAcgAAAAAAAQAAAA4AAABiAHkAcABh
AHMAcwAAAAAAUiM=

--_000_20B1A3CBD98F3845B3F5F56D8597EF59FD5764avmb2qlogicorg_--
