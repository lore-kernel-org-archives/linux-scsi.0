Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA4F78C9C;
	Fri,  8 Aug 2025 20:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754686660; cv=none; b=nXpwPGddM1x3Gxjt10O9ioBe26ZeGaVJk2/FVLZ1UNbrTlrONVZC5fQn2ATdB1LenRaT0KJo0P30hXVoK9mjBs2aAgvKZKEAVQ3+XsLSm4Xp+QBTFwQfrKDxee9G1Uvo3kFXhdJZF8XgrgUssXoiRyYlWfz6tfzi9721ZWENOXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754686660; c=relaxed/simple;
	bh=zWFcntFwBHNkCuNfXYsLceA5vZhsbuHavdLAvg28tc8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VEeCuXQjJ/ao+I5sw3F83tVUMdLlp6x0+1hvHPhJE8QhgQSmgGQc6p83ypQZpOpac8hc6ihlswW1iOWrunAw9ZYrb4CN4YtYDHpDU2GilcsSIyrWDR3hiyUobsZoKCbKk2ngM6ydOMmQATLHNF6aY4ZhnZt9OxFNsDKDQ1zZ4d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JFySPWuc; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JFySPWuc"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b4233f86067so1640814a12.0;
        Fri, 08 Aug 2025 13:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754686658; x=1755291458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dP3sz71bjrozNYimMztSuHPCg7Ua1DsmgmApUBbMrQY=;
        b=JFySPWucTkqusM8EyHahWp1wpC7ExpztKw9Znv6ijqBtoxqncDAPIUckOqzd4bjrAH
         7K8BoWm8LFWizu135/9dWJK1NWQbK55HzaDGj3LZOAysUDBpHTq5pjLKKh2ejUYwyLG8
         UIb1N+5PJHXEwhgORCasJK0hxc2yi5U2WtHHTJj0mLj5Ga+uqaeeOlmzscm9SIVjazN2
         xd8UoVlIAeJzAhapkGQJWVYamZoJQVHFiG1vek/7bgcPA+G6aNhsH1Rb8QMdZAA0M67I
         NTPwjXtEKVkR9qSVpURaaCQwudUj1P0g3WK6vmNgEa60NFcDRBoU0a2xU0tofIXgQ1aa
         qmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754686658; x=1755291458;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dP3sz71bjrozNYimMztSuHPCg7Ua1DsmgmApUBbMrQY=;
        b=a5Ps0+m2BpWRRwbR6+SU2VIC0niyb40IRX+oHZ13eInrGnVEj5QEWsMEIDsvX2k0ou
         gWiELB+Hwqx7r1X+QdfnI2s5ie6TD+24zmoMARBj5vuWrzKBbeY59FKQ/2fr2DFChoth
         YbDCOF5KrxcGCWnNE8PtyjF7UTyj6kowGCAmf80HG6AlGGu4HI/POXv71yux1E0i5qzy
         217ix3BBDTaRx1eNXmcJJYZ2NUFLRPC4v0WdKoXQzQmyJCgqvCj6ApVnzHvo1823HoAR
         KlWyiBJ4qfoolrVNAUKpfVeTpRUVHK2IHD3laUVX0RC7Hg2B3zX/ICROczhS3GqLH2oD
         st6g==
X-Forwarded-Encrypted: i=1; AJvYcCWKkjmv3k9hwbSi3jfx5cLISR5AhxMAFV+LFIS5DUkEPUA6hYBNvybsPF33fNbDRscXo0Zi1S7gF296tg==@vger.kernel.org, AJvYcCXk/cqYHMM4o4kyPbtTYRzDrMW6hEhRUIxAneIGPVWEMZcBUVCaMYzyHXZWAaYOwA2ex1q0NMIbvFMoHhs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr1xfzefz2MWAP8O9NqVjCArxVnRRC9q0l/Vnw8H2V83ji/Q7z
	heQcdJOI8qDhI199ivfghjYbY+nMqsjyJzPkvrqndoDqpzCJUI8b4KuP
X-Gm-Gg: ASbGnctTic8YzqgiEZhvJOVYa3qOkp8MTpHVBZfkIvmJg/aHqDMiRE0LaexRfciJCg5
	Qj9u40oWAZJvxPR6Ta0ER/5QUf2J+K31ry6BF5dnxPit9+0qwBFRedFBDPinQbuWVkM8DP8Bw2T
	oPiNhBc2ruRCKUZfEtFPuACtHdvShyMmB2tzr2fZcIBpqNvNoWzF8gKQiQ3Saq0xlydcxWoOag/
	3EmeFLRFj+0MIFqFnDn5NTarEE8CK6Wunm/qkdEr4mBhvoS5JPrDWRu9WHhxR4IKGPooph9TJ0a
	vwnWFfOIbj90YoSSY2VuiiCfEOZxDPT8seigzcLEdLll548zUXIhVbbp0sOyuczhc5cPmL8hV3u
	fPseUNOOfQhXPfiKxFkW9JY6z26HlxgeS
X-Google-Smtp-Source: AGHT+IGceS0djDb24jWNDuXSuY0xaoYXkG7gJKm0UCKaFrYq5Pg2JD6F5CeMI2naY+Sn/6wiy2um1A==
X-Received: by 2002:a17:902:ebc5:b0:215:6c5f:d142 with SMTP id d9443c01a7336-242c2df8073mr62409615ad.20.1754686657787;
        Fri, 08 Aug 2025 13:57:37 -0700 (PDT)
Received: from avinash ([2406:8800:9014:d938:f647:9d6a:9509:bc41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e89768a7sm216840965ad.83.2025.08.08.13.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 13:57:37 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v5 0/2] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Sat,  9 Aug 2025 02:28:17 +0530
Message-ID: <20250808205819.29517-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This v5 series follows up on v4 of the "scsi: sd: Fix build warning in sd_revalidate_disk()"
patch. In v4 and earlier, the change was sent as a single patch.

As @Bart mentioned about changing the return type of function `sd_revalidate_disk()`

Based on the review/feedback, the change has now been split into two logically
independent patches:

  1. Change sd_revalidate_disk() return type to void.
  2. Fix build warning in sd_revalidate_disk()

The return type change removes unused and potentially misleading return
codes, since none of the callers care about the returned value.

The stack usage fix prevents large structures from being allocated on the
stack, improving safety and avoiding potential kernel stack overflows.

Changes since v4:
  - Split the original single patch into two patches.
  - Started a new email thread (not a reply) as suggested.

Link to v4:
https://lore.kernel.org/all/411260ff-d5c7-4f82-8c47-e66e4828c2b1@acm.org/



Abinash Singh (2):
  scsi: sd: make sd_revalidate_disk() return void
  scsi: sd: Fix build warning in sd_revalidate_disk()

 drivers/scsi/sd.c | 54 +++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

-- 
2.50.1

