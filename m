Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675C233938C
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672657; cv=none; b=JHGOBlaBUcVPEU8aM0SKTASloZov2ATn5iC4FP2v5BXu6RAjLLJyybsLuUi4k+rO+VVCRMd1v/9RiiTluWod5HUYtHKwxPc77XdwIj8sfV8ICP0nyS/l3j04aG0p11CLBKiYU3mzvCuXsVupXl0OXeeAL0xAoYzLaD6NhE4Gfeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672657; c=relaxed/simple;
	bh=KIMckrdf5Rcb6FP1D8PnM8MyA0ZBG6QZqcMzal3zuVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkeRmb+JqbSTN9bNTS6N+2QVxyCCUPYyMZ6N4NwX9qRGKvfClz+r4sHyqqkhYArQuUMPYBntxvFHRCQyG5qSSwB7wLKx4oVu8SMe24uM28SXoYuJ+L4i+z1D3qMWMwlbMQs/X8u967SYCzT/ddbKDm4QRFmPvGJzY2/IJ+C5EBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=TFyPAMHm; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TFyPAMHm"
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-7ee4399c423so4591610a34.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672655; x=1788277455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZKpQpy3fSYTmPkiR3demXtX3WpgnSgRiv6wj51s7LN8=;
        b=p2LRNOg0nbDLkH6Y4OLfWyzhUWGg2XyZlcbGLqbyspYSFL2enMQN6UFPZOMOTwk9hN
         7rHhcmRkpG0cby/SBJme+ljbS9pqzJIOAanG65KlIdc+TSBPbLlE8T40mzUBhtija1t9
         tdd8BIzZKTJMS7vJzQ8A3ZJmo7my5WfDX/w+VVTB9x+/XH/ImJQSaDJOIs/XoKgS7WL9
         iCFYAov7Zy6EB08dXYn3ojmp3FGiQQIy4oYiWhgDLVi9uKqETD6ezMbAbOOrOo1zUiWz
         W9bNwPOpOlSU419pAba900eWwwrLI2kw+C65HocjYmGG4SEzuXGXfX1f0KVSn/1LhVqn
         KHLw==
X-Gm-Message-State: AFuF++nTn4DhdaNwfaEi2RiuoRywh/SoNy5AQw9VS6bn18+0kw8HI0NX
	PXCOF1Oq6tXAG4Ydm6AXqZcJVgNBCip7nopRFc3phKzOkwl/rs0o2HG4LFNsFOKKg16sYl/Elhq
	VzFYI8RNhKqqrRGhm3KyAkYaweF6yShZuxErRMQYWl8B18f0DMmLz5KZfT6nHsoRw3VT1EuGFtn
	zhV9OBrN9lIj5AqBX+K46xHevlqVyXd8d8BQF+YLnVlDYyHxE6yw3ii7Ox2CiIrsb/w6o5X4ahi
	wPyAeZWAn3yOJv+O/aua7LN
X-Gm-Gg: AR+sD12y8kUHpNDMapqFxCzRRoy76yahPlP3tvH8h0T+tJcT/O7GGlwN/ZtiN1F54EJ
	6Bxl7FHB461/kOXOxgwzLl8F2RPyYCOD7Do8MrpMkTEOXBZOWdS7rXtrqToxGzgU0IlWwi1+bZo
	K4IUVZUbt68ehm1TXOzJDU9vPwsGdknDwSJGx2JbLuj3hOEmLde7ir5VWEE5svDzG0CIFlKDlr7
	WECEf7uhvao3Llh04yI6fHoB5llQKimnHsVbYwaGtiRaeHS+dq2xb1mgBsCICUfDhndNCq7p3Sl
	Qz8x/I01hGaU1m/UP9Vx3TGmIDTH4GPCHh9328GJfW2heFNNKe2byjTGVbP5EAh2MrjrExsYWaa
	kclO19wlimZaximNCpPLtELXenTPVFjzYhOgGwMe4VtF9/9HZfp3qQZu7YhEtNoRhpsvhh7cEyc
	wh4yZVHOXIxcacbicr+Ma7CXayOdOHH/4fXcsRC1zsyZ+XlQ==
X-Received: by 2002:a05:6830:719f:b0:7ee:41ca:e7b0 with SMTP id 46e09a7af769-7f4afa8c5edmr7268021a34.14.1787672655124;
        Tue, 25 Aug 2026 08:44:15 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-121.dlp.protect.broadcom.com. [144.49.247.121])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7f48fc188e0sm1084150a34.4.2026.08.25.08.44.14
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:44:15 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cfc52ddc55so72921175ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672654; x=1788277454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZKpQpy3fSYTmPkiR3demXtX3WpgnSgRiv6wj51s7LN8=;
        b=TFyPAMHmw6FpzYQmAg33VItX7RQKErtFQ8zFHUhZ+wpdTc1x1TypjvdUb8vM5yLlfV
         tW3VEHCviSoyQJwfj17+cJWonOGFU5KWlOvxnMEx7uffXJLy8m2Wt8Y/851TtCYYtpFK
         KRlkdxnilHGJ6MeICirZ6K00HYA+vdmiJ6fq8=
X-Received: by 2002:a17:903:1a68:b0:2d6:e4ff:9cad with SMTP id d9443c01a7336-2d6e4ffa0admr112638335ad.3.1787672653674;
        Tue, 25 Aug 2026 08:44:13 -0700 (PDT)
X-Received: by 2002:a17:903:1a68:b0:2d6:e4ff:9cad with SMTP id d9443c01a7336-2d6e4ffa0admr112637285ad.3.1787672653025;
        Tue, 25 Aug 2026 08:44:13 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:44:12 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	sumit.saxena@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 02/17] mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
Date: Wed, 26 Aug 2026 02:33:56 +0530
Message-ID: <20260825210411.301535-3-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The MPI request is copied out of the caller supplied payload without
first checking that the requested amount is actually present, so the
copy can read past the end of the payload buffer.

Check the range before copying.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - No changes from v1.
 drivers/scsi/mpi3mr/mpi3mr_app.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 8e5d24793efd..1cd1c38dcd56 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2538,6 +2538,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 				rval = -EINVAL;
 				goto out;
 			}
+			if (sgl_iter + mpi_msg_size >
+			    dout_buf + job->request_payload.payload_len) {
+				dprint_bsg_err(mrioc, "%s: MPI request buf exceeds dout_buf\n",
+					       __func__);
+				mutex_unlock(&mrioc->bsg_cmds.mutex);
+				rval = -EINVAL;
+				goto out;
+			}
 			memcpy(mpi_req, sgl_iter, mpi_msg_size);
 			break;
 		default:
-- 
2.52.0

