Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018897;
	b=nrOL0KlbbuQigosvcWsX5jmqDWgk3GDALL9NaI2xv/W22jDTG+ADglyyZx3jiAl7vgMj
	 CQFhmQnjFhbZ8+CNSUDZItg0wKF0qjSnH/426JrDLIg4vCpmq6k50Z5DmWhT+CwVl0GPr
	 jguQBJoaZhCp0cR2d7Z05NWW1O6OSeXnrsSUh8Tj1a/BHzh3EPV0vL/eB15svLvcqm/mS
	 XmEKpqR7ZnorjFRo8baowsHuTIceusuk1BlSs4jz6jnNftDLdmReO2ew22TxXvxW4gH7E
	 4ibBxAP5ciEvEHfoy64wGtqoIsAPJBWPPqb8a8qkrDdUWKxh6KIJT855lq96bl+bqbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018897;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iSQTJc/iRoE9ap2PM0X1PteM4qNBL5Yn8mEgnBJnQKo=;
	b=rYH34tLXzSAs35g2VKkcCU2r35OQIVCqHIbhJz3Df6yIJWVeiwOl8LPh/mhmpqtFWjC9
	 mqgwFN215v+ogS4uaZtHsfhCNjY17X+Vxetf64zj/7iCIyIfWg34vwbL1DgotpfGzLjyn
	 wZn3tEXT42XIE4ZqgE4ehzsKaWB+v+cXFO2+o0TCvvYN6ODgL88SGJSa5AIXfmk3vqAzd
	 VofWRAOeWvy/Dlq6b+34++TNic319dU3kA+5BR4MclJ2O8In2K5MOjmqIeK/kIyQ7f86m
	 6j5+KG5Rzf9+htKC0zPTLxCAIAs99Bktclu/BeWHtS/germbPIPH1zjrrE0Lc3BJMAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UmeEj3gw;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB2F606A31B;
	Mon, 26 Oct 2026 12:48:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EB2F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UmeEj3gw
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793018891; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=iSQTJc/iRoE9ap2PM0X1PteM4qNBL5Yn8mEgnBJnQKo=;
	b=UmeEj3gwt1JUY4jmlwN9yfmGtOahX/+YRi01iz5RV064oVTtKlUl6X22oy+ObTkxCtb+H9+1e4FEY9oA1z7S4AWULqffnviSD3clw+df0uGtblyaLg+XsHPRgMFHFJMbJqZoB0DC8bRNDt41Kevy6qn2YDuBeiYny+3990LXIMk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XDYKCv3_1793018881;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDYKCv3_1793018881 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 20:48:10 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: sashiko-bot@kernel.org
Cc: mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	john.garry@linux.dev,
	ddiss@suse.de,
	hexlabsecurity@proton.me,
	xiangzao@linux.alibaba.com
Subject: Re: [PATCH] scsi: target: Verify the iSCSI ISID is NUL-terminated
Date: Mon, 26 Oct 2026 20:48:01 +0800
Message-ID: <20261026124801.2720682-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <sashiko-outbox-184760@kernel.org>
References: <20261026044632.1738901-1-xiangzao@linux.alibaba.com> <sashiko-outbox-184760@kernel.org>
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

Sashiko is right.  get_unaligned_be64() reads the first 8 bytes
unconditionally, and the NUL check alone does not bound that when
fewer than 8 bytes remain in the descriptor.

v2 requires 8 bytes to remain after the separator, in addition to
the NUL, so every consumer stays inside the descriptor.

v2: https://lore.kernel.org/r/20261026124138.2708365-1-xiangzao@linux.alibaba.com/

-- 
Yuanhe
