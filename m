From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 14:55:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2747C.784DDA50"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Dave Hansen' <haveblue@us.ibm.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2747C.784DDA50
Content-Type: text/plain;
	charset="iso-8859-1"

Dave,

Here's a patch that should restore the queue depths to what they were before
the
queue depths change was merged in.  Hopefully this well restore your lost
performance.  If I don't hear or find anything bad about it, it will be
going
to Linus shortly.

And thanks goes to Mike Anderson for his initial version.  That made writing
this patch all the easier.

David Jeffery


------_=_NextPart_000_01C2747C.784DDA50
Content-Type: application/octet-stream;
	name="ips2.5.42.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ips2.5.42.patch"

--- linux-2.5.42/drivers/scsi/ips.c	Tue Oct 15 14:34:16 2002=0A=
+++ linux-2.5.42_new/drivers/scsi/ips.c	Tue Oct 15 14:24:13 2002=0A=
@@ -1877,12 +1877,16 @@=0A=
 {=0A=
    ips_ha_t    *ha;=0A=
    int          min;=0A=
+   int          depth;=0A=
 =0A=
    ha =3D IPS_HA(SDptr->host);=0A=
    min =3D ha->max_cmds / 4;=0A=
-   if (min < 8)=0A=
-      min =3D ha->max_cmds - 1;=0A=
-   scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, min);=0A=
+   if((SDptr->type =3D=3D TYPE_DISK) && ha->enq->ucLogDriveCount){=0A=
+      depth =3D (ha->max_cmds - 1) / ha->enq->ucLogDriveCount;=0A=
+      depth =3D max(min, depth);=0A=
+   } else=0A=
+      depth =3D 2;=0A=
+   scsi_adjust_queue_depth(SDptr, MSG_SIMPLE_TAG, depth);=0A=
    return 0;=0A=
 }=0A=
 =0A=

------_=_NextPart_000_01C2747C.784DDA50--
