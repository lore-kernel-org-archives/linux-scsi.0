Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800703E5561
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773250442; cv=pass; b=W5YX5OwO+B700TM3qQDvP8CNxXjy1dn64I0s4s38Fx4tQEWmcFfFsgZ+O4co1EoTkmwQyOl8Cst9oO0loIQfAtWqqr+yEIupd/l02UJYvN5P+kI74Trtnz25gk9CndlOKYN4NjK34hagRrPJb6thWhlC2POfvif+3by9TLVsb9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773250442; c=relaxed/simple;
	bh=s2TT4zBmTgKLBjwI2jX25EeD0XUul2cp2vaWxlr2I3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tg3TbteSSqBUazDcqVyrSpkr2W2GgunUVoibq3mHGcYsQUHSTNAgM81mRLMk5MDvAsvNVMT2a5sYoqxN62RJOJLszKvGagL/xpQHuodrfNjAvFcMlMUMG33kLfFB4cSPFKKOH5VPDdAbmBY8ac317LircMRMHU6RBgWc0+jOEAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fkRynZC9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=awhL1Xiq; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fkRynZC9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="awhL1Xiq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773250438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=flJ16OLbnUTRR+lsZIvlkZ9oQtiHzlZe/Icpj7ZquZU=;
	b=fkRynZC96qRwTgEaI80gfc7M97DxDcBA7mO6SRB2rl/xL6BnCtIuD9UT42TJwpjUQJYcxC
	97tsy3zZ7uuSf3PHURRhESGqOf/MnWKNvgrKOq7WXD+Ar403xlo5HTBvqEP5E1dmK04UqJ
	o7KKtp/+me0/BXABhwoa66mCm+w7KmU=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-uffLgMT-PlSLRozSpRyueA-1; Wed, 11 Mar 2026 13:33:57 -0400
X-MC-Unique: uffLgMT-PlSLRozSpRyueA-1
X-Mimecast-MFC-AGG-ID: uffLgMT-PlSLRozSpRyueA_1773250435
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-38a3baf3db6so736971fa.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 10:33:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773250435; cv=none;
        d=google.com; s=arc-20240605;
        b=Y1D3zL6v4xLyAvTLhkMsqQnwMkH7JtRd1rQKD2eyyexQ9jSXILBAAcVDTkqUMsCGPX
         m4w+pBKNJbW1Qrr195olzIq8XRApL85deeheNcwkYNkL+HKU7qdsWQvORSYJv7OiqRfN
         hpF9MW76d5BFy3MccHlNLMuhZUUhoj5TUX7XLgnLS0F8ed/IxSSbJMDe6bKZHRws+HRF
         B8RYaPF71McmeOUcjtKa+Wk5PDuYvx1HjPipcqaLni7u6nd+ywk6noKZuRSJWdt5w2aV
         sVJnXwToFNlJ5L2cTjQzighAxkS/1MxrIO4WPHr0oMLfkVB0ipLlrL4vRI0gMyl95ZEB
         fqVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=flJ16OLbnUTRR+lsZIvlkZ9oQtiHzlZe/Icpj7ZquZU=;
        fh=8IgN5hs3XVxRL7l4Vb+e430zHPwks8PDBmwnPligDFQ=;
        b=dS4P4GvwkwQeT9nbx2jzaNoSELe/uAU+Cmgj3EcFDw1U0yKUMzVRK97sPHnsXmz469
         uWPkDr2VkfVGoPn+z0Nk9O7a8yfdqP07zsg/rnwLCm46WZTc2HkIf1W1PFg0m3jTP9vZ
         8hy55QxhdF8H3Si6Yqos3VVeErmaj8wyJkITomRu7Ffromdm7MwKa7IEpCn9gftsvazx
         4cTg/QBs0ppuCEh5uFa6SGB5e15kRrDK2DxEo04nX2IH1ZzufafPN7cmg2YyDGtxI4hy
         tTYh+XpxEjGqiBvuNR3KgCbcDMh0wTwZ78jZtcR1XWGlg66q6W5GhlAS5Un6+SGtzN6k
         50oA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773250435; x=1773855235; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=flJ16OLbnUTRR+lsZIvlkZ9oQtiHzlZe/Icpj7ZquZU=;
        b=awhL1Xiq4AaVmEFuiABPQdXBo+6jeYCinVI0Hzxq6xTDInIUXUFESGSajStTnEQFn3
         MLAdvYlCjV/Z6mRFmdZgHaoXoE7c43+1vTZxX9bJfW9osYDumnMtpHG9m4Dm4566RylB
         F1QpnHwzDMiAgLWSQPu4RE06lC05vtibnzexHY3vBgL+wQL/Ey0IvTIv4CmCsTVDz7/c
         z367AWk9bFKNPevNLhparpBwUtA6tbcUJGmCIn51GskthhbsLcMZJVfyE/btsYXpLyNm
         k9YOW734YztFpQVi0t5/hpYAIYhS+vl5kwMySFudwsM+/TU/Ozmw6NvJ9ZeWin9+TefH
         DC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773250435; x=1773855235;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=flJ16OLbnUTRR+lsZIvlkZ9oQtiHzlZe/Icpj7ZquZU=;
        b=oJ1Wwx/F9jm8oP+k5AoknYsFmIOHIoYn8kJ4ILwFjH/OkWhQ6luG7XXPPnxa0TnMvr
         FD0i3jTXqhQbNLapAXeTm0QeFGJeibHOc67L1fVNXh04gylWDPpbsHt+t/bsEYbPjATa
         O/PARkFthg3hQcytTBws/eCOkTk0eLE0pzhciz1YcH65iUJc++lODVVv1LkaWcPzvh7p
         t6YcKh5BxOhHf2sn22saIbSyeePs93k22ZfkdPU3891ZEQE890jqDYoiVkC87g/2ciJl
         z2nNEk6t4IkQu7kuP2vNRkktbO53cjLZFWq5dRN+P+5eBL+t4zjQA7x98yyqXDKdFxbm
         Efkw==
