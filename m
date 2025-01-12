Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917E81B372C
	for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2025 12:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736685824; cv=none; b=qinjtvputZ29KS1DoSSI53L2Lm/2IYud0OY2A9qpUBg6r59ZVgzEQMmEHNeCS+mbPDX8GD+/JzdwTstRtbFYX6hqNQEfrg0rlgf1L1qLatNQYgymMUdMMUzGBsgb/S364UqGtSLmV+3gDAMdLGfJuUPdF2veXRbt8ed+MJQyL8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736685824; c=relaxed/simple;
	bh=fufsAlqrbmNOej/9C24Swpfavv2tTLVyglUeMeAjOMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B0Qlb0oGo1ywE6Rx3WKWQbmyqzkia7YkPz4vBCQGKzQg92INmtyzMHwR+IWRIvlx9h2sZGYVPwahFcIIWph6p8zJ3cVyjD7gS3FR0TPmEftqLulGysHlQEX2vkyGCKyT7M9opMjHmGWn8r+sFzeo+oyYKmXhE6S3ccRvIqScsdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zettlmeissl.de; spf=pass smtp.mailfrom=zettlmeissl.de; dkim=pass (2048-bit key) header.d=zettlmeissl.de header.i=@zettlmeissl.de header.b=V5mUu+Um; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zettlmeissl.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zettlmeissl.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zettlmeissl.de header.i=@zettlmeissl.de header.b="V5mUu+Um"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-71e36b27b53so1907590a34.1
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2025 04:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zettlmeissl.de; s=2024-02-28; t=1736685820; x=1737290620; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fufsAlqrbmNOej/9C24Swpfavv2tTLVyglUeMeAjOMo=;
        b=V5mUu+UmI/nWCo+wOIWtj6ZyEDhIc7hUugZTspyQ8tdEg7779B9HLxSYV2l7ym6VD2
         zrHKIxuwG4uSVjv4qrQyHfd78XjBjiYz5C7i2U3So/QoiR1UPGARqYUYdpxsHUNXq3cG
         r65U3iCNlTAArLLMlsp8Nrl5s61J/W6C88FYeRLTeFvpQcXgQJ4ai/025Jj6pxdyWgOe
         TeEPdkUt6RJ3uA+EesHzfNZwL9d3VZurdZrh2IozMbJTXv7whZhrZXwfcaKP5V5I1BXf
         jLX0wMm3G+clfy/sWlzRhdx6TuGEEd7ZQ5h3OOvXnJFsu18mPpoeflp/Fu/0U1YQs2hn
         FQSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736685820; x=1737290620;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fufsAlqrbmNOej/9C24Swpfavv2tTLVyglUeMeAjOMo=;
        b=IOl4Z7YK6tyKvOM2QAxhcWew3JJTAdKJ60FT6JIdrpVuxBTD5py2pMXFhVilS3ceCr
         knHqEQ8W3aXRI+i0t6JH6rfpl3RZLq8VPZpKu3j/79kGRKVDWOs4jOoQY4/FX/9vrbAz
         fw026xalHXHh8/WAyXPrnPUp4cgv7h2Apt1oezZn9dUaf2FkqSdMhUjzzd6hfNf/aZCF
         XoFss/55NBszKryWecw+2xotgobiTzwoEht+Skpgi6wvLvkkacpHGlIRXibzdwd/JIWx
         H3U32+GteutxEY9e2jnMP3y+CU/I1l5WSb6R22ssTmAwb/NVt3kbxkU0xgL6I/Q41v46
         0BtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlDsq0u5HCpdHXOPFJYyXlnXfoi1xkaV87rnCruOJnfh/7ZbVHwXmkt5JFFPq6AHZDtfdG+PgWoE6w@vger.kernel.org
X-Gm-Message-State: AOJu0YziOdLfPGeEW6rGjo3lqo4AXKgMsE7AzLyAXOYAcTdyT/vJSA1C
	71EtTh+5NT4Vg/h5v/IfaJOf/54LKt3U5fFJHErkESHgTlkSg8WgDybJEWfmkZEgrcyLAQziosB
	a
X-Gm-Gg: ASbGncsyMhOQJMLxC/zeqeaz71uXUz+oxoOvJc4kz+hIFlJHVTUWAebFNwoV7OBcJuI
	bry//fngW6+IowIUI33XRRODhev7JqPcBMfPqZCcZ1NnTklIGoUrAmUQDQq7/veCaGEBxXuOWL5
	w5NczH7LMN8CdzeeQzv4JZnS+yVjERSl4u1MqCQxNXUq2LvxmdymTcUIyaIhWrg62uGqr42xGLl
	NbhB4cyrjkSmDyM/Q3Qs7wzjWr6cPY82tZb9mkJ20zPZjca8YM9r/1mfZJn4Zz0WdevXz/ZE34U
	E6BedFVkO3/ndUZW
X-Google-Smtp-Source: AGHT+IGurZ3C9qepLRfkCIsNXS2XWp26VOtxE33We55tAeNm9wRPTo9hjuvLzf6mIb9cCcw7NH9mKw==
X-Received: by 2002:a05:6820:4b07:b0:5f6:d91b:ef36 with SMTP id 006d021491bc7-5f730849a23mr8313617eaf.1.1736685820608;
        Sun, 12 Jan 2025 04:43:40 -0800 (PST)
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com. [209.85.160.45])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7231862a39esm2542345a34.64.2025.01.12.04.43.38
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2025 04:43:39 -0800 (PST)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-2aa179a8791so2070212fac.1
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2025 04:43:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXeQARIY86ctZqk3EIsPzKNXIzUibR0nDdbyMtzOCx0pPxA04ckD+tfDSiA/h4mN7zB6j1bGExsGmhL@vger.kernel.org
X-Received: by 2002:a05:6870:e2cf:b0:29e:18cc:276f with SMTP id
 586e51a60fabf-2aa066e09b0mr8895438fac.11.1736685818229; Sun, 12 Jan 2025
 04:43:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zi5YTR98mKEsPqQQ@zettlmeissl.de> <CACjvM=dA7MqfAC6_fiWv4LvmN8mNPnNG_YXoKnEz6t0vzyRkSw@mail.gmail.com>
 <yq1r0c8a65c.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1r0c8a65c.fsf@ca-mkp.ca.oracle.com>
From: =?UTF-8?Q?Max_Zettlmei=C3=9Fl?= <max@zettlmeissl.de>
Date: Sun, 12 Jan 2025 13:43:27 +0100
X-Gmail-Original-Message-ID: <CACjvM=cYhANg39-_7398rZFu2pr78iJH33vXXRYpZdtgSySKcg@mail.gmail.com>
X-Gm-Features: AbW1kvaEPH3GPJNvC1pLvKfyo19jWBLN8SM2i0Binv4wsi7ACqKDauTXZfVfcq0
Message-ID: <CACjvM=cYhANg39-_7398rZFu2pr78iJH33vXXRYpZdtgSySKcg@mail.gmail.com>
Subject: Re: Oops (nullpointer dereference) in SCSI subsystem
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Did you get around to taking a closer look yet?

I'm still experiencing this issue. In fact I just hit it about a
minute ago which prompted me to check in on this report.
