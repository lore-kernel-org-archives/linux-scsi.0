From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH][RESUBMIT] dm-mpath: Two minor fixes while processing
 activate_path
Date: Fri, 15 Jan 2010 13:26:07 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF487870633@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:56711 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758241Ab0AOU0O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2010 15:26:14 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Alasdair G Kergon <agk@redhat.com>

This patch adds two minor fixes while processing device mapper path activation.

1. Skip failed paths while calling activate_path.
   If the path is already failed then activate_path will fail for sure. We 
   don't have to call in that case. In some case this might cause prolonged retries unnecessarily.

2. changed the mis-leading message if the activate path fails with SCSI_DH_NOSYS.

Signed-off-by: Babu Moger <babu.moger@lsi.com>

---
--- linux-2.6.33-rc2/drivers/md/dm-mpath.c.orig	2010-01-15 15:04:37.000000000 -0400
+++ linux-2.6.33-rc2/drivers/md/dm-mpath.c	2010-01-15 15:11:48.000000000 -0400
@@ -461,6 +461,9 @@ static void process_queued_ios(struct wo
 		m->pg_init_count++;
 		m->pg_init_required = 0;
 		list_for_each_entry(tmp, &pgpath->pg->pgpaths, list) {
+			/* Skip failed paths */
+			if (!tmp->is_active)
+				continue;
 			if (queue_work(kmpath_handlerd, &tmp->activate_path))
 				m->pg_init_in_progress++;
 		}
@@ -1143,8 +1146,8 @@ static void pg_init_done(void *data, int
 			errors = 0;
 			break;
 		}
-		DMERR("Cannot failover device because scsi_dh_%s was not "
-		      "loaded.", m->hw_handler_name);
+		DMERR("Could not failover the device, Handler scsi_dh_%s "
+			"Error %d.", m->hw_handler_name, errors);
 		/*
 		 * Fail path for now, so we do not ping pong
 		 */