X-Forwarded-Encrypted: i=1; AJvYcCUiN2fkzWKG5QoeJOmVYVqntvq4l/f85W2IXrcFMpkUio1J5PMF8H6MegtvHN4lvuoA0+nrI9aoF0dw@vger.kernel.org
X-Gm-Message-State: AOJu0YxiAGxXSG8bLeYagtbzfTLdN96QiDg3e+TovpPYTFIM604rD0hk
	HLqOOIx36vI5RlVyyTE5t5SD1+XmocyLDuKazBMP3C33DbIj8Xt0o1XdYltMNHrIuVBaYCIUM4O
	rTjVYTorSxMFjfRHSDdbqc/4ef/b/bZkcI4cgLjCQ3+HSeh7PIfLZN2i94/mS8Lgkazt5eXg/gR
	Ayd+4GXc6EsF8vHxZrWgGSgzJ8ZKxAoqLQQ2rDjg==
X-Gm-Gg: ATEYQzx1B/fPfkR50orMJWbzcy1SCA/xHZmk5UllaujWC5rpUotLCcls0yIjyawNiL4
	kIgJEOJ0Dm7xDraW91/s2j2olGvV6Zg5fzPaYaEOLTLCpGpV0W1pwprcN4oq5cIpxR8z7hp0jpH
	0PyNs81D+TkVwcCJ1+iFOMigYZWr3PoEbBHie7y+677+hk0BlbSQhmeMzv8WW16kY314ikbExVi
	5tM
X-Received: by 2002:a05:651c:2118:b0:38a:5f1e:5a27 with SMTP id 38308e7fff4ca-38a67ac5bebmr12044251fa.0.1773250435320;
        Wed, 11 Mar 2026 10:33:55 -0700 (PDT)
X-Received: by 2002:a05:651c:2118:b0:38a:5f1e:5a27 with SMTP id
 38308e7fff4ca-38a67ac5bebmr12044041fa.0.1773250434837; Wed, 11 Mar 2026
 10:33:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311170956.9146-1-djeffery@redhat.com>
In-Reply-To: <20260311170956.9146-1-djeffery@redhat.com>
From: David Jeffery <djeffery@redhat.com>
Date: Wed, 11 Mar 2026 13:33:41 -0400
X-Gm-Features: AaiRm52MnSut7lwQAhwTt7Xx2XUNBQi4rzRxg1tEEehWxmKQpJTSigbO7AwxnYw
Message-ID: <CA+-xHTEdSk69BYpu+6mKVyoErgMTnOpZ-AFXntMe61w1BT0_FQ@mail.gmail.com>
Subject: Re: [PATCH v11 0/5] shut down devices asynchronously
To: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Stuart Hayes <stuart.w.hayes@gmail.com>, 
	Laurence Oberman <loberman@redhat.com>
