Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE2525393C
	for <linux-scsi@vger.kernel.org>; Tue,  9 Sep 2025 22:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757455781; cv=none; b=GXIpg4ytGKm3TcC14B0VZavHHnokLbss9gvFvAWME1zUwXjKFXA5nfYjXFkkpt0BIlbZZrbnyJCe56qfEsk7j6D8JuKW1kfeC50RhaUUEiGaxo4aSQD0A3u7d1nJIx2OASUNJ3yBo9YVNUmKOeu/P/pYplp7df/b9djFnzHDJYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757455781; c=relaxed/simple;
	bh=Rl85ifHTqqcOljpR5uWWgDGTzWdXobghNEGRkdP76KY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=j3t/GnfLAn5HfybFldVc4CtsS9NjLpQokJrHDu14vUbLCI4sS4q8lkTSQfaQ13X0S3oD3TIoD9a8e/6cUGxQJyxgTMxjBJ9hwIxOQ1Zx8fl1W6MKRpPh3YqQXDhDQpTbNGbSuBCYcpyZGpq10uBu7MueYJ/iiQwfgEnJxTTWb5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TzMswMtw; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TzMswMtw"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-71d603cebd9so60181707b3.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Sep 2025 15:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757455779; x=1758060579; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XmJ5o+jPnqmlOrUzy3HJkAfKFx97iJc4+bwh0bc73yY=;
        b=TzMswMtwKFYpxuG7MGPp5IWu3C/gPtGaHvjCi3bmfyi1/WoJl5ceBqIAqcoJEpK6q6
         /R3o+hXqQMYOWSjjsr3oH22HUv5VWIZdMzUFw5Wzu6/jCIM1CRCAd17zYvTqJSXg/Cf6
         7ZJ7HN5yAoVTi7jU3bC4t3UBEtcEIm5Ve4aYjVHNf+vyJDrGBexhI+H5RhcYxYns/B5W
         qYv2jYeXRdOZHwU9lYhryqcwVifw5ON6BbduzOH5EkzNqSVYZrErKUSozy69cX1mWlec
         gfgkRyQBMwEJ5nniYHk5Vlbk+AVZCJTZhdAacMJ140rcDrEaONVHAN1jvLE67Ynzt2ha
         bEjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757455779; x=1758060579;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XmJ5o+jPnqmlOrUzy3HJkAfKFx97iJc4+bwh0bc73yY=;
        b=upLmyonyW7kjYKlKPU97FeYztZRrPDudBdcdOzBdfkCx491ERmkMdZFUEFQQvCySaN
         i/SKEsN4nOZ+GYvwEN4w4ohWWZXdq8B6t6ryh6+YK5nwUabRZ93mhUwwQ/jrnIm+juwX
         hfUm5Lakdc63M0oynOjhmSWhvY7AHp2nEP6bna9MAfmYcCCSM5pIUYQUCXSKyiqBocjG
         ibZdsIuvVXKj4NEKV/TblcUiiVxufLkBOpwBi2BEF3KndrHSnbj56JnayzS8wZrvi/J7
         HUEUubc1snQWetjvM0jGv5KA311fcvj5GSQsLllDgHyHJ1cIPNs8jnVBOs3UKIQU0xm6
         hyeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbnNsN9CClWxyMpbSRCiYSQG7DLM0cbJ19xiPfOaLB0wi7nY3LZhfoEBnVwVJP7jdJ8jku3Cld8EJo@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1xXuebQr+mELjb1yVza7GCOxLQxkbgu5Sdu4d0SddSpcb3r5v
	1pA6wCsb25ygI4JoKlqa84/bQzSYI3JFD71+U+oAgxirUy2teHdFttpZcXba1X3RErvswQWVjFM
	9Z1IBceAHqg5gHlrSFapyJFI40Mo7sbyljW5E
