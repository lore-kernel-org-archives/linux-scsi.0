From: Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [PATCH] sg.c: fix a memory leak in devices seq_file implementation
 (2nd)
Date: Tue, 23 Aug 2005 22:25:14 +0200
Message-ID: <430B862A.4000009@tu-harburg.de>
References: <4305D040.1050301@tu-harburg.de> <200508232057.50334.ioe-lkml@rameria.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050507080302090903010609"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932372AbVHWUZ3@vger.kernel.org>
In-Reply-To: <200508232057.50334.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Linux-Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050507080302090903010609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ingo Oeser schrieb:
> 
> kfree() checks its argument, so instead of
> 
> if (pointer)
> 	kfree(pointer);
> 
> just do
> 
> kfree(pointer);
> 

This is an updated patch. Removed the unnecessary if.

Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>


--------------050507080302090903010609
Content-Type: text/x-patch;
 name="scsi_sg.c-dev_seq_file-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_sg.c-dev_seq_file-fix.diff"

 drivers/scsi/sg.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/scsi/sg.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sg.c
+++ linux-2.6/drivers/scsi/sg.c
@@ -2971,23 +2971,22 @@ static void * dev_seq_start(struct seq_f
 {
 	struct sg_proc_deviter * it = kmalloc(sizeof(*it), GFP_KERNEL);
 
+	s->private = it;
 	if (! it)
 		return NULL;
+
 	if (NULL == sg_dev_arr)
-		goto err1;
+		return NULL;
 	it->index = *pos;
 	it->max = sg_last_dev();
 	if (it->index >= it->max)
-		goto err1;
+		return NULL;
 	return it;
-err1:
-	kfree(it);
-	return NULL;
 }
 
 static void * dev_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
+	struct sg_proc_deviter * it = s->private;
 
 	*pos = ++it->index;
 	return (it->index < it->max) ? it : NULL;
@@ -2995,7 +2994,9 @@ static void * dev_seq_next(struct seq_fi
 
 static void dev_seq_stop(struct seq_file *s, void *v)
 {
-	kfree (v);
+	struct sg_proc_deviter * it = s->private;
+
+	kfree (it);
 }
 
 static int sg_proc_open_dev(struct inode *inode, struct file *file)

--------------050507080302090903010609--
