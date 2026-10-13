Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D7E3C13EE
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 14:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791900155; cv=none; b=Quqtmob8kJ+vljP9jk8O38vNrbTEFshbEIj9Xqgz2HRlUbHePlqZgD2K3StAwoIr9eQ8myGOmBUjtXY1iq7hxTGO2abeMUEThooWbrvSy/IsicuBjDzjdsXaPtUR+AM6odtr9gonF2e8aBID4mI7swwckfbSZgKIh4C9ayP+JOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791900155; c=relaxed/simple;
	bh=Tawb0P4WHQbChCm0POAm0vP/OT0i3bQuplGTDM9ziFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B7V2tbfscKSx73STiasd7UGQXQcDxJRl5tsOlXRQiXymp02KCij3aH23XgRWMCjzMMzR7JKCkDy4xgEyUhrQ15KcUerD875JKwgTQAQGthT7YuvXJACiCz7QUWS4IVdE8VZjCa6gvZODtvrLvQfv4woA1HFh+podgeeYVNAVfrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=0wacYjbs; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="0wacYjbs"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e8b20a899fso10878845ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 07:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791900152; x=1792504952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gpvwGadULPDGCwDez0VhWNS62rM8BYPtekPhIicjGOU=;
        b=0wacYjbslPFBJHaRaCfeH3+kGmnMbBD+0IrKW+MwkiZz50vz+AZN43toDt7RdsEBMK
         RSnkfpVfGYRnBxfodvjknMclg+yeYQYwtHaz82FEUgZw9getGYePqMIJOSD+dUCCtqUu
         rDgX6HeaPyYr+ZH+fhpEa/4y7t1U8OfJFlchcpSnoLcXeIguXdtVjjJpLXdlTjY3as+6
         0aL9KBQ5nsbazSH7MZ25NeG3VRp+0ayFUVVWL5YQdSHIxLicBj/RuTEmJW84Es8Giftr
         q3grA9SL8+QEjS7qthbX4U7eDMor1PTNT9T4n4E4Q4GolQ0t68+4i+T3o7lwYc7NfuTJ
         EHlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791900152; x=1792504952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gpvwGadULPDGCwDez0VhWNS62rM8BYPtekPhIicjGOU=;
        b=dB8c1mzTWnIqomR5oUWtz8e3rcROd5fZ58iffgA0XU+ZWtBbz1KPu/xVpAAxXTwtUC
         lztcswQEgnKCRJriSJB4OLZvoWPYLnTx+ILZLWDSB5SinGSJzX/fzNahfv3NybQ8LOYJ
         zCVxD5HfLDRQtaKzWFkmg2sbg/EocobnYpybvGhhkerwDhKmVBs+XN/Ba2zrn7YCqoEz
         QAnUhWxJdVvlElfjYslIFfWt5oYv2YzdPuTPXkP8wuYhrY5BJE6rgL0KX1IO1aerp5AV
         Wa6mv4HNL9p94dwFBt5JXbTbaUOqtRvCMAmY/gC2JAQ73cCyCMEIaMdHHvcEUf5/m4uj
         CghQ==
X-Gm-Message-State: AFq9FYLieAakCjAwfHEu374X21FBDPaMM7yRXAPlB2yhZhH4/oGP1xzG
	fGr+iQg6NBKnTjr50/XoBNd+SN+awgRi0HQOcN9S2TDCjNXLjseWy0GKX+giUODyU8g=
X-Gm-Gg: AYBFou1P/Ej4C7iL+6VPsW5D0Rj2tdlaBREjv3lzbgpcc35vmXilnAkQerp3GI2LbaU
	s79ppN4OvHn9Dpm6gdx3w6RtPjRPcfF0O5V2bwTig+tTbdM+gJvsLM7fj7Sbw1WzN2PL8n+ZPG/
	+RlFbEQnnq28DuGekIpe4fOuxSLDpzUhIiYmoY072p4hohILFGqrjSgYT5DW45JCRv28Cu8R2Ne
	tIW0EK57mhtN8YEPLk540m19srJ+KQvokdENADLwmPQfNzlPwC2Qom3svAJ948Kn2p37E0hdSre
	LJR8bFmPEvR6aX79wWXzqOPpsxzbImHfLKnecU2APtNyzgBYa/eku0dQ/JKMmH6JVuaJvvtfyxH
	d+6u2Mu2q/eiwQm8f2BQgaczyikD9yr0XaP7Kdo30rbmgowGUKgORfuJGETy9Mjq6DBI1UXO5rL
	4wPAoQRAddbt2+5Lo2srYNxZ5uGW1rKrkG7YzCFyGaApRhCaoZ+TIPoTHQRu6KFFGaf522+SsoU
	/1qB0f3JslhNMw7VVBi
X-Received: by 2002:a17:902:f54f:b0:2dd:c100:b2c3 with SMTP id d9443c01a7336-2e842ce0ad9mr102000625ad.46.1791900151506;
        Tue, 13 Oct 2026 07:02:31 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e841a02f85sm56433065ad.10.2026.10.13.07.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 07:02:27 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH 0/2] scsi: aacraid: bound adapter-declared sense lengths
Date: Tue, 13 Oct 2026 23:02:12 +0900
Message-ID: <20261013140214.3156938-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two spots in aacraid size a sense-data copy by the destination buffer
(SCSI_SENSE_BUFFERSIZE) rather than the source array, so an adapter that
over-reports its sense length makes the copy read past the source and
hand the trailing bytes -- the previous request's scatter-gather list
in the shared FIB area -- to user space.  Bound each copy at the source
array size, as the container sense paths already do.

The two sites have different origins (one is as old as the driver, the
other came with the native HBA path), so they are split for independent
backporting.

Yehyeong Lee (2):
  scsi: aacraid: bound the SRB sense data copy to the source buffer
  scsi: aacraid: bound the HBA sense response copy to the source buffer

 drivers/scsi/aacraid/aachba.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0

