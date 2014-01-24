From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 1/6] megaraid_sas: Do not wait forever
Date: Fri, 24 Jan 2014 08:34:54 +0000
Message-ID: <d02c587fc2dd4e83b6f87d957c2344e7@BN1PR07MB247.namprd07.prod.outlook.com>
References: <1389867936-118685-1-git-send-email-hare@suse.de>
 <1389867936-118685-2-git-send-email-hare@suse.de>
 <ed5d620b461a4d918b00ab18553618dd@BN1PR07MB247.namprd07.prod.outlook.com>
 <52E22320.4060603@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:3604
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752128AbaAXIe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2014 03:34:57 -0500
In-Reply-To: <52E22320.4060603@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adam Radford <aradford@gmail.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, January 24, 2014 1:54 PM
> To: Desai, Kashyap; James Bottomley
> Cc: linux-scsi@vger.kernel.org; Adam Radford; Saxena, Sumit
> Subject: Re: [PATCH 1/6] megaraid_sas: Do not wait forever
>=20
> On 01/24/2014 08:46 AM, Desai, Kashyap wrote:
> > Hannes:
> >
> > We have already worked on "wait_event" usage in
> "megasas_issue_blocked_cmd".
> > That code will be posted  by LSI once we received test result from
> LSI Q/A team.
> >
> > If you see the current OCR code in Linux Driver we do "re-send the =
IOCTL
> command".
> > MR product does not want IOCTL timeout due to some reason. That is =
why
> > even if FW faulted, Driver will do OCR and re-send all existing
> <Management commands>
> > (IOCTL comes under management commands).
> >
> > Just for info. (see below snippet in  OCR code)
> >
> > /* Re-fire management commands */
> >                         for (j =3D 0 ; j < instance->max_fw_cmds; j=
++) {
> >                                 cmd_fusion =3D fusion->cmd_list[j];
> >                                 if (cmd_fusion->sync_cmd_idx !=3D (=
u32)ULONG_MAX) {
> >                                         cmd_mfi =3D instance->cmd_l=
ist[cmd_fusion-
> >sync_cmd_idx];
> >                                         if (cmd_mfi->frame->dcmd.op=
code =3D=3D
> MR_DCMD_LD_MAP_GET_INFO) {
> >                                                 megasas_return_cmd(=
instance, cmd_mfi);
> >
> > megasas_return_cmd_fusion(instance, cmd_fusion);
> >
> >
> >
> > Current <MR> Driver is not designed to add <timeout> for DCMD and I=
OCTL
> path.
> > [ I added timeout only for limited DCMDs, which are harmless to
> continue after timeout ]
> >
> > As of now, you can skip this patch and we will be submitting patch =
to fix
> similar issue.
> > But note, we cannot add complete "wait_event_timeout" due to day-1
> > design, but will try to cover wait_event_timout for some valid case=
s.
> >
> Ouch.
>=20
> The reason I sent this patch is that I've got an Intel box here, whic=
h blocks
> megaraid_sas initialisation when the IOMMU is turned on:
>=20
> [   21.867264] megasas: io_request_frames ffff880800f50000
> [   21.867363] megasas: init frame 00000000fff57000
> [   22.223234] megasas: frame status 00
> [   22.223235] megasas: IOC Init cmd success
> [   22.223282] megasas: ld map ffff88080b600000
> [   22.223289] megasas: issue dcmd 05 opcode 300e101
> [   22.244184] dmar: DRHD: handling fault status reg 2
> [   22.244186] dmar: DMAR:[DMA Read] Request device [06:00.0] fault
> addr 6980000
> [   22.244186] DMAR:[fault reason 06] PTE Read access is not set
> [   22.247223] megasas: frame status 00
> [   22.247231] megasas: issue dcmd 05 opcode 300e101
> [   22.247231] megasas: INIT adapter done
> [   22.247237] megasas: pd list ffff88080cfd0000 size 8192
> [   22.247237] megasas: issue dcmd 05 opcode 2010100
> [   22.253516] dmar: DRHD: handling fault status reg 102
> [   22.253518] dmar: DMAR:[DMA Write] Request device [06:00.0] fault
> addr e3f0000
> [   22.253518] DMAR:[fault reason 05] PTE Write access is not set
> [   22.253521] dmar: DMAR:[DMA Write] Request device [06:00.0] fault
> addr e3f0000
> [   22.253521] DMAR:[fault reason 05] PTE Write access is not set
> [   22.253523] dmar: DMAR:[DMA Write] Request device [06:00.0] fault
> addr e3f0000
>=20
> [ Some more DMAR messages snipped ]
>=20
> [   22.273199] dmar: DRHD: handling fault status reg 2
> [   22.273201] dmar: DMAR:[DMA Read] Request device [06:00.0] fault
> addr 6cef000
> [   22.273201] DMAR:[fault reason 06] PTE Read access is not set
>=20
> [ .. ]
>=20
> [   94.222456] megasas: frame status ff
> [   94.240946] megasas: failed to get PD list
>=20
> (I've inserted some debugging messages :-)
>=20
> This is really weird. The 'write' faults do correspond with the numbe=
r of
> (megaraid) commands, reserved at the initial step.
> (This is a 'Fury' card, btw).

=46ury card has iMR FW and we have seen issue with iMR FW if IOMMU is O=
N, but not like driver load failure.
Is your OS driver behind Fury ? What is a Raid type used on your setup =
?

Which system you are using ?=20

> What is more puzzling is that the INIT command and the initial LD Lis=
t
> command goes through, but the PD List command gets blocked.
>=20
> Incidentally, this is not consistent; occasionally even the LD List c=
ommand
> gets blocked, and the DMAR messages occur earlier.

LD command use megasas_issue_polled which is already timeout based mech=
anism.
Below are list of DCMD command which use infinite timeout.

megasas_get_seq_num
megasas_flush_cache
megasas_shutdown_controller
megasas_mgmt_fw_ioctl=20


We can convert all DCMD except IOCTL with timeout value. For you " mega=
sas_get_seq_num" might be hang in FW. It cannot be " megasas_get_ld_lis=
t".


>=20
> Anyway. Point is, if we cannot timout these initial commands the
> megaraid_sas driver will be stuck during initialisation (as the loop =
_never_
> terminates).
> Which in turn means that the modprobe command hangs indefinitely, and
> you cannot even unload the module.
> The only way to recover here is a reboot.
> Nasty.
>=20
> Hence the patch for the timeout; when this triggers the HBA is pretty=
 much
> hosed anyway, so the state of the firmware is pretty much irrelevant =
here.
> But at least you can continue to boot.
>=20
> (And OCR doesn't work at this point, neither. But that's a different =
story).
>=20
> Cheers,
>=20
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
