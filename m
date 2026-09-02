Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A8E4A9D4B
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 20:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788379589; cv=none; b=I/R4yEklCxROnbZuJQYQAvT3tqD2NdH57x9sXj39pKiqoaOp1qg0tDPIv1uW6zKamtiJpLgoM0XOV13Hs7mRYjDaLxPht4tvjz/GO8zxmXsrIk9NhsqrevcM66tbGux7NUNYFw9m3WnwtOzcYb5enVyD/mxhS3ai6sVzag0QLOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788379589; c=relaxed/simple;
	bh=PUdwSTyoKchnGNvcKZneP8Bj182M6z3uu7Ne1W7EWu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8sUaY7dlgdFlmOKKXItT8flCTlY/45yRwEx9THCCd+GDYm/putJifLXSf04fgMY8/r5aGnmNGWKVwPaiDAxqB6DPQXvTgbUPH2r78VaQAFbuN0eoMDaBL/+s30UHiP5ayPdgKGgNkPXudJcCa1NrK1htk42NJG2mNS8FB4xHbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WCOKFc+O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WCOKFc+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788379587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qj6Ej6aw6ESKMozrrmkT6gNikVjoJG57NJAgL2FNY6M=;
	b=WCOKFc+OOFBg8ZCGTQRn2hdODzY5e9d+JzC2swX2QKkeAddA8mVuPK8LykDkixbWyRF3lp
	RNC88hmrTjNLqCUy9l5fISQqJR+8dvHnEWNWJv+CdYBuRqg7XfXb8J1RkfIODax9KAKdWQ
	QmaLeODbOdfV9GYBhPs45PuJfw/mpvw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-lfSnGyAPO7iHpTz7KpplyA-1; Wed,
 02 Sep 2026 16:06:22 -0400
X-MC-Unique: lfSnGyAPO7iHpTz7KpplyA-1
X-Mimecast-MFC-AGG-ID: lfSnGyAPO7iHpTz7KpplyA_1788379579
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 69AD1195421A;
	Wed,  2 Sep 2026 20:06:19 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.17.16.153])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 08C161955F02;
	Wed,  2 Sep 2026 20:06:15 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Hannes Reinecke <hare@suse.de>,
	Jesse Taube <jtaubepe@redhat.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Chris Leech <cleech@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>,
	shinichiro.kawasaki@wdc.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH v2 7/7] nvme: fcloop: Add set_marginal_rport to sysfs
Date: Wed,  2 Sep 2026 16:05:47 -0400
Message-ID: <20260902200547.184734-8-jtaubepe@redhat.com>
In-Reply-To: <20260902200547.184734-1-jtaubepe@redhat.com>
References: <20260902200547.184734-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

To allow testing of multipath failover, add a sysfs attribute to set a
remote port as marginal. This will allow the fcloop LLDD to set the
marginal flag on a remote port, simulating a marginal link.

Example:
Turn on marginal for a remote port matching wwnn and wwpn:
`echo 'wwnn=0x200000109b5f2956,wwpn=0x100000109b5f2956,marginal=1' >
/sys/class/fcloop/ctl/set_marginal_rport`

Turn off marginal for a remote port matching wwnn and wwpn:
`echo 'wwnn=0x200000109b5f2956,wwpn=0x100000109b5f2956,marginal=0' >
/sys/class/fcloop/ctl/set_marginal_rport`

Suggested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
V10 -> V1:
 - New patch
V1 -> V2:
 - Fix reference count leak in error path
---
 drivers/nvme/target/fcloop.c | 50 ++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index b63af3b643a6..9977c2a71bd5 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/parser.h>
 #include <uapi/scsi/fc/fc_fs.h>
+#include <uapi/scsi/fc/fc_els.h>
 
 #include "../host/nvme.h"
 #include "../target/nvmet.h"
