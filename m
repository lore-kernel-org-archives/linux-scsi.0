From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as33) Remove /proc/scsi directory in scsi_remove_host()
Date: Wed, 11 Jun 2003 13:41:03 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0306111328330.696-100000@ida.rowland.org>
References: <20030521180308.GD1116@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:7172 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263131AbTFKR1X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2003 13:27:23 -0400
In-Reply-To: <20030521180308.GD1116@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Mike:

You may know this already; if so please forgive the redundant information.  
The reworking of the host registration code in 2.5.70 has a bug that
prevents the host's directory in /proc/scsi from being removed when the
host is unregistered.  The cause of the problem is that
scsi_proc_host_rm() is checking for shost->hostt->present == 0, but it is
called before scsi_free_shost() which is where shost->hostt->present gets
decremented.

Since there doesn't really seem to be any need to check
shost->hostt->present (hosts shouldn't be removed more than once), I
removed that line.  I also reset shost->hostt->proc_dir back to NULL, in
case the same host template is used again later to register another host.

(There's another problem that prevents scsi_free_shost() from being called 
at all, but that's a bug in the driver model core.  I've submitted a 
separate report about that.)

Alan Stern


===== scsi_proc.c 1.11 vs edited =====
--- 1.11/drivers/scsi/scsi_proc.c	Mon May 26 14:01:11 2003
+++ edited/drivers/scsi/scsi_proc.c	Wed Jun 11 13:22:43 2003
@@ -149,8 +149,8 @@
 
 	sprintf(name,"%d", shost->host_no);
 	remove_proc_entry(name, shost->hostt->proc_dir);
-	if (!shost->hostt->present)
-		remove_proc_entry(shost->hostt->proc_name, proc_scsi);
+	remove_proc_entry(shost->hostt->proc_name, proc_scsi);
+	shost->hostt->proc_dir = NULL;
 }
 
 static void proc_print_scsidevice(struct scsi_device* sdev, char *buffer,

