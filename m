Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9446125228C;
	Wed, 15 Apr 2026 04:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776226050; cv=none; b=FFktRwN67LsWfXGklkK4tMXGEGUtFsDHZvDDj4u24ebu/IVT7kQ/wNG2cj44No8mjGVNR+goRfxtcd+WbrADAQ4L1jI4dQmZRtHCpwkgnAfrrKnJYfHPDltPREdKxYY9J6E9jS+hu8/uR/OvOHwRp8qLnPGCB6M7+QMa7vKMJM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776226050; c=relaxed/simple;
	bh=I4U/X4anEmx3t+b5a+LnHSrvGNqMgQjmdI7ZhAp2BlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OljKLQLxVVodsFVwafARmECSXVYgs2OGI/pjHcKUDNCWeCByN5kvb2l3jxB5kcHVZXHXbQAw5/cN6ZGaVJMXPcZgmgr5VCU83EGa54BCBjQ10laaqivgcetROpg++llJwHJktfePyRuHzyVdKKoI70pqKv/M72fcyv6VqWexLWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0Y23FOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0Y23FOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E33C19424;
	Wed, 15 Apr 2026 04:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776226050;
	bh=I4U/X4anEmx3t+b5a+LnHSrvGNqMgQjmdI7ZhAp2BlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0Y23FOjVd8T4aAqg89FmLjNMrZyV0RthL4Aa+uTP0OizulJaaP6J+ikMyAMPoxCz
	 kKrnuCM8N/1+JcpJl+1XM0FG9Dw3SVdwgSVJT0tZmVJLNd+3nW/41WobhgkS6/GrHt
	 nNeV1X1AONrGj3K5U3sffT4dZBhuTTLRa79tYE6SXLV6IuuJuebM51yC+GLXkLA6cp
	 gF41mAKWxs4zVBJaL+SDrJSW2GGj8rLJKd813JZSSWGgIEhHUmqfm57HIP7zYmgd19
	 TNmYvHjM6kxngUZtSudrTyqVKftJL5twlB9YmdC2qe/1aQuPJ+yGkWfs+rrsdRtRN3
	 VwGX9RGOX31mw==
From: "Carlos Bilbao (Lambda)" <carlos.bilbao@kernel.org>
To: martin.petersen@oracle.com,
	kees@kernel.org,
	d.bogdanov@yadro.com
Cc: pabeni@redhat.com,
	mlombard@redhat.com,
	kuniyu@google.com,
	michael.christie@oracle.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bilbao@vt.edu,
	Carlos Bilbao <carlos.bilbao@kernel.org>
Subject: [PATCH v3] scsi: target: iscsi: reject invalid size Extended CDB AHS
Date: Tue, 14 Apr 2026 21:07:28 -0700
Message-ID: <20260415040728.187680-1-carlos.bilbao@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <yq1cy02tgum.fsf@ca-mkp.ca.oracle.com>
References: <yq1cy02tgum.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Bilbao <carlos.bilbao@kernel.org>

If ecdb_ahdr->ahslength is zero, two bugs follow:

  kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15, ...)

allocates 15 bytes, but the immediately following memcpy writes
ISCSI_CDB_SIZE (16) bytes into it, a one-byte heap overflow. Also:

  memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
           be16_to_cpu(ecdb_ahdr->ahslength) - 1);

(u16)0 - 1 promotes to (int)-1 which converts to SIZE_MAX as size_t,
causing a massive out-of-bounds write.

Reject ahslength == 0 with ISCSI_REASON_PROTOCOL_ERROR before the kmalloc.
Also reject ahslength values that exceed the actual AHS buffer advertised.

Fixes: 8f1f7d297bce ("scsi: target: iscsi: Add support for extended CDB AHS")
Signed-off-by: Carlos Bilbao (Lambda) <carlos.bilbao@kernel.org>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>

Changes in v3:
- Move ahslength and cdb_length declarations to function scope following
  the reverse christmas tree ordering of existing locals.

Changes in v2:
- Add bounds check: ahslength must not exceed (hdr->hlength * 4) - 3.
- Replace opaque ahslength + 15 with explicit cdb_length variable.
---
 drivers/target/iscsi/iscsi_target.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index e80449f6ce15..cb832fd523af 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -995,6 +995,7 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	int data_direction, payload_length;
 	struct iscsi_ecdb_ahdr *ecdb_ahdr;
 	struct iscsi_scsi_req *hdr;
+	u16 ahslength, cdb_length;
 	int iscsi_task_attr;
 	unsigned char *cdb;
 	int sam_task_attr;
@@ -1108,14 +1109,27 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 				ISCSI_REASON_CMD_NOT_SUPPORTED, buf);
 		}
 
-		cdb = kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15,
-			      GFP_KERNEL);
+		ahslength = be16_to_cpu(ecdb_ahdr->ahslength);
+		if (!ahslength) {
+			pr_err("Extended CDB AHS with zero length, protocol error.\n");
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_PROTOCOL_ERROR, buf);
+		}
+		if (ahslength > (hdr->hlength * 4) - 3) {
+			pr_err("Extended CDB AHS length %u exceeds available PDU buffer.\n",
+			       ahslength);
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_PROTOCOL_ERROR, buf);
+		}
+
+		cdb_length = ahslength - 1 + ISCSI_CDB_SIZE;
+
+		cdb = kmalloc(cdb_length, GFP_KERNEL);
 		if (cdb == NULL)
 			return iscsit_add_reject_cmd(cmd,
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
 		memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);
-		memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
-		       be16_to_cpu(ecdb_ahdr->ahslength) - 1);
+		memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb, cdb_length - ISCSI_CDB_SIZE);
 	}
 
 	data_direction = (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVICE :
-- 
2.43.0

