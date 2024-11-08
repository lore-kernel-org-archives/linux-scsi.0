Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3450C1E22F8
	for <linux-scsi@vger.kernel.org>; Fri,  8 Nov 2024 10:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731060820; cv=none; b=jUm3VfDpWWhf+VN0d+a9psuQ+t3UfrjOvuxqiGNsUY0mFrBnYoYGhY2Qpb75cq5yAhP/FoeHfY72MVXYC3ZRcbSU/7WA6xDdkk41SVdsVrGw+dooLQN498w7n0M2Oplta9Tf1aGpTMQ1pvR7GN5Qg9zdycXABVtWS6InLdZz1SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731060820; c=relaxed/simple;
	bh=ea4nlkwkzPB63YKMis8itWyLgLXMno9A2YwLA3UdNCs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DN8R5kDiT9ejlSf8ZogKLn1WTH+yyujH6nm+nFpY47RkmysQTab/AKV6YyC711WEl/v+kXT7TvpUtceZaOxJgOBvIkTH5OvmJho/P1+TVrFy7n2/lUm3oe6iJkuXOdVxjMqj5mS8XdqSexLf52z65ukAl0xvTo70K4dFWJABtGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lbr+DYAB; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lbr+DYAB"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9ed49edd41so352133766b.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2024 02:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731060814; x=1731665614; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ea4nlkwkzPB63YKMis8itWyLgLXMno9A2YwLA3UdNCs=;
        b=lbr+DYAB82qDvt80zijrwV1ZTUJXpwd7MUbe/3/jRtbYLvnj8W/ffzT9ReIuA2TmGn
         UCi/g2IkxMqYQXUgikE8t94ZF1l/m4bcfMZxK1DQHBH/6lA1SFQzatBHHa1HoJaVITVs
         jtXvYqwxO6ttGsbKr++R998cvkTqdGUk6ennJ/TATySRWSx54CDJ8N8y1az3buh5rluD
         MYU28FTDIlfVNvUuG+/9gS4OYTak74Q8bcu36TD00myPsPrcpSMNaug6QmFMb9TT6OQ/
         1Rn3R1AeECKQnwmrIDEYop3EYwsBIBBbG/0MmzCNYmOMcWH1nanmnJ2aZziI3TBg3XT1
         vy4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731060814; x=1731665614;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ea4nlkwkzPB63YKMis8itWyLgLXMno9A2YwLA3UdNCs=;
        b=N959pVio6Q+LdU0+IIK5SzZbbB5mJTYvxUVNDqDSeSidisQtVyzGvJkH2op9CbOyu2
         67ehk1RsmTRgqEvLIxIRZeVUwZKqS/PadlTMhMwHqMFM3i/VZDbRl7EECvL00EEmy4kd
         Ty9Ab+0pYVPKMj3gzmv3R9xiObQXrqwarMLSC0sovdo/AWlI8G2SPb6KjIk7V9AahQdn
         y+Ad4bCj4gVVQuM+hu3X3bzuEqKvJ5AFX5gurbjC3epN19j2gvlBG7TXNxbRoIQ8+A0w
         w8Sik9e4bgvdM3cLblTLDAZeMuAB+6kZTqvjBrUoer/pVCS7urn80y1ZXdmKrOQOzaF0
         XDow==
X-Gm-Message-State: AOJu0YwYCpy9yuLm+k3PzVhBkTjB7zmiNZemYXoc5LHOnRtS05c+f9sa
	N4EBf/XDslB9MCd5OymNldi29aBTz22seYMEb49bmRFxWI0OVLlX
X-Google-Smtp-Source: AGHT+IE+Q7rWMt5oRj/WPYAIVL3BMQmZACcknXv5UlJySkkPAYHi24DWSINfU7/aSBJHfDydNzCA6Q==
X-Received: by 2002:a17:907:1c11:b0:a9e:82d2:3168 with SMTP id a640c23a62f3a-a9eefff1525mr182741366b.46.1731060814311;
        Fri, 08 Nov 2024 02:13:34 -0800 (PST)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0a4a979sm213430966b.71.2024.11.08.02.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 02:13:33 -0800 (PST)
Message-ID: <7bab2feedfdb6ea8038f0772f1a78d04a71f1dd7.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Restore SM8650 support
From: Bean Huo <huobean@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,  "Bao D. Nguyen"
 <quic_nguyenb@quicinc.com>
Date: Fri, 08 Nov 2024 11:13:32 +0100
In-Reply-To: <20241106181011.4132974-1-bvanassche@acm.org>
References: <20241106181011.4132974-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-11-06 at 10:10 -0800, Bart Van Assche wrote:
> Some early UFSHCI 4.0 controllers support the UFSHCI 3.0 register
> set.
> The UFSHCD_QUIRK_BROKEN_LSDBS_CAP quirk must be set for these
> controllers.
> Commit b92e5937e352 ("scsi: ufs: core: Move code out of an if-
> statement")
> changed the behavior for these controllers from working fine into
> "ufshcd_add_scsi_host: failed to initialize (legacy doorbell mode not
> supported)". Fix this by setting the "broken LSDBS" quirk for the
> SM8650 development board.
>=20
> Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
> Closes:
> https://lore.kernel.org/linux-scsi/0c0bc528-fdc2-4106-bc99-f23ae377f6f5@l=
inaro.org/
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
> Fixes: b92e5937e352 ("scsi: ufs: core: Move code out of an if-
> statement")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Appreciate it!


Reviewed-by: Bean Huo <beanhuo@micron.com>
