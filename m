From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] constants.c [was: consolidate and log scsi command on send
 and completion]
Date: Wed, 01 Oct 2003 11:22:32 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F7A2C58.4010809@torque.net>
References: <20030930172134.A10611@beaverton.ibm.com> <20030930172339.A10629@beaverton.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080800000909010101080600"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:53922 "EHLO
	iggy.triode.net.au") by vger.kernel.org with ESMTP id S261845AbTJABXi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2003 21:23:38 -0400
In-Reply-To: <20030930172339.A10629@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080800000909010101080600
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick Mansfield wrote:
> Some sample output showing the command logging (with CONFIG_SCSI_CONSTANTS
> enabled).
> 
> Of course after shutting off syslogd :-(
> 
> And with scsi logging for ml queue of 2 and ml complete of 2 via:
> 
> 	sysctl -w dev.scsi.logging_level=0x2400
> 
> FYI, if you want both ml queue and ml complete both set:
> 
> 	to 	use scsi_logging_level
> 	1		0x1200
> 	2		0x2400
> 	3		0x3600
> 	4		0x4800
> 
> Output for scanning host3 id 0, a0 is REPORT LUNS, interspersed with writes 
> to the root disk <0:0:0:0>, and partition information:
> 
> scsi <3:0:0:0> send                  UNKNOWN(0xa0) 00 00 00 00 00 00 00 04 08 00 00 
> scsi <3:0:0:0> done SUCCESS        0 UNKNOWN(0xa0) 00 00 00 00 00 00 00 04 08 00 00 

looks good ....

However, drivers/scsi/constants.c does know about Report Luns??
Looks like a merging problem by Andries and me sometime back.
See attachment.

Doug Gilbert

--------------080800000909010101080600
Content-Type: text/plain;
 name="s_consts_c260t6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="s_consts_c260t6.diff"

--- linux/drivers/scsi/constants.c	2003-07-31 01:37:47.000000000 +1000
+++ linux/drivers/scsi/constants.c260t6pl	2003-10-01 11:12:35.000000000 +1000
@@ -62,42 +62,54 @@
 
 
 static const char *group_2_commands[] = {
-/* 40-41 */ "Change Definition", "Write Same", 
-/* 42-48 */ "Read sub-channel", "Read TOC", "Read header", 
-            "Play audio (10)", unknown, "Play audio msf",
-            "Play audio track/index", 
-/* 49-4f */ "Play track relative (10)", unknown, "Pause/resume", 
-            "Log Select", "Log Sense", unknown, unknown,
-/* 50-55 */ unknown, unknown, unknown, unknown, unknown, "Mode Select (10)",
-/* 56-5b */ unknown, unknown, unknown, unknown, "Mode Sense (10)", unknown,
-/* 5c-5f */ unknown, unknown, unknown,
+/* 40-41 */ "Change Definition", "Write Same",
+/* 42-48 */ "Read sub-channel", "Read TOC", "Read header",
+            "Play audio (10)", "Get configuration", "Play audio msf",
+            "Play audio track/index",
+/* 49-4f */ "Play track relative (10)", "Get event status notification",
+            "Pause/resume", "Log Select", "Log Sense", "Stop play/scan",
+            unknown,
+/* 50-55 */ "Xdwrite", "Xpwrite, Read disk info", "Xdread, Read track info",
+            "Reserve track", "Send OPC onfo", "Mode Select (10)",
+/* 56-5b */ "Reserve (10)", "Release (10)", "Repair track", "Read master cue",
+            "Mode Sense (10)", "Close track/session",
+/* 5c-5f */ "Read buffer capacity", "Send cue sheet", "Persistent reserve in",
+            "Persistent reserve out",
 };
 
 
 /* The following are 16 byte commands in group 4 */
 static const char *group_4_commands[] = {
-/* 80-84 */ unknown, unknown, unknown, unknown, unknown,
-/* 85-89 */ "Memory Export In (16)", unknown, unknown, unknown,
-            "Memory Export Out (16)",
-/* 8a-8f */ unknown, unknown, unknown, unknown, unknown, unknown,
-/* 90-94 */ unknown, unknown, unknown, unknown, unknown,
+/* 80-84 */ "Xdwrite (16)", "Rebuild (16)", "Regenerate (16)", "Extended copy",
+            "Receive copy results",
+/* 85-89 */ "Memory Export In (16)", "Access control in", "Access control out",
+            "Read (16)", "Memory Export Out (16)",
+/* 8a-8f */ "Write (16)", unknown, "Read attributes", "Write attributes",
+            "Write and verify (16)", "Verify (16)",
+/* 90-94 */ "Pre-fetch (16)", "Synchronize cache (16)",
+            "Lock/unlock cache (16)", "Write same (16)", unknown,
 /* 95-99 */ unknown, unknown, unknown, unknown, unknown,
-/* 9a-9f */ unknown, unknown, unknown, unknown, unknown, unknown,
+/* 9a-9f */ unknown, unknown, unknown, unknown, "Service action in",
+            "Service action out",
 };
 
-
 /* The following are 12 byte commands in group 5 */
 static const char *group_5_commands[] = {
-/* a0-a5 */ unknown, unknown, unknown, unknown, unknown,
-            "Move medium/play audio(12)",
-/* a6-a9 */ "Exchange medium", unknown, "Read(12)", "Play track relative(12)", 
-/* aa-ae */ "Write(12)", unknown, "Erase(12)", unknown, 
-            "Write and verify(12)", 
+/* a0-a5 */ "Report luns", "Blank", "Send event", "Maintenance (in)",
+            "Maintenance (out)", "Move medium/play audio(12)",
+/* a6-a9 */ "Exchange medium", "Move medium attached", "Read(12)",
+            "Play track relative(12)",
+/* aa-ae */ "Write(12)", unknown, "Erase(12), Get Performance",
+            "Read DVD structure", "Write and verify(12)",
 /* af-b1 */ "Verify(12)", "Search data high(12)", "Search data equal(12)",
-/* b2-b4 */ "Search data low(12)", "Set limits(12)", unknown,
-/* b5-b6 */ "Request volume element address", "Send volume tag",
-/* b7-b9 */ "Read defect data(12)", "Read element status", unknown,
-/* ba-bf */ unknown, unknown, unknown, unknown, unknown, unknown,
+/* b2-b4 */ "Search data low(12)", "Set limits(12)",
+            "Read element status attached",
+/* b5-b6 */ "Request volume element address", "Send volume tag, set streaming",
+/* b7-b9 */ "Read defect data(12)", "Read element status", "Read CD msf",
+/* ba-bc */ "Redundancy group (in), Scan",
+            "Redundancy group (out), Set cd-rom speed", "Spare (in), Play cd",
+/* bd-bf */ "Spare (out), Mechanism status", "Volume set (in), Read cd",
+            "Volume set (out), Send DVD structure",
 };
 
 

--------------080800000909010101080600--

