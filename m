From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg_dd bpt= count=
Date: 20 Oct 2003 13:49:14 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066679354.2833.66.camel@patehci2>
References: <1066174844.3399.6.camel@patehci2>
	 <1066674092.2833.0.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:2522 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262865AbTJTTtW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 15:49:22 -0400
In-Reply-To: <1066674092.2833.0.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> > sudo sg_dd of=/dev/sg0 if=/dev/zero bs=2k bpt= count=
> > may reliably take down kernels.

To sg3_utils sg_dd.c I first propose the following patch, to persuade
get_num to return determinate results more often.

Specifically I propose changing:

        char c;
        res = sscanf(buf, "%d%c", &num, &c);
        if (0 == res) ...
        else if (1 == res) ...
        else {
                switch (c) { ...

Personally I believe that source fragment switches on uninitialised c in
the situation `man sscanf` describes as: "RETURN VALUE ... The value EOF
is returned if an input failure occurs before any conversion such as an
end-of-file occurs ...".

As a test, I did separately execute get_num("").  For me once the
uninitialised c and num were then 8 and 1108545272 (aka x42130EF8), so
the result was -1.  I notice gcc -Wall doesn't mention this kind of
read-before-write.

Pat LaVarre

P.S. Also I wonder if we would prefer rewriting these "return -1" as
loud exits e.g.:

fprintf(stderr, "file %s line %d\n", __FILE__, __LINE__);
exit(-1);

--- sg3_utils-1.05/sg_dd.c	2003-10-19 03:35:32.000000000 -0600
+++ sg3_utils/sg_dd.c	2003-10-20 13:35:20.515143520 -0600
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


