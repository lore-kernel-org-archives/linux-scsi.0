Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561F72E7F39
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 17:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782150133; cv=none; b=AxQymvbm+R8Pg5uNq3CRL5lEvHLmsgcu14eaPAZObyd9OMsfFNyPJ4aHe9ayGFMRHNBLNaEX8zeZnpJ9supcdVW+CKuG8ZIpyNPgEkLmd6yw+1gDYilKK8kM/EMpzgNKBiOD76ZH39MTSsnWxhyDTGPNPQRWBAQt1umm084PNLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782150133; c=relaxed/simple;
	bh=QH3KrRoWJuIPfFyEQs+7l2o1gbngwfwlpX7zx4wi2yA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EcL0Tdmlrz6qfD9L4hvPL2Vm/Y9xUgNo0nMzOmCeIw6y3B62Md2iMk+EyiCVrz3gwtlMvR5CIgSa3y6gLMjvA4wvud4W8TDLj1xqf4a9zP5jggISqzCgsiiAvsSKWy7xW91r/38gba5dBU5ufzVIsi9l6lkwCv/obn12hVFZ1sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sdw3hmTD; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sdw3hmTD"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-30bcdf8232fso9910416eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 10:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782150131; x=1782754931; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ToB/8IE6VikY/NkfvlNd+aqZ/ZSWB+24gFF6ITZVopQ=;
        b=sdw3hmTDYJeyZQFv/dPIScq6KHCArOwTaEx4X5xjGJeRlOjA1BAH7bwFP5kMZwOf49
         PXyYDOXh0xslbp1tydUfMbBGB8QGMT3+qI/J8gFHkT899LIX5UCtLQ0r3RAX5vblRStR
         5YeoeiZr2mvuGCDyJDQ0t6aDzTa/rB8P1udqw6tHqEC4NTrpvwfjhmuD+bVU5Y+f0Zkb
         8of/auXMW2zoqY/o1FZTPs7atWJhypypUC7GAvbAm2AOo8tAeT7RvOa5953VmTYb4cxk
         okDOO+IlSFTHuwVcszPV8w7FX57DmSRe2HyXojWnRBWozX7iTOiD4rXWYFNpLssy/aRW
         PqfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782150131; x=1782754931;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ToB/8IE6VikY/NkfvlNd+aqZ/ZSWB+24gFF6ITZVopQ=;
        b=rQaBIL2IHKUDfW5fRS7MKAJBftPTA8ognea9kCB9WfBSsT2hwvf3+NEORtx27+ZkBE
         6JFZGvx+VoSNUiUbnN3sWSS1xb0i3ekVmZjbb1ICdK4D69y1SXOu4BsXzbiq7m+oic9A
         i5R4eaVryVUm9hSlW34RVWhd9yQ8Un7I2SHnsXE4h6y63W9xZ29bISnFA3JHVTozLrG9
         gHw4ESUBWl+XIs5qVDXTgxAfVO8XDW1QYGIPATKgBC6lNgPIwjs52h4dKYVutb5ccpD/
         wancEZDRA1Ah1z8duacM+oWo68JmCetZE4I5kB4ozd294XKAXdkhPSJYsnXvASkqh40O
         a0qg==
X-Forwarded-Encrypted: i=1; AHgh+Roh6/l+s+Nq9jX8ya1GPc15gnNCpx6jOixGiGPf1P7qglVVoet1gH7JimonIAbzsAWnpJES9kxR/nNw@vger.kernel.org
X-Gm-Message-State: AOJu0YzrcQhv716SdbBBUSbLS482OqRrJ+0ef6RUH5xayamVps4BjxDg
	/Dg0iziPrbMa5udCeZLKsyh9vXUOv/NAtT04GjmttwQ7aMDYF9h5fgUG
X-Gm-Gg: AfdE7cm4k4+W0wuSHH2yINUlCC7CzO/35N6cpAUOeC92sr8p7CEELog+x7Ge7hqm0gn
	FnUsS6lHqK6+ig15Dej/fcK1xPA6uqVW0l1Gsp2OffD8csdTQXTtcRG/VCMC8JYJ6dgECQ0vFpN
	N+8QaZgqbF0iRnMTzmPjcAyIdAbpjQr2rwCgigoG9+BKXjSxP7ZxY/jKq9GQ/PE1eAjzK/XC9uA
	ers9Fzn2mMk+tJtpOOkkqJQI9GtuXWq0+OBS8x+lyb8kUkRgU/A8ifYyXXl132XHM1v+7l814rI
	7VTZrTfAZ1ioBwWgM6ipGCnIGIMVFseu5eHQH2bIjR9j3L748vVUqx64zBttnsdFBH5mmowfWjN
	59g9w8LnqZ6uez+kepaMHeeIJvbOKB9Uuj1fXo7rHIxj+Ks3TjbLpL0j2wUovkAdpqSBhPnt1G0
	TD7fjml7EIf6PuSyMj/zYHp/sFqJjeMUIhdnjau1kS09BIa/kXovCIEy7VqET/g5Ys6Q==
X-Received: by 2002:a05:7300:5b89:b0:30b:f888:7821 with SMTP id 5a478bee46e88-30c070387a8mr11480846eec.28.1782150131326;
        Mon, 22 Jun 2026 10:42:11 -0700 (PDT)
Received: from [10.69.76.39] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c1be5c5desm11114785eec.28.2026.06.22.10.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2026 10:42:10 -0700 (PDT)
Message-ID: <82be2f83-5454-47cb-8719-b259209a5e2b@gmail.com>
Date: Mon, 22 Jun 2026 10:40:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: lpfc: unbounded QFPA response length in lpfc_cmpl_els_qfpa()
To: Maoyi Xie <maoyixie.tju@gmail.com>, Justin Tee <justin.tee@broadcom.com>,
 Paul Ely <paul.ely@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <178214622623.2376914.7843191393281628987@maoyixie.com>
Content-Language: en-US
From: Justin Tee <justintee8345@gmail.com>
In-Reply-To: <178214622623.2376914.7843191393281628987@maoyixie.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Maoyi,

 > This runs when the VMID feature is negotiated. The attacker is a 
malicious
 > or compromised fabric switch or target answering the QFPA request.
 >
 > I reproduced the overflow on 7.1-rc7. I ran the same copy with a 1020 
byte
 > qfpa_res buffer and a len that makes len + 8 larger than it. The copy 
runs
 > past the buffer and faults.

Is it possible to provide the fabric switch and target hardware details, 
i.e. model and version numbers, used to reproduce this issue?

 > Does this look like a real bug to you, and is bounding len the right
 > approach? If so I am happy to send a proper patch with a Fixes tag and Cc
 > stable.

No, this does not look like a real bug because the payload comes from an 
implicitly trusted source within the fabric.  Hence, it would be helpful 
to share switch and target details that this issue was found.  That 
said, we are already aware of this through AI security scan warnings and 
it will be addressed in a near lpfc version update.

Regards,
Justin
