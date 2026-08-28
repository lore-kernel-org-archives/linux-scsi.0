Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE95366DA3
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2026 15:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787932262; cv=none; b=YU7/XYEgDR7NNsMq/IwDPsfOS+9r5FrUKqMkIMfnt8lhE8AHqsZeO5j3eCHdXKTH0dnLQY8Ih978zp8gnh1AeAhsqM7zMicvl4Tve42+Xn8bl2MwtDw42WS/a1HVyx7XAG0Jj7dvrWKeRTr9x6sbDG4lcMT1AOypfEmDEA8Wt/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787932262; c=relaxed/simple;
	bh=ReIfV+XfN9CJ7gWGHVy+pvxz4t/Bfm9Oz0pHx1zUvmQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Aj9gyKv5fXGakQSM7KPTlIqcsDg5nynRYqv2sBLXcvos8jMpeoof4eSpVia1n9HDgrCvFYn0DUTYzd7lfbt/4Xt7VBC3+t+kYQHlHOyLMnfGOZ+tZWkP21k/sHeWhD9d+YyDFxQCFIEgt5FhGVrWWmk07zANQrqYkvuTK3/w2vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Po3ok6Co; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Po3ok6Co"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a60a4f1ae2so1476642a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2026 08:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787932256; x=1788537056; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uNXgP9aiWGCY8sBDBkxQ5jGmQfHLh/8XePeePdlfGZw=;
        b=Po3ok6CoqSt0K7p74Ie5YqBocIN+aT+ywCfyYaEW0nyMCqj9P2obgLfhD1uZp3moPR
         ZOwWxmFXCI4XDkVBaGeCOC79P3b4afBm7F8wF/CDagFghN/DdWkDh3WWpmvzWgeMl8Ve
         eca34GBPI/3jBYUahiMGbh+fyAxAcAry29jpcoG/RZlzJRU8VaCUWm3Cdjp6/uGeN7DS
         HGzO3pufLwguWh5e7bjNyWFERjBLppaSQ1XxS2i6ZDmHfUq5tOZDA9ubLCvSxJww2WDu
         AbbuNAnwdQEZs0jiXOqJpPZa8qiJrE+Dw6WZmGLRPg5P12aM9fA796C0jcpqAOlJ90Ry
         rTBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787932256; x=1788537056;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uNXgP9aiWGCY8sBDBkxQ5jGmQfHLh/8XePeePdlfGZw=;
        b=aUjN/ajeBjgLYixeF6sd8vUU3u1Y1v+UP0GVvkvGQ7Ejz/+xg+IA3DnfO9HWbS9AOQ
         4H46zlJPgcYVZsGE+RFK2VxgmgjhhVuZG/IWE7TYSmsqZflWZMVnx4W8ultPDf9bMIvw
         qIS0jJwlakwNfLC0Ct6vtXvCv4c2wBQeuGDuu2TaIC500njHfP1ihc5htDkbJ3fEnAlM
         I0slHsS0nl7H+VheRS9+T7WF8b8s7Gra9ci4fjL8ntw/xYNHNRomBdTy5G6XL5rI/JS+
         O+bgN1YSnV95d8TtVOic1DYh2h9aSugMZ8QscGpBp3Xkpikl/omyt+EgRt35JN2lRiph
         v+zg==
X-Forwarded-Encrypted: i=1; AHgh+Rpm4hGwn7jZTcrLkTjnW2L41Tj2KJJdzYp6RxLwojJnHMnwcBi8lo179Qm1YKGjSHYx/cd/AKZYGNIv@vger.kernel.org
X-Gm-Message-State: AFuF++kunkZn1RYneCCWUnNVT2GTmq3jK7/AeNxfBUsBvkMSD8rtHwcr
	Om97ftAEu/gPPfbzq1ePXREuBLx/m6MnA7VHtWt+ABwJXgcoDr5BXFHkSNOmkA9K169VsFeWDwR
	7hVDcaX+9LqVd0Jzz3A==
X-Received: from edrb21.prod.google.com ([2002:aa7:d495:0:b0:6a6:a82:8b98])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5286:b0:6a6:1c30:bc4c with SMTP id 4fb4d7f45d1cf-6a61c30c3cfmr2134011a12.5.1787932256221;
 Fri, 28 Aug 2026 08:50:56 -0700 (PDT)
Date: Fri, 28 Aug 2026 15:50:55 +0000
In-Reply-To: <20260821142414.150892-4-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260821142414.150892-1-djeffery@redhat.com> <20260821142414.150892-4-djeffery@redhat.com>
Message-ID: <9huzjypaz1k0.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH 3/9] driver core: warn should device_move try to move a
 need_parent_lock device
From: tarunsahu@google.com
To: David Jeffery <djeffery@redhat.com>, driver-core@lists.linux.dev, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Stuart Hayes <stuart.w.hayes@gmail.com>, 
	Laurence Oberman <loberman@redhat.com>, Bjorn Helgaas <helgaas@kernel.org>, kexec@lists.infradead.org, 
	David Jeffery <djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"

David Jeffery <djeffery@redhat.com> writes:

> Currently, no device has need_parent_lock set and is moved by
> device_move. need_parent_lock is only set by the usb bus and very
> few device types ever use device_move.
>
> Add a warning to device_move to catch should it ever be used on a
> device with need_parent_lock set. The combination would break
> the immutable relationship needed between parent and child for
> need_parent_lock when locking and unlocking both.
>
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
>  drivers/base/core.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index bd9c2921e326..75f5931165a8 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -4712,6 +4712,14 @@ int device_move(struct device *dev, struct device *new_parent,
>  	if (!dev)
>  		return -EINVAL;
>  
> +	/*
> +	 * device_move() should not be used on devices with need_parent_lock
> +	 * set. Concurrent reparenting will violate the immutable
> +	 * relationship needed while locking and unlocking both parent and
> +	 * child.
> +	 */
> +	WARN_ON(dev->bus && dev->bus->need_parent_lock);
> +
>  	device_pm_lock();
>  	new_parent = get_device(new_parent);
>  	new_parent_kobj = get_device_parent(dev, new_parent);
> -- 

Thankyou for adding this, Please feel free to add
Suggested-by: Tarun Sahu <tarunsahu@google.com>

Also, I have seen sashiko complaining about another problem with
device_move which is impractical/impossible. So I mentioning it below
for discussion/information.

Sashiko Claim: There is potential deadlock if a device is being
registered with DL_FLAG_STATELESS which skips the reordering of
the list so device_kset->list will have device dependent devices out of
order. Also same problem can be create by device_move.

=> This is impractical because a device being registered with
DL_FLAG_STATELESS must have its supplier already registered first
(Documentation/driver-api/device_link.rst) which inherently puts
them in the order.

Similarily for device_move() affecting topological order is very
impractical. Unless someone mis-use the API
device_move(..., DPM_ORDER_NONE). Which, as well, not favourable
on upstream.

Once topological order is messed up, neither async shutdown nor serial
(sync) shutdown can work. As it is precondition for it. except
DL_FLAG_SYNC_STATE_ONLY, which is handled in both implementation.


~Tarun

> 2.55.0
