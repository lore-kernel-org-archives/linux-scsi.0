From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi proc_info called unconditionally
Date: Sat, 16 Aug 2003 11:06:16 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030816110616.A26667@infradead.org>
References: <20030816084409.GA8038@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030816084409.GA8038@suse.de>; from olh@suse.de on Sat, Aug 16, 2003 at 10:44:09AM +0200
To: Olaf Hering <olh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 16, 2003 at 10:44:09AM +0200, Olaf Hering wrote:
> 
> Why is ->proc_info() called when the function pointer is NULL?

Looks like the check for it's presence got lost in

	[PATCH] Correct removal of procfs host enteries [1/2]

Here's a trivial patch to get it back:


--- 1.32/drivers/scsi/scsi_proc.c	Thu Jul 31 10:31:51 2003
+++ edited/drivers/scsi/scsi_proc.c	Sat Aug 16 10:31:37 2003
@@ -81,6 +81,9 @@
 
 void scsi_proc_hostdir_add(struct scsi_host_template *sht)
 {
+	if (!sht->proc_info)
+		return;
+
 	down(&global_host_template_sem);
 	if (!sht->present++) {
 		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
@@ -96,6 +99,9 @@
 
 void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
 {
+	if (!sht->proc_info)
+		return;
+
 	down(&global_host_template_sem);
 	if (!--sht->present && sht->proc_dir) {
 		remove_proc_entry(sht->proc_name, proc_scsi);
