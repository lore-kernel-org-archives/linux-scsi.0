From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/6] megaraid_sas: Do not wait forever
Date: Fri, 24 Jan 2014 09:24:00 +0100
Message-ID: <52E22320.4060603@suse.de>
References: <1389867936-118685-1-git-send-email-hare@suse.de> <1389867936-118685-2-git-send-email-hare@suse.de> <ed5d620b461a4d918b00ab18553618dd@BN1PR07MB247.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45137 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaAXIYD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jan 2014 03:24:03 -0500
In-Reply-To: <ed5d620b461a4d918b00ab18553618dd@BN1PR07MB247.namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adam Radford <aradford@gmail.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>

On 01/24/2014 08:46 AM, Desai, Kashyap wrote:
> Hannes:
>=20
> We have already worked on "wait_event" usage in "megasas_issue_blocke=
d_cmd".
> That code will be posted  by LSI once we received test result from
LSI Q/A team.
>=20
> If you see the current OCR code in Linux Driver we do "re-send the IO=
CTL command".
> MR product does not want IOCTL timeout due to some reason. That is wh=
y even if
> FW faulted, Driver will do OCR and re-send all existing
<Management commands>
> (IOCTL comes under management commands).
>=20
> Just for info. (see below snippet in  OCR code)
>=20
> /* Re-fire management commands */
>                         for (j =3D 0 ; j < instance->max_fw_cmds; j++=
) {
>                                 cmd_fusion =3D fusion->cmd_list[j];
>                                 if (cmd_fusion->sync_cmd_idx !=3D (u3=
2)ULONG_MAX) {
>                                         cmd_mfi =3D instance->cmd_lis=
t[cmd_fusion->sync_cmd_idx];
>                                         if (cmd_mfi->frame->dcmd.opco=
de =3D=3D MR_DCMD_LD_MAP_GET_INFO) {
>                                                 megasas_return_cmd(in=
stance, cmd_mfi);
>                                                 megasas_return_cmd_fu=
sion(instance, cmd_fusion);
>=20
>=20
>=20
> Current <MR> Driver is not designed to add <timeout> for DCMD and IOC=
TL path.
> [ I added timeout only for limited DCMDs, which are harmless to
continue after timeout ]
>=20
> As of now, you can skip this patch and we will be submitting patch to=
 fix similar issue.
> But note, we cannot add complete "wait_event_timeout" due to day-1 de=
sign, but will
> try to cover wait_event_timout for some valid cases.
>=20
Ouch.

The reason I sent this patch is that I've got an Intel box here,
which blocks megaraid_sas initialisation when the IOMMU is turned on:

[   21.867264] megasas: io_request_frames ffff880800f50000
[   21.867363] megasas: init frame 00000000fff57000
[   22.223234] megasas: frame status 00
[   22.223235] megasas: IOC Init cmd success
[   22.223282] megasas: ld map ffff88080b600000
[   22.223289] megasas: issue dcmd 05 opcode 300e101
[   22.244184] dmar: DRHD: handling fault status reg 2
[   22.244186] dmar: DMAR:[DMA Read] Request device [06:00.0] fault
addr 6980000
[   22.244186] DMAR:[fault reason 06] PTE Read access is not set
[   22.247223] megasas: frame status 00
[   22.247231] megasas: issue dcmd 05 opcode 300e101
[   22.247231] megasas: INIT adapter done
[   22.247237] megasas: pd list ffff88080cfd0000 size 8192
[   22.247237] megasas: issue dcmd 05 opcode 2010100
[   22.253516] dmar: DRHD: handling fault status reg 102
[   22.253518] dmar: DMAR:[DMA Write] Request device [06:00.0] fault
addr e3f0000
[   22.253518] DMAR:[fault reason 05] PTE Write access is not set
[   22.253521] dmar: DMAR:[DMA Write] Request device [06:00.0] fault
addr e3f0000
[   22.253521] DMAR:[fault reason 05] PTE Write access is not set
[   22.253523] dmar: DMAR:[DMA Write] Request device [06:00.0] fault
addr e3f0000

[ Some more DMAR messages snipped ]

[   22.273199] dmar: DRHD: handling fault status reg 2
[   22.273201] dmar: DMAR:[DMA Read] Request device [06:00.0] fault
addr 6cef000
[   22.273201] DMAR:[fault reason 06] PTE Read access is not set

[ .. ]

[   94.222456] megasas: frame status ff
[   94.240946] megasas: failed to get PD list

(I've inserted some debugging messages :-)

This is really weird. The 'write' faults do correspond with the
number of (megaraid) commands, reserved at the initial step.
(This is a 'Fury' card, btw).
What is more puzzling is that the INIT command and the initial
LD List command goes through, but the PD List command gets blocked.

Incidentally, this is not consistent; occasionally even the LD List
command gets blocked, and the DMAR messages occur earlier.

Anyway. Point is, if we cannot timout these initial commands
the megaraid_sas driver will be stuck during initialisation (as the
loop _never_ terminates).
Which in turn means that the modprobe command hangs indefinitely,
and you cannot even unload the module.
The only way to recover here is a reboot.
Nasty.

Hence the patch for the timeout; when this triggers the HBA is
pretty much hosed anyway, so the state of the firmware is pretty
much irrelevant here. But at least you can continue to boot.

(And OCR doesn't work at this point, neither. But that's a different
story).

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
