From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 15/34] scsi proc_ops: convert drivers/scsi/BusLogic.c
Date: Wed, 22 Feb 2012 22:46:06 +0300
Message-ID: <1329939985-26793-15-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44011 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2BVTrA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:00 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433831bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:46:59 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/BusLogic.c |  103 ++++++++++++++++++++++++----------------------
 drivers/scsi/BusLogic.h |    1 -
 2 files changed, 54 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index f66c33b..58e9bd2 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -39,6 +39,8 @@
 #include <linux/mm.h>
 #include <linux/stat.h>
 #include <linux/pci.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/dma-mapping.h>
@@ -3198,30 +3200,19 @@ static int BusLogic_BIOSDiskParameters(struct scsi_device *sdev, struct block_de
 }
 
 
-/*
-  BugLogic_ProcDirectoryInfo implements /proc/scsi/BusLogic/<N>.
-*/
-
-static int BusLogic_ProcDirectoryInfo(struct Scsi_Host *shost, char *ProcBuffer, char **StartPointer, off_t Offset, int BytesAvailable, int WriteFlag)
+/* /proc/scsi/BusLogic/<N> */
+static int buslogic_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *shost = m->private;
 	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) shost->hostdata;
 	struct BusLogic_TargetStatistics *TargetStatistics;
-	int TargetID, Length;
-	char *Buffer;
+	int TargetID;
 
 	TargetStatistics = HostAdapter->TargetStatistics;
