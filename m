Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEF430CD84;
	Thu, 28 Aug 2025 18:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756406637; cv=none; b=bfUMCjHrwp2K+njuxmbGQRLdgG+bpb2V1+LgAFevO9O1wJu81fcumfBTDFDL82wTOHn9ZaNVm4Oowp68/JJz3MSjIWqkEE10WyLoF4R6YYeikPFKIYrK3J1PltoOZQ+HMpUM0L21dwrZUOfhIKhN+K1WGJqDuZ6ZZcX7gVNnq2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756406637; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VjHmg+RvwbQKWAiaQDhDpDgc3Rh5+PrjmkrvEyGiNu9442kI9Lo5uBES4r//hBcB9BQ5s50aSfHN3F2wKxjIxxsWjT4i6hn44NssFm8tRh/xZU+VQapC6looEJC9hyA1RSUnV0amgaKDj60Vhq/9kHeEOvIEuXKctdrSZ2f0bFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZfKw449y; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZfKw449y"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-71d6051aeafso10570587b3.2;
        Thu, 28 Aug 2025 11:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756406635; x=1757011435; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=ZfKw449yFTzJQfQF6zMm62wpa07fDBROpxVboHH3cjh0/wtFFETzJ5YqlhFLmgPwk/
         1+iy8wEWDVHcVoL7DlKWFc8Y57Sgo93iZN4YJ9/bZAXhLeXEKo0gjslzZz9R3WZEkrYs
         ghmWK2skrardUa4X2PlsgP1vIpqgn7p0vkNsCoJuIbGS7h7fjBNCWevVtPJmaSIcJH/K
         E+B4M5Q1ADg8EcY4Nkxy5bhcMQQMxwc+eg6JkDhvXmHaNRe8iHIBVFZWUZ2Kdj/W0kd3
         531pXxQor7B9caOYCPVRAQ4SbdnRRVRcC1b7+mbPz69uu+C2nZodB0dKjE0eB5O/i9Ha
         5qNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756406635; x=1757011435;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=P9RTzvnBBL636L8+W06RRSZf7P3YZPM3VFFxDMxAEhMQ7vvZwHOtb6C/MMqjiM17SF
         bBcAjVmHtOnQKV+IcW2L3kMoVWHxwPNp/E3FtP5VDoiURfM6MfodJkG/QRzZ26w+ggvw
         UpsVRlhPGM+nYTizD//o5tg2AGd6WyyVaNal+mOIPBk6qFX1AIzEJcjfRvfg/2kiagY1
         gpsjYlKOV4/5xMkZzDvQgCPr0UFKWC15fpStZAewLsHkBFO1kZujUdLaBM0nb2xj0SX0
         OjLydFt8SZF2nmYxhJ+To1jOvZ/Rrhatx3k+mKnee9UXRxkV/g2yReHM0w70O1ZRkhoK
         qjOw==
X-Forwarded-Encrypted: i=1; AJvYcCUqFJNiAHxtmUrvldwFo73wDAU+8E8TtWrVrIwRGGUdGQTIAuqFgzAqz6V2WzMUB+Ygm4CyOH2ICMumGg==@vger.kernel.org, AJvYcCVlNcYX9nFXls0Yly+jZ0m+4Whq3ZC1N/jTPakLVxU1fpU2n5wfdPWSu7lLLbGvtOfZLZK3iu5ynNdjmd0=@vger.kernel.org, AJvYcCVliVGiF3ICZNv71RUvPE7hO1D3K7evp4yZ8HjPs3VzoRfw8sXx6YPyVp3X5M93Iq2ZNlKdq+HV@vger.kernel.org
X-Gm-Message-State: AOJu0YxoMk6jK+HPUGVEPkDsEdPOzPP7mLd6eYgEYzlor+nsi8yOG5qX
	baRthOUEVtBrqRg+Ce8nf1Jv3TrjgY6Xhn5+4FMYUBQCbX1VLwNlCdxzlAdYFGUfl2LjGZUdH1M
	gpwmS0etoTeboLyNppu2CpSIDwqQDDRc=
X-Gm-Gg: ASbGncvUXSBhiviwqesD/Cr0+ddYH6qzkDMcHrjAYbn1lutzuWNXDEsE8JFAxKyxuH/
	819v5rTMxXTB3oxQ3e6tq+rzf+rAbcFFHcnW3yedxJ8CEHOZdm5R7XpiFsHAUbNEu48E/tqJCO1
	ry5En4pDChbfXSwXaD3AjFNvEfkV8D9878LWMYJQ6mMG2KadprlT/KR4V9CBneER2iDuC7tp+Oh
	flJc3R8
X-Google-Smtp-Source: AGHT+IFy63WMeZNhOuRDVpfQOR+pfgibyhHVjJNYLVee/M+lcgwVVswCucuVjgttdjmHIXWzZf1LW1ffV+ApiOKukuY=
X-Received: by 2002:a05:690c:4442:b0:720:bb3:ec31 with SMTP id
 00721157ae682-7200bb3f427mr206360037b3.47.1756406635372; Thu, 28 Aug 2025
 11:43:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250828044008.743-1-evans1210144@gmail.com>
In-Reply-To: <20250828044008.743-1-evans1210144@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Thu, 28 Aug 2025 11:43:31 -0700
X-Gm-Features: Ac12FXy8pmO_hIDFfsZ-8mDU0Ugusa134O92VRib-NK2xTbN6UWn5KwyYADjHbk
Message-ID: <CABPRKS9N8ZVpJWgy9vhNCO2_nPPghYQDbHMK53rELWnF--D6gA@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: lpfc: Fix buffer free/clear order in deferred
 receive path
To: John Evans <evans1210144@gmail.com>
Cc: james.smart@broadcom.com, Justin Tee <justin.tee@broadcom.com>, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
