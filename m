From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: usb-storage: fix typo
Date: Thu, 23 Jan 2003 11:40:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123114040.B12788@one-eyed-alien.net>
References: <20030119143058.A31114@one-eyed-alien.net> <20030119171602.D31114@one-eyed-alien.net> <20030123044306.GA6584@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030123044306.GA6584@kroah.com>; from greg@kroah.com on Wed, Jan 22, 2003 at 08:43:06PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Linux SCSI list <linux-scsi@vger.kernel.org>


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Well, it's stored in my local tree as a large series of deltas.  But I'd
settle for just being able to boot the kernel with debugging enabled and
try it myself.

The problem is, it doesn't make any sense if split up into smaller pieces.
The change from old hotplug system to new hotplug system really is one
package.  I mean, I could send you the delta where I convert the probe
mechanism to use the new system, but then it's just going to blow up when a
device is detached.

I'll keep working on getting a booting configuration.  Some people have
suggested turning off framebuffer support, but that's already off....

Matt

On Wed, Jan 22, 2003 at 08:43:06PM -0800, Greg KH wrote:
> On Sun, Jan 19, 2003 at 05:16:02PM -0800, Matthew Dharm wrote:
> > This patch goes on top of the last one.  It fixes a typo in the test for
> > scsi_register() failure.
>=20
> With these two patches applied, when plugging in a usb-storage device I
> get the following oops.  So I've backed the changes out :)
>=20
> Any thoughts of splitting them up into smaller pieces to try to figure
> out where the problem would be?
>=20
> thanks,
>=20
> greg k-h
>=20
>=20
> drivers/usb/host/uhci-hcd.c: 1c20: wakeup_hc
> hub 1-0:0: port 1, status 101, change 1, 12 Mb/s
> hub 1-0:0: debounce: port 1: delay 100ms stable 4 status 0x101
> hub 1-0:0: new USB device on port 1, assigned address 2
> usb 1-1: new device strings: Mfr=3D73, Product=3D90, SerialNumber=3D110
> usb 1-1: Product: USB Storage Adapter
> usb 1-1: Manufacturer: In-System Design
> usb 1-1: SerialNumber: 1300E00000DEEF2E
> DEV: registering device: ID =3D '1-1', name =3D USB Storage Adapter (In-S=
ystem Design)
> kobject 1-1: registering. parent: usb1, set: devices
> bus usb: add device 1-1
> bound device '1-1' to driver 'usb'
> dev_hotplug
> do_hotplug
> fill_devpath: path =3D 'devices/pci0/00:07.2/usb1/1-1'
> drivers/usb/core/usb.c: usb_hotplug
> do_hotplug: /sbin/hotplug usb HOME=3D/ PATH=3D/sbin:/bin:/usr/sbin:/usr/b=
in ACTION=3Dadd DEVPATH=3Ddevices/pci0/00:07.2/usb1/1-1
> usb 1-1: usb_new_device - registering interface 1-1:0
> DEV: registering device: ID =3D '1-1:0', name =3D usb-00:07.2-1 interface=
 0
