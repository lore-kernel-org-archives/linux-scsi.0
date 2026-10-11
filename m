Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673CB45DF70
	for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 14:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791730100; cv=none; b=c4nqE0sDd5cjCSZsgrV8eTfpAdBA8A2jNIAU3qE57+T8pSaNIj+F5LRa71FDnzmUJf9c1l4lH1MfOLC0m/UbDrZrQVBhtYjUjjPLYJBxNyxezUk1R/M/R2P376V732R3CG8oGRdjcwu1VchTgClojkbPjYd93DMAI/XLjZP63DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791730100; c=relaxed/simple;
	bh=wp2wz6TYqmnqIT2LRSTYsLgYORoln64DgzKKWwauE8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aR0HpKZX7gS0yb5H7uYka9JG+nY1WVIOCZNe+RX+6U2tkkZfRJJOOKi2H1xKBLnpLg/pmXX0WNMMAO+HV00DdlWr5c6/gfWHWnTazW+FfhdxZnTdq3YVs6W34Q6lDo8muZCseZKarpbYBqt8gyV7MFg3gauDR5OhQdScVqrx3ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=qgqE4V+A; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="qgqE4V+A"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cd5cd8d89a7so285234a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 07:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791730098; x=1792334898; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8l1QYFfMMBJoxB1IFUgFWO0ntxBdjM/gPsjDbGJDZ/I=;
        b=qgqE4V+A3OMPBnKR5zs3op/evaSin245UvpZjwS4KBjDioVTkXIHGySN5da16ToVbL
         x+2VJjCD3elKKzFK4zlL9Ub8+xJJ0KtAIeYgRhagkttg4rvlcj3rJJyZ0wqdpsYMI0sv
         IT2DArJ7Mj+i3gvjOAGzecf8tQ+oCvu6sJxiA1CQxakb8u/tJY+4wpAbSofCQTpzxBzU
         bl7dAO+fuLCD/ohQbCK8YYKSGWhZKSwjsccrtDVvRNEy97qwteFrHSoVeUIKof8cifDO
         DTtan+VVEcBpxTZPz+FpGdl5llOq8RAQxXKH0eR+mYITNH3YxUiWsluBeM9M2Z65joiI
         uX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791730098; x=1792334898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8l1QYFfMMBJoxB1IFUgFWO0ntxBdjM/gPsjDbGJDZ/I=;
        b=VmcJciDfj1UtQeZvyd0Ec0LqhFDRS86tY/DWVobt1yBCmBLNsbhM/UjxV2tIkGEddJ
         W4CSCtbRJLiS6TEiuP1RhHxUhoe7+tr/3YedMgJeJ3eqCIElrfbFsCtTIwvL9Ok+lHU2
         2EkdJto/7U9/ncHcQ5osbWbyJdnjivTwnuOZcbzDOl+ehFxTQQPpqIUkSJ81rfOGJmyU
         0IE/UiJZvZluJYoV9HoU5vucYZithZJVbB+8PLF5hM0vDr6AD3VVxM/6/uRiF3aMrpai
         QETzi6OwavFl5GggOLGch2OdWhyrcwCyU0tGsO/mXpkaKYME/msZGG6i1Wo/g4Bgp1Ur
         e1qQ==
X-Forwarded-Encrypted: i=1; AKwUvBw1B1VkjOBp+WDkXQ7a1LHSjBxQPl2N40A1HKPSvkYbD3yFDAw+cEZkKfr82cYpp3PQ5D8aS1nbAcnv@vger.kernel.org
X-Gm-Message-State: AFq9FYJKPLkYpGqYgG6g2l45VhoiHHl0xX1oEqfDcfoB8nFQtY4W6rN9
	LGIq7CnhAOVGQHdyI/01EY1/LXOxSdbyn8Ia8QTWp6sZp2DmZVzkZsaMK8jdyRONT4A=
