From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid: kernel NULL pointer dereference
Date: Wed, 13 Apr 2005 13:24:30 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B010AA69D@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:64469 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261155AbVDMRYe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 13:24:34 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>, =?iso-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This is a can't happen, as aac_cfg_open should have reported an (-ENODE=
V) error when it found no matching controller device ...

Sincerely -- Mark Salyzyn

-----Original Message-----
=46rom: Mark Haverkamp [mailto:markh@osdl.org]=20
Sent: Wednesday, April 13, 2005 12:59 PM
To: Ralf M=FCller
Cc: linux-scsi; Salyzyn, Mark
Subject: Re: aacraid: kernel NULL pointer dereference

On Wed, 2005-04-13 at 18:02 +0200, Ralf M=FCller wrote:
> I currently try to set up a server with an Adaptec 2810SA RAID contro=
ller.
> While testing the Adaptec command line utility aacraid (actually the
> command "controller list") with a vanilla 2.6.12-rc2 kernel I got the
> following kernel oops - maybe someone is interested, maybe someone as
> some help for me:

I was able to reproduce this on my machine.  What I found was that if I
had some aacX devices in /dev that didn't exist that I got this fault.
You may try, as a work around for now, to delete any aac devices in /de=
v
that don't really exist and see it that helps.

Mark.


>=20
> Unable to handle kernel NULL pointer dereference at virtual address 0=
000002c
>  printing eip:
> c02e62fa
> *pde =3D 00000000
> Oops: 0002 [#1]
> PREEMPT SMP
> Modules linked in: nvram ipv6 speedstep_lib freq_table processor edd =
evdev joydev st sr_mod af_packet sg 3c59x mii ehci_hcd uhci_hcd e1000 u=
sbcore i2c_i801 i2c_core intel_agp agpgart parport_pc lp parport video1=
394 ohci1394 raw1394 ieee1394 capability commoncap dm_mod reiserfs ide_=
cd cdrom ide_disk aacraid piix ide_core sd_mod scsi_mod
> CPU:    0
> EIP:    0060:[<c02e62fa>]    Not tainted VLI
> EFLAGS: 00010046   (2.6.12-rc2-smp)
> EIP is at _spin_lock_irqsave+0x1a/0x80
> eax: 00000000   ebx: 0000002c   ecx: 00000001   edx: 00000286
> esi: f6116000   edi: 0000002c   ebp: bf8a4440   esp: f6117f34
> ds: 007b   es: 007b   ss: 0068
> Process aaccli (pid: 6691, threadinfo=3Df6116000 task=3Df5f18a60)
> Stack: 00042008 00000000 f886980f 00042008 00000000 00000000 f886888d=
 00042008
>        bf8a4440 00000000 bf8a4440 f8869243 f88708a0 f5331d80 ffffffe7=
 c0170888
>        bf8a4440 00042008 00000000 f5331d80 00000005 f6116000 c0170a05=
 f6116000
> Call Trace:
>  [<f886980f>] fib_alloc+0xf/0x60 [aacraid]
>  [<f886888d>] ioctl_send_fib+0xd/0x100 [aacraid]
>  [<f8869243>] aac_do_ioctl+0xb3/0xb8 [aacraid]
>  [<c0170888>] do_ioctl+0x48/0x70
>  [<c0170a05>] vfs_ioctl+0x55/0x1d0
>  [<c0170bc6>] sys_ioctl+0x46/0x60
>  [<c01040cb>] sysenter_past_esp+0x54/0x79
> Code: eb db e8 9a ef ff ff eb c0 90 8d b4 26 00 00 00 00 56 53 89 c3 =
b8 01 00 00 00 e8 12 65 e3 ff be 00 e0 ff ff 21 e6 9c 5a fa 31 c0 <86> =
03 84 c0 7e 0c c7 43 04 00 00 00 00 89 d0 5b 5e c3 52 9d b8
>  <6>note: aaccli[6691] exited with preempt_count 1
>=20
> The system is a newly installed SuSE 9.3. If you need more
> information - please ask.
>=20
> Regard
> Ralf
>=20
--=20
Mark Haverkamp <markh@osdl.org>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
