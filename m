From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg_scan -i /dev/sg[0123] /dev/hd[abcd] /dev/scd[0123]
Date: 08 Dec 2003 11:29:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070908146.2263.121.camel@patibmrh9>
References: <1070670440.3056.7.camel@patibmrh9>
	 <3FD43229.7070708@torque.net>  <1070906283.2263.101.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:17320 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261670AbTLHS3R
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2003 13:29:17 -0500
In-Reply-To: <1070906283.2263.101.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> > > From:sg_scan.8
> 
> ... only the ... predefined -a and -n device lists

The trivial inline patch here does let us choose as we please out of
/dev/sg* , for example:

$ sudo sg_scan /dev/sg*
/dev/sg0: scsi0 channel=0 id=0 lun=0 [em]  type=5
$ sudo sg_scan /dev/sg2 /dev/sg1
$ sudo sg_scan /dev/sg0
/dev/sg0: scsi0 channel=0 id=0 lun=0 [em]  type=5
$

But 2.6.0-test11 drivers/block/scsi_ioctl.c doesn't much like sg utils
sg_scan.c:

$
$ sudo sg_scan /dev/hd[acd]
sg_scan: device /dev/hda failed on scsi ioctl, skip: Invalid argument
sg_scan: device /dev/hdc ioctls(4), skip: Invalid argument
sg_scan: device /dev/hdd ioctls(4), skip: Invalid argument
/dev/hdc: scsi0 channel=0 id=0 lun=0 [em]/dev/hdd: scsi0 channel=0 id=0 lun=0 [em]$
$

Pat LaVarre

diff -Nurp sg3_utils-1.06/sg_scan.c sg3_utils/sg_scan.c
--- sg3_utils-1.06/sg_scan.c	2003-11-11 21:30:59.000000000 -0700
+++ sg3_utils/sg_scan.c	2003-12-08 11:19:51.156943240 -0700
@@ -145,6 +145,7 @@ int main(int argc, char * argv[])
     int host_no;
     int flags;
     int emul;
+    int name0 = -1;
 
     for (k = 1; k < argc; ++k) {
         if (0 == strcmp("-n", argv[k]))
@@ -168,6 +169,10 @@ int main(int argc, char * argv[])
             usage();
             return 1;
         }
+        else if (*argv[k] == '/') {
+            name0 = k;
+            break;
+        }
         else if (*argv[k] != '-') {
             printf("Unknown argument\n");
             usage();
@@ -184,7 +189,20 @@ int main(int argc, char * argv[])
             perror(ME "close error");
             return 1;
         }
-        make_dev_name(fname, k, do_numeric);
+
+        if (name0 < 0) {
+            make_dev_name(fname, k, do_numeric);
+        }
+        else if (k < name0) {
+            sg_fd = -1;
+            continue;
+        }
+        else if (k < argc) {
+            strncpy(&fname[0], argv[k], sizeof fname);
+        }
+        else {
+            break;
+        }
 
         sg_fd = open(fname, flags | O_NONBLOCK);
         if (sg_fd < 0) {


