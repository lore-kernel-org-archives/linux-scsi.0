Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEC236C5AE
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 14:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779113397; cv=none; b=tOKTaXcVmaqQXIRIzdwnXFdhP8dPpBBJ4k3k66iWaWG6hkTYGogwtmfFtRe4tUItJkZHpPmdkU/6k1R7C1X5yRYHUVhrm/6WtnR8DQLNYsl9FeEqHtb+yo2xAak31FAkgw4yTNnwQAJ+CjoPCqfWbtr8a5R5JoyRWAEqINvx4i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779113397; c=relaxed/simple;
	bh=THmElVxW+1xGlC65m3NTKfeXYXU2Nv6oKr1bGetAz/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNJuKagNOPcfNXjoQEiHFjzSSw2/JP1j+qOPwmVlAOzefEQzanaOTsgtdEX2bZ5F14RU8dn/Qj/7TzJlxncGS6V1dGArovYMj8y0FzdZlKQusoWpDhPh2AjPBnz2LA8TdJmIAKFpN11sRW72s4sOXl836QEJD5FW0RGCTAAxbfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AdQF9M+/; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AdQF9M+/"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51306c36c3eso29428691cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 07:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779113394; x=1779718194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JcCkhUrBAXbdWT6IfHUQo8JZZr8OMY5xmgFkJbZZrG4=;
        b=AdQF9M+/Q1Mj7bjSWEAqxN1vjgk8Dx8JL9Y1thVf5fl1q5VtTVenWs3TCwdoCgRtVf
         WQKOSFDzPei2F1kB5FK8G2XyeaeQZj183nEURjRwatEa0LmhG8wEPlYQ+B5PSeuTe/EM
         4ulL2pqjVrnGYX094Z2R5gAkJE8bVDdjwFKzWSclbEI99/WAA/478p59OyvOyYmCvx9T
         wOzcXz/DAGAnG50i8hbFH7ozirUCNSthjzPeGGglR3YlOvaCG5USZldUELoPqjlXk/DR
         tK43/XUXucOgoCxHaqQMD5gc73RnVGP3D6FhC4bTQzjUxpC3TCFzLMXSIzKg/vnTxGJh
         eCQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779113394; x=1779718194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JcCkhUrBAXbdWT6IfHUQo8JZZr8OMY5xmgFkJbZZrG4=;
        b=nkaN2Z48cmq3ScKSYVqM46DviC7QgafwWO47MyYYzMjgD+Y5MbTrTVjwCNSrWJd5y+
         ha3Y6ZUAVtde0BGFA+u4I2dbsUZSwUS/aci+Y7+8/qexCZtUqeBAnGNC/GS2NYee3uHd
         wGg+yD6BZ6Uv98XJmgdpv81EmIsOFXNB6XRuo5cDIxRRoAegKahjgJS6ab8/M3ZKivfS
         EIkRiuUvwlZoogTuLy57tzNF/hOvhYQBosqHEaXAq/cdPYXg9Jbrgu3FCTCT1qOIcWRd
         oBPiANCWnNDAfbEefxwltd8Xb9uAufyb4OrsKKjWeESCYAHoNu02gkMRNlqRdbtp2ofL
         qqgQ==
X-Forwarded-Encrypted: i=1; AFNElJ96d/OBVx4f2HLe0kcq+Oq0W/5gi1pHWextEA5uxhnoIwnAm8zzv2qMDJnbiuyQU6nVCWArHBnPU0ZE@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+dmLbA42IySgphOyuzWvNDTzfeA9lxkIRRWCXWBl5QWruB9iM
	Eas5w7bwLwB82t0EkKu9IKuQnobVHA7dhJD0hyfSnuBOWacrENcUxjfz
