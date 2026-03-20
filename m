Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543DF29ACF6
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 20:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774039738; cv=none; b=jbJodLSaW5Gqvmom3FF4FuRnSS0nYdfJbJgUgkPIPr56lahjsYUaD8ULoHoSVUcHgXjMEqRUwKBrGf5KATXqQgHFOrIh7tEEfZtdqJ8ZSXEkB4Nvp38ZvUkxiPf3hHNJDyawJ+ir4ADbgg64vIV1ndye4QgcNncceSy3FcaXH00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774039738; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G4Fp9JEgmu3meLaAMPRlzgANCRt48gDW0G3DbtJFC6hAWYbukymWTc0SKsA9DGF9ruRbIgYipeaI3ygWHNPeHzSjCwp8flD4q+4lwCdwoTZE12YNHdUAm2IWa/MgdA5Iw4tflJ7Thm6dejBwVesv8sL46IC3W9n0Twnj3M4a/7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Afc9lio7; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Afc9lio7"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-899ed41208fso14315006d6.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 13:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774039736; x=1774644536; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=Afc9lio7uWThpB9fQcOrenMU96PgvimVM+exIDFTq6pbibE6LGnaXWDCIRvd0MFTul
         AWhLe/RAwyxWNou3zGpIJ8GDpf6RayBzchsYnknz/p6i/tTjH8z6Ndbfnx4RtORlbxbp
         znyEHAY1pTDjcnl9Rr3fc7uEhQ2dXg4O4J1e0/XMp0whjf/kbf4Y+mayfERRwnDfCo0J
         arbAK8DORiRjLV+ZzGx5xh6ygpPHNxplZY1qxXeKqd+pjyt8z5MgUNPcm6V2uqT1KJ7z
         KI2OChBkrauV3ur5hqdsyOR4G3R9YpvaARHDpoIZucprFFHWQBWgzWWJfX/oFVsbCQ1p
         qiWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774039736; x=1774644536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=iY9MCgT0VY4q62hMCmzAviZChiPgkC564S8VisEZAzKwkaSoNulZLTG+rqrZ5bpum9
         ZfsblK4dmD8PUFlzbPjsKpYyu11SCusBV7KSGceeB7o9MIKXDRjj7j2iVC6vjMxfMzW3
         TZoUH210vUUwHvqx30Hi9lq93RTCttHTeTFxSmWegfNxRuUX7zCqnoX3Zk1RS8pbqYzf
         NcAF+KJHrs8Krz9p5kO9vDkndieTfSP3OevZwaBVn0Tuj6GI0e19wfQkoJTBw3TL7j5V
         2JuXLmCEgVkpkxZ1WuDjpqZhFO6nAXCfXqsORgA48oO8gtoyWV3W7B25CR71ECDAKK1R
         XiSw==
X-Gm-Message-State: AOJu0YwbB7axvjD/NFOWdSo2nAsyPG759rTwAX7gmDzoLo9ahzR0dmQA
	IK0HqJ9vJwM/JJX+AbTfF4E6FmDsTaEETzqyvLBgxAJbeeoIzgRMXWdl
X-Gm-Gg: ATEYQzwOiZ0V98aOp/hK0oc8iKOUg4SJMeoExOD8wzl3BHFq/f4iz2B9345u4rHhiPQ
	3RMAd0Z6hr7uf8gL+l59GDYJ1REEY3N5e3qBQF9zUrqp9Ic55lLCkpX/lwxO+7w4VQUKo1TPjb1
	i0sXiTUiwlniyOkTqswxuymqSUuARL96zSP3NQ2KjbNqzpd1HkuW6KibATDn36EDW/gvecPgqfs
	dI5Zdf3dTEDEdVNZHuXv0W5hndKHD5V5U644YQ3Vj+QlMbTE08kJMq2A8xcWoK63iEKxsDU3B29
	ZZKH0ZYY0YFkxIXFJx8jqLi3iV62lX9JJnyu3xCCowEXoWQUWZT98yl2DoF6EVceEv6dX0GM0qj
	nsv61htg3JJjxTo1II8tARs3eVSf0z3EXvV3JZTZZzZLCIPxDwmaskFR2ZLbBr6Xwv01lkUl8Dx
	aaZ7Dmi66zx6z9QGrQPA1UHd+0x9oKaFi5CQ5xd2xHMz215NVV3tFOHwisYoARR02T4ZFdzhXhR
	g==
X-Received: by 2002:a05:6214:5e08:b0:89c:8681:36fa with SMTP id 6a1803df08f44-89c86814fffmr56368476d6.32.1774039736232;
        Fri, 20 Mar 2026 13:48:56 -0700 (PDT)
Received: from [10.69.77.173] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c8521311esm29456526d6.7.2026.03.20.13.48.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2026 13:48:56 -0700 (PDT)
Message-ID: <398a792b-ca68-4339-8af1-fddd0e3daf51@gmail.com>
Date: Fri, 20 Mar 2026 13:48:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: lpfc: Use the crc32c() function
To: Eric Biggers <ebiggers@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260316223631.72361-1-ebiggers@kernel.org>
Content-Language: en-US
From: Justin Tee <justintee8345@gmail.com>
In-Reply-To: <20260316223631.72361-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
