Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C7A516175
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 16:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791908191; cv=none; b=mjjoY8IV791om5k3e65nPh35Q1Fy9Xy3o0BUza2r1VBO7G047z5pgnWqBMrwdE4+Tgaiiq68XnY1L6Q+iE/mMiNh7u63P8smZwZYW6H5MNCWusD282xF1n1tbhnYnl6vGW5W2ZYhoZcwByGmXDImTYi3ATZA9JA8cvhtU+Uh/ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791908191; c=relaxed/simple;
	bh=FM29EhJVqrYLAqj2i7juSb1dg63c9N3PNf0p5C6RR1g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=odYxVt71qZf9tySueqqbcLDa4LCP6HbIcVKSUojXj1VtBBUB0uc2EbH2mA8dKWXTeFe3LRlDFgHpX00vKZ7qNiSK1zVgJobbhz8glFqqbGvn/waRHON028Rv30qE4lhbQq8Ttf7oX0l8dSaXS9ZH5EC1gkYJfVixRrwjzJljLQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=FQcp3SLr; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="FQcp3SLr"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3a4b3ac8fb7so1424031a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 09:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791908189; x=1792512989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KgL+W3U7o5OU8BRm9L4xOZKWqaV/qLRw6ZW40Aj7xuM=;
        b=FQcp3SLrSY5NEqzb3tgngcXIBi00SIlpeXyjWSj7kXUSSeHj5izzS0Uzjhvgp6zdq1
         9O22olE6fuC9LHX+9Ka/jimBlxlbeu47WnXOThqbWqs8hdgsCKvH0geRj2nxiAWWPohq
         WnUHJaWykLKO5ICAOJihW9KmYnbS7cO5s7Hkst5wSFXUjnorb3E4p6FHS5DDo8boz/wO
         LZRFRyjXL1deWzGpGlLExLevVVzMIBT/vaJ7QwbQmo6JcnRw/WpRy9nklADyspVLWnIP
         PiyySg4iDErDjTh5SFZws7OoCD8Hq+x1XSnHAIrWFj2l71tRXCfFsnlvZtwBvI22wI9Q
         iA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908189; x=1792512989;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KgL+W3U7o5OU8BRm9L4xOZKWqaV/qLRw6ZW40Aj7xuM=;
        b=EOxCTeqd9puV32BmTIXHjX5yfH2CLz3mT55yHSNfNK6zTC0WNU3XBgz/l0qoksEwlp
         eCARHuU1dVdQyYoKImXZgcANgMf6LJmvrNzl72ZDiX/LmQBFjwPqHe7vjIdCPAvN1a3Z
         Q6c6v5jrGnuziVCZZ9qck1ZYlVE2RFGRQw2wdOU23vDYhh2I27H1Ry7cX5Ht7i+Ci+02
         voZ7NV/siqSTQydRduOoGcUUPlGqi4HI7S5HHCS+pJD7JRxU2UOR4wD+t5bXHq05dlws
         gP/E04lX9/enSKoEImGEyGhjg4e4owdAcDMsE8jCwZQfv+qAca9rFdffNRa4DLBpgfp5
         l+dw==
X-Gm-Message-State: AFq9FYIUCJLI5nqXq3W2fdpZL8iqFDo5KF0pz+qlB/xU2fyqM8+iRHrZ
	fTOfh9uyhc45SAb2pss207Ww9YIGSfONDaXhhIiRXfXVi0/+pDiCoBRPVoIsyreDuU0=
X-Gm-Gg: AYBFou1z3TrjW31qrLtsH5bQTvTB/5s5ZmeewW8spIRmXGhBkJ+qguVDbV8hY59VB62
	kl743S2S1uhTSmuA7d+7YIjJnAwAsiKlpS9WPF1wUcRj/DiVTea+UOw/dhmMHvqFybby0ZXvmsO
	FvoQcHAWHsz4+E+J/IjE+CLiBNFzA+8LhQYzDCACOrLKN1ednR1HoJ0QB14uP//UlGr36Ur/4SR
	eW5+y7ElJ/1z40jI0Q0i1lTcTaa/VMjPESq/ML08C/J4d7FhI+tOVsojDT/Qpmti/OUJTzZqGDZ
	L6LA97hawKxRd/vFDZhVayKzqqC5uQvEwsK4fM9lyJ+2y3qP98/J0zIG2PEPuw2jFCE5DMCOMb9
	VKC8tX8gXHVjB7xkhEdLkcwTJQ96PDX1B8UWjqi/kG8tgzMtXjfQBFzZacGsAVoOlctwi6D/FKQ
	mwIUjM92PDlBNM6n4Dt7fGMwmzbAD01HnJh/0qdUQF8VLu8flQK/RKJAJCdcHSZ8yOtBdE6Lsp3
	sVWJFQ8TV1lFcVSWeDQ
X-Received: by 2002:a17:90b:1d03:b0:3a0:9640:8028 with SMTP id 98e67ed59e1d1-3ab3a8db035mr10114932a91.59.1791908188836;
        Tue, 13 Oct 2026 09:16:28 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac600642c5sm202607a91.5.2026.10.13.09.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 09:16:28 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH 0/2] scsi: mvumi: bound two firmware-supplied lengths
Date: Wed, 14 Oct 2026 01:16:18 +0900
Message-ID: <20261013161620.3210533-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two places in mvumi trust length/count fields the Marvell UMI firmware
supplies and never check them against the buffers they index.  An event
with the maximum param_count/sense_data_length makes mvumi_show_event()
read past the 512-byte event buffer and into the log; a handshake page
with frame_length >= 256 makes the checksum loop, which uses an unsigned
char counter, spin forever during probe (shorter over-long values read
past the page).  Both date to the driver's introduction.

Yehyeong Lee (2):
  scsi: mvumi: bound the per-event parameter and sense dumps
  scsi: mvumi: reject an out-of-range handshake frame length

 drivers/scsi/mvumi.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0

