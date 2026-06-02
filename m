Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF43A373C12
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780424065; cv=none; b=Ftv/0M93crcQFWO5ytndOp3px0gcVAJhloif2HWYbZ8qZ/bzSxbOsY0mp6y65ig1FAR2/BtOWusbzJBVIScg/V+N6btW7Pf7REvuXzMMWiCWVGdwuniOJ8P6PUbKfRHViuR6kGwB+c2sIKvQyv/2oRROjG0oN6qF4nUOBhca7So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780424065; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TSLHOCmSvqmfYdYl4PjbGOa05TVls5ZOWOWuZTf0e2a57/104IUk7b/EdWePatsVsxloNOv1TAnLjbfBvQfcGhMMaO/e1ocI5sgK/z8OGPNDunEP5G79R+ZblkqHHc3b1kJ7y9PPfe/+bMNSuJKI2LcFcMn9O+3yPKx7egl2uY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A/+syUlK; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A/+syUlK"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8cce8873b56so42287546d6.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2026 11:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780424063; x=1781028863; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=A/+syUlKKP71tPloX7+GQmKp1OJ96ahWPQoTfuBh2OdYpbrZ5oGuEXCV2HBN2lJQsO
         OgHWso0IJePe4uZ6lkoVA1BEVwA5eYCbDXccPOonD1H+yKnCPv4ueKL9MZNRbtdCrSmm
         g0xzwLNta1V4U606JXQ6Le/Ykw6LtX1kZ35A7CRMpbbc6gWl8YBKEc/8+Sz+dAUOcxq6
         7Z22P469LmwWcJ8DXybLR8zDKgaP6wZeXAQ8acNs2BFQEkiHYAyX69oN+vLOpekcYsxS
         M0VALD23UhA9WYr4zhKpO9bF3jdb7bjBYM0XmfV9W+YRyv8nX1jNmHPLSQCYt29lhXvV
         KfLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780424063; x=1781028863;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=aFDqHKXW2VNY9yK/rxFvWtTfeqATgUjb1uYTi51JGyPUAQPQqH3fQIX/+YlnJZ2usC
         lun5uE1C6vgq+HD18b5ULJ8Kp2XK91+9ioZ26wTXOgt2cJzZLTmHv35ghpmkQJ87+/OS
         ptktW0MIhMhMvxPd4l74keTGytSIrn3/pL204S+aucvf0x3LEEiX5n0kFk6LiMwSRAfl
         EJKn/c5oLQGtN3J3klv1i6F453oQ1Cd9KMP4fts6BwMa4LKBXl0FR8zgE8iTa/rFF1an
         M7Wm3eEhS6kCBSxYw4UzjVehcrDrbjSEOkOD+38I4kddOeuUM6C9Z5v/BaYYum4sqMco
         651g==
X-Forwarded-Encrypted: i=1; AFNElJ/bqfMck21ZyErk5eJQDCOeIDEVjV3l3HTGoXMSJEm6N1g5fPFTsrdq94fieuc0JgW+5pji08XS3bhP@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1sXUQqDIEr8bFHI7KOEgs8K3qT6Vmow10MWFT7zAxIFd5MiT8
	7cWAZWo45r+VENB2OBwDLtqruC2isRZXQNEQ7OSz0PdwmRKdYrfgQtxT
X-Gm-Gg: Acq92OGNXmgV5bCYP5o/kw0HqNKiSETNlsP0Gh3GIbGwzyX3UkYeGwMkux7HJsbCyNT
	dZWkLGMcOUaR0Ri87QPg4OfavHDH2b9vECtMh3eqzm1vcwEY98nhHK/jHVrxinfmbckw36rnG9e
	PiySZbnyYNP6Co7ctQmcVx87Kn9/kYIsC5WksvLR4f/GMBJAG1y8bUYdb6NGJXFX2xTcD+w+4+p
	XA2/OhzI1N7a1wJmT+XEyaQQVRNbbpkmaSR22JXEyPPKsLV6RBgT5sACpK4N2IqC/gJ4FeUXG90
	OoKhmmyU3HqMt34TynnOa1WH1kqcExq/WFjl/yX2KhEvbr8bqgqDTSpAyShjG/AU/EGiwRnk/O5
	gmx64sP0QTwPftBS3fUjh3XjRAU6M+hdFvqGWA4Pc31DK6bbeKZcLRPea5ZBDhhkAETXcJbrzLp
	ofFfL+Ea5jFiexyDZnuOgiLViodid72oLwhJxDRyOIYq9BM+7fPEeSfoYTbNeCb6afanhJmCYUg
	NmKRcSbO1yN+KE=
X-Received: by 2002:a05:6214:53c4:b0:8ca:1102:3e3d with SMTP id 6a1803df08f44-8cebf44ad91mr73933916d6.13.1780424062730;
        Tue, 02 Jun 2026 11:14:22 -0700 (PDT)
Received: from [10.69.79.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea0635b1sm127984846d6.11.2026.06.02.11.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 11:14:22 -0700 (PDT)
Message-ID: <d4b37da5-27b5-468a-8dbe-5b2b9135c422@gmail.com>
Date: Tue, 2 Jun 2026 11:12:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: lpfc: fix spelling mistakes in comments
To: William Theesfeld <william@theesfeld.net>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260601202001.651088-1-william@theesfeld.net>
 <20260602111912.23864-1-william@theesfeld.net>
Content-Language: en-US
From: Justin Tee <justintee8345@gmail.com>
In-Reply-To: <20260602111912.23864-1-william@theesfeld.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
