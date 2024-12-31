Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2593D64;
	Tue, 31 Dec 2024 01:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735607149; cv=none; b=GPErCaQwMib9ZeOrZUiAihuu+7ADrN/3yd3iQE51kG6zTrYCTiQ0L1RfBeWzdow+wDr8zT+nCSxCA9BaLDZ2maN2XJj39chf+Dg3SELT8tNmDepOIbH72ETZzQ1D6FNOU6Py1sDXKDPCcQ7uwbCimiI50je82CNlANBvGRqZolE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735607149; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mrsp08Gof+vwgQ1dCtUfnPWcutHHmJHL4WUtrfxMN1MHeMTDhIpHjzashHFeJcDf7+wErC6Bs/dkoXjtN0VniZbArAFfgn2l/Se/Z/DqT9OPDJarHHHH/riRTN+TztxffLuztvnyW+gkK7wWIDmXUABOLhT9swH4lgcDR+xLEuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m3tDbiSj; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m3tDbiSj"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e3983426f80so11951268276.1;
        Mon, 30 Dec 2024 17:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735607146; x=1736211946; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=m3tDbiSjV8dqsmpNnh2bce0IR2AXS/5S2RlCTwsPA1xfzEsqoKEEIMZi8T2k141egF
         pEShVG/GWeZ/PBBb53B0yiSmyls6xwxvk2QEI2Ec53oizZMvpKlprajWNkj4TYaJmFZf
         UgrNfVwknXaCimjIj9gJrUHTQyMfWfSAHRDKs/8VKQcAZ1xcphYpBvm3RGoTVW0o2Spj
         MVwTJ1qSZEKA3fmMQptw1c51bRv5tSPM5wbPHlggGIdX35+e8nt/toGcotxdzSaAAWhs
         6K4QScO8Q7U7TPdaQDaIkSauJxJFghIO/QrRGs2smQvR7BrC9OPJR3Rf0X/zCz/QnQKX
         PajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735607146; x=1736211946;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=PaCnUgxVc9NU3Rq95rOhtUrXMrGm+NyUuJtc7uLtCScwdiA1x9bA1ftf0IPrHBQsFv
         uc/vpAd7LqFLdlKCtOaaKI4c797vIJ/Gu62uGNsYy19eXnVoEcFg5hqkO8n6+Oh48ZoM
         RegeyBjx/Vz2VKRX++2tY4dFkP899mAvXt+RmarPYGlPvNZCG1mpT7M/SoMFfZKbpB2k
         5Uvf4hryzbeWYFGO9iM2BrCQBThnAP9UP+qo+mDGcOCehWKEq+DtyXgT7Vv0D2gugelL
         viQDYEAJRCkJlteJPdG4zQDSlsRwwnyAINiQPSxcoiPgLA1GmGIqpvCTeyR7KcswqK0A
         67OQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJirxnmB25LNLFdFwAwgKfpGPUw/N6m92zC32uKJvNbHI/CGp2OGHUce6RbWIMs/AgSzQ276IN7lkk@vger.kernel.org
X-Gm-Message-State: AOJu0YxjmnPZftlJccwAoqUDwbnf8joeLwzML4f5l/cikmPMFv5Ukrdh
	hpnl9xtPVndyOa8yCEGiIpds5vKVql4t+126gKhKLcMfece5yxSwJrH/Zw2xWIL+NtA7+Il9A0O
	Mt4WYQNxirQ28XyJrtjeu21GEEQne6pbT
X-Gm-Gg: ASbGncuGhiNWQe1wyRqAAwpvf5onBQU2iDfqpZgMXUTzX9cJoI0u7yUGjAeByW74Efc
	L8iG5ZmMB7ttpELyW7t/L7slbE9oBRZBiv7nbjQA=
X-Google-Smtp-Source: AGHT+IHy8BWZPBt2i9gw2CkI6xf3tszM1EEODEDDzO4Jz75+D+QVFLCePVRrqW0Kcoe1qe38ztojQM2z2cOnyGf50xQ=
X-Received: by 2002:a05:690c:6893:b0:6ef:4a1f:36b7 with SMTP id
 00721157ae682-6f3f81474efmr231319327b3.25.1735607146464; Mon, 30 Dec 2024
 17:05:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241228184949.31582-1-yury.norov@gmail.com> <20241228184949.31582-12-yury.norov@gmail.com>
In-Reply-To: <20241228184949.31582-12-yury.norov@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 30 Dec 2024 17:05:31 -0800
Message-ID: <CABPRKS-uqfJmDp5pS+hSnvzggdMv0bNawpsVNpY4aU4V+UdR7Q@mail.gmail.com>
Subject: Re: [PATCH 11/14] scsi: lpfc: switch lpfc_irq_rebalance() to using cpumask_next_wrap()
To: Yury Norov <yury.norov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Justin Tee <justin.tee@broadcom.com>, James Smart <james.smart@broadcom.com>, 
	Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
