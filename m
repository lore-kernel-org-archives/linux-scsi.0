From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [PATCH]scsi_dh_rdac: Retry for Quiescence in Progress in
 rdac device handler
Date: Mon, 26 Jan 2009 21:29:37 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C13FF9AFFD6@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

During device discovery read capacity fails with 0x068b02 and sets the de=
vice size to 0. As a reason any I/O submitted to this path gets killed at=
 sd_prep_fn with BLKPREP_KILL. This patch is to retry for 0x068b02. Pleas=
e apply.

From: Vijay Chauhan<vijay.chauhan@lsi.com>

This patch adds retry for Quiescence in Progress in rdac device handler.

Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>

---
--- linux-2.6.29-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c.orig    2=
009-01-26 20:46:05.000000000 +0530
+++ linux-2.6.29-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c 2009-01-2=
6 20:47:34.000000000 +0530
@@ -579,6 +579,11 @@ static int rdac_check_sense(struct scsi_
                         * Power On, Reset, or Bus Device Reset, just ret=
ry.
                         */
                        return ADD_TO_MLQUEUE;
+               if (sense_hdr->asc =3D=3D 0x8b && sense_hdr->ascq =3D=3D =
0x02)
+                       /*
+                        * Quiescence in progress , just retry.
+                        */
+                       return ADD_TO_MLQUEUE;
                break;
        }
        /* success just means we do not care what scsi-ml does */
--
