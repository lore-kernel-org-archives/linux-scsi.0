Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B222BEC43
	for <linux-scsi@vger.kernel.org>; Sat,  1 Aug 2026 13:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785591416; cv=none; b=mXejbtFXH4nL5H8enY2JssDXKQSt45ZhZ9sTqgnlQHdodYsNQshuXlBydRuYs6Hv6n+4H7WdHhqk2hJkO5ygRmZCBSUGVNqIjO41mDRr/9/UDK0qietb1YY57WsEHBTwoiIn1FBA6LZkCX5CmM6ca2po9awdTJQgJTPL9istRCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785591416; c=relaxed/simple;
	bh=eB58HO5QK1YXyRAqhrYWSTOZcsExz4TPhNofK2YkZlA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rGutuvTtrAO3WppI9jSLLKNs1hX03xvz+A+eFtRO2A4xL+JwjOurlTF5ygHytL6qQC+1apJ6yTbxUz7BuclqEXGu+C5h0EMCdT7A7QZ5le4/iV+1d2YFu7KKnKf+mLEeHrqPVx8ABoL5+DcSklHq6XEL9qT7PKIeQA7uLnvxhHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=wMxxRSrU; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="wMxxRSrU"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cee9b74ee1so15103795ad.3
        for <linux-scsi@vger.kernel.org>; Sat, 01 Aug 2026 06:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785591412; x=1786196212; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=upVI1OEGifNaxUYsdgzmCaYduKWqMNtXXmGmafq6qHQ=;
        b=wMxxRSrUV7i7niuhtw9GVWWaeqf5XQ8zbkIc2ivrl4RbUVa671eIaZyHSaO40vxlAx
         N5SMJo0jRYishPWAyA7oj1VFys0Q8DNTO4dIJAK0yyDRTIhehVMqx6nRI+RIiA8gZfL3
         4TMm5BOwRQlir45Hy/XbEQFHYRvUus5ciYZHHd4sedFO7P3J6oLmnjDENEk32Krucdgd
         n9TW9RMnc+VYSAaP9ozKlEnG4e1aZXpO6rMNxciphRQ3JPBT6fqjv7IAgpiVGBwm+N4v
         A5OvWwGspOOpinWCguBgsSwJcLf095tss6w1kb4rsxqGiYoZQQwypsEQgVdtdJDfBCdN
         Y4iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785591412; x=1786196212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=upVI1OEGifNaxUYsdgzmCaYduKWqMNtXXmGmafq6qHQ=;
        b=j5ylJqhFnqhM2n1FhH7G6KLyE2EbL4P/vKIniu27jKgNjtgAtw48D8vUGwU8095xBu
         BavyE9h8+K6jB7Qotk7+3FenKOaTuoIcO7Pfevj1W2UHL/F9sb0erzczDHQwH95wmx6K
         ngyx8m5oGxF/ViRfgvtJtUG6EQT/gUdiYKmrSgmsqz8FNzIzTjULd6a5x7QoApL8nrKv
         jSrPvB8diUu+/+fRI07+p/reouvxtoHeG73CN1Y5CkaML36UGOyUU/xCv8SxFbGU5xYZ
         FN9O2F/g4Zn0gwd7JxUT+3ebB3ZU/WYp6SEqcqjIIurSCQnQT3gEgtlWZCVeZcZjmU39
         gxDg==
X-Forwarded-Encrypted: i=1; AHgh+RqOd9+1Qk30LkCvP0oGcfLEZBF6cdzzv6tyO81udbZCVU9iqpP8N3QXW4G0/Q8fYCxPDvw9XAtufRhx@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxm7itg2+pHyEDG51u0KFDI/iWCiQJFLy1fq5qPw0gfaO5QB53
	EATLGzpKt/hugR82FYJNmVCAhB76i2C/YGiGlqNE5fvyGHx5LRM4yO2Y/EsfAx1SEgM=
X-Gm-Gg: AR+sD10Ka6IpVd1z09UPxF2ylp6eeo6Kc8XdFrS0rd7axX+cnSkawkAeYw8u2aqDMAj
	4LqvV5FlPfWdxJyDOdw13x6fFr9YQlWKjHc9h3aKQ/SzX4RUYOP3IGCe/mSpJITR60dA0Cx18EC
	VOK/cmWLLEw40EJFelibFM9GbrcQM5w7b/B33y8tPshGodcteAZjTfD59dqCs4JvhnHhHughozX
	AW8e9nK9yV0+tnThgQx2eNnTYG5mpSyKo2MEpvJvhITP1VkDnG3YXS3Ipo1xsDCp28z4sWy1u9B
	xh+lQiTpfK+k+o8MfFPOWgq42l4LR4ESGY/+/zFYhrEKt/n2qsoPWwOwi8M/NZwvUA2L58PFLUM
	D3A0B9lQL3Z3CdyU9yJR8C2Lg75YGpvsHBVD4cNGx3C7adVpUBywdzkw/n2VfAcO6tjqIJJsRS6
	zFfIXAhWkMGsGv3/g9xr21BGSY17ffF6y+sK9eYk1u17Ha7LEDHNVHICxI7jGKUlKoVFXNZbBtl
	iw/Ss45YuEcPqEGcokaBA==
