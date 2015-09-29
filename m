From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: twa generates WARNING upon boot
Date: Tue, 29 Sep 2015 11:33:01 -0700
Message-ID: <1443551581.2207.26.camel@HansenPartnership.com>
References: <68ee66bf9581d10b0ab813e5006869ec.squirrel@atoth.sote.hu>
	 <CAHtARFHdFOVHZ2_-JT9_nvRZmbF+cffRrtaaE4DSZSrJwU6BCA@mail.gmail.com>
	 <d8e4bcdc939f0926a63f5c4a35fb8e0c.squirrel@atoth.sote.hu>
	 <1443548266.2207.19.camel@HansenPartnership.com>
	 <1443549768.2207.22.camel@HansenPartnership.com>
	 <95d34bcc4c0fcf84d02d76a4443ba07c.squirrel@atoth.sote.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38203 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965461AbbI2SdD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 14:33:03 -0400
In-Reply-To: <95d34bcc4c0fcf84d02d76a4443ba07c.squirrel@atoth.sote.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "=?ISO-8859-1?Q?=22T=F3th?= Attila\"" <atoth@atoth.sote.hu>
Cc: adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2015-09-29 at 20:25 +0200, "T=C3=B3th Attila" wrote:
> 2015.Szeptember 29.(K) 20:02 id=C5=91pontban James Bottomley ezt =C3=AD=
rta:
> > On Tue, 2015-09-29 at 10:37 -0700, James Bottomley wrote:
> >> On Tue, 2015-09-29 at 18:49 +0200, "T=C3=B3th Attila" wrote:
> >> > 2015.Szeptember 27.(V) 23:19 id=C5=91pontban adam radford ezt =C3=
=ADrta:
> >> > > On Sun, Sep 27, 2015 at 4:56 AM, "T=C3=B3th Attila" <atoth@ato=
th.sote.hu>
> >> > > wrote:
> >> > >> The 3ware card is a 9650SE-12ML running in a Asus Z8PE-D12X
> >> > >>
> >> > >
> >> > > Can you re-try with Christoph's patch:
> >> > >
> >> > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.gi=
t/commit/?id=3D118c855b5623f3e2e6204f02623d88c09e0c34de
> >> >
> >> > As I've told this patch has been already included in the kernel =
I'm
> >> using
> >> > (4.1.7-hardened-r1, which is based on 4.1.7).
> >> > Out of curiosity I've reverted the patch and the WARNING no long=
er
> >> appears
> >> > during boot...
> >>
> >> Ah, it looks like there's a bug in the patch, it doesn't take into
> >> account that the driver has a minimum sg map length and it copies =
for
> >> things under that, so we're likely unmapping something that wasn't
> >> mapped.   It's slightly hard to fix given that the indicator flag =
we'd
> >> use for this is gone in that patch; does this fix the warning?
> >
> > Actually, strike that, it would still barf on internally generated
> > commands (and it's recursively calling twa_scsi_dma_unmap).  This d=
oes a
> > partial revert of the state check which should pick up all cases th=
e
> > input didn't go through the mapping.
>=20
> Just to be clear before I try something out.
> In this latter patch you are resurrecting TW_PHASE_SGLIST, which has =
been
> ment to be removed in Christoph's patch from the header.
> I guess I have to reintroduce those phase defines on top of the chang=
es
> below in your latest email.
> Or please let me know what should I exactly try out.

Heh, sorry forgot the header change.  This should be the complete patch
attached.

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
diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index 0fdc83c..c88d5bd 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -324,6 +324,10 @@ static twa_message_type twa_error_table[] =3D {
 #define TW_CURRENT_DRIVER_BUILD 0
 #define TW_CURRENT_DRIVER_BRANCH 0
=20
+/* Phase defines */
+#define TW_PHASE_INITIAL 0
+#define TW_PHASE_SGLIST  1
+
 /* Misc defines */
 #define TW_9550SX_DRAIN_COMPLETED	      0xFFFF
 #define TW_SECTOR_SIZE                        512


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
