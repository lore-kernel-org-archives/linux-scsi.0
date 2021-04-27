Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B473DC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B373613B0
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbhD0WAp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:45 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39154 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239510AbhD0WAZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 93E262042AC;
        Tue, 27 Apr 2021 23:59:39 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bOaQrI+pQdhQ; Tue, 27 Apr 2021 23:59:38 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 12E582042A4;
        Tue, 27 Apr 2021 23:59:33 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 77/83] sg: add SGV4_FLAG_REC_ORDER
Date:   Tue, 27 Apr 2021 17:57:27 -0400
Message-Id: <20210427215733.417746-79-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By default, when ioctl(SG_IORECEIVE) is used in multiple requests
mode (mrq) the response array is built in completion order. And the
completion order isn't necessarily submission order which can be a
nuisance. This new flag allows the user to specify where (via an
index in the v4::request_priority field) a given request's response
will be placed in the response array associated with a mrq
ioctl(SG_IORECEIVE) call.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 43 +++++++++++++++++++++++++++---------------
 include/uapi/scsi/sg.h |  1 +
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index a76ab2c59553..37a3361dec31 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1552,8 +1552,11 @@ sg_mrq_sanity(struct sg_mrq_hold *mhp, bool is_svb)
 			hp->response = cop->response;
 			hp->max_response_len = cop->max_response_len;
 		}
-		if (!is_svb)
+		if (!is_svb) {
+			if (cop->flags & SGV4_FLAG_REC_ORDER)
+				hp->flags |= SGV4_FLAG_REC_ORDER;
 			continue;
+		}
 		/* mrq share variable blocking (svb) additional constraints checked here */
 		if (unlikely(flags & (SGV4_FLAG_COMPLETE_B4 | SGV4_FLAG_KEEP_SHARE))) {
 			SG_LOG(1, sfp, "%s: %s %u: no KEEP_SHARE with svb\n", __func__, rip, k);
@@ -2775,7 +2778,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		srp->s_hdr4.cmd_len = h4p->request_len;
 		srp->s_hdr4.dir = dir;
 		srp->s_hdr4.out_resid = 0;
-		srp->s_hdr4.mrq_ind = 0;
+		srp->s_hdr4.mrq_ind = (rq_flags & SGV4_FLAG_REC_ORDER) ? h4p->request_priority : 0;
 		if (dir == SG_DXFER_TO_DEV) {
 			srp->s_hdr4.wr_offset = cwrp->wr_offset;
 			srp->s_hdr4.wr_len = dlen;
@@ -3053,7 +3056,7 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p, struct
 static int
 sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs, struct sg_io_v4 *rsp_arr)
 {
-	int k;
+	int k, idx;
 	int res = 0;
 	struct sg_request *srp;
 
@@ -3062,8 +3065,15 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs, struct sg
 		if (!sg_mrq_get_ready_srp(sfp, &srp))
 			break;
 		if (IS_ERR(srp))
-			return k ? k : PTR_ERR(srp);
-		res = sg_receive_v4(sfp, srp, NULL, rsp_arr + k);
+			return k ? k /* some but not all */ : PTR_ERR(srp);
+		if (srp->rq_flags & SGV4_FLAG_REC_ORDER) {
+			idx = srp->s_hdr4.mrq_ind;
+			if (idx >= max_mrqs)
+				idx = 0;	/* overwrite index 0 when trouble */
+		} else {
+			idx = k;	/* completion order */
+		}
+		res = sg_receive_v4(sfp, srp, NULL, rsp_arr + idx);
 		if (unlikely(res))
 			return res;
 		rsp_arr[k].info |= SG_INFO_MRQ_FINI;
@@ -3077,7 +3087,14 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs, struct sg
 			return res;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
 			return k ? k : PTR_ERR(srp);
-		res = sg_receive_v4(sfp, srp, NULL, rsp_arr + k);
+		if (srp->rq_flags & SGV4_FLAG_REC_ORDER) {
+			idx = srp->s_hdr4.mrq_ind;
+			if (idx >= max_mrqs)
+				idx = 0;
+		} else {
+			idx = k;
+		}
+		res = sg_receive_v4(sfp, srp, NULL, rsp_arr + idx);
 		if (unlikely(res))
 			return res;
 		rsp_arr[k].info |= SG_INFO_MRQ_FINI;
@@ -7619,7 +7636,8 @@ sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 
 /* Writes debug info for one sg_request in obp buffer */
 static int
-sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, bool inactive, char *obp, int len)
+sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, bool inactive, char *obp,
+		   int len)
 {
 	bool is_v3v4, v4, is_dur;
 	int n = 0;
@@ -7659,13 +7677,8 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, bool inactive,
 		n += scnprintf(obp + n, len - n, " sgat=%d", srp->sgatp->num_sgat);
 	cp = (srp->rq_flags & SGV4_FLAG_HIPRI) ? "hipri " : "";
 	n += scnprintf(obp + n, len - n, " %sop=0x%02x\n", cp, srp->cmd_opcode);
-	if (inactive && rq_st != SG_RQ_INACTIVE) {
-		if (xa_get_mark(&srp->parentfp->srp_arr, srp->rq_idx, SG_XA_RQ_INACTIVE))
-			cp = "still marked inactive, BAD";
-		else
-			cp = "no longer marked inactive";
-		n += scnprintf(obp + n, len - n, "       <<< xarray %s >>>\n", cp);
-	}
+	if (inactive && rq_st != SG_RQ_INACTIVE)
+		n += scnprintf(obp + n, len - n, "       <<< inconsistent state >>>\n");
 	return n;
 }
 
@@ -7749,7 +7762,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx, bool r
 			n += scnprintf(obp + n, len - n, "     rq_bm=0x%lx", srp->frq_bm[0]);
 		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns, true, obp + n, len - n);
 		++k;
-		if ((k % 8) == 0) {	/* don't hold up isr_s too long */
+		if ((k % 8) == 0) {	/* don't hold up things too long */
 			xa_unlock_irqrestore(&fp->srp_arr, iflags);
 			cpu_relax();
 			xa_lock_irqsave(&fp->srp_arr, iflags);
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 236ac4678f71..871073d1a8d3 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -128,6 +128,7 @@ typedef struct sg_io_hdr {
 #define SGV4_FLAG_KEEP_SHARE 0x20000  /* ... buffer for another dout command */
 #define SGV4_FLAG_MULTIPLE_REQS 0x40000	/* 1 or more sg_io_v4-s in data-in */
 #define SGV4_FLAG_ORDERED_WR 0x80000	/* svb: issue in-order writes */
+#define SGV4_FLAG_REC_ORDER 0x100000 /* receive order in v4:request_priority */
 
 /* Output (potentially OR-ed together) in v3::info or v4::info field */
 #define SG_INFO_OK_MASK 0x1
-- 
2.25.1

