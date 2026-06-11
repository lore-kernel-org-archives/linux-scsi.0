Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D813F6C32
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781181139; cv=none; b=tA0yrUsmOHi9NZj7V+KOJHAk4ReRNIqEhXmOtgTfPPfPfll1c5A9amsrv6OhWCaebUr5m/rYHJfFtO7Iq8vxNQ4X/dSoe0hjYzIOL+2onRdIjmHX8mM649OUAxCEdamwYmBOcC6tpsAaKQJT+ruPn+O8WfV86CeMC4/68yfOiyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781181139; c=relaxed/simple;
	bh=BSx2REIDdYh6rBcLzILSd3dV8BAOIWvSwTx3IBfTmHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4dF0u8kumkwznXh+qFcnXi0hxnKA1y/A/S5GvwEGjs5ZDYZI0lAT3tOA7V2bLqxF7ZuqsyVL/EB7oUET9yo0YYA8B1hU/tESx0MW8NmhE1/xjhwJEeaL8BD48LsqnqRIR0RMDzKqpTfp+iCUJ+cWhI76fDM5XO/oq5KEkcd1Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fusS4jyO; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fusS4jyO"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9155183b42cso134025885a.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 05:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781181137; x=1781785937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mLymrEZazNmQKknDX1QeqtCgPzdIbUvDepEeTIb67zo=;
        b=fusS4jyOa5zHNNzrdMeHlzjDsolfIbVNkICGkyClIIWsCwESgBqYtsHIEEU3x6HhGO
         0JPnrpiybvQ4cWf4I4/S9UO3IcosKCI3tCMZbOWEsZay2gGu4ra3Fy4Li/ImZIHagM6x
         FUlMWvSW/pjSYWc0cD9h0O7i8l9V6Woydhq4bG6BP6hXkifYqt5kNhmUpHI5uR+aoaT6
         oyregi29XXuDRDQG+KJEmyfIWqzYYK1bQrfeDJUemX3S53sqGS7T5j2MsBpYIxlfTpy4
         ndHOD4LMCD1+YoH45+iawFoZlNkbcay+eo70O/X0LGtmPDTT3pCIweHfVi5Ioe4WCsjM
         xaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781181137; x=1781785937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mLymrEZazNmQKknDX1QeqtCgPzdIbUvDepEeTIb67zo=;
        b=fydETszJnEReNjM3oXsETpVGLtwXU06QQVqdV2/QUbUzBx6GQ8YC3/CNtaVG95j5CA
         JGCewb5oLoNsKa+w/bP8eQ6MbOYUtjLBv99e2vSqN4l4OOPh7ovmExL3NjkWHWoJ89B3
         njZuCw630bqh7UMY+pLXRS+x9ZtwP9IMNu2p5IJ966YCWLpr2MDxjg661DUK3qFNIviD
         x3lYhaQTxYbhjU4DtaXt3TXIas1VPo3CvTiGdJRmuQ1RqvtJUZlhuHzlorGfpf8N1Mo0
         VE51ht8XcGe3dIF3lHyocDWeKd5gd1rVCTznH+wo/t2E8K2JkBSjVb/Tg2IMK4rKLuPj
         2VEQ==
X-Forwarded-Encrypted: i=1; AFNElJ+LeuT4GQyFITDJlpqsLs67FXBiAF1UOtLXrxjOEvJTgH0j75u+m9FyTHwmCkvbOBaJ3cn6QNrQ7fco@vger.kernel.org
X-Gm-Message-State: AOJu0YzOLDoUZOxZjTdR+njB/nS8ReEo7Zb1N74r3u7JjrUlGXXPb7KE
	vwCp4A+2jgx3GPW/SePftUR2R6R84Mo/Jwr234xH8/OIrxKWvDQ8tIE+
X-Gm-Gg: Acq92OE4KKV0nQOmbShwmADVvVLg6WiFOEMX6utLrUvbrkhJ9F4kaT1qqcdtV5WSzay
	RHAGhQGTWMcb/Icc2Pd4itopbS6Q8eRUSEuwPUlLLU0vobuJXfTMTv1l1LyZ4msv2ZLC7+upufK
	u+8mPrPx1739m+8u+Oop6ho5CiHfg3x1VXLfvGBr/ndfwNKAeL1VmWARkBfrkTuQ0Xe+IDq0bLv
	pES4rF9NQZhoT6AvMKE6aWdpMztfbjzQgSWRLMt0MJmhBIbxRF+vYXGG+Ubhbn4OEWwlGDOu+Pe
	88xEvROojbwNLkNVfGCeDy+6GEI4fv307jvhESuIjUfs245vXDQ8Aqn8yiiZJiSo+PO0YUWldBS
	om6AHSM9pUJ5ouPvkqjTxQoziBJKrteOTTVBE4R6KCgXVf6RMO42AD7lTba8usMVvdzcT6mGEgY
	SMIkXvqwQgvxaMrRjxicpnFeGBi2rXO7ViDl2nP+PO6rp9IaIAcTeyNnoUeK1C1+EcAM8cS1Uz/
	+jdQSjrVB6D7zSoG4N0GxZ8dj4zUUQ=
