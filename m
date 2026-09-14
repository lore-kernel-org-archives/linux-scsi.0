Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059AC3F1045
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 08:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789372860; cv=none; b=M3dmWtM9adsT7W3eLTuMnZwXvYeEK5w+LAB11RuA9dK+MUUbh7SbDAMIzS08L3vVF22xjdvzBQ2WENKZt4RdaL4yD5jX73d7noIhnEgPMtBVTq3SB0nmCnAZRQkJo99tGI0Yi2ION639qYPh8ngqju6OXrWONLC26QgOSlomEJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789372860; c=relaxed/simple;
	bh=EYQOeSNuOoXjqRUIdNe++z2p6T2udVShkfpEKbrrMj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=syCvJ+ZAYfIjJpGBQdR6V8iPDIFvmjiBh5qxHpQz+7EEEWtreeWiDy6qjuQzWaYMkWrhz65fVR+Lshptmykf4PWfPXP0mBwR8twBLH+CGiONb5VyGjPhAqmOsxmZJcCkxH2hrJczHu4fx3vhBfHwXtwAdM8rjMCz6abdaKQZ/Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OrVaSuRm; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OrVaSuRm"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd5462b69so9718405e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 01:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789372857; x=1789977657; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cmYhlDLXbDHAFy+wmv5M6UosyGJ8HUUEwo3iL6kJsHg=;
        b=OrVaSuRmJutYx2IOtNi9FcKxKApNX/a5HymYOCPyuYDUUNG2QXN90yXabvp0sPaJ5T
         E630+E7uvsqsHQbU01F/mYqSNq7Bs8STzVFiD7SMRKOuwXj8jCYkxTZZ1PCXK7dEdic3
         4FniaSLH/Bo9qygIlol0E1NkaBUa/5s8pH2k73vhs/wpkBRdmNdgzDasWcSI02Nrw4S2
         SnBL5wdxDOofu6ZCr0ibj6DtTiEeFOgNg5/RSYh0SDRnxaNg/arggG3vQUPzk5QmggLv
         yk9bE7uoIb8P1vRzI+C5SjAdwT+pEbuRo5wBtjWAHPlJ/Sqyrx1sdvAIPUIQ4uxv5yrU
         fvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789372857; x=1789977657;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cmYhlDLXbDHAFy+wmv5M6UosyGJ8HUUEwo3iL6kJsHg=;
        b=TSGLlWiVsaX9W+vP1geWxm02Rnd9uz1gVAbO13YxaL0E0AMoczZ1Z/ir6xFQig/Gb+
         a1/d7vNwo4vEXR6i0eCG8SwXFNcWQ4m7RYsppDeK0YjvUiKyHdP4c7Qv9XrLQllnP4Kg
         F3gRC+U4UMre3LItNB3f7Q9eSRGoVIt+LAXGxwU4Qh0OC4TXBxvmgV44TfOMZGmzDySO
         zst8O7Lhf/+8PTvHDoxdvmeG+g/o70CxgLSoWIBxnwsDfZNAi8WNOZMcAY2YpVBzmMPy
         0htOqXkRGXLenri6NKe/WO37FottWrvVQ64KagZ0wktplEP+Psz+yufy9TYZh+vlwcWA
         VzKQ==
X-Forwarded-Encrypted: i=1; AKwUvByhifqB0D2ExTnRO77vmEa8nVvnGoPJTHO5yT56p4Ei/qfXQRurXwqf+qw4JnZ1t1A+XaZC7tohN1BP@vger.kernel.org
X-Gm-Message-State: AFuF++ll96zq7s+cvvsioJ2o6OiwgupN885rw6hzbhC0mzBnarNZbUuS
	TTuW0PyInq/LyPNlablNaCSVYZRI3/EfTZJNzj4aw3jwZdsT0f5lUekpqBrTygKVh5M=
X-Gm-Gg: AYBFou2akPpiXejwQVgjIUaW263wZbeUt73QvWqC5qkOt+xlPvHngEwxmtJG6jJp3o5
	9jbiDrQNb7MOluuIw6uBhuMXVlZ9CZ1zG8xCbxmZe2N6tpVZ7vYlddHvMPqrUmLzOesdSEbviH6
	oQ2pCQxNKFUA6i5+lW5Vh+wCjQDVyFN5zdsxGTUhv8cqNVdIkwZAa7VnMfpX60JidxY27qVBD9z
	Dzc/zZD3s/DOfjZnAPEYgapBfzwRWo3pG71rldz/U74jQoEq3ugjYr1QojjbX3JxK2FMFmlRmg5
	DMNn6bvyVsZGpZwj6MA1K+hPjJsi2JkoAnWtGddlCtXUaFK4y926ej5nA3v4nAVJC+61KmmHuwh
	dCK3tDmViBM8hZzfPRG2ChkxgO3TXMsLEJk8T6TEY8B2KK6uRU77ucXhZO6ctMAkviZPY+SazC3
	Ku17Uy6zegqXyGwXfCizugKUAIKwavs9EqeI8xyFb0xPe2vYr/ZA6jllVZNhpNWk8UFCnXii1xQ
	gwiWgInIOebWK4vb/h/Z7aj/uQbXsn2Jz00qgAUX9A=
X-Received: by 2002:a05:600c:4e45:b0:49e:6050:9fbe with SMTP id 5b1f17b1804b1-49e7a68cefdmr32722865e9.15.1789372856926;
        Mon, 14 Sep 2026 01:00:56 -0700 (PDT)
Received: from ?IPV6:2a02:3033:271:ff25:5180:f8d1:43d5:f6a0? ([2a02:3033:271:ff25:5180:f8d1:43d5:f6a0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e71e300f3sm201135275e9.7.2026.09.14.01.00.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 01:00:56 -0700 (PDT)
Message-ID: <c335085d-a824-4632-ad3a-c06715258c81@suse.com>
Date: Mon, 14 Sep 2026 10:00:54 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] uas: JMS578 returns reproducibly incorrect data after host
 reboot
To: djraszit <djraszit@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAFKhL9eUM91rtywaz_7Mz+4mJH2b2csmOmc3+86ii3a0Ka3Q6g@mail.gmail.com>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <CAFKhL9eUM91rtywaz_7Mz+4mJH2b2csmOmc3+86ii3a0Ka3Q6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.09.26 16:38, djraszit wrote:
> The same correct value is also obtained when the enclosure and disk are connected to another Linux computer.

Hi,

thank you for this valuable and comprehensive bug report.
Just to clarify, does the quote from above indicate that
the device returns correct data on other systems after
reboot or does it mean that you verified that the disk
holds the correct content by attaching it to another system?

	Regards
		Oliver

