Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D316350F
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 10:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709201649; cv=none; b=MUxPxedQAVErbwxzDDiIKLrBqti26CwZ3Spwh3ygfuelf1svXoXmwIW7G04oU5t80ct4/vPLMb4WTfWriBO8G7rdVOtbgvE6Fnwz/gOwEk6azwd7cInridRyBUp9FAl4ytaVZWvYsPhBND9JveDTvzamTFJc/DFRRJWQAZu1Gp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709201649; c=relaxed/simple;
	bh=aO/xACjri3DeJZJbYyZbIn3zPglqkV2lKn/RFIM8uSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V8zFjovWgye+E+jF1T6HgwI1qyanK+oiPkRP552i/gyOUxyKohjS3koKtAc8sy9T4acNWAJ7X9tNdyYhYA66W5OUZbH2lMR6eSvSR+WzVajmwOVBU9GcULzlhT1WZwfys2OoryfGDj933xRf79ged0ILLdkfQ6I11SzBKX94fhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OQYLDG9W; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OQYLDG9W"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-412bf3d52d7so2034915e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 02:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709201646; x=1709806446; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jnnbn314m5C/930ao7THUc7euOiuIRor/2uYI5CotuI=;
        b=OQYLDG9WK5oGDUeJw3oEY+37s7u1HPzCaDnG2gE110jbPcu23xWvrOnaVu7Bkiii/s
         AJrrnDMEsKhN88lCVoyaoV2YYhccDCU0M7qaJt43pziq3wPuIkg5+pwBWikz/tlF+Y11
         jOd3d5VY8r7tWTNOxRIuQwZGisErRgfCUbDTB8VRcWhq5WUjXcxiEQdiX57JFJ/+yWW6
         yifbG/lKq7t+l+AjUD1j6FtdR9alPKcumRLlIpflKpO8atep/xhR73UgB3lsGY2/i3pS
         H0+0dwb2usPzGni/lsbMaKRrZlde7iqPQh6FFb+Nzc6NNwvjWKO72FLqp+DUUySl0Jkr
         e80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709201646; x=1709806446;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jnnbn314m5C/930ao7THUc7euOiuIRor/2uYI5CotuI=;
        b=kc9YkQnsw+Osi4C52ht/3F9qzg7HjExfX0nSRD5yi0TQGG34cKtE/LCLIq5oBMuQw6
         /294KtEmnM4s2TF2ia+MWzVResBMYLmkqumiFdWaGWMqx+k2QODCzaXqIjPERoSnYSzw
         lVRE7ZSgh8WEjUoDpiYI1ySJox0YjvkAAvgj5ReXcPEnuMGDWEDoCV2qscM2JDNEXz1y
         OeBZlNYeVMs34zlzULxAmVqQAJg/GfV3KVYYVsqW45cF2PMZ4GjcOhthKSVMP3OLKmRl
         iQjG3slmNVyuUotzMGt6aJDDQV7CiLShKFOAkw2NDideAkfsT7JmGOAeMIVFOi94p/Gr
         1nUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmkW5ZHXZT1ico0SYBhqs4b1fHLZuNW/t+T3poUzztg8m3ml+p/4mr9Bb7YfoSi832IDXkLJprJcpPJLhNxUA8jB2lDmuFcbEL+Q==
X-Gm-Message-State: AOJu0Yw6UaPXZGjXiBdpaBGMiJAx3pLeZQfRETtsOjM0gIGUuDfoc9b8
	h+ycc7KmSu1VnCxTWQpqAw+B53f7cLftZTwCVkitOnUNYr50kBfrr5BMr2DjlnE=
X-Google-Smtp-Source: AGHT+IGFyJEaCoJzyd7PF1nh1cjcVfv4xAAk+3Zq2JvER863k+1HDULiC8Ke+TEiagF31qTpvhzwyQ==
X-Received: by 2002:a05:600c:a001:b0:412:bd5b:efbd with SMTP id jg1-20020a05600ca00100b00412bd5befbdmr1040220wmb.1.1709201645978;
        Thu, 29 Feb 2024 02:14:05 -0800 (PST)
Received: from ?IPV6:2001:a61:1366:6801:d8:8490:cf1a:3274? ([2001:a61:1366:6801:d8:8490:cf1a:3274])
        by smtp.gmail.com with ESMTPSA id n33-20020a05600c3ba100b00412bca4cdf9sm1504987wms.36.2024.02.29.02.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 02:14:05 -0800 (PST)
Message-ID: <62891b42-7662-463a-885b-fba1d29bafdd@suse.com>
Date: Thu, 29 Feb 2024 11:14:04 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] USB:UAS:return ENODEV when submit urbs fail with
 device not attached.
Content-Language: en-US
To: "WeitaoWang-oc@zhaoxin.com" <WeitaoWang-oc@zhaoxin.com>,
 Oliver Neukum <oneukum@suse.com>, stern@rowland.harvard.edu,
 gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
Cc: WeitaoWang@zhaoxin.com, stable@vger.kernel.org
References: <20240228111521.3864-1-WeitaoWang-oc@zhaoxin.com>
 <e8c4e8a3-bfc3-463f-afce-b9f600b588b2@suse.com>
 <07e80d55-d766-1781-ffc9-fab9ddcd33e3@zhaoxin.com>
 <49a365a7-199a-42cd-b8d3-86d72fe5bca6@suse.com>
 <0b0eefa5-71b6-dc08-d103-72b9aebd9237@zhaoxin.com>
 <9263b77e-9ebe-4987-bf7f-8f9fafcf06b3@suse.com>
 <bb269ab0-128b-1988-acf1-8df05f08cf86@zhaoxin.com>
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <bb269ab0-128b-1988-acf1-8df05f08cf86@zhaoxin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 29.02.24 17:40, WeitaoWang-oc@zhaoxin.com wrote:

> OK, I'll submit a new version after you help to review the following patch.

Hi,

perfect.

	Regards
		Oliver

