Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B10F2D6E59
	for <linux-scsi@vger.kernel.org>; Fri,  2 Jan 2026 09:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767345311; cv=none; b=isQufZmoYFLGqJErhZ7K2Gq+BGhLKDOFfI54O17ydXJTAP9IPW99gqS2MiSLY39Htm+R0xz2pAuMWO2ZNVK6bHUU6GJzStKXDVP/fWx4ltHcxwJHD7FrFsFMGVlCZG6eE63wy9wytAmOiR7FtoenGUuveV0Q772EF9DpkCDRvCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767345311; c=relaxed/simple;
	bh=OQ95NodpicSGUk0iHBGZIIo21gUmLBy6tiMBcM7rbLo=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=N6AIvjZuSRvxrRQj9jxTcBF7BCEC8kGK2NRm6DwEzZiISIJRy9YnowpB62NabsDHPHkqk+feMxa3MKrHfFoko1Z9xveX8DTVC24dPz8sneZE8AaFWVhPnEqiER8nAPQoOTkmIixWxYUYEBDTpmm0mh3rF3wXCUKMcw+eMze2RDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bE+QmItb; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bE+QmItb"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42fb2314f52so6668565f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 02 Jan 2026 01:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767345306; x=1767950106; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:to:content-language:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TR9B0Za9Df05IKu1No77n0ZHDlhVEm5pY8mJ2UW+3s=;
        b=bE+QmItbbgr+Vmm/AxTZUgD5iCjpDfjU52EjosC1jtNd7AKAQtgAN/nl/g5UsyIGDT
         PhVmEM6ZZUOQ/VSqgT23nCOTjHd/mWy2nona7gjXDfCHoaxAO3K+HyRWBYAEJNuLtn+c
         1RLUxHC6rmRnGOzDBwYxEywq4QFWnCKsZHWBF4pcL63cb+jPCGM49rmL8s5vo3p/N9WI
         ExJbQp4J4sBlL0Qoj0odaAqWezrOFm5EYpaK4uxTxvKPjQ/6egZIP+FnuxmlZ7a+cF10
         +MebXOKO5MnZK82NdBffTo9eKoTNL9VO2O8T0mGw4TlwqzPtpRfPKx2jQc36BCr1Y0Ko
         AhzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767345306; x=1767950106;
        h=content-transfer-encoding:subject:to:content-language:from
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/TR9B0Za9Df05IKu1No77n0ZHDlhVEm5pY8mJ2UW+3s=;
        b=tPNSOU22YlMemZ/rBLG5P5R7WnbwyIdSxgNBIJgE636tEd080FE0k0bbgA7rmQtCOl
         mLwm8KBQiKTSxCo/dtxB66bTi2PdH2bwiaTW0FFi4Ma0rQMqkCVgR3g55h20EFHqh0sH
         BDAXPfFkKvMYbtB7vc7o62aH31f3mFePwo3qz3L9EhOYlKOxr8Lo4kU2W0HE6uRRaQ8p
         ErykQJb1bCiTDqg4XGND5hTihdxPHfxEQPB8ETS0Z/gXTJIYD/jlfkEQEMXaUsSlsXT/
         Dh33fGtXzonKVoET+gX4BFer9e5YZVxucHkxxbaf9mUEFm/WBHfIcJHSxFzqeDfV6nyR
         bhFg==
X-Gm-Message-State: AOJu0YzXKTyCe3Rp8shkjs5GLqt3qj/7TiVNgBGHq/h4zHm03UoMwrI/
	Hdcz4s3AsHEVVHcrHYm8Jq8+HmX4drfHQJTEQ8C86r1Spx70z45quNuy/zjrBE5e
