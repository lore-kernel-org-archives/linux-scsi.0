Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E8DC433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 16:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E22DD61AF9
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 16:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhJCQkB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Oct 2021 12:40:01 -0400
Received: from smtp.infotech.no ([82.134.31.41]:55321 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231342AbhJCQjo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 3 Oct 2021 12:39:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2DD81204238;
        Sun,  3 Oct 2021 18:37:55 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uYEd1xrUwIZG; Sun,  3 Oct 2021 18:37:53 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-91-187-47.dyn.295.ca [23.91.187.47])
        by smtp.infotech.no (Postfix) with ESMTPA id 6E6D820414B;
        Sun,  3 Oct 2021 18:37:26 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
Subject: [PATCH v21 32/46] sg: add some __must_hold macros
Date:   Sun,  3 Oct 2021 12:31:37 -0400
Message-Id: <20211003163151.585349-33-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211003163151.585349-1-dgilbert@interlog.com>
References: <20211003163151.585349-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the case of sg_wait_open_event() which calls mutex_unlock on
sdp->open_rel_lock and later calls mutex_lock on the same
lock; this macro is needed to stop sparse complaining. In
other cases it is a reminder to the coder (a precondition).

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7e088d9cda4e..a7eebc1d5407 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -375,6 +375,7 @@ sg_check_file_access(struct file *filp, const char *caller)
 
 static int
 sg_wait_open_event(struct sg_device *sdp, bool o_excl)
+		__must_hold(sdp->open_rel_lock)
 {
 	int res = 0;
 
@@ -1728,6 +1729,7 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
  */
 static int
 sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
+		__must_hold(sfp->f_mutex)
 {
 	int new_sz, blen, res;
 	unsigned long iflags;
@@ -3579,12 +3581,12 @@ sg_remove_sfp(struct kref *kref)
 
 static int
 sg_idr_max_id(int id, void *p, void *data)
+		__must_hold(sg_index_lock)
 {
 	int *k = data;
 
 	if (*k < id)
 		*k = id;
-
 	return 0;
 }
 
@@ -3887,6 +3889,7 @@ sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 /* Writes debug info for one sg_request in obp buffer */
 static int
 sg_proc_debug_sreq(struct sg_request *srp, int to, char *obp, int len)
+		__must_hold(sfp->srp_arr.xa_lock)
 {
 	bool is_v3v4, v4, is_dur;
 	int n = 0;
@@ -3989,6 +3992,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
 /* Writes debug info for one sg device (including its sg fds) in obp buffer */
 static int
 sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len, int *fd_counterp)
+		__must_hold(sg_index_lock)
 {
 	int n = 0;
 	int my_count = 0;
-- 
2.25.1

