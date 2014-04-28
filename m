From: Matthieu CASTET <matthieu.castet@parrot.com>
Subject: Re: Buffer I/O error after s2ram with usb storage
Date: Mon, 28 Apr 2014 15:01:39 +0200
Message-ID: <20140428150139.0e10dfd9@parrot.com>
References: <20140422160115.46d8d2bf@parrot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140422160115.46d8d2bf@parrot.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

any news on this.

Matthieu CASTET

Le Tue, 22 Apr 2014 16:01:15 +0200,
Matthieu CASTET <matthieu.castet@parrot.com> a =E9crit :

> Hi,
>=20
> while playing with suspend to ram I found a strange behavior with usb
> key.
>=20
> This can be easily reproduced by doing :
> - plug a usb key
> - start to read the usb key : "cat /dev/sdx > /dev/null"
> - go to suspend : "echo mem > /sys/power/state"
> - while in suspend, unplug and replug the usb key (simulate usb power
> loss for computer that keep power)
> - exit suspend
> - there is read error on the usb key
>=20
>=20
> Because the power was cut during s2ram, the usb stack reset the devic=
e
> <1>.
> When new data transfer are done, we got a UNIT_ATTENTION from the
> device <2> and IO error are returned to user space application.
>=20
> After some investigation it seems some (all on the 3 I tested) usb ke=
y
> report as removable, and scsi layer abort the transfer in case of
> UNIT_ATTENTION <3>.
>=20
> The usb storage driver call scsi_report_bus_reset after device reset,
> but because of commit dfcf7775 <4>, we don't ignore unit attention if
> "sshdr.asc =3D=3D 0x28 && sshdr.ascq =3D=3D 0x00" ("Not-ready to read=
y").
>=20
> If dfcf7775 is reverted there is no more Buffer I/O error.
>=20
> Is that possible to find a way to restore the behavior before dfcf777=
5
> commit (no Buffer I/O error after device reset) after a suspend to ra=
m ?
>=20
>=20
> Matthieu CASTET
>=20
> PS : the same error happen if sg_reset -b /dev/sdx is used on the
> device.
>=20
>=20
> <1>
> [  117.070255] usb 2-1.4: reset high-speed USB device number 3 using
> ehci-pci [...]
> [  117.543922] Restarting tasks ... done.
> [  117.548390] video LNXVIDEO:01: Restoring backlight state
> <2>
> [  117.549179] sd 6:0:0:0: [sdb] Media Changed
> [  117.549184] sd 6:0:0:0: [sdb] =20
> [  117.549187] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> [  117.549189] sd 6:0:0:0: [sdb] =20
> [  117.549191] Sense Key : Unit Attention [current]=20
> [  117.549195] Info fld=3D0x0
> [  117.549197] sd 6:0:0:0: [sdb] =20
> [  117.549201] Add. Sense: Not ready to ready change, medium may have
> changed [  117.549203] sd 6:0:0:0: [sdb] CDB:=20
> [  117.549205] Read(10): 28 00 00 02 c9 00 00 00 f0 00
> [  117.549212] end_request: I/O error, dev sdb, sector 182528
> [  117.549218] Buffer I/O error on device sdb1, logical block 22560
> [  117.549225] Buffer I/O error on device sdb1, logical block 22561
> [  117.549228] Buffer I/O error on device sdb1, logical block 22562
> [  117.549231] Buffer I/O error on device sdb1, logical block 22563
> [  117.549233] Buffer I/O error on device sdb1, logical block 22564
> [  117.549235] Buffer I/O error on device sdb1, logical block 22565
> [  117.549238] Buffer I/O error on device sdb1, logical block 22566
> [  117.549240] Buffer I/O error on device sdb1, logical block 22567
> [  117.549243] Buffer I/O error on device sdb1, logical block 22568
> [  117.549245] Buffer I/O error on device sdb1, logical block 22569
> [  117.809462] sd 6:0:0:0: [sdb] No Caching mode page found
> [  117.809470] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [  117.812696] sd 6:0:0:0: [sdb] No Caching mode page found
> [  117.812703] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [  117.813688]  sdb: sdb1
>=20
>=20
> <3>
>         case UNIT_ATTENTION:
>             if (cmd->device->removable) {
>                 /* Detected disc change.  Set a bit
>                  * and quietly refuse further access.
>                  */
>                 cmd->device->changed =3D 1;
>                 description =3D "Media Changed";
>                 action =3D ACTION_FAIL;
>             } else {
>                 /* Must have been a power glitch, or a
>                  * bus reset.  Could not have been a
>                  * media change, so we just retry the
>                  * command and see what happens.
>                  */
>                 action =3D ACTION_RETRY;
>             }
>=20
> <4>
> commit dfcf7775815504d13a1d273073810058caf84b9d
> Author: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
> Date:   Thu Aug 11 20:25:20 2011 +0900
>=20
>     [SCSI] Fix out of spec CD-ROM problem with media change
>    =20
>     Some CD-ROMs fail to report a media change correctly.  The specif=
ic
>     one for this patch simply fails to respond to commands, then give=
s a
>     UNIT ATTENTION after being reset which returns ASC/ASCQ 28/00.  T=
his
>     is out of spec behaviour, but add a check in the eat CC/UA on res=
et
>     path to catch this case so the CD-ROM will function somewhat prop=
erly.
>    =20
>     [jejb: fixed up white space and accepted without signoff]
>     Signed-off-by: James Bottomley <JBottomley@Parallels.com>
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index a4b9cdb..dc6131e 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -293,8 +293,16 @@ static int scsi_check_sense(struct scsi_cmnd *sc=
md)
>                  * so that we can deal with it there.
>                  */
>                 if (scmd->device->expecting_cc_ua) {
> -                       scmd->device->expecting_cc_ua =3D 0;
> -                       return NEEDS_RETRY;
> +                       /*
> +                        * Because some device does not queue unit
> +                        * attentions correctly, we carefully check
> +                        * additional sense code and qualifier so as
> +                        * not to squash media change unit attention.
> +                        */
> +                       if (sshdr.asc !=3D 0x28 || sshdr.ascq !=3D 0x=
00) {
> +                               scmd->device->expecting_cc_ua =3D 0;
> +                               return NEEDS_RETRY;
> +                       }
>                 }
>                 /*
>                  * if the device is in the process of becoming ready,=
 we