X-Gm-Gg: Acq92OEi9jhaTmBDq0FHOdX3OL4QGMkTd+8oo6tM9YVeriJA2xu39QVuniBQhBqckLm
	43v9NY/OuOirqW/TxXB5L7J9XIIFnsGITk6SpFLcHYTW1p4d6gBpv45i8o8o77EbkYaNEUkobsi
	oGTPNNmgHa3hfMqkHjYbfWBVPsN18pr38Ft1EhhVgOvrwxbYx7GCMh0d06GyWysf5qKHKKvbp7q
	rIYX/kHLwwiXmGmav4LGp4q1bZqWf2zFlPV7EYr4zQfgNSkyTDBBX3yM2V5TQk18OibXJHKPyXi
	7gy96Oo3aCTx4kM7+YehCnQaywZt2EvR5KQx83Gv1lp3osoU3Ub02aSHkoI84YBUA2fAxK9Lfs5
	eMnTfGDmKPtQEYnRDhHD4A28vGVYw5ZRRcY4JN/JQDCHluX3f0zizjWLXMLuUL7/klyYWjOJ7NW
	UJ7wqc6o02m7867ZhGXSnV5ZSqiZUAJPDlEk064GnGYYuFH6r10oq+ovRVLI20a0hKafRtM3Kfi
	D4x/Kr8Xwd9/sMgHojZukSzGNqh+sec5TK7nnlBGTY=
X-Received: by 2002:a05:622a:5e13:b0:50b:487c:f3d1 with SMTP id d75a77b69052e-5165a0703b6mr201830211cf.3.1779113392898;
        Mon, 18 May 2026 07:09:52 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456888f6sm139477401cf.3.2026.05.18.07.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 07:09:52 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Shyam Sundar <ssundar@marvell.com>,
	James Smart <james.smart@broadcom.com>,
	Hannes Reinecke <hare@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Kees Cook <kees@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: scsi_transport_fc: widen FPIN pname walker counter to u32
Date: Mon, 18 May 2026 10:09:45 -0400
Message-ID: <20260518140945.2751273-2-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518140945.2751273-1-michael.bommarito@gmail.com>
References: <20260518140945.2751273-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

drivers/scsi/scsi_transport_fc.c::fc_fpin_li_stats_update() and
fc_fpin_peer_congn_stats_update() walked the on-wire
pname_list[] with a u8 loop counter against the 32-bit __be32
pname_count field, and never bounded pname_count by the
descriptor body the TLV walker already validated.

A fabric-side FPIN sender (the elected fabric controller, a
co-tenant N_Port that spoofs S_ID 0xFFFFFD after FLOGI, or a
compromised switch supervisor) could hang the FC ELS receive
thread of an lpfc or qla2xxx initiator indefinitely by
emitting one FPIN ELS frame whose Link-Integrity or
Peer-Congestion descriptor sets pname_count to 256, because
the u8 counter rolls over and the loop condition i <
pname_count stays true for every value i can take.

Widen the loop counter to u32 in both walkers and clamp
pname_count against the per-descriptor available bytes
(desc_len minus the fixed body that precedes pname_list[])
before iterating.  A malformed descriptor that claims more
entries than its TLV body can hold is rejected by the clamp.

Fixes: 3dcfe0de5a97 ("scsi: fc: Parse FPIN packets and update statistics")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 drivers/scsi/scsi_transport_fc.c | 81 ++++++++++++++++++++------------
 1 file changed, 51 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index dce95e361daf0..cef0c85693fd4 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -747,7 +747,7 @@ fc_cn_stats_update(u16 event_type, struct fc_fpin_stats *stats)
 static void
 fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
 {
-	u8 i;
+	u32 i, pname_count, max_count, desc_len;
 	struct fc_rport *rport = NULL;
 	struct fc_rport *attach_rport = NULL;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
@@ -764,20 +764,34 @@ fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
 		fc_li_stats_update(event_type, &attach_rport->fpin_stats);
 	}
 