Cc: Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <tatashin@google.com>, 
	=?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 1:11=E2=80=AFPM David Jeffery <djeffery@redhat.com>=
 wrote:
>
> This patchset allows the kernel to shutdown devices asynchronously and
> unrelated async devices to be shut down in parallel to each other.
>
> Only devices which explicitly enable it are shut down asynchronously. The
> default is for a device to be shut down from the synchronous shutdown loo=
p.
>
> This can dramatically reduce system shutdown/reboot time on systems that
> have multiple devices that take many seconds to shut down (like certain
> NVMe drives). On one system tested, the shutdown time went from 11 minute=
s
> without this patch to 55 seconds with the patch. And on another system fr=
om
> 80 seconds to 11.
>
> Changes from V10:
>
> Reworked to more closely match the design used for async suspend
>   * No longer uses async subsystem cookies for synchronization
>   * Minimized changes to struct device
>   * Enable async shutdown for pci and scsi devices which support async su=
spend
>
> Changes from V9:
>
> Address resource and timing issues when spawning a unique async thread
> for every device during shutdown:
>   * Make the asynchronous threads able to shut down multiple devices,
>     instead of spawning a unique thread for every device.
>   * Modify core kernel async code with a custom wake function so it
>     doesn't wake up a thread waiting to synchronize on a cookie until
>     the cookie has reached the desired value, instead of waking up
>     every waiting thread to check the cookie every time an async thread
>     ends.
>
> Changes from V8:
>
> Deal with shutdown hangs resulting when a parent/supplier device is
>   later in the devices_kset list than its children/consumers:
>   * Ignore sync_state_only devlinks for shutdown dependencies
>   * Ignore shutdown_after for devices that don't want async shutdown
>   * Add a sanity check to revert to sync shutdown for any device that
>     would otherwise wait for a child/consumer shutdown that hasn't
>     already been scheduled
>
> Changes from V7:
>
> Do not expose driver async_shutdown_enable in sysfs.
> Wrapped a long line.
>
> Changes from V6:
>
> Removed a sysfs attribute that allowed the async device shutdown to be
> "on" (with driver opt-out), "safe" (driver opt-in), or "off"... what was
> previously "safe" is now the only behavior, so drivers now only need to
> have the option to enable or disable async shutdown.
>
> Changes from V5:
>
> Separated into multiple patches to make review easier.
> Reworked some code to make it more readable
> Made devices wait for consumers to shut down, not just children
>   (suggested by David Jeffery)
>
> Changes from V4:
>
> Change code to use cookies for synchronization rather than async domains
> Allow async shutdown to be disabled via sysfs, and allow driver opt-in or
>   opt-out of async shutdown (when not disabled), with ability to control
>   driver opt-in/opt-out via sysfs
>
> Changes from V3:
>
> Bug fix (used "parent" not "dev->parent" in device_shutdown)
>
> Changes from V2:
>
> Removed recursive functions to schedule children to be shutdown before
>   parents, since existing device_shutdown loop will already do this
>
> Changes from V1:
>
> Rewritten using kernel async code (suggested by Lukas Wunner)
>
>
> Stuart Hayes (2):
>   driver core: don't always lock parent in shutdown
>   driver core: separate function to shutdown one device
>
> David Jeffery (3):
>   driver core: async device shutdown infrastructure
>   pci: enable async shutdown support
>   scsi: enable async shutdown support
>
>  drivers/base/base.h       |   2 +
>  drivers/base/core.c       | 165 +++++++++++++++++++++++++++++++-------
>  drivers/pci/probe.c       |   1 +
>  drivers/scsi/hosts.c      |   3 +
>  drivers/scsi/scsi_scan.c  |   1 +
>  drivers/scsi/scsi_sysfs.c |   4 +
>  include/linux/device.h    |  13 +++
>  7 files changed, 160 insertions(+), 29 deletions(-)
>
> --
> 2.53.0
>

Adding missed Stuart Hayes and Laurence Oberman addresses.

