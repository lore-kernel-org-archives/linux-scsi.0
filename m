Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175024;
	b=puv+XZcjB6B0GweZy7AxPYA9LEO5ngVUonta0FHN9fL4kRvBJUE9QOPZiLAwCfGwGd7Y
	 pfysD2/2wnP9YPUeyYSPLuKN4LAmKuYXPwLJfjGWVYvzuZ1yKOAgMj5Hs540WbJl/08OV
	 n6SfTxnbTXwMA3TAw/QFOr3v9zYy8P1YmQFQ5h03ycwhlZZTwhpLu0Q7zEdhqZn5UP2Z4
	 N34KqrjNN6t+PE5QgAU62P/yGgPP7bzO7mJHijpoxFsYXZNZXF7NWwcaEXwmFN3kWdrBb
	 tVVu2Pfqb9BaZxeHUNq5MBrW2Y5iiRoYv3IxKzUjTPtqvO33bt/DNY3G/ntbf5KrYXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175024;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
	b=mv2C2aOrPHszmFtBviCChB7ZvNRITfFMSUrgUQaGg/QWhbh5jdJqvwUwibFkF9G+NeSX
	 SOLmZOvzAA24+BTZKo1bnoqQUP/h8eqXUY7VqxttY+1Gy3x56JTbrXk22SZ3VIc/f7LjJ
	 XPA23VUr1BkrcpxrLK2g8EI7IDi182/yYW6M0GN22Ui+6XqpeHVeTfL390JhK3LoZVQ8J
	 cgksI6oUPYz704mJ9mAQnzN1BDEo7O08IZYu8fR6FVmdSYpraHgkA7LIcuqPZ/HjdlsOK
	 fZBLODNL25qMQEB5rRkJMJAo3e1DA782gu3XRK2xL/wncqkcKdi62pfFF7eirRVQdwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=sLazAkoS;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B3B60A2620
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:43:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47B3B60A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=sLazAkoS
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a070781f63so429505b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175023; x=1795779823; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=sLazAkoSqoOCbIqm5cyRCTMvTBb5auoEwUi6S31PoEXGsFiOOxqN0c9rIy0/l5heDk
         9/VPa538Qx9u4veHSAF0y0I+TNqb4K3YZFXMrOFrPkMSMHZfS+gs9RhdE6loCR79t652
         msh8I/A+evIg6yWFY+MH0k48sQnIA6bwgndUiQyM2wFbA7YIBftA5heKW/3ngtpStA0k
         ha1wiiYu+37aAMsVqOCUSccgqHxPNPZpuL1Z431YI0+QLpqsgfQwXHooxZkKCxKZE7Le
         SCQ720xIxjULAzwptLYYdjuXVmDVSBjW5RbRzHnOQTNv+3nSk/JLSnCPxTDKPhskqdFA
         PqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175023; x=1795779823;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f40EVFz1rtWKrEF/UhE+GvFPiXhiXKV+B46XullK7uk=;
        b=rpGQ5SwRBe2q1HZ08VoPOrT+nr5zYP7yAzSXhySQKmJ9zQxdZRhLrxPnmdnPtDAiGe
         XQ1FXD3nI9yUrwbokpOIY9WykQarWViattJ0jjf3dKoqRVK0C5n0DNe6O2kgZofy0jqb
         KK8WHicprKLxBG6Kg7xC5uhyfLnVHIwmyyz19OjEgmAPidkFuIZfSTT/7xEmVd6Mwv/2
         qcRAL1TOYDGXIuUZIAADPTIcRvCy90js0pYrRqscwB8Rdq9XbxyBpzK9ICGIeF2wHhDX
         A8224sw342jCIvRx88eaYSDWpsASnnPW2pc32+WrF+0xLoeks7dwp3o/XTKAGiF+Z8LW
         MJ9g==
X-Forwarded-Encrypted: i=1; AL+hErEC5KlSgSCfAnQSJeKWpNwjgqTvszF3Xx4ddR+hY+Gr1gPYGezFib9GbiN2NIyU+RcpeqCCRvnjC4il@vger.kernel.org
X-Gm-Message-State: APuU4Z8dqwIzEiIjJy28/GaiR6ympJ1LNT7UlkW+GJl0NYEvsz3skP6P
	rtnact/hb7+AZo/KCMELWuxotcIHDLe5KX2pbXBxE4sng1T9vtJoEIJX6dxFAPhi/UM=
X-Gm-Gg: AYBFou3sxcpVcBuYER3Rk2LNPi+nSILZ21LoEGwzGKEvEFDDeS987XF03SOom51T4mN
	SPyXCIX1NSh7Sl77mN9zZfv7gnJEj7XN4ceyv1rqOMwa4MKK0niKjiAE4uGGLDuF9AKnFmLDaPI
	MGuUqFVB3Wn+sjfKXEvXxC0va/YroM2cbGPgJapUVtqWkRmwk4cB76wDsNcIX6RmXgCOrghTytz
	S+yXQlf6vnCKU9/6O69LOVaO4hv1Ni2zmKoPd5wGP139fS78vDAdG6qrejKVduMOhqz+oy8hXdp
	ViOH5cEZGN5AeL9cH/hXal6HMHSOvwVRnt02e355OffIrGpot/9IOEj6Q+o3OW1507a8M7yL03O
	fAarILQxQhO4EUm8Hr3DOeSbgjuf/hTa+1rmnz/HAfGHM5vLx+imVXWBwVtORNL7LkZebLcD/BW
	k891M/7N2+98lojSmF1+46bnZp2mlmquDiv97SYKgqJUeCP3zwB1ow8Pp9Hopnvvgnpi6wwGsu7
	+PBnCYktShjW4PI4gcJ7qbBmNt37fHmZcUrcMjZCEe+22PbzJ2Mleqc1s8Vw9np5O76j/j86OMX
	/32n1KOU6JZ33nU+ZLkFi2Kga8E6M5xX+tTQq3Ot9HPQIYn4ccCLRkEjEpUK+vONlOy9bzhSiCW
	dTKFdtQNYKAyqqjkPmWQjbft1KGKXHwviAUfq
X-Received: by 2002:a05:6a20:914a:b0:3dd:85aa:4526 with SMTP id adf61e73a8af0-4014b5645c4mr2972265637.33.1795175023592;
        Fri, 20 Nov 2026 03:43:43 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c86d821637sm1488388b3a.0.2026.11.20.03.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:43:43 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Fri, 20 Nov 2026 20:43:39 +0900
Message-ID: <20261120114339.3072367-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014004226.3469868-1-yhlee@isslab.korea.ac.kr>
References: <20261014004226.3469868-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v9:
  https://lore.kernel.org/all/20261015045213.3975845-10-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
