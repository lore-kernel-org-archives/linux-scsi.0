From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: does scsi_io_completion need to dump sense data for ata pass through (ck_cond = 1) ?
Date: Tue, 22 Dec 2009 19:17:36 +0100
Message-ID: <200912221917.36495.kb@sysmikro.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from v007470.home.net.pl ([212.85.125.104]:64140 "HELO
	v007470.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751138AbZLVSY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2009 13:24:26 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eric@andante.org, linux-scsi@vger.kernel.org
Cc: Krzysztof.b@id-7.com

Hello Eric,

I think it is not necessary and current behavior of kernel like 2.6.31=20
confuses QA people.=20
They need explanation that message like below:

sd 5:0:1:0: [sdb] Sense Key : Recovered Error [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
=A0 =A0 =A0 =A0 72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
=A0 =A0 =A0 =A0 00 00 00 00 00 50
sd 5:0:1:0: [sdb] Add. Sense: ATA pass through information available

stands for that sense data contains ata registers file and the command =
was=20
executed properly.

Here is additional condition i used in scsi_io_completion() which suppr=
esses=20
this message. Is it okay ?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f3c4089..7e8555a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -774,8 +774,18 @@ void scsi_io_completion(struct scsi_cmnd *cmd, uns=
igned=20
int good_bytes)
 	 * is what gets returned to the user
 	 */
 	if (sense_valid && sshdr.sense_key =3D=3D RECOVERED_ERROR) {
-		if (!(req->cmd_flags & REQ_QUIET))
-			scsi_print_sense("", cmd);
+		if (!(req->cmd_flags & REQ_QUIET) &&=20
+		    !((req->cmd[0] =3D=3D ATA_16 || req->cmd[0] =3D=3D ATA_12)=20
+			&& (req->cmd[2] & (1 << 5))) ) {
+				/* skip reporting sense data for satl
+					ATA_12/16 if CK_COND bit is set
+					because:
+					- sense is delivered to app,
+					- by default cmd ends up with
+					    0x50 status byte
+				*/
+				scsi_print_sense("", cmd);
+			}
 		result =3D 0;
 		/* BLOCK_PC may have set error */
 		error =3D 0;



This is something offtopic but i don't know yet where to look for answe=
r to=20
following issue with native 2.6.31.5.  I noticed that very often there =
is=20
used oom killer on a box with xeon (dual core), 2G ram during e.g. make=
 -j2=20
modules so make can be killed but also e.g. ssh, hald (saw in dmesg). A=
nyway=20
make modules  (! without j2 !)somewhat works also this issue doesn't ha=
ppen=20
with kernel like 2.6.27.19 (Suse patches) - no matter make forks any ti=
me it=20
wants.

Any ideas ?


Regards,
Krzysztof Blaszkowski




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
