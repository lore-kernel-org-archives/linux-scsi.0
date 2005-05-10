From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: [PATCH] sg3_utils sg_map: add support for sparse 3-character disk
	 names
Date: Tue, 10 May 2005 16:00:35 -0400
Message-ID: <92952AEF1F064042B6EF2522E0EEF4373482AA@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5559A.EDB210B1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub4.stratus.com ([134.111.1.17]:42668 "EHLO
	mailhub4.stratus.com") by vger.kernel.org with ESMTP
	id S261768AbVEJUAw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2005 16:00:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'dougg@torque.net'" <dougg@torque.net>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5559A.EDB210B1
Content-Type: text/plain

I'm not sure if this patch would be useful (or desirable) to anyone else,
but I thought I'd share it just in case.

Using udev to assign 3 character sd names (sdaaa, for example), generated
based on where a disk is physically located. There are problems using sg_map
in this situation for two reasons: 1) the names are too long, and 2) the
names are sparsely allocated and sg_map doesn't like this.

This patch (sg_map.c.1.14.patch, against version 1.14 of sg3_utils) modifies
sg_map to allow 3 character sparse names. Here's what I changed:

- increase MAX_SD_DEVS to the maximum # for up to 3 character names
- modified make_dev_name to handle 3 character names
- ignore ENOENT in scan_dev_type to allow for names to be sparsely allocated

This was the quickest, easiest way to make sg_map work in this situation...
I realize it's not a nice general solution to the problem.
 
Nate Dailey
Stratus Technologies


Signed-off-by: Nate Dailey <nate.dailey@stratus.com>


------_=_NextPart_000_01C5559A.EDB210B1
Content-Type: application/octet-stream;
	name="sg_map.c-1.14.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="sg_map.c-1.14.patch"

--- sg_map.c.orig	2005-05-06 14:36:02.750844160 -0400=0A=
+++ sg_map.c	2005-05-06 14:38:28.661662344 -0400=0A=
@@ -59,7 +59,7 @@ typedef struct my_map_info=0A=
 =0A=
 =0A=
 #define MAX_SG_DEVS 256=0A=
-#define MAX_SD_DEVS 128=0A=
+#define MAX_SD_DEVS 26 + 26*26 + 26*26*26 /* sdX, sdXX, sdXXX */=0A=
 #define MAX_SR_DEVS 128=0A=
 #define MAX_ST_DEVS 128=0A=
 #define MAX_OSST_DEVS 128=0A=
@@ -111,31 +111,34 @@ static void make_dev_name(char * fname, =0A=
                           int do_numeric)=0A=
 {=0A=
     char buff[64];=0A=
-    int  big,little;=0A=
+    int  ones,tens,hundreds; /* for lack of a better name */=0A=
+    int  buff_idx;=0A=
 =0A=
     strcpy(fname, leadin ? leadin : "/dev/sg");=0A=
     if (do_numeric) {=0A=
         sprintf(buff, "%d", k);=0A=
         strcat(fname, buff);=0A=
     }=0A=
+    else if (k >=3D (26 + 26*26 + 26*26*26)) {=0A=
+        strcat(fname, "xxxx");=0A=
+    }=0A=
     else {=0A=
-        if (k < 26) {=0A=
-            buff[0] =3D 'a' + (char)k;=0A=
-            buff[1] =3D '\0';=0A=
-            strcat(fname, buff);=0A=
-        }=0A=
-        else if (k <=3D 255) { /* assumes sequence goes x,y,z,aa,ab,ac =
etc */=0A=
-            big    =3D k/26;=0A=
-            little =3D k - (26 * big);=0A=
-            big    =3D big - 1;=0A=
-=0A=
-            buff[0] =3D 'a' + (char)big;=0A=
-            buff[1] =3D 'a' + (char)little;=0A=
-            buff[2] =3D '\0';=0A=
-            strcat(fname, buff);=0A=
-        }=0A=
-        else=0A=
-            strcat(fname, "xxxx");=0A=
+        ones =3D k % 26;=0A=
+=0A=
+        if ((k - 26) >=3D 0)=0A=
+            tens =3D ((k-26)/26) % 26;=0A=
+        else tens =3D -1;=0A=
+=0A=
+        if ((k - (26 + 26*26)) >=3D 0)=0A=
+             hundreds =3D ((k - (26 + 26*26))/(26*26)) % 26;=0A=
+        else hundreds =3D -1;=0A=
+=0A=
+        buff_idx =3D 0;=0A=
+        if (hundreds >=3D 0) buff[buff_idx++] =3D 'a' + =
(char)hundreds;=0A=
+        if (tens >=3D 0) buff[buff_idx++] =3D 'a' + (char)tens;=0A=
+        buff[buff_idx++] =3D 'a' + (char)ones;=0A=
+        buff[buff_idx] =3D '\0';=0A=
+        strcat(fname, buff);=0A=
     }=0A=
 }=0A=
 =0A=
@@ -394,20 +397,17 @@ static void scan_dev_type(const char * l=0A=
             if (EBUSY =3D=3D errno) {=0A=
                 printf("Device %s is busy\n", fname);=0A=
                 ++num_errors;=0A=
-                continue;=0A=
             }=0A=
-            else if ((ENODEV =3D=3D errno) || (ENOENT =3D=3D errno) =
||=0A=
-                     (ENXIO =3D=3D errno)) {=0A=
+            else if ((ENODEV =3D=3D errno) || (ENXIO =3D=3D errno)) =
{=0A=
                 ++num_errors;=0A=
                 ++num_silent;=0A=
-                continue;=0A=
             }=0A=
-            else {=0A=
+            else if (ENOENT !=3D errno) { /* ignore ENOENT for sparse =
names */=0A=
                 snprintf(ebuff, EBUFF_SZ, "Error opening %s ", =
fname);=0A=
                 perror(ebuff);=0A=
                 ++num_errors;=0A=
-                continue;=0A=
             }=0A=
+            continue;=0A=
         }=0A=
 =0A=
         res =3D ioctl(sg_fd, SCSI_IOCTL_GET_IDLUN, &my_idlun);=0A=

------_=_NextPart_000_01C5559A.EDB210B1--
