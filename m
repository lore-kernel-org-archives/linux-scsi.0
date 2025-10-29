Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C61355808
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761761724; cv=none; b=APXqUlRd3tgb5ZxuAaLFqN+7lSClBlZ8A36h+Wv+nyXckjVgosKCeGLQ2/lUrP+qN7uH2NLkcWfE+pSPJ1tzzb/FhLghLQAbPanzgre5kWw1FdhzmnEkjTpm7MqLwCGfWO6lryMGz/5vwrk3Ne0ZrbCx89/aY56sjNyX0MlhxdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761761724; c=relaxed/simple;
	bh=BuHwcBRjX7psQRnTKSitcdj0z27vIL/EwC/MUMdXQjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s+MXpEch4S4zgVWxdz2xlxZtgzeUwpWtG5tBqRZcA1+r4JYiSllntteaZgd63jKZnQ7jo9ilFR9ouzhGE0oCY5IARhtUYZpQ9MPNpuHPruMNKUQwFJLChADdhw8FylxRhyV/dmJXTMZYV8y/uL+HajZi0UAKtDQ8mqJ5kg3CbGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UiyClDEC; arc=none smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UiyClDEC"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-63e35e48a25so263415d50.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 11:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761761722; x=1762366522; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BuHwcBRjX7psQRnTKSitcdj0z27vIL/EwC/MUMdXQjo=;
        b=UiyClDECh70d8Im1x1oeC/kp5zO/svOg4FNXu9NvL/hzfnd6U7LQ/zbnsBj8GgaCn0
         2pk6s/FaVrnqro/jbVBdvfqN7jbwHsWaPB2gebPmaUjTkbQqIDXIIC/Re4jq7egQAmc5
         kEClBW7AEemGR+tWJSXn4qDNSj/bj3KrFxQR6OJzesAtEocxes2OqBI+bUbJ+OiIgZGN
         6wQ5uFfbIYz97kezn1bTDNzwPlfjogbrQV8bgh/MFEcFssWLhBbrVWtjmsgKkMbsJnh2
         Lt4ud4ND5dOryzEWmbtlDIJn4axNsz496678U811qLeqxh0p51DuQxdxKSlJ5OS5Ef2R
         6qVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761761722; x=1762366522;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BuHwcBRjX7psQRnTKSitcdj0z27vIL/EwC/MUMdXQjo=;
        b=ac8vAdot1FdwrVRPeZPgeXVr1l/OHnV51TusLLm8WX3SABQpqAaIUhYxBJyELlTnC0
         1QqbtoKOEI4gddo3StL6sUYXhishb9UmBVGxZISBGcx4NcUwAxBoBt7nw3UuRRspkOxk
         FuNK7yF1K6ipAJCmMbCy4Isk0RD2SLS1arHCVurkdnKc19hYPGfA3o6W9G4vRwTZAbLs
         7hJHXt8qyHEueD1131oyvnXnHA9DZpgHTMJdnOgplcu6+MNFoo2WVYFCdVtFw1o0WC+/
         gDh3xKH2KfokRSF1zmswRqiVHZE/GI/iC4GHWn1uv4XRi9RHPW+s94Z7UwANVje/XEDh
         WALw==
X-Gm-Message-State: AOJu0YwJO8ZZz7ksHtZeHICXyP0tmY+/GGAjHaau8tfX4h6amtmQKnLN
	tE1TZQnhcBO7PLEe8zdqbJ6a9yi41KToRo7Osi5gVwesRIuJYxAouBA9FcRwGuu+3QucyIIKpFK
	Ciow6lLV/TGQxRC2pDBeMped6U3fG8ws=
X-Gm-Gg: ASbGncvLCiBDeTPfTSQq27F2tMjW/FNndFMdsXqbResdIsGAwh2BjGSzvwniUreox4v
	sQKSEmOMkLu8bwO9jtHTKOTWdLOtRkSwRuK6yUNZCVMs5fNU/xcHqBAiQsf3gB9/y9EUsW1VJo1
	CXK6ZowKzzWET5CyUcozXjsJ7BQ43q+5N30yz9El0Lyp14Qs8c7qV6qUoY1567+m8uMf/vw17EP
	+U/z9/Dkho+jPHpdnhcyl51V/4E51HAhKWrxl3qFG9hjxRBM5TA4MpLl4hxEw==
X-Google-Smtp-Source: AGHT+IFnXhi3SdibMHCcHs/z2gFQTiRX4IoidpL3yGaXjN15H/P4VdTok3LT6Mrjv+nMa/mqc501DYapsr0wdeyncYY=
X-Received: by 2002:a53:d548:0:b0:63e:350c:aea2 with SMTP id
 956f58d0204a3-63f76db3c3dmr2726416d50.47.1761761721838; Wed, 29 Oct 2025
 11:15:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027235446.77200-1-justintee8345@gmail.com>
 <20251027235446.77200-10-justintee8345@gmail.com> <921bd950-4e62-4140-a015-c41ea7f07989@kernel.org>
 <CABPRKS9qL-vNbLeE=bqtk=wodVpA2fz8WR_n_iFXS3Yey_bbmg@mail.gmail.com> <a4cfc9db-3c41-4b92-ab2b-17b0ed7f1955@kernel.org>
In-Reply-To: <a4cfc9db-3c41-4b92-ab2b-17b0ed7f1955@kernel.org>
From: Justin Tee <justintee8345@gmail.com>
Date: Wed, 29 Oct 2025 11:14:52 -0700
X-Gm-Features: AWmQ_bki_pBu3_P0pEbxqTWfxoM59etmzo9Hgbq3zdZ_kkdAfRVeIxEsY5fYPoY
Message-ID: <CABPRKS-uBAzvCN6nRLy0bteG7AKAbeMUPfOsc85_ww7=OjrWpA@mail.gmail.com>
Subject: Re: [PATCH 09/11] lpfc: Add capability to register Platform Name ID
 to fabric
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Content-Type: text/plain; charset="UTF-8"

> That's not really answer to my question. I asked where is ABI documented
> and you answer how driver behaves. Not related.

So, referencing lshw, the device tree ibm,partition-uuid property is
used when reporting UUID on IBM Power systems
https://github.com/lyonel/lshw/commit/9c5c2f0706db330114ff4624e0931ac40c1d6fe2

Additionally, referencing how libnvme generates UUIDs, the same
property seems to have been chosen by IBM as the basis for NQN
generation as well
https://github.com/linux-nvme/libnvme/commit/62bac64627b7ee99c49f30a399240acf04c95d92

Regards,
Justin
