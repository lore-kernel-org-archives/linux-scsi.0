From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: Re: sym53c8xx_2 fix
Date: Mon, 23 Dec 2002 12:41:31 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021223115324.T5310-100000@localhost.my.domain>
References: <200212191314.45778.bjorn_helgaas@hp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200212191314.45778.bjorn_helgaas@hp.com>
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bjorn_helgaas@hp.com>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com



On Thu, 19 Dec 2002, Bjorn Helgaas wrote:

> We run the sym53c8xx_2 driver on a simulator.  Because the
> simulator's disk model is somewhat simplified compared to real
> hardware, it exercises some code paths that are not exercised
> on the hardware.
>
> Our simulator guru found what appears to be an error in
> one such path.  Here's his description and patch (against
> 2.4.20).  Let me know if you need more information.
>
> Justin, I copied you because the comment immediately preceding
> this code says it's part of an optimization you suggested
> (negotiating for SYNC immediately after a WIDE response).
>
> > ... There is also a bug in the driver that keeps us from
> > booting.  This code path is not executed on hardware but is on the =
sim with
> > our simple disk model.  The current driver assembles an SDTR reques=
t but
> > then calls the SDTR response script.  Here is the fix:
>
> > --- orig/linux-ia64-2.4/drivers/scsi/sym53c8xx_2/sym_hipd.c     Fri=
 Sep 27 17:27:41 2002
> > +++ fixed/linux-ia64-2.4/drivers/scsi/sym53c8xx_2/sym_hipd.c    Wed=
 Dec 18 21:26:25 2002
> > @@ -4363,7 +4363,7 @@
> >
> >                         cp->nego_status =3D NS_SYNC;
> >                         OUTB (HS_PRT, HS_NEGOTIATE);
> > -                       OUTL_DSP (SCRIPTB_BA (np, sdtr_resp));
> > +                       OUTL_DSP (SCRIPTB_BA (np, send_sdtr));
> >                         return;
> >                 }

May-be the driver doesn't behave correctly here, but your patch is not
correct. The reason is that the <send_ptr> script label assumes that th=
e
target is already in MESSAGE OUT phase. This is the case after a select=
ion
with ATN, for example.

But, in our situation, the target just sent a WDTR response (MESSAGE IN
phase) and ATN wasn't asserted. Then the initiator must assert ATN prio=
r
to deasserting ACK for the last message in byte in order to ask the tar=
get
for a MESSAGE OUT phase, otherwise the target can switch to any phase i=
t
desires.

Here is the SCSI SCRIPTS (same for both firmwares):

}/*-------------------------< SDTR_RESP >------------------------*/,{
	/*
	 *  let the target fetch our answer.
	 */
	SCR_SET (SCR_ATN),
		0,
	SCR_CLR (SCR_ACK),
		0,
	SCR_JUMP ^ IFFALSE (WHEN (SCR_MSG_OUT)),
		PADDR_B (nego_bad_phase),
}/*-------------------------< SEND_SDTR >------------------------*/,{
	/*
	 *  Send the M_X_SYNC_REQ
	 */
	SCR_MOVE_ABS (5) ^ SCR_MSG_OUT,
		HADDR_1 (msgout),
	SCR_JUMP,
		PADDR_B (msg_out_done),
}/*-------------------------< PPR_RESP >-------------------------*/,{
	/*
	 *  let the target fetch our answer.

Here is a brief translation (the SCRIPTS above look understable, anyway=
):

SDTR_RESP:
	Assert ATN
	Clear  ACK
	Wait for MESSAGE OUT phase
SEND_SDTR:
	Send the MESSAGE data

May-be I should have renamed the <SDTR_RESP> label when I implemented
Justin's suggestion in the sym driver, but the needed SCRIPTS was alrea=
dy
there and I just had to make the SCRIPTS processor jump to the appropri=
ate
label. Indeed, the comments are misleading or at least not complete, an=
d I
have to add some.

Anyway, technically, the initial driver code seems correct to me here a=
nd
I am surprised that your change allows to fix something. In my opinion,=
 it
should break something, unless the target magically turns to MESSAGE OU=
T
phase for some reason.

The magic that makes a target switch to MESSAGE OUT phase is the assert=
ion
of the ATN signal. This signal is automatically deasserted by the Symbi=
os
chip SCSI core after a MESSAGE has been sent. As a result, the ATN sign=
al
is not asserted in our situation, since it was cleared after our WDTR w=
as
sent.

The SDTR_RESP stuff asserts ATN prior to deasserting ACK for the last
message byte (as specified by SCSI) in order for the target to enter
MESSAGE OUT phase immediately, then sends the MESSAGE. This behaviour
applies to a normal SDTR response or to a SDTR negotiation after WDTR
negotiation. This was the reason of re-using SDTR_RESP SCRIPTS code.

Regards,
  G=E9rard.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
