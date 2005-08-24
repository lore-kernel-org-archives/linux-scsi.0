From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2xxx: does not respond to SCSI_IOCTL_PROBE_HOST
Date: Wed, 24 Aug 2005 14:13:48 -0700
Message-ID: <20050824211348.GH8205@plap.qlogic.org>
References: <1124915655.13251.16.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:33619 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932239AbVHXVNy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 17:13:54 -0400
Content-Disposition: inline
In-Reply-To: <1124915655.13251.16.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Drew Winstel <raw@dslr.net>
Cc: linux-scsi@vger.kernel.org

On Wed, 24 Aug 2005, Drew Winstel wrote:

> Here's the situation.  I am running a QLogic QLA2200 (32-bit mode; lspci
> output follows), and when I issue an ioctl() to call
> SCSI_IOCTL_PROBE_HOST to /dev/sg0 (example code follows as well), the
> ioctl() returns 0, as if to imply that there is no host present, which
> is obviously not possible since the drive is attached to the HBA.  Using
> an Adaptec 29160 adapter with a drive connected produces logical,
> reasonable output, so I'm turning to the experts here.  Is this by
> design, a bug, or just something I've horribly missed?  I have tried it
> with a 2.6.11 and 2.6.12.5 kernel to no avail.

/proc support has been stripped from the qla2xxx driver.  So,
hostt->present is never incremented:

	void scsi_proc_hostdir_add(struct scsi_host_template *sht)
	{
		if (!sht->proc_info)
			return;

		down(&global_host_template_sem);
		if (!sht->present++) {
			...

SCSI_IOCTL_PROBE_HOST returns hostt->present:

	static int ioctl_probe(struct Scsi_Host *host, void __user *buffer)
	{
		unsigned int len, slen;
		const char *string;
		int temp = host->hostt->present;

		...
		return temp;

Not sure how we want to fix it, perhaps for backwards compatibility,
increment present regardless of the value of proc_info.

Something like this, perhaps (untested)?

---

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -80,32 +80,44 @@ out:
 
 void scsi_proc_hostdir_add(struct scsi_host_template *sht)
 {
+	int create;
+
+	down(&global_host_template_sem);
+	create = !sht->present++;
+	up(&global_host_template_sem);
+
 	if (!sht->proc_info)
 		return;
 
-	down(&global_host_template_sem);
-	if (!sht->present++) {
+	if (create) {
+		down(&global_host_template_sem);
 		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
         	if (!sht->proc_dir)
 			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
 			       __FUNCTION__, sht->proc_name);
 		else
 			sht->proc_dir->owner = sht->module;
+		up(&global_host_template_sem);
 	}
-	up(&global_host_template_sem);
 }
 
 void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
 {
+	int destroy;
+
+	down(&global_host_template_sem);
+	destroy = !--sht->present;
+	up(&global_host_template_sem);
+
 	if (!sht->proc_info)
 		return;
 
-	down(&global_host_template_sem);
-	if (!--sht->present && sht->proc_dir) {
+	if (destroy && sht->proc_dir) {
+		down(&global_host_template_sem);
 		remove_proc_entry(sht->proc_name, proc_scsi);
 		sht->proc_dir = NULL;
+		up(&global_host_template_sem);
 	}
-	up(&global_host_template_sem);
 }
 
 void scsi_proc_host_add(struct Scsi_Host *shost)
