From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [RFC - PATCH 0/3] SCSI: Initiator based LUN Masking - SCSI mid-layer
Date: Mon, 13 Aug 2012 18:38:47 +0200
Message-ID: <50292D97.1030606@linux.vnet.ibm.com>
References: <1344652511-13899-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:41552 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2HMQkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2012 12:40:07 -0400
Received: from /spool/local
	by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Mon, 13 Aug 2012 17:40:05 +0100
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q7DGdv3G31195176
	for <linux-scsi@vger.kernel.org>; Mon, 13 Aug 2012 16:39:57 GMT
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q7DGe23x031411
	for <linux-scsi@vger.kernel.org>; Mon, 13 Aug 2012 10:40:03 -0600
In-Reply-To: <1344652511-13899-1-git-send-email-kgudipat@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kgudipat@brocade.com
Cc: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, revers@redhat.com, michaelc@cs.wisc.edu, hch@infradead.org, adapter_linux_open_src_team@brocade.com, amathur@brocade.com, Martin Peschke <mpeschke@linux.vnet.ibm.com>, Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>

Hi Krishna,

On 08/11/2012 04:35 AM, kgudipat@brocade.com wrote:
> 	The following RFC patch-set adds Initiator based LUN Masking support=
 to SCSI mid-layer
> 	and tries to address the feedback we have received to have LUN Maski=
ng feature in the
> 	SCSI mid-layer and made available to everyone.
>
> 	We came up with a design proposal to implement LUN Masking in SCSI m=
id-layer.
>
> 	I have listed the proposal details below and also attached the RFC p=
atch-set
> 	that enables LUN Masking in the SCSI mid-layer and the implementatio=
n of the
> 	LUN Masking feature by the Brocade BFA driver using the APIs provide=
d by the
> 	SCSI mid-layer to support LUN Masking feature.
>
> 	Can you please review the design proposal, patches and please let us=
 know your opinion?
>
> Thanks in advance,
> Krishna C Gudipati.
>
> (LUN masked =3D LUN to be made visible)

This terminology definition strikes me a bit odd, though I have to admi=
t=20
that I'm not a native speaker. One of the definitions I found says "to=20
conceal from view" which is also what I would feel naturally and seems=20
the opposite of your proposed usage. How is "masking" defined for targe=
t=20
lun masking on the storage side?

> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> Proposal - LUN Masking implementation in the SCSI mid-layer using SCS=
I target
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>
> Design Proposal:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Maintain a masked LUN list (the luns to be made visible) per target i=
n the
> SCSI target structure and use this list to determine whether to add t=
he LUN
> to the system config or to skip adding this LUN during the SCSI scan.
>
> The masked LUN list can be populated during the LLD target_alloc() en=
try point
> and can also be modified using the APIs that re-config this masked LU=
N list.
> The re-config is followed by a SCSI scan to honor the modified masked=
 LUN list.

> API changes:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 	- Introduce APIs to add or remove LUNs from SCSI target masked_lun_l=
ist.

> 	   extern int scsi_target_mask_lun(struct Scsi_Host *shost, int chan=
nel,
> 					   int target_id, unsigned int lun);

> 	   extern int scsi_target_unmask_lun(struct Scsi_Host *shost, int ch=
annel,
> 					     int target_id, unsigned int lun);

> 	   extern int scsi_target_config_lunmask(struct Scsi_Host *shost, in=
t channel,
> 						 int target_id, int masking_config);

> Pseudocode/Logic:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Populating the "masked_lun_list":
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

>    - For implementing LUN Masking, LLD can add the list of LUNs that =
are to be
>      masked to the scsi_target "masked_lun_list" in the target_alloc(=
) entry point.
>
>    - Further add/remove modifications to "masked_lun_list" can be don=
e using APIs
>      scsi_target_mask_lun() or scsi_target_unmask_lun() respectively.

Please correct me if my understanding is wrong. It seems to me as if th=
e=20
only interface to add/removing luns from the masking list in the scsi=20
midlayer are three in-kernel functions that are supposed to be called b=
y=20
an LLD. I understand this makes sense in your case with bfa, where you=20
seem to have a vendor-specific interface via bsg to user space to=20
add/remove luns from masking (among other things), and persistent=20
storage for the configured stuff in flash on the HBA.

