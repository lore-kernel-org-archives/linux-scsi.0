Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1F63F7AB4
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781181140; cv=none; b=O/of3w7jIibWi9l4lj21nnCAU1Mn8wpRNJTxaym3rYr5YPNS7aAe8rCKB8g0yTQePKH52tJTVmdAs7b+0peHDcUw+DR+QRfkLw/bBbdq651l15cjkCRZFe6XOt41WcGstpRkuoaRC3P2u523BPQth3XlrF+Vp6Eo83wubloVrM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781181140; c=relaxed/simple;
	bh=+g3UoGJSQBMIJWfE4I1WQriSnOqWfRW0HPDuB75fY0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWGLInIqd2WshJoL7JRCT6keIwhjYo0/XIOSOjOWS6ImRntyBbEovIZ+dQT0LQD3KuVGCSiqctnMrlZW+VOfiCk7eCj/kO8EwsdWC7T6sioNsdpyUucdgNlb5S7r1Yh+urpzDC2niKXcFgZS4nWReF5cxuLzG2uKnCRDgP0/UXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AVQN5Lzz; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVQN5Lzz"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9158629a220so880551385a.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 05:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781181138; x=1781785938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VGR23VQQ0KIak7ZD7YLq3Alex+Q6WU/vJpcU1WhhyY0=;
        b=AVQN5LzzLDR6l4zmuedj4Kj76oucvGfD7HqTkq4tGb18BXNO3Sj+YvVqF1GKv030m+
         JlImv9Eyfv0eKC0hfNukxTwO241dNX0vERIXnj2SlDOSqNTafdJbDKN6YH3Zzusk6Rdw
         Fz4VAOjJjHISNW+ol7QjZ46yq/MDbOptcdaL8uxBeh0QMuB8gj/lc6Fz5k5b0W4wSc5L
         dsnRLO7XJN7gYHgNapC/oM8Nm/7aZtvaIbczFeKUMZzIX58xyJ/Wu+MMPGFBnsXaSrSf
         8jJ+DYORCHRqYHnBPpblAIihk8wzUpFfWJpYLdHzLBPrPqOtZL/4SoMF9oHCJq/L/nCg
         lSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781181138; x=1781785938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VGR23VQQ0KIak7ZD7YLq3Alex+Q6WU/vJpcU1WhhyY0=;
        b=rNphZYk8g0ZuJJ+IPAnkisSPYTywRyFd233egebgOs+tSt64PrJe6lJ0c70Qq7561x
         GCm8CJZ1rqkldak0gto+unBT7z6e+0FpBa/S3Jc+67pp0HRA0sWWpSDZsJu2TkhnAJKL
         epADXcaZ868PahDe4e4LdpjMGidJir/3vNyTQRe4RLoqqeeIcExFlgaBgx+bNOWzX047
         GECb12+6ts51KUABzMSMkH64AJZ8nRy1RxvNHaYgZ5d37TfLBjlTMmvZlqIuH6iquKZ/
         NVx4otYh9huN23dz/FUT2C6mAip8Yccr3i47+gzntxsDpjZCxFPby1Xdp/0uB4MzrKQs
         w+4w==
X-Forwarded-Encrypted: i=1; AFNElJ8xVhpKX8eZyzOMhiz+bt16HD1dhehyncQMH+dc6HDoM5PIox/j7y/zX5u6Wz/yGOD8+q7+I2k5HjJ2@vger.kernel.org
X-Gm-Message-State: AOJu0YyNQkRI4mBe1QcPlBhEFLAGQV4kC1HUCIeeUBU+hacdKnX6GNpI
	lKVFP9m5J+8689B+R1CdE83/nhU9beHnkK4m82j21BJoYIrnfor7q2Ur
X-Gm-Gg: Acq92OFc7byC9uMCtNPQTesAt8JGlXASAUqGO3HK0c6f+EnfFAXguflXdDrHTOPWAWE
	1lqUwzD6zRa8WOjoCpSfW3WvR2k13Psz2RIqP25PijgeRp6jVBu7WITcf7Inlslph7lAxi1B+WU
	WCgws17ZJVUSrD6vq/tpuYKW7sxFYWQNLhKOri8TRF2T7soRLn/YE9lWY1bQ4isMPls/laK6O/e
	cskSXIDtkMozbl0qV42DL1yiaKsMpwRUepaza+c1SZXX3B2GbVAtgXCCorRGxYQKizYNRfEJ5YJ
	Ne20q4wENngxPDUxu+J4Mm0oBZ4G5vUsuYtLw9aRQw2Bdfbc1+d93bCCThao8b4Vuy9zAqZvJc4
	BxjS3N3Xo2yy96ErTZc2emusE6asgwP3ha6kTTYBkqevDDAYF9q35mTC9a++BWOndmfSYSPhTmB
	f2bIn8/qVpTUpx7GKbyEb0TdaTbQNuvDP6+iBU9UgdeTnqgTD8jYM+wSUzAvoJ5tPO336JQ5YW/
	q+N4tGzQYyJZD3tkwoTauiRc3ekm4E=
X-Received: by 2002:a05:620a:17a2:b0:915:3542:ff72 with SMTP id af79cd13be357-9160acc37e6mr365473885a.22.1781181138395;
        Thu, 11 Jun 2026 05:32:18 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9160b02f758sm171220685a.36.2026.06.11.05.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 05:32:17 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] xen/scsiback: free the command tag on the TMR submit-failure path
Date: Thu, 11 Jun 2026 08:30:46 -0400
Message-ID: <20260611123046.2323342-3-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611123046.2323342-1-michael.bommarito@gmail.com>
References: <20260611123046.2323342-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

scsiback_device_action() obtains a command tag in
scsiback_get_pend_req() and submits a task-management request with
target_submit_tmr(). When target_submit_tmr() fails it returns < 0
and scsiback jumps to the err: label, which sends a response but
frees nothing, leaking the tag.

Impact: a pvSCSI guest can leak the command tags of a LUN's
session, stopping the LUN, by issuing VSCSIIF_ACT_SCSI_ABORT or
RESET requests whenever target_submit_tmr() fails.

transport_generic_free_cmd() cannot be used here. By the time
target_submit_tmr() returns an error it has already run
__target_init_cmd() (so se_cmd->cmd_kref is one, not zero), and on
its target_get_sess_cmd() error path it has freed se_cmd->se_tmr_req
via core_tmr_release_req() while leaving SCF_SCSI_TMR_CDB set and
the pointer dangling. Letting the command release run
target_free_cmd_mem() would then double-free se_tmr_req.

Use the same helper, which returns just the tag, on this path too.

Fixes: 2dbcdf33dbf6 ("xen-scsiback: Convert to percpu_ida tag allocation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 drivers/xen/xen-scsiback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index f324732eba7f8..c7036e0e41bda 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -658,7 +658,7 @@ static void scsiback_device_action(struct vscsibk_pend *pending_req,
 	return;
 
 err:
-	scsiback_do_resp_with_sense(NULL, err, 0, pending_req);
+	scsiback_resp_and_free(pending_req, err);
 }
 
 /*
-- 
2.53.0