X-Received: by 2002:a05:6a21:6e92:b0:3c0:f772:8128 with SMTP id adf61e73a8af0-3c92a889548mr3898837637.54.1785591411530;
        Sat, 01 Aug 2026 06:36:51 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c329:7b28:fe02:5dc8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe39ea9c50sm1697375a12.27.2026.08.01.06.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 06:36:51 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: libiscsi_tcp: check the data direction of a Data-In PDU
Date: Sat,  1 Aug 2026 22:36:35 +0900
Message-ID: <20260801133635.1986706-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Data-In branch of iscsi_tcp_hdr_dissect() resolves the ITT to a task
and copies the PDU's data segment into that command's scatterlist without
asking whether the command was reading. iscsi_tcp_r2t_rsp() in the same
file does ask, and rejects an R2T for a command that is not DMA_TO_DEVICE.

A target that answers a WRITE command's ITT with a Data-In therefore has
the initiator write target-supplied bytes into the pages that write was
about to send. Those are the caller's own pinned pages for an O_DIRECT
write, and page cache pages for a buffered one.

Observed against a test target that emits one 512-byte Data-In naming a
128 KB write's ITT, after the R2T for that write. With O_DIRECT the
caller's buffer ends up holding 512 bytes of the target's data while
pwrite() returns 131072. Buffered is quieter: pwrite() and fsync() both
succeed, nothing is logged, and reading those blocks back returns the
target's bytes out of the page cache without a command going on the wire.

Check the direction before using the scatterlist, the way the R2T path
already does.

Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
Reproduced on v7.2-rc5 with the in-tree initiator over TCP against tgt 1.0.97
on loopback, HeaderDigest and DataDigest both None, InitialR2T=Yes,
ImmediateData=Yes, FirstBurstLength=65536, MaxXmitDataSegmentLength=8192.

A 128 KB O_DIRECT write goes out as 8192 bytes of immediate data, one R2T for
the remaining 122880 at offset 8192, and 15 Data-Out PDUs.  The test target
inserts one Data-In after that R2T: ITT of the write, DataSN 1, buffer offset
8192, 512 bytes, no S bit.  Its payload is a repeating 16-byte marker so the
extent can be measured exactly.

  arm                 caller's buffer after pwrite()      target backing store
  no injection        marker 0, non-0x5a 0 of 131072      0x5a 8192 of 8192
  injection           marker 32 at offset 8192,           marker 32,
                      non-0x5a 512 of 131072              0x5a 7680 of 8192
  injection, patched  marker 0, non-0x5a 0 of 131072      marker 0

pwrite() returns 131072 in the first two rows.  With the patch the PDU is
rejected with ISCSI_ERR_PROTO, the same return the R2T path uses for the same
kind of violation, and the write fails.  Two runs per arm; a 4 KB write and
the 128 KB write both still complete normally on the patched kernel.

The same injection against a buffered write of the same size:

  arm                 read back after fsync()          target backing store
  no injection        marker 0, non-0x5a 0 of 131072   0x5a 131072 of 131072
  injection           marker 32 at offset 8192,        marker 32, 0x5a 130560
                      non-0x5a 512 of 131072
  injection, patched  marker 0                         nothing written

pwrite() and fsync() both return success in the first two rows and nothing is
logged.  The read back uses a descriptor opened before the write and puts no
command on the wire -- bracketing it with a 512-byte O_DIRECT read at a fixed
LBA shows nothing in between on the target side -- so those bytes come out of
the page cache.  With the patch fsync() fails with EIO and the write does not
land.  Injecting at offset 126976 instead of 8192 behaves the same.

Eight runs of the injected arm at offset 8192 and six at 126976.  The read
back was corrupt in every one.

 drivers/scsi/libiscsi_tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index e90805ba868f..0283c4444cd0 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -480,6 +480,9 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 	int datasn = be32_to_cpu(rhdr->datasn);
 	unsigned total_in_length = task->sc->sdb.length;
 
+	if (task->sc->sc_data_direction != DMA_FROM_DEVICE)
+		return ISCSI_ERR_PROTO;
+
 	/*
 	 * lib iscsi will update this in the completion handling if there
 	 * is status.
-- 
2.43.0

