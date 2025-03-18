Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE9D203716;
	Tue, 18 Mar 2025 09:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742291036; cv=none; b=ScCg6idAEmatNJ95z4ON1YewoLF0QtCMk//Fe6TF4McVACSpQ3thvTVCBjGmkfPOg3x2Z+Ki1TQwdNYaE6fe+NEbzkc5VfTamTiIoHWc5HKP8SUGE96GQZGHpnZtdRDXZ6HcBxTz3+Ga8OAHCrIrtxPWw6r2fpiVdIIv26GpyA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742291036; c=relaxed/simple;
	bh=XaCMPcxZPpx3RjmzjLh33LTCkrAMEaVOGoAlykO+ERk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hxLnoiv86PnCpXrkvQ3lTkC0cw1RM1psvz7G+8F6FkrSx7rJRPEDxPNCXD86SYWLBblZu12IY2KQO76seeQmoMY95GX3dTYT7YaXs3EXM6M1NFGW2IzChHx8Ma89MVAxgA0NQUGiMy0Kj+dzEGSV07V+FYaMyyd0rIx21+HLk+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=livyB0fx; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="livyB0fx"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22403cbb47fso98240885ad.0;
        Tue, 18 Mar 2025 02:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742291034; x=1742895834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hJbWkSZND/K3t/quPIPTfxuwMu7Us16mwzx5pshvALk=;
        b=livyB0fxNLh4TV7fDAuXqNYD4fRpMU+Xbtpt4eMCDmExKEvtI4G6RnyYNhY8VPPjsw
         BnE2dxfZ9b1KPaWqiFtXijS7vrudJ6OTazW8G3fiLB8jtapuxZkhqaLmcpYGumVR0puf
         j/7BUjJfvaAIvylfsHo+qy1XzPa22bmY3lYaYTFAAwZeRMjiGMePRvMvKB5XJ8gHy9cX
         k0rUU2jpCR1cGdq6bboO/0C1MVqToaN97ntSqSGNGjGZhC/MZoOi2psfZ0xSG4Pa1JSx
         uPYdeAps7k7/vTt/A6Sc8hbuE3qWeX3MBRqlsPb+Pu9V4kkyEr6yv7Co1hdx6gRhd3km
         /ytQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742291034; x=1742895834;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hJbWkSZND/K3t/quPIPTfxuwMu7Us16mwzx5pshvALk=;
        b=TumfS9QAW2uYTzTGgyA4IRDchqtRSbsH2C1NOlZ2Ro6vVc8ICZIoAuBrQgB9SH+xQx
         4cW08sMN1y+XwCGTr/zMkhKsF8jt81eRtPvsWj6e3o5/t2NI4gQ7xvb7TJK/4hyj5IQq
         7/95DsYpjxKAEpwWCbgy5PSU8OXn4zcO+j6HvtFOKA9XKVh5Lzi9HfS+lMqj1OujCVgA
         q/nnb/Ke4ubs9KG6kwU/Ytut6UcFTzazrA0jl43a9q1n4WyTl6GBH9aIkX2psi4PVLVF
         I99ehItzyLiePGgZWzl0nV1JAVvzKRrkrE+HPgqt+X0GPnuz9eHuDMLYxZoVC1p6EftY
         hElQ==
X-Forwarded-Encrypted: i=1; AJvYcCVypRh6iJIf3tl4z7fa1/pRup6+lliDGTP1Bas3ZtOe0v+tS7Mck9ouvC8ZjpAzF2eGjTOyHE0fh8lwfD0=@vger.kernel.org, AJvYcCWDfWmuRBg49oap8pQ2ahuUuFELeELbPEZajT5KQC2kCeHqd3kMwM41RDu0p/L25wGUIAUiWTCWuzVAuA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFxHIAG90dnzBskBgvpAyZTuo1wXly8TGYBWSjjMFWUgMoacSY
	JEx0wwBPQ+UflVwMqHQSiK621RXTRAwIPJAYp/jYooNzGplzHl01
X-Gm-Gg: ASbGncsTZOEgsZ/RQ8/WApH9LPZ2m0S+ltd7goNvIWVgGHYt4+ngMaIAzrhurH2E6k8
	uzwTV90KIOTQ67m2kXoyivVYrnEwBA4uvBufebydnhg4hj6lO2beJ99NSFA8uVFHZUCruLye7hc
	zZ68s4Gv4oi7wBNpmcXMUU/UZ2Xt+4XV3mP4MsyFuaGdXOZWUHTrQYoTu5VTzJjlW7I+rXI+sVz
	yi6+ZxWf5T+b/RNwsHmCZMbMAXlQvlIf7ViKYfjcprrvojkTQv9ldlnusue3I1iNDSQBZ5v2wh0
	W7Kh9mw5GyZW0QGpQJvxY2ug6ZL3NNM1WG35s/EajikXxLkwXxylyMQwjPJM8l5QgUS2jd/dyUW
	B7XY=
X-Google-Smtp-Source: AGHT+IH2ALjYAcNZFxFSk+UFw+JaT6R9liUb9JM6KsyABh3Uh+bIRYXRzCmoq6U09VGIyXm4x+WI+Q==
X-Received: by 2002:a17:903:18e:b0:223:325c:89de with SMTP id d9443c01a7336-225e0a5282bmr189640685ad.1.1742291033856;
        Tue, 18 Mar 2025 02:43:53 -0700 (PDT)
Received: from localhost.localdomain ([114.246.238.36])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-225c6bd3c59sm89848815ad.218.2025.03.18.02.43.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 18 Mar 2025 02:43:53 -0700 (PDT)
From: linmq006@gmail.com
To: Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Lin Ma <linma@zju.edu.cn>,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: linmq006@gmail.com
Subject: [PATCH] scsi: iscsi: Fix missing scsi_host_put in error path
Date: Tue, 18 Mar 2025 17:43:43 +0800
Message-Id: <20250318094344.91776-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

Add goto to ensure scsi_host_put is called in all error paths of
iscsi_set_host_param function. This fixes a potential memory leak when
strlen check fails.

Fixes: ce51c8170084 ("scsi: iscsi: Add strlen() check in iscsi_if_set{_host}_param()")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 9c347c64c315..0b8c91bf793f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3182,11 +3182,14 @@ iscsi_set_host_param(struct iscsi_transport *transport,
 	}
 
 	/* see similar check in iscsi_if_set_param() */
-	if (strlen(data) > ev->u.set_host_param.len)
-		return -EINVAL;
+	if (strlen(data) > ev->u.set_host_param.len) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	err = transport->set_host_param(shost, ev->u.set_host_param.param,
 					data, ev->u.set_host_param.len);
+out:
 	scsi_host_put(shost);
 	return err;
 }
-- 
2.39.5 (Apple Git-154)

