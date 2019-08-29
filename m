Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C92C3A5A4
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 02:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4796C22CED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 02:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfH2C1e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 22:27:34 -0400
Received: from smtp.infotech.no ([82.134.31.41]:40147 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727348AbfH2C1d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Aug 2019 22:27:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id DBB492041F1;
        Thu, 29 Aug 2019 04:27:32 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CD5rXEZASmee; Thu, 29 Aug 2019 04:27:31 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 508E3204248;
        Thu, 29 Aug 2019 04:27:30 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@infradead.org
Subject: [PATCH v4 18/22] sg: add some __must_hold macros
Date:   Wed, 28 Aug 2019 22:26:55 -0400
Message-Id: <20190829022659.23130-19-dgilbert@interlog.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190829022659.23130-1-dgilbert@interlog.com>
References: <20190829022659.23130-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the case of sg_wait_open_event() which calls mutex_unlock on
sdp->open_rel_lock and later calls mutex_lock on the same
lock; this macro is needed to stop sparse complaining. In
other cases it is a reminder to the coder (a precondition).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 904f3ac8add7..187e85b215d5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -379,6 +379,7 @@ sg_check_file_access(struct file *filp, const char *caller)
 
 static int
 sg_wait_open_event(struct sg_device *sdp, bool o_excl)
+		__must_hold(&sdp->open_rel_lock)
 {
 	int res = 0;
 
@@ -1506,6 +1507,7 @@ sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
 static void
 sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
 			struct sg_req_info *rip)
+		__must_hold(&sfp->rq_list_lock)
 {
 	spin_lock(&srp->req_lck);
 	rip->duration = sg_get_dur(srp, NULL, NULL);
@@ -1627,6 +1629,7 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
  */
 static int
 sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
+		__must_hold(&sfp->f_mutex)
 {
 	bool use_new_srp = false;
 	int res = 0;
@@ -3547,6 +3550,7 @@ sg_remove_sfp(struct kref *kref)
 
 static int
 sg_idr_max_id(int id, void *p, void *data)
+		__must_hold(&sg_index_lock)
 {
 	int *k = data;
 
@@ -3855,6 +3859,7 @@ sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 /* Writes debug info for one sg_request in obp buffer */
 static int
 sg_proc_debug_sreq(struct sg_request *srp, int to, char *obp, int len)
+		__must_hold(&sfp->rq_list_lock)
 {
 	bool is_v3v4, v4, is_dur;
 	int n = 0;
@@ -3890,6 +3895,7 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, char *obp, int len)
 /* Writes debug info for one sg fd (including its sg requests) in obp buffer */
 static int
 sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len)
+		__must_hold(&sfp->rq_list_lock)
 {
 	bool first_fl;
 	int n = 0;
@@ -3939,6 +3945,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len)
 /* Writes debug info for one sg device (including its sg fds) in obp buffer */
 static int
 sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len, int *fd_counterp)
+		__must_hold(&sdp->sfd_lock)
 {
 	int n = 0;
 	int my_count = 0;
-- 
2.23.0

