From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: STK9840/SYM53c875 ODD transfer in DATA OUT phase
Date: Fri, 26 Sep 2003 18:39:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030926163921.GD32502@chihiro.cern.ch>
References: <20030926102021.GA32502@chihiro.cern.ch> <m3k77vhghs.fsf@trained-monkey.org> <Pine.LNX.4.58.0309260858210.1793@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3.cern.ch ([137.138.131.164]:6574 "EHLO smtp3.cern.ch")
	by vger.kernel.org with ESMTP id S261427AbTIZQjX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 12:39:23 -0400
Received: from chihiro.cern.ch (pcitadc13.cern.ch [137.138.34.18])
	by smtp3.cern.ch (8.12.1-20030924/8.12.1) with ESMTP id h8QGdLDe006265
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2003 18:39:21 +0200 (MET DST)
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0309260858210.1793@filesrv1.baby-dragons.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

* Mr. James W. Laferriere (babydr@baby-dragons.com) [20030926 09:03]:

Jes, James,

> On Fri, 26 Sep 2003, Jes Sorensen wrote:
> > Have you tried using a different SCSI controller to see if it
> > is driver related? Any chance you could try 2.4.21?

> If memory serves this is driver related . And IIRC someone
> has made changes or at least put forth a patch to attempt to
> aleviate the odd byte count problem . It is in (Again IIRC) both
> of the Symbois drivers (ie: 53c8xx.c & sym53c8xx_2) . Do try a
> newer kernel than 2.4.21 tho 2.4.22 is what I am running . Hth ,
> JimL

Well, I tried 2.4.22, the change is really small:

--- linux-2.4.20-18.7.cern/drivers/scsi/sym53c8xx_2/sym_hipd.c	2003-07-=
04 12:22:05.000000000 +0200
+++ linux-2.4.22/drivers/scsi/sym53c8xx_2/sym_hipd.c	2003-08-25 13:44:4=
2.000000000 +0200
@@ -221,7 +221,7 @@
  */
 static void sym_soft_reset (hcb_p np)
 {
-	u_char istat=3D0;
+	u_char istat;
 	int i;
=20
 	if (!(np->features & FE_ISTAT1) || !(INB (nc_istat1) & SCRUN))
@@ -4641,7 +4641,10 @@
 		case M_IGN_RESIDUE:
 			if (DEBUG_FLAGS & DEBUG_POINTER)
 				sym_print_msg(cp,"ign wide residue", np->msgin);
-			sym_modify_dp(np, tp, cp, -1);
+			if (cp->host_flags & HF_SENSE)
+				OUTL_DSP (SCRIPTA_BA (np, clrack));
+			else
+				sym_modify_dp(np, tp, cp, -1);
 			return;
 		case M_REJECT:
 			if (INB (HS_PRT) =3D=3D HS_NEGOTIATE)

=2E..to no avail, the problem persists.  However, there is a funny
thing I observed: the driver still logs the *same* error message=B9
to the ringbuffer when I do even byte transfers, however for some
weird reason the driver reports success, and lo, I can read the
file back and it is intact.  Odd byte transfers trigger the same
condition and the driver reports no sense.  Very strange...

Peter

=B9
Sep 26 18:29:06 x kernel: sym0:0:0:extraneous data discarded.
Sep 26 18:29:06 x kernel: sym0:0:0:ODD transfer in DATA OUT phase.
Sep 26 18:29:06 x kernel: sym0:0:0:COMMAND FAILED (87 0 9).

--=20
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+'=
'
 Kelemen P=E9ter     /       \       /       \     Peter.Kelemen@cern.c=
h
=2E+'         `+...+'         `+...+'         `+...+'         `+...+'
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
