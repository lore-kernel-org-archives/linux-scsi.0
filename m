Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000CD3BCD3F
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 19:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779217599; cv=none; b=Byy8qeFfocFXzspHpjaD55IYLW/rlB7+4O9sG+QUG/ONtvRHEzqkmVsXMeZw5EGXkz9WY/LvDA708Z9AqB4KiLXTjNo7vQ9H7JiJ43oHw+GC+zg0N5wriZrQ6LZ+/IutjZnaAKjUUAHBadebeo94yUiY5x1rZpVx5h91TYa5FzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779217599; c=relaxed/simple;
	bh=+R+LjFInjA7vyxj+p9DyJ35DmVdXYIIr2T3gPmEFlxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhxRlgBAfup24oY+KwZ37M4PS57sQiRFCPEzFLl+hUpbzGJyiBRh+rJ6Slf/5UvXWjEvirrm9ahiD1csI5BcRAYOCSNwIGJjOFUzkRILXmMiPecW069P1jupACcGxAlMkdAh3dpWyOV5kbe1MFNz6EvaoyrQR5VQ1/olLB5Gr2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LJa+iHYc; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LJa+iHYc"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-516389a9b70so45052351cf.3
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 12:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779217597; x=1779822397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frUuugDajwbIOykQjzhC84jXkkFKRlA58W38jq3zHQc=;
        b=LJa+iHYcOuO7UmgxhESdF1A3p/p9GLOxYoRWs70GT11DKUigMrojexeIzrt1xlCKu5
         gV/im335br1SxY83lJuHxkB3GG9kwJYm3QWxubm7V6RIfW5PisdFwIF/W1vhp+Ifwtfx
         qcft3npId1yqCxQU+/Poi1BikkS3oANz224LlSlRKm7uFQmtbZmwV0zkpo0hutSSBRtU
         vjSgVtorwKBMpW4vT0zNRkfpL4qIIH28RAOTs7pYE66o3j7neW1ADZOA1iuhwCoXXJb4
         fO5b3tGG1YiiyAFMpxB2L+oEESWw9irNUoHdnaYRb2ZQHzpK3qQ7ybKhXBqORtY5kIzs
         zRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779217597; x=1779822397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=frUuugDajwbIOykQjzhC84jXkkFKRlA58W38jq3zHQc=;
        b=OqbK+jqNe2kuvBA3Es4sGgTrEWQa4UZ2ixEdUGTcYEY4HmJislNQUzb9nnR11AY35+
         Jup4yCVBm9pYkyT4ir//QCixNGPapZh7g5X1mpvqRW6M0YKRERQc7taSansjHBaoGVe/
         0vq5TwD5NberULDXjomWKDiRbKagLzXfbU1qlWpzR4CO7A0+mcvA7pbK/+yKKmXZ7o/V
         BAXI8sL9M3F+JWTD7EQ7SlJLhjJ9GrPrUSTRinozF6AYIBBz0lnrQ+mMumdjWzWRhQft
         etEa8gIsi7vp7hvRqpHfi8rcyqnhSnMq58vQNYOuzdxknhLmfC5MVpeiIO7YXxaYM79P
         ArLw==
X-Forwarded-Encrypted: i=1; AFNElJ8mOqs57VDws2cR3cFxOULdmavyqGJc+Go4INVFn2MOo09IUQH8R3VikoUNB09cMf4XdsTL9zp0vV//@vger.kernel.org
X-Gm-Message-State: AOJu0YzPD3janBsxbwoapIEqNxv3KBMXIVTHbSV/6Ys11PM0ZAQPfIAp
	o7RnQaPNH3P63kqBl5O+DTcnN3g3NKu7FBGopdLcEAqL4q8lGuhobu+I
X-Gm-Gg: Acq92OHEgC7VjWZIzvFfoKjCmQmbd7xkv/zs3s27tGMVRia21n6adwOTCCDoXUFKoLd
	DX9RHqE7H+5gyrD8KbpFMO6PhTC02xCKQAwctmgMKpknkFZ2rSUmTygtQsvpvP5e0dc8i23lVfI
	NZ6GcB9ZYLJi9xLuF+9d0vtV7AiASJhICOOzAQ3Co3WrAF4KM9+lAeIYYZXWlrp1WQBRvaGn1xg
	a5wG5LUZVS+REz97D6XJYxSUgsXrFEgfYo1eT2kV27CA5TcHijkhxRbjfrXGYBxV5FlO3ltKjEK
	GGEEqW3EnD64eJa85zquEzXuGeXeUEZZ1FzIIouofNsVMIHGm3e2kYQ48sunBMfND20outw5eKW
	+FoInzdcI96SEzALW6itqNKhTwR5B+HbpsRNTabJENpEdfCiB6OJumh8YCd0QrVXKq++OrAiIgs
	dszNbMXHziQOe+dLjmRUXKhn4hfZ79lxj6uY0Oed0Z7FUjxCIGHgkQ/qHwT3ghkmgRqtJ0L/z3n
	/gKptkfoBPq0L/DUHGZ
X-Received: by 2002:a05:622a:2445:b0:4f1:ab79:fb18 with SMTP id d75a77b69052e-5165a03e931mr269170821cf.25.1779217596596;
        Tue, 19 May 2026 12:06:36 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5164585fa0asm187088571cf.31.2026.05.19.12.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 12:06:36 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
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
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3] scsi: scsi_transport_fc: widen FPIN pname walker counter to u32
Date: Tue, 19 May 2026 15:06:15 -0400
Message-ID: <20260519190615.2761667-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260518143706.2808177-1-michael.bommarito@gmail.com>
References: <20260518143706.2808177-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