-	if (be32_to_cpu(li_desc->pname_count) > 0) {
-		for (i = 0;
-		    i < be32_to_cpu(li_desc->pname_count);
-		    i++) {
-			wwpn = be64_to_cpu(li_desc->pname_list[i]);
-			rport = fc_find_rport_by_wwpn(shost, wwpn);
-			if (rport &&
-			    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
-			    rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
-				if (rport == attach_rport)
-					continue;
-				fc_li_stats_update(event_type,
-						   &rport->fpin_stats);
-			}
+	/*
+	 * Clamp pname_count to the number of pname_list entries
+	 * the descriptor body can actually hold.  desc_len
+	 * excludes the desc_tag/desc_len header (FC_TLV_DESC_HDR_SZ),
+	 * so the bytes available for pname_list[] are
+	 * desc_len - sizeof(fixed fields before pname_list[]).
+	 */
+	pname_count = be32_to_cpu(li_desc->pname_count);
+	desc_len = be32_to_cpu(li_desc->desc_len);
+	if (desc_len < sizeof(*li_desc) - FC_TLV_DESC_HDR_SZ)
+		max_count = 0;
+	else
+		max_count = (desc_len -
+			     (sizeof(*li_desc) - FC_TLV_DESC_HDR_SZ)) /
+			    sizeof(li_desc->pname_list[0]);
+	if (pname_count > max_count)
+		pname_count = max_count;
+
+	for (i = 0; i < pname_count; i++) {
+		wwpn = be64_to_cpu(li_desc->pname_list[i]);
+		rport = fc_find_rport_by_wwpn(shost, wwpn);
+		if (rport &&
+		    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
+		    rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
+			if (rport == attach_rport)
+				continue;
+			fc_li_stats_update(event_type,
+					   &rport->fpin_stats);
 		}
 	}
 
@@ -827,7 +841,7 @@ static void
 fc_fpin_peer_congn_stats_update(struct Scsi_Host *shost,
 				struct fc_tlv_desc *tlv)
 {
-	u8 i;
+	u32 i, pname_count, max_count, desc_len;
 	struct fc_rport *rport = NULL;
 	struct fc_rport *attach_rport = NULL;
 	struct fc_fn_peer_congn_desc *pc_desc =
@@ -844,20 +858,27 @@ fc_fpin_peer_congn_stats_update(struct Scsi_Host *shost,
 		fc_cn_stats_update(event_type, &attach_rport->fpin_stats);
 	}
 
-	if (be32_to_cpu(pc_desc->pname_count) > 0) {
-		for (i = 0;
-		    i < be32_to_cpu(pc_desc->pname_count);
-		    i++) {
-			wwpn = be64_to_cpu(pc_desc->pname_list[i]);
-			rport = fc_find_rport_by_wwpn(shost, wwpn);
-			if (rport &&
-			    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
-			     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
-				if (rport == attach_rport)
-					continue;
-				fc_cn_stats_update(event_type,
-						   &rport->fpin_stats);
-			}
+	pname_count = be32_to_cpu(pc_desc->pname_count);
+	desc_len = be32_to_cpu(pc_desc->desc_len);
+	if (desc_len < sizeof(*pc_desc) - FC_TLV_DESC_HDR_SZ)
+		max_count = 0;
+	else
+		max_count = (desc_len -
+			     (sizeof(*pc_desc) - FC_TLV_DESC_HDR_SZ)) /
+			    sizeof(pc_desc->pname_list[0]);
+	if (pname_count > max_count)
+		pname_count = max_count;
+
+	for (i = 0; i < pname_count; i++) {
+		wwpn = be64_to_cpu(pc_desc->pname_list[i]);
+		rport = fc_find_rport_by_wwpn(shost, wwpn);
+		if (rport &&
+		    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
+		     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
+			if (rport == attach_rport)
+				continue;
+			fc_cn_stats_update(event_type,
+					   &rport->fpin_stats);
 		}
 	}
 }
-- 
2.53.0