X-Gm-Gg: AY/fxX6qmf2MD7CQCf6bpbv9d0NtV78hrjznPmMArx0du2sCWYPysXsTJalAhf1+OKq
	A6/Y5nLbhZymSjOrbpkRiohg2aPlqUo4nUA8tfR6QBSKVAbyuLSI/4pTNIT5NAqxvC5QSrkM/K+
	RqekfveH86fGvzzsw1ZA4IWpasloN8px+ct5MNO2qB3aLhjs7t6jL2/npv8AeywD26ss1+rd4TX
	Oag3gw5E371qNfZ9c54igJygWGCyk3L16Iv9Ec9qXrfE1n7lXEknSbEbwRmMXG018F94nuxt/LE
	olnYfbKJYvzVpcDnwDYh3PIVGZSZ/KhDFxKt+QfyQNXxOhNbUhbq6bpQeTIwWNGEdFVysxj7atG
	x7Wup14nKnWvfW2UiTf8MQ+UtNhzlVl0d2xW8IPv9HyTUyxTWN7tgDiGasaPA7Wg42oBUjsJF35
	AV6FnO6GohcsdfVWBMJGYjmEedRtmGryjZE0s6Ip8y35axk1fnOpzRIVsiSQpF0euO11OHAA==
X-Google-Smtp-Source: AGHT+IFTLdUZji3G6T1tN3ij6Vtn7EPxWr+faNsm/PyW38WnvKirofVD9KjQ+/OuhfBGDy+4BgYkqQ==
X-Received: by 2002:a05:6000:3104:b0:431:9d7:5c2e with SMTP id ffacd0b85a97d-4324e501694mr50407694f8f.35.1767345306111;
        Fri, 02 Jan 2026 01:15:06 -0800 (PST)
Received: from [192.168.10.194] (net-188-216-175-96.cust.vodafonedsl.it. [188.216.175.96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea226d1sm85715264f8f.13.2026.01.02.01.15.05
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jan 2026 01:15:05 -0800 (PST)
Message-ID: <3bb03946-eb11-4e28-a72b-e958833bb5cc@gmail.com>
Date: Fri, 2 Jan 2026 10:15:04 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sergio Callegari <sergio.callegari@gmail.com>
Content-Language: en-US, it-IT
To: linux-scsi@vger.kernel.org
Subject: Sd card race on resume with filesystem errors (possible data loss?)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi and happy new year!

I would like to report a problem that I am encountering with the sdcard 
storage.

I have received the suggestion to write to the dedicated ml from the 
linux-stable one.

In my setup /home is on an sd-card (because system is a 
laptop/convertible where the internal disk is too small). The card is 
luks encrypted and has a btrfs filesystem on it.

When the laptop sleeps and then resumes, there is a race. The sdcard 
gets accessed for read/write but is not yet ready, so there are I/O 
errors. BTRFS is not happy with them and tends to remount RO.

This issue is well known to purism developers (e.g. see 
https://source.puri.sm/Librem5/linux/-/issues/484 and 
https://forums.puri.sm/t/sdcard-becomes-read-only-after-waking-up-from-suspend/20767/2).

My kernel logs are identical to those in 
https://source.puri.sm/Librem5/linux/-/issues/484 (first comment), apart 
from the fact that I get the errors from BTRFS, while the reporter there 
gets the errors from EXT4. This indicates that the race is not specific 
to BTRFS.

The errors in the kernel logs come right after the PM: suspend exit message.

 From what I understand:

1. The error is more frequent with the SD-LUKS-FILESYSTEM 
stratification, but not specific to it

2. A phone/tablet set up such as those that purism developers address 
will generally use sdcard for storage and require suspend, being a good 
trigger for the problem. However, the problem is in no means specific to 
phones, ARM devices, etc. I am getting it on an X86-64 laptop.

3. It is unclear to me if there is a real risk of data loss. Possibly 
with BTRFS that has a more complex data management this can be the case.

4.Even if data loss can be excluded, the issue requires a reboot to get 
the filesystem back to RW, so it is annoying.

5. Purism developers have a kernel patch for it at 
https://source.puri.sm/Librem5/linux/-/merge_requests/788. From my 
understandig, this is not in linux mainline or stable. Would it make 
sense to consider that patch?

6. For stable kernels, there is a mitigation consisting in a systemd 
sleep-resume hook as in

#!/bin/sh
/usr/bin/systemd-cat -p5 /usr/bin/echo ${1} ${2}

case "${1}" in
         post)
                 sleep 1.5
                 systemd-cat -p4 /usr/bin/echo "hack, wait for sdcard"
         ;;
esac

see https://source.puri.sm/Librem5/linux/-/issues/484#note_277648

This appears to reduce the occurrence of the problem, but not to 
eliminate it completely.

Thanks for the attention

Sergio

