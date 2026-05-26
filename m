Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89193BBA1E
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 20:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779826516; cv=none; b=QDq8/6NiS5yeEKqiUVeX4gDibx2MTNxUIsUT3z2faRMmNGOvF+ps+A6uIaurRbWiWKoKSQjHwDqWqPA45Gos6iYxOybwGbQl0hM1Oi7v5zpPBeFdR/knxtFWSEc+liB+NV8qtOZPm0uNRsXgmpdWkJGdBKJtGefE37o5yc6zMcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779826516; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hvYg/7vQ2m2vlQr5L4VtApgsqk/zzmY/xVbOL2G+xzxH1YL5oN1jZx+asjOht8V4tYhgPVqeM5UzVhGY8kxBk1CV4IATUS15/rkYOsaBddyFDzHmI2JHEt4Ffe2ix8F8aQEWFBHliRiT7OOFY+zYOrFRw0kUoudikeNGKsVayqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DvQJVXtf; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DvQJVXtf"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50e5bea4045so85182171cf.3
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 13:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779826513; x=1780431313; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=DvQJVXtfvmIiB7kU2Wf0jAd+WUo6zcDlS8FnFrYlRleU+yRXaAXljxjhQwEAAcgi1U
         zsN3/x8RLzjb8j5xAdRyikTUzjI9bR4dyhmNyWwDBXQPKf8rm3961sLgilXMSoteUJ9/
         uXDSuZvE2fS9UJerinoh96mSXFFWzpxFPwjPKL0euWRJHc5R4p5JPwFA7S3rD/feLIVz
         k00mO51waHR2XokyF6uQAMvDi6lOV505j/GQiArw5F1GxkBT8ucMYmt4vsyWD06clJq0
         WR1eMpeaCFFpBnQU/MmHLzwfiYFJKDoRJd9VSXwP8BizpJRdPJwcnLAeQ3FEx6/HsYN/
         UnrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779826513; x=1780431313;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=QTC0/em9ZyIrMMNNKeX/JN0LoHEBN65j3j8QUSC43LbimxKqNTYDwRKWV4MvzSfp4l
         myEogpGfkFltjsce6EKWIli8Oay00BJC+7+E5Qn32Eb7/UJPNuqNen9V7xBRB7FS/4Qb
         54Yajfo76mWAX2J4C5usdkMLtAxZ649IaYd+78RAgZhF6SPH5gy60KWxYHQo6ZKboUWb
         JZMOX++yDBme6Du2Ghl5D6PQEA0MX89UAl5jQi2pFZKsZrxN3z7Rzlsvqi6RC/64+RM4
         e0ElIAzilC1ynf81dhH0PQS7+uqpv+Yphgz4+DDy3andybmTpdzvUVNaqG25Q6RJOLhg
         txiQ==
X-Forwarded-Encrypted: i=1; AFNElJ96aNqG4pzw4ZlZcc/RMcLxi2Wg40QwuVVIhF0RpZLgDVdOwHI0NDS9A1WK4CY3iLUYtZt1RNItWdSY@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4lYLlwhX8MMXTRYWFgSTZyVnUAY1aoEtAceh2qFvkc75c1zDO
	Qnr00j5MZH1bH9TVONOzrYwj9bW+UlarnechvrWBb51yEcPSyn6QarFO
X-Gm-Gg: Acq92OEbmllSTmzhxGNCDg/49GEkdKmSfrYnLHto5HGgJWdKmMnNHlXBLO3GqLTTCGQ
	+ux+rqMHl1Pj1Es0+uWZONe8Jcts1rz5JqKchJ4Re6N1EF1257/tmYk/vyqOPofUraWOW6D/b59
	f9cXWB3RONDgmSB3+KfnvlUIOtPBzOjttU8HwKyotssdN/3MzoHLRx1VFfPvf2BBsdZ/qjjqEgJ
	/1+T/bvRpPBkA+1y13VeDIaA0dY+2Y3dzSxDpXIC0sez8844rdhsQ4kcxHxWgW447cIgJcpLNZJ
	cO+o/BKhQwwr4PUgFkAXBpeul9ycEcJzLS/Qwop/8lXzDKAAk5TbIjwkyjd4Yy2y+euf7yF3FTo
	18qWT0rxZCTNi8h3It+mIDWc+12Au9AbS2gAfKcCOfmpl/CmEU4ZEcIqlzf1F0mB0tV1UiOigje
	UNCIUAFZq0wv1yCvjx8KjA4UnD+BUw8Id2KPcC1w38Wei/b/G2ZquA2jYC+dW1CEQ62wsLXPr5U
	bBqvg==
X-Received: by 2002:a05:622a:1b04:b0:50d:9c60:fe2a with SMTP id d75a77b69052e-516d43dc0ffmr281713131cf.1.1779826508756;
        Tue, 26 May 2026 13:15:08 -0700 (PDT)
Received: from [10.69.73.149] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517069f2d2fsm30989611cf.3.2026.05.26.13.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 13:15:08 -0700 (PDT)
Message-ID: <81f88141-3e6f-45e4-b2ac-11e1602b1933@gmail.com>
Date: Tue, 26 May 2026 13:13:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: lpfc: turn lpfc_queue q_pgs into a flexible array
To: Rosen Penev <rosenp@gmail.com>, linux-scsi@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260523050241.190239-1-rosenp@gmail.com>
Content-Language: en-US
From: Justin Tee <justintee8345@gmail.com>
In-Reply-To: <20260523050241.190239-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
