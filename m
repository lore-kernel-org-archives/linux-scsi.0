From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH] scsi: iterate over devices individually for /proc/scsi/scsi
Date: Mon, 29 Oct 2007 17:50:32 -0400
Message-ID: <472655A8.1090700@suse.com>
References: <461E89C8.7040507@suse.com> <20070413072506.GA20326@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbXJ2VrS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 17:47:18 -0400
In-Reply-To: <20070413072506.GA20326@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> On Thu, Apr 12, 2007 at 03:34:32PM -0400, Jeff Mahoney wrote:
>>  On systems with very large numbers (> 1600 or so) of SCSI devices,
>>  cat /proc/scsi/scsi ends up failing with -ENOMEM. This is due to
>>  the show routine simply iterating over all of the devices with
>>  bus_for_each_dev(), and trying to dump all of them into the buffer
>>  at the same time. On my test system (using scsi_debug with 4064 devices),
>>  the output ends up being ~ 632k, far more than kmalloc will typically allow.
>>
>>  This patch uses seq_file directly instead of single_file, and breaks up
>>  the operations into the 4 seq_file callbacks. The result is that
>>  each show() operation only dumps ~ 180 bytes into the buffer at a time
>>  so we don't run out of memory.
> 
> The simpler answer is don't use /proc/scsi/scsi, but lsscsi instead.
> It even has an option to provide /proc/scsi/scsi-style output.
> 
> This already came up the last time someone from SuSE sent a patch
> to fix an "issue" like that.  That time at least the patch was
> massageable into something sane, which this one isn't.  So please
> take the advice this time and stop using /proc/scsi/scsi.

This should be something a bit more sane. After writing this up, I'm in
complete agreement with you on how much of an unsalvagable mess the
previous patch was.

 On systems with very large numbers (> 1600 or so) of SCSI devices,
 cat /proc/scsi/scsi ends up failing with -ENOMEM. This is due to
 the show routine simply iterating over all of the devices with
 bus_for_each_dev(), and trying to dump all of them into the buffer
 at the same time. On my test system (using scsi_debug with 4064 devices),
 the output ends up being ~ 632k, far more than kmalloc will typically allow.

 This patch defines its own seq_file opreations to iterate over the scsi
 devices.The result is that each show() operation only dumps ~ 180 bytes
 into the buffer at a time so we don't run out of memory.

 If the "Attached devices" header isn't required, we can dump the
 sfile->private bit completely.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---

 drivers/scsi/scsi_proc.c |   58 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 52 insertions(+), 6 deletions(-)

--- a/drivers/scsi/scsi_proc.c	2007-10-29 13:56:28.000000000 -0400
+++ b/drivers/scsi/scsi_proc.c	2007-10-29 15:50:57.000000000 -0400
@@ -294,20 +294,66 @@ static ssize_t proc_scsi_write(struct fi
 	return err;
 }
 
-static int proc_scsi_show(struct seq_file *s, void *p)
+static int always_match(struct device *dev, void *data)
 {
-	seq_printf(s, "Attached devices:\n");
-	bus_for_each_dev(&scsi_bus_type, NULL, s, proc_print_scsidevice);
-	return 0;
+	return 1;
+}
+
+static inline struct device *next_scsi_device(struct device *start)
+{
+	struct device *next = bus_find_device(&scsi_bus_type, start, NULL,
+					      always_match);
+	put_device(start);
+	return next;
+}
+
+static void *scsi_seq_start(struct seq_file *sfile, loff_t *pos)
+{
+	struct device *dev = NULL;
+	loff_t n = *pos;
+
+	while ((dev = next_scsi_device(dev))) {
+		if (!n--)
+			break;
+		sfile->private++;
+	}
+	return dev;
+}
+
+static void *scsi_seq_next(struct seq_file *sfile, void *v, loff_t *pos)
+{
+	(*pos)++;
+	sfile->private++;
+	return next_scsi_device(v);
+}
+
+static void scsi_seq_stop(struct seq_file *sfile, void *v)
+{
+	put_device(v);
+}
+
+static int scsi_seq_show(struct seq_file *sfile, void *dev)
+{
+	if (!sfile->private)
+		seq_puts(sfile, "Attached devices:\n");
+
+	return proc_print_scsidevice(dev, sfile);
 }
 
+static struct seq_operations scsi_seq_ops = {
+	.start	= scsi_seq_start,
+	.next	= scsi_seq_next,
+	.stop	= scsi_seq_stop,
+	.show	= scsi_seq_show
+};
+
 static int proc_scsi_open(struct inode *inode, struct file *file)
 {
 	/*
 	 * We don't really needs this for the write case but it doesn't
 	 * harm either.
 	 */
-	return single_open(file, proc_scsi_show, NULL);
+	return seq_open(file, &scsi_seq_ops);
 }
 
 static struct file_operations proc_scsi_operations = {
@@ -315,7 +361,7 @@ static struct file_operations proc_scsi_
 	.read		= seq_read,
 	.write		= proc_scsi_write,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= seq_release,
 };
 
 int __init scsi_init_procfs(void)


-- 
Jeff Mahoney
SUSE Labs


