From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Sun, 21 Jun 2009 18:55:07 GMT
Message-ID: <200906211855.n5LIt7iU026590@demeter.kernel.org>
References: <bug-13594-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41578 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZFUSzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2009 14:55:05 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5LIt7Zk026591
	for <linux-scsi@vger.kernel.org>; Sun, 21 Jun 2009 18:55:07 GMT
In-Reply-To: <bug-13594-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D13594





--- Comment #2 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org> =
 2009-06-21 18:55:06 ---
Reply-To: James.Bottomley@HansenPartnership.com

On Sun, 2009-06-21 at 13:47 -0500, James Bottomley wrote:
> >   [  811.091916] sd 0:0:0:0: [sda] Sense Key : Recovered Error [cur=
rent]
> > [descriptor]
> >   [  811.099807] Descriptor sense data with sense descriptors (in h=
ex):
> >   [  811.106175]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 =
00 00
> >   [  811.113262]         00 4f 00 c2 00 50
> >   [  811.117379] sd 0:0:0:0: [sda] Add. Sense: ATA pass through inf=
ormation
> > available
>=20
> This is a message the kernel prints out on all recovered error return=
s
> (except those marked REQ_QUIET).  It's purely informational and doesn=
't
> affect return processing of the command at all, so the kernel is
> actually treating this as a successful completion not an error.
>=20
> > I've tried upgrading to the newest firmware (1.28.02.00, 05-MAY-200=
9), but
> > all that changed is that the hex dump was added to the error messag=
e.
> >=20
> > Whenever this happens, it appears like all the disks =E2=80=9Chiccu=
p=E2=80=9D and the kernel
> > loses contact with the controller for a small while. If too many of=
 these
> > happen at once, eventually disks start falling off RAIDs, and the e=
ntire
> > machine goes down. It looks to me as if these messages should simpl=
y not be
> > treated as errors by the kernel -- smartctl explicitly asks for a r=
esponse even
> > if the command doesn't fail (by setting CK_COND), so the response p=
robably
> > shouldn't be taken as an error.
>=20
> So this sounds like the bug ... however, for the LSI card, this bug w=
ill
> be in the SAT layer in the fusion firmware.  I can shut the kernel up=
 by
> making the recovered error processing clause look for 01/00/1D as wel=
l
> as REQ_QUIET, but it won't affect this problem.

Actually quieting the message is trivially easy, try this.

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f3c4089..a0235c9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -774,7 +774,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsi=
gned int
good_bytes)
      * is what gets returned to the user
      */
     if (sense_valid && sshdr.sense_key =3D=3D RECOVERED_ERROR) {
-        if (!(req->cmd_flags & REQ_QUIET))
+        if (!(req->cmd_flags & REQ_QUIET) &&
+            !(sshdr.asc =3D=3D 0x00 && sshdr.ascq =3D=3D 0x1d))
             scsi_print_sense("", cmd);
         result =3D 0;
         /* BLOCK_PC may have set error */

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