-	if (WriteFlag) {
-		HostAdapter->ExternalHostAdapterResets = 0;
-		HostAdapter->HostAdapterInternalErrors = 0;
-		memset(TargetStatistics, 0, BusLogic_MaxTargetDevices * sizeof(struct BusLogic_TargetStatistics));
-		return 0;
-	}
-	Buffer = HostAdapter->MessageBuffer;
-	Length = HostAdapter->MessageBufferLength;
-	Length += sprintf(&Buffer[Length], "\n\
+	seq_printf(m, "\n\
 Current Driver Queue Depth:	%d\n\
 Currently Allocated CCBs:	%d\n", HostAdapter->DriverQueueDepth, HostAdapter->AllocatedCCBs);
-	Length += sprintf(&Buffer[Length], "\n\n\
+	seq_printf(m, "\n\n\
 			   DATA TRANSFER STATISTICS\n\
 \n\
 Target	Tagged Queuing	Queue Depth  Active  Attempted	Completed\n\
@@ -3230,66 +3221,62 @@ Target	Tagged Queuing	Queue Depth  Active  Attempted	Completed\n\
 		struct BusLogic_TargetFlags *TargetFlags = &HostAdapter->TargetFlags[TargetID];
 		if (!TargetFlags->TargetExists)
 			continue;
-		Length += sprintf(&Buffer[Length], "  %2d	%s", TargetID, (TargetFlags->TaggedQueuingSupported ? (TargetFlags->TaggedQueuingActive ? "    Active" : (HostAdapter->TaggedQueuingPermitted & (1 << TargetID)
+		seq_printf(m, "  %2d	%s", TargetID, (TargetFlags->TaggedQueuingSupported ? (TargetFlags->TaggedQueuingActive ? "    Active" : (HostAdapter->TaggedQueuingPermitted & (1 << TargetID)
 																				    ? "  Permitted" : "   Disabled"))
 									  : "Not Supported"));
-		Length += sprintf(&Buffer[Length],
+		seq_printf(m,
 				  "	    %3d       %3u    %9u	%9u\n", HostAdapter->QueueDepth[TargetID], HostAdapter->ActiveCommands[TargetID], TargetStatistics[TargetID].CommandsAttempted, TargetStatistics[TargetID].CommandsCompleted);
 	}
-	Length += sprintf(&Buffer[Length], "\n\
+	seq_printf(m, "\n\
 Target  Read Commands  Write Commands   Total Bytes Read    Total Bytes Written\n\
 ======  =============  ==============  ===================  ===================\n");
 	for (TargetID = 0; TargetID < HostAdapter->MaxTargetDevices; TargetID++) {
 		struct BusLogic_TargetFlags *TargetFlags = &HostAdapter->TargetFlags[TargetID];
 		if (!TargetFlags->TargetExists)
 			continue;
-		Length += sprintf(&Buffer[Length], "  %2d	  %9u	 %9u", TargetID, TargetStatistics[TargetID].ReadCommands, TargetStatistics[TargetID].WriteCommands);
+		seq_printf(m, "  %2d	  %9u	 %9u", TargetID, TargetStatistics[TargetID].ReadCommands, TargetStatistics[TargetID].WriteCommands);
 		if (TargetStatistics[TargetID].TotalBytesRead.Billions > 0)
-			Length += sprintf(&Buffer[Length], "     %9u%09u", TargetStatistics[TargetID].TotalBytesRead.Billions, TargetStatistics[TargetID].TotalBytesRead.Units);
+			seq_printf(m, "     %9u%09u", TargetStatistics[TargetID].TotalBytesRead.Billions, TargetStatistics[TargetID].TotalBytesRead.Units);
 		else
-			Length += sprintf(&Buffer[Length], "		%9u", TargetStatistics[TargetID].TotalBytesRead.Units);
+			seq_printf(m, "		%9u", TargetStatistics[TargetID].TotalBytesRead.Units);
 		if (TargetStatistics[TargetID].TotalBytesWritten.Billions > 0)
-			Length += sprintf(&Buffer[Length], "   %9u%09u\n", TargetStatistics[TargetID].TotalBytesWritten.Billions, TargetStatistics[TargetID].TotalBytesWritten.Units);
+			seq_printf(m, "   %9u%09u\n", TargetStatistics[TargetID].TotalBytesWritten.Billions, TargetStatistics[TargetID].TotalBytesWritten.Units);
 		else
-			Length += sprintf(&Buffer[Length], "	     %9u\n", TargetStatistics[TargetID].TotalBytesWritten.Units);
+			seq_printf(m, "	     %9u\n", TargetStatistics[TargetID].TotalBytesWritten.Units);
 	}
-	Length += sprintf(&Buffer[Length], "\n\
+	seq_printf(m, "\n\
 Target  Command    0-1KB      1-2KB      2-4KB      4-8KB     8-16KB\n\
 ======  =======  =========  =========  =========  =========  =========\n");
 	for (TargetID = 0; TargetID < HostAdapter->MaxTargetDevices; TargetID++) {
 		struct BusLogic_TargetFlags *TargetFlags = &HostAdapter->TargetFlags[TargetID];
 		if (!TargetFlags->TargetExists)
 			continue;
-		Length +=
-		    sprintf(&Buffer[Length],
+		seq_printf(m,
 			    "  %2d	 Read	 %9u  %9u  %9u  %9u  %9u\n", TargetID,
 			    TargetStatistics[TargetID].ReadCommandSizeBuckets[0],
 			    TargetStatistics[TargetID].ReadCommandSizeBuckets[1], TargetStatistics[TargetID].ReadCommandSizeBuckets[2], TargetStatistics[TargetID].ReadCommandSizeBuckets[3], TargetStatistics[TargetID].ReadCommandSizeBuckets[4]);
-		Length +=
-		    sprintf(&Buffer[Length],
+		seq_printf(m,
 			    "  %2d	 Write	 %9u  %9u  %9u  %9u  %9u\n", TargetID,
 			    TargetStatistics[TargetID].WriteCommandSizeBuckets[0],
 			    TargetStatistics[TargetID].WriteCommandSizeBuckets[1], TargetStatistics[TargetID].WriteCommandSizeBuckets[2], TargetStatistics[TargetID].WriteCommandSizeBuckets[3], TargetStatistics[TargetID].WriteCommandSizeBuckets[4]);
 	}
-	Length += sprintf(&Buffer[Length], "\n\
+	seq_printf(m, "\n\
 Target  Command   16-32KB    32-64KB   64-128KB   128-256KB   256KB+\n\
 ======  =======  =========  =========  =========  =========  =========\n");
 	for (TargetID = 0; TargetID < HostAdapter->MaxTargetDevices; TargetID++) {
 		struct BusLogic_TargetFlags *TargetFlags = &HostAdapter->TargetFlags[TargetID];
 		if (!TargetFlags->TargetExists)
 			continue;
-		Length +=
-		    sprintf(&Buffer[Length],
+		seq_printf(m,
 			    "  %2d	 Read	 %9u  %9u  %9u  %9u  %9u\n", TargetID,
 			    TargetStatistics[TargetID].ReadCommandSizeBuckets[5],
 			    TargetStatistics[TargetID].ReadCommandSizeBuckets[6], TargetStatistics[TargetID].ReadCommandSizeBuckets[7], TargetStatistics[TargetID].ReadCommandSizeBuckets[8], TargetStatistics[TargetID].ReadCommandSizeBuckets[9]);
-		Length +=
-		    sprintf(&Buffer[Length],
+		seq_printf(m,
 			    "  %2d	 Write	 %9u  %9u  %9u  %9u  %9u\n", TargetID,
 			    TargetStatistics[TargetID].WriteCommandSizeBuckets[5],
 			    TargetStatistics[TargetID].WriteCommandSizeBuckets[6], TargetStatistics[TargetID].WriteCommandSizeBuckets[7], TargetStatistics[TargetID].WriteCommandSizeBuckets[8], TargetStatistics[TargetID].WriteCommandSizeBuckets[9]);
 	}
-	Length += sprintf(&Buffer[Length], "\n\n\
+	seq_printf(m, "\n\n\
 			   ERROR RECOVERY STATISTICS\n\
 \n\
 	  Command Aborts      Bus Device Resets	  Host Adapter Resets\n\
@@ -3300,22 +3287,40 @@ Target	Requested Completed  Requested Completed  Requested Completed\n\
 		struct BusLogic_TargetFlags *TargetFlags = &HostAdapter->TargetFlags[TargetID];
 		if (!TargetFlags->TargetExists)
 			continue;
-		Length += sprintf(&Buffer[Length], "\
+		seq_printf(m, "\
   %2d	 %5d %5d %5d    %5d %5d %5d	   %5d %5d %5d\n", TargetID, TargetStatistics[TargetID].CommandAbortsRequested, TargetStatistics[TargetID].CommandAbortsAttempted, TargetStatistics[TargetID].CommandAbortsCompleted, TargetStatistics[TargetID].BusDeviceResetsRequested, TargetStatistics[TargetID].BusDeviceResetsAttempted, TargetStatistics[TargetID].BusDeviceResetsCompleted, TargetStatistics[TargetID].HostAdapterResetsRequested, TargetStatistics[TargetID].HostAdapterResetsAttempted, TargetStatistics[TargetID].HostAdapterResetsCompleted);
 	}
-	Length += sprintf(&Buffer[Length], "\nExternal Host Adapter Resets: %d\n", HostAdapter->ExternalHostAdapterResets);
-	Length += sprintf(&Buffer[Length], "Host Adapter Internal Errors: %d\n", HostAdapter->HostAdapterInternalErrors);
-	if (Length >= BusLogic_MessageBufferSize)
-		BusLogic_Error("Message Buffer length %d exceeds size %d\n", HostAdapter, Length, BusLogic_MessageBufferSize);
-	if ((Length -= Offset) <= 0)
-		return 0;
-	if (Length >= BytesAvailable)
-		Length = BytesAvailable;
-	memcpy(ProcBuffer, HostAdapter->MessageBuffer + Offset, Length);
-	*StartPointer = ProcBuffer;
-	return Length;
+	seq_printf(m, "\nExternal Host Adapter Resets: %d\n", HostAdapter->ExternalHostAdapterResets);
+	seq_printf(m, "Host Adapter Internal Errors: %d\n", HostAdapter->HostAdapterInternalErrors);
+
+	return 0;
+}
+
+static int buslogic_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, buslogic_proc_show, PDE(inode)->data);
+}
+
+static ssize_t buslogic_proc_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
+{
+	struct Scsi_Host *shost = PDE(file->f_path.dentry->d_inode)->data;
+	struct BusLogic_HostAdapter *HostAdapter = (struct BusLogic_HostAdapter *) shost->hostdata;
+	struct BusLogic_TargetStatistics *TargetStatistics = HostAdapter->TargetStatistics;
+
+	HostAdapter->ExternalHostAdapterResets = 0;
+	HostAdapter->HostAdapterInternalErrors = 0;
+	memset(TargetStatistics, 0, BusLogic_MaxTargetDevices * sizeof(struct BusLogic_TargetStatistics));
+
+	return count;
 }
 
+static const struct file_operations buslogic_proc_ops = {
+	.open		= buslogic_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= buslogic_proc_write,
+};
 
 /*
   BusLogic_Message prints Driver Messages.
@@ -3567,7 +3572,7 @@ static int __init BusLogic_ParseDriverOptions(char *OptionsString)
 static struct scsi_host_template Bus_Logic_template = {
 	.module = THIS_MODULE,
 	.proc_name = "BusLogic",
-	.proc_info = BusLogic_ProcDirectoryInfo,
+	.proc_ops = &buslogic_proc_ops,
 	.name = "BusLogic",
 	.info = BusLogic_DriverInfo,
 	.queuecommand = BusLogic_QueueCommand,
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 649fcb3..6c6c13c 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -1321,7 +1321,6 @@ static inline void BusLogic_IncrementSizeBucket(BusLogic_CommandSizeBuckets_T Co
 static const char *BusLogic_DriverInfo(struct Scsi_Host *);
 static int BusLogic_QueueCommand(struct Scsi_Host *h, struct scsi_cmnd *);
 static int BusLogic_BIOSDiskParameters(struct scsi_device *, struct block_device *, sector_t, int *);
-static int BusLogic_ProcDirectoryInfo(struct Scsi_Host *, char *, char **, off_t, int, int);
 static int BusLogic_SlaveConfigure(struct scsi_device *);
 static void BusLogic_QueueCompletedCCB(struct BusLogic_CCB *);
 static irqreturn_t BusLogic_InterruptHandler(int, void *);
-- 
1.7.3.4

