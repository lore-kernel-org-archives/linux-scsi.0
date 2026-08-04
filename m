Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1744A4252BE
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 04:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816365; cv=none; b=lQUGlhIlSdbWU97qJS1JTdaLa5Mrx6npPqxfC5uX4+2gvlWd5dPYlFYjpx8yhtVx475BHNbm/I5e/Y1tV6Upj8FQsaxwe/tcbO27IuwEkUYNL/kyDP2HSDdWxJaetNG5pLn/IIMx/34LPnRzvgcVJc+q0/8MeUGczAxpegdmxOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816365; c=relaxed/simple;
	bh=C/t+MNPkgIeqigfQL1VMUIFlW20W0dhjFFTJArsSgVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eb7yQpUhz8GEzCyRIw2Fh9dDECdf7V4Wn/K6hzY4QeevR6XoLDwuaClZ9bKUflmCMyIxlSSpb2co0NvCdQ4YeyeNiqixMw+PjRiDesYarBTjp+wEszxQbRmSqSa4NMv4ceHB4u23uPH4+8uUvJuc1cIhI0zmJR0uWS05zju61is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=0di/cOe4; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="0di/cOe4"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cf27856f9cso41268435ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2026 21:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785816362; x=1786421162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=z/0c7SzZ4UnapvEswuZB9Xo99f46VsnKuWKwL1MGsJs=;
        b=0di/cOe4aiEbQSMsuE9jyPsG/BU9FZ9ZTlyznMVJSoy2JUeoVBro4cmEg7dlKiHYh1
         tX+l0pA79VLXz5z/K9N+bmJFuzEKJOC6c2O90BpKdsn5LxIQCZc+cemKVYhJUyx+icKw
         qsD1YLHfssBF/r04uMj3HmweECxhFnTOaYVd5Qi/vEisSkWhx3ccymA+Vw9Nfg8fpv1T
         K+LLgJ+FQMxD/QehZYTBO2f4SqTZNAv4TUdlAUC/7hpvcKbFxmlxT2IpAX4/LV97sb3O
         XUGuaaMmJ3cd2olRQfXPLsdCVPvOgo6gBYXcyaCDh5PmpPK3cumrBKrbFatZIDo/AbB4
         bE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785816362; x=1786421162;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z/0c7SzZ4UnapvEswuZB9Xo99f46VsnKuWKwL1MGsJs=;
        b=om96tErynnFBgQ2+K3vKEkQbRpNMJzi8eQFgH5rgcGaVPJ+jYG5KL4LvSzstB+Cpc6
         zSIluHNFfFGZ5nYF/KiPY0QYazthhtvPudb8FQ5S7EHHx7MEsw4seWUa548Nj1KZRCrI
         leIGw5E43SK1ZilQwqWS1+zkyl6x7n0kMdFnXGt7vf59eQDfrEva1PwxQZig4qMVYsU9
         qRejjywslSj1WGhg1hMqeGw9VanMowF+3szB2XfImCW6cMeSAPYxMV+lOEXq6yKs3l65
         eUm827YLtbGxkuOiQ0yPjEP2V25Nd7chZ9/NewJHGDIgFiU7hjOaJlvk8fOvbUHUnx7I
         ucvA==
X-Forwarded-Encrypted: i=1; AHgh+RqZmAllhc8Vu45kRyis+o5iqd6M5k7WCRNBpqX/Pji2QE0263WOpgRbgbnQSKt/D957BvInK0K1W2v+@vger.kernel.org
X-Gm-Message-State: AOJu0Yzkc0vG6gQiXq2TA8FYPKRd5qU2G14Lnj2Vws8tTQDGdayPhc4J
	FGrrpCC9psAQhZAMdFl6hzQXiHuOrW3PZNXstdu4cHFmK3g1Gm7tzSENMV4OP15Fi/fFNtTFU1X
	/V09u28s=
X-Gm-Gg: AR+sD10IPHkCdUY1o7Gw5M0cKcdPyxxQh/gmPlY4HhsAfwcGrajN3o5wGc/EzTyapjn
	ybCu5bNYwwvomV84Bgh7W/3dlZD9TlJadtzx9syVtobWY46NZstfVIwuSw1inoUGbAQuaaQbLhw
	fBsLxLpx9XdzDS3tNy3a8K90GPedc3SW5t/xq45781cWMloq0+/qCJIgo+eqxEpxuFJAbub+axA
	rG76OojyIMyaqzBr3Rc8rae90wEf9e0afIrUuB8JnNXW5HhZKg+mvjxRv1rpjNLt/rLFkJsI/lB
	9DpOpJB//goCwf91pKSyrVR+aVHkkHGa98GWqV09gHgthnirc+jp1hCubho4amrcIQz41+nygBw
	B2IJ3NSfy+dZwctme3GxAL2bvPbMXF7E42vOAVTyoyr2xtUYMB20bEJYWLFW0HeL9FyyftjrW4z
	VV42Q+vjsDAn3bJmj6Bfc5jbS1rmwaDbO2UCS9qfHsi/z/Q8UdYIrTAbtyS9lqZIc8GYzL
X-Received: by 2002:a17:902:f54f:b0:2c9:fbde:ab66 with SMTP id d9443c01a7336-2d052490e46mr116264085ad.37.1785816362050;
        Mon, 03 Aug 2026 21:06:02 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b11f9a9sm46075465ad.57.2026.08.03.21.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:06:01 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v2 0/3] scsi: libiscsi: validate task lookups driven by target-supplied ITTs
Date: Tue,  4 Aug 2026 13:05:43 +0900
Message-ID: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1 was a single patch for the Reject path. The Sashiko review of it
pointed at two more places where a target-supplied ITT reaches a task
without being checked, and both are now in the series.

1/3 bounds the index from below. A transport that implements
parse_pdu_itt can produce a negative one; be2iscsi does, and forwards an
unsolicited NOP-In from the hardware with the target's ITT intact. I
have no be2iscsi hardware, so this one is argued from source.

2/3 is v1 unchanged: the ITT reflected in a Reject PDU.

3/3 is the same defect at the lookup that five management responses
share. An unsolicited NOP-In naming an unused index dereferences a NULL
task->conn; a Text Response with the same ITT crashes a little later in
iscsi_complete_task().

Measured on 7.2-rc5 with KASAN over a proxy that injects one PDU. Five
attack shapes oops or warn unpatched and none of them do with the
series. Normal I/O, an abort TMF, a rejected NOP-Out ping, a userspace
nop sent over netlink and an iscsid-driven session are unchanged.

v1: 20260803104149.2114414-1-yhlee@isslab.korea.ac.kr

Yehyeong Lee (3):
  scsi: libiscsi: reject a negative task index from parse_pdu_itt
  scsi: libiscsi: validate the ITT reflected in a Reject PDU
  scsi: libiscsi: validate the task named by a management response

 drivers/scsi/libiscsi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
2.43.0

