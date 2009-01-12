From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Make errors printed from scsi_sysfs_add_sdev() mean something.
Date: Mon, 12 Jan 2009 14:06:47 +0100
Message-ID: <496B4067.1020204@s5r6.in-berlin.de>
References: <20081223221859.GA541@rere.qmqm.pl> <496B37C8.3010705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:41642 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZALNHn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2009 08:07:43 -0500
In-Reply-To: <496B37C8.3010705@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> Micha=B3 Miros=B3aw wrote:
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -872,12 +872,12 @@ int scsi_sysfs_add_sdev(struct scsi_device *sd=
ev)
>>  	error =3D device_add(&sdev->sdev_gendev);
>>  	if (error) {
>>  		put_device(sdev->sdev_gendev.parent);
>> -		printk(KERN_INFO "error 1\n");
>> +		printk(KERN_ERR "sysfs: SCSI device registration failed: %d\n", e=
rror);
> Shouldn't that be sdev_printk()?

It seems it shouldn't.  sdev_printk() wants device name and bus ID of
the sdev_gendev.  AFAICS device_add() initializes them, and callers of
device_add() can't be quite sure how far device_add() got before an err=
or.

>>  		return error;
>>  	}
>>  	error =3D device_add(&sdev->sdev_dev);
>>  	if (error) {
>> -		printk(KERN_INFO "error 2\n");
>> +		printk(KERN_ERR "sysfs: SCSI class device registration failed: %d=
\n", error);
> Same here ...

At that point, sdev_printk() should work indeed.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D--=3D ---=3D -=3D=3D--
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
