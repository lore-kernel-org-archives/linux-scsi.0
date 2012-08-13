From: Krishna Gudipati <kgudipat@Brocade.com>
Subject: RE: [RFC - PATCH 0/3] SCSI: Initiator based LUN Masking - SCSI
 mid-layer
Date: Mon, 13 Aug 2012 15:48:29 -0700
Message-ID: <B5EE62D80D50B84BB9E5174F7FCCE80A2839ABBD1F@HQ1-EXCH02.corp.brocade.com>
References: <1344652511-13899-1-git-send-email-kgudipat@brocade.com>
 <50292D97.1030606@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34025 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052Ab2HMWsv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2012 18:48:51 -0400
In-Reply-To: <50292D97.1030606@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Rob Evers <revers@redhat.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "hch@infradead.org" <hch@infradead.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>, Akshay Mathur <amathur@brocade.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>, Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>

Hi Steffen,

Thanks for reviewing the design, please find my responses in line with =
tag [KRISHNA].

Thanks,
Krishna.

> From: Steffen Maier [mailto:maier@linux.vnet.ibm.com]
> On 08/11/2012 04:35 AM, kgudipat@brocade.com wrote:
> > (LUN masked =3D LUN to be made visible)
>=20
> This terminology definition strikes me a bit odd, though I have to ad=
mit
> that I'm not a native speaker. One of the definitions I found says "t=
o
> conceal from view" which is also what I would feel naturally and seem=
s
> the opposite of your proposed usage. How is "masking" defined for tar=
get
> lun masking on the storage side?

[KRISHNA]: Here masking is used synonymously to zoning. So, only the LU=
Ns that are part of the
scsi_target masked lun list (i.e. LUNs of a specific target zoned to th=
e initiator to be seen) - can be
attached during the SCSI scan and rest are supposed to be skipped/not a=
ttached.

>=20
> >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Proposal - LUN Masking implementation in the SCSI mid-layer using S=
CSI
> target
> >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Design Proposal:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Maintain a masked LUN list (the luns to be made visible) per target=
 in the
> > SCSI target structure and use this list to determine whether to add=
 the LUN
> > to the system config or to skip adding this LUN during the SCSI sca=
n.
> >
> > The masked LUN list can be populated during the LLD target_alloc() =
entry
> point
> > and can also be modified using the APIs that re-config this masked =
LUN list.
> > The re-config is followed by a SCSI scan to honor the modified mask=
ed LUN
> list.
>=20
> > API changes:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > 	- Introduce APIs to add or remove LUNs from SCSI target
> masked_lun_list.
>=20
> > 	   extern int scsi_target_mask_lun(struct Scsi_Host *shost, int
> channel,
> > 					   int target_id, unsigned int lun);
>=20
> > 	   extern int scsi_target_unmask_lun(struct Scsi_Host *shost, int
> channel,
> > 					     int target_id, unsigned int lun);
>=20
> > 	   extern int scsi_target_config_lunmask(struct Scsi_Host *shost, =
int
> channel,
> > 						 int target_id, int
> masking_config);
>=20
> > Pseudocode/Logic:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Populating the "masked_lun_list":
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> >    - For implementing LUN Masking, LLD can add the list of LUNs tha=
t are to
> be
> >      masked to the scsi_target "masked_lun_list" in the target_allo=
c() entry
> point.
> >
> >    - Further add/remove modifications to "masked_lun_list" can be d=
one
> using APIs
> >      scsi_target_mask_lun() or scsi_target_unmask_lun() respectivel=
y.
>=20
> Please correct me if my understanding is wrong. It seems to me as if =
the
> only interface to add/removing luns from the masking list in the scsi
> midlayer are three in-kernel functions that are supposed to be called=
 by
> an LLD. I understand this makes sense in your case with bfa, where yo=
u
> seem to have a vendor-specific interface via bsg to user space to
> add/remove luns from masking (among other things), and persistent
> storage for the configured stuff in flash on the HBA.


[KRISHNA]: Steffen, yes you are right, currently in this proposal we on=
ly have 3 interfaces
exported from SCSI mid-layer for LLD to configure LUN Masking.
I believe with the interfaces provided currently we should be able to e=
nable LUN masking
even though we don't have a persistent storage or a vendor-specific BSG=
 based interface.

The interfaces scsi_target_mask_lun() to mask a LUN and scsi_target_unm=
ask_lun() to unmask
a LUN can be called dynamically even from your current sysfs implementa=
tion of LUN Masking.
The only action required on a configuration change is to trigger a new =
SCSI scan and the state of
the masked LUNs and LUN Masking configuration state is maintained by th=
e SCSI mid-layer until
the scsi target is destroyed. On a target discovery we need to re-confi=
gure the LUN Masking from sysfs again.

The advantage of having persistent storage in the LLD is we can have LU=
N Masking enabled/configured
during the driver load, as we can call the APIs to configure LUN Maskin=
g from target_alloc() entry point
and can avoid LUN Masking configuration from user space during every mo=
dule load and during the
target offline/online events as above.


