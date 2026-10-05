Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68964CB8DD;
	Mon,  5 Oct 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791215840; cv=none; b=O0isrrvBSRJ7Adez2RZcpSWNHG2H5YpI+0mzIASieJQ1JFIUHBXlyShsiLftqY9WL2j2IhSHUVW27DYjfsayu09p4//DZyzU855ukbDnh7mu+UhePeA6thnImzXGWy+TMQ8pegphiWW4p0riGLHNSo9TbbcUvdAtIsp4vEOM870=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791215840; c=relaxed/simple;
	bh=4x/rggUe3FoPbP2vQGa0IfGARqg+sTYPhCQM+9x9034=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMy/oAC2NHGcce0oGRrG2Q4YJ6IIQ7kUM4Pb+w3YtmBzMJZ2M1LJhfPWUI9oxfmmKQBVqC8vR3OitwNo//+PnJ6uxRd2woCBjt2+L9lPkizNpg2Mwz7xK3FO+xVArDYvhID4zqeF0HVW3xKk5ZBqeMQFBHM0cro5LFplHQQb5wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zzrp2T7e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zzrp2T7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF0F1F00893;
	Mon,  5 Oct 2026 15:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791215838;
	bh=lDEwT/kJtxLnQzyVwnYdvIREEI0cxdELQ5TKUhzaHBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zzrp2T7elK6M4JBUF+PyMYalrQK25TTX9CMUWpC5s6VXvnWHp3ocfydNIKCsf+CvZ
	 ebyHz8cbLSQ17XiO63nAK2sPWkV4HyArobsQ4SIAfNK0jrMCANtJxsbT8C2hqMCG9G
	 AOFbBr04dTJnqBMk/FE2psHmOwVtEaouthoFD0bfwRhdHvryUb1wewiNHj1uaYvP/2
	 UBizqRRAn6u3+PxoTJVagVGx8UIkOcWHFCOxhhxolKVqPyDxvBasdhcn1b0ZTZzbcj
	 vB+4/Jue0JZuWjjtbOIauMtOhmBS8Ra5K+8JHNIne4YOhJEMLUUV1MGcipxoy9VTW8
	 v2h8svXN4Y3Hg==
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>,
	Ian Bridges <icb@fastmail.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 03/12] scsi: lpfc: Print rx monitor records straight into the seq_buf
Date: Mon,  5 Oct 2026 08:56:53 -0700
Message-ID: <20261005155708.1471260-3-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005155653.late.426-kees@kernel.org>
References: <20261005155653.late.426-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3097; i=kees@kernel.org; h=from:subject; bh=4x/rggUe3FoPbP2vQGa0IfGARqg+sTYPhCQM+9x9034=; b=owGbwMvMwCVmps19z/KJym7G02pJDFmHT5w+3PUqXONk7tl1q6Q2JTyKigq/we905U7vQTueH DF2tdq6jlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgInUqjIynGqP3Mam4Xa1KOCE 2ObVW3NumwmGpcg41EhPWyy4Z2eKDMM/u4TqmNcSWkfu3bL78eYKA4PXEQe7VBU3UYaXE5r5UnL 5AA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

lpfc_rx_monitor_report() formats each record into a stack buffer, then
appends it with seq_buf_puts(), relying on seq_buf_puts() appending
nothing when a string does not fit: the debugfs output then ends at the
last whole record, and the record left out is read in full next time.
The next patch makes seq_buf_puts() copy as much as fits instead, as
seq_buf_printf() and strlcat() do.

Print each record with seq_buf_printf(), and when it does not fit, end
the string where the record began, since the reader takes the buffer up
to its NUL. This also takes the DBG_LOG_STR_SZ buffer off the stack.

Build tested ARCH=x86_64 with GCC 16.2.0, CONFIG_SCSI_LPFC=m and W=1.

Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 45 +++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cfa4371169f1..a7b1ea67ed98 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8108,7 +8108,6 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
 	spinlock_t *ring_lock = &rx_monitor->lock;
 	u32 ring_size = rx_monitor->entries;
 	u32 cnt = 0;
-	char tmp[DBG_LOG_STR_SZ] = {0};
 	bool log_to_kmsg = (!buf || !buf_len) ? true : false;
 	struct seq_buf s;
 
@@ -8133,27 +8132,37 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
 
 		/* Read out this entry's data. */
 		if (!log_to_kmsg) {
+			unsigned int len;
+
+			/* A header that did not fit leaves no room. */
+			if (seq_buf_has_overflowed(&s))
+				break;
+			len = seq_buf_used(&s);
+
+			seq_buf_printf(&s,
+				       "%03d:\t%-16llu%-16llu%-16llu%-16llu%-8llu%-8llu%-8llu%-8u%-8u%-8u%u(%u)\n",
+				       *head_idx,
+				       entry->max_bytes_per_interval,
+				       entry->cmf_bytes,
+				       entry->total_bytes,
+				       entry->rcv_bytes,
+				       entry->avg_io_latency,
+				       entry->avg_io_size,
+				       entry->max_read_cnt,
+				       entry->cmf_busy, entry->io_cnt,
+				       entry->cmf_info,
+				       entry->timer_utilization,
+				       entry->timer_interval);
+
 			/*
 			 * Drop a record whole if it does not fit, without
-			 * consuming its ring entry.
+			 * consuming its ring entry: the reader takes the
+			 * string up to its NUL.
 			 */
-			scnprintf(tmp, sizeof(tmp),
-				  "%03d:\t%-16llu%-16llu%-16llu%-16llu%-8llu%-8llu%-8llu%-8u%-8u%-8u%u(%u)\n",
-				  *head_idx,
-				  entry->max_bytes_per_interval,
-				  entry->cmf_bytes,
-				  entry->total_bytes,
-				  entry->rcv_bytes,
-				  entry->avg_io_latency,
-				  entry->avg_io_size,
-				  entry->max_read_cnt,
-				  entry->cmf_busy, entry->io_cnt,
-				  entry->cmf_info,
-				  entry->timer_utilization,
-				  entry->timer_interval);
-
-			if (seq_buf_puts(&s, tmp) < 0)
+			if (seq_buf_has_overflowed(&s)) {
+				buf[len] = '\0';
 				break;
+			}
 		} else {
 			lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
 					"4410 %02u: MBPI %llu Xmit %llu "
-- 
2.55.0

