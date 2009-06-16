From: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Return of PENDING status to SCSI driver
Date: Tue, 16 Jun 2009 19:05:27 +0530
Message-ID: <3e7aae30906160635g4d191a4exdb710554a349cac0@mail.gmail.com>
References: <4A363EB4.8000102@panasas.com>
	 <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>
	 <3e7aae30906150707we781237o366950971d748b6f@mail.gmail.com>
	 <4A365BBE.3010708@panasas.com>
	 <3e7aae30906150742l18e74a8fua5f08686c2c76454@mail.gmail.com>
	 <4A36776C.5010208@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4A36776C.5010208-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

> This is bulshit. Get your act together babe. You are hacking and deri=
ving from
>  GPLed code. You are legally bind by that.
>
>  But you are welcome to remove any lowlevel rocket science from your =
driver
>  and just post the Linux relevant things. Infact why don't you start =
with a
>  demo driver that just emulates in SW IO transfers close to what your=
 driver
>  will do. scsi_debug is a good place to look.
>
>
>  > But Still I am confused with return status (to SCSI layer) for the
>  > command while it is in progress, to get the next command. Is it so=
me
>  > thing like PENDING?
>  >
>
>
> Look in scsi_debug enable some prints. It queues and completes cmnds
>  asynchronously. Look in Alan's other mail I think you are hit with t=
he
>  usb queue_command posting the commands to a thread. This is unique t=
o
>  usb.
>
>  > -RD
>
>
>  Boaz
>

At this stage, I can not reveal the complete code without my client=92s
permission. But the entire code will be made public (According to GPL)
once driver is completed.

But here I am pasting the template structure code that I am using in my=
 driver.

struct scsi_host_template usb_stor_host_template =3D {
	/* basic userland interface stuff */
	.name =3D				"usb-storage",
	.proc_name =3D			"usb-storage",
	.proc_info =3D			proc_info,
	.info =3D				host_info,

	/* command interface -- queued only */
	.queuecommand =3D			queuecommand,

	/* error and abort handlers */
	.eh_abort_handler =3D		command_abort,
	.eh_device_reset_handler =3D	device_reset,
	.eh_bus_reset_handler =3D		bus_reset,

	/* queue commands only, only one command per LUN */
	.can_queue =3D			5,
	.cmd_per_lun =3D			5,

	/* unknown initiator id */
	.this_id =3D			-1,

	.slave_alloc =3D			slave_alloc,
	.slave_configure =3D		slave_configure,

	/* lots of sg segments can be handled */
	.sg_tablesize =3D			SG_ALL,

	/* limit the total size of a transfer to 120 KB */
	.max_sectors =3D                  240,

	/* merge commands... this seems to help performance, but
	 * periodically someone should test to see which setting is more
	 * optimal.
	 */
	.use_clustering =3D		1,

	/* emulated HBA */
	.emulated =3D			5,

	/* we do our own delay after a device or bus reset */
	.skip_settle_delay =3D		1,

	/* sysfs device attributes */
	.sdev_attrs =3D			sysfs_device_attr_list,

	/* module management */
	.module =3D			THIS_MODULE
};


Here I am giving some portion of the data structure us_data I am using

struct us_data {
=09
	.......
=09
	/* SCSI interfaces */
	struct scsi_cmnd	*srb[5];		 /* current srb		*/
	unsigned int		tag[5];		 /* current dCBWTag	*/

	...continued.

}

If I call void (*done)(struct scsi_cmnd *) call back immediately after
receiving a command, will I get another command ?


Regards,
RD
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
