Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B13BC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5561D2083E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="o7b8dPCw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgGBCqI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:46:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39367 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgGBCqH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 22:46:07 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200702024604epoutp0125e8c84738895ac1123da4f5e9de8fd0~dz3mZ_4W92941029410epoutp01H
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:46:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200702024604epoutp0125e8c84738895ac1123da4f5e9de8fd0~dz3mZ_4W92941029410epoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593657964;
        bh=ktfYmqyeYkaB4RbQ/mzXvx+UvUm8DhxHeF+x52POj48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=o7b8dPCw+8JMpdFEp90wkf5CS2sNn9IC6EAW1HKgMw9Mrj+qrj0fZEQs4qzvMmwW9
         VVuqZ5PCn1Jqp1qD1+NS9C83S8S/Izuw8QNaTvwJATwt7d6pG/OK9dihs7A6B0wBfk
         aWMT5m6KT23w6MqhWsHPXgIdM+uW6ewE3OqR8Kjw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200702024603epcas2p1ae05c0c54f688ee0ab164057bb4fb2b2~dz3l9KCrR1441614416epcas2p1m;
        Thu,  2 Jul 2020 02:46:03 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.190]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 49y2XT64mBzMqYkY; Thu,  2 Jul
        2020 02:46:01 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        48.9F.19322.76A4DFE5; Thu,  2 Jul 2020 11:45:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200702024558epcas2p38e61e50755728e18dadc9d9f08dabfbd~dz3hFhO3G0472304723epcas2p35;
        Thu,  2 Jul 2020 02:45:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200702024558epsmtrp2e9460d218801a2a1c775f01247ed88d8~dz3hEuxKc2800328003epsmtrp26;
        Thu,  2 Jul 2020 02:45:58 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-0d-5efd4a67e3e7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        10.E0.08382.66A4DFE5; Thu,  2 Jul 2020 11:45:58 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200702024558epsmtip234bb952b7043370d6e508c5e8b8cb118~dz3g6p-G40375103751epsmtip2r;
        Thu,  2 Jul 2020 02:45:58 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v2 1/2] ufs: introduce a callback to get info of command
 completion
