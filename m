Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA433DEADC
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 08:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894542; cv=none; b=Ubm57gQk3Dx6vSa7lZ3mNrDwJwipKhB1qcxCTpnMROh4MV+jlVye5aMSgwpX1DdrzoYE3wKBZjhUL6zv9a60Vx3q2gBRynlWh3KwG3Y3n9U3tgEz8Ee3ZNhuktoQkBTkJFB5VJYBs7XGl7rOqoUgvoOdVGKcdx57Dk1xyBy4Opg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894542; c=relaxed/simple;
	bh=uBdgn9dm7uR01HJNEMZUJOgReZ48bMbbNMEwsxPITrg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hFH/H0YwHZF7gFxxYljce7k/hb64oEi4OsQJqGN3JadMO6gdI9CF3X5uU2eRgsqJBn4qmftTJ0957piIAaEXIujrlIeQUOwOO57VRnnl36Hx2PWOJF/eBVL5UHUo7WreC9mSjScFExOqOEtoF9xlSrZSCkuWZkjhG10uGwqx81s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DBGOloBl; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DBGOloBl"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493a97fad2fso3281135e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 01 Jul 2026 01:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782894540; x=1783499340; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zEE7c4JvCa0G28E+b+L5pjVZkd/Bl+RD6B9TkZhci2M=;
        b=DBGOloBlFN9hrvIW7fYjMZMqgPwkYjh25ylXsT5uJH8a2aVq/NyVCP1j8O1eOnZKE/
         /i5Q8jLKLWm1tWT5GVIXrxFjUuVdvkp0hZOvJszDnbpGpwZURqym1pyeYw3NKYSyF7kR
         XjGQP7nKDbalpN2YR/fE6I7yA+tsFFghtMOVlIFO4qRX4CsoYGr44/pUfoSgcIg/HTc9
         CDxzqIBv2zCla91gfKXUKeJLSkQAx3V3XtXCIqnMpszFAokhghX/WMWcY9bqWNHRy+Ug
         Y1pOb1LF9RSmOGndjanMnwBYa3ZgA39j3Vq6AfngPBeW57o23D/ORHMtDYT8fZlGV9ow
         bcxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782894540; x=1783499340;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zEE7c4JvCa0G28E+b+L5pjVZkd/Bl+RD6B9TkZhci2M=;
        b=mTZe6eeVPhtmwlUrXt3m37uqsYn6gzknwQWeuEuAG2bYpb8FOSFF3hzuIilrPtSNUl
         Y4hHSfCyeSsnrRlEtUKTftZK8jDJ5GHWX4EAcFroLkWRkkd0KDX8KSBDPEzkNaV5Ucb8
         vvrNDEmooxdkF5uCaajEBwOla3ENTPWNgDcY+95k8RaHzQnqEsLebSn47LhX7UkdFGG9
         A1LUn/QK7GpAMq8EBwK4QUgQjR0CNjJIY8K8x/G1dShuAucZVbaOmf9xNPDryorUQsmp
         XwTKGkSy6zT5oBnPINrlBm2g+9IZ66MMubWPiFpYER/Vci5WOq4ulmutGquJ9thY6QF9
         pnGw==
X-Forwarded-Encrypted: i=1; AFNElJ+0lTsGJFwq35+hcLgQqNfUehmKnZVy6Xs7B8K8xTZWQtOI7Kr+dTJX6euAj4OiTpQ91/0Uy1MudZB5@vger.kernel.org
X-Gm-Message-State: AOJu0YzfY3dcDLHTgiVXmU0GZUjFRqFn9kiftek+006fCaG35KEIgd6/
	EYfm+dGTLj834CJSgCmamD/BC+R7qObIqzMoMFfwwlSobENGn+Zz3y+74AB2o2d2n8U=
X-Gm-Gg: AfdE7cl6tbfQuftvVshGHdCNY0dof0XJIVSvP3rBX4R6oYxJpjxedTI+Hp0SdKA9z+/
	U6IAhT1kmNfLi9/0KThZ+tzQvEZg3CLyacLxvpXlXsN4/5fIvosc8NwWJXNCYalFhREiHixWxX8
	azyWA8K5uJZWbsn7E79qFVrQURtWSJdnOfMMpNAKFkkGXUq5Onr9+zlTSys9ARp06+DeMYAznVA
	n4jQUST6xBDOxeHeKp0gnpW8AsMlMzhBYajWhHRmU9yU9Bkauix83pwl+9gtfOHU42xJnKN1cxo
	S0UU47vphp2OEVancoh4HJrBHQkVG0V7vT2AgOy6+/tRo9LCDlHei/sYJLjQFMRhhpXL3E5tdx+
	Cp0UuVZJaOXsb0z/OS1hoMihrzzGU+TrTBnR8FLgUaxAVM79R0NurD76QUeS547gcHnhC283L8K
	VUUXXGlIZIyYOQIpDZ8GSraDFuq6Ragwuuctd4crGp
X-Received: by 2002:a05:600c:4e0b:b0:492:5145:f054 with SMTP id 5b1f17b1804b1-493c2b99ef1mr8464735e9.26.1782894539512;
        Wed, 01 Jul 2026 01:28:59 -0700 (PDT)
Received: from [10.10.30.42] (pd95bc558.dip0.t-ipconnect.de. [217.91.197.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493be4d8f5asm86590935e9.8.2026.07.01.01.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 01:28:59 -0700 (PDT)
Message-ID: <e2599d9b-5dd9-47db-8339-f1aa825a11d6@suse.com>
Date: Wed, 1 Jul 2026 10:28:57 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [usb-storage] [RFC PATCH] usb: storage: uas: limit consecutive
 device resets in error handling
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org,
 Tomasz Figa <tfiga@chromium.org>
References: <20260701040335.810297-1-senozhatsky@chromium.org>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20260701040335.810297-1-senozhatsky@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.07.26 06:03, Sergey Senozhatsky wrote:
> When a UAS storage device experiences persistent wire or hardware IO
> failures, commands time out and the SCSI error handler thread invokes
> uas_eh_device_reset_handler().  If usb_reset_device() succeeds at the
> USB hub level but the underlying drive remains unresponsive, the reset

What exactly do you mean by unresponsive? Usbcore must at least
reassign the configuration (and the device address).

> handler returns SUCCESS. SCSI EH then requeues pending commands with
> DID_RESET (ACTION_RETRY), causing them to time out again 30 seconds
> later in an infinite loop.  This blocks block layer queues indefinitely:

Arguably this is a SCSI issue, not a UAS issue, but anyway.
[..]

> Introduce a runtime-configurable module parameter 'reset_limit' (default
> 3) and track consecutive resets in devinfo->reset_cnt.  When a productive
> block layer command completes successfully (SUBMITTED_BY_BLOCK_LAYER),
> reset the counter to zero.  If consecutive resets exceed reset_limit,
> abort the loop by completing pending commands with DID_NO_CONNECT and
> returning FAILED.  This allows SCSI EH to offline the unresponsive
> device.

Let us take a step back. What is the issue here? The device goes
into error handling. That is not a problem as such. A method
designed to remedy an error condition has not been effective but seems
to succeed.
That must not happen. So what do we do? It seems to me like we
ought to add a test for the effectiveness of the reset.
At first glance it looks like UAS should do a TEST UNIT READY
on its own after a reset.
Or are we looking at a command that reliably crashes the device and
is reissued by an upper layer? In that case either we need
a quirk or the SCSI layer ought to deduce that it is using commands
it shouldn't use.

Can we have more information about the scenario that triggered
the desire for this patch?

	Regards
		Oliver