Zfcp has been having initiator based lun masking since a long time.=20
Originally, we disabled all midlayer lun scanning on registering the=20
scsi_host. Only on explicit user actions through our own driver-specifi=
c=20
sysfs interface, we would ask the midlayer to probe and add one=20
particular lun by calling scsi_scan_target() for this one specific lun =
only.

When we introduced automatic lun scanning and probing through the=20
midlayer for NPIV setups, we also had to introduce -ENXIO in=20
slave_alloc() to suppress luns we do not want as an LLD when running in=
=20
non-NPIV setups, where we still support hardware virtualized HBAs and=20
must not touch each reported lun in each virtual Linux image sharing th=
e=20
same HBA and thus the same physical WWPN making the Linux images=20
indistinguishable in the fabric and on the target.

However, in both cases we only have the lun masking knowledge in the LL=
D=20
because we did not know of any other existing mechanism we could reuse=20
but to implement it on our own. The user space interface is by means of=
=20
unit_add and unit_remove sysfs attributes in the LLD specific sysfs tre=
e=20
reflecting HBAs, remote ports, and fcp luns. Basically, it is a shadow=20
of common code objects of type scsi/fc_host, fc_rport/target,=20
scsi_device making up the hierarchical whitelist of resources the user=20
would like to use. The user interface is described in the scsi/zfcp=20
chapter of our device drivers book on=20
http://www.ibm.com/developerworks/linux/linux390/documentation_dev.html=
=2E

In other words, we don't have our own persistence layer and would be=20
happy to rely on a common user space interface possibly owned by the=20
scsi midlayer. Other LLDs, that also don't have their own persistence=20
layer, could then also build on this generic lun masking and some user=20
space tool could do persistence if needed (such as udev rules).

Without such common user space interface, I don't yet see why the scsi=20
stack should maintain a (copy of an LLD) list if this list can only com=
e=20
from an LLD which could already do the lun masking in slave_alloc()?
I admit that it would be a first step, though.

> LUN Masking configuration change:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> To enable LUN Masking from disabled state:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

>      Handling already attached SCSI Devices:
>      ---------------------------------------
>      Flow:
>      -----
>      __scsi_scan_target() {
> 	scsi_probe_and_add_lun() {
> 		. . .
> 		sdev =3D scsi_device_lookup_by_target(starget, lun);
> 		if (sdev) {
>
> 		    /* Check if this LUN is part of the "masked_lun_list"
> 		     * If YES - set the sdev->is_masked to 1 and return
> 		     * SCSI_SCAN_LUN_PRESENT as done currently.
> 		     * If the LUN is NOT part of the "masked_lun_list" then
> 		     * remove this device using the __scsi_remove_device().

Is __scsi_remove_device() safe to call? The device could be in use. Of=20
course it would still have a refcount > 1 but we've had quite a number=20
of scsi device removal races lately so I might be a bit overcautious.

> 		     * The return status in this case will be SCSI_SCAN_MASK_LUN
> 		     */

> To disable LUN Masking from enabled state:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>      - Unset LUN Masking in scsi_target using scsi_target_config_lunm=
ask() API.
>      - Trigger a new LUN scan to reflect the new config.
>
>      Handling already attached SCSI Devices:
>      ---------------------------------------
>      Flow:
>      -----
>      __scsi_scan_target() {
> 	scsi_probe_and_add_lun() {
> 		. . .
> 		sdev =3D scsi_device_lookup_by_target(starget, lun);
> 		if (sdev) {
> 		    . . .
> 		    /* Unset the sdev->is_masked bit */
> 		    . . .

Dito, since this also calls __scsi_remove_device() eventually.

> 		}
> 		. . .
> 	}
>      }

> Pros:
> =3D=3D=3D=3D=3D
> 	- Implementation is not that complex
> 	- LLD can choose at run time / during SCSI scan LUNs to be masked.
> 	- SCSI Stack controls the device addition/removal during the scan
> 	  based on the LLD LUN masking config.
> 	- SCSI Stack maintains the list of masked luns.


Steffen Maier

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
