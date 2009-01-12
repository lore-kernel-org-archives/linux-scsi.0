From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Make errors printed from scsi_sysfs_add_sdev() mean something.
Date: Mon, 12 Jan 2009 15:04:26 +0100
Message-ID: <496B4DEA.9000206@suse.de>
References: <20081223221859.GA541@rere.qmqm.pl> <496B37C8.3010705@suse.de> <496B4067.1020204@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbZALOE3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2009 09:04:29 -0500
In-Reply-To: <496B4067.1020204@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Hi Stefan,

Stefan Richter wrote:
> Hannes Reinecke wrote:
>> Micha=B3 Miros=B3aw wrote:
>>> --- a/drivers/scsi/scsi_sysfs.c
>>> +++ b/drivers/scsi/scsi_sysfs.c
>>> @@ -872,12 +872,12 @@ int scsi_sysfs_add_sdev(struct scsi_device *s=
dev)
>>>  	error =3D device_add(&sdev->sdev_gendev);
>>>  	if (error) {
>>>  		put_device(sdev->sdev_gendev.parent);
>>> -		printk(KERN_INFO "error 1\n");
>>> +		printk(KERN_ERR "sysfs: SCSI device registration failed: %d\n", =
error);
>> Shouldn't that be sdev_printk()?
>=20
> It seems it shouldn't.  sdev_printk() wants device name and bus ID of
> the sdev_gendev.  AFAICS device_add() initializes them, and callers o=
f
> device_add() can't be quite sure how far device_add() got before an e=
rror.
>=20
Hmm. True.

Easiest way would be to remove the printk altogether, as a failure of
device_add() will print out enough warnings as it stands.
To be precise you get something like

------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x33/0x3a()
sysfs: duplicate filename '4:0:1:0' can not be created
=2E..
---[ end trace dac6dbc3f072e760 ]---

and

kobject_add_internal failed for 4:0:1:0 with -EEXIST, don't try to regi=
ster things with the same name in the same directory.
Pid: 2693, comm: scsi_wq_4 Tainted: G        W 2.6.27.10-20090109 #2
=2E..

so we have enough information already.

>>>  		return error;
>>>  	}
>>>  	error =3D device_add(&sdev->sdev_dev);
>>>  	if (error) {
>>> -		printk(KERN_INFO "error 2\n");
>>> +		printk(KERN_ERR "sysfs: SCSI class device registration failed: %=
d\n", error);
>> Same here ...
>=20
> At that point, sdev_printk() should work indeed.
But it'll spawn a similar error as above, so we
could remove it here, too.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
