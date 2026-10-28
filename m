Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793177298;
	b=JxWErboU1BvxOnvPqjZBvWRdOUlmCywesxQN6NL+PMQJ0IX0M/lQ7pujue+O0P6joaar
	 9WpGBYorLOvNKkmEGRlDNvxzsVJoI3HRhgCxGVcQ4N+CbxXxnuynp6MJAOwynCCjyJR22
	 5KGbht1RCR66T+2q0flX8Xx+DxaGTpivueD24p/a+klWejrPNqj0daH28XCQebI+gnnsf
	 CTxO2ILLhFXdj4g6f4wXvAD1RYCl9h3fpo5Bu/53ZNHZaIckICWNyvgFVLxuar/02FEIR
	 +7alfluU9R9QphUtPn0hc75H3tRIQnqyara7XY/utSX+O6wDWrvaN5XuaK2mxjmaDoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793177298;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=/P4FiXSfTahRag+IvS76kiNUJNsGZXNeZs1soro+q0U=;
	b=cB0HQGLQAIUZ/AXbTHr4Mdzc1/CQlO2M8VcFuEiwLwZ2CV3GVQOzZVz/hOYIU6nyyQ6N
	 /DnhRHzw52a4x/mG1BFAtsN2hQVqta7m/+4yhV1V/Zo2uSrSGXugpxjgRT+Jw5pFaik/J
	 eDjr0Kow0fROWEkR7NNBMZ9YRgObfver/YKf6LFXzBfu/SkdYwC4N1+01zaCDUsF6o+1r
	 zt53XvxFfpz6RJ0GXM2HFoe+ahdZNx5QVeDY5jOdeOq/yKBUfrHf7mjUGtJP3ZYJm5X4d
	 NeO+pOIZNLs6F3N0CQiCdQIhL/jrml7lM0qMqW60MA7MVk/kURarRd7/iH1vBArDVjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=D98NASGz;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0463A606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 08:48:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0463A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=D98NASGz
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so6296015e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 01:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793177296; x=1793782096; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/P4FiXSfTahRag+IvS76kiNUJNsGZXNeZs1soro+q0U=;
        b=D98NASGz48p7nzkolCFiBv4ijS+AKWuUcJww6ATbM972WUm4X5vRZV7iNzb9SIxKyx
         gFC7a4SjHboCVyZlMEQewuvtX9pBbZJ8HQXd/YRps3XtTbGtkp5xlpIMBKURowHrhJsU
         EhDFxa4FvXAYYT07wlt2TAHY3/eO5IlCs1/zrnH5D+KNjaDT10CkZerq/B085TALGqGQ
         WfM4VhyXuV4oFa/7BOzbL/T+qAV81zbphPF5Sw14di0J5Qz//ji+Fl3yzluw7lPLV3Fb
         aOGI4xsBxHqcn7jKTp8hUtcafadwY4BQSUp2z7uZgYIjKohp8dq14HCzQrmSmCH7JchF
         A4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793177296; x=1793782096;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/P4FiXSfTahRag+IvS76kiNUJNsGZXNeZs1soro+q0U=;
        b=Zg0lVcL/EZX85FHyVOPJZ/+61plKVDS9xf8iU8SJgPgXyuSDzckHRmczcE0Isl/Z02
         C9RU+sIdpGvFMEbU2BdkQakV4CNRcBv7hmqC64sWxQAhQq1pN+XHXjk05I4Q62g1MFRS
         +q0TrB8WTYmQCIEecVAOG02I9RwACMWQ4i8HUlTbDxXBZxwHLESwFd/PuGMdtsrC+qWJ
         grwy9gB+Z2M1lCIpHCjC+FghL3Jz6MVrfbJN5oDVcY/g535Czvw8UQpyz9sGjGvv/1Ob
         1vmKBEiSlv4IRZ1bTBrW/G9H8LjRURw/0zbdGNGwQlUIyYmi7IGJ4MHFU+7dyeCik1B7
         DWGg==
