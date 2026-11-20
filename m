Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175014;
	b=3rZ8Ezzk4EuXzzoEiux0SgGAnaz3uh9jbeYly3Ffh4HdQ60F+U5tFs/35M4Qxe07cSW0
	 G73IzBejTJvz49dHCDAVMbNrseap47DxZBwlH+TcZ+V6lCpz88aq0vaqCIv1BVIdfHVOI
	 Ixut/5L2CnZ6QrRUR8HyM/UcV+P9xFxksC7njdbX64neN6oYhUQ8y8AdvxxSxEm4F9bFq
	 I5C3X1Z2bcjDH8HTm+7IRAiZx1GxvTLMeLC3ZH+lKi/CTUCV9Jx/LLqrpelMKcjY6+kyM
	 G30vQe/4LjIovl2LHdsDW5lsuAOVqV+aDepbYtY8Fb1WxLldiUMMqNMPrcHISAbFsQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175014;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/7KVf5PnmXgwclJwx+CNk+Pd0XXzEB+lHICPBbjWm9Y=;
	b=hif2eogwFWjvOtOyXkOFYl/jSRh/F8dnp29q/NNPmiY9p3UR22azf2Dodh630L3scobj
	 ppe1Mf4ABJY43KPItPcO/qQgLTHydFy2xccqmai40yE5MWSiUJ2maDE5g5RwggRC68sQa
	 STphzA9cMz+3++7KRy4f/4H1t/LK5CzP9fzpEiarPTIe/jhFp68ux1KVIQkDnNQfmu9Ef
	 taAuuuWS720Mw/AeCsiGWblA0haQHEQagO6scbbbFdy+Pv1XIccKNvX2bZ270Vpgk495U
	 /+gRn8cao88Tqmzlcic77UbwiTpXSq870R8NmmaHQOqh7NvEMOJTQjZxOitxND+/OAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=U5T1S5dB;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2903460A2603
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:43:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2903460A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=U5T1S5dB
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2f02b9c1f6fso4800035ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175013; x=1795779813; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/7KVf5PnmXgwclJwx+CNk+Pd0XXzEB+lHICPBbjWm9Y=;
        b=U5T1S5dBgNcU3cmKk2y/NZqQqUhhacPbWBpgNS2tvJB9d3YN+acrHKPlYvbRJsUdFu
         CajRIZ0rWOJAl4ekZOM7DW9LDuXHS93SMzQ+ohVKjx9LfTJ4fYlZ1KQ4+D4S/IzzcAxs
         mQZ8VoGPUc6hz3II/nfBR/aePyQ0IizsTvcjRtpAODZvbUNplQtYKZk/vIrz1LoaR64q
         m3RrI0iTZ4Dl2a8+MN9TOL1KQZRsYsAwCpIt47VQTOs3AnJCuRgPrSY/nBRNSH56gKuY
         2hTEz3Ks1+8X47j74UjEBXwm4PZLuiu9VByJ5+cM4cVRp9vjHgH/zuvXxK6N9s2J8b1P
         ZluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175013; x=1795779813;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/7KVf5PnmXgwclJwx+CNk+Pd0XXzEB+lHICPBbjWm9Y=;
        b=K3rPIGdMrZEBSJd3yc8W9LDTXP/gbLTVDXria1bOFayhyXpFkGZ4ElPT/vfxAVkGo/
         S0qP5QkP1HyvjCvGt10SbayMqhiKyZMg1jnlGOuXNrI0kxZjyXWzrWlPvGILJDydmZHJ
         +CtqSoIdDoQ8rNYGVJGJ9U9/Pd0N4Z4qlmeFK2R+ggMU3N+nFzn5sZ0TuIFY8fUbqnaa
         k65ng/85iMOiRjq0uWvJSVh4OWTQrhi9mdCwbYRXrVW73t0+RVMFwdwX6ykHYLI64gVa
         vV9Ub1+OVPg2yPk6QWeRRAJ53s8Le0gaRtjhOBkvP+dZH0xYYq9l5JudeXtyh9Tr2oVw
         Mbfg==
X-Forwarded-Encrypted: i=1; AL+hErE4Nz4+CuJYEFRLH8f0x8e+xWSv3RQC6/tz/DF3zrN2Yw27c79mLHyCm0tR5RbBct6d5B64HP6ABzpo@vger.kernel.org
X-Gm-Message-State: APuU4Z+1XSh4pyWLdN6q3ovtVkbMtT5mPT49M2mJFYuN4hip8hm+JHf5
	3Th/AcpAeOpUcIRzDnZdchdbOMmff1hW9eC9y2NbhEdkQCOpxABq+iuzSN33/5vlCGkio2b4mJI
	tk0DQjXc=
X-Gm-Gg: AZFdTZcslLNXA8C8EEIObLUOqQh/XEYZGf9txKLNQkiG3dqrFipY8qoc8VIMqweLW6u
	Y6N3QhoLLqM8JyD2sm8nD6iPS8EvC+6xsFeKfBbEOei7BDaIrbYDfHjz3wReYT7F1UhADMiXfnH
	1EFvjx/lZwjbf8nICnqqx3tuqCBXLlR8ulRGM0gtJaKwHuTrZqb3I2EHWxidlBVxWLFlXEXH/wo
	lRb3tsrmDvBuhTSBjrDMC0kM8+qykJMzYf6oxoFbyNf7lVBe6vjK+Q7butdce4ZizD9Uc9cLvSY
	6uchhzbVyIeFV0HqC9BdP8Y+wv7bZInuzE+RBhgMTvmEqQpSRFROHxs7U3Nc6T2l9f20qzoVbHK
	MAzQRFyPJKpuu18SsphsITjRf5Ri9r5IjFnxU8LC9l9XODDmSF5/K2YsNuYxknLxuSa1lZQa7CG
	aT7ahfxSABYjFutdPeaS5Xe7Ey8bHwH+Km93DoFD9anGEBThvj1tPnVD6W5fY270xnk1JRDvPBp
	rjwU+ruoDPzG+IJUmjvQkFDRMFxY7gS6sSHBUP/VIy/DE9oi7BRJ+g6lUfB6hx6p9Lr2fNBumRH
	HETqO2K9UZxLDW0Lx24rt+b3QHL1pwbBPHu6BkyXg4iemhsv/hSBwc9NBlra+8in6AGE6XjZlVN
	WAOCq/IdDTHUacOK41spgNOM2IiD9YHKzovCx
X-Received: by 2002:a17:903:41cd:b0:2e9:6645:e9a9 with SMTP id d9443c01a7336-2f03f20cc4fmr22356425ad.32.1795175013537;
        Fri, 20 Nov 2026 03:43:33 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c6e50sm13252465ad.13.2026.11.20.03.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:43:32 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: aacraid@microsemi.com
Cc: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: aacraid: bound adapter-declared sense lengths
Date: Fri, 20 Nov 2026 20:43:28 +0900
Message-ID: <20261120114328.3072332-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013140214.3156938-1-yhlee@isslab.korea.ac.kr>
References: <20261013140214.3156938-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v2:
  https://lore.kernel.org/all/20261013150420.3168223-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
