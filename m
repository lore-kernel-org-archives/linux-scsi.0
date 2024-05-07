Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F2D6D1A9
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 08:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715071790; cv=none; b=YlZJE3XKmytTPLr7veylF6XTg4NRUKdM/PbzWYFJs+Un+oDCfdTPvGQ2WLv4T0xAebMDijeAWw514Z81gZdccYn8qJSp+JgF5WSVnAobKIEbxjHNkDm+uEtOHPqiI7ZnGH5LdXcpbnkhQiBb2gV6xr4gHAlT0JihKP5gNSONudA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715071790; c=relaxed/simple;
	bh=qVyPEN5jMnOaG2HJPLxO05CBXeKQ3Ad71BRuURDHWgk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=f68hsGNuphJ7BQno7P/JnFckoGc40atQQ9zyGvMC42vvULsZvRBwtG2X9/BrVYSvwCF8pmuHT55LmJMkW5KXG3ux9rXw7crh8tRyRuc53OyTSj6H7FxByB5p4qGLskorenqPYLZa72jRXqGJ0Oymno3RRjPYEAfMBzLb3HTDXQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dorinxev.biz; spf=pass smtp.mailfrom=dorinxev.biz; dkim=pass (2048-bit key) header.d=dorinxev-biz.20230601.gappssmtp.com header.i=@dorinxev-biz.20230601.gappssmtp.com header.b=HPCMh5Kv; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dorinxev.biz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dorinxev.biz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dorinxev-biz.20230601.gappssmtp.com header.i=@dorinxev-biz.20230601.gappssmtp.com header.b="HPCMh5Kv"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7ebe09eb289so1029262241.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 May 2024 01:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dorinxev-biz.20230601.gappssmtp.com; s=20230601; t=1715071787; x=1715676587; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qVyPEN5jMnOaG2HJPLxO05CBXeKQ3Ad71BRuURDHWgk=;
        b=HPCMh5KvOE99zq1OZI8TEQ4NLYDJroMhOzGy7PPHo0mKQhuLYWeSpSmTdWv+5mY0aK
         K9O2g4S6OcV0/vQ/VwlReWY+7HakdYsHI/r+yM7Ej1DpHfwL+jQfHs6itmJ+B7Cc5VKC
         7V/hs0jcqfxy88GHDX28ww3KPCi4/fvDxWiMdcbnBCX1zakImP17hPvEbjQXLqczcHJa
         fp4h9xmYsyBGIIYOou/xh2c7Giclj6SNN+g8UD1llb85ZjzwTSrPfoecwid+AMEfC9pA
         v3ENt8wauVgZuk4jtPlVBih7pLAHCmWUZH7x1hmKctjVU7/bu8eoU1CPw5WeYcLF3igS
         rxxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715071787; x=1715676587;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qVyPEN5jMnOaG2HJPLxO05CBXeKQ3Ad71BRuURDHWgk=;
        b=W8wPLzEhpg05gNmdkX7UiZ4pF/ad5Ok5ou7q86D+liwqp+HzkudZQk5lAF86Ws5XAd
         kaqcv7Ez8Xpin6FezWBbdVhn5pzNaJ8uyCePG9MFrz/izSOitvJuz0wlo0/DkAXGJhc5
         0Ek91KjMO7BKcbHe0dIvFAvy17HioW5fIDBj/hBwjpChSMhdHDY0+lSiNQBZMWajEJ65
         S2TpPQYBTt1Do33mqBgJmEYpmNpmRXc5//SldL2hOMchHGl3X+QF5cTBDNDBg8ItyTMh
         r2ARkHzmW9NmjRjXJhk/rqchj1eGg3kdWb/AvDnKJyTQFRE9+CFkzel7GNVvIeD3e1/Y
         1dzA==
X-Gm-Message-State: AOJu0YyoWejyr7Jc4/PG8YSwIxlsq2Gdtq0jyFSk+p+YELtLzaxTHuZV
	uXAc7u9GGI9S93Xtya1txPgmSSImo13UZTKTJfT5mRmLmQQdYnhY2g5eR3vDmVSKWq1mdOoXv/5
	dYuqgUQm0H6GVbSp+LAHirMLSWz8Vo3b51/8tmz6rItn6fWxPTIs=
X-Google-Smtp-Source: AGHT+IFEJDQIpiksnG0p/NPID4jMRxNHJHYFzJT12A3Tg6c8wzSGshUgOZwcrTtwpf8zNQBzfqhnhN9motKGS0NNnR8=
X-Received: by 2002:a05:6122:20a2:b0:4da:dff6:16bc with SMTP id
 i34-20020a05612220a200b004dadff616bcmr11060283vkd.15.1715071787271; Tue, 07
 May 2024 01:49:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Dorin Xevious <dorin@dorinxev.biz>
Date: Tue, 7 May 2024 11:49:36 +0300
Message-ID: <CADvXaUfaxL3rTAKnmdZX63=zc9Zo2bzgWKvt5F-boZPMTr+_rQ@mail.gmail.com>
Subject: some weird messages from the mpt3sas
To: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I'm using an LSI9305-16i card with a few SATA hard disks connected.

Occasionally, I'm getting some messages in the syslog about the
controller, but I cannot find any info about it. I don't see any
errors about the controller or the disks either in syslog or the
journal, just those messages out of nowhere.

Could someone decipher these messages so I can see if there's any
issue? if there is any issue, how do I disable these messages.

The messages:

May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:47 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)
May 07 08:05:48 prox kernel: mpt3sas_cm0: log_info(0x30030109):
originator(IOP), code(0x03), sub_code(0x0109)

Thanks