X-Forwarded-Encrypted: i=1; AKwUvBy2VI97Ola+l55tWSVqvN1Puk8qGv3oZW54RzYgAEKM/UIkrTei00ziS/8YO2zkwNV5aTMSKTDySE5Z@vger.kernel.org
X-Gm-Message-State: AFq9FYJwHee+0X+297mCakJIqEFzkRjxN2tAXq3r98Z71L5t9liX/QVj
	spiNkgsqlJClIV7QyvDgDqGIGx2yFy7yfilcSJzlGWmk5O5HV9XQUm9bac7zDHAqT6i6HGfZ9GV
	SYOXw
X-Gm-Gg: AYBFou2032ar7hAJdW7HPg5QaDaxkxxkYpqrjTuWCYJJBXDvFLDr0Gj/jchUzbkRJEZ
	4rnDooYocJRL9S31y3hJxCGk7Pih9QFQhdWTKO97oUi5hq3NjTMLss5y/NLXcLRdCkK/CGbsH/F
	ZOf9vEq3dpJPdus9Q6c9jAT464Y793ZioNGjO4jp8KFhhgU/acPqKcL+XpnOX6I1td8Rud5a598
	sIvKvsyhhYmVFcDkqF1VK5mBj30hCv1bxo14JkI/bQ9K2hhKRxCU9XBCbVGyP/cwUYgQIbf1tOP
	8GdrvyFC6WcYfkUi6Cw4VPvtUfqfh1OI5t1pRWiWqW4D7d0SWFQ2lO3n0Ppr9n7eNCdZ6hSKVwk
	8aEZVTglyc5nlDUZauYkr8BLO1luK7s6OXBCZFdXL708ZbEl106e9iGm4DHJ9Zgjue9r0NdJ5SQ
	KRRLt7mTHdeRJFKyUoFfMTnXvGFmLOIATS2AbTgMPYQ/zdGwOgDittzsf6pGcm/RwTIjA8jozTO
	Xdh4jtuBYWlQ+lolK7e33FF++o2Xaal70eweMPLZrZL4vbWIoQo2kEhY2ZMy58M4ND8cvTdrQvM
	WAssJHgXJtL87E9mNZZf4UVSONnu/QqLl8JC0gEb+J3wFMNgoFWEt7F4aF21NmiVFd3H
X-Received: by 2002:a05:600c:a00f:b0:4a1:9c71:9f17 with SMTP id 5b1f17b1804b1-4a996d873a9mr22922355e9.9.1793177296320;
        Wed, 28 Oct 2026 01:48:16 -0700 (PDT)
Received: from ?IPV6:2001:a61:13b5:e001:5d05:908:ac82:a3a1? ([2001:a61:13b5:e001:5d05:908:ac82:a3a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a93103e72dsm25003415e9.2.2026.10.28.01.48.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 01:48:15 -0700 (PDT)
Message-ID: <5230664a-9666-4196-a798-260da5aa8e8e@suse.com>
Date: Wed, 28 Oct 2026 09:48:15 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] usb: uas: wait for pending commands before unbinding
To: Jiayi Li <lijiayi@kylinos.cn>
Cc: Alan Stern <stern@rowland.harvard.edu>,
 Michal Pecio <michal.pecio@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <8469d5fa-2f4e-4565-8d84-43d6b71b4a9c@suse.com>
 <20261028020958.1141513-1-lijiayi@kylinos.cn>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20261028020958.1141513-1-lijiayi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 28.10.26 03:09, Jiayi Li wrote:

Hi,

> USB core has already terminated the interface URBs, but a running
> synchronous scan may still be waiting for SCSI command completion.
> Waiting for scan_work at the beginning of uas_disconnect() would
> therefore delay the command cleanup below.

Why? What is it waiting for? And why do you think we can skip
that wait safely?

	Regards
		Oliver

