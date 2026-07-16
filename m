Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D12222590
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 06:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784185150; cv=none; b=MnburQexCMa44/tdSDLHl0sBzcRXQEdwRB8vvwhjKLWaOZFYHgyDz6U6U0tO54hul+/HsbQVgHhPm8cNaHqw2ZG1QC5ld9EUghd6W/wPW+gENpCDQ8xR+jc8CCBbSaMej8gj2wbr57wqdIAvAHubkLTCtYgn2lw7+OiQnKqt2FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784185150; c=relaxed/simple;
	bh=1vybAkZ2wMgVaOzHa2qygLuGlC3TJoH/uFlRzZYKiTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJtqVmp+awxWVjrUonGfTvb4oNMbZrvsiDHgKG3smEm+qw6QTrOy2TZiXrXA7vgQdAZ3ZOcgePDPSxYl/CdQ8HHLQs5JHUDJgNqcg3PiNTvhN/TIR09kJxq2f4OAoA2gRzdwygo00D4VvcWYR4TRhhT8qGK6I/1E8o04FuNr29s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KYioNWKY; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KYioNWKY"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-845b6d9bf39so273843b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 23:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784185149; x=1784789949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Av94P2V8NtTmuihxtjhBFmg2tcbDiYUZN4BJgJSyKHU=;
        b=KYioNWKYv5WQRWOeqJxObBFZSPr19OW2STAXI8cGlE6GudKW5Au7NH7aTvGHlgTuDM
         D+h7Xj85mpVVpXn3aNCtpCJswmtw3CiNZKdwu+AcXAJhNgWQ8rb21lEnCcLSdEj+wYOe
         r1RWXSDJZsGNNntTYqZMcaVbDMjnibEdVHS/GnaRThL7r2r+UdjceFKlzWls9olog/62
         52aER6tNTtBp2GUvGL+OBWYVLqJ9uNrV4yggMNh+AD87JMtMnhjpHl4g8q3FZc6IEOTJ
         RLYPw7rLiAC1CP7amuSwQoLemgLLOpsvh36wiLvq78mPNe+1FHiITzf78t0TLmDCA/gT
         Uo3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784185149; x=1784789949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Av94P2V8NtTmuihxtjhBFmg2tcbDiYUZN4BJgJSyKHU=;
        b=mMHQKQFC5XzYIPtLCtYaBNUCaH7uaj1v9uh08D0pCiTjblmS2F/Kbd50LpgHwTPwbZ
         tiSLa/NVqh8Ot83/VRCp1CIaLvcRKroasX0KgZD4X6/4kiiLt67E9O5sm+7+VYsG8K05
         2zyagZaXWEZciDOoi2nL0TU0Nlxcid7QrmtRE+SltBYEyh57kxtK++NCQ1dyZthVN+hW
         UPTzwwdJCAYuwkHd90b4dV1gH9eaYAnbWDqwtZsgdMYVvokBBZZ4eiluh+r5/PMWRLpn
         WxxZPkybkX4JGQdDuqS5/i32bJVDWF4pgxnvTRT6IurvnRurjgBjGmvF53oZoPpFsgtF
         hreQ==
X-Forwarded-Encrypted: i=1; AHgh+RqCfeZDkA6LwIuzRa9dIeoOOpXd36TaWzdRWNCnFoiXKHV3sdIVxDL4i6u/iTutqj/lpLAyt3tw8sC8@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0sTM1GJlCXoQKWvSDn6NdyFvMsmR0F2xrIJOJ6vhsmKhkwMI3
	2y7UykGgoVH32+B6qS9VuQgvrKPMFvoOHJsgHgethFPfpxpLB+zCabu2
X-Gm-Gg: AfdE7ckL3MJODqN4CJgGYxjJrrxEYwpkxro1lfT9kvzt/4rWqyDnVL2nx03l92/ggWo
	WRbidI1GjnZDSw4REG9HvhLa33UNe7oK0xbqdxCpQC4X3jQudlsQ4ZpclOqOxVAuB5ZlUCwhisw
	NJTb5arkhjL9YQn33IJL32s+pJ+kEDWSpT0aUTXAczIP70nBAHoiDtT8LsE6SdFccGwAFmN+ETi
	kmim5fH6/c7h7v1riYACRLejhf9hyXVJRQgJSsCwNVdMjkaV3APnbR0xP7p5lLR6E+Xg0nRU/lT
	8HfiJj5c6gvxELN3xHOXxcRURs4JksIudid9P92APPBbBK9wVCv2OGZ/nXnJ/Qzg0WxLERTPhND
	KBMAeWbg0KyR6uEMG6rlXSq12AeS2iEJtW+qDIKGKncSHzhVpQdYH4qE7xxN5jVhp9cmN4XwPbu
	mkbSDem9S6SztnW4bicGiccmdoNe9mB54RRhu8Xw0yAO6xtxEMezcTcIZktBxtqeJgnV1j4MICh
	SiXpzzLcW29lxFq
