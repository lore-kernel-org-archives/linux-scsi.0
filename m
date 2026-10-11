Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267CC45DF47
	for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 14:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791730095; cv=none; b=HZ8QhkfxDCPXvNGlPe1gQ83Czs8I0cmn8780PwIgZxiRhJgh5Gk3G0vwvh2Fm26LejbDQUmzIMWWR/RM7rnDmA0r+OmLTGCPN742xUJOHZxxUDMUbHQ5Il/9JBi4tCAjajJRuNwfynOD5wnZKKd4ZQ+lwb3IpGE78HzylVUZnDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791730095; c=relaxed/simple;
	bh=7aWGWnb73NSU7Z0y3MRjEulSdwR/21cbwE2MaVzY7pk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fDQsNiGnQDkDrqXcAkyYCIvdqCn6W891eCllAUwhAZDAhFPM9P/MdYdqEXrp+vPqn1vCc++bcnx2DlaN2viH/yQZQL1JtLIutSg1shOdlBgURS5XA4S2gmUNE0u+kJ7cNBFOfZmIUQgsnUp8b/9lHZIrE1SVGfMxikkHCTwexEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=d6X5L/PD; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="d6X5L/PD"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-381b831d535so1333541a91.0
        for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 07:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791730091; x=1792334891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BbKfn/xhPzUGiDzldQhVozJf+7TM7w8YDGYVF538SOs=;
        b=d6X5L/PDd1GgtNfG8bJzNfgpvkDsuIQQvXR2C6b8gqDtJF5TbWWkkcy0c4o8W7YiC3
         zPcyjUksPmyD/GvBj/Ar7uVQdlXBhFN0XHtuvBdMMOEiK2kOOrQzUEpt2lF6/6i2ufRI
         tUb8FRahtL2bNpFF6ZoWWGC5vWCfVB0TRSypTdGp+x82eI86OOGWK6Xl/BRoUPNTrWF1
         0V7UTT0CLcN3o9qGLGY1b0DCVbmxbJroKniGeHaeT6xXEtJnjtlDrzM0V8euVyJsJmyB
         l5Fxfht83tE1qTHaWLFSgXTv5tQUVRcMolC2pGvYhrBoHXneTlpr8TMndc8cMyutSoqp
         sEyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791730091; x=1792334891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BbKfn/xhPzUGiDzldQhVozJf+7TM7w8YDGYVF538SOs=;
        b=Op5o2R5WtpW0F4Cj+Wue55lHayDbZVVUBPW0FW/eVabngHUfd647Cd+a9/V8qATZs+
         XaoKg0ak/P+BewostZcH5gCgDKFp7/ubvs+AbQKi5O1CpV8Bc0T+9LoCLsr6uQBd/TrQ
         K9GsBMtzuVkFcQQ6lcuq/hW3ZSJH8c2wRO7vrgwsUW0f+rFC8h7hzNBX0REYMPSsRn9v
         2uBA3uQiuTLXsprCl7+qpkRTIOtlCmR4xlQPQEktrFQauZuDuoG08PcMXiE6RQthtGQx
         ILBanoDNTzyVcIJ+DF5cbo26KhFMXudEOECgcv84Vl2Bs3sulwSBDOll8dWVUwMHx78f
         GzHA==
X-Forwarded-Encrypted: i=1; AKwUvByRuyDz0dCot40ePBIWIrgaMd15FCaKgFZzVbDRPMg82qvmGm96NusvmJdan0NyjoEILQ+wnFZoRSGL@vger.kernel.org
X-Gm-Message-State: AFq9FYJi+fg+nhavSovMH9CgbsvZLUK92gxEVrgW1ZkuQMHUqkzFV5cS
	U6Nxr1SqWpDtmndO7eo5R7YmEACpT9kVv/wpYWRm4gzXvv7k00iPC3p72QP4PdFo7DM=
X-Gm-Gg: AYBFou1WpbIeiIcT+h78/AlQ9WZhO45chuxwZiqL9ZcbuHRuikxcadIwuwsEIo3tIwX
	5H6PFPL7IMzu+DTdbybD/zZdUGG2NnpEdu/cdBdl6TAXw5ArK1oO5MyYzuzxvx4rCg8dwg58Ita
	QUOvp2cGsmuRc0B3xi21mdRnyHlgcGMjJYUvhdBaaAb9KCZWXsvY7nG6qG173Ft5v4YvxgYOT17
	d98aLbZbvpWN/eP3qd1yNI0/PW+MxjfSL+eeYLjp5cj93rb+XvO66VlorH2zVpR9DlBybTf/jUQ
	OCpQNoskKyAAT1/IiAEe5IVslz4lDXj9ADclmbajx+raoKe/mo+j4SF7yO2Xr19lUJPJTtNyaMT
	OjnPXmgzA1HVMMDViYBXi5+UB0/oJpMCBMoc0nf7CxuHpkDmBRZvwPuII9mOmwbJKHkWB7fh4Nl
	zqmQMic375Ze7udgH28FMx40TUZAHb1eJx5mm0szdVwnA9lrJgyaCqa7jgF2G3+KZOFF4c3Gp9S
	G4BgPXvCxkDMpQe/MQsnriQ71G/0ZJ5
X-Received: by 2002:a17:90a:a96:b0:3ab:9c73:12a with SMTP id 98e67ed59e1d1-3ab9c730944mr1926196a91.2.1791730090947;
        Sun, 11 Oct 2026 07:48:10 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:97fe:d421:a74a:1d6e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38ddac6dsm11729048a91.7.2026.10.11.07.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 07:48:10 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v3 0/2] scsi: qla4xxx: bound and correct the ISP83xx reset template
Date: Sun, 11 Oct 2026 23:47:49 +0900
Message-ID: <20261011144752.2063334-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ISP83xx reset template is read from the adapter flash and executed
without checking its sizes against the buffer it is read into, and the
array cursor used by read-modify-write entries never advances. This
series bounds the template to its buffer and makes the cursor fill the
array as the template format intends.

Patch 1 is the memory-safety fix and is marked for stable; patch 2 is a
reset-path correctness fix.

v3:
  - 1/2: also read the remaining little-endian entry fields (register
    addresses, values, masks and delays) through le32_to_cpu(), and
    allocate the template buffer with vzalloc() so the checksum does not
    sum uninitialised tail bytes.
  - 2/2: reworked per review. The cursor starts at one so the first
    polled value lands in array[1] instead of the array[0] sentinel, is
    written back after every read, and is reset in
    qla4_83xx_process_stop_seq() so each reset refills the array from the
    start.
  - The qla4_83xx_reset_seq_checksum_test() "if (~sum)" test is always
    true, but that is pre-existing logic this series does not modify;
    correcting it needs the template's intended checksum value, which is
    not in the source, so it is left out of scope.

v2: https://lore.kernel.org/r/20261011040257.2017421-1-yhlee@isslab.korea.ac.kr
v1: https://lore.kernel.org/r/20261010181139.1911817-1-yhlee@isslab.korea.ac.kr

Yehyeong Lee (2):
  scsi: qla4xxx: bound the ISP83xx reset template to its buffer
  scsi: qla4xxx: advance the reset-sequence array cursor in
    poll_read_list

 drivers/scsi/qla4xxx/ql4_83xx.c | 207 +++++++++++++++++++++++---------
 1 file changed, 148 insertions(+), 59 deletions(-)

-- 
2.43.0

