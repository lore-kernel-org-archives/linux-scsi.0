From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg_dd bpt= count=
Date: 20 Oct 2003 15:34:15 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066685655.3128.10.camel@patehci2>
References: <1066174844.3399.6.camel@patehci2>
	 <1066674092.2833.0.camel@patehci2>  <1066679354.2833.66.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:52370 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262817AbTJTVeX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 17:34:23 -0400
In-Reply-To: <1066679354.2833.66.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug G:

Have we reached closure now?  I also see crashes if I try:

sg_dd of=/dev/sg0 bs=2k bpt=-1

To oops this way, I only need write privileges into some of /dev/sg*,
not the other root privileges.

Therefore I now propose the following patch, a replacement of and an
improvement on my earlier sg3_utils-1.05/sg_dd.c patch.

I got to this patch courtesy some fprintf stderr and one-second sleeps. 
I now think `sg_dd of=/dev/sg0 bs=2k bpt=` can mean, in part:

#include <fcntl.h>
#include <scsi/sg.h>
#include <sys/ioctl.h>
#include <unistd.h>

int main(void)
{
	char const * fn = "/dev/sg0";
	int fd = open(fn, O_RDWR);
	if (0 <= fd) {
		int t = -2048;
		ioctl(fd, SG_SET_RESERVED_SIZE, &t);
	}
	return 0;
}

Compiled separately, that specific example takes down 2.6.0-test8 here,
same as sg_dd does.  Ctrl+Alt+F2 worked long enough for me to die in an
alternate console, but still I died.

SG_SET_RESERVED_SIZE at Google is:
http://www.tldp.org/HOWTO/SCSI-Generic-HOWTO/gs_rs_size.html
but that doesn't tell me what the permissible range of t is.

Nonnegative is my guess of our intent, I see bpt=0 does not so
immediately oops.

Pat LaVarre

diff -u sg3_utils-1.05/sg_dd.c sg3_utils/sg_dd.c
--- sg3_utils-1.05/sg_dd.c	2003-10-19 03:35:32.000000000 -0600
+++ sg3_utils/sg_dd.c	2003-10-20 15:18:06.204065056 -0600
@@ -475,10 +475,10 @@
     char c;
 
     res = sscanf(buf, "%d%c", &num, &c);
-    if (0 == res)
-        return -1;
-    else if (1 == res)
+    if (1 == res)
         return num;
+    else if (2 != res)
+        return -1;
     else {
         switch (c) {
         case 'c':
@@ -621,6 +621,10 @@
         usage();
         return 1;
     }
+    if (bpt < 0) {
+        fprintf(stderr, "bpt cannot be negative\n");
+        return 1;
+    }
     if ((skip < 0) || (seek < 0)) {
         fprintf(stderr, "skip and seek cannot be negative\n");
         return 1;


