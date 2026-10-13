Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A6047D929
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791912719; cv=none; b=h7FNzl6hi0hGX9QADkFxPEkwf8ckRBaD7nPMgihF99z2ydjbO+3SUvCavih/iyXK60W+DyqHoO8yawhOvgn93GOLnErNj5qKNHsIGmxN9eKpMGD/8JpusR0D8z3Zx/hLgLwTTVNfdEVj/w4W1pex91qdL9To+tzUQ/HJ1RsJnkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791912719; c=relaxed/simple;
	bh=UyzJg1CGrCT6l9BIn9xt70V+4ZaVLdHp7djXGtqNNi0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LCS393OMdcA2S2wbbplsZPHerAXh+zEVFDDKxQ6EB2+Y+w7f/CoxwjDao6QFaWWy91Q4Ev6Q0pGytjbDETnDyQA6LhaKm0aCMNvDiNxU/nR8NjEKI2yQuzDrhbPfYOG9l5/1/jinBZk0nNNXAyG+X47/o7tpRcEbovQNT6vz4uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=EljJEzoC; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="EljJEzoC"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3a706146559so1963516a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791912713; x=1792517513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VlswUne+avJ8bwCltZgy3YunaA6SJPVFCYyJDSRlVeQ=;
        b=EljJEzoCt96nWwC89w0iF8i7ACQQ+eGmbtAb00YZNq+44PtVj6C6fB0Z0ozedi3VWc
         1dUxuwrFu4ztzD/d/cLZIYCfZBlvkFOqAjqbUwux+b4wh2XrWXGcMMMN9s8kDsPOTrNw
         Y6hsTm5bwPELlwdm8UItaWzyr3zAXKns0YDcLCl8u6GVFuyIxEyVF4brshQk6yvrTo/D
         K1lvCGnazOETlYPmA2XeVWOndaS6u2PVpw4c/R9kGPzg7ibFTDrru+ApdlRYB6TaU15a
         7dQnqXbe1yrXTEt4DczX8RP6qimJ4UZubqTyK4nNCBWq36lxADFyHTSUaKYSoDlZesh/
         bnSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791912713; x=1792517513;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VlswUne+avJ8bwCltZgy3YunaA6SJPVFCYyJDSRlVeQ=;
        b=CxRJzD4+WRUdZxk5Vb37fGqvN6UXEmTmmuHpywHICM8WmHvT0rbRtZaboFcKG3U62a
         RlCQJHNaXUQpAfhEjbun8JZIh3DRGr563f11HCvCnbRtjrHIBnT41Z7ql3+EUNUn4vWr
         GMDo3WlelFrn6fVej3aIWcVqeDbw/aSUFijM0vkY3FgPzefYbHyu+dUPGVPnBuFZBNhy
         F6r5UpNqRLgRTD/h5HMCThEvL1AesGCpXjDq5Jx8gh2y5QSYVwhZGu2DMiw+UMlh7Lhk
         v3QWfL4beQwlZW1hxxmDmgs3eo626AYJ0nBNE97K3CqpWOCNFBoZmSwbcpdmE/i4Gm4j
         v8ng==
X-Gm-Message-State: AFq9FYKY2999uroXIGWG3yxAFgalpNPHnA+qTqZ/8U06bgdeixpOSdf4
	LzhYvuQ+qbCWdPOt6XloiACP/6T2Q5WKN2Mvga3b5PQcXdmRmwyW/qTU8EUMJuE0PoskGM9oAdF
	R+joF
X-Gm-Gg: AYBFou3R6Z75hEJ+e2U6vv3Q+bw2aknzf6U2h8T6CI345mgckYGlTRY12rLOyLcGALm
	7VSTar/4t2iZSBt/UWygYQDPXYW4TfVFKi7maZTMDq5nqDSY8IL+xvoplz5L6g21UnRWucY9hWA
	fujIdHp34QuBgD2EIHBNlgiibx08L1GdNecKjuLAC2l3gd4vikcsNXRZzlMd3Bi/C8nDYQ0IH5P
	4xODA+0y4EuqUUhiCTtilmUTRtPm0Yug7K4S35ztJ+cMtHO0EtWA8zgyV0LUDA1eSNQ61/k4PO1
	h1y39XZ2jgZqLTg1kzhos2LIZgyZ/L8KY7l/aAUlTb/4+hksdYD9ee0dpGa1MATikI1SSQjlNpU
	K7782/ek9B3ckHlDPwKueu8YmVZI52bNofuBE5H3TfOpDKKXQYVttc6m9JjthVTs4wrBDLVNemj
	jA7uhd9NXKjAhol4JfYt/+rYYiDiM+IvoHUWvMSrUJ2Biv3UBhr7eWBOkxP/sinKz3mhf3csuXC
	lEtGCD9GSi0rwf2SBUk
X-Received: by 2002:a17:90b:5830:b0:39e:6c68:c787 with SMTP id 98e67ed59e1d1-3ab3acea00dmr11915708a91.61.1791912713219;
        Tue, 13 Oct 2026 10:31:53 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac6019ca59sm607396a91.9.2026.10.13.10.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 10:31:52 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 0/2] scsi: mvumi: bound two firmware-supplied lengths
Date: Wed, 14 Oct 2026 02:31:43 +0900
Message-ID: <20261013173145.3412863-1-yhlee@isslab.korea.ac.kr>
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

v2: read the handshake frame_length once into a local and use it for both
    the bound check and the checksum, so an untrusted device cannot change
    it between the two (addresses the double-fetch noted in review);
    1/2 unchanged.

Yehyeong Lee (2):
  scsi: mvumi: bound the per-event parameter and sense dumps
  scsi: mvumi: reject an out-of-range handshake frame length

 drivers/scsi/mvumi.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0

