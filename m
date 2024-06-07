Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC8313F43A
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 05:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717739921; cv=none; b=oaPvwmaBVSq5svwXnrz/uautsyWBIcJ7eSHCL3Oy/j/msrCqiJbE2Bl2p81GwiZ/aK/92H/tmoWUILg6LGMO0XEmF9s62WaFUWGyFSVVNm+QDl+15qYURGkeGz7zfjk4wJZNlyiUoXCsdfAiNIJjRXzO/oUJ/VFirCziSwwOrw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717739921; c=relaxed/simple;
	bh=IqUc/LKepa0q/uwKlIntaMoIeIcrlrSdWeXPPi4bO/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=toxCdQzx/88jGe4ujyiOTbfZ9uRshQzSNJd5wMuLb4hNG/NYE7kADvXqQBKTlFqkR1c3T9pjFICTNe7j/qSI+IVGfDqkSN+R1/V0VKf5h6OcDKPOFMmpFSvWUqN4UQcBLkqSv9ddA+BoL3UQXaNoW7E9eEiuc0VnOnO+Ufy8do0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UgkDk2p+; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UgkDk2p+"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-35f0aeff7a8so43087f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 06 Jun 2024 22:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717739917; x=1718344717; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WtwmJY3XP5Iwlr2y2eradU6tEjlICOoXybcdo1JN+rE=;
        b=UgkDk2p+5mkfDGFA7ywJlprlvXITCeJO+gQg5fc13mE4iubtMUj5zaA2OBqltJS9+K
         PFS4pgsA0u8YTb6fiZ/HbT4EzixhQp3LunfBMe049tZH5U5uwEoDgmvHT9Nzf8TgGP0f
         azrkCzE9aQ3uVTZO3MTvylSN3PobtFQUqQ8aBiX/Z423flinzKd7XMNxhVhXAsj0yJ4R
         6meF75bFxa3q9qAxyJrSU6LcP4qnkFNDnbJCcc9r+NHmCAvSoywo+YVXHi9DzzEI7BN/
         PAGLU7Ir9lESiiY6UMhSMh5IVRld4wrihHf9nkcIOImXTjBU5ZnG1oDMvjnAQHiK112S
         KkdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717739917; x=1718344717;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WtwmJY3XP5Iwlr2y2eradU6tEjlICOoXybcdo1JN+rE=;
        b=eHzeQ5pvdDZJlrAniTQqgBrPD1DDHFWgeU9POV7bv/fkp7fhVSgSQdxfRcDEJM/+Cj
         TAnlIysv+V/jKbU6bmaaCS+vazUn9V5nlvl/yOOz+1BGdNPdksXRBGUm0n0yu3zX7Q22
         e6GdX9cat5GXGxKhsAULf5jfu9u9hG6HgLjZnVy3+njyEKBeDvCeOWOoEAXHIarQsOXj
         6e8IzZfxAMwnTTYj3lCe2wvqHN+6447wnM1b3eHvWSPcHB9jG4CoWxkBcSvqaGmZJYn+
         QjAX+Loi3JrNrf/tHVOzYZo+ffMU+50UjGjzY4cc5c+qJdKMb/7fadaX4sF/OGIY/xEi
         zsJg==
X-Forwarded-Encrypted: i=1; AJvYcCWSUrsWQt0Dsm1DAlV4vp4j5yLzqYqVnuD7tya9PlcyqpcW0HIF+64XRN3x8yuHGVarlTvrz9gdfNIOUZOi5t97nEjcWA0OmECbKQ==
X-Gm-Message-State: AOJu0YxzNBKefOEitkapizlfRAX06GF9UU3cA9JsnVdeEh/A7NTrQKwl
	3LAh1BY+3BaOFjeaFLRnuB9z5Dw+WuWyNLWoD4L46NZS4IHQZ4OIAzlAkAMmjW0=
X-Google-Smtp-Source: AGHT+IHeYxyo/QN+0ENQh/rpaE6LyLSWsIFGkFDRX1cySRq3Xr8wqkHqhhNVXWIVIjFW1siP50TzmQ==
X-Received: by 2002:a05:6000:c89:b0:355:2db:a06 with SMTP id ffacd0b85a97d-35efed55840mr1279441f8f.32.1717739916727;
        Thu, 06 Jun 2024 22:58:36 -0700 (PDT)
Received: from ?IPV6:2001:a61:139b:bf01:c0fa:2aad:468a:2d84? ([2001:a61:139b:bf01:c0fa:2aad:468a:2d84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35ef5e989besm3208792f8f.76.2024.06.06.22.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jun 2024 22:58:36 -0700 (PDT)
Message-ID: <3359c8c9-4e33-4e9e-9ded-692ada3d4995@suse.com>
Date: Fri, 7 Jun 2024 07:58:35 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND][PATCH] usb: uas: set host status byte on data completion
 error
To: Shantanu Goel <sgoel01@yahoo.com>, Oliver Neukum <oneukum@suse.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <87msnx4ec6.fsf.ref@yahoo.com> <87msnx4ec6.fsf@yahoo.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <87msnx4ec6.fsf@yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 07.06.24 05:32, Shantanu Goel wrote:
> Set the host status byte when a data completion error is encountered
> otherwise the upper layer may end up using the invalid zero'ed data.
> The following output was observed from scsi/sd.c prior to this fix.
> 
> [   11.872824] sd 0:0:0:1: [sdf] tag#9 data cmplt err -75 uas-tag 1 inflight:
> [   11.872826] sd 0:0:0:1: [sdf] tag#9 CDB: Read capacity(16) 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
> [   11.872830] sd 0:0:0:1: [sdf] Sector size 0 reported, assuming 512.
> 
> Signed-off-by: Shantanu Goel <sgoel01@yahoo.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
