Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A83322332C;
	Thu,  6 Feb 2025 05:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738819531; cv=none; b=R4VMbPenwua2RqfJs52nkZES9Qcpt28yIEU8ca8N9scOWbxkhm0BApj8Sm2UJUBrBOp1UXdD64rfYcee2Iq0lx32E7D72qOHgfcm4pm90Jf1z5tRB8JlSsq/gGdpGlMzCa9l3ZaKw8kIvWzwgAI5uJOE04NkStxaDu+pAEzr9OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738819531; c=relaxed/simple;
	bh=Xtjx3uxcFPYi/TLUmDwg2/2tIWfAduJwYyqLWWeDeMc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cr6UvmB8T1jijj4Qa1RNJpFrfY79x4t+dNMkPAhbI4kf2uawBn1fBsAvkBBdbauqkQz5JatjNR49fgX3Lg77ExZLekPzet2AlDkeKSdN51MJ353EMeK3GsuX3S7VSno1sHFjztkSPW5/8O/iziuE+IhWhy83ukFzES4DVVArMdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dmyg+zJo; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dmyg+zJo"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-467b086e0easo3237281cf.1;
        Wed, 05 Feb 2025 21:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738819528; x=1739424328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJV+JnHF+HhkT7KIBW7n9OjfNE5A7gati51g0dLXiZs=;
        b=dmyg+zJocZALrdQrc2osE4Gu3EepGI7PGPBMwNzlXGvqW4Y1r0HyPaGW3/jPCkobKl
         AyuYF/yruNDYef6upbdZQT2psajOYcj7UNFjp0OnfT1r0x2crwwUP66N8TV0hsVbGFMt
         uY72WQSRgHbDpPmkWVak5KfRB1TBaYkYpFcGeFaG8W9gLM/Fg3VfED5PRL1QTfnw9swh
         zzL901StiyTOLTNSic9uG4l7kqBmDGAfTYRJc0PNBseUOIOL8FsB4JNi7xULBoKqwoRV
         UcOayASiD6HS5Al47nryW5BYC7QxVFeqeXQLR58ibvVXRVLg0KRlFQpDH+NVnHfpw4Tt
         hK9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738819528; x=1739424328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oJV+JnHF+HhkT7KIBW7n9OjfNE5A7gati51g0dLXiZs=;
        b=Z6ZtLF0UKJ7g5KFGwwEyDTuK7MGf6VUnhoBRDKVoWM1wFkfykj2/v9lJdW8mlT44mC
         /cJb0N6/l3K5oVzvSUIZMZUOMWM7QLTsnG1WURPRXBQQAP2R923xwaa7f46ZEzBxZABF
         N/5PhI2m50EB6HxyHQ/xCqjYOmkhWJss/zQoXhwfgCFq8r5wst1g+Gf6iPXjgvTxIr59
         AQnidv08l4EDka82bBPcIN+otLb7yFAybML2QME/dTBJSR+H3Z27zBbSnSiMzL+5ktgr
         v0fiwo/NiZPFtf9MKJALPlf665W4xZZbINoKv1QDn87aG256IMn/XHFXqXKKIyKkuJyb
         AGYg==
X-Forwarded-Encrypted: i=1; AJvYcCUF5CfJuVPVvnW0rqM8Jf3/A7WSCCtXEWfUz91lC9faUgAM8keU5fD6lePwoYMM2RFc/mnWuvE4WhgeCxU=@vger.kernel.org, AJvYcCXFxmM6ndtU/rP9/d68AurhnMGUfp3TLimPGe+DCXR5dXXauz62+u+V0FSz7m4t35eUjVhGGWt9xN83yw==@vger.kernel.org, AJvYcCXXhdTAxkm76lh/Eh6pQKhvxNWz0IiobcWNSsGjpJ3PUgzVYv73iBmW+g1KyyiZenh/b1meDsdc@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxt8sK4jKNMus8cpkW5V8mt/zvPf+6cu8hy3dkfbuRGQ8SvpaM
	11EhnJhgs4W5bQ+vmgcdrmwykO46ajlYrFDMpomQxBdr14z9QNjs
X-Gm-Gg: ASbGncsQxWwamR3oEANQ6NrEi02KBuxhxOUmG9Oq9qN5HsoBMXBW7P6SgzbPG6HUh39
	ZmBWuezpb2Y9HYAz13vp1UhI4VhvFt2Kj8KOjjcleywab6jq+8pnOgsbvxkwqeFystZhtlVOi5A
	mjCEbZDA6Sa99gwSHmir0V3LWUVBk3kCfUA3+quqWWFjIHrbV/cDGe99B3FsCoL1Qu4Uncmdu0o
	XGsNexMJb7XWcR/zu/GoicR0ffkTrh1nEyT32MFUePhF+U2eNPdmtRj4iSRya7zn7/660heSP4b
	5MBMaOs7Rv0h1jkCiZuylBcJD/ld9ir3DCxSyA==
X-Google-Smtp-Source: AGHT+IHOf4acj+ObsBYsQz4mzRjxCUqjl/8uitgt7dSFsSO+r5mbO7+1zCVFrdDJ4Dy0zGH4h+x8mA==
X-Received: by 2002:ac8:580b:0:b0:467:5016:57fa with SMTP id d75a77b69052e-470282e7349mr71813431cf.44.1738819528278;
        Wed, 05 Feb 2025 21:25:28 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47153beaacasm2285571cf.67.2025.02.05.21.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 21:25:27 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: markus.elfring@web.de
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com,
	arun.easi@cavium.com,
	bvanassche@acm.org,
	jhasan@marvell.com,
	jiashengjiangcool@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com,
	martin.petersen@oracle.com,
	nilesh.javali@cavium.com,
	skashyap@marvell.com,
	stable@vger.kernel.org
Subject: [PATCH 1/2] scsi: qedf: Replace kmalloc_array() with kcalloc()
Date: Thu,  6 Feb 2025 05:25:22 +0000
Message-Id: <20250206052523.16683-2-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250206052523.16683-1-jiashengjiangcool@gmail.com>
References: <d4db5506-6ace-4585-972e-6b7a6fc882a4@web.de>
 <20250206052523.16683-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
used/freed.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/qedf/qedf_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index fcfc3bed02c6..d52057b97a4f 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -254,9 +254,7 @@ struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_ctx *qedf)
 	}
 
 	/* Allocate pool of io_bdts - one for each qedf_ioreq */
-	cmgr->io_bdt_pool = kmalloc_array(num_ios, sizeof(struct io_bdt *),
-	    GFP_KERNEL);
-
+	cmgr->io_bdt_pool = kcalloc(num_ios, sizeof(*cmgr->io_bdt_pool), GFP_KERNEL);
 	if (!cmgr->io_bdt_pool) {
 		QEDF_WARN(&(qedf->dbg_ctx), "Failed to alloc io_bdt_pool.\n");
 		goto mem_err;
-- 
2.25.1

