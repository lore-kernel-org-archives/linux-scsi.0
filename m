Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F6980C
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 14:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707834742; cv=none; b=p+KJka7DwZ1kbLr/nxtt2tmGSXaJqgm4hlyv3SYxiizLxGU4lc3yTOoKSR1MNPJYnqmUju4Kq5SXUjqTeCRrRk2WjpvYiiBob77z20otJu19knfFS81OnMiqZfzypHk1R8o7TInn55U3BgRxo7QJi3v40ipjPUaWE1GozBkMHfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707834742; c=relaxed/simple;
	bh=U5ZrHBrWcAUE9Y41fFMLpPGv/KRg+mZUyUM7S7g2HzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EJH/FfbYph8hbS+pN83qavz7Fn58cR45DElzHJjZpslnrpXhqPEF/bV8JA31DhkGimA7Jh23PSCSBsly635nuqYuf/CtlCocsVVqRaw57H1vf/8u1L2Ik4K5CQth9vbmGxHxGCZhg5thsh4Aw5GBNckRW8tA+U+nvrMg1/KtvPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CixtPyJl; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CixtPyJl"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-411bf7e5c6bso4542765e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 06:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707834738; x=1708439538; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tkmZw6wnQN7KBYXyvd8m4RLTht5eLalE8DvBZ/0VlFQ=;
        b=CixtPyJlmlMFe6lvqYElHGgl3wxr6DYUzc7N6zBGO0wlRhFfqI/xjV2K/d94XtWZl0
         A5j5Kvp8MN7jUOMBG07iKGAB/8DF1GumCGjCzflB0eEorgi94AsemtETMg6Ev6TQU58Z
         2ahIIhY7U17xZ6n4jhHBpsyrCnLegjHTR02bFqaqKVSvj2HpRIBr6sivwolS85YbPILf
         A+EpwaB2of9jl4LJJ6vhn3g8wsgRX4PUgP8gLay6rvV7LRxRV1RXbLDpzSiLN3qf6LPs
         z9Nxp1/i0IuHqycrzMU8HqtrJEvvC5oU0N36fS3LmmSePz50J26WGNk+BwL3rL3jw+nP
         X48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707834738; x=1708439538;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tkmZw6wnQN7KBYXyvd8m4RLTht5eLalE8DvBZ/0VlFQ=;
        b=EgNHyyaEHX2TQ4VJ08+XyWXIugmVi/PJQFCDOtrnIeLwtUsohTpT+NfQIoFRST+ZCw
         a+nOFN4yvp7Yj9A3I0SL9Kz51cD99TSUvXadp66WJDe60BpK6F/nQ8od9PDnawuMv5Iy
         TVDhxl1Y1zdndjzNDWLM4jabBPMzGxhnsoRHCq3mrEKtfqoBc2InD7kAvqaKpyze1PbG
         GodVLU4a5DaDVn1z3sHy4xny07ZE0w0GvSD1dnh2p4Du6kH+z/7t9fVN+Pmb/3jOLfFC
         9L4DSI4fUZ/4gBp+a+qQmFzmz7gKroGict2dBueuoqgWCKyaLMvSx0OvFBmVfQH9wpb9
         umVA==
X-Gm-Message-State: AOJu0Yx/9yyTFPAmgZWScXhbZoRXqmI+uhNhw0B4c7VeOloEx6wg1xgF
	I7NweCQ45RKq9+VGFoehW1Ut2c+FmX2s0J0J3dVe6TW8ihfJoij16EUP05UiAgo=
X-Google-Smtp-Source: AGHT+IFR2GO+ChW4f1Rhw3kPKlleAgLQlqKaCQKPfffs9zzvnHgTKHtllPOUzZ9F8RKIO/OumtdywQ==
X-Received: by 2002:a5d:5585:0:b0:33a:edaf:13ec with SMTP id i5-20020a5d5585000000b0033aedaf13ecmr7296385wrv.14.1707834738582;
        Tue, 13 Feb 2024 06:32:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVMeauP1Ba2Qg0DjOviADaAirmyu/Faga5FOKXwkx+L9vGMdNvE6C9PiPXay7aud8GJuHzgwfrZbNPj8HZqmJD1Q3GcxHdGIEly
Received: from ?IPV6:2001:a61:1366:6801:d8:8490:cf1a:3274? ([2001:a61:1366:6801:d8:8490:cf1a:3274])
        by smtp.gmail.com with ESMTPSA id u6-20020a056000038600b0033ce2aae7ffsm576697wrf.33.2024.02.13.06.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 06:32:15 -0800 (PST)
Message-ID: <cb660336-1771-482b-bba1-8407e6db92e5@suse.com>
Date: Tue, 13 Feb 2024 15:32:14 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] usb-storage: Ignore UAS for LaCie Rugged FW USB3
To: Julian Sikorski <belegdol@gmail.com>, linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
References: <20240209151121.1004985-1-tasos@tasossah.com>
 <b16e72ad-3f2d-46a8-8361-2641088694df@rowland.harvard.edu>
 <2978efa3-e83f-4ef5-907d-8232e4b692a5@tasossah.com>
 <6d4b1f55-09df-47e9-945d-fa38cd36588c@gmail.com>
 <b6dcf71b-f094-4664-8d43-7d8c0173f51f@gmail.com>
 <c21f9649-30be-462a-b9ec-f7c96ead30cf@gmail.com>
 <0cf5ea13-6472-47e1-a32f-b9f332656c6a@gmail.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <0cf5ea13-6472-47e1-a32f-b9f332656c6a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 13.02.24 14:06, Julian Sikorski wrote:
> I am cross-posting this to scsi list, maybe someone there would be able to understand what is going on.
> Out of interest, why is the device called "Rugged FW USB3" by scsi but "Rugged USB3-FW" by usb?

USB takes the name provided by USB descriptors.
SCSI takes it from some VPD, IIRC.

	HTH
		Oliver

