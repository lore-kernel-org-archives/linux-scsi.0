From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] sd: close hole in > 2T device rejection when
 !CONFIG_LBDAF
Date: Mon, 27 Feb 2017 18:57:44 +0000
Message-ID: <1488221849.2656.8.camel@sandisk.com>
References: <1488208949-3811-1-git-send-email-steve@digidescorp.com>
         <1488211985.2656.1.camel@sandisk.com>
         <3a6783ec-200d-5df5-2e1e-756c7e8b7c22@digidescorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:10975 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbdB0TQW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 14:16:22 -0500
In-Reply-To: <3a6783ec-200d-5df5-2e1e-756c7e8b7c22@digidescorp.com>
Content-Language: en-US
Content-ID: <E0865F00453CFE4AABA97B6EE15C900D@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "steve.magnani@digidescorp.com" <steve.magnani@digidescorp.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "steve@digidescorp.com" <steve@digidescorp.com>

On Mon, 2017-02-27 at 11:13 -0600, Steve Magnani wrote:
> On 02/27/2017 10:13 AM, Bart Van Assche wrote:
> > Why are the two checks slightly different? Could the same code be used =
for
> > both checks?
>=20
> The checks are different because with READ CAPACITY(16) a _really_ huge=20
> device could report a max LBA so large that left-shifting it causes bits=
=20
> to drop off the end. That's not an issue with READ CAPACITY(10) because=20
> at most the 32-bit LBA reported by the device will become a 35-bit value=
=20
> (since the max supported block size is 4096 =3D=3D (512 << 3)).

Sorry but I still don't understand why the two checks are different. How ab=
out
the (untested) patch below? The approach below avoids that the check is
duplicated and - at least in my opinion - results in code that is easier to=
 read.

Thanks,

Bart.


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cb6e68dd6df0..3533d1e46bde 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2082,6 +2082,16 @@ static void read_capacity_error(struct scsi_disk *sd=
kp, struct scsi_device *sdp,
 	sdkp->capacity =3D 0; /* unknown mapped to zero - as usual */
 }
=20
+/*
+ * Check whether or not logical_to_sectors(sdp, lba) will overflow.
+ */
+static bool lba_too_large(u64 lba, u32 logical_block_size)
+{
+	int shift =3D sizeof(sector_t) * 8 + 9 - ilog2(logical_block_size);
+
+	return shift >=3D 0 && shift < 64 && lba >=3D (1ULL << shift);
+}
+
 #define RC16_LEN 32
 #if RC16_LEN > SD_BUF_SIZE
 #error RC16_LEN must not be more than SD_BUF_SIZE
@@ -2154,7 +2164,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, s=
truct scsi_device *sdp,
 		return -ENODEV;
 	}
=20
-	if ((sizeof(sdkp->capacity) =3D=3D 4) && (lba >=3D 0xffffffffULL)) {
+	if (lba_too_large(lba + 1, sector_size)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
 			"devices.\n");
@@ -2243,7 +2253,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, s=
truct scsi_device *sdp,
 		return sector_size;
 	}
=20
-	if ((sizeof(sdkp->capacity) =3D=3D 4) && (lba =3D=3D 0xffffffff)) {
+	if (lba_too_large(lba + 1ULL, sector_size)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
 			"devices.\n");
--=20
2.11.0
