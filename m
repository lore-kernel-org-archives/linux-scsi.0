Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057723939DE
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 07:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790752974; cv=none; b=bRFvQ11e0wyNTpkymXC/Va2pn3sfi8VXUaA4X+9+vJWAjEybrDsKq6suX1UBE8BThb5RVGDFCWX0turgpInUNU3kABPMTPDn7r9wnBa1GMw2RlHKHJgnQEw8fMiTggHVi6BL3FjdWqHv90Wyw4GBCM6SknLbf3eGchcwpW02pVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790752974; c=relaxed/simple;
	bh=nV/iNF+/tr5R+HlRYzbBMnjCuktKhfYLuFq/OkCFbkE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=czUpk1nSRjmApAhpwsozRXp6li9nAmTarGw6VU/qym7vKM/wqyWdufxOvEHuKcWBnp3BNSKNle2sdEKRZg7vOii34snO5OgpKrPhXb0R/zj349ksQ6AL04ms4nCnWkcpGgYg9c8kQ/x5XgKCKe6uv6K9AJ6qK3VSJmWBx8tN7Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bPli6TS5; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bPli6TS5"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e7d2bb404so6593025e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 00:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790752971; x=1791357771; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3py4Gq1rrzGZxQ3f33llQv9RYaeSHhngqz3ACgv9Wfc=;
        b=bPli6TS5Ixd2Gb6EZaEhVvY721ieF8FawUAGhwt0PPwAvAlElpIOE7aW1BSHtohgwU
         DRh0V4ouZ5gGb6B9VBtY+S0/Yju5OtrlMuhZzTXa4crFzGmHI1h++ZffIpeXbiCdUAA/
         vESf8sjr4xnth7pZj+9dTtih3tiy7xros2Npm8W8O4Oq9IBXvC6awxihuxkPQXCaPBFX
         9ct4N7lbdDawmvWKrcc1OleYlWSy+m7IQGrW5TUiVCHMv6oTLRyMdpgE/3BQFZS7ivS5
         jY2uZ4jtOyvww+wpSsPrRfH/oB3i8aAqfpGTdohhqgoQabXdcRuPnxIxWoLP015eJtgo
         3hlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790752971; x=1791357771;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3py4Gq1rrzGZxQ3f33llQv9RYaeSHhngqz3ACgv9Wfc=;
        b=CPzpPlgmNYzIHP0wCctlW0LRXiq3SWPcx0oOsnjNaS0gwjSTZZjr7sSsw9kmLHls3Z
         oCelCQ+vNIDiBmBpGU7y8LRT7jO3jUdSfA2LkST8QydLpnOnRhds2YrwrpHbm+B6PvQ2
         pnnErKab0k7EnM8i9klweVb0QQB0vEa5HoDwLl9dJU4wuxNGTxjJiyHnVprTWqCr8mz1
         AW4FGwe9AQaMOzY9TqeLDi4IcBRhz2MKd0vDzJfikQRc6ethz/zUtCAMPsa9yh/hl0Oy
         AdFer1vEJz1XCBCckQKXW+Juw9lFsb1hkqlPqAt5ZlgpMQAvrM9mR5UWW4FubRwVHzM1
         2FXw==
X-Forwarded-Encrypted: i=1; AKwUvBy9LwRjN0OSBrEaa5/zxqwgUPOPcxI4RJrHyfcg7Zxs5q7BwMd6H7DtYLVmTRd39wYsY9DbNjP8RYw/@vger.kernel.org
X-Gm-Message-State: AFuF++l1FZfJEG9pHtZw++dU4RRpoJA+KBEH3eGeoszkbAdi2zMSPRJO
	QbZ41BmcpqNs0+BsRyBXW5DW5t9bM0f8BB0yq1XLJMLSUjszk7CWmwD8WtjIlz3KdJQ=
X-Gm-Gg: AYBFou3Yl8puickQvgv0VTONUxOi9WUO0RhjizKwNst+Pcc7zT/3M2h0rR7dsaEzroj
	e2TH8Wfur3GaZZEC/L/OgiBGA/SUfbYBXFQlfJk2hn2H1T+Qok/7Crkc5B8+0tR/EcpGsSo3N14
	LQL19xpTwfqBMRFeeX+gLx8q+3zbYI5iOWvTsbcJqL9gSyaFn6NQN1QDS/JL29TTUGs2B7HbeV7
	frspX5y72IDtjBQvrwzK4I3tNqEJutwmpnMhh2bl2yPZ0u1bJWQ07gu3Aafw5ObmXTS1S4D7hj6
	GEzimD7y/AZsUbISot6gpViyCQlOSTOS9YdZrOdfcjUZYFKKhXJxQgw/kyOlsQPiWZgFWfV/xxM
	OuzNf0X/BTCg9yzglM2CybS9xQtOoGZ08HsGoGMaHD0Ifasfz55otUbzC6myu0j62hAfHTAr44P
	Jcq/GuMvLpvj6cK9CSmPgXK5zdWkfDktbc9ObdD5VxEJ9Z6P3ohT2aWe4PF5WAvCSg1+0fKh2da
	nUrLZRWHe8YJOh+TbXyd3sg2ATl4VHa99HQljQ1Ng==
X-Received: by 2002:a05:600c:c491:b0:49e:65f2:db64 with SMTP id 5b1f17b1804b1-4a01b1966a9mr6038175e9.5.1790752971184;
        Wed, 30 Sep 2026 00:22:51 -0700 (PDT)
Received: from ?IPV6:2001:a61:136a:b001:2f5f:2aa6:50c2:162f? ([2001:a61:136a:b001:2f5f:2aa6:50c2:162f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01b1e7a46sm11026135e9.0.2026.09.30.00.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 00:22:50 -0700 (PDT)
Message-ID: <813dcf3a-0615-4152-baa7-47b0046ca113@suse.com>
Date: Wed, 30 Sep 2026 09:22:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] usb: uas: quiesce SCSI before stopping endpoints on
 unbind
To: Jiayi Li <lijiayi@kylinos.cn>, Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
 Michal Pecio <michal.pecio@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <d3639d68-0213-4b70-a771-aa5dc3ec9767@suse.com>
 <20260930013332.829717-1-lijiayi@kylinos.cn>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20260930013332.829717-1-lijiayi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

thank you for pursuing this issue.

On 30.09.26 03:33, Jiayi Li wrote:
> Hi Oliver,
> 
>> Acked-by: Oliver Neukum <oneukum@suse.com>
> 
> Thank you for the Acked-by. Subsequent testing found a regression in
> v2: physically unplugging the device with UAS commands in flight can
> cause an approximately 30-second SCSI timeout. I described the failure

This can happen. Don't be discouraged.

> in my reply to the Sashiko review:
> 
> https://lore.kernel.org/linux-scsi/20260922100542.164047-1-lijiayi@kylinos.cn/
> 
> I have a local candidate that keeps the unified teardown order.

Highly important.

> When URB submission or completion returns -ENODEV or -ESHUTDOWN,
> it marks the transport dead, stops further submissions, clears

Why this specific trigger?
I am asking because -ENODEV comes relatively late in the process.
URBs tend to fail long before that.

> COMMAND_INFLIGHT and sets DID_NO_CONNECT for pending commands.
> It drains the remaining URBs in work context, allowing the commands
> to complete through uas_try_complete().

In the context of which work?

> Does this approach seem reasonable, or would you suggest a simpler
> way to handle the physical-disconnect case?

I definitely have no simpler way to handle physical disconnect.
With what you describe, while the approach seems entirely reasonable,
I wonder what is to be done if error handling has already started
on the SCSI level.

	Regards
		Oliver


