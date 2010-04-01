From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] sd: retry read_capacity on UNIT_ATTENTION
Date: Thu, 01 Apr 2010 10:30:01 -0400
Message-ID: <1270132201.4439.14.camel@mulgrave.site>
References: <20100401134428.7E4D1337C5@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50849 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab0DAOaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2010 10:30:05 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id F16FE93EE3
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2010 16:30:04 +0200 (CEST)
In-Reply-To: <20100401134428.7E4D1337C5@ochil.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 2010-04-01 at 15:44 +0200, Hannes Reinecke wrote:
> Hazard testing uncovered yet another bug in sd. Under heavy
> reset activity the retry counter might be exhausted and
> the command will be returned with sense UNIT_ATTENTION/0x29/00
> (POWER ON, RESET, OR BUS DEVICE RESET OCCURRED). In those
> cases we should just increase the retry counter again,
> retrying one more to clear up this Unit Attention state.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
>=20
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 1962bea..7d75a21 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1454,8 +1454,15 @@ static int read_capacity_10(struct scsi_disk *=
sdkp, struct scsi_device *sdp,
>  		if (media_not_present(sdkp, &sshdr))
>  			return -ENODEV;
> =20
> -		if (the_result)
> +		if (the_result) {
>  			sense_valid =3D scsi_sense_valid(&sshdr);
> +			if (sense_valid &&
> +			    sshdr.sense_key =3D=3D UNIT_ATTENTION &&
> +			    sshdr.asc =3D 0x29 && sshdr.asq =3D=3D 0x00)
                                      ^^^^
should be =3D=3D

> +			    /* Device reset might occur several times,
> +			     * give it one more chance */
> +			    retries++;
> +		}

=46irstly, not even compile checked:

drivers/scsi/sd.c: In function =E2=80=98read_capacity_10=E2=80=99:
drivers/scsi/sd.c:1558: error: =E2=80=98struct scsi_sense_hdr=E2=80=99 =
has no member named =E2=80=98asq=E2=80=99

Secondly, we can't quite do this.  Some devices (only broken ones in my
experience) will reply UNIT_ATTENTION I was RESET forever, leading to a
loop here.  Additionally, a massive reset storm on a shared bus would
DoS the code here, so there must be a give up point after a reasonable
number of retries.

The third problem is that if this is happening to a large device, we
only catch it in RC10 ... so we'll report undersize if the device is >
SPC2

How about this instead?

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7b75c8a..cdb8ed6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1432,6 +1432,8 @@ static void read_capacity_error(struct scsi_disk =
*sdkp, struct scsi_device *sdp,
 #error RC16_LEN must not be more than SD_BUF_SIZE
 #endif
=20
+#define READ_CAPACITY_RETRIES_ON_RESET	10
+
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device=
 *sdp,
 						unsigned char *buffer)
 {
@@ -1439,7 +1441,7 @@ static int read_capacity_16(struct scsi_disk *sdk=
p, struct scsi_device *sdp,
 	struct scsi_sense_hdr sshdr;
 	int sense_valid =3D 0;
 	int the_result;
-	int retries =3D 3;
+	int retries =3D 3, reset_retries =3D READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
@@ -1468,6 +1470,13 @@ static int read_capacity_16(struct scsi_disk *sd=
kp, struct scsi_device *sdp,
 				 * Invalid Field in CDB, just retry
 				 * silently with RC10 */
 				return -EINVAL;
+			if (sense_valid &&
+			    sshdr.sense_key =3D=3D UNIT_ATTENTION &&
+			    sshdr.asc =3D=3D 0x29 && sshdr.ascq =3D=3D 0x00)
+				/* Device reset might occur several times,
+				 * give it one more chance */
+				if (--reset_retries > 0)
+					continue;
 		}
 		retries--;
=20
@@ -1526,7 +1535,7 @@ static int read_capacity_10(struct scsi_disk *sdk=
p, struct scsi_device *sdp,
 	struct scsi_sense_hdr sshdr;
 	int sense_valid =3D 0;
 	int the_result;
-	int retries =3D 3;
+	int retries =3D 3, reset_retries =3D READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
 	unsigned sector_size;
=20
@@ -1542,8 +1551,16 @@ static int read_capacity_10(struct scsi_disk *sd=
kp, struct scsi_device *sdp,
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
=20
-		if (the_result)
+		if (the_result) {
 			sense_valid =3D scsi_sense_valid(&sshdr);
+			if (sense_valid &&
+			    sshdr.sense_key =3D=3D UNIT_ATTENTION &&
+			    sshdr.asc =3D=3D 0x29 && sshdr.ascq =3D=3D 0x00)
+				/* Device reset might occur several times,
+				 * give it one more chance */
+				if (--reset_retries > 0)
+					continue;
+		}		=09
 		retries--;
=20
 	} while (the_result && retries);



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