X-Gm-Gg: AYBFou2CEf3KZaKpxecOcPdyQcFVhAvw/O+AGNX8bw9eX24wqLrPP6nduK2KsOpErRB
	rXELQJHcqhQRpqReOL53/u16Ya40QMgZRjmco+CNINM3tRCXmnb62iPAHGV0xVxyw5tZROKnPYX
	48AhuLQc3rCpaQKcyDNF9uYwgg5kSet4hanNNeoVq9G6O96zBxqzo4YNVmxB/SUtW6LfKqcPqY8
	T/uEx/MB/1POx/pWMVKFLMZgwj/QAjk1XUTTDp7wvwN0vtpsjX0BgksaHwniNO2t5m6HPSgKwUH
	xjaYByz/FXSg1ewOUjtw3Yry/OMky9WZ9V9hJmTesjPiuau+IzrldOtkeCOxWGDjTJGgJCD4gUW
	vTXFfytTIhYg3DqkqOs1QM0uNcBSx3VS//n8BqXjARsQsE4uyCgmeOZdwrZfpFN+fdTo8okdoMg
	DW5NZ3wqG17F0yMWmXOmpm4hQ7Isqz0H3++Ej6UHB5OUVVUJ/YkTjwSVhTMTlNnojrR5E04J0fb
	DiSFZD6h+nqzTe9XPaYb287NO0OSvej
X-Received: by 2002:a17:90b:5186:b0:3a2:b036:ed63 with SMTP id 98e67ed59e1d1-3ab3ac9bed8mr5366232a91.38.1791730097610;
        Sun, 11 Oct 2026 07:48:17 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:97fe:d421:a74a:1d6e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38ddac6dsm11729048a91.7.2026.10.11.07.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 07:48:17 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v3 2/2] scsi: qla4xxx: advance the reset-sequence array cursor in poll_read_list
Date: Sun, 11 Oct 2026 23:47:51 +0900
Message-ID: <20261011144752.2063334-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261011144752.2063334-1-yhlee@isslab.korea.ac.kr>
References: <20261011144752.2063334-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

qla4_83xx_poll_read_list() stores each polled register value into
ha->reset_tmplt.array at ha->reset_tmplt.array_index, but it only wrote
the cursor back when it wrapped at QLA83XX_MAX_RESET_SEQ_ENTRIES. The
cursor starts at zero and the wrap is never reached, so it stays at zero
and every read overwrites array[0].

array[0] is the slot qla4_83xx_rmw_crb_reg() treats as "read the register
directly" rather than "read array[index_a]", so the polled values never
reach the slots a read-modify-write entry refers to; those read back as
the zero the array was initialised with.

Write the cursor back after every read and start it at one, so the polled
values fill array[1] onward and a read-modify-write entry sees them. Slot
zero stays reserved as the direct-read marker. qla4_83xx_process_stop_seq()
already restarts seq_index for each reset but left the array cursor alone,
so reset it there too and the array refills from the start each time.

Fixes: 6e7b429259fc ("[SCSI] qla4xxx: Added support for ISP83XX")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/qla4xxx/ql4_83xx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index c68500280168b..ed72040e905ae 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -1122,14 +1122,18 @@ static void qla4_83xx_poll_read_list(struct scsi_qla_host *ha,
 						  __func__, i,
 						  ha->reset_tmplt.seq_index));
 			} else {
+				/* array[0] is the rmw sentinel; slots are 1-based */
 				index = ha->reset_tmplt.array_index;
+				if (index == 0)
+					index = 1;
 				qla4_83xx_rd_reg_indirect(ha,
 							  le32_to_cpu(p_entry->dr_addr),
 							  &value);
 				ha->reset_tmplt.array[index++] = value;
 
 				if (index == QLA83XX_MAX_RESET_SEQ_ENTRIES)
-					ha->reset_tmplt.array_index = 1;
+					index = 1;
+				ha->reset_tmplt.array_index = index;
 			}
 		}
 	}
@@ -1256,6 +1260,7 @@ static void qla4_83xx_process_reset_template(struct scsi_qla_host *ha,
 static void qla4_83xx_process_stop_seq(struct scsi_qla_host *ha)
 {
 	ha->reset_tmplt.seq_index = 0;
+	ha->reset_tmplt.array_index = 1;
 	qla4_83xx_process_reset_template(ha, ha->reset_tmplt.stop_offset);
 
 	if (ha->reset_tmplt.seq_end != 1)
-- 
2.43.0

