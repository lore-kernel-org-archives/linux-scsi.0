From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
Subject: Re: What should be done with wrong warning "please use bus_type	methods."
 on sd, sr, st and osst?
Date: Tue, 25 Mar 2008 23:20:57 +0100
Message-ID: <47E97AC9.4030207@tremplin-utc.net>
References: <47E7B40D.1000509@tremplin-utc.net>	 <1206372247.3494.22.camel@localhost.localdomain>	 <20080324175922.GB13816@kroah.com> <1206382594.3494.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailservice.tudelft.nl ([130.161.131.5]:29924 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757AbYCYWVG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2008 18:21:06 -0400
In-Reply-To: <1206382594.3494.76.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>, Tilman Schmidt <tilman@imap.cc>, Kay Sievers <kay.sievers@vrfy.org>

24/03/08 19:16, James Bottomley wrote/a =C3=A9crit:
> On Mon, 2008-03-24 at 10:59 -0700, Greg KH wrote:
>> On Mon, Mar 24, 2008 at 10:24:07AM -0500, James Bottomley wrote:
>>> A solution would be to duplicate the power management methods in th=
e
>>> scsi_driver structure, but this is a complete waste of space since =
the
>>> generic driver ones aren't going away (at least according to Kay an=
d
>>> Greg).  I still think the best thing to do is just to turn off this
>>> spurious warning.
>> Do you have a patch that can detect the usage that you currently hav=
e so
>> that I can change the warning message to not trigger if things are s=
et
>> up that way instead?
>=20
> Well, my suggested fix would be the attached one since you and Kay se=
em
> to be telling me that converting to bus_type X methods still leaves u=
s
> free to reuse the driver X methods.  If you're planning on deprecatin=
g
> the driver X methods, then sure, it makes sense for me to duplicate t=
hem
> in the scsi driver.

I guess the problem with removing the warning is that in some other
cases it could really be useful (searching on the web seems to show a
couple of true positives).  I think Greg was more suggesting like addin=
g
a flag ".i_know_what_i_am_doing" somewhere and putting it to 1 to
disable the warning.

Anyway, if the driver X methods are meaning something else, it makes
sense to duplicate them specifically in the scsi driver structure. We a=
re
basically talking about 8 bytes per scsi device, which can be considere=
d
a fair trade-off if it allows to detect bugs in other places of the
kernel. Following is an example of patch.

Eric
PS: Probably I'm an idiot, for the patch I didn't understand how to
move ".remove" to scsi_driver, so I moved it to scsi_device... anyway i=
t's
just an example in order to be sure that everyone is talking about the
same thing.

---
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b9b09a7..7d29099 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -384,8 +384,8 @@ static int scsi_bus_remove(struct device *dev)
 	 * driver may have altered it and it's being removed */
 	blk_queue_prep_rq(sdev->request_queue, scsi_prep_fn);
=20
-	if (drv && drv->remove)
-		err =3D drv->remove(dev);
+	if (sdev->remove)
+		err =3D sdev->remove(dev);
=20
 	return 0;
 }
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7ee86d4..da6adfd 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -83,7 +83,6 @@ static struct scsi_driver sr_template =3D {
 	.gendrv =3D {
 		.name   	=3D "sr",
 		.probe		=3D sr_probe,
-		.remove		=3D sr_remove,
 	},
 	.done			=3D sr_done,
 };
@@ -635,6 +634,7 @@ static int sr_probe(struct device *dev)
 	sprintf(cd->cdi.name, "sr%d", minor);
=20
 	sdev->sector_size =3D 2048;	/* A guess, just in case */
+	sdev->remove =3D sr_remove;
=20
 	/* FIXME: need to handle a get_capabilities failure properly ?? */
 	get_capabilities(cd);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ab7acbe..0809a0b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -158,6 +158,7 @@ struct scsi_device {
=20
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
+	int (*remove)		(struct device *);
=20
 	struct execute_work	ew; /* used to get process context on put */
=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
