Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1064F3176E3;
	Wed, 27 Aug 2025 16:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756310886; cv=none; b=KT2hwtWuylie7mok407gDKkYUG1jcPmF7eA2iFTo6FhDxkNimCNeDzC1RToWU/1O9JL8audujVtEZm0z14M+5bkCgfzQTtyCJWlwellcegKzwnlcA9VWIdu+0Q0vspFT1ZVQ1aRpPoQI+4VF1JRvsWyh5+LaIr0iXMXIi4I+V6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756310886; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FLyoTs9fqdy1fYU7CfsbzyYhBw+siGwQe4ncwqjQXEbfVPivaE863PPQbpzQdobDreDoX/0bAQgoDiG+gTyJCPAaDmxeDi6eEwnA88te6SQ3mya4B1uwDgq9Thczs2FYQbdms6Prd8JJgkh3Pd2JHYws1X2oVHaYCpaceYOytxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MFmaoO5+; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MFmaoO5+"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-71d603cebd9so74521267b3.1;
        Wed, 27 Aug 2025 09:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756310884; x=1756915684; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=MFmaoO5+fLMye4h/UhcJYvtYkeHfeU6TgIAVELKkNYf35va7RiUQ1WH2/toWcgMRBP
         qXfcEdcETUhighjx8zWTL4Pzp7+Jx4UP4qNu04ZKW5S3nBAmmAa6G/CpmnTq8IPAZAST
         TQkoZMRBQuvWdljNKWrPwToxRXbMA+UWtdfZNAt5XgF3Qn5nyGHyrWwGfC1NgWxE+Rq1
         GUFoxdfV7XcL1lvniWNseY8vGTIUroxcEMznLClwGrby2TRNCJO7LlRKBag2bmByAnwR
         9Rsw8omveYdtlYtMbfSnFAcRN17Ztoq8C9rFR4orQXg1Zh+TgNZbTU96vWk5CFR+ZP8u
         AyQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756310884; x=1756915684;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=asBw/H6yJk8C3jk67skURG+9nhqtO8dhwV0j/A6WMcQNYNVnovzQrH1h41EJjZpLSM
         ZdLONZF2WqBqOp1RiKDsBKsHOI57RqFdm3ox0rwEVZiJlr4mzL80rw+9DWytjRJoQZLw
         Az+dnExyQ0fDwMFSR36U7RGDIf8FWm0UyAwPgYMF5t1TiFJ5dW3KlfS4K6BF4cNC22qh
         kDkZbm1+srata7Jd1MMuSDGCt2BZpRMHpkQuOCE57n0TokPdTdVU1b/dZZgEdNa/o4Db
         p9OCRJ35lZ3bU6Izgruhv8Vqyl0cj04fisH2nwC6Hhmxbiy8mLbQR24eo/Lv4JMnlJYT
         rfrw==
X-Forwarded-Encrypted: i=1; AJvYcCWWBdqN6WWFSplcgL4UrnF0nbdTbc6cUb0BJQ/xuO1sbgAb8QmvKymgmr077JgMqXBxWWlYbaZUl7YMvB2Mqdc=@vger.kernel.org, AJvYcCX+iJKX/btPt5+S6sbXy1cEIFHndxWkZ37KNAksL5Y9KuBOLPypxlFi2ZDH3dgDPG5yPpNzqcHgsx1/Lg==@vger.kernel.org, AJvYcCXyxswLIMdcoJi92gUIi4eIqEYCEfhFfuKRjdRDTRRt5eUVyp/Kmtr5VnF/6hVe+5YMqgJpkhwsc/n129zx@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+vgtZ0fpI6D5C8PeaEfU3aW/EQtX+Hbxp9ouGaRfANgjAGAl2
	iwZ6QOwXiEj0h0Nz4d1Les7kjLSYn17eWlA2HlB0zGbRtHgXTPwt1f3d8gN9e8cB1yHKPMKVKWC
	LGGXEqh8KHQRqnPbxc6ppouRgvBVYG8vCOawk
X-Gm-Gg: ASbGncug8/9RL3sHe618hWdBkBEBIKlUCiI+gAb2DPlBFpB6dxlFu/xFlmcgLht1ADN
	hVmKTy6CWvMhyGxbUWAUvtxnna4wUo3iOspcp6xx+flhcEVAeD4jlgWql9CHmblVHpUkIUWTXV6
	vjqnbdzqv/BpExCDtUzwpfl6aITzN50ELmHWYVU2UM5Ln+Y4vRm0o8uiLqcrHlaOmIR13gpVT9a
	s5SD7nm6m+FKCH8wVs=
X-Google-Smtp-Source: AGHT+IHhWZApQJf8beg6UJ/2XJqt2rVIO9kFhrGWCFb2fQ3i7gedFrTgbIzKalZ4+LrpLfrbEVLJsP9EpBLFSK6366k=
X-Received: by 2002:a05:690c:f86:b0:720:5fbc:20c2 with SMTP id
 00721157ae682-7205fbc3779mr151770777b3.36.1756310883816; Wed, 27 Aug 2025
 09:08:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aK6hbQLyQlvlySf8@kspp> <020f8c5c-c9e4-4ad0-8052-a0b182ded92c@suse.de>
In-Reply-To: <020f8c5c-c9e4-4ad0-8052-a0b182ded92c@suse.de>
From: Justin Tee <justintee8345@gmail.com>
Date: Wed, 27 Aug 2025 09:07:41 -0700
X-Gm-Features: Ac12FXzYmfdpT-7M3izWgMiP6gup4wu_VmM5HZxYKNrgGaT92_htX_7P3pXBtm4
Message-ID: <CABPRKS_O7HSvb2-R2B7O64SYmy=n+-E6GdViQG5GwGv3S=8iSg@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: fc: Avoid -Wflex-array-member-not-at-end warnings
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Justin Tee <justin.tee@broadcom.com>, 
	James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
