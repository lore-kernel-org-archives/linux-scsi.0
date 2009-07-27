From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] dm mpath: Skip calling activate_path if the path is already
 failed
Date: Mon, 27 Jul 2009 11:35:30 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF46F252765@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:45510 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZG0SeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2009 14:34:05 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'dm-devel@redhat.com'" <'dm-devel@redhat.com'>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch adds a check to skip failed paths while calling activate_path. It is not required to call activate_path for failed paths. 

Signed-off-by: Babu Moger <babu.moger@lsi.com>
---


--- linux-2.6.31-rc3/drivers/md/dm-mpath.c.orig	2009-07-27 10:30:39.000000000 -0500
+++ linux-2.6.31-rc3/drivers/md/dm-mpath.c	2009-07-27 10:35:50.000000000 -0500
@@ -454,6 +454,10 @@ static void process_queued_ios(struct wo
 		m->pg_init_count++;
 		m->pg_init_required = 0;
 		list_for_each_entry(tmp, &pgpath->pg->pgpaths, list) {
+			/* Skip failed paths */
+			if (!tmp->is_active)
+				continue;
+			
 			if (queue_work(kmpath_handlerd, &tmp->activate_path))
 				m->pg_init_in_progress++;
 		}