X-Gm-Gg: ASbGnctoD1/LsLZU2DLJ1OWXjKk6nP6qPybPAXipTK+3EB/YlYOQIqPMT05sFEcDDcX
	B6k47obgcbOJnQC+TgdGnXSjt8puVTZyKrcmIQrpnGFE/AAWbbpGXzf7D8bVNMZOaiiRgreNEta
	xrU754MkGtwmJ/N7/zI9eU+iZhvQ47jX/tKlhzl+EdslSlU58E6w2sFEqyX84wKhfm0PVIggcqC
	Q0mFD3+L5uUvOOgIFWILZHj1bqbqMrYk1yhABn/fQqf9aaCkDrDI0KVe0NNUg==
X-Google-Smtp-Source: AGHT+IFqNLkC+jmXhcN3ReNLmiASziY8GQzbu1BJxMjJ7N26Xo+bVXvGXy5YOxms8UmrenvJkTKUPDHd82QRK/PTE8U=
X-Received: by 2002:a05:690c:fca:b0:72c:2eaf:1cc0 with SMTP id
 00721157ae682-72c2eaf361amr50796687b3.23.1757455778642; Tue, 09 Sep 2025
 15:09:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Davy Davidse <davydavidse@gmail.com>
Date: Wed, 10 Sep 2025 00:09:26 +0200
X-Gm-Features: Ac12FXxpG4DYXH2BN4T5ajRp3bT0waYrA9jzpYOUgyBROKwgeF818Nlj_rCkAcs
Message-ID: <CADzRqdBCLjA=6nLxUivDm=hA5vkfkMiE+BmC_zKtA2DCUxu2Dg@mail.gmail.com>
Subject: [RFC] target: Support for CD/DVD device emulation in fileio backstore
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear Linux SCSI Target maintainers,

I'm writing to discuss a limitation in the Linux Target subsystem regarding
CD/DVD device emulation and to gauge interest in addressing this gap.

# Current Situation

When serving ISO files via iSCSI targets, there's a significant behavioral
difference between TGT (user-space) and Linux Target (kernel-space):

TGT behavior:
- Supports explicit device type configuration for ISO files
- Presents ISO as TYPE_ROM (0x05) SCSI device when configured for optical media
- Windows recognizes the ISO as an optical drive
- ISO appears in File Explorer as a mounted volume
- Can be browsed like a regular DVD/CD

Linux Target behavior:
- No device type configuration available for ISO files
- Always presents ISO as TYPE_DISK (0x00) SCSI device
- Windows sees the ISO as a regular disk in "diskpart list disk" but
not as a volume with the type DVD-ROM
- The disk cannot be read by Windows

# Technical Root Cause

The issue stems from the hardcoded device type in
drivers/target/target_core_sbc.c:

```
u32 sbc_get_device_type(struct se_device *dev)
{
    return TYPE_DISK;  /* Always TYPE_DISK (0x00) */
}
```

Both fileio and iblock backstores use this function, preventing any form
of optical media emulation.

# Comparison with Existing Solutions

User-space alternatives like TGT provide this functionality:
- Explicit device type selection via command-line parameters
- Full MMC (MultiMedia Commands) implementation
- Proper SCSI device type presentation

Kernel infrastructure already supports multiple device types:
- pscsi backend: Returns actual device type from underlying hardware
- Core SPC module: Contains TYPE_ROM handling code
- SCSI subsystem: Full support for all standard device types

# Request for Comments

Would the maintainers be interested in accepting a patch to add configurable
device type support to the fileio backstore? This would:

- Maintain full backward compatibility (default to TYPE_DISK)
- Enable proper CD/DVD/ROM device emulation
- Bring kernel-space target capabilities in line with user-space solutions
- Address real deployment scenarios currently requiring TGT

As someone primarily focused on high level coding languages, rather than kernel
development, I'm hoping this RFC might inspire a kernel developer who sees
value in this functionality to take on the implementation.

Thank you for your time and consideration.

Best regards,
Davy
