From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Return of PENDING status to SCSI driver
Date: Tue, 16 Jun 2009 17:27:40 +0300
Message-ID: <4A37ABDC.4050308@panasas.com>
References: <4A363EB4.8000102@panasas.com>	 <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>	 <3e7aae30906150707we781237o366950971d748b6f@mail.gmail.com>	 <4A365BBE.3010708@panasas.com>	 <3e7aae30906150742l18e74a8fua5f08686c2c76454@mail.gmail.com>	 <4A36776C.5010208@panasas.com> <3e7aae30906160635g4d191a4exdb710554a349cac0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:28306
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751291AbZFPO1p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2009 10:27:45 -0400
In-Reply-To: <3e7aae30906160635g4d191a4exdb710554a349cac0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

On 06/16/2009 04:35 PM, Ramya Desai wrote:
>> This is bulshit. Get your act together babe. You are hacking and der=
iving from
>>  GPLed code. You are legally bind by that.
>>
>>  But you are welcome to remove any lowlevel rocket science from your=
 driver
>>  and just post the Linux relevant things. Infact why don't you start=
 with a
>>  demo driver that just emulates in SW IO transfers close to what you=
r driver
>>  will do. scsi_debug is a good place to look.
>>
>>
>>  > But Still I am confused with return status (to SCSI layer) for th=
e
>>  > command while it is in progress, to get the next command. Is it s=
ome
>>  > thing like PENDING?
>>  >
>>
>>
>> Look in scsi_debug enable some prints. It queues and completes cmnds
>>  asynchronously. Look in Alan's other mail I think you are hit with =
the
>>  usb queue_command posting the commands to a thread. This is unique =
to
>>  usb.
>>
>>  > -RD
>>
>>
>>  Boaz
>>
>=20
> At this stage, I can not reveal the complete code without my client=E2=
=80=99s
> permission. But the entire code will be made public (According to GPL=
)
> once driver is completed.
>=20

This is counter productive and stupid. If they are going to release the=
 code,
anyway, and there are no secrets, then the time to release it is now wh=
en
there are problems. When the driver is done and everything is working w=
e don't
need the code do we? it's during development that the code is important=
=2E When there
is nothing to do there is nothing to do.

> But here I am pasting the template structure code that I am using in =
my driver.
>=20
> struct scsi_host_template usb_stor_host_template =3D {
> 	/* basic userland interface stuff */
> 	.name =3D				"usb-storage",
> 	.proc_name =3D			"usb-storage",
> 	.proc_info =3D			proc_info,
> 	.info =3D				host_info,
>=20
> 	/* command interface -- queued only */
> 	.queuecommand =3D			queuecommand,

If this is the unchanged queuecommand from usb-storage then
this will not work. As explained

>=20
> 	/* error and abort handlers */
> 	.eh_abort_handler =3D		command_abort,
> 	.eh_device_reset_handler =3D	device_reset,
> 	.eh_bus_reset_handler =3D		bus_reset,

All these currently assume a single command how
did you change them?

>=20
> 	/* queue commands only, only one command per LUN */
> 	.can_queue =3D			5,
> 	.cmd_per_lun =3D			5,
>=20

Good

> 	/* unknown initiator id */
> 	.this_id =3D			-1,
>=20
> 	.slave_alloc =3D			slave_alloc,
> 	.slave_configure =3D		slave_configure,
>=20
> 	/* lots of sg segments can be handled */
> 	.sg_tablesize =3D			SG_ALL,
>=20
> 	/* limit the total size of a transfer to 120 KB */
> 	.max_sectors =3D                  240,
>=20
> 	/* merge commands... this seems to help performance, but
> 	 * periodically someone should test to see which setting is more
> 	 * optimal.
> 	 */
> 	.use_clustering =3D		1,
>=20
> 	/* emulated HBA */
> 	.emulated =3D			5,
>=20
> 	/* we do our own delay after a device or bus reset */
> 	.skip_settle_delay =3D		1,
>=20
> 	/* sysfs device attributes */
> 	.sdev_attrs =3D			sysfs_device_attr_list,
>=20
> 	/* module management */
> 	.module =3D			THIS_MODULE
> };
>=20
>=20
> Here I am giving some portion of the data structure us_data I am usin=
g
>=20
> struct us_data {
> =09
> 	.......
> =09
> 	/* SCSI interfaces */
> 	struct scsi_cmnd	*srb[5];		 /* current srb		*/
> 	unsigned int		tag[5];		 /* current dCBWTag	*/
>=20
> 	...continued.
>=20
> }
>=20
> If I call void (*done)(struct scsi_cmnd *) call back immediately afte=
r
> receiving a command, will I get another command ?
>=20

I think you miss understood:

done() can/usually be called asynchronously when you have results, good=
/bad,
of the executed command, and all memory has been consumed, (can be free=
d).

scsi will call .queuecommand upto min(can_queue, .cmd_per_lun) times
without any call to done(). Then for each done() called it will call
=2Equeuecommand again. (If more commands are pending)

So in short min(can_queue, .cmd_per_lun) is the maximum number of
commands queued at the target.

>=20
> Regards,
> RD

Above is all good. Your are doing something bad else where, which
you don't show us. Knowing the current USB code, then that is certainly
the culprit. Lots of places assume one command and other places behave
synchronously (ie. wait for response).

=46ree Life
Boaz
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
