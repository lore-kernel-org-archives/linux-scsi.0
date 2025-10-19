Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3364A22A4F6
	for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2025 08:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760861464; cv=none; b=UM8IHuYjTPp+3esqgZN5CBLXAkPRjyGwye8OpQ4z5XzzA8dNWx07uyCezHpO18tY8qEcSk17fovXJ14AGdvmCGqto0/dgtfiKRr4MlNnWgtJ7EFd3CLYQME/jKtQuxzmJEa6UMCK222pzDipCY3xCS9wgN8saug4DMcBAumZdZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760861464; c=relaxed/simple;
	bh=0JD5EhU3dMvt2TzDGGngYx4VWjKCENlPlTrXXievwr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hJm9VnC0K0rJxXUkvx8veGGyn3W+wTE3l2gYqtGQ0ybm5JBtQbPjtaxH2B/JFfQEDDu6QEfJH6PkSlTZUO1V4BVwtWPhfnZ/+z/IFwiwVX9ouZCjKmQwOSC2BN1plExZLpluZYWKVNfULnx3jTYP8z7+1G79BdzeLfsDwqPbNvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ccTdEhIo; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ccTdEhIo"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-780fe76f457so38487117b3.0
        for <linux-scsi@vger.kernel.org>; Sun, 19 Oct 2025 01:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760861461; x=1761466261; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JD5EhU3dMvt2TzDGGngYx4VWjKCENlPlTrXXievwr0=;
        b=ccTdEhIopdhypwI8L3JBil5M4STne8SmRaQFfCBM02l9LkTDCeY07VksMZS734XIYW
         fSr9E0vMaFgWvM5hpUfvHCdQwXqN1rLdg7uGpCmcE1a8p73wsSFiGM9KgaCUVorU2bB4
         QXlk0k/rKjfCpslj0HWJBncYE9y9o12Mjtf9KUBJxsuzUFBzDISvTP/UdlOzuowk2O9I
         i6m0bPW8oTEyUXCgLGFGHisuLGD8VhQ1MKnYlEu61P8OxgXOJsE/nO9c7FNSYyLg97yE
         4ySn5cXO9k6TDK22f8AGkED3Ks52VuOYFicnSfjIjvJlszMjZfsukHxg61ULY8iC4TUN
         9kxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760861461; x=1761466261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0JD5EhU3dMvt2TzDGGngYx4VWjKCENlPlTrXXievwr0=;
        b=OlANlLlZsGeKU2+b6botoN+/cBzjvEoinQtiDBHHCPgNXyDsrWrxvKkc7IvejUwRnW
         DZjF51/Bz8aIK3jtviVey5FwS8qdJ0a0EQmP3B5uB/GGqpMhHIo+4OpMr0sFXR12+SbD
         tx0OQCrRDON4kRk5teB/l++U6zEIO0zHpTD0Y1YRg28hEhtjvtCJzXJK6nPFMdiVLZNX
         Lj+79pmRQj95t0iPJ2257ttV2HiCHOeJwT12Z9B53F08n48eYv4UpghDGALwK1teh58w
         1bPsisUnS3kNdVWqXScv4IOsG4ZEf/NIxPOOWrc2qmrNCAH0Dwrcm5Zi+99yOwmtj7pY
         AMnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW/vZ4Xbq8D2g7RdMNNAy/QV5b4Vc7Zgsa2kVfmYcQQ/w6K0/uVaaspenLZrpG7WSs/GtXQ3kfQRFo@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw0ofjIv7kSyMv1pcG/C5ilUt77ZCe3TPaBfuHLjUBqwDm5YpV
	eTpznqFSXzDoSAmWCFkbpQZS3XxYBQHRlBmy6UGQyrBObyFdlg0bkhMY5MQX7E3WHW+zqQpEqv5
	X+si+Fbtws5jtADuoQitefkKHWRTnDoY=
X-Gm-Gg: ASbGncvtUE1ll6vWYTD0UOfMwzsmC+Lj+rQsRtRXTH3sXJdTVyFEw7LcEl6CUWw/Q3v
	bKSBv9smKb8zRNhrrtjyRTT9LhqUO6P2G1n+Pcd1rsX/7QuHJZbv+DTSWMZb7vAv9vqFWXrpacg
	bgWI3p71pwRw7qtOGGAufLJ4IAG57o6KyTBYNp4hJ/usb5F5KPS5zeDndiMeiO5yMFohzT2jpNv
	PK3mP6dSpkEhxiJrOUJAj+ka/2TJgbDdoi/jSEKVF4sRQvEJAspkNKzJYMEM1WFR4sjCrWGIY8=
X-Google-Smtp-Source: AGHT+IEDp/usYEtVSaz10lwwm2/rh8YYcBuxag2F0nuBjSfSMoio/EijPl9t2f1PGKCDHr/mRoxnx6oC2CKJ7h3r2Ic=
X-Received: by 2002:a05:690c:31e:b0:782:9037:1491 with SMTP id
 00721157ae682-7837780ba2dmr109813007b3.42.1760861461100; Sun, 19 Oct 2025
 01:11:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241202010844.144356-16-ebiggers@kernel.org> <20251019060845.553414-1-safinaskar@gmail.com>
In-Reply-To: <20251019060845.553414-1-safinaskar@gmail.com>
From: Askar Safin <safinaskar@gmail.com>
Date: Sun, 19 Oct 2025 11:10:25 +0300
X-Gm-Features: AS18NWAhDVf2aU8hB0qWERPwO9zi-ils_dPukaoQchmqqRauvEb3B93Zz-69KFg
Message-ID: <CAPnZJGAb7AM4p=HdsDhYcANCzD8=gpGjuP4wYfr2utLp3WMSNQ@mail.gmail.com>
Subject: Re: [PATCH v4 15/19] lib/crc32: make crc32c() go directly to lib
To: ebiggers@kernel.org
Cc: ardb@kernel.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev, sparclinux@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 19, 2025 at 9:09=E2=80=AFAM Askar Safin <safinaskar@gmail.com> =
wrote:
>
> Eric Biggers <ebiggers@kernel.org>:
> > Now that the lower level __crc32c_le() library function is optimized fo=
r
>
> This patch (i. e. 38a9a5121c3b ("lib/crc32: make crc32c() go directly to =
lib"))
> solves actual bug I found in practice. So, please, backport it
> to stable kernels.

Oops. I just noticed that this patch removes module "libcrc32c".
And this breaks build for Debian kernel v6.12.48.
Previously I tested minimal build using "make localmodconfig".
Now I tried full build of Debian kernel using "dpkg-buildpackage".
And it failed, because some of Debian files reference "libcrc32c",
which is not available.

So, please, don't backport this patch to stable kernels.
I'm sorry.



--=20
Askar Safin
