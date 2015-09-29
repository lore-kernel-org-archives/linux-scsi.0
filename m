From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: twa generates WARNING upon boot
Date: Tue, 29 Sep 2015 11:02:48 -0700
Message-ID: <1443549768.2207.22.camel@HansenPartnership.com>
References: <68ee66bf9581d10b0ab813e5006869ec.squirrel@atoth.sote.hu>
	 <CAHtARFHdFOVHZ2_-JT9_nvRZmbF+cffRrtaaE4DSZSrJwU6BCA@mail.gmail.com>
	 <d8e4bcdc939f0926a63f5c4a35fb8e0c.squirrel@atoth.sote.hu>
	 <1443548266.2207.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38093 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935317AbbI2SCu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 14:02:50 -0400
In-Reply-To: <1443548266.2207.19.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "=?ISO-8859-1?Q?=22T=F3th?= Attila\"" <atoth@atoth.sote.hu>
Cc: adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2015-09-29 at 10:37 -0700, James Bottomley wrote:
> On Tue, 2015-09-29 at 18:49 +0200, "T=C3=B3th Attila" wrote:
> > 2015.Szeptember 27.(V) 23:19 id=C5=91pontban adam radford ezt =C3=AD=
rta:
> > > On Sun, Sep 27, 2015 at 4:56 AM, "T=C3=B3th Attila" <atoth@atoth.=
sote.hu>
> > > wrote:
> > >> Here is a current trace I see after booting that kernel:
> > >> ------------[ cut here ]------------
> > >> WARNING: CPU: 0 PID: 1 at drivers/iommu/intel-iommu.c:3214
> > >> intel_unmap+0x186/0x1f0()
> > >> Driver unmaps unmatched page at PFN 0
> > >> Modules linked in:
> > >> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.1.7-hardened-r1 #2
> > >> Hardware name: System manufacturer System Product Name/Z8P(N)E-D=
12(X),
> > >> BIOS 1302    06/25/2012
> > >>  ffffffffab40bd6b 0000000000000000 0000000000000000 ffffffffab21=
608f
> > >>  ffff880237c03ca8 ffffffffa4ed0fa6 00000000000015d2 ffff880237c0=
3d00
> > >>  ffff880237c03ce8 ffffffffa40ad9a0 0000000000000000 ffffffffab21=
608f
> > >> Call Trace:
> > >>  <IRQ>  [<ffffffffa4ed0fa6>] dump_stack+0x45/0x5d
> > >>  [<ffffffffa40ad9a0>] warn_slowpath_common+0x80/0xc0
> > >>  [<ffffffffa40ada44>] warn_slowpath_fmt+0x64/0x90
> > >>  [<ffffffffa46de866>] intel_unmap+0x186/0x1f0
> > >>  [<ffffffffa46de8ea>] intel_unmap_sg+0x1a/0x30
> > >>  [<ffffffffa475ef13>] scsi_dma_unmap+0x73/0x90
> > >>  [<ffffffffa47b8683>] twa_interrupt+0x493/0x780
> > >>  [<ffffffffa4100f7a>] handle_irq_event_percpu+0x7a/0x130
> > >>  [<ffffffffa4101069>] handle_irq_event+0x39/0x60
> > >>  [<ffffffffa4104469>] handle_fasteoi_irq+0x89/0x1a0
> > >>  [<ffffffffa4005715>] handle_irq+0x85/0x160
> > >>  [<ffffffffa4004f6c>] do_IRQ+0x4c/0x100
> > >>  [<ffffffffa4edd557>] common_interrupt+0x97/0x97
> > >>  <EOI>  [<ffffffffa403d1cc>] ?
> > >> default_send_IPI_mask_allbutself_phys+0xbc/0x100
> > >>  [<ffffffffa4042e79>] physflat_send_IPI_allbutself+0x19/0x30
> > >>  [<ffffffffa40385d8>] native_send_call_func_ipi+0x108/0x140
> > >>  [<ffffffffa4125c10>] ? proc_dma_show+0x70/0x70
> > >>  [<ffffffffa41264f4>] smp_call_function_many+0x1c4/0x270
> > >>  [<ffffffffa4126671>] kick_all_cpus_sync+0x21/0x30
> > >>  [<ffffffffa41bb546>] __do_tune_cpucache+0x56/0x4d0
> > >>  [<ffffffffa458f4b7>] ? string.isra.3+0x47/0x100
> > >>  [<ffffffffa41bb9f7>] do_tune_cpucache+0x37/0xb0
> > >>  [<ffffffffa41bbad5>] enable_cpucache+0x65/0x130
> > >>  [<ffffffffa4ec5c13>] setup_cpu_cache+0x173/0x270
> > >>  [<ffffffffa41bc2c2>] __kmem_cache_create+0x262/0x360
> > >>  [<ffffffffa418a5c2>] do_kmem_cache_create+0x92/0x1d0
> > >>  [<ffffffffa418a81e>] kmem_cache_create+0x11e/0x1d0
> > >>  [<ffffffffafc4c3d0>] ? twa_init+0x36/0x36
> > >>  [<ffffffffafc4c4a7>] init_sd+0xd7/0x198
> > >>  [<ffffffffa4000384>] do_one_initcall+0x94/0x1a0
> > >>  [<ffffffffafc15285>] kernel_init_freeable+0x183/0x22f
> > >>  [<ffffffffa4ec44f0>] ? rest_init+0x80/0x80
> > >>  [<ffffffffa4ec44f9>] kernel_init+0x9/0xf0
> > >>  [<ffffffffa4edcdfe>] ret_from_fork+0x3e/0x70
> > >>  [<ffffffffa4ec44f0>] ? rest_init+0x80/0x80
> > >> ---[ end trace a39a5826ea41aa47 ]---
> > >>
> > >> The 3ware card is a 9650SE-12ML running in a Asus Z8PE-D12X moth=
erboard.
> > >>
> > >
> > > Can you re-try with Christoph's patch:
> > >
> > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/c=
ommit/?id=3D118c855b5623f3e2e6204f02623d88c09e0c34de
> >=20
> > As I've told this patch has been already included in the kernel I'm=
 using
