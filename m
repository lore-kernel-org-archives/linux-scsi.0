From: Luben Tuikov <luben@splentec.com>
Subject: [RFC] Some comments on ``pending'' and Coding Style
Date: Mon, 10 Mar 2003 15:48:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6CFA2E.6080604@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id h2AKmiL03863
	for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2003 15:48:44 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 > though SAM-3 references
 > pending, I don't see any SAM references to deferred.

Ok, so you should've seen the definition of ``pending command'' then.

The comments in brackets ([]) are mine.

SAM-3r05 gives the following definition:

   3.1.72 pending command: From the point of view of the
   application client [SCSI Core], the description of command
   between the time that the application client [SCSI Core] calls
   the Send SCSI Command SCSI transport protocol service [queuecommand()]
   and the time one of the SCSI target device responses described in
   5.5 is received [scsi_done()].

This is what ``pending_q'' describes.  This is how I've used
it in mini-scsi-core: insert just before a call to queuecommand()
into pending_q, move to done_q at scsi_done().

[[This way you get a nice closed logical loop of the entities
who the command, from the slab, through the queues, back to the
slab.]]

And this is why I want the variable names to be from the point of
view of SCSI Core.

Documentation/CodingStyle: Most of the things in there, clearly, are from
``The Elements of Programming Style'' by Kernighan and Plauger,
2nd ed, 1988, McGraw-Hill.

In the same line of thought, earlier today I submitted this patch:

--- linux-2.5.64/Documentation/CodingStyle.orig	2003-03-10 11:23:46.000000000 -0500
+++ linux-2.5.64/Documentation/CodingStyle	2003-03-10 11:37:18.000000000 -0500
@@ -1,3 +1,4 @@
+Updated: Mon Mar 10 16:34:35 UTC 2003

  		Linux kernel coding style

@@ -264,3 +265,26 @@

  Remember: if another thread can find your data structure, and you don't
  have a reference count on it, you almost certainly have a bug.
+
+
+		Chapter 9: Organization
+
+Writing efficient code is important in both complexity and
+implementation.  In other words your code organization should NOT be
+too complex to understand.  Complexity directly depends on the choice
+of data representation and code organization.  To help you stay in
+line, here are a few guidelines to follow:
+
+      Modularize.
+      Use subroutines.
+      Each subroutine/module should do one thing well.
+      Make sure every module/subroutine hides something.
+      Localize input and output in subroutines.
+
+And the most important:
+
+    Choose the data representation that makes the program simple.
+
+
+			      ----------
+

-- 
Luben

