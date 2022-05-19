Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189B8C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 12:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbiESMbX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 08:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbiESMbT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 08:31:19 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27D817E14
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 05:31:18 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so5114280pjq.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 05:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pJh8WirqYdswsr6jJeoDn4B+Kd+ShXKahHaQuAvRypI=;
        b=I48Er1b4DLjS6Z232dl0eH/pWRliW1u0llXQoKt2YKIrR2mPL1G07U+1yyGULYL03X
         gaQmbu56LElJsBA5SFIWLExbj2pw2U90+ZgSExDcJvYuS1mQ+J9HrOk5Y0kjlCEkCX1b
         NFswGoOd7ZT77M6QjJzHqX3m9Zuy4DjHyvqP0j7mQg2e2uDVBp2RdBa7utolRrPSIadO
         5FB946KjB2MwkazDUfXyqjq7I5mCNxahEeuk5Fs2WqbXnb0wKNOQMDxZb5TS9Qt8cVIX
         s/HzONrlQfOHt1+5HpoN9OWdzHtXAB45n9Fu/GnAh8kaxOWkOfNQnQaxJaxaIrMDrNdS
         4vng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pJh8WirqYdswsr6jJeoDn4B+Kd+ShXKahHaQuAvRypI=;
        b=6BHec57pcfBJqWBDr1prYJ9u4WcVxstSfOiWwI6Wci8Vg5E/60MqAOLcox+6QjYJV6
         97rc69VWfEXMCVGkLuSa0khBBSSOegbhzmcJE+jg6ACvFsyAhar8pmZpJBMccQmoDC1F
         Ene4EX8kNg99kvQ6MEDdxmH9OF2R1LDIv55rdYtNZOuYRoD8DWYPpw2MVNK5NG1ogMRp
         yUY7ba+Ln8zxDFokXezq6yjNjMY50ovSfEcK7Sax2AA2kQbJwD1OfLvVotK4pDNsjXPO
         dlMCO9IXaqpcpVl9dIUa9PDvq+B8HKoAIfS14TjgeqMuMbu8+h6Yt0uwk5/C7RgGLqpF
         wV9A==
X-Gm-Message-State: AOAM532B73dp05lLFLq4NlT9QNBcGIwdWau0X9jtWatPYQOcNaMqh/Gi
        pM6Qo6eaFSJkQOf7kssftRMygBE8Ki8=
X-Google-Smtp-Source: ABdhPJxNi7FvNHdc4YZSS4PGsSI1lYhbd+Y1WfueXs4BVYi6nQbBbUfCs/La6G4+Oa6xF89XzGxuRA==
X-Received: by 2002:a17:903:210:b0:15e:f139:f901 with SMTP id r16-20020a170903021000b0015ef139f901mr4758992plh.66.1652963478179;
        Thu, 19 May 2022 05:31:18 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z26-20020aa79e5a000000b005180f4733a8sm3581797pfq.106.2022.05.19.05.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 05:31:17 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     Muneendra <muneendra.kumar@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 1/4] nvme-fc: Add new routine nvme_fc_io_getuuid
Date:   Thu, 19 May 2022 05:31:07 -0700
Message-Id: <20220519123110.17361-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220519123110.17361-1-jsmart2021@gmail.com>
References: <20220519123110.17361-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Muneendra <muneendra.kumar@broadcom.com>

Add nvme_fc_io_getuuid() to the nvme-fc transport.
The routine is invoked by the fc LLDD on a per-io request basis.
The routine translates from the fc-specific request structure to
the bio and the cgroup structure in order to obtain the fc appid
stored in the cgroup structure. If a value is not set or a bio
is not found, a NULL appid (aka uuid) will be returned to the LLDD.

Signed-off-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Acked-by: Christoph Hellwig <hch@lst.de>

---
v2: modify to sync with Christoph's patch:
 blk-cgroup: move blkcg_{get,set}_fc_appid out of line
 commit db05628435aa
---
 drivers/nvme/host/fc.c         | 18 ++++++++++++++++++
 include/linux/nvme-fc-driver.h | 14 ++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 080f85f4105f..05f9da251758 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1899,6 +1899,24 @@ nvme_fc_ctrl_ioerr_work(struct work_struct *work)
 	nvme_fc_error_recovery(ctrl, "transport detected io error");
 }
 
+/*
+ * nvme_fc_io_getuuid - Routine called to get the appid field
+ * associated with request by the lldd
+ * @req:IO request from nvme fc to driver
+ * Returns: UUID if there is an appid associated with VM or
+ * NULL if the user/libvirt has not set the appid to VM
+ */
+char *nvme_fc_io_getuuid(struct nvmefc_fcp_req *req)
+{
+	struct nvme_fc_fcp_op *op = fcp_req_to_fcp_op(req);
+	struct request *rq = op->rq;
+
+	if (!IS_ENABLED(CONFIG_BLK_CGROUP_FC_APPID) || !rq->bio)
+		return NULL;
+	return blkcg_get_fc_appid(rq->bio);
+}
+EXPORT_SYMBOL_GPL(nvme_fc_io_getuuid);
+
 static void
 nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 {
diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-driver.h
index 5358a5facdee..fa092b9be2fd 100644
--- a/include/linux/nvme-fc-driver.h
+++ b/include/linux/nvme-fc-driver.h
@@ -564,6 +564,15 @@ int nvme_fc_rcv_ls_req(struct nvme_fc_remote_port *remoteport,
 			void *lsreqbuf, u32 lsreqbuf_len);
 
 
+/*
+ * Routine called to get the appid field associated with request by the lldd
+ *
+ * If the return value is NULL : the user/libvirt has not set the appid to VM
+ * If the return value is non-zero: Returns the appid associated with VM
+ *
+ * @req: IO request from nvme fc to driver
+ */
+char *nvme_fc_io_getuuid(struct nvmefc_fcp_req *req);
 
 /*
  * ***************  LLDD FC-NVME Target/Subsystem API ***************
@@ -1048,5 +1057,10 @@ int nvmet_fc_rcv_fcp_req(struct nvmet_fc_target_port *tgtport,
 
 void nvmet_fc_rcv_fcp_abort(struct nvmet_fc_target_port *tgtport,
 			struct nvmefc_tgt_fcp_req *fcpreq);
+/*
+ * add a define, visible to the compiler, that indicates support
+ * for feature. Allows for conditional compilation in LLDDs.
+ */
+#define NVME_FC_FEAT_UUID	0x0001
 
 #endif /* _NVME_FC_DRIVER_H */
-- 
2.26.2

