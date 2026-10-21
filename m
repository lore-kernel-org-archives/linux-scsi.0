Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792588506;
	b=yQeQeMzks9uR8Wi3zuZ8Je655xUIEwIobHZY5dv4y55+mXzwZkVJFHzaM2NGik0tTvcX
	 NRo5JdyR+akZL3g9BBIryhvW6DidSZSS8BdTUhfeQ/tGi1DzbLEkX7pvihFkV58nA2cLI
	 vCnCfmJg4VxwTylgc5awxpPcUncgiYZNjZ4GDsum+D1QiPUIpjBlW5P8BTPtUsTKkVAM/
	 tCnnsLZFIK08CiUGHjbiT1ndz8JxNbd+cdwMsiQFHlwr9x0vWRWSWTWTvdMtDevVCzH4C
	 j8q9InwbvimH/D00jeSSHF1+kTKcJwrLRhY1tt7Xvc6JZuUcMgFPnBzdY7v26Ljd3Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588506;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MqUHtb91EGdlurTZlXxP4P7Tr3AqGBBA+lpnZnmX+hs=;
	b=EAsmxlJqMHD5VQtHdkAhLPVZIc8vdb4NC1C8PT6fAJqJlvOY1aU7gyemIWpxseKqwbIg
	 f7pj51rKj1fBYc1UfPBrtilGTuPOwptQFyFn3/AG7b1eE/vrYDVcO+Jprof4NU2bReQDY
	 4adSLibVB49MneTIv9XrccEAENrch9IgrWN9IpKaUdweo9FWW2Gm/oTC7T+ijIHUpti9X
	 LN8M3pFlZKNgbvGAardVY1mjQNqrGr/KYE3KUFCzhQYkLkedU49/qwzi2G1Vrw2RUt2Rq
	 y+BsfTviItZ1sdkIT3mOc4gYQg6hKHbN1rmd2TYojlLpzXGvkqrLK4gvfyUMC95/t1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=ZoiAG+th;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BD3606A31D
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 13:15:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41BD3606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=ZoiAG+th
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a052aff9e9so421735b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 06:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792588504; x=1793193304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MqUHtb91EGdlurTZlXxP4P7Tr3AqGBBA+lpnZnmX+hs=;
        b=ZoiAG+thjNuSCBxrm+Ztvoo5TwArUAkM5ICO1111dsWB6kgWplFSTMFHvjWPiH+drZ
         IzkFF3YDNMxyRvao4luVZQLYqX3Q6/QVdaBtFr5dl2jSFKi3qvk0XQ6eKmjB71lpbZvh
         4Y5OSh4lIywV0y4Nrh8pvDSWGJikYk2zNcdUtMIigFXOW5V0lbSTHsjZB4v7ILyFyHMw
         T+YHxyXT/7f8V6j8HHAP2RCCq43wMZAYvDu85hIFM8NvC5ESIyX1+2cyQ5c+4lrzDb5F
         oAgn79hiRhvyec3FjwE5HAlHhgCy3Te4pPNWtdQK2BBlWq2xHCakOg3k83kUln14Xk2Y
         9Yjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792588504; x=1793193304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MqUHtb91EGdlurTZlXxP4P7Tr3AqGBBA+lpnZnmX+hs=;
        b=uQ5nmScTrDe2rcunI4NegOyHU3ww934SFoICWWrz4AFGAz3ZVJIyXNMh9CJjUuOl3y
         EtIR7JKBBU+yn3EDxx9xzll8+mEDpDDrXKDQN3hMslIlgLG35en2WTiJX0AiEK8YRNi2
         VN5rD4Rnl/VY3nADaTixWC/dwCkf0hstZ79oOC7VgYueGs2lH2zVDrxsq19vAK2MteGN
         s3Q+QMoR3ArL31vbdenPZX/3sdH86L75cD7SCQm8fFUQMaMpbKA2PMDILQ/W23a1KVay
         zZLoLZZudrkpNV+7KS1q2pfgGs++kGMAWN7kU9rl4Iqx0J/gAAeBGiRV2TYJ7iDNKsUT
         hJUQ==
