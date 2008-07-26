From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [SCSI] can't plug Nokia 5300 anymore (bisected)
Date: Sat, 26 Jul 2008 18:46:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0807261826390.28592-100000@netrider.rowland.org>
References: <488AEFA6.5030409@belbone.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1205 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756145AbYGZWqb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2008 18:46:31 -0400
In-Reply-To: <488AEFA6.5030409@belbone.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?C=E9dric_Godin?= <cedric@belbone.be>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Kernel <linux-scsi@vger.kernel.org>

On Sat, 26 Jul 2008, C=E9dric Godin wrote:

> Alan Stern wrote:
> > On Fri, 25 Jul 2008, C=E9dric Godin wrote:
> >
> >  =20
> >> resending because wrong address of lkml and cc scsi list
> >>
> >> Hello,
> >>
> >> since 2 or 3 -git kernels (Linus tree)  I have a problem with my l=
aptop=20
> >> and its connection through USB to a nokia 5300 gsm.
> >>
> >> The logs show me a endless loop (until i unplug my USB cable) of=20
> >> following messages :
> >>
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
> >> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> >>
> >> I bisected the kernel and found the following commit as result :
> >>
> >> 427e59f09fdba387547106de7bab980b7fff77be is first bad commit
> >> commit 427e59f09fdba387547106de7bab980b7fff77be
> >> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> >> Date:   Sat Mar 8 18:24:17 2008 -0600
> >>
> >>    [SCSI] make use of the residue value
> >>
> >>    USB sometimes doesn't return an error but instead returns a res=
idue
> >>    value indicating part (or all) of the command wasn't completed.=
  So if
> >>    the driver _done() error processing indicates the command was f=
ully
> >>    processed, subtract off the residue so that this USB error gets
> >>    propagated.
> >>
> >>    Cc: Alan Stern <stern@rowland.harvard.edu>
> >>    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnersh=
ip.com>
> >>
> >> :040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd=20
> >> c85f8cb8bd4910724f0101e41054555980727e16 M      drivers
> >>
> >>
> >> When reverting it with 2.6.26-06077-gc010b2f , everything is back =
to normal.
> >>    =20
> >
> > Can you post the corresponding dmesg log from a system built with=20
> > CONFIG_USB_STORAGE_DEBUG enabled?
> >
> > Alan Stern
> >
> >  =20
> Sure,
> i attached it

This log doesn't contain an endless loop of error messages.  In fact I=20
see only one error, and the commit you found wouldn't have affected=20
that error.  More accurately, if the commit magnified the error into an=
=20
endless loop, then without the commit the error would still have been=20
present and would have caused data corruption.

Anyway, it would be interesting to see what happens with the commit in=20
place and the following patch applied.  (The first part of the patch=20
has already been accepted by James.)

Alan Stern




Index: usb-2.6/drivers/scsi/scsi_error.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-2.6.orig/drivers/scsi/scsi_error.c
+++ usb-2.6/drivers/scsi/scsi_error.c
@@ -653,6 +653,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd=20
 	ses->sdb =3D scmd->sdb;
 	ses->next_rq =3D scmd->request->next_rq;
 	ses->result =3D scmd->result;
+	ses->underflow =3D scmd->underflow;
=20
 	scmd->cmnd =3D ses->eh_cmnd;
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
@@ -711,6 +712,7 @@ void scsi_eh_restore_cmnd(struct scsi_cm
 	scmd->sdb =3D ses->sdb;
 	scmd->request->next_rq =3D ses->next_rq;
 	scmd->result =3D ses->result;
+	scmd->underflow =3D ses->underflow;
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);
=20
Index: usb-2.6/include/scsi/scsi_eh.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-2.6.orig/include/scsi/scsi_eh.h
+++ usb-2.6/include/scsi/scsi_eh.h
@@ -73,6 +73,7 @@ extern int scsi_reset_provider(struct sc
 struct scsi_eh_save {
 	/* saved state */
 	int result;
+	unsigned underflow;
 	enum dma_data_direction data_direction;
 	unsigned char cmd_len;
 	unsigned char *cmnd;
Index: usb-2.6/drivers/usb/storage/transport.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-2.6.orig/drivers/usb/storage/transport.c
+++ usb-2.6/drivers/usb/storage/transport.c
@@ -663,7 +663,7 @@ void usb_stor_invoke_transport(struct sc
 	}
=20
 	/* Did we transfer less than the minimum amount required? */
-	if (srb->result =3D=3D SAM_STAT_GOOD &&
+	if ((srb->result =3D=3D SAM_STAT_GOOD || srb->sense_buffer[2] =3D=3D =
0) &&
 			scsi_bufflen(srb) - scsi_get_resid(srb) < srb->underflow)
 		srb->result =3D (DID_ERROR << 16) | (SUGGEST_RETRY << 24);
=20


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
