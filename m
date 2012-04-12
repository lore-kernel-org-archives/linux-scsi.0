From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [RFC] How to fix an async scan - rmmod race? try_module_get
Date: Thu, 12 Apr 2012 14:48:52 +0200
Message-ID: <4F86CF34.2000906@redhat.com>
References: <4F7DA4F8.90104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933732Ab2DLMs4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Apr 2012 08:48:56 -0400
In-Reply-To: <4F7DA4F8.90104@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>

Hi,

the first patch waited in scsi_remove_host was until the scan thread ends, some flags were set
so the thread could be aborted prematurely. 

This patch uses a try_module_get to lock the module and prevents a rmmod while it's locked.
The disadvantage is that in the protection we use again the same host template (shost->hostt->module;),
and when this were not valid I think and oops in try_module_get will follow. It seems to me
that the LLDs use scsi_scan_host only in the initial attach function so this is safe now, but ..

This, and the fact that the initial patch can ends the scan thread in the middle (I hope this is safe?),
makes me prefer the original patch.

A potential fix for a scan invoked from a different location, eg. a user via syfs is maybe also needed, but
can be handled separately. 

Tomas

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 29c4c04..6cf8df3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1839,9 +1839,13 @@ static int do_scan_async(void *_data)
 {
 	struct async_scan_data *data = _data;
 	struct Scsi_Host *shost = data->shost;
+	struct module *mod = shost->hostt->module;
 
 	do_scsi_scan_host(shost);
 	scsi_finish_async_scan(data);
+
+	module_put(mod);
+
 	return 0;
 }
 
@@ -1853,16 +1857,22 @@ void scsi_scan_host(struct Scsi_Host *shost)
 {
 	struct task_struct *p;
 	struct async_scan_data *data;
+	struct module *mod;
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return;
 	if (scsi_autopm_get_host(shost) < 0)
 		return;
 
+	mod = shost->hostt->module;
+	if (!try_module_get(mod)) /* module_put is called from do_scan_async */
+		return;
+
 	data = scsi_prep_async_scan(shost);
 	if (!data) {
 		do_scsi_scan_host(shost);
 		scsi_autopm_put_host(shost);
+		module_put(mod);
 		return;
 	}
 


