Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA34253340
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 08:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278969; cv=none; b=qpJcIRRWOwFtcNDN4l783KRJ42VumroCrPWZ7DA7VnykI6GHu6aMIekAySrj5bm+LiulGYfuQ14Bs0ThVx7lAIi34JmZSDo4uaS3oEuzGFUYusRR3G/OGF5uN4bVHN3RA3msWzQnVeWnLcmvy+eQ/KsVVeVJG9CCz4qE1jJM9DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278969; c=relaxed/simple;
	bh=91hMEBpF69oLnRNrnD3g7Le9m7vY7PSSwV7tbTwrzn4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GdGnCML3AbLrT9iUPswEVwDKzON/jIkbqpdOUJcW262+a3cGxBU0WnmgsQZxganTVVwdHUxbtvLF+IhjwbjTpiiXLzRmh+Ue8wgoQhvWm5QCANVBaoXMC1c+6Yg9gWCfSarimUhq5iTa11kvYfUDM6X95h3BqWImoKeudYoasWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hb+Rs6Cj; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hb+Rs6Cj"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso107401735e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 01:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777278967; x=1777883767; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=91hMEBpF69oLnRNrnD3g7Le9m7vY7PSSwV7tbTwrzn4=;
        b=Hb+Rs6CjrsU0ACP3689UO37Xx+i+U/ZfJZOZxNf5Qn38YrqSBHN6hpEqN9iA9cvb7H
         aE/mGbE1ZecEzCsG0Qa6DiW8k9CjXWrbTGS7/+zrQpUMdlR3ajeMLr+I4hdYRw0uxHwD
         etEKuD302Nt+JVSCuGxiZADsTMdAkbD4nFwhy7ysH/JHCVCl6RIBvzsqU0FFc6BDJrx9
         wrNduV3BFYrX4R1/myZT2ZGFEZN1BQRuMf6U6HUZC9MH1ijK+7BhMsFcv/52yZx38kAW
         2VH42Ej3Q+5Mu9n7SujbwDABotEtsrZ0dzilgL7tTUXnixkUOzSQqADQv8Lle1iGK+uJ
         AVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777278967; x=1777883767;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=91hMEBpF69oLnRNrnD3g7Le9m7vY7PSSwV7tbTwrzn4=;
        b=qzPeU5iLNHPHQRlEhDwrdkHfIa+bN+K5ptbEM1FYd3RRqxMvNMUrDfj8oezYU9DQrB
         aC1SIaC5SzYsz51QPtHTrvQDcboAR+wmjn3jwbJ7kgLpe1Q445YJ786usAbN14hMa7fI
         hYs6t+WBDhNut/X46GH6kM9MJHSyZvD01PONh1HhANugbecTHnP22Wz+TAG9O0RsN5wt
         W8rxu3aK+hH3OPTOl34NcywJLBnBN0M5dORSFObfpLyTdqVgkEa0JkIRhqOhsk47uOCH
         NyjTnGQs/4FXDp5ljR6dKIyX5PxFWrsz3+ePd6kjgibci963BkmS4zYIDNx1bpRbHoFX
         jyMg==
X-Gm-Message-State: AOJu0YyKHyYzTgsWzp16K5ntDVqxR9SNAD/KUlXneVvJPU3wopCSxK2b
	YkfsvP7cw8umKHzqox3/e1o0qQpTcU9wN6rRspz+X0fDZ/jeXaOgKEDV
X-Gm-Gg: AeBDies6tdSPMo5Mvii/DlplshjIJBUHeazQgrhxIg1dWvRfcZEi1P5X7lHRMBCRVEL
	cqvU+vehb+HDpqyVlI9t87ANQye2ScqZZwYMB0GKuokxnoM65jImJ5fWEE6XKMYqWBWAbrrljxq
	YFCmOLE5a/K466SivtUXhf98lbPCXfC5763jSdlEpDw6ZiZKrmDCPUgBr12tKOI7nyPVqUX/pQi
	RAAYzlfnKW1QRjBl9L3M4BrspckeFRxGZZYfJ4TxLIT9gtz2A1dMlDOHf0MCkeo2pw3g0dun55W
	x1R+UaqnrPpbv/VorFxtJnoso22qH/7dRbx/hwZyWanjIOTaijr0cFCy+gEAeru4QR86hL1pdf1
	050X5K1GBoUFqegNsPgN9C196BhOa/L17R5TvW3+RJ+9KcmNHBkC8kI4pE65VU6QeqgEnXEYgPY
	VnSXAlJBJ0nIYYXLvHFJvpp8MSq6Vwrbb4u3aU
X-Received: by 2002:a05:600c:64c7:b0:488:a2ac:a334 with SMTP id 5b1f17b1804b1-488fb73aa3bmr605203715e9.3.1777278966523;
        Mon, 27 Apr 2026 01:36:06 -0700 (PDT)
Received: from [10.176.237.185] ([137.201.254.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a18csm90573903f8f.20.2026.04.27.01.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 01:36:06 -0700 (PDT)
Message-ID: <d7eb5958dcf2a27738973b0c876308a8d34ea47a.camel@gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Introduce function
 ufshcd_query_attr_qword()
From: Bean Huo <huobean@gmail.com>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com,  mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Matthias
 Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>, Neil Armstrong
 <neil.armstrong@linaro.org>,  Ram Kumar Dwivedi
 <ram.dwivedi@oss.qualcomm.com>, Zhongqiu Han
 <zhongqiu.han@oss.qualcomm.com>, Huan Tang <tanghuan@vivo.com>, Daniel Lee
 <chullee@google.com>, Liu Song <liu.song13@zte.com.cn>, vamshi gajjela
 <vamshigajjela@google.com>, "Rafael J. Wysocki"
 <rafael.j.wysocki@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, open
 list <linux-kernel@vger.kernel.org>, "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
Date: Mon, 27 Apr 2026 10:36:03 +0200
In-Reply-To: <20260424151420.111675-2-can.guo@oss.qualcomm.com>
References: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
	 <20260424151420.111675-2-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-04-24 at 08:14 -0700, Can Guo wrote:
> Introduce a new generic function ufshcd_query_attr_qword() to handle
> quad-word (64-bit) UFS attribute operations. This consolidates the
> handling of 64-bit attributes which was previously scattered across
> multiple specialized functions.

Looks good, clean refactoring that consolidates 64 bits attribute handling.

Reviewed-by: Bean Huo <beanhuo@micron.com>