X-Forwarded-Encrypted: i=1; AKwUvBxnjHpuixBj7haA/5BlmGH2mqBt36LMFOVn4hneA4cN0+/WcvMuI4JVtphxltna2kG0GpcpGDIwHGkp@vger.kernel.org
X-Gm-Message-State: AFq9FYJCC6ty30FUfXxBxt4tYmm91UJrt8kFvtMaOSHBVzaVp59qe5al
	ZTZ+KCtPezrlRW10B8M2znprgECZr0HkndkBIAVo0lTW6ptVH7SySwjDFhXPJOcEkvQ=
X-Gm-Gg: AYBFou2jvBkzHHQw4CbAsm6S2GLDZ/ylcigcEZ3z3BUzz1mdRk9c24VtVEYCSHXr9z+
	5G+fawLAz5akz4DcbV3DoSVbs5o/ho+MYKkivV7ASM3exLBFIsmMavs0YqnEOfXyfJnkFRrCj6X
	YKlm1dclqpprF7FC+H23u53RI5nZ4XEBP+BxwNk1y5FUJQ4PSA+C9pD9wIUBwF+3hLxO9ZtLunb
	LWv5qyhh5vzwfON9SLFE+sxZ12OtvbWgN1+gbyaPyPKIezJugWfcJql0cVkOLF4SRGaZgFnywSL
	9L8egNSX1fC0265zRgq9p6NBJ4fZ1dUGYjNWIOe76s/9+knnUzukxD+Tl1Ah2LJF7zIioDwKsC0
	U6Dhhgy1dDT/4lBYyhvESWAvFgu9bjXKwU4BV8w0Z36L+3NaWDGuFCvPsSYLsAYYASGT3hWwmMT
	UlnkaqOGkvKXlzCWqYYlLytvAi89qWbjl0nWO7wKNqbDx7ZQOvK96bpn0HeqPUFM/dZ/jkj9geK
	ApBnolQp6Di3aKbvdtFZZ0+Z6mgn6x4LlUd9N202WdDs4V9iCPi1g4qIqj+cPj9+CTXRTJsl/JE
	6Q==
X-Received: by 2002:a05:6a00:22c5:b0:878:34d7:6a24 with SMTP id d2e1a72fcca58-8a089dfdc7emr1689491b3a.38.1792588504540;
        Wed, 21 Oct 2026 06:15:04 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e416:85ef:f22:6c5d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895e273bsm889414b3a.41.2026.10.21.06.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 06:15:03 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: James Smart <jsmart2021@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	Mike Christie <michael.christie@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH] scsi: elx: efct: hold a node reference across asynchronous session setup
Date: Wed, 21 Oct 2026 22:14:48 +0900
Message-ID: <20261021131448.2692313-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021022209.2580332-1-yhlee@isslab.korea.ac.kr>
References: <20261021022209.2580332-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the review. The concern is right, so I have sent a v2 rather
than argue it.

v1 gated the setup work on node->nport and node->req_free, but that is
not enough. req_free is only set in __efc_node_shutdown(), which the node
reaches after efct_scsi_del_initiator() has already run and returned, so
a node sitting in __efc_d_wait_del_node still passes the test. On that
path the setup work can register a session that nothing ever removes, and
in the narrow window where efct_session_cb() has published node->tgt_node
it can store a lookup entry after efct_scsi_del_initiator() erased it,
leaving a freed pointer in efct->lookup.

v2 drops that predicate and gives the node an explicit target-session
state, read and written under efc->lock, so efct_scsi_del_initiator() and
the setup work agree on who owns the session. I have posted it as a v2 at
https://lore.kernel.org/r/20261021130802.2691833-1-yhlee@isslab.korea.ac.kr