> kobject 1-1:0: registering. parent: 1-1, set: devices
> bus usb: add device 1-1:0
> usb-storage 1-1:0: usb_device_probe
> usb-storage 1-1:0: usb_device_probe - got id
> scsi0 : SCSI emulation for USB Mass Storage devices
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
0b8
>  printing eip:
> c88b1023
> *pde =3D 00000000
> Oops: 0000
> CPU:    0
> EIP:    0060:[<c88b1023>]    Not tainted
> EFLAGS: 00010097
> EIP is at usb_storage_queuecommand+0x13/0x3774eff0 [usb_storage]
> eax: c7f6f440   ebx: 00000297   ecx: c569ae00   edx: 00000000
> esi: c569ae00   edi: c7f6f440   ebp: 00000000   esp: c55cbbf4
> ds: 007b   es: 007b   ss: 0068
> Process khubd (pid: 990, threadinfo=3Dc55ca000 task=3Dc6a80120)
> Stack: c88995e7 c569ae00 c8899ab0 c569a88c c7f6f440 c569aa00 c55cbc2c c88=
9e640=20
>        c569ae00 c569ae00 c569ae00 c569a88c c569ac00 00000202 c569a800 c01=
b0147=20
>        c569ac00 c569ac00 c569a88c 00000001 00000000 c55cbc98 00001770 000=
00024=20
> Call Trace:
>  [<c88995e7>] scsi_dispatch_cmd+0xf7/0x37766b10 [scsi_mod]
>  [<c8899ab0>] scsi_done+0x0/0x37766550 [scsi_mod]
>  [<c889e640>] scsi_request_fn+0x1c0/0x37761b80 [scsi_mod]
>  [<c01b0147>] blk_insert_request+0x47/0x50
>  [<c889d8f4>] scsi_insert_special_req+0x24/0x37762730 [scsi_mod]
>  [<c88996d0>] scsi_wait_req+0x70/0x377669a0 [scsi_mod]
>  [<c8899000>] +0x0/0x37767000 [scsi_mod]
>  [<c889f36f>] scsi_probe_lun+0x4f/0x37760ce0 [scsi_mod]
>  [<c012f0f7>] kmalloc+0x77/0xa0
>  [<c889f7c4>] scsi_probe_and_add_lun+0x94/0x377608d0 [scsi_mod]
>  [<c889fab8>] scsi_scan_target+0x38/0x37760580 [scsi_mod]
>  [<c889fbac>] scsi_scan_host+0x4c/0x377604a0 [scsi_mod]
>  [<c889ac09>] __scsi_add_host+0x39/0x37765430 [scsi_mod]
>  [<c88a11e0>] +0x340/0x3775f160 [scsi_mod]
>  [<c88bbe20>] +0x40/0x37744220 [usb_storage]
>  [<c88b3d9e>] storage_probe+0x79e/0x3774ca00 [usb_storage]
>  [<c012f045>] kmem_cache_alloc+0x25/0x60
>  [<c88bf75c>] us_unusual_dev_list+0x7a8/0x3774104c [usb_storage]
>  [<c88bf828>] usb_storage_driver+0x88/0x37740860 [usb_storage]
>  [<c88bf7a0>] usb_storage_driver+0x0/0x37740860 [usb_storage]
>  [<c88bf7a0>] usb_storage_driver+0x0/0x37740860 [usb_storage]
>  [<c886212a>] usb_device_probe+0x10a/0x3779dfe0 [usbcore]
>  [<c88bef88>] storage_usb_ids+0x7a8/0x37741820 [usb_storage]
>  [<c88bef88>] storage_usb_ids+0x7a8/0x37741820 [usb_storage]
>  [<c88bf7b8>] usb_storage_driver+0x18/0x37740860 [usb_storage]
>  [<c8878900>] usb_bus_type+0x0/0x37787700 [usbcore]
>  [<c0199564>] bus_match+0x34/0x60
>  [<c88bf7ec>] usb_storage_driver+0x4c/0x37740860 [usb_storage]
>  [<c8878958>] usb_bus_type+0x58/0x37787700 [usbcore]
>  [<c01995e0>] device_attach+0x50/0x60
>  [<c88bf7b8>] usb_storage_driver+0x18/0x37740860 [usb_storage]
>  [<c8878940>] usb_bus_type+0x40/0x37787700 [usbcore]
>  [<c0199762>] bus_add_device+0x82/0xc0
>  [<c0198b28>] device_add+0xe8/0x130
>  [<c886e2d4>] +0xa8/0x37791dd4 [usbcore]
>  [<c8863441>] usb_new_device+0x4f1/0x3779d0b0 [usbcore]
>  [<c886fa20>] +0x6a0/0x37790c80 [usbcore]
>  [<c886e2d4>] +0xa8/0x37791dd4 [usbcore]
>  [<c886e415>] +0x1e9/0x37791dd4 [usbcore]
>  [<c0115f35>] __wake_up+0x15/0x30
>  [<c88653bd>] usb_hub_port_connect_change+0x27d/0x3779aec0 [usbcore]
>  [<c8870b00>] +0x1780/0x37790c80 [usbcore]
>  [<c886e9cd>] +0x7a1/0x37791dd4 [usbcore]
>  [<c886557d>] usb_hub_events+0x12d/0x3779abb0 [usbcore]
>  [<c88657e5>] usb_hub_thread+0x45/0x3779a860 [usbcore]
>  [<c0115e80>] default_wake_function+0x0/0x40
>  [<c8878a0c>] khubd_wait+0x4/0x377875f8 [usbcore]
>  [<c8878a0c>] khubd_wait+0x4/0x377875f8 [usbcore]
>  [<c88657a0>] usb_hub_thread+0x0/0x3779a860 [usbcore]
>  [<c0106f31>] kernel_thread_helper+0x5/0x14
>=20
> Code: 8b 82 b8 00 00 00 48 74 08 0f 0b 95 00 60 be 8b c8 8b 82 b0=20
>  <1>Unable to handle kernel NULL pointer dereference at virtual address 0=
00000b0
>  printing eip:
> c88b107d
> *pde =3D 00000000
> Oops: 0000
> CPU:    0
> EIP:    0060:[<c88b107d>]    Not tainted
> EFLAGS: 00010002
> EIP is at usb_storage_command_abort+0xd/0x3774ef90 [usb_storage]
> eax: 00000000   ebx: 00000202   ecx: 00002003   edx: c569ae00
> esi: c7f6f440   edi: c7f6f440   ebp: 00000000   esp: c5c95f6c
> ds: 007b   es: 007b   ss: 0068
> Process scsi_eh_0 (pid: 1038, threadinfo=3Dc5c94000 task=3Dc54d3240)
> Stack: c889cd13 c569ae00 c569ae00 c889cdec c569ae00 c7f6f440 c88a325b c88=
9d4a7=20
>        c569ae00 c7f6f440 c569ae00 c5c95fc4 c889d5eb c7f6f440 00000000 000=
00000=20
>        00000000 c5c95fd0 c5c95fd0 00000000 c55cbd14 c0108ae5 00000000 000=
00000=20
> Call Trace:
>  [<c889cd13>] scsi_try_to_abort_cmd+0x43/0x37763330 [scsi_mod]
>  [<c889cdec>] scsi_eh_abort_cmd+0x1c/0x37763230 [scsi_mod]
>  [<c88a325b>] +0x23bb/0x3775f160 [scsi_mod]
>  [<c889d4a7>] scsi_unjam_host+0x37/0x37762b90 [scsi_mod]
>  [<c889d5eb>] scsi_error_handler+0xbb/0x37762ad0 [scsi_mod]
>  [<c0108ae5>] ret_from_fork+0x5/0x14
>  [<c889d530>] scsi_error_handler+0x0/0x37762ad0 [scsi_mod]
>  [<c0106f31>] kernel_thread_helper+0x5/0x14
>=20
> Code: 39 90 b0 00 00 00 74 0b b8 03 20 00 00 c3 90 8d 74 26 00 50=20
> =20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You are needink to look more evil.  You likink very strong coffee?
					-- Pitr to Dust Puppy
User Friendly, 10/16/1998

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+MEU4IjReC7bSPZARAiYIAJsErcn/NSO3PA0HLaeD0lxh1DdXCACfUEN6
ALxahw6hZKstwXIkhiLDR+U=
=VsO9
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
