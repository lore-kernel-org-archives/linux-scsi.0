Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3BB349CDD
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030091; cv=none; b=HhlAnBpOcslbPfuidmo+Kf3kD/u5/CQgWjiOvT/bprsil3SQYEPDfPzWtABNpFNexaZBdF9qUtU3EVaMlnxFbEcVZ9WAC+b/VuygrPKuzv+034JTGd0pUFJKsSDMaCPBPP9EhXzMx8y4O/p0wH84J0O+0XmelrfQePmM8UxVlcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030091; c=relaxed/simple;
	bh=z8rbKTuCjfVAdfxDy/CGPYi1m0YldO3H97Xnt7VhH3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oF95hv/Z4Ie+PlU+GH0SP3QNeNLaLMGsJZ2Gr6dZ3s0QXSSBqfKSgppWGGnhafXZcAhEoITIq7UwHjjYa1mmCmnZfXqMoKJ9LKOhPhnk+PnOV6ZefZc9Ue9TQPS9vZXd+FT3z8dZpjE5ir9jJIbZkWV7N3oP7Yzmo69QqB3Fpqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=DV2x+zW3; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="DV2x+zW3"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc7e79c1eaaso2139462a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 19:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792030088; x=1792634888; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z8rbKTuCjfVAdfxDy/CGPYi1m0YldO3H97Xnt7VhH3w=;
        b=DV2x+zW3D8GXd0Bt7v2/GZG63Pi9Pp50O1mRA8yyerwG9HYRnJawq5pE6tAjCpJ2UJ
         BFDUz0DuE0JYQYvSIgZViaxVPuK0/o72hoHEwCgU7LuT6Oxyvid8wO6R1yRl4FEEMUb5
         FPG6BmHD4qXO1ojoYilUWrKwB2aMAZvMiQ5U++L3gpr8iyP2UY+y8OVS/uNCiR7FMut+
         u4fjh5b+XslHf4skMf1nIqVPeJuEbo3B59jUngOrUYPSFZIUOyU3cocg0+c5bisBGbjK
         W516/cV0gt26z9tHBdD86BvLwrXy8bhxBKxXhxCCadKyEyekAH22EaD4ocV+/RU4HDs8
         WxQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792030088; x=1792634888;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z8rbKTuCjfVAdfxDy/CGPYi1m0YldO3H97Xnt7VhH3w=;
        b=WiM5e/rETXrd86vbP9yd5wYttGozpAjp+F6u+GOIVvfAZywn9BGVYVABOLgxoIVBlL
         QAx626wSvcDy6JRezyZRD9KbnpQWV+DquO8BOW93lwTJg8z30lBjK+eMsZhPSD6D8hyd
         tfwkfj9K4FevE+n12A2wTn9SRz6gRle3tblfeurPgi82F4jzm19oCsjwA1xTumpmlKAw
         qvbeFCxLmIjzr9JNIS9OOIfe/915OKRR+2C7nPYl/sBsCDVp2Dyo5a3nYOpjl1S8m8Ke
         eOmLJTmG8L5NN/MrC06adbk9hdemDzmxECAr7jexL7ODfKvABoeJcQkHwemtMRUaoZfF
         6z+w==
X-Gm-Message-State: AFq9FYIZ2HboW9iFqGx0unIuAdpIVBg+skc39eywilFMmAb3GhUEDHEV
	/UsIyp7KCv23KWSlvmU2+pog5fEQhe22F5fsohlEz0HJ2Zin2fnTQIVoz9snBui1xLXiMplN6eR
	coorz
X-Gm-Gg: AYBFou30RAwNwrVsOyMBZgFsZ9vS9NakGKIZUKQvJZTurch1sk8/O7v9zWs58r38JPB
	ITZF1qfk8RP/cE5EEPs62YevOJZl7SO0YEtYe569voT8NKf8stKs17rZ8NigFGENwcblDvH1lq3
	gMSbjK9n59S94SzYePzmJSCr04jCersExDFOmDEOpr7mP48jkjNmjjtOKsYOSLancSFCATLnlZt
	vOK9wzmCHeBINPqG2wY62ThKtI6q9ulMNpOULNlbcppiNEQp87yp9l8CP/dBjhY7NEyk9RnmbmJ
	75osdSZVUthLKf4usS0tkdpIzSukNWtSMNijceMfzf8Xi1lpR5P1jT9wcQ6JqixSA2dNtv4hv/Y
	xv7akMTrQgmxYthC7+oKEtzgYQkf4yL+brkw1FD0HfOPzITuYcmpU13Zwe5A+r1x+8/Eskf3ndA
	vt1+1nN+AvCNKywX6inGEmqeEX4E6j1FGDPgC9B/clBhNQ1Jv3w3zNB0LgL85YsTHoXPCqR/Pf1
	BtLZg==
X-Received: by 2002:a17:90a:d2ce:b0:3ac:9925:72ae with SMTP id 98e67ed59e1d1-3ac99259edbmr818954a91.31.1792030088535;
        Wed, 14 Oct 2026 19:08:08 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac947928b4sm1770401a91.11.2026.10.14.19.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:08:08 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v7 6/7] scsi: mvumi: validate the response frame tag before using it
Date: Thu, 15 Oct 2026 11:07:56 +0900
Message-ID: <20261015020757.3913811-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-172082@kernel.org>
References: <sashiko-outbox-172082@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Thanks for the review. None of these are regressions introduced by this
series; I verified each against the base tree.

Endianness (this patch and 5/7): the driver does no device-to-host endian
conversion anywhere -- these fields are plain u16 and are used natively
throughout (e.g. host->max_id = mhba->max_target_id, tag_pool.size =
mhba->max_io). The new checks read the same values the driver already
consumes, so they follow the existing convention rather than change it.
Making the driver big-endian-correct would be a driver-wide __le
conversion, which is a separate change. I'll note that on a big-endian
build the base driver silently accepts a byte-swapped count and scans
phantom targets; patch 5 turns that into an explicit probe failure.

MV9580 / per-completion udelay: the unconditional request_id comparison in
mvumi_receive_ob_list_entry() is pre-existing. This patch only wraps the
reads in READ_ONCE(), fixes the > to >= off-by-one, and localizes the tag;
the comparison itself is unchanged. The new re-check I add in the
completion handler is gated by request_id_enabled, matching the existing
gate in mvumi_check_ob_frame(), so a controller that leaves the flag clear
is unaffected.

dma_rmb(): the validate-then-memcpy ordering is unchanged from the base.
The ownership handshake here is the MMIO copy pointer read with ioread32()
in mvumi_check_ob_list_9143()/_9580(), which already carries the
architecture's read barrier, not the tag. The driver's own comment notes an
entry "may point to [an] entry in [the] outbound list before [the] entry
has valid data", so the tag can itself be stale; ordering the tag read
ahead of the payload read would not help, and a CPU barrier cannot make a
not-yet-DMAed payload arrive. I don't think a dma_rmb() here is correct
without a firmware write-ordering guarantee I can't establish from the
tree.

tombstone tag 0xff vs max_io > 255: correct, and pre-existing --
max_io_support is not bounded and the 0xff sentinel can alias a valid tag.
This series does not introduce it (the re-check reads the dequeued copy
before the sentinel is written), but the defect is real; I'll send a
follow-up that stamps the consumed entry with 0xffff, which is always
outside the u16 tag range, once this series lands.
