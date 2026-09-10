Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD1F2F6562
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 02:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789005991; cv=none; b=TXSNfnkfDuMlXUzLl8svUC239jh1I0tdxSb2EEX5ZDgRtVLrt2jjMyPENr1tJPyd/7xMiJCSVUIYd7PtV3eH0vDijZHLH2sxFP3hj75m6tb0PrVriwrHWlZ7U/yf5pn192j9FEdr71s0sPgf0CLP3ito5F9V40rS7GhTe1W890U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789005991; c=relaxed/simple;
	bh=cT2ixrEMHtiVfuyneVqCpLewyOY0EkT+PRXnvPuAmrM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WC2RxDPomOBYwXGR1zid/jI+VnFINdrVaNc3Kq6JpmTnE6rqF/brHvC6chN9aiCreiz2BQhdwHuOUaoBdGxqyOoKq9YQsUfRk8kEUfxMtJIOcqEU0AiAZlfUzpzBVabY67x6edlK4HURaUsQEzbwLufbNzoHSxr4gtg4D3axbZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tScsuWUy; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tScsuWUy"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1ca15334cso5214393a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2026 19:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789005989; x=1789610789; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cT2ixrEMHtiVfuyneVqCpLewyOY0EkT+PRXnvPuAmrM=;
        b=tScsuWUyoQXgw78V1PWNTyifiYV0U1zB+rEuP1ZMAnxdko55FZhc9plI2r4XBA3S+f
         ZA7A+UkAka3VRvPwxLg7PGNzQcA67nSYfkmzShoAJRImm2GlGPQsfGewOyaMAbf1E7Nl
         s6fxNEuKV/lKyBO2zMU6JgykrBqQKyJXZPeE9Vm7rTz1ap6Eyfg0sMSGv5LbYocjL7px
         8mClTZtQv62JtSR4/NVZ0pSLMPAdbpGhANNSa/wjoY3EvppUCX8fjy36J+9j66hI2Utl
         Ra6fKm0rnyFE1lW7/HWnxfXcyeugz/63qoXj987vNBZ7hSs3c0Uf2V/PkoUW6FTupNf7
         qT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789005989; x=1789610789;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cT2ixrEMHtiVfuyneVqCpLewyOY0EkT+PRXnvPuAmrM=;
        b=ALb1vo/H0LRx4DC54WhSt86pahvZ11RnC5wLfBilrKD/vhLdzK4JsRzJtj9xFuTwjA
         xWBamoIrxhRvq6uHIZEo5AAMwNjxHd6cpQ+SFzbhH8DKPwH2Prra06WkZnDeQHrlyW5f
         FzFWUmEdDymqmAgf/8/IbadxbgVebD6MX21YZv3dNADQynTFOcUFN6CWPLy0GdpwtAgJ
         9oVjiCn2PHdvpD8zeNOgYw6lnkrHrhxH5p+TdZ9WSZaW9fn4YzUDQkqHxq4u3AMdisUI
         iN76TgKFwySMqL0wRGsNMt77ilR8pFVnUxBPC7c3BRzN+wxOPLr+1ayqGohwHbFroGXD
         RxnQ==
X-Forwarded-Encrypted: i=1; AKwUvBx1Dv5T3KQX3E40eQ/ZTh2XG0MncSD4AO0g+2c3j1OIa6NGXFg0z7xm2HGFB2mF36e/gVUYgWCW3MoH@vger.kernel.org
X-Gm-Message-State: AFuF++lDRVMKzkVT1ztCp6KENsvQ6pkCpE6epzDh8akyBFFPk3ayWSiB
	bvoZhvw9KgRzlSR6cx74HSKcR4kqC0VTOY3xoxMpLOATBRp9UdBhfCgS6Q3H/AbYe91qw/EHwjW
	qyCS1ItZTDrudTpoam2M9FA==
X-Received: from pgfd20-n2.prod.google.com ([2002:a05:6a02:6554:20b0:cc4:32f9:eab2])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:78b:b0:3da:bd6d:bef4 with SMTP id adf61e73a8af0-3dabd6dc136mr13519890637.13.1789005988969;
 Wed, 09 Sep 2026 19:06:28 -0700 (PDT)
Date: Thu, 10 Sep 2026 10:06:27 +0800
In-Reply-To: <20260910015503.1991119-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260910015503.1991119-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910020627.2006795-1-stanleyjhu@google.com>
Subject: Re: [PATCH v3 0/2] scsi: ufs: rpmb: Fix bus registration and device lifecycle
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Brian Kao <powenkao@google.com>, Bean Huo <beanhuo@micron.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, Li Qiang <liqiang01@kylinos.cn>, 
	Ao Sun <ao.sun@transsion.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

For reference, the companion patch guarding the generic RPMB core with
mutex has been submitted to Jens Wiklander and LKML here:
https://lore.kernel.org/r/20260910015515.1991789-1-stanleyjhu@google.com

Thanks,
Stanley
