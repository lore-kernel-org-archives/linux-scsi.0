From: =?UTF-8?B?Q2zDoXVkaW8=?= Martins <ctpm@ist.utl.pt>
Subject: Re: mptsas hangs caused by ATA pass-through explained
Date: Tue, 1 Jun 2010 20:43:49 +0100
Message-ID: <20100601204349.e13fca3b.ctpm@ist.utl.pt>
References: <20100426231154.GB577@kspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.ist.utl.pt ([193.136.128.22]:34221 "EHLO smtp2.ist.utl.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab0FATtq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2010 15:49:46 -0400
In-Reply-To: <20100426231154.GB577@kspace.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Kuester <rkuester@kspace.net>
Cc: Eric Moore <Eric.Moore@lsi.com>, Kashyap Desai <kashyap.desai@lsi.com>, DL-MPTFusionLinux@lsi.com, support@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Mon, 26 Apr 2010 18:11:54 -0500 Ryan Kuester <rkuester@kspace.net> w=
rote:
> I may have an explanation for the LSI 1068 HBA hangs provoked by ATA
> pass-through commands, in particular by smartctl.
>=20
> First, my version of the symptoms.  On an LSI SAS1068E B3 HBA running
> 01.29.00.00 firmware, with SATA disks, and with smartd running, I'm s=
eeing
> occasional task, bus, and host resets, some of which lead to hard fau=
lts of
> the HBA requiring a reboot.  Abusively looping the smartctl command,
>=20
>     # while true; do smartctl -a /dev/sdb > /dev/null; done
>=20
> dramatically increases the frequency of these failures to nearly one =
per
> minute.  A high IO load through the HBA while looping smartctl seems =
to
> improve the chance of a full scsi host reset or a non-recoverable han=
g.
>=20
> I reduced what smartctl was doing down to a simple test case which
> causes the hang with a single IO when pointed at the sd interface.  S=
ee
> the code at the bottom of this e-mail.  It uses an SG_IO ioctl to iss=
ue
> a single pass-through ATA identify device command.  If the buffer
> userspace gives for the read data has certain alignments, the task is
> issued to the HBA but the HBA fails to respond.  If run against the s=
g
> interface, neither the test code nor smartctl causes a hang.
>=20
> sd and sg handle the SG_IO ioctl slightly differently.  Unless you
> specifically set a flag to do direct IO, sg passes a buffer of its ow=
n,
> which is page-aligned, to the block layer and later copies the result
> into the userspace buffer regardless of its alignment.  sd, on the ot=
her
> hand, always does direct IO unless the userspace buffer fails an
> alignment test at block/blk-map.c line 57, in which case a page-align=
ed
> buffer is created and used for the transfer.
>=20
> The alignment test currently checks for word-alignment, the default
> setup by scsi_lib.c; therefore, userspace buffers of almost any
> alignment are given directly to the HBA as DMA targets.  The LSI 1068
> hardware doesn't seem to like at least a couple of the alignments whi=
ch
> cross a page boundary (see the test code below).  Curiously, many
> page-boundary-crossing alignments do work just fine.
>=20
> So, either the hardware has an bug handling certain alignments or the
> hardware has a stricter alignment requirement than the driver is
> advertising.  If stricter alignment is required, then in no case shou=
ld
> misaligned buffers from userspace be allowed through without being
> bounced or at least causing an error to be returned.
>=20
> It seems the mptsas driver could use blk_queue_dma_alignment() to adv=
ertise
> a stricter alignment requirement.  If it does, sd does the right thin=
g and
> bounces misaligned buffers (see block/blk-map.c line 57).  The follow=
ing
> patch to 2.6.34-rc5 makes my symptoms go away.  I'm sure this is the =
wrong
> place for this code, but it gets my idea across.
>=20
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusi=
on/mptscsih.c
> index 6796597..1e034ad 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -2450,6 +2450,8 @@ mptscsih_slave_configure(struct scsi_device *sd=
ev)
>  		ioc->name,sdev->tagged_supported, sdev->simple_tags,
>  		sdev->ordered_tags));
> =20
> +	blk_queue_dma_alignment (sdev->request_queue, 512 - 1);
> +
>  	return 0;
>  }
>=20

 Hello,

 I have tested v2.6.34 on a box with 16 SATA disks attached to a
LSISAS1068E (through a port expander), with and without this patch:

 With vanilla 2.6.34 I can reliably reproduce controller timeouts both
with the example code provided by Ryan and with a simple loop like:

while : ; do for d in `ls /sys/block/ | grep sd` ; do smartctl -a /dev/=
$d ; done ; done

 The result are controller timeouts with the following kind of kernel m=
essages:

mptscsih: ioc0: attempting task abort! (sc=3Dffff8802be18dc00)
sd 4:0:2:0: [sdc] CDB: ATA command pass through(16): 85 08 0e 00 00 00 =
01 00 00 00 00 00 00 00 ec 00
mptbase: ioc0: LogInfo(0x31140000): Originator=3D{PL}, Code=3D{IO Execu=
ted}, SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff8802be18dc00)
mptbase: ioc0: LogInfo(0x31112000): Originator=3D{PL}, Code=3D{Reset}, =
SubCode(0x2000)
mptbase: ioc0: LogInfo(0x31120101): Originator=3D{PL}, Code=3D{Abort}, =
SubCode(0x0101)
mptscsih: ioc0: attempting task abort! (sc=3Dffff8802be18dc00)
sd 4:0:2:0: [sdc] CDB: Test Unit Ready: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31112000): Originator=3D{PL}, Code=3D{Reset}, =
SubCode(0x2000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff8802be18dc00)
mptscsih: ioc0: attempting target reset! (sc=3Dffff8802be18dc00)
sd 4:0:2:0: [sdc] CDB: ATA command pass through(16): 85 08 0e 00 00 00 =
01 00 00 00 00 00 00 00 ec 00
mptscsih: ioc0: target reset: SUCCESS (sc=3Dffff8802be18dc00)
mptbase: ioc0: LogInfo(0x31112000): Originator=3D{PL}, Code=3D{Reset}, =
SubCode(0x2000)
mptbase: ioc0: LogInfo(0x31120101): Originator=3D{PL}, Code=3D{Abort}, =
SubCode(0x0101)
mptscsih: ioc0: attempting task abort! (sc=3Dffff8802be18dc00)
sd 4:0:2:0: [sdc] CDB: Test Unit Ready: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31112000): Originator=3D{PL}, Code=3D{Reset}, =
SubCode(0x2000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff8802be18dc00)
mptscsih: ioc0: attempting bus reset! (sc=3Dffff8802be18dc00)
sd 4:0:2:0: [sdc] CDB: ATA command pass through(16): 85 08 0e 00 00 00 =
01 00 00 00 00 00 00 00 ec 00
mptscsih: ioc0: bus reset: SUCCESS (sc=3Dffff8802be18dc00)
mptbase: ioc0: LogInfo(0x31112000): Originator=3D{PL}, Code=3D{Reset}, =
SubCode(0x2000)
mptbase: ioc0: LogInfo(0x31120101): Originator=3D{PL}, Code=3D{Abort}, =
SubCode(0x0101)
mptbase: ioc0: LogInfo(0x31120101): Originator=3D{PL}, Code=3D{Abort}, =
SubCode(0x0101)
mptscsih: ioc0: attempting host reset! (sc=3Dffff8802be18dc00)
mptscsih: ioc0: host reset: SUCCESS (sc=3Dffff8802be18dc00)


 As described in

 https://bugzilla.kernel.org/show_bug.cgi?id=3D13594

 this can result in nasty side effects, like multiple drives getting
kicked out of an MD array.

 With Ryan's patch applied on top of v2.6.34 I cannot reproduce the
above problem with my simple script nor with Ryan's example.

 So, IMHO, this patch should be strongly considered for inclusion, or
else the root cause investigated further.

 So, as far as I can tell:

Tested-by: Cl=C3=A1udio Martins <ctpm@ist.utl.pt>

 I'm also glad to test any further patches, if it turns out that the
above is not the most correct fix for the issue.

 Thanks in advance.

 Best regards

Cl=C3=A1udio


> I look forward to hearing from you guys who know this hardware and co=
de
> better than I do.  Is the hardware at fault, or should the driver be
> shielding the hardware better?  Where's the right place to add this c=
ode, if
> it's the right fix?
>=20
> Does this `fix' the problem for anyone besides me?
>=20
> Regards,
> -- Ryan Kuester
>=20
>=20
> Here is a minimal bit of test code which causes the error.  BEWARE: t=
his
> will hose the HBA at which you point it.  If that's controlling your
> root disk, you may hang your machine.
>=20
> /*
>  * sg_bomb -- send SG_IO ioctl which causes LSI 1068 HBA to hang
>  *
>  *   usage: sg_bomb <device>
>  *    e.g.: sg_bomb /dev/sdb
>  *    e.g.: sg_bomb /dev/sg1
>  *
>  *   Modify offset_into_page to adjust the degree of buffer misalignm=
ent.
>  */
>=20
> #include <unistd.h>
> #include <scsi/sg.h>
> #include <sys/ioctl.h>
> #include <fcntl.h>
> #include <stdlib.h>
>=20
> int main(int argc, char* argv[])
> {
>     char* filename =3D argv[1];
>     unsigned int offset_into_page =3D 0xe40;
>     // works: unsigned int offset_into_page =3D 0x0;
>     // hangs: unsigned int offset_into_page =3D 0xf00;
>     // works: unsigned int offset_into_page =3D 0xf04;
>=20
>     unsigned char ata_identify_cmd[] =3D {0x85, 0x08, 0x0e, 0, 0, 0, =
0x01,
>         0, 0, 0, 0, 0, 0, 0, 0xec, 0};
>     unsigned char sense[32];
>     unsigned char* data =3D valloc(0x2000) + offset_into_page;
>     struct sg_io_hdr hdr =3D {
>         .interface_id =3D 'S',
>         .dxfer_direction =3D SG_DXFER_FROM_DEV,
>         .cmdp =3D ata_identify_cmd,
>         .cmd_len =3D 16,
>         .dxferp =3D data,
>         .dxfer_len =3D 512,
>         .sbp =3D sense,
>         .mx_sb_len =3D sizeof(sense),
>         .timeout =3D 5000,
>     };
>=20
>     int fd;
>     if ((fd =3D open(filename, O_RDWR|O_NONBLOCK)) < 0)=20
>         perror();
>=20
>     return ioctl(fd, SG_IO, &hdr);
> }
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
