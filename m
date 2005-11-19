From: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Sat, 19 Nov 2005 15:37:28 +0100
Message-ID: <200511191537.28489.kilian.cavalotti@lip6.fr>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <437DECDB.3070509@us.ibm.com> <437E5E1E.2080902@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2-g19.free.fr ([212.27.42.28]:46995 "EHLO smtp2-g19.free.fr")
	by vger.kernel.org with ESMTP id S1751126AbVKSOh2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Nov 2005 09:37:28 -0500
In-Reply-To: <437E5E1E.2080902@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

On Saturday 19 November 2005 00:05, Douglas Gilbert wrote:
> Perhaps Kilian could try the following patch (borrowed from
> scsi_debug). The patch is against lk 2.6.15-rc1 but should
> by widely applicable (unless the aic7... series really
> does have a 12 byte limit).=20

Well, I just downloaded a fresh 2.6.15-rc1 source tree from kernel.org,=
 and,=20
to my surprise, I can't apply your patch.

Talking about linux/drivers/scsi/aic7xxx/aic7xxx_osm.c, the only occurr=
ence of=20
	/* Initial Domain Validation */

is at line 736, and it's preceded by:
        if (bootverbose)
                printf("%s: Slave Configure %d\n", ahc_name(ahc), devic=
e->id);

        dev =3D ahc_linux_get_device(ahc, device->channel, device->id,
                                   device->lun);
        dev->scsi_device =3D device;

        ahc_linux_device_queue_depth(ahc, dev);

instead of:
	if (bootverbose)
                sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
=20
	ahc_linux_device_queue_depth(sdev);

in your patch.
So it seems functions have changed between your 2.6.15-rc1, and my 2.6.=
15-rc1,=20
unless I missed something.

I nevertheless tried to apply your patch, but sdev and dev objects seem=
s to be=20
different, so I can't attibute host->max_cmd_len to the dev object. As =
you=20
probably already understood, I'm not a kernel developer, and my C knowl=
edge=20
is far from being sufficient to handle changes myself. :)

Any hint?

Thanks and regards,

--=20
Kilian CAVALOTTI                      Administrateur r=E9seaux et syst=E8=
mes
UPMC / CNRS - LIP6 (C870)
8, rue du Capitaine Scott                          Tel. : 01 44 27 88 5=
4
75015 Paris - France                               Fax. : 01 44 27 70 0=
0
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