@@ -21,6 +22,7 @@ enum {
 	NVMF_OPT_FCADDR		= 1 << 3,
 	NVMF_OPT_LPWWNN		= 1 << 4,
 	NVMF_OPT_LPWWPN		= 1 << 5,
+	NVMF_OPT_MARGINAL	= 1 << 6,
 };
 
 struct fcloop_ctrl_options {
@@ -31,6 +33,7 @@ struct fcloop_ctrl_options {
 	u32			fcaddr;
 	u64			lpwwnn;
 	u64			lpwwpn;
+	u32			marginal;
 };
 
 static const match_table_t opt_tokens = {
@@ -40,6 +43,7 @@ static const match_table_t opt_tokens = {
 	{ NVMF_OPT_FCADDR,	"fcaddr=%x"	},
 	{ NVMF_OPT_LPWWNN,	"lpwwnn=%s"	},
 	{ NVMF_OPT_LPWWPN,	"lpwwpn=%s"	},
+	{ NVMF_OPT_MARGINAL,	"marginal=%d"	},
 	{ NVMF_OPT_ERR,		NULL		}
 };
 
@@ -120,6 +124,13 @@ fcloop_parse_options(struct fcloop_ctrl_options *opts,
 			}
 			opts->lpwwpn = token64;
 			break;
+		case NVMF_OPT_MARGINAL:
+			if (match_int(args, &token)) {
+				ret = -EINVAL;
+				goto out_free_options;
+			}
+			opts->marginal = token;
+			break;
 		default:
 			pr_warn("unknown parameter or missing value '%s'\n", p);
 			ret = -EINVAL;
@@ -199,6 +210,9 @@ fcloop_parse_nm_options(struct device *dev, u64 *nname, u64 *pname,
 
 #define TGTPORT_OPTS	(NVMF_OPT_WWNN | NVMF_OPT_WWPN)
 
+#define MARGINAL_OPTS	(NVMF_OPT_WWNN | NVMF_OPT_WWPN | \
+			 NVMF_OPT_MARGINAL)
+
 
 static DEFINE_SPINLOCK(fcloop_lock);
 static LIST_HEAD(fcloop_lports);
@@ -1663,6 +1677,40 @@ fcloop_set_cmd_drop(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+static ssize_t
+fcloop_set_marginal_rport(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct fcloop_nport *nport;
+	struct fcloop_ctrl_options opts = {};
+	unsigned long flags;
+	int ret;
+
+	ret = fcloop_parse_options(&opts, buf);
+	if (ret)
+		return ret;
+
+	/* everything there ? */
+	if ((opts.mask & MARGINAL_OPTS) != MARGINAL_OPTS)
+		return -EINVAL;
+
+	nport = fcloop_nport_lookup(opts.wwnn, opts.wwpn);
+	if (!nport)
+		return -ENOENT;
+
+	spin_lock_irqsave(&fcloop_lock, flags);
+	if (!nport->rport || !nport->rport->remoteport) {
+		spin_unlock_irqrestore(&fcloop_lock, flags);
+		fcloop_nport_put(nport);
+		return -ENOENT;
+	}
+
+	nvme_fc_set_remoteport_fpin(nport->rport->remoteport, opts.marginal);
+	spin_unlock_irqrestore(&fcloop_lock, flags);
+	fcloop_nport_put(nport);
+
+	return count;
+}
 
 static DEVICE_ATTR(add_local_port, 0200, NULL, fcloop_create_local_port);
 static DEVICE_ATTR(del_local_port, 0200, NULL, fcloop_delete_local_port);
@@ -1671,6 +1719,7 @@ static DEVICE_ATTR(del_remote_port, 0200, NULL, fcloop_delete_remote_port);
 static DEVICE_ATTR(add_target_port, 0200, NULL, fcloop_create_target_port);
 static DEVICE_ATTR(del_target_port, 0200, NULL, fcloop_delete_target_port);
 static DEVICE_ATTR(set_cmd_drop, 0200, NULL, fcloop_set_cmd_drop);
+static DEVICE_ATTR(set_marginal_rport, 0200, NULL, fcloop_set_marginal_rport);
 
 static struct attribute *fcloop_dev_attrs[] = {
 	&dev_attr_add_local_port.attr,
@@ -1680,6 +1729,7 @@ static struct attribute *fcloop_dev_attrs[] = {
 	&dev_attr_add_target_port.attr,
 	&dev_attr_del_target_port.attr,
 	&dev_attr_set_cmd_drop.attr,
+	&dev_attr_set_marginal_rport.attr,
 	NULL
 };
 
-- 
2.55.0

