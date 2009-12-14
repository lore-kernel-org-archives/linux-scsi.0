From: Tomas Ebenlendr <ebik@jyxo.com>
Subject: Re: Problem with disks shutting down at random
Date: Mon, 14 Dec 2009 14:17:00 +0100
Message-ID: <20091214141700.46318975@ebiz.jyxo.com>
References: <26198.87.210.74.220.1260785226.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kajo.jyxo.com ([195.122.208.215]:43207 "EHLO mail1.jyxo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbZLNNXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2009 08:23:06 -0500
In-Reply-To: <26198.87.210.74.220.1260785226.squirrel@ketsers.dhs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: linux-scsi@vger.kernel.org

At first, try to NOT use smart (smartctl). I do not know how smart goes
with your controller, but it caused similar bug here. (Monitoring tool
was launching smartctl every 5 minutes. The disks vere kicked off at
xx:x0:00 or at xx:x5:00.)

On Mon, 14 Dec 2009 11:07:06 +0100 (CET)
"Caspar Smit" <c.smit@truebit.nl> wrote:

>=20
>=20
> Hi,
>=20
> I already posted this on the linux-ide mailinglist but that
> didn't end up with a solution and/or cause to this problem.
>=20
> I'm
> having a problem where a harddisk (not always the same) randomly shut=
s
> down and is disconnected from the linux kernel. In other words I have=
 to
> reboot the system or physically unplug/replug the disk to get it to w=
ork
> again. As stated this will happen to different disk at different time=
s.
>=20
> I will provide my configuration:
>=20
> SuperMicro
> SC-216
> chassis (24 bay 2,5" disks)
> 24x Seagate ST9500420AS 500Gb
> 7200 RPM Hard Drives
> 3x SuperMicro AOC-SAT2-MV8 (SATA Controller
> using the sata_mv kernel driver)
>=20
> I use Debian Lenny 5.0
> and
> kernel: linux-image-2.6.30-bpo.2-amd64
> (2.6.30-8~bpo50+1)
> from the
> backports repository.
>=20
> The symptom is that after a
> while of
> operation a disk is shut down and kicked out of a RAID set.
> It doesn't matter if there is load or not on the system.
>=20
> The
> logging
> says:
>=20
> sd 11:0:0:0: [sdk] Unhandled error code
> sd 11:0:0:0:
> Result: hostbyte=3DDID_BAD_TARGET
> driverbyte=3DDRIVER_OK
> sd 11:0:0:0:
> end_request: I/O error, dev
> sdk, sector 0=20
>=20
> In this case sdk,
> but it happens to all
> disks.
> Then the disk is not readable by the
> system anymore.
>=20
> When I check the disk for errors
> (badblocks/smart) in another
> system it doesn't give any errors.
> I
> only have this with
> 2,5" systems.
>=20
> Is this a sata_mv
> problem? A disk
> problem? or anything else?
> I can provide more info if
> needed.
>=20
> From the kern.log:
> Saeed Bishara replied to my kern.log with
> the following.
>=20
> the following lines from the kern.log:
> Nov 24 23:03:23
> supernas02 kernel: [131523.808631] ata19.00: exception
> Emask 0x0 SAct
> 0x0 SErr 0x0 action 0x6 frozen
> Nov 24 23:03:23 supernas02 kernel:
> [131523.808690] ata19.00: cmd
> b0/da:00:00:4f:c2/00:00:00:00:00/00 tag
> 0
> Nov 24 23:03:23 supernas02 kernel: [131523.808691]          res
> 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> Nov 24
> 23:03:23 supernas02 kernel: [131523.808770] ata19.00: status: { DRDY =
}
> Nov 24 23:03:23 supernas02 kernel: [131523.808801] ata19: hard resett=
ing
> link
> Nov 24 23:03:28 supernas02 kernel: [131529.324010] ata19: link
> is slow
> to respond, please be patient (ready=3D0)
> Nov 24 23:03:33
> supernas02 kernel: [131533.860010] ata19: SRST failed
> (errno=3D-16)
> Nov 24 23:03:33 supernas02 kernel: [131533.860038] ata19: hard resett=
ing
> link
> Nov 24 23:03:38 supernas02 kernel: [131539.376009] ata19: link
> is slow
> to respond, please be patient (ready=3D0)
> Nov 24 23:03:43
> supernas02 kernel: [131543.912006] ata19: SRST failed
> (errno=3D-16)
> Nov 24 23:03:43 supernas02 kernel: [131543.912033] ata19: hard resett=
ing
> link
> Nov 24 23:03:48 supernas02 kernel: [131549.428010] ata19: link
> is slow
> to respond, please be patient (ready=3D0)
> Nov 24 23:04:18
> supernas02 kernel: [131578.940012] ata19: SRST failed
> (errno=3D-16)
> Nov 24 23:04:18 supernas02 kernel: [131578.940048] ata19: limiting
> SATA link speed to 1.5 Gbps
> Nov 24 23:04:18 supernas02 kernel:
> [131578.940077] ata19: hard resetting link
> Nov 24 23:04:23 supernas02
> kernel: [131583.952009] ata19: SRST failed
> (errno=3D-16)
> Nov 24
> 23:04:23 supernas02 kernel: [131583.958191] ata19: reset
> failed,
> giving up
> Nov 24 23:04:23 supernas02 kernel: [131583.958218]
> ata19.00: disabled
> Nov 24 23:04:23 supernas02 kernel: [131583.958253]
> ata19: EH complete
>=20
> means that a timeout error occurred, the
> after then, the disk didn't respond.
> is it the same disks that fails
> all the time?
> ---
> As I said it doesn't happen to the same
> disk.
>=20
> Anyone knows where to look for a cause for this problem?
>=20
> Kind
> regards,
> Caspar Smit
>=20
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
                                               Tom=C3=A1=C5=A1 Ebenlend=
r
					       Jyxo s r.o.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
