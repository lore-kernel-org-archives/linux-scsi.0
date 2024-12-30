Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FD9335BA;
	Mon, 30 Dec 2024 06:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735541450; cv=none; b=gmXTw15iujCMzpmyBUT4LdQ9N7+3sbKXeP/s69/MstdYTGwO8K4YzWJ2OnUE9yLu+AYqAWVMMnhQVGX5Km8crRfx458qL4YtgYY/+jstCP94sJEd4pyRGmKfEQ96M1jOX6ZzCUtIdq+aFakvK0TDlkspC1GLfrtmdoikneggVwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735541450; c=relaxed/simple;
	bh=6TxKrAVAdmCbpxlHWcPXBw8B9fVXl9lzcOXPtFxubho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h9gUgKfEzUNqitkeyQCcL2Csjm1U61wxq1LAran5WesiW8KMGG9KEpB1jQ/8YWYXYMg72EuCUuI7iwmIwJgHNytOesd3FAP5PMDwtXcUdAkbTkO8dUAIyr7IsVJ8ySsnRXyWwkdxsskRExSRzOEtPGCzJ72hFcZC9NRC3fMLabM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TKKwHc+p; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TKKwHc+p"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2163dc5155fso111667225ad.0;
        Sun, 29 Dec 2024 22:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735541448; x=1736146248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HrGnkXdJTKDIbBx7nMZlsxBN7/Ez+9hLB+1Epd7M69E=;
        b=TKKwHc+pMRMXzU6IW8EhWUiuV2DwNOzyWXOTGlKyAqR2d6C16y4MoN5qqVYcEW5zNn
         JCh8+H4bim6PAyih1sk4QPYci182JbMb1nzTOUnAGb821gfOxgep8QpX6f5es8QydSXy
         qjNVFfS0p6nl3Vr3Ce6wY25nYjiAITD3wPu3h8igLreqR4JiAEXjJJ+JthW8freJZ8Xa
         u/LzzLhjACtgamhRCeYxgnVRD06sKKBkRPYBC9TKg+5XjUOw9mYpNsPKu1WjnBsQR5t8
         hgpsjeQ/OS6BL5w8f2XYIc+SY6IDHYD0yNHrq4BB4aMYXm2/oUqBboz7lyQIjB5HA5IQ
         c+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735541448; x=1736146248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HrGnkXdJTKDIbBx7nMZlsxBN7/Ez+9hLB+1Epd7M69E=;
        b=TQ7UTaU0uiUBio2Gidh5fVTGl0mWEO9I28SCAR80J9ujOpKdQGOduZ+mZ+/1fN7HR5
         HYUEwvX101gzIjNS3L4z1/282XLv6AQ5LnwCmbJcIw4MMNEglrm2aZXai7u5Ry1QO+Bl
         d8d3SSE7NoIc3/DnnM2R1LaWTAIURumBKh6A2DOeiE4u2a/1hL7Ih6bN6iIps5a08I9X
         mqHzVhwBdcJLD2IZJV4yyRaHKIRpAzSF7yr9yQfrLsKsDbVxX93qcg7qlQJ9wCbJ96AP
         U6NBiIwgRoaPzdVE02WuNMktibQfGjFtFPntfMG+d3bbISIyYx2FfiupKqjRcA1jzzh0
         JBhQ==
X-Forwarded-Encrypted: i=1; AJvYcCX13vnxqMvfSZd+H6RQ28MSlpVjgmUbfFzjfssVzTGvgfTjNxpCBiClIgcjQrJgEnZDC4E2i3YVvQg4GAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzM1HVSGdG0WSYUWWC4x/OQU8GS9uuyllQ5rgPYWsAHvpsEbgC/
	W/pe68Kl/HMhY+ddtx/r4Sj32JqkKztLsP7SRlvByeBfdQqkH3nB
X-Gm-Gg: ASbGnctfYGA97fP9rq/NXG67ER9lRPP8/7ceeixnACOuaxLRQTuoOPYw9UjlkeAKu5j
	xaon93MbDvEuDU2cfPcXs3vrU+ubPj9xdtX7z3HH/vbNM+U65ZrxImYtbnlwaTskWILEPhdy32J
	rSp50jLazLUS6A9NX1gJa94VlNr3lIngtcZR8KMuDt2el52NSNsgbrJ+ypgQ4EG/3l6cMGl232b
	2WxPoohQ6rx+S4NkFdDqq5nBISP57uo+ljtPMZRY3yP300ZU38sb89zRTB9s2XbEWDnhgYosg8+
	UbJwBrqom72ZyIx0K4Abp0dgxQ==
X-Google-Smtp-Source: AGHT+IEeS7tlV3TMoiVBRiBLwLcG2JMKw0ZR9J9lmd7KIG5rx04SQxlVMmmpSjnBZVLR++LlIhU8IA==
X-Received: by 2002:a17:902:da87:b0:216:554a:212c with SMTP id d9443c01a7336-219e6f12d63mr403512815ad.46.1735541447966;
        Sun, 29 Dec 2024 22:50:47 -0800 (PST)
Received: from HAOQINHUANG-MC0.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc962c3dsm171906205ad.31.2024.12.29.22.50.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 29 Dec 2024 22:50:47 -0800 (PST)
From: haoqinhuang <haoqinhuang7@gmail.com>
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	himanshu.madhani@oracle.com,
	skashyap@marvell.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	haoqinhuang <haoqinhuang@tencent.com>,
	Haisu Wang <haisuwang@tencent.com>
Subject: [PATCH] scsi: qla2xxx: Remove duplicate fcport release in error handler
Date: Mon, 30 Dec 2024 14:50:41 +0800
Message-ID: <20241230065041.67315-1-haoqinhuang7@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: haoqinhuang <haoqinhuang@tencent.com>

After calling function qla2x00_sp_release(), the system automatically
executes the function qla2x00_free_fcport(sp->fcport).

A closer inspection of qla2x00_sp_release() reveals that it triggers a
call to sp->free(sp), where sp->free points to qla2x00_els_dcmd_sp_free.
In function qla2x00_els_dcmd_sp_free(), if sp->fcport exists,
qla2x00_free_fcport(sp->fcport) is triggered.

Given this sequence of events, calling qla2x00_free_fcport(sp->fcport)
again during qla2x00_sp_release() is duplicate. This redundant call
should be eliminated.

Fixes: 82f522ae0d97 ("scsi: qla2xxx: Fix double free of fcport")
Signed-off-by: Haisu Wang <haisuwang@tencent.com>
Signed-off-by: haoqinhuang <haoqinhuang@tencent.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 0b41e8a06602..faec66bd1951 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2751,7 +2751,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (!elsio->u.els_logo.els_logo_pyld) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2776,7 +2775,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (rval != QLA_SUCCESS) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
-		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
-- 
2.43.5

