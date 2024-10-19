Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABB83207
	for <linux-scsi@vger.kernel.org>; Sat, 19 Oct 2024 17:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729359444; cv=none; b=S4xHLM0en/cGPflffvj1rYtZKL8nycJnKPTG6PP31VuCO92YuK1xNR53z+zg73uoRklZK7HARdtNURZijWaUbOHa/wJOaQIsYEVa0pS09ZcyZtbSsTZSR7548nO85A5VeLakdbbDvl8Dv3kFLEgUNvTcIeFJlIbY2v3J7wWSqZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729359444; c=relaxed/simple;
	bh=dz9SchaUjm6N4J5y1bx7T+58eYJGnNo7xCxmb2glJ5o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=bFA1ln0rCrhlFaVj94qOUNgPx75KYEcp5Fge/RsKZAA9P8/n3P7Bcb4r4LlMS1teZFWzC5khaZSPTUc9DHQhL41Y7JafmX9vupvLC4P9wZncejfFjfH2E1JXdKBJgV7C9pdj42Bi4d1pWLZLRT0FJhOOehfaq4LS/ontlQNy12c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fHmhat/f; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fHmhat/f"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a99f3a5a44cso358118566b.3
        for <linux-scsi@vger.kernel.org>; Sat, 19 Oct 2024 10:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729359440; x=1729964240; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dz9SchaUjm6N4J5y1bx7T+58eYJGnNo7xCxmb2glJ5o=;
        b=fHmhat/fw8ouMrfIbTs9W49gK7MAX40is74sNq66GXiggqp9UeefWdz/u+lqDM5Qea
         TXsvVYK/yj6vwjXYG4HKZV65YFD721+g02bQaEL1GY8wT8gjJOyxEG8J+XVG0fdtlrLh
         EhHgSJFbGZxrUQsgVh/1tOK/t3rJ53OkAl/Z2si71szAaUeDRnuDta1qttSmhSnfQu6p
         CAPueVZ+uhfMkvLb2JpxHA2FSSLb8lTy968zgrvYrL+wy9oEAsFQQshBGiDzbglmaedI
         HEoqSHtNc46XstdaUFbQVExYzeTsT6EA50lb72DEVTq+UrW87ea7WSW6rF5PEKigtLT9
         3i4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729359440; x=1729964240;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dz9SchaUjm6N4J5y1bx7T+58eYJGnNo7xCxmb2glJ5o=;
        b=CV9rM9DtGQUmjaEZC9QsluXdyUtn8T+QlUERqOJn4fjps45F9QqsfNjoo69WLEY+Eu
         f/93Htozu84Zbe3eUPAl2m5zoLL+cP/y3LKQ+V2OsLZbL3Ed1QnRx2zjHJfBvpMMPK7F
         jRct7410/sHy67BEy/kCxhK//BZMKOLL9OhXftcMEcSBIvcdlyiqAKWzZqBuoJjEcwfv
         +66fvd2hLl+C1bw8MCYu1JMnDj1Wvc2QmRyR0mjG2UBWF1hauSDN47RkTHxZxcFQ438f
         Cs8WRP7ajnxUfjYQVQH1k4k0y5/P8gLdDHBwLS+v6NeUQjV1sLETgdHUIbI1pfqGKsDt
         FZyw==
X-Gm-Message-State: AOJu0YxczyLwgK7sCadt/RjsyVQm6eZskr9mAek96eq70lYUaNh6jU6K
	YHLwuomb6WosNRjBZg9zyK0ksnxAITbtBp5vCEBuhBnCw6UUi814hvaiYEBNj6iAOIUl3uZZrc8
	aQlHNCBEOrSzQDj+U3LdxxmEoTp6E5r7O
X-Google-Smtp-Source: AGHT+IFAB97mxTBxiI4ULOf6FfQycYBp7JN8G+o45aHn9GeF+Ey+vQE0lkfi52zQMvGX3WNryD0cAEgnIlif/OP1aDo=
X-Received: by 2002:a17:907:9343:b0:a9a:17b9:77a4 with SMTP id
 a640c23a62f3a-a9a69a760e1mr599350066b.20.1729359439667; Sat, 19 Oct 2024
 10:37:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Magnus Lindholm <linmag7@gmail.com>
Date: Sat, 19 Oct 2024 19:37:08 +0200
Message-ID: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com>
Subject: qla1280 driver for qlogic-1040 on alpha
To: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,


I've been running linux on alpha (alphaserver es40) for a while, using
a qlogic-1040 scsi controller. A few weeks ago I added more RAM to the
es40, but as soon as I got above 2GB RAM I started seeing file system
corruptions on the drive attached to the qlogic controller. I
re-compiled the driver to force DMA_BIT_MASK of 32 bits and everything
was fine again. I believe that on alpha the
CONFIG_ARCH_DMA_ADDR_T_64BIT flag gets set in the kernel config, which
will enable 64-bit support in the qla1280 driver. This works as long
as there is less than 2GB RAM in the system (which is the case for my
other alpha hardware). The nvram flag "enable_64bit_addressing" on the
qlogic board is not checked nor set by the driver. What is the best
way of using the qla1280 driver? I might want
CONFIG_ARCH_DMA_ADDR_T_64BIT still enabled for other hardware on my
es40.
I've not yet tested the card on non-alpha hardware so I don't know for
sure if this is platform specific for qlogic on alpha.

Regards

Magnus Lindholm