X-Received: by 2002:a05:6a00:14d4:b0:847:888f:9b0f with SMTP id d2e1a72fcca58-84beb1a602fmr1332854b3a.15.1784185148733;
        Wed, 15 Jul 2026 23:59:08 -0700 (PDT)
Received: from nugod-NUC15CRHU5.tail9f095a.ts.net ([218.237.104.87])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f7dadcfsm4278643b3a.48.2026.07.15.23.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 23:59:08 -0700 (PDT)
From: HyeongJun An <sammiee5311@gmail.com>
To: Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	Lee Duncan <lduncan@suse.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	HyeongJun An <sammiee5311@gmail.com>
Subject: [PATCH v2] scsi: libiscsi_tcp: bound SCSI Response data segment to the connection buffer
Date: Thu, 16 Jul 2026 15:58:48 +0900
Message-ID: <20260716065848.1653431-1-sammiee5311@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710050645.1194212-1-sammiee5311@gmail.com>
References: <20260710050645.1194212-1-sammiee5311@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iscsi_tcp_hdr_dissect() receives the data segment of several PDU types
into the fixed-size conn->data buffer, which is allocated for
ISCSI_DEF_MAX_RECV_SEG_LEN (8192) bytes.  For the LOGIN_RSP, TEXT_RSP,
REJECT and ASYNC_EVENT opcodes the dissect path already rejects a PDU
whose DataSegmentLength exceeds that buffer.

The SCSI Command Response (ISCSI_OP_SCSI_CMD_RSP) path also copies its
data segment (sense/response data) into conn->data via
iscsi_tcp_data_recv_prep(), but it does so without the same check.  The
only upstream bound on in.datalen is conn->max_recv_dlength, the
initiator's advertised MaxRecvDataSegmentLength, which is commonly
negotiated well above 8192 (open-iscsi defaults to 262144).  A target
that returns a SCSI Response with a DataSegmentLength between 8193 and
max_recv_dlength therefore overflows the 8192-byte conn->data buffer.

Once the same bound applies, ISCSI_OP_SCSI_CMD_RSP is handled exactly
like those responses: bound the data segment, receive it into conn->data
when present, and otherwise complete the PDU with no data.  Fold the
opcode into that case group rather than duplicating the check.

Fixes: a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld")
Suggested-by: Chris Leech <cleech@redhat.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
---
v2: Fold ISCSI_OP_SCSI_CMD_RSP into the LOGIN_RSP/TEXT_RSP/REJECT/
    ASYNC_EVENT case group instead of duplicating the bounds check, as
    suggested by Chris Leech.  The handling is identical: both bound the
    data segment to conn->data, receive it when present, and otherwise
    complete the PDU with no data (the latter via the LOGOUT_RSP
    fallthrough).  No functional change from v1.

v1: https://lore.kernel.org/all/20260710050645.1194212-1-sammiee5311@gmail.com/

 drivers/scsi/libiscsi_tcp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index e90805ba868f..7223bb18b048 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -752,13 +752,6 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		rc = __iscsi_complete_pdu(conn, hdr, NULL, 0);
 		spin_unlock(&conn->session->back_lock);
 		break;
-	case ISCSI_OP_SCSI_CMD_RSP:
-		if (tcp_conn->in.datalen) {
-			iscsi_tcp_data_recv_prep(tcp_conn);
-			return 0;
-		}
-		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
-		break;
 	case ISCSI_OP_R2T:
 		if (ahslen) {
 			rc = ISCSI_ERR_AHSLEN;
@@ -766,6 +759,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		}
 		rc = iscsi_tcp_r2t_rsp(conn, hdr);
 		break;
+	case ISCSI_OP_SCSI_CMD_RSP:
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
 	case ISCSI_OP_REJECT:
-- 
2.43.0