Date:   Thu,  2 Jul 2020 11:38:09 +0900
Message-Id: <cc9a0edf340931397c04303213ea0d54023708de.1593657314.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1593657314.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1593657314.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdljTQjfd62+cwYQv3BYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFotubGOyuLnlKItF9/UdbBbLj/9jcuDyuHzF2+NyXy+T
        x4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpRSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
        XGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhgYGQKVJmQk3HkwUuWgimCFa2/pzE1MPbxdTFy
        ckgImEhM2viNsYuRi0NIYAejRGP3c3YI5xOjxOrZE6Gcb4wS7V/WsMC0HN/WBJXYyyixctt3
        NgjnB6PE3nk/warYBDQlnt6cygSSEBG4wSgxp/kwK0iCWUBdYteEE0wgtrBApMSVyZ3sIDaL
        gKpEX28j0CQODl6BaInWZqhtchI3z3Uyg9icApYS6++0MqKyuYBqfrJLrN90lxWiwUWidesl
        qGZhiVfHt7BD2FISn9/tZYOw6yX2TW1ghWjuYZR4uu8fI0TCWGLWs3ZGkCOYgT5Yv0sfxJQQ
        UJY4cosF4nw+iY7Df9khwrwSHW1CEI3KEr8mTYYaIikx8+YdqK0eEo83QWwSAtl0cvI0lgmM
        8rMQFixgZFzFKJZaUJybnlpsVGCIHH2bGMEpUst1B+Pktx/0DjEycTAeYpTgYFYS4T1t8CtO
        iDclsbIqtSg/vqg0J7X4EKMpMBwnMkuJJucDk3ReSbyhqZGZmYGlqYWpmZGFkjhvruKFOCGB
        9MSS1OzU1ILUIpg+Jg5OqQamFGcP2dN3ddZeOay+yuGlRPmiCoZWXpeubjm9+kkGGyJmPV72
        ZPvOsqX7vuftyrtiEJM11Vdx9qflZalGaW8WcmzIO1ky89Hbmnu/g60u6/3PY/q1UfmIW+Op
        wrKbvY/eRG0ri7lZXJf7VLByRojGs4ceZtdOsyof27/Q4W6DNbtGrm4vx7xd8vwTHr64Ii5t
        do7zI4PSW4NJifeVW3hvGx/4FdGdJVK+zMrqVObON+tFZ8ibTfF0kgi6dnhfqfLi8E05gdmf
        DrKEzLOI67ogdjll00RG3YLDfhHtp46uCClYWXglIiNlmvGi+y8dVIKunC4XaNvdpnH/p0n9
        7PTKLL2m1k3Ln7ywlu7Z5CanxFKckWioxVxUnAgA8kNAlhoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSvG6a1984g1n3FC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLRbd2MZkcXPLURaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARxWWTkpqTWZZapG+XwJVx5MFLloIp
        ghWtv6cxNTD28XUxcnJICJhIHN/WxN7FyMUhJLCbUWLRvE8sEAlJiRM7nzNC2MIS91uOsILY
        QgLfGCXWr0oBsdkENCWe3pzKBNIsIvCIUeL3zE52kASzgLrErgknmEBsYYFwiS0Lz4MNYhFQ
        lejrbWTrYuTg4BWIlmhthtolJ3HzXCcziM0pYCmx/k4rI8QuC4kdTZfYcIlPYBRYwMiwilEy
        taA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOLy1NHcwbl/1Qe8QIxMH4yFGCQ5mJRHe0wa/
        4oR4UxIrq1KL8uOLSnNSiw8xSnOwKInz3ihcGCckkJ5YkpqdmlqQWgSTZeLglGpg2m3irbpq
        8f3jfAXBWsGrdIWVdh8+bq4TlOfEMl3EkeOP70ftCp7wZ0pHpbdNsiiLj1z9SX3z0oxFdVfV
        mZiO3bvX1Fo9vXJ+eKRk3efdho/iLL9k7Yhpctt/MEY5+dM5rgnCr1Q4Zz7R36LXU2Op9/5C
        zEH3vOpUlW6+4yz1GQK1vgWv2/wbZr+13HK2Uezu0zOPGxpMfv10XhYo4m2tJilm3b/n3/7V
        LIExCzJPMan4XVe6yNUiJ1F5qvxf1c7HTNtZyvr09ZINPPSFI05efyPD91pq0VajJvnLn8+H
        TgqQ19CaYcDJ6j0n+/TaoNtLYldZ6ph0lCVeW26ae7tU/f084SXqmUdXT6mz0lZiKc5INNRi
        LipOBADJl7JJ3gIAAA==
X-CMS-MailID: 20200702024558epcas2p38e61e50755728e18dadc9d9f08dabfbd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200702024558epcas2p38e61e50755728e18dadc9d9f08dabfbd
References: <cover.1593657314.git.kwmad.kim@samsung.com>
        <CGME20200702024558epcas2p38e61e50755728e18dadc9d9f08dabfbd@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some SoC specific might need command history for
various reasons, such as stacking command contexts
in system memory to check for debugging in the future
or scaling some DVFS knobs to boost IO throughput.

What you would do with the information could be
variant per SoC vendor.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52abe82..3326236 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4882,6 +4882,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
 		lrbp = &hba->lrb[index];
 		cmd = lrbp->cmd;
+		ufshcd_vops_compl_xfer_req(hba, index, (cmd) ? true : false);
 		if (cmd) {
 			ufshcd_add_command_trace(hba, index, "complete");
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
@@ -4890,6 +4891,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			/* Mark completed command as NULL in LRB */
 			lrbp->cmd = NULL;
 			lrbp->compl_time_stamp = ktime_get();
+
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c774012..6cf46bd 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -307,6 +307,7 @@ struct ufs_hba_variant_ops {
 	void	(*config_scaling_param)(struct ufs_hba *hba,
 					struct devfreq_dev_profile *profile,
 					void *data);
+	void	(*compl_xfer_req)(struct ufs_hba *hba, int tag, bool is_scsi);
 };
 
 /* clock gating state  */
@@ -1137,6 +1138,13 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, profile, data);
 }
 
+static inline void ufshcd_vops_compl_xfer_req(struct ufs_hba *hba,
+					      int tag, bool is_scsi);
+{
+	if (hba->vops && hba->vops->compl_xfer_req)
+		hba->vops->compl_xfer_req(hba, tag, is_scsi);
+}
+
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /*
-- 
2.7.4

