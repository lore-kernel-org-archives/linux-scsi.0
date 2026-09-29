Received: from mail-lr2-f34.google.com (mail-lr2-f34.google.com [74.125.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB0A5187CF
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 14:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790693151; cv=none; b=tUGcmgId4VYxrdfD8pt8PnxWHagLoJh9P0xk9Lnl8ENoC2/Ex9N2D74RSAKEmrqdZVfuPBuq800Qu65T0jRkHde8JXUQlqpcZudlVzhtYsMZB29+Gcu93yRgJPGgieJXC/yEcXpUKzyc484i7QNplC6yEGYSMRpBj1nOWkQKzP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790693151; c=relaxed/simple;
	bh=lZuVot7YJ0juctes4qSdCcPkywuCSsLMsB43wu1Y4Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m8Z/bUKwLLvbsP6ssUoLUeYL/U/Lt/m9eqwnpR7XV/H2nmKQZTOHJifUrwMc6BO5BDDUuNkg+5aMj1QYh7TLXQGTuK8T/iZTQwV4txxmkfHGD0m4o/FCgvmC03bdJRCODhTm88q9oLfs5stN1oATLQAmznk4ODi2l676Q91GFYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nqgispDF; arc=none smtp.client-ip=74.125.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nqgispDF"
Received: by mail-lr2-f34.google.com with SMTP id 38308e7fff4ca-3a75ff20a6eso13778951fa.0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 07:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790693139; x=1791297939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0wpjYz1EI0tVyJi7cV3YZm2AdOrxjkB1FR92T/0Hu80=;
        b=nqgispDF/NxzpqhPmGefFnf/NFQgvpbtPUlCbIz04VpNHLX7FFoXXaSx1IRrw9MY9q
         LfJtZusvMySWjkYsGXpwdlOgEk8D/hyPP8S8zdohZ9tkw27nrNbWI8jRBNgIzbvGNYDT
         67BtSefuqnWQ3Ov5NmBuTPnrPQQ4hib8BKjC23a1zR0mrb+VX7EiBNFMuuzuhabET715
         Wfl7VRCc/FnIIBXWe5DUgeGYu7Q1CRrRhkG3cDDEQC0ZbSsd3gNxzllK1IDwn8kW4roC
         0oYvoIVRFxLT2JDtDyMhDQon0G7KC3H0syjIbwDQbKeQCVJLkcSwE2RTvtV+U/5vmpPx
         moaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790693139; x=1791297939;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0wpjYz1EI0tVyJi7cV3YZm2AdOrxjkB1FR92T/0Hu80=;
        b=FY8d3hi2vWRRCgvm34rQe9pEsxIhlU1LxwFA9oYZpVY9jT6DkBJAhvqu10G+sGJHXk
         9kDWtDMA+le637Xzr3ZQz6pND4NwosyaZ4XKUIfDCbdVUPB84pckEXEoj29+6komjMox
         G8p5pmOUZdi89NClNTZyXEgbDxmfrIrdX2SfnNXnqddCnGwav7mQHxKDldaPUjYZv6AX
         amfEUM/wCao8b52M5QoIo5+RPzxgcABMwxL3anUnMoqQgFi2GKd3Er0H5yBk+eCtAi40
         ZCoyDMGhRyygkJHTesKLPnwMDZF/4GOa5ZUot3QoSup5ZHF4fSbEl6x4/bS+lLA0+hJD
         rO2w==
X-Gm-Message-State: AFq9FYK0fS20uRUcM374pFFsxk3p42K8Xm/TVaFdeH+TmAimTk2rtd+K
	V6aEFcdhD7eqyUWHG4AdvJmMIkeSZnGjr1p9zkaaVibu3tkjGTfEec9fQXyGPLU=
X-Gm-Gg: AYBFou1m5zRszzMikBMmXhgUGOPEgG5qVL5wpvNEs2DhNlsQcjHbAQVmMq3igZTjK4+
	86NVtKx5nSgQ8SE4Fi/i4X/zdjsz4d7TrzOO+KWny64BQsOm6MNfKYxyzJWta1cZ67ikAZpBs6u
	JJdFcaT5QRCeaw5S062kAltdMxIzCZErfMjqyao00m6WSUdWbGZL92UDtx2WweLkkDj8QoX2bpW
	IT7P9HZWnWOFPsSxKdOserLpJSExwfwSnBedy+pY16BdZdZGyyUmi3uXfzm57T3IAOvR2IoX28b
	LT86uYce9qnxAMXrnymFGT1X5Zbx0JhOrI+eXonAFljEkCPTaX04NhG5nfPTWPA3m3EVPUW0ui0
	R4NFfw86I2HUqFF65mn1q+FANjZ38/Op7KXMC6vxTOjrCcPRNuibgdc8vykKhUXOfsuzTadQxPQ
	UepL3AL48U03dn0CkjbRHJSBxbMcvQZLRrotjm+lsmLlKqzvnn5iqcufni/Vg7B7MIoNVoN54D/
	vWX+MAab0e++GUKMTYpFBmhLRqzMtcWd/KKxl4NXyNgds5xaLTLCsFP8HfF4DzXeV4+HY4RyeTj
	SReVUGy8dpdOMOJ1ZFBeFXPfNkuqHSQoof7wx9cj8pd8DNFHCAwGjzVEXEpjUkqWomnkYGbmDnG
	yeFSuO+3TT1yhKg==
X-Received: by 2002:a2e:a593:0:b0:3a6:3741:987c with SMTP id 38308e7fff4ca-3a64c7e9c2cmr34390991fa.27.1790693138834;
        Tue, 29 Sep 2026 07:45:38 -0700 (PDT)
Received: from gentoo ([98.10.102.237])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a64c2fa412sm41874421fa.22.2026.09.29.07.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 07:45:38 -0700 (PDT)
From: Matthew Whitehead <tedheadster@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: tedheadster@gmail.com,
	mkp@kernel.org,
	James.Bottomley@hansenpartnership.com,
	loberman@redhat.com,
	emilne@redhat.com
Subject: [PATCH] scsi: aha1542: Remove unneeded scsi_dma_unmap() call
Date: Tue, 29 Sep 2026 10:45:28 -0400
Message-ID: <20260929144528.7061-1-tedheadster@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

aha1542 never DMA maps the command's scatterlist. Data is bounced
through a per-command buffer allocated with dma_alloc_coherent() in
aha1542_init_cmd_priv(), the adapter is programmed with
acmd->data_buffer_handle, and the payload is copied to and from the
request segments in aha1542_queuecommand() and aha1542_free_cmd().

The scsi_dma_unmap() call left in aha1542_free_cmd() therefore unmaps
a scatterlist that was never mapped. With CONFIG_DMA_API_DEBUG enabled
this results in:

  device driver tries to free DMA memory it has not allocated
    [device address=0x0000000000000000] [size=0 bytes]

Remove the call.

Verified by testing on real hardware.

Fixes: 2f2fef022c3e ("aha1542: use a local bounce buffer")
Suggested-by: Laurence Oberman <loberman@redhat.com>
Assisted-by: LLM
Signed-off-by: Matthew Whitehead <tedheadster@gmail.com>
---
 drivers/scsi/aha1542.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index fd766282d4a4..a197b3d0b26b 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -271,8 +271,6 @@ static void aha1542_free_cmd(struct scsi_cmnd *cmd)
 			buf += bv.bv_len;
 		}
 	}
-
-	scsi_dma_unmap(cmd);
 }
 
 static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
-- 
2.52.0

