Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38544A8A29
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 13:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466325; cv=none; b=toLi4uOuBgAFJ+Pp/fCozY+5y6b54nIcbyKvuQQV5fslzL6Qpawf/6WE9KaFCr4dNbwDHHjF6kbRIkdvN3YKH3yCM0K/dMim7sQH2QuX8XMXwuDbxxbN+sOOp+OZE3WfZJQ3xLKlOsfyw8J2nFFgJjzg9uI/ptw7tVlKfKba59M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466325; c=relaxed/simple;
	bh=Q4bWILpty64faa4Itg++N7wqOYZAwlwGZPLJbsqOCU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hu/nKv/eRer814mpwm2xhoshSHaGsbW7Uz3g837Sb4xOgITOb7usP4r9lQuluIEBlvfHkcSreAssJLOpyb4lre4QdnryJDTzarR6QQQ34/bh09ljp6U3XkFCua8/VmI7MD9xaTEwj1XxyWLEY7wYpKCJPQJW0EujyF1FH9VgrhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LuJOTTFZ; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LuJOTTFZ"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48b0584ad71so2039650f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 06:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791466322; x=1792071122; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EF0ORxL9xRoD8kTXGFBu2omdDiiROF2S9Nk6IzMT2Xs=;
        b=LuJOTTFZsqidX0nbStyM9iRdRhHlv4YXvTfjxkPt8Zwo6ETbE1LapW9svivhat3xcT
         t00q5dxRW6+ASmrDz5mAWfF1yerAgDFIaJrup8JXKdlVkusLvVaFlhoT1dUPjK07wIHq
         lSO1O4WebEUDdfpFJVShYsqMIJQmPhft3rvAjsRpIchXHZ+zn6auWlZz4XHPVODsXFXP
         hV7zm7QYrOyQFo4UsRsJbba/njnEEhstIIjtu0CaqsxiA08kvGLvoVZ/nJymmHFiGHYZ
         juOvm+COeUlFuZdWUVeReMvdJynLJc5xI0+EL92EwrwEu/biry/LcGU9jgcJWnq/IpzW
         dbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791466322; x=1792071122;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EF0ORxL9xRoD8kTXGFBu2omdDiiROF2S9Nk6IzMT2Xs=;
        b=iAUCrrYoxUN/xZa6q+yCopldUowDMarmCsZdl7vtax7jVapbDAtmSWOnFtzdkoVBtC
         KXC8Ij5AyJc1cp3LdtMCUF8xvXBaXegEU+31GT5mYec6cS6qVLHuV+Bn7Am/24TqHKeE
         2mqqylepbPDjwr1vnTJqvrx48U2mIqPXzrlf71m1xsoHw3pX9TaiEdXcLDrofizX5x0Q
         1FWlSwgDh5ZuwgYuLSCN4lmYK2QWaTZOuYWfqOeo/u9Fuj1s9WDG7AGHm0DllcldpG/Q
         c3eiM8nlxo6JZhlZ+sYFLYEL/M2K6vhRQFlz86AHG77nj28ZrTyGNlGe7xHAIgE3vjH7
         qCTA==
X-Gm-Message-State: AFq9FYJ4WkIjzVw6IaJFGU/zOmAIwxqyOvYIs016JWGZDuEnlZnZk+yM
	wlorJ+kCxRWvYDZD/mJ1W4QL25wc8XZVyXfy8WNAkQSehQ4iZJDKTT8h8iSqadURDd8=
X-Gm-Gg: AYBFou2qhI+Y1/I+1XrzQa1HgBpxjpDrwf3rHClXLTHW5AmWuiwx+OpMoeGelZrYdPe
	QgOttCSQEhFP8neSp0U+XL/Mi224M2nUnxDk9oFID/9ShctFjgbaYc4z8Z+KSwj/pUonMdr2Zgm
	5aoQ5pKtloaWHAUAA9vHOzPwyH0UCkmknhw7djebLDfOnDGTyotQZoTwak5pTpC6uoD92z7Speo
	K+qqv7+KKTN+axkztXSQcterz+JK57AstUqnp2AWBZfWAH10Jsd+6/hLBFJANrLfuPuBRk1QYCp
	h3YZH37KriC8HhHJoKfCrHgB5oxcLAtEEl/EQiD1aY/LZwcfJZRy2MCxQMDpaY9/eclxz/aEd1f
	J+xTCYLJR9LR3vktZ92Xk3J7aHlCP5Ue44+HAvOQdjUoZfm4avvW4GnRmWR/ckVJiYo0VUaN9gD
	bgU1uMZeRq0jDe1/gHyId9lDdJHBpGp9tg2qlbOnblTbPEcAmsyt0rhPXS74F+elvNAPOrfWrIi
	8QSAS60SuW5/aYoagWrRlbSBjpWjcdDD9Ods9wKqA==
X-Received: by 2002:adf:e19b:0:b0:48b:ff5:d297 with SMTP id ffacd0b85a97d-48c727823c4mr10620890f8f.25.1791466322023;
        Thu, 08 Oct 2026 06:32:02 -0700 (PDT)
Received: from ?IPV6:2001:a61:13be:f901:8903:c5f1:e7c8:72f0? ([2001:a61:13be:f901:8903:c5f1:e7c8:72f0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c75b53fb7sm8309301f8f.58.2026.10.08.06.32.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 06:32:01 -0700 (PDT)
Message-ID: <c2fd2fb5-0fe9-4788-bcd0-bf7d09c1b5d4@suse.com>
Date: Thu, 8 Oct 2026 15:32:00 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] usb: uas: implement .change_queue_depth to allow
 per-device queue depth override
To: Luca Cecchi <luca.cecchi.info@gmail.com>, linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, oneukum@suse.com
References: <20261008112645.1820678-1-luca.cecchi.info@gmail.com>
 <20261008122604.1862534-1-luca.cecchi.info@gmail.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20261008122604.1862534-1-luca.cecchi.info@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08.10.26 14:26, Luca Cecchi wrote:

> 
> v2: guard against devinfo->qdepth holding a negative error code left
>      over from a failed uas_configure_endpoints() call in

Sorry, overlapping mails.
Please drop this part. Sashiko was too nice about this issue.
It is a general bug. qdepth must never be negative. It is
a general issue. I've submitted a patch. Your patch
just hit the issue.

	Sorry
		Oliver

