From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] scsi: Do not attach VPD to devices that don't support
 it
Date: Thu, 21 Jan 2016 08:37:11 +0100
Message-ID: <56A08AA7.6090709@suse.de>
References: <20160121063039.3803.66.stgit@localhost.localdomain>
 <20160121063522.3803.23150.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030304050902060209000501"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160121063522.3803.23150.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Duyck <aduyck@mirantis.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, alexander.duyck@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, jthumshirn@suse.de
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030304050902060209000501
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 01/21/2016 07:35 AM, Alexander Duyck wrote:
> The patch "scsi: rescan VPD attributes" introduced a regression in which
> devices that don't support VPD were being scanned for VPD attributes
> anyway.  This could cause issues for this parts and should be avoided so
> the check for scsi_level has been moved out of scsi_add_lun and into
> scsi_attach_vpd so that all callers will not scan VPD for devices that
> don't support it.
> 
> Fixes: 09e2b0b14690 ("scsi: rescan VPD attributes")
> Signed-off-by: Alexander Duyck <aduyck@mirantis.com>
> ---
>  drivers/scsi/scsi.c      |    3 +++
>  drivers/scsi/scsi_scan.c |    3 +--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index b1bf42b93fcc..ed085e78c893 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -784,6 +784,9 @@ void scsi_attach_vpd(struct scsi_device *sdev)
>  	int pg83_supported = 0;
>  	unsigned char __rcu *vpd_buf, *orig_vpd_buf = NULL;
>  
> +	if (sdev->scsi_level < SCSI_3)
> +		return;
> +
>  	if (sdev->skip_vpd_pages)
>  		return;
>  retry_pg0:
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6a820668d442..1b16c89e0cf9 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -986,8 +986,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  		}
>  	}
>  
> -	if (sdev->scsi_level >= SCSI_3)
> -		scsi_attach_vpd(sdev);
> +	scsi_attach_vpd(sdev);
>  
>  	sdev->max_queue_depth = sdev->queue_depth;
>  
> 
Isn't this slightly pointless, given that we're testing the inverse
condition in scsi_attach_vpd()?

And in anycase, I guess we should be using the same logic sd.c is
using. Please see the attached patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

--------------030304050902060209000501
Content-Type: text/x-patch;
 name="0001-scsi-Do-not-attach-VPD-to-devices-that-don-t-support.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-scsi-Do-not-attach-VPD-to-devices-that-don-t-support.pa";
 filename*1="tch"

=46rom bc662c5a0255e868746ef317e2eff04dc3fcfac5 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Thu, 21 Jan 2016 08:18:49 +0100
Subject: [PATCH] scsi: Do not attach VPD to devices that don't support it=


The patch "scsi: rescan VPD attributes" introduced a regression in which
devices that don't support VPD were being scanned for VPD attributes
anyway.  This could cause issues for this parts and should be avoided so
the check for scsi_level has been moved out of scsi_add_lun and into
scsi_attach_vpd so that all callers will not scan VPD for devices that
don't support it.

Fixes: 09e2b0b14690 ("scsi: rescan VPD attributes")

Suggested-by: Alexander Duyck <aduyck@mirantis.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi.c        |  3 ++-
 drivers/scsi/sd.c          | 19 +------------------
 include/scsi/scsi_device.h | 25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b1bf42b..1deb6ad 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -784,8 +784,9 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 	int pg83_supported =3D 0;
 	unsigned char __rcu *vpd_buf, *orig_vpd_buf =3D NULL;
=20
-	if (sdev->skip_vpd_pages)
+	if (!scsi_device_supports_vpd(sdev))
 		return;
+
 retry_pg0:
 	vpd_buf =3D kmalloc(vpd_len, GFP_KERNEL);
 	if (!vpd_buf)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5451980..868d58c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2789,23 +2789,6 @@ static void sd_read_write_same(struct scsi_disk *s=
dkp, unsigned char *buffer)
 		sdkp->ws10 =3D 1;
 }
=20
-static int sd_try_extended_inquiry(struct scsi_device *sdp)
-{
-	/* Attempt VPD inquiry if the device blacklist explicitly calls
-	 * for it.
-	 */
-	if (sdp->try_vpd_pages)
-		return 1;
-	/*
-	 * Although VPD inquiries can go to SCSI-2 type devices,
-	 * some USB ones crash on receiving them, and the pages
-	 * we currently ask for are for SPC-3 and beyond
-	 */
-	if (sdp->scsi_level > SCSI_SPC_2 && !sdp->skip_vpd_pages)
-		return 1;
-	return 0;
-}
-
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -2844,7 +2827,7 @@ static int sd_revalidate_disk(struct gendisk *disk)=

 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
=20
-		if (sd_try_extended_inquiry(sdp)) {
+		if (scsi_device_supports_vpd(sdp)) {
 			sd_read_block_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
 			sd_read_block_characteristics(sdkp);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a5fc682..d9aea6c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -515,6 +515,31 @@ static inline int scsi_device_tpgs(struct scsi_devic=
e *sdev)
 	return sdev->inquiry ? (sdev->inquiry[5] >> 4) & 0x3 : 0;
 }
=20
+/**
+ * scsi_device_supports_vpd - test if a device supports VPD pages
+ * @sdev: the &struct scsi_device to test
+ *
+ * If the 'try_vpd_pages' flag is set it takes precedence.
+ * Otherwise we will assume VPD pages are supported if the
+ * SCSI level is at least SPC-3 and 'skip_vpd_pages' is not set.
+ */
+static inline int scsi_device_supports_vpd(struct scsi_device *sdev)
+{
+	/* Attempt VPD inquiry if the device blacklist explicitly calls
+	 * for it.
+	 */
+	if (sdev->try_vpd_pages)
+		return 1;
+	/*
+	 * Although VPD inquiries can go to SCSI-2 type devices,
+	 * some USB ones crash on receiving them, and the pages
+	 * we currently ask for are for SPC-3 and beyond
+	 */
+	if (sdev->scsi_level > SCSI_SPC_2 && !sdev->skip_vpd_pages)
+		return 1;
+	return 0;
+}
+
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
--=20
1.8.5.6


--------------030304050902060209000501--
