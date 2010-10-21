From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Thu, 21 Oct 2010 12:26:31 -0700 (PDT)
Message-ID: <743248.2576.qm@web31812.mail.mud.yahoo.com>
References: <1287607774.10283.78.camel@haakon2.linux-iscsi.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:24195 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753609Ab0JUTpE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2010 15:45:04 -0400
In-Reply-To: <1287607774.10283.78.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>, Brian King <brking@linux.vnet.ibm.com>, Mike Anderson <andmike@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>Andrew

--- On Wed, 10/20/10, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote=
:

> From: Nicholas A. Bellinger <nab@linux-iscsi.org>
> Subject: [ANNOUNCE] Status of unlocked_qcmds=3D1 operation for .37
> To: "linux-kernel" <linux-kernel@vger.kernel.org>, "linux-scsi" <linu=
x-scsi@vger.kernel.org>
> Cc: "Vasu Dev" <vasu.dev@linux.intel.com>, "Tim Chen" <tim.c.chen@lin=
ux.intel.com>, "Andi Kleen" <ak@linux.intel.com>, "Matthew Wilcox" <wil=
ly@linux.intel.com>, "James Bottomley" <James.Bottomley@suse.de>, "Mike=
 Christie" <michaelc@cs.wisc.edu>, "Jens Axboe" <jaxboe@fusionio.com>, =
"James Smart" <james.smart@emulex.com>, "Andrew Vasquez" <andrew.vasque=
z@qlogic.com>, "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>, "Hann=
es Reinecke" <hare@suse.de>, "Joe Eykholt" <jeykholt@cisco.com>, "Chris=
toph Hellwig" <hch@lst.de>, "Jon Hawley" <warthog9@kernel.org>, "MPTFus=
ionLinux" <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.balla=
bio@inwind.it>, "Luben Tuikov" <ltuikov@yahoo.com>, "mvsas maintainer" =
<kewei@marvell.com>, "pm8001 maintainer Jack Wang" <jack_wang@usish.com=
>, "Brian King" <brking@linux.vnet.ibm.com>, "Mike Anderson" <andmike@l=
inux.vnet.ibm.com>, "Christof Schmitt" <christof.schmitt@de.ibm.com>, "=
Tejun Heo" <tj@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>
> Date: Wednesday, October 20, 2010, 1:49 PM
> Greetings all,
>=20
> So as we get closer to the .37 merge window, I wanted to
> take this
> oppourtunity to recap the current status of the
> drop-host_lock /
> unlocked_qcmds=3D1 patches, and what is required for the next
> RFCv5 and
> hopefully a merge into .37.=A0 The last RFCv4 was posted
> here:
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D128563953114561&w=3D2
>=20
> Since then, Christof Schmitt has sent a patch to drop
> struct
> scsi_cmnd->serial_number usage in zfcp, and Tim Chen has
> sent an
> important fix to drop an extra host_lock access that I
> originally missed
> in qla2xxx SHT->queuecommand() that certainly would have
> deadlocked a
> running machine.=A0=A0=A0Many thanks to Christof
> and Tim for your
> contributions and review!
>=20
> So at this point in the game the current score sits at:
>=20
> *) core drivers/scsi remaining issue(s):
>=20
> The issue raised by andmike during RFCv4 described as:
>=20
> "If we skip __scsi_try_to_abort_cmd when REQ_ATOM_COMPLETE
> is set it
> would be correct for the scsi_decide_disposition cases but
> it would
> appear this would stop __scsi_try_to_abort_cmd from being
> called in the
> time out case as REQ_ATOM_COMPLETE is set prior to calling
> blk_rq_timed_out."
>=20
> The complete discussion is here:
>=20
> http://marc.info/?l=3Dlinux-scsi&m=3D128535319915212&w=3D2
>=20
> We still need folks with experience to dig into this code,
> so you know
> the scsi_error.c code please jump in!
>=20
> *) LLD libraries running by default w/ unlocked_qcmds=3D1
>=20
> libiscsi: need ack from mnc
> libsas: need ack from jejb
> libfc: remaining rport state + host_lock less issue.=A0
> Need more input
> =A0 =A0 =A0=A0=A0from mnc for James Smart
> and Joe on this...
> libata: jgarzik thinks this should be OK, review and ack
> from tejun
> =A0 =A0 =A0 =A0 would also be very helpful.
>=20
> The main issue remaining here is the audit of libfc rport
> (and other..?)
> code that assumes host_lock is held to protect state.=A0
> mnc, do you have
> any more thoughts for James Smart and Joe here..?
>=20
> *) Individual LLDs running by default w/ unlocked_qcmds=3D1
>=20
> aic94xx: need ack maintainer at adaptec..?)

Adaptec doesn't exist anymore--it's just a memory in the minds of
many good engineers.  Anyway, as a former Adaptec employee and
the author of aic94xx and the SAS code in the Linux kernel (which
Bottomley copied from a git tree from an Adaptec server or maybe
from the linux-scsi ML, munged it up and submitted as his own
into linux-scsi git tree) I can give an ACK on both. Both the
aic94xx and the SAS code were written with the host lock as a
kludge and we unlock/lock it as you can see in the code.

> mvsas: need ack maintainer at marvell..?)
> pm8001: need ack Jang Wang
> qla4xxx, qla2xxx: need ack Andrew Vasquez
> fnic:=A0 need ack Joe Eykholt
>=20
> Aside from the required ACKs, I am not aware of any other
> mainline LLDs
> doing the legacy SHT->queuecommand() -> unlock()
> -> do_lld_work() ->
> lock() that have not already been converted.
>=20
> The main question here is if any out of tree SCSI LLDs use
> this legacy
> optimization..=A0 Should we come up with a compile time
> way to alert
> vendors to this..?
>=20
> *) Individual LLDs converted to use explict
> scsi_cmd_get_serial()
>=20
> mpt2sas: Add scsi_cmd_get_serial() call
> mpt/fusion: Add scsi_cmd_get_serial() call
> dpt_i2o: Add scsi_cmd_get_serial() call
> eata: Add scsi_cmd_get_serial() call
> u14-34f: Add scsi_cmd_get_serial() call
> zfcp: Remove scsi_cmnd->serial_number from debug traces
>=20
> Aside from the required ACKs, I am not aware of any other
> mainline LLDs
> that use struct scsi_cmnd->serial_number internally that
> have not
> already been converted.=A0 The same applies to out of
> tree modules for
> this, but is certainly not critical.
>=20
> So as the clock winds down to get this merged into .37, if
> anyone else
> has any concerns or comments please let myself and the
> other relivent
> maintainers know and we will try to address them
> accordingly.
>=20
> Thanks!
>=20
> --nab
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
