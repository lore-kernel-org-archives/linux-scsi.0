From: Dave Jones <davej@redhat.com>
Subject: Re: fix qla2xxx inline failure.
Date: Wed, 15 Sep 2004 07:43:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915114311.GB17683@redhat.com>
References: <20040915113254.GA17683@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36314 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265230AbUIOLnR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 07:43:17 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.10) with ESMTP id i8FBhHmn017282
	for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2004 07:43:17 -0400
Received: from devserv.devel.redhat.com (devserv.devel.redhat.com [172.16.58.1])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id i8FBhHr18185
	for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2004 07:43:17 -0400
Received: from devserv.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by devserv.devel.redhat.com (8.12.11/8.12.10) with ESMTP id i8FBhBXS029707
	for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2004 07:43:11 -0400
Received: (from davej@localhost)
	by devserv.devel.redhat.com (8.12.11/8.12.11/Submit) id i8FBhBiV029705
	for linux-scsi@vger.kernel.org; Wed, 15 Sep 2004 07:43:11 -0400
Content-Disposition: inline
In-Reply-To: <20040915113254.GA17683@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There was a second failure..
drivers/scsi/qla2xxx/qla_rscn.c: In function `qla2x00_cancel_io_descriptors':
drivers/scsi/qla2xxx/qla_rscn.c:320: sorry, unimplemented: inlining failed in call to 'qla2x00_remove_iodesc_timer': function not considered for inlining
drivers/scsi/qla2xxx/qla_rscn.c:257: sorry, unimplemented: called from here
make[3]: *** [drivers/scsi/qla2xxx/qla_rscn.o] Error 1


Signed-off-by: Dave Jones <davej@redhat.com>

--- 1/drivers/scsi/qla2xxx/qla_rscn.c	2004-09-15 12:02:12.000000000 +0100
+++ 2/drivers/scsi/qla2xxx/qla_rscn.c	2004-09-15 12:41:48.504957664 +0100
@@ -242,6 +242,20 @@ qla2x00_free_iodesc(struct io_descriptor
 }
 
 /**
+ * qla2x00_remove_iodesc_timer() - Remove an active timer from an IO descriptor.
+ * @iodesc: io descriptor
+ */
+static inline void
+qla2x00_remove_iodesc_timer(struct io_descriptor *iodesc)
+{
+	if (iodesc->timer.function != NULL) {
+		del_timer_sync(&iodesc->timer);
+		iodesc->timer.data = (unsigned long) NULL;
+		iodesc->timer.function = NULL;
+	}
+}
+
+/**
  * qla2x00_init_io_descriptors() - Initialize the pool of IO descriptors.
  * @ha: HA context
  */
@@ -311,20 +325,6 @@ qla2x00_add_iodesc_timer(struct io_descr
 	add_timer(&iodesc->timer);
 }
 
-/**
- * qla2x00_remove_iodesc_timer() - Remove an active timer from an IO descriptor.
- * @iodesc: io descriptor
- */
-static inline void
-qla2x00_remove_iodesc_timer(struct io_descriptor *iodesc)
-{
-	if (iodesc->timer.function != NULL) {
-		del_timer_sync(&iodesc->timer);
-		iodesc->timer.data = (unsigned long) NULL;
-		iodesc->timer.function = NULL;
-	}
-}
-
 /** 
  * IO descriptor support routines.
  **/
