From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] Target fabric module for SCSI para-virtualization
Date: Mon, 07 Feb 2011 09:07:49 +0100
Message-ID: <4D4FA855.2030904@suse.de>
References: <1297065435.13752.173.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38279 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab1BGH7k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2011 02:59:40 -0500
In-Reply-To: <1297065435.13752.173.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, lsf-pc@lists.linuxfoundation.org, linux-scsi <linux-scsi@vger.kernel.org>, Stefan Hajnoczi <stefanha@gmail.com>, Anthony Liguori <anthony@codemonkey.ws>, Christoph Hellwig <hch@lst.de>

On 02/07/2011 08:57 AM, Nicholas A. Bellinger wrote:
> Greetings all,
>=20
> [Topic]
>=20
> A hybrid target fabric module for QEMU/KVM SCSI para-virtualization
>=20
> [Abstract]
>=20
> Currently we use the TCM_Loop v4 fabric module with mainline .38 targ=
et
> code to present SCSI LUNs with high level multi-fabric (iSCSI, FC, SA=
S)
> SPC-3 port WWN emulation into KVM guests using two different forms of
> QEMU HBA hardware emulation.  However both of these currently require
> interaction with the QEMU block layer and extra overhead of OS
> independent code running in user-space connected to our existing
> SG_IO/BSG interfaces.  This also has the limitiation that we currentl=
y
> cannot perform explict SCSI Initiator Port access management for LUNs
> also present via TCM_Loop SCSI LLD driver on the KVM host.
>=20
> Recently there has been an off-list discussion between myself and
> members of the QEMU/KVM community, and they have expressed an interes=
t
> in seeing a native paravirtualized SCSI passthrough available to QEMU
> guests with direct interaction into TCM fabric module code running on
> KVM host.  This would be using existing CDB level port emulation code=
 in
> target_core_fabric_lib.c, and (mostly) generic fabric control plane i=
n
> target_core_fabric_configfs.c..  Beyond the TCM fabric module specifi=
cs,
> this will require:
>=20
> *) An asynchronous I/O capable virtio interface for KVM that does not
> require direct QEMU block-layer interaction
>=20
> *) A multi-fabric WWN naming capable TCM fabric module using native
> virtio-scsi connections to individual KVM guests for kernel-level
> passthrough into TCM backend storage.  (eg: similar to TCM_Loop, but =
w/o
> the Linux/SCSI LLD frontend, and full explict Initiator port NodeACL =
+
> MappedLUN control abstraction)
>=20
> *) Guest OS specific para-virtualized SCSI driver packages (similar t=
o
> virtio-blk) performing SCSI I/O handoff into passthrough interface vi=
a
> SCSI I_T nexues, with proper T10 WWN Port and LUN naming provided fro=
m
> underlying TCM v4.x infrastructure  (eg: full compat w/ existing SPC-=
3
> capable cluster clients)
>=20
YES!
One item less on my long-term to-do list.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
