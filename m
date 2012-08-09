From: "Parikh, Neerav" <neerav.parikh@intel.com>
Subject: RE: FC_PORTSPEED semantics confusion and zfcp regression
Date: Thu, 9 Aug 2012 19:29:22 +0000
Message-ID: <739353123C992A4C8800D77E2094259046D72566@ORSMSX101.amr.corp.intel.com>
References: <5023E206.2080104@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45283 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759223Ab2HIT30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Aug 2012 15:29:26 -0400
In-Reply-To: <5023E206.2080104@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Brattain, Ross B" <ross.b.brattain@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>, Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Steffen Maier
> Sent: Thursday, August 09, 2012 9:15 AM
> To: linux-scsi@vger.kernel.org
> Cc: Parikh, Neerav; Brattain, Ross B; Love, Robert W; James Bottomley=
;
> Martin Peschke; Daniel Hansel
> Subject: FC_PORTSPEED semantics confusion and zfcp regression
>=20
> Earlier, commit
> 1832a5862f2e1b4e5835611ee14bc30a8ed3cad5
> "[SCSI] change port speed definitions for scsi_transport_fc"
> changed the semantics of FC_PORTSPEED defines to match the Report Por=
t
> Speed Capabilities (RPSC) ELS of FC-GS/FS-LS instead of FC-HBA/SM-HBA=
=2E
> It also mentions the problem that FC-HBA/SM-HBA and FC-GS/FC-LS conta=
in
> somewhat contradicting bit definitions for port speed.
>=20
> Lately, commit
> a9277e7783651d4e0a849f7988340b1c1cf748a4
> "[SCSI] scsi_transport_fc: Getting FC Port Speed in sync with FC-GS"
> reverted this.
> (See also http://marc.info/?l=3Dlinux-scsi&m=3D132892310322550&w=3D2.=
)
>=20
> However, there does not seem to be an explicit explanation of this.
> While the source code comment of struct fc_host_attrs says its fields
> adhere to HBAAPI 2.0, the comment of the FC_PORTSPEED defines does no=
t
> explicitly do so and a (new) user of the latter might not see the
> relation to the structure fields, esp. since there is no obvious
> relation in terms of C types other than being type compatible to a
> generic int.
> The commit message also does not say so but mentions SM-HBA along wit=
h
> FC-GS without stating that they contradict themselves and FS-GS even
> within the same document since it defines both RPSC ELS and FDMI port
> attributes.
>=20
> 1) Is this change of semantics deliberate?
>=20
> The commit message of a9277e7 states that user space is not affected
> since it only sees text strings in the corresponding sysfs attributes=
=2E
>=20
> Actually, commit c3d2350a8420dbf9d48f5f8a0fb72117bfcbc1b0
> "[SCSI] fc_transport: update potential link speeds"
> deliberately decided against syncing the bit definitions because of a
> potential binary-incompatibility.
>=20
> Is there some use of the bit definition that is not as transparent as
> the text string based sysfs interface of an fc_host? E.g. using
> scsi_transport_fc.h in user space libraries or applications (if this =
is
> even allowed to be exported to user space)? I could find an in-kernel
> binary use in libfc/fc_lport.c which could alternatively do a
> conversion
> between the old RPSC ELS format of fc_host_{supported_}speed{s}() (an=
d
> libfc/fc_lport.c which has probably the same format as fc_host) when
> building the FDMI blob in scsi/fc_encode.h:fc_ct_ms_fill()?

While adding FC-GS FDMI support for the open FCoE stack (that uses libf=
c)
to register the port speed attributes(via FDMI) correctly either I woul=
d
need local libfc definitions that would translate the in kernel=20
=46C_PORTSPEED to specification values or get these defines in sync wit=
h=20
the FC-GS/SM-HBA/HBAAPI spec level to not do these translations that ot=
her
drivers seem to be doing. I chose to do the former in this commit.=20

One thing that I seem to miss is the RPSC ELS have some different defin=
itions
for speed as compared to the FC_PORTSPEED before this commit as well. D=
oes the=20
zfcp HBA FW do some internal conversion resulting into speed values tha=
t=20
were in sync with the prior FC_PORTSPEED values?

>=20
> 2) Why did commit a9277e7 change the kernel internal bit definitions?
>=20
> The zfcp LLDD has been copying the supported speeds value directly fr=
om
> what is reported by the HBA since the latter adheres to the RPSC ELS
> format for line speeds. Since commit a9277e7 this is broken now and w=
e
> see 10 Gbit instead of 4 Gbit in the supported_speeds sysfs attribute
> of
> the fc_host. I don't mind converting zfcp to an explicit finite bit
> conversion based on individually defined constants, esp. since all
> other
> FC LLDDs (qla2xxx, bfa, lpfc, ibmvscsi, fnic, mptfc) seem to do so
> already. The only slight drawback I can see is that the code needs to
> be
> touched for new HBA generations supporting new port speeds.
This is the same problem I was trying to avoid while you were trying to=
 reuse
the values reported by HBA to the OS; whereas I was copying the speed v=
alues=20
set for the libfc fc_lport instance to FDMI speed related attributes as=
 is.=20
Copying them as is was reporting incorrect speeds on the FC switch side=
 FDMI=20
database.=20

>=20
> 3) Should we have port speed defines for both RPSC ELS (in
> include/fc/fc_els.h?) and FDMI port attributes (in
> include/scsi/scsi_transport_fc.h? unless the bit semantic change gets
> reverted)?
>=20
> This way I could reuse the former to convert to the latter within zfc=
p
> and other users can reuse it with regard to RPSC ELS. I would send a
> patch if we agree on this.
I'm okay with either of the approach and if you choose the former (reve=
rt)
then I'll make necessary changes in libfc part to convert values intern=
ally
there.
Also, regardless of the approach you decide on wouldn't zfcp need to ma=
ke
sure the speed values reported by HBA FW is in sync with the in kernel=20
values?

>=20
> 4) Either way, should the port speed defines indicate RPSC ELS vs. FD=
MI
> more explicitly in their identifier names, in order to avoid future
> confusion?
If you chose to revert the a9277e7 then perhaps you don't need multiple=
=20
speed definitions.=20

>=20
> Regards,
> Steffen
>=20
> Linux on System z Development
>=20
> IBM Deutschland Research & Development GmbH
> Vorsitzende des Aufsichtsrats: Martina Koederitz
> Gesch=E4ftsf=FChrung: Dirk Wittkopp
> Sitz der Gesellschaft: B=F6blingen
> Registergericht: Amtsgericht Stuttgart, HRB 243294
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