>=20
> Zfcp has been having initiator based lun masking since a long time.
> Originally, we disabled all midlayer lun scanning on registering the
> scsi_host. Only on explicit user actions through our own driver-speci=
fic
> sysfs interface, we would ask the midlayer to probe and add one
> particular lun by calling scsi_scan_target() for this one specific lu=
n only.
>=20
> When we introduced automatic lun scanning and probing through the
> midlayer for NPIV setups, we also had to introduce -ENXIO in
> slave_alloc() to suppress luns we do not want as an LLD when running =
in
> non-NPIV setups, where we still support hardware virtualized HBAs and
> must not touch each reported lun in each virtual Linux image sharing =
the
> same HBA and thus the same physical WWPN making the Linux images
> indistinguishable in the fabric and on the target.
>=20
> However, in both cases we only have the lun masking knowledge in the =
LLD
> because we did not know of any other existing mechanism we could reus=
e
> but to implement it on our own. The user space interface is by means =
of
> unit_add and unit_remove sysfs attributes in the LLD specific sysfs t=
ree
> reflecting HBAs, remote ports, and fcp luns. Basically, it is a shado=
w
> of common code objects of type scsi/fc_host, fc_rport/target,
> scsi_device making up the hierarchical whitelist of resources the use=
r
> would like to use. The user interface is described in the scsi/zfcp
> chapter of our device drivers book on
> http://www.ibm.com/developerworks/linux/linux390/documentation_dev.
> html.
>=20
> In other words, we don't have our own persistence layer and would be
> happy to rely on a common user space interface possibly owned by the
> scsi midlayer. Other LLDs, that also don't have their own persistence
> layer, could then also build on this generic lun masking and some use=
r
> space tool could do persistence if needed (such as udev rules).
>=20
> Without such common user space interface, I don't yet see why the scs=
i
> stack should maintain a (copy of an LLD) list if this list can only c=
ome
> from an LLD which could already do the lun masking in slave_alloc()?

[KRISHNA]: The disadvantage of the LUN Masking implementation using the=
 SCSI slave callouts
is we cannot do a REPORT_LUNS based SCSI scan and need to fall back to =
Sequential LUN scan.
The reason being if we return -ENXIO from slave_alloc() for any LUN tha=
t is part of the REPORT_LUNS
response payload this would result in the scan being aborted. So we nee=
d to do a sequential LUN scan which
is not so good as we end up scanning for 16K LUNs, for SPARSE LUNs. So =
we came up with this proposal.


> I admit that it would be a first step, though.

[KRISHNA]: Steffen, thanks for the review. Please let me know if I have=
 answered your questions.
In addition the design can be enhanced to have something like udev rule=
s to maintain persistency
as you mentioned; I will think it through, please let me know if you ha=
ve some ideas.

>=20
> > LUN Masking configuration change:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > To enable LUN Masking from disabled state:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> >      Handling already attached SCSI Devices:
> >      ---------------------------------------
> >      Flow:
> >      -----
> >      __scsi_scan_target() {
> > 	scsi_probe_and_add_lun() {
> > 		. . .
> > 		sdev =3D scsi_device_lookup_by_target(starget, lun);
> > 		if (sdev) {
> >
> > 		    /* Check if this LUN is part of the "masked_lun_list"
> > 		     * If YES - set the sdev->is_masked to 1 and return
> > 		     * SCSI_SCAN_LUN_PRESENT as done currently.
> > 		     * If the LUN is NOT part of the "masked_lun_list" then
> > 		     * remove this device using the __scsi_remove_device().
>=20
> Is __scsi_remove_device() safe to call? The device could be in use. O=
f
> course it would still have a refcount > 1 but we've had quite a numbe=
r
> of scsi device removal races lately so I might be a bit overcautious.

[KRISHNA]: During my testing I haven't seen any issue - but I would dou=
ble-check.

>=20
> > 		     * The return status in this case will be
> SCSI_SCAN_MASK_LUN
> > 		     */
>=20
> > To disable LUN Masking from enabled state:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >      - Unset LUN Masking in scsi_target using scsi_target_config_lu=
nmask()
> API.
> >      - Trigger a new LUN scan to reflect the new config.
> >
> >      Handling already attached SCSI Devices:
> >      ---------------------------------------
> >      Flow:
> >      -----
> >      __scsi_scan_target() {
> > 	scsi_probe_and_add_lun() {
> > 		. . .
> > 		sdev =3D scsi_device_lookup_by_target(starget, lun);
> > 		if (sdev) {
> > 		    . . .
> > 		    /* Unset the sdev->is_masked bit */
> > 		    . . .
>=20
> Dito, since this also calls __scsi_remove_device() eventually.
>=20
> > 		}
> > 		. . .
> > 	}
> >      }
>=20
> > Pros:
> > =3D=3D=3D=3D=3D
> > 	- Implementation is not that complex
> > 	- LLD can choose at run time / during SCSI scan LUNs to be masked.
> > 	- SCSI Stack controls the device addition/removal during the scan
> > 	  based on the LLD LUN masking config.
> > 	- SCSI Stack maintains the list of masked luns.
>=20
>=20
> Steffen Maier
>=20
> Linux on System z Development
>=20
> IBM Deutschland Research & Development GmbH
> Vorsitzende des Aufsichtsrats: Martina Koederitz
> Gesch=E4ftsf=FChrung: Dirk Wittkopp
> Sitz der Gesellschaft: B=F6blingen
> Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
