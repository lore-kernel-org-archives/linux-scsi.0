From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] libiscsi: avoid unnecessary multiple NULL assignments
Date: Wed, 10 Apr 2013 11:24:38 -0500
Message-ID: <1365611079-15011-2-git-send-email-michaelc@cs.wisc.edu>
References: <1365611079-15011-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37377 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936114Ab3DJQYy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Apr 2013 12:24:54 -0400
In-Reply-To: <1365611079-15011-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Masatake YAMATO <yamato@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Masatake YAMATO <yamato@redhat.com>

In iscsi_free_task, NULL is assigned to task->sc twice: before and
after kfifo_in invocatoin. Allocating and freeing iscsi_task are guarded
with session->lock, so multiple NULL assignments cause no trouble. But
people reading the source code may be confused.

The second NULL assignment comes from commit:

    3e5c28ad0391389959ccae81c938c7533efb3490

It seems that the line after kfifo_in invocation was introduced
accidentally.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d5e5c44..5de9469 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -507,7 +507,6 @@ static void iscsi_free_task(struct iscsi_task *task)
 	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
 	if (sc) {
-		task->sc = NULL;
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
 		/*
-- 
1.7.1

