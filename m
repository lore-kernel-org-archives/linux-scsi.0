Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90862D5A19
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 22:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772058716; cv=none; b=US749WJwbepFAALNif5csmVSLZgE7niqrhViPLetC72tb37k54r97pVUM4QYNZ6tNq22/6zIXefetBVggTEJRwZ2lb5FKljt/QrlFRvNpqp9tXSCV0+na6qIQXti85clQCVDcEe5LD4klZ3oDh4fI9x8eyHHluYWgHO+iKAfsSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772058716; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aVKpVMGkD3GQ9aQ0bTQEEJjSdngzrJY1hUzUZZ2IVGUMZNI3VA+5kE6lxzLPfJC++4T4Pim2cByiJKBXuFu2fnMTi0Tqawv72cmvLrqOsKLppC/SNqnH1a05qJcDNEOR66Lcn5WM7QwwDc69Cq/9IwGNzbB1ZoKsdqFLk7y3Gws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tp07kAtj; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tp07kAtj"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-126ea4b77adso247383c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 14:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772058715; x=1772663515; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=Tp07kAtjt9w9szm0I6Wg060fd5rONuofIm7XoYyayNYZ/T0X/jJEvPMUd88Ko3myHB
         ONc6mvdF/u3lYroB3cLR2dIdMKjLH7xY4N7/dcG8QW5A55zQ7bSVnmOCiYdOmNF8mKMF
         VUiid4TBd3uRzy+N86WHBc8qczQcTPSho+EgzRnhiiTThj4N/PRuLNfLg3pYwCAghD+f
         KldGSsb/Hxk6xb6mc4855f+mOUAlOOcvChKVisMd5xThRf1HDVTdvqCW2k5jrYF+WAMi
         0HejbetwhO2s6wgE3bXq2D1qdq2r9NfgHowiM924Fz+IeBZig2Y22otOPFezN492dtWf
         xovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772058715; x=1772663515;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=VQWvH4fI1pL1xAKKQVSzWYkWZwoU9zhHk/dvbrasYw6rrm9qGP50iHpE/ozHM1Dn1r
         II8u1xwXgT3GmF4Ukuyn7bs9F7Kbqdnp9fk+fa/aVdSeh7T13jiOjZDQcpcwPRBvg9vn
         B4zgYDpSTegvo/d7Gno1JknMVcO2bwe8pSJSwar2xjA/yqfS4dVriTFVSqqf0eh03hzS
         W1pSsEj4wAnP+AMQ0m4YQ8qAZ1BWqS1yXGfUYqxwPr5zZpLjuXQK4K3xtzvzfUNOR9gC
         VYbFKv3OzrGO7OfoEmEXqZH1F56+v9D2iq6WZtcAzr8AVhZD48zE8IkzCwY9QY23wI+I
         sWZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX992FibWXBWPvBUwXwFGi8x8pAZvXWuZlRCy+Z2z+14ZHce+JQ+VQv4HVUthTapvBclJi+ReEvuhE8@vger.kernel.org
X-Gm-Message-State: AOJu0YwF/w78ashUHX49Meus1auqH531qCjajdIUZ7Ma0uiTuqiiakOY
	sh3+kgJKG3pJtDNXDazeAbzUkjh6hLBlQXo3wRZ5P/+wJ/z9qr8kYEiV
X-Gm-Gg: ATEYQzyEuWP7PnZzZHardL++zmle7+POBzkj/uQ3t/Lxc4k/xtf8ymVaeRCcfJ5O3mV
	/XZO/GmiH4ToZqNkON14KTnpqqEBQAhDg+BeBrvtjbL3AjwqY6pu0YG80SR+8hAZoLHn4E9IMAE
	1U4g9OzycH57O4TTqiFE9WqgsCn8CeQEGN5Jgiyry2zXs1ppx9FUKPK6YLBSMQCVHq0Ws5VUfCX
	uK7FH46jepSKNVb1xRjiJ6z6wQbN/c9Ua1uCEt698lBNRmxVuYSfpKOe5Ljf3O8xWgLNdVqN/ba
	AQVaGOe27vc0GSAoEynzpbCpU0MjpFy7ia6qQMuj4cZieQWptzthGH63Ozp8vwjhNHHu4rtPZQZ
	fe6EAD+aqE9GWp43zLhdffMuso5bUOBU91MKNM0BJUXNcTRoBxJ8r4HB97JwSDAMrSP6DzMfFO9
	AqBViZNbuLOIpazXoEkemx6ZJJ/mbZB0hDBX9vl1R2qQ==
X-Received: by 2002:a05:7022:603:b0:119:e56c:18b1 with SMTP id a92af1059eb24-1276ad182b0mr7064155c88.25.1772058714699;
        Wed, 25 Feb 2026 14:31:54 -0800 (PST)
Received: from [10.69.70.152] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdd1bce281sm325930eec.2.2026.02.25.14.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 14:31:54 -0800 (PST)
Message-ID: <6e0b646e-462d-4698-b2ad-156d58a53500@gmail.com>
Date: Wed, 25 Feb 2026 14:31:46 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: lpfc: eliminate kernel-doc warnings in lpfc.h
To: Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20260224234954.3606638-1-rdunlap@infradead.org>
Content-Language: en-US
From: Justin Tee <justintee8345@gmail.com>
In-Reply-To: <20260224234954.3606638-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
