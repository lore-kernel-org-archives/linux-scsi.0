Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793642703;
	b=ILMI7WWKOpd4va84PzYXYxiVWK18XM3NA7u4Nf/3/w1z8QQRIHTQBNWPbTZApAGBJayM
	 aXicFkewVjfb9HvenpwWZzGJeZdElQQyiFATHzYkEKRCUv8u+RBPSUfkVGwq5ED/KJA/V
	 df6lxkTkVujctem4mhqMdXHEztTA4lJNfwYZPnFi1ogrqvd3QRBY6GYOUlaZdb0TsKmCL
	 H27spHVK3CUy0CcBONHGetclS+X8loezEorhSgXCvfGsdgiqz65wdvBZDBW+LJNsjMmQ0
	 2UW+0ORkQQaAPGZA3+JKOmPNQMNPQ8fV3gbWWl5LY6ZxwC5iOgMJPeqacjfvXkvbwkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793642703;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
	b=EVjtYh0zhNU34weztnqbzEYr2pJHkJ+44MlCfzZqK8gLgEKmft1NgImmVGMekSK3ZcEX
	 v5EyGIh3HcvRLUUjpfhBiQ3dNa0Invzzw5TES5x779MNGd2Q9o9hpnKIYPS6VDIeJtxmT
	 PrTo/mo8c0mERuk1WKQl4rF8It/TK02m+zqld0efEBciXcBisZZ1vfYmOd0qXVyr9IDhu
	 7mFL2tREhAvWjjUQSZR+NJMFPOrcwrIaIGCHHIzknbok4lhRiYZTroSwWZgfQW+BBu0Fq
	 7kGZgCICKw0UGdBIo/cotoi76JSPoFxHa4tDUCfiUOGBc4PR+ACN1+oxIsAV1RU6/gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=D7cs9qQW;
	arc=none smtp.remote-ip=209.85.167.51
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63FA606A333
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 18:05:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A63FA606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=D7cs9qQW
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5bfbc25a76aso4762956e87.0
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2026 10:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793642701; x=1794247501; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=D7cs9qQWPZ2sXQvXL8i7X7MiI1rLQyg+Z8aA7yM+mEILXHg2GeCfRnTXoMfNKaQbjb
         xI+hyhOU8jkM/GSNkswuZitmrhgQjID9PgcqNHifc7uvmn71ZRHB8KtUkMbMlol+ORBm
         9HwTpUVHByCCldmbezshfITrhY3+7prvf0FKE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793642701; x=1794247501;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=HQPyYQiHj473NiDJP/Mz3xivsHzm8pa0Tsu/npUiYlvJf4xWDdB4X3Av/Tao1T98ZP
         2hPke825agouLs6PntUAMSEJWIsIYgxoUAgW5JXAUXFAPvAyoEdc1TTPBp7xRWMxZtBH
         xGNu1yvX9EqKhNo+YFBDRyt1dr+ciyverWKBAxBINumsg28ekfgGQSqf7OC2tXnwZP9T
         AbfOjrY00ET9FGVqYJLAbHwsbaFExVv4kYy5acS/xTr4hDlSyklvHdyuJp8/om/P0iVb
         jTMAWiyx2i+niC3FA2/N8DOa2nhfxL86HAe8DLutFVmWxqz2Sz3vRHiatb/DFBv18ySN
         SiRg==
X-Forwarded-Encrypted: i=1; AKwUvBx+YvF+G8JHeJaXNtNiQqCW7IFtfzCjJJ8YOzNbSfHpq50X6uFZsBpFhkazG3XONeF+sSJmUKASiwkP@vger.kernel.org
X-Gm-Message-State: APuU4Z8yp/HypvxeaGZzKWhn9clqOdqT6XdrqrlwljB9DTLsxlev3wgb
	7YkD+lxq5q8+M3nHtP1ybm1UfH46z9Eu+S4ugY9pN+ZrgIiQKMuSVt6iKip9R9ajI+ZJMPQGPkF
	NRac61mNaxg==
X-Gm-Gg: AYBFou3NBdQCdnhgN8zRH/TW+7KEcEGeevQudo60QYiB1GS4XLOqaDqDq8TdWV/Kw3Q
	kefpFcXYb7nUjVT5aeyPn5Czr57QhLDnJvrH8ZbTgEFk76sMcSU6lnTYaetPSiCduadypySVd/F
	IqZ1/zZFErNcjcYKja5dl5jHrmKDfKYuJWttt6QfoLFRlw5TsCAYOk3O5gb+P5Gw+P0T7bXHwMR
	NFcBXbRGxRNsiJB27ROQRb2vdtiW84KsapdTJrXsyaPclQga+S7fN7oltUEXatRJ8Rc54GxC4DT
	mLLiHU6iOgv8pPMCzTMZIuTkraTmNk6OSfzqSEtirj1WuBh1AcvxxWqfJXckRzO7Sfq124BMHBa
	Zw5/T5q5gd73b+B8jnUWnjL2noI4wdV8RrRZ15/j6OC3wiI9ZZYl0nMhUWJ9hlO27JeJMbKhjvJ
	R4pEM+MXulJEZunXMYqCkLnIP2CyqeT08I9QPwgC0T0Fff6pJEWaW4el5C0Tyh72bbvIdHGJOaW
	XcgJV3SY9qXRou/iDoiOF7atDEaoobCilo0P5M+aQYd46L7h+fLtsRIZTMSGK5Sk6Mnfuz8JPRO
	J8ksAAk4y/EsGyYfPAwUncPo5S5uePa9ULRVYejxzW516FWA0B8g4uM4/vKKMmYNgw4liXOiuRC
	Bmg==
X-Received: by 2002:a05:6512:b91:b0:5bf:ae99:5251 with SMTP id 2adb3069b0e04-5bfd118c477mr4529493e87.5.1793642700700;
        Mon, 02 Nov 2026 10:05:00 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe1791832sm1673734e87.23.2026.11.02.10.05.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 10:05:00 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5bcb440d1cbso2155174e87.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2026 10:05:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx1PmOmYYb4i1qJ1Kq1pNxUWlYkHbNeOicqDofnvbKRqRDqczJxDQm9lCRQ49a0PtDYgB4vNpg83Q3C@vger.kernel.org
X-Received: by 2002:a17:907:d94:b0:c2d:c80e:8366 with SMTP id
 a640c23a62f3a-c4ca7426f6emr874452266b.0.1793642348398; Mon, 02 Nov 2026
 09:59:08 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org> <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Nov 2026 09:58:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
X-Gm-Features: AclHuK_qZTBVsLQIdymgRHScSFenC6XsGggUDmcuOugjrSTbuVkeASUmC_hYPZo
Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
Subject: Re: [PATCH RFC 01/38] PCI/proc: don't truncate the position of config
 space accesses
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Nov 2026 at 06:22, Christian Brauner <brauner@kernel.org> wrote:
>
> proc_bus_pci_write() truncates the file position to an int. A pwrite()
> at an offset like 0xfffff000 turns it negative [..]

I think this would actually be better with rw_verify_area() just
checking a per-file maxbytes.

We already have that logic for lseek and friends - using that fairly
hacky combination of s_maxbytes and !unsigned_offsets().

We should combine s_maxbytes and unsigned_offsets() at file open time
into f_maxbytes and check that not just at lseek but in
rw_verify_area.

And then things like proc_bus_pci could set it's size limit in one single place.

Hmm?

                   Linus
