From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: patch (was Usage question)
Date: Wed, 04 May 2005 23:19:50 +0200
Message-ID: <42793C76.5010807@s5r6.in-berlin.de>
References: <1112394885.6487.9.camel@localhost.localdomain>	 <424DFE79.4080003@s5r6.in-berlin.de>  <1112450118.5518.3.camel@defiant> <1112492302.20936.12.camel@kino.dennedy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:63974 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261623AbVEDVUA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2005 17:20:00 -0400
In-Reply-To: <1112492302.20936.12.camel@kino.dennedy.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux1394-user@lists.sourceforge.net

Dan Dennedy wrote on 2005-04-03:
> On Sat, 2005-04-02 at 15:55 +0200, Matthias Bl=E4sing wrote:
[hotplugging of SBP-2 CD-ROMs]
>>There was a patch for the kernel on this list, which work quite good =
for
>>me (sr.c and sr_ioctl.c have to be modified - Olaf Hering on
>>24.10.2004). I couldn't find any bad side effects of this.
>=20
> Thanks, I located the message on the linux1394-devel list:
> http://marc.theaimsgroup.com/?l=3Dlinux1394-devel&m=3D109862922621832=
&w=3D2
>=20
> There is a very good report response to Olaf's little patch.
> http://marc.theaimsgroup.com/?l=3Dlinux1394-devel&m=3D109925711513542=
&w=3D2
>=20
> Please, others, try it as well. I'm going to....

I tried it with up to two different CD-RWs and a HDD on the same FireWi=
re
bus. Works for me. There have been other positive reports on linux1394-=
user
as well. Quote from Olaf's posting:

| The trouble starts in register_cdrom(), it sets the ->exit() function=
 if
| the CD can do CDC_MRW_W.
| On unregister, it tries to send a packet to the device which is alrea=
dy
| gone.
|
| How about this patch?

diff -purN linux-2.6.9.orig/drivers/scsi/sr.c linux-2.6.9-olh/drivers/s=
csi/sr.c
--- linux-2.6.9.orig/drivers/scsi/sr.c	2004-10-22 19:02:43.545400072 +0=
200
+++ linux-2.6.9-olh/drivers/scsi/sr.c	2004-10-24 16:32:10.765682704 +02=
00
@@ -916,6 +918,7 @@ static void sr_kref_release(struct kref
  	struct gendisk *disk =3D cd->disk;

  	spin_lock(&sr_index_lock);
+	cd->use =3D 0;
  	clear_bit(disk->first_minor, sr_index_bits);
  	spin_unlock(&sr_index_lock);

diff -purN linux-2.6.9.orig/drivers/scsi/sr_ioctl.c linux-2.6.9-olh/dri=
vers/scsi/sr_ioctl.c
--- linux-2.6.9.orig/drivers/scsi/sr_ioctl.c	2004-10-22 19:02:43.547399=
768 +0200
+++ linux-2.6.9-olh/drivers/scsi/sr_ioctl.c	2004-10-24 16:31:05.9215405=
12 +0200
@@ -86,6 +86,11 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
          struct request *req;
  	int result, err =3D 0, retries =3D 0;

+	if(!cd->use) {
+		err =3D -ENODEV;
+		goto out;
+	}
+
  	SDev =3D cd->device;
  	SRpnt =3D scsi_allocate_request(SDev, GFP_KERNEL);
          if (!SRpnt) {


--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D-=3D -=3D-=3D --=3D--
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