> > (4.1.7-hardened-r1, which is based on 4.1.7).
> > Out of curiosity I've reverted the patch and the WARNING no longer =
appears
> > during boot...
>=20
> Ah, it looks like there's a bug in the patch, it doesn't take into
> account that the driver has a minimum sg map length and it copies for
> things under that, so we're likely unmapping something that wasn't
> mapped.   It's slightly hard to fix given that the indicator flag we'=
d
> use for this is gone in that patch; does this fix the warning?

Actually, strike that, it would still barf on internally generated
commands (and it's recursively calling twa_scsi_dma_unmap).  This does =
a
partial revert of the state check which should pick up all cases the
input didn't go through the mapping.

James

---

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index add419d..751ed66 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -151,7 +151,13 @@ static void twa_scsiop_execute_scsi_complete(TW_De=
vice_Extension *tw_dev, int re
 static char *twa_string_lookup(twa_message_type *table, unsigned int a=
en_code);
=20
 /* Functions */
+static void twa_scsi_dma_unmap(struct scsi_cmnd *SCpnt)
+{
+	if (SCpnt->SCp.phase =3D=3D TW_PHASE_SGLIST)
+		scsi_dma_unmap(SCpnt);
+}
=20
+ =20
 /* Show some statistics about the card */
 static ssize_t twa_show_stats(struct device *dev,
 			      struct device_attribute *attr, char *buf)
@@ -1339,7 +1345,7 @@ static irqreturn_t twa_interrupt(int irq, void *d=
ev_instance)
 				}
=20
 				/* Now complete the io */
-				scsi_dma_unmap(cmd);
+				twa_scsi_dma_unmap(cmd);
 				cmd->scsi_done(cmd);
 				tw_dev->state[request_id] =3D TW_S_COMPLETED;
 				twa_free_request_id(tw_dev, request_id);
@@ -1582,7 +1588,7 @@ static int twa_reset_device_extension(TW_Device_E=
xtension *tw_dev)
 				struct scsi_cmnd *cmd =3D tw_dev->srb[i];
=20
 				cmd->result =3D (DID_RESET << 16);
-				scsi_dma_unmap(cmd);
+				twa_scsi_dma_unmap(cmd);
 				cmd->scsi_done(cmd);
 			}
 		}
@@ -1762,15 +1768,18 @@ static int twa_scsi_queue_lck(struct scsi_cmnd =
*SCpnt, void (*done)(struct scsi_
 	/* Save the scsi command for use by the ISR */
 	tw_dev->srb[request_id] =3D SCpnt;
=20
+	/* Initialize phase to zero */
+	SCpnt->SCp.phase =3D TW_PHASE_INITIAL;
+
 	retval =3D twa_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NULL)=
;
 	switch (retval) {
 	case SCSI_MLQUEUE_HOST_BUSY:
-		scsi_dma_unmap(SCpnt);
+		twa_scsi_dma_unmap(SCpnt);
 		twa_free_request_id(tw_dev, request_id);
 		break;
 	case 1:
 		SCpnt->result =3D (DID_ERROR << 16);
-		scsi_dma_unmap(SCpnt);
+		twa_scsi_dma_unmap(SCpnt);
 		done(SCpnt);
 		tw_dev->state[request_id] =3D TW_S_COMPLETED;
 		twa_free_request_id(tw_dev, request_id);
@@ -1845,6 +1854,8 @@ static int twa_scsiop_execute_scsi(TW_Device_Exte=
nsion *tw_dev, int request_id,
 				if (sg_count < 0)
 					goto out;
=20
+				srb->SCp.phase =3D TW_PHASE_SGLIST;
+
 				scsi_for_each_sg(srb, sg, sg_count, i) {
 					command_packet->sg_list[i].address =3D TW_CPU_TO_SGL(sg_dma_addre=
ss(sg));
 					command_packet->sg_list[i].length =3D cpu_to_le32(sg_dma_len(sg))=
;


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
