Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3F72E64A
	for <linux-scsi@vger.kernel.org>; Sun, 16 Feb 2025 14:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739715338; cv=none; b=i5lqOH9rw8j79BK9FDn0WE6DB56yV01qmG+fB91h4GfUiCsfcA/08XKfwh6nI52N90FSl4V6RPkpQ9Pvcl7anW4qE9IRb4m/kQNbnBJMxBOfAtNo6aIweo6WYwm1LM6B15J2RjnVphaN0Y7wfMjtL7XF9bCdCaUu4BJaVx2xUtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739715338; c=relaxed/simple;
	bh=NjdP+HYW5ufsAoh0in9wXTTB0+zsjbE2DLH49bIuBgI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kt1w6QFzmdIOx8tFLodmXuCc5AU1FbPhGuo+5nxym9dVogCaSogsyY5j3jPaPxC4Q6gY+QfwCQ4PD4rzf3YAJm/o0wVI7vjkAxS1qQ9yv8SyCOFay6DUeVH929mibIycwC76/wh+49Knd9w/X+rDRE4JupfyvmVbnnjEWHchNfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=levzehrB; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="levzehrB"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-38f2f783e4dso1540383f8f.3
        for <linux-scsi@vger.kernel.org>; Sun, 16 Feb 2025 06:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739715335; x=1740320135; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NjdP+HYW5ufsAoh0in9wXTTB0+zsjbE2DLH49bIuBgI=;
        b=levzehrBM0JN3E3CDnMh/uzNzfdblD6SEheRyaCREe4xplKanb9ZbJnnFnN9MXGWRS
         Wk/gL10AGhQ4QQ7RtcmGBJrLl0bMxEHCXlWwr3Wmt+U7aLw5AkT8tfmt03i9LZ6t6dps
         FjG4OJW+eQ2rxxEZPQwLPpznfmStlQQavL3cwSIq9GB1rEEQ9+UVrUeQVaIT1+j3dIKG
         YQuD2gm40A8hi05mCF9XjDrPselxIh97HXqYNvwOKFZmI4An1rMNq4lsZ0NHod2iKbXX
         qKzlMifcAJMbXyaUDNh9WZJ/auEqAmgorDRxACqIz/9YThV8sH3SmBmVchMh3rkOkNI7
         wh7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739715335; x=1740320135;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NjdP+HYW5ufsAoh0in9wXTTB0+zsjbE2DLH49bIuBgI=;
        b=LJ5peCpNiltc676e0w4zd93+2vAb4sOekm+vL8VKp0YVuFEl77UKTD6l8l3M8kcWvR
         WhY+yqt/PAF7aEt5xTZguolAaeFCJMLXkeX8Wt1KyKHtd5XZiw1By95J0qy4Hdj+/0Qh
         OeqTZ2w4W3YLlYIA64roHQ8232LNNj+eWctWVOqEmnqgiUhsDrc5bncGK1rG3mgfB3Hc
         AnpwekeaxWxzx3yZ2w5Iy8BJUg2toduqgulVp9Fy+ABcU1EmtULg+3Su5XVAwQJC1rqw
         w4IuPiYX3FJKMpr3FV5qXKbb6paVPxhmrNlUsXq9q+DPTvyofJDaiQQovmtJFwQGJG5s
         YWEw==
X-Forwarded-Encrypted: i=1; AJvYcCW5uNesFiabpz+Oie+Moq8d+93Mzy2RXEslR0FI/YqvHh5iQOnX+k8fVu/bT8gJlxFDclg4kRDICuVB@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6BZqLtmRsmd1DbsWvaaeEmgFwK5VEPKzXp9+B0PughQcojhkb
	518ogJZ11+jj6jaQIFbZn192eeKzXJ4ru4vD/Gut0a4nnnk68nzs
X-Gm-Gg: ASbGncuGvwrpLyztAXyGU/5JEq0oiNxZgueQN6y3R/MvZx6XYLzo9RcbqePS9S/HuYR
	1xj91YFON40ldhfZZXNCpgwB4nCPEcNih39D3ahI0oz4m5AEHSXL9JR7lK/3NnVA3B6TyEFhDqg
	4B8w9eGVLwr746wWKtZwp+6HoPsPQKFFz3BoSRUIUz83T+b/tMp2i1o7DLnl1n0x3uBB08meLNy
	KFj/7uFvOD0keXgYFcgbRcHB8HpX6eDibkqjaLgP3cKKTGdGS5jjf/+HaD+mUaQ9yunF2FJeUDN
	hbKzeiOvXGbZDvFwKvwlUQ6g1quri+HKnnkvJfEmUNjNJjLOhWlr6z4WAWEpqmRUaPtouE9vyuY
	tTBraJiXrBt/8HdNASM2udLKwxwh6zV18+Nn1sGxCdCPISEQrbkIIMzw=
X-Google-Smtp-Source: AGHT+IFU9X7XfDxQRxgRSxeJbVVfPNo+JeJw2CZ0Ntr6HoE6gZ2UyRdopaXlBmPIhV1DCnL70W7p7Q==
X-Received: by 2002:a5d:598f:0:b0:38c:5cd0:ecd5 with SMTP id ffacd0b85a97d-38f33f4acb2mr6636251f8f.38.1739715335234;
        Sun, 16 Feb 2025 06:15:35 -0800 (PST)
Received: from p200300c5870742d85925c84ae79fb582.dip0.t-ipconnect.de (p200300c5870742d85925c84ae79fb582.dip0.t-ipconnect.de. [2003:c5:8707:42d8:5925:c84a:e79f:b582])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f25914d73sm9880652f8f.54.2025.02.16.06.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2025 06:15:34 -0800 (PST)
Message-ID: <2420c932bd2443b3c924c02a1375ae63bed8ab6e.camel@gmail.com>
Subject: Re: [PATCH v3] ufs: core: add hba parameter to trace events
From: Bean Huo <huobean@gmail.com>
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org, 
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com, 
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com,  qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com,  eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com,  bvanassche@acm.org
Date: Sun, 16 Feb 2025 15:15:33 +0100
In-Reply-To: <20250214083026.1177880-1-peter.wang@mediatek.com>
References: <20250214083026.1177880-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


On Fri, 2025-02-14 at 16:29 +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
>=20
> Included the ufs_hba structure as a parameter in various trace events
> to provide more context and improve debugging capabilities.


From the patch commit message, it is no clear how you can use this
change to get more infor and debug, since the content of the ftrace
output is the same after this change. Because the device name
(dev_name) is still being printed, but now it is derived dynamically
from hba->dev instead of being stored as a string in the trace event.=20

I assume you mean to let bpf get more information from hba:


strust ufs hba *hba =3D ctx->hba;

If my assumption is correct, this purpose and intent should be
prominently highlighted in patch commit message.


Kind regards,
Bean
