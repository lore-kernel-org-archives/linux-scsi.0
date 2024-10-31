Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79F419D88D
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730388312; cv=none; b=BxMcix5oi0a2eEoAsThP9IWs6zgMUVM8k9RN6Yt5o0itQhC2gfbMmC0xXOp8NihrG0D2xnxqU8fpcep6lXdQEL2gFqgEGGKAHZtAxpHQ+hWjbCptbk5C96xkPpjGge7xay/czNLLDECZkoiSKjWVwWq4uEAuKh15mmrUGDfFgEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730388312; c=relaxed/simple;
	bh=IBz7iT0Zj8CMmdySiYxI98hOiO56Uyzyng5cuc3WVTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NZC1wbCofSbd9FCJdgtQY2MC0KJQdcbWIv72hESTYZf5W2jPzFic4UfWf0Ef9DLCMvCcRMPPzQ6OlYR2WeyRePWnqbG7M9mLS4HRTztW8Kn42KYt6Mee3YguO5C7VxNPjzX8dz0J+16YhaWru00Y8uq6J/lfmCGZ3z51aB8w+V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ehwvAgDN; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ehwvAgDN"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c9c28c1e63so1190625a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 08:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730388309; x=1730993109; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IBz7iT0Zj8CMmdySiYxI98hOiO56Uyzyng5cuc3WVTU=;
        b=ehwvAgDN0X2zoZArz1re4wfyhcto4l8DjbqXZnVDB+NI+l7a84F0CQyiOlc4CQYPKy
         qYlU5QDXZsjYQjDS9r2i0Nj4rPnbyLtpmBuaq/HfhDQ+0Qja4iUvLmtjxNMcIlxBH1T7
         AUnOEwyOv2BdV97fLoKfER0RiRdOUb9oEzWEL0urXRZhqZ6eIA/Vn+EZrGxHI6eL02Nx
         hf5jawlc9UehHkrVIe7HBbF4Xd4mgb91Ki+v23gOp/NVcWkoQejOn6+SvoMvd9t72yJ0
         VIm28dyaNIDT6xdMBO+S8t70DFfnDPNz1OEnpMnQvLbIjPCKBNh1qswAUawy5WsHaMGk
         R+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730388309; x=1730993109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IBz7iT0Zj8CMmdySiYxI98hOiO56Uyzyng5cuc3WVTU=;
        b=PVs9dogixwq7mj3cS4ycJnER9CrCpPdiGYbWZYr5Gh0qFj/NsV3KCh5qo/yzbA8/MP
         kl87J9gobc689uGtjbA4d1JpGHg9RknqVRimyIxYIlQbWXBmZQzJl14ItXuYvv55u5ZP
         9aL3or1OQEWwWMwP8R66b7NpewpS7VcDSRsixsuFDII1DLfUMBQS0qRZRoG8EE0RQ2dD
         mhYYcBQnHwcbQijcrBMCrr9B/oullp+4LEky902ufdol7obGm8Hnhl6BnrwCmKUdt+0y
         dG3nAiOcN6qJDuSC/i/kXLIKTj8xFondl0CD44JIOjoPA441foTJKCvfCbNukf2CSqzf
         kFoA==
X-Gm-Message-State: AOJu0YyJP+eOIvELqaJxIevRzlYg/QeIDGZ6ZS8pkYqHn6iTpyMZ1VCw
	KOIGgOl1g4NPxj7AcRQ0xl6DPgr4YcWakFZyi1pgT5QEtTpVz9OKVGw9f1LhoUoVV34OPrmU4aK
	xqhDJcEGu3OqKUKQgjWZTuqsLQ84=
X-Google-Smtp-Source: AGHT+IEjRmBdV5obQzUFRIu8PP05vEHXNNxnTwKOz9XUJQtOUc5ghZnNUgj0GP9OK257jMQcE4vUWGupTTidcvEvV3g=
X-Received: by 2002:a05:6402:5109:b0:5cb:dd06:96d6 with SMTP id
 4fb4d7f45d1cf-5cea967ac5fmr3006921a12.11.1730388308771; Thu, 31 Oct 2024
 08:25:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031125506.20215-1-linmag7@gmail.com> <20241031153924.03e057d1@samweis>
In-Reply-To: <20241031153924.03e057d1@samweis>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Thu, 31 Oct 2024 16:24:57 +0100
Message-ID: <CA+=Fv5Txr4SvP_+aYcGWF4rD7fM27S9BGoJMN5pFZrwXuKuuvw@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: qla1280.c
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks so much for testing! I'll need to look more into why this fails
on Alpha then.

Magnus



> this breaks SGI Octane and SGI Origin systems:
>
> qla1280: QLA1040 found on PCI bus 0, dev 0
> qla1280 0000:00:00.0: enabling device (0006 -> 0007)
> qla1280: Failed to get request memory
> qla1280 0000:00:00.0: probe with driver qla1280 failed with error -12
> qla1280: QLA1040 found on PCI bus 0, dev 1
> qla1280 0000:00:01.0: enabling device (0006 -> 0007)
> qla1280: Failed to get request memory
> qla1280 0000:00:01.0: probe with driver qla1280 failed with error -12
>
> They need 64bit DMA addresses.
>
> Thomas.
>
> --
> SUSE Software Solutions Germany GmbH
> HRB 36809 (AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev, Andrew McDonald, Werner Knoblich