An adjacent Fibre Channel fabric actor that can deliver an FPIN ELS
frame to an lpfc or qla2xxx Linux initiator can trigger a non-return
in the generic FC transport. This is not a local userspace or IP
network path; the attacker must be able to inject fabric traffic, for
example as a compromised switch or fabric controller, or as a same-zone
N_Port on a fabric that permits source spoofing.

The Link-Integrity and Peer-Congestion FPIN walkers used a u8 loop
counter against the 32-bit on-wire pname_count field, and did not bound
pname_count by the descriptor body already validated by the TLV walker.
A pname_count of 256 therefore wraps the counter and keeps the loop
condition true indefinitely.

Factor the shared pname_list[] walk into one helper, widen the counter
to u32, and clamp pname_count against the entries that fit in the
descriptor body before iterating.

Fixes: 3dcfe0de5a97 ("scsi: fc: Parse FPIN packets and update statistics")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
Changes in v3:
- State the fabric-adjacent threat model explicitly in the commit
  message and clarify that this is not local userspace or IP-network
  reachable.
- Use min_t(u32, ...) for the pname_count clamp, as Christoph suggested.
- Use FC_TLV_DESC_LENGTH_FROM_SZ() instead of open-coding the descriptor
  body length calculation.
- Factor the duplicate LI and peer-congestion pname walker into a common
  helper while preserving the LI-only host-stat update.

Changes in v2:
- Drop the redundant cover letter shipped with v1.  A single-patch send
  does not need one, and the v1 cover carried stale draft markers.

 drivers/scsi/scsi_transport_fc.c | 77 +++++++++++++++++---------------
 1 file changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index dce95e361daf0..0684d8c69c3c6 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -737,6 +737,37 @@ fc_cn_stats_update(u16 event_type, struct fc_fpin_stats *stats)
 	}
 }
 
+static void
+fc_fpin_pname_stats_update(struct Scsi_Host *shost,
+			   struct fc_rport *attach_rport, u16 event_type,
+			   u32 desc_len, u32 fixed_len, u32 pname_count,
+			   __be64 *pname_list,
+			   void (*stats_update)(u16 event_type,
+						struct fc_fpin_stats *stats))
+{
+	u32 i, max_count;
+	struct fc_rport *rport;
+	u64 wwpn;
+
+	if (desc_len < fixed_len)
+		max_count = 0;
+	else
+		max_count = (desc_len - fixed_len) / sizeof(pname_list[0]);
+	pname_count = min_t(u32, pname_count, max_count);
+
+	for (i = 0; i < pname_count; i++) {
+		wwpn = be64_to_cpu(pname_list[i]);
+		rport = fc_find_rport_by_wwpn(shost, wwpn);
+		if (rport &&
+		    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
+		     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
+			if (rport == attach_rport)
+				continue;
+			stats_update(event_type, &rport->fpin_stats);
+		}
+	}
+}
+
 /*
  * fc_fpin_li_stats_update - routine to update Link Integrity
  * event statistics.
@@ -747,13 +778,11 @@ fc_cn_stats_update(u16 event_type, struct fc_fpin_stats *stats)
 static void
 fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
 {
-	u8 i;
 	struct fc_rport *rport = NULL;
 	struct fc_rport *attach_rport = NULL;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	struct fc_fn_li_desc *li_desc = (struct fc_fn_li_desc *)tlv;
 	u16 event_type = be16_to_cpu(li_desc->event_type);
-	u64 wwpn;
 
 	rport = fc_find_rport_by_wwpn(shost,
 				      be64_to_cpu(li_desc->attached_wwpn));
@@ -764,22 +793,11 @@ fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
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
-		}
-	}
+	fc_fpin_pname_stats_update(shost, attach_rport, event_type,
+				   be32_to_cpu(li_desc->desc_len),
+				   FC_TLV_DESC_LENGTH_FROM_SZ(*li_desc),
+				   be32_to_cpu(li_desc->pname_count),
+				   li_desc->pname_list, fc_li_stats_update);
 
 	if (fc_host->port_name == be64_to_cpu(li_desc->attached_wwpn))
 		fc_li_stats_update(event_type, &fc_host->fpin_stats);
@@ -827,13 +845,11 @@ static void
 fc_fpin_peer_congn_stats_update(struct Scsi_Host *shost,
 				struct fc_tlv_desc *tlv)
 {
-	u8 i;
 	struct fc_rport *rport = NULL;
 	struct fc_rport *attach_rport = NULL;
 	struct fc_fn_peer_congn_desc *pc_desc =
 	    (struct fc_fn_peer_congn_desc *)tlv;
 	u16 event_type = be16_to_cpu(pc_desc->event_type);
-	u64 wwpn;
 
 	rport = fc_find_rport_by_wwpn(shost,
 				      be64_to_cpu(pc_desc->attached_wwpn));
@@ -844,22 +860,11 @@ fc_fpin_peer_congn_stats_update(struct Scsi_Host *shost,
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
-		}
-	}
+	fc_fpin_pname_stats_update(shost, attach_rport, event_type,
+				   be32_to_cpu(pc_desc->desc_len),
+				   FC_TLV_DESC_LENGTH_FROM_SZ(*pc_desc),
+				   be32_to_cpu(pc_desc->pname_count),
+				   pc_desc->pname_list, fc_cn_stats_update);
 }
 
 /*
-- 
2.53.0