X-Received: by 2002:a05:620a:440c:b0:910:c1ba:91d3 with SMTP id af79cd13be357-9160a841f7fmr283346285a.45.1781181136610;
        Thu, 11 Jun 2026 05:32:16 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9160b02f758sm171220685a.36.2026.06.11.05.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 05:32:15 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] xen/scsiback: free unsubmitted command instead of double-putting it
Date: Thu, 11 Jun 2026 08:30:45 -0400
Message-ID: <20260611123046.2323342-2-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611123046.2323342-1-michael.bommarito@gmail.com>
References: <20260611123046.2323342-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

scsiback_get_pend_req() obtains a command tag and returns a
vscsibk_pend whose embedded se_cmd has only been memset to 0, so
its cmd_kref is 0; the se_cmd is initialised (kref_init() via
target_init_cmd()) only later, in scsiback_cmd_exec(), on the
successful VSCSIIF_ACT_SCSI_CDB path. The two error paths in
scsiback_do_cmd_fn() taken before the command is submitted -- a
failed scsiback_gnttab_data_map() and an unknown ring_req.act --
call transport_generic_free_cmd(&pending_req->se_cmd, 0), which
kref_put()s a refcount of 0. That underflows it ("refcount_t:
underflow; use-after-free") and, as the release function is not
run, leaks the command tag.

Impact: a pvSCSI guest can leak every command tag of a LUN's
session, stopping the LUN, by submitting requests with a bad
grant reference or an unknown request type; under panic_on_warn
the refcount underflow panics the host.

Add a helper that just returns the tag with target_free_tag() and
sends the error response. It frees the tag while the v2p reference
still pins the session, and snapshots the response fields
beforehand because freeing the tag can let another ring reuse the
pending_req slot.

Fixes: 2dbcdf33dbf6 ("xen-scsiback: Convert to percpu_ida tag allocation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
Reproduced on a Xen dom0 (Linux 6.1.y) exporting a pvSCSI LUN to a guest.
A frontend that sends a single ring request with an unknown action type
drives scsiback_do_cmd_fn() into transport_generic_free_cmd() on the
never-initialised command and logs

  refcount_t: underflow; use-after-free
  WARNING: ... refcount_warn_saturate
   transport_generic_free_cmd+0x... [target_core_mod]
   scsiback_do_cmd_fn+0x... [xen_scsiback]
   scsiback_irq_fn+0x... [xen_scsiback]

from the vscsiif IRQ thread, and panics the dom0 under panic_on_warn.  The
failed grant-map path reaches the same free.  With this patch the same
request is answered with DID_ERROR and the tag is returned, with no
underflow.  These error paths are unchanged since 2dbcdf33dbf6, so mainline
is affected identically.

 drivers/xen/xen-scsiback.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index e33f95c91b096..f324732eba7f8 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -611,6 +611,25 @@ static void scsiback_disconnect(struct vscsibk_info *info)
 	xenbus_unmap_ring_vfree(info->dev, info->ring.sring);
 }
 
+/*
+ * Send the error response for a request that did not reach the target core
+ * and return its tag.  Free the tag before the response drops the v2p
+ * reference that keeps the session alive, and snapshot what the response
+ * needs since returning the tag can let the slot be reused.
+ */
+static void scsiback_resp_and_free(struct vscsibk_pend *pending_req,
+				   int32_t result)
+{
+	struct vscsibk_info *info = pending_req->info;
+	struct v2p_entry *v2p = pending_req->v2p;
+	struct se_session *se_sess = v2p->tpg->tpg_nexus->tvn_se_sess;
+	u16 rqid = pending_req->rqid;
+
+	target_free_tag(se_sess, &pending_req->se_cmd);
+	scsiback_send_response(info, NULL, result, 0, rqid);
+	kref_put(&v2p->kref, scsiback_free_translation_entry);
+}
+
 static void scsiback_device_action(struct vscsibk_pend *pending_req,
 	enum tcm_tmreq_table act, int tag)
 {
@@ -792,9 +811,8 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info,
 		case VSCSIIF_ACT_SCSI_CDB:
 			if (scsiback_gnttab_data_map(&ring_req, pending_req)) {
 				scsiback_fast_flush_area(pending_req);
-				scsiback_do_resp_with_sense(NULL,
-						DID_ERROR << 16, 0, pending_req);
-				transport_generic_free_cmd(&pending_req->se_cmd, 0);
+				scsiback_resp_and_free(pending_req,
+						       DID_ERROR << 16);
 			} else {
 				scsiback_cmd_exec(pending_req);
 			}
@@ -808,9 +826,7 @@ static int scsiback_do_cmd_fn(struct vscsibk_info *info,
 			break;
 		default:
 			pr_err_ratelimited("invalid request\n");
-			scsiback_do_resp_with_sense(NULL, DID_ERROR << 16, 0,
-						    pending_req);
-			transport_generic_free_cmd(&pending_req->se_cmd, 0);
+			scsiback_resp_and_free(pending_req, DID_ERROR << 16);
 			break;
 		}
 
-- 
2.53.0

