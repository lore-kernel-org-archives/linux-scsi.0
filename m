From: Mathieu Chouquet-Stringer <mchouque@free.fr>
Subject: Re: class_device_add error in SCSI with 2.6.17-rc2-g52824b6b
Date: Thu, 20 Apr 2006 12:14:48 +0200
Message-ID: <20060420101448.GA20087@localhost>
References: <20060419213129.GA9148@localhost> <20060419215803.6DE5BDBA1@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-alpha-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060419215803.6DE5BDBA1@gherkin.frus.com>
Sender: linux-alpha-owner@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, linux-alpha@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 19, 2006 at 04:58:03PM -0500, Bob Tracy wrote:
> Similar error previously reported by me for 2.6.17-rc1, except sda go=
t
> added fine: error occurred when attempting to add/register sdb.=20
> Thankfully, you were able to append a trace...

In my case, I was able to solve the problem by replacing this call at
line 1648 in drivers/scsi/sd.c (patch attached):
strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);

by

snprintf(sdkp->cdev.class_id, BUS_ID_SIZE, "%s", sdp->sdev_gendev.bus_i=
d);

Then it works.

While debugging the whole thing, I was printk'ing the value of
sdkp->cdev.class_id right after the strncpy call and here's what I
getting (basically only the first 4 chars + final \0):=20
"0:0:"

So I guess the strncpy routine on alpha is fscked up or gcc is doing
something crazy. The function is under arch/alpha/lib/strncpy.S, time t=
o
learn assembly.


--- linux-2.6/drivers/scsi/sd.c	2006-03-28 13:28:24.000000000 +0200
+++ linux-2.6-mat/drivers/scsi/sd.c	2006-04-20 12:12:36.000000000 +0200
@@ -1645,7 +1645,8 @@
 	class_device_initialize(&sdkp->cdev);
 	sdkp->cdev.dev =3D &sdp->sdev_gendev;
 	sdkp->cdev.class =3D &sd_disk_class;
-	strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
+	snprintf(sdkp->cdev.class_id, BUS_ID_SIZE, "%s",
+		sdp->sdev_gendev.bus_id);
=20
 	if (class_device_add(&sdkp->cdev))
 		goto out_put;


--=20
Mathieu Chouquet-Stringer                           mchouque@free.fr
    "Le disparu, si l'on v=E9n=E8re sa m=E9moire, est plus pr=E9sent et
                 plus puissant que le vivant".
           -- Antoine de Saint-Exup=E9ry, Citadelle --

-
To unsubscribe from this list: send the line "unsubscribe linux-alpha" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
