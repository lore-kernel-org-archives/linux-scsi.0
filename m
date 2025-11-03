Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6D72F25E2
	for <linux-scsi@vger.kernel.org>; Mon,  3 Nov 2025 09:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762162912; cv=none; b=PyH/WFbyCQPuti41NrWu3d79o8VAjmt8F3f7TkeeSipMCTK8nwuphV03p8VQJFYbd0kfWvTJnlOZNTDttjirh1rr9S12HimL56Cp84a/CMOWufoydKYdu3mOq83p1K5ovLIcq7BgP4+5xL795kpES8YyWUCFTgGd/Dw8gynR8Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762162912; c=relaxed/simple;
	bh=aXJZtEP9MzAuBE72bhvix2W9bevYZ5Ri5o0a3J6FafU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lkqgAMAL7cSwZNDhA0DNbeLGq8nzqoO5Dfct5lHXrZqfXNUCEj31hr0mrviTOggmnxL9ZH7lEclnN8FGJIJR6I1x5zPNWrhukKJ+zld3p5x6EWygGdEe1F3zStx8InC0NlEiyRaadoAmmdjjkXOmK280OOohaUXSGvWahw/z7Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L5fbvBuu; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L5fbvBuu"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640a0812658so2677435a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 03 Nov 2025 01:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762162907; x=1762767707; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uQ4p8extKYli1hpsb18sxQURINeyF5Ujv69r9EjqtSM=;
        b=L5fbvBuuYsWJnsh89kXTpRVZTh+PLokuFWNfs7/0+mtBW1LLO9yJbex1RKcvIjrf8q
         yFdzWW7gomoG07KS5KwlMg5qW0DY323HInapNEYNmPqx12MrW/2DxmlbOEDVqfWjvK3w
         1Fqp6SNs2OWJWwSwVJMFSC+gj7CCH8DnDhSeUz2sO7eSveMgRHR5yQ+OZqS8NYsOezKU
         qBWjen17GXNdKjVxzEn+wM6sciJ5OHK48LjIl3vKRKuWlUoglBCd/eEQneJfvF7v/3WY
         W7dEXrJtZdTY9R5oyL7qPt/2ijqm7eLWmQl33DfFv5ljgwpYfpn9Kg0nmBkLLlpuyWeY
         Xxfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762162907; x=1762767707;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uQ4p8extKYli1hpsb18sxQURINeyF5Ujv69r9EjqtSM=;
        b=QqqPUwREvffcjOhhHRn6obu2gY8uIowNRbWSCXwuxrgwYBQ2tKLBwaFyQt+KasP3oB
         hvY/hnkw4trBy1LGxqv5WeizfRe0LJwkmMFL6Hzeg34bksbUj0TYmvBRL4qXtRXCgWaA
         cGrZZbnA+izvcA5xKuEH7liBwVcTOEPDsGmuMHlBm+9NLI50jxt9aSMoQcl/2OnKIGcA
         I0b2Rf15SePk9OIOizQkEsjPohEFYhnfqNNCW2M7WCqcgWbKCK9Sh+A+HTQqGwdQk6PK
         dVlC7kj2K6zI8DLjUavGdQ2pvWP5Nd9Q2+1Yt0XOKRkXgELZaG9CQzCtvVP/I2yIV2GR
         SKIA==
X-Forwarded-Encrypted: i=1; AJvYcCWYyD+fTBOgL5oTN4fpzdthflHjcNtUoZH4cS4BkunqqhTYPwP+lS6lwkAfkrQ7y8dVwLOuc6nrIaQm@vger.kernel.org
X-Gm-Message-State: AOJu0YwGPC1fD9HGke099Uzpq1EFiNAlompT8gcdTHaSDZgKfz59EPNw
	fAvHmPqdbQFM9TWvHC9nkXu6ofqKX2B8CL9i7ohKGppY1YGLvffGQaz8nxGXAHcpJIs=
X-Gm-Gg: ASbGncves8q9InfqAlKwHhUYVFAbkS0J1TWQsftq4iOkplPvQMtAGvQTK8qBGHxyB1q
	qp+x7QQOMWR192JOajboyxdYe/7judAIKdJZ3gdugT+f1MqBrMTPWDmpqtqyhzDiCR4k93mm4AM
	BgG6g0iYU6Mr2SAF3NsEREcVTTT/EjTXItlYBJUQcMUDR39oQFE265qzeY8HSMJQ/zp2pobGk4l
	5NrliexVdtLb/YHSMJO+cFpUKe7HilQjx3X9CWMrdkd/ME9DrI98RvsyUVX4EPhrbo6D2BmI1JF
	hY9QAlzPsrTPsgNB0w2jqmqJin/QLWzp5Lqqhl5GBhG9ckaCQCLVQbOmzpZwmURsYH/XIEroYtH
	VtpjJm3ZMKf5Plw1zSDuuHSUWogLwP1Tl22czegka00Vyhv+S+vEdy0p75T8L4bCQMI6wPUfNN1
	EAWNWHoPkhpF3/TEHHHd3VdYg5zKqES5xegJ8kno7ZAhr7uG/lMjTw8zo=
X-Google-Smtp-Source: AGHT+IH2gzj+vo7E8Ikz+oUAKkZsomKKLWkfIfLWgoIJFmJJqNapKWXnB39jlaelhJtTjBQ7ItLs8A==
X-Received: by 2002:a05:6402:1472:b0:63c:1d4a:afc4 with SMTP id 4fb4d7f45d1cf-6407704138emr9280289a12.4.1762162906723;
        Mon, 03 Nov 2025 01:41:46 -0800 (PST)
Received: from ?IPV6:2001:a61:13df:d801:cb2e:7d62:bafe:d300? ([2001:a61:13df:d801:cb2e:7d62:bafe:d300])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64098077b1asm6659522a12.7.2025.11.03.01.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 01:41:46 -0800 (PST)
Message-ID: <a3d9c04d-73fe-4624-abee-b06abda9fe97@suse.com>
Date: Mon, 3 Nov 2025 10:41:45 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [usb-storage] Re: [PATCH v2] usb: uas: fix urb unmapping issue
 when the uas device is remove during ongoing data transfer
To: Owen Gu <guhuinan@xiaomi.com>, Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org, Yu Chen <chenyu45@xiaomi.com>,
 Michal Pecio <michal.pecio@gmail.com>
References: <20251015153157.11870-1-guhuinan@xiaomi.com>
 <aP8Llz04UH8Sbq5Q@oa-guhuinan-2.localdomain>
 <8de18ee2-ccdd-4cdd-ae49-48600ad30ed4@suse.com>
 <aQYRIgg2lyFhd7Lf@oa-guhuinan-2.localdomain>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <aQYRIgg2lyFhd7Lf@oa-guhuinan-2.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01.11.25 14:55, 'Owen Gu' via USB Mass Storage on Linux wrote:
> On Mon, Oct 27, 2025 at 02:35:37PM +0100, Oliver Neukum wrote:

> I think the error handling only takes effect when uas_queuecommand_lck() calls
> uas_submit_urbs() and returns the error value -ENODEV . In this case, the device is
> disconnected, and the flow proceeds to uas_disconnect(), where uas_zap_pending() is
> invoked to call uas_try_complete().

OK, I see. You are right. Please resubmit and I'll ack it.

	Regards
		Oliver

