From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: 2.5.63/64 do not boot: loop in scsi_error
Date: Wed, 5 Mar 2003 17:22:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0303051721570.3061-100000@home.transmeta.com>
References: <UTC200303060101.h2611cg08660.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <UTC200303060101.h2611cg08660.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Thu, 6 Mar 2003 Andries.Brouwer@cwi.nl wrote:
>
> See that 2.5.64 came out - good. Time to send the next dev_t patch.
> Unfortunately 2.5.63 and 2.5.64 do not boot.
> 
> A moment ago I looked at what goes wrong, and it turns out that
> scsi_error is activated

See if this fixes it..

		Linus

---
# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1088  -> 1.1089 
#	drivers/scsi/scsi_error.c	1.38    -> 1.39   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/03/05	andmike@us.ibm.com	1.1089
# [PATCH] Fix SCSI error handler abort case
# 
# I had my list empty checks reversed if aborting and bus device reset
# failed.  The condition that causes the error handler to run is still
# unknown.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Wed Mar  5 17:21:56 2003
+++ b/drivers/scsi/scsi_error.c	Wed Mar  5 17:21:56 2003
@@ -1490,9 +1490,9 @@
 			       struct list_head *work_q,
 			       struct list_head *done_q)
 {
-	if (scsi_eh_bus_device_reset(shost, work_q, done_q))
-		if (scsi_eh_bus_reset(shost, work_q, done_q))
-			if (scsi_eh_host_reset(work_q, done_q))
+	if (!scsi_eh_bus_device_reset(shost, work_q, done_q))
+		if (!scsi_eh_bus_reset(shost, work_q, done_q))
+			if (!scsi_eh_host_reset(work_q, done_q))
 				scsi_eh_offline_sdevs(work_q, done_q);
 }
 
