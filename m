Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E3F1B1436;
	Thu, 20 Jun 2024 16:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718901828; cv=none; b=X/JlmoYVXhxpUXEoSuehH3CBtU9G6y3pQRxHVx6QduhqXXR/FeeSR4mlQgo5xPfnuZPIaK/23VPUu890DkcRP6pCWP/KHYA2nRogdbiqipIw49E5d3g5ri9JTJvLIJrQESmYvch9UVE9Q1VLfmPUtE4dgOHUlYsJEY6lO9McHR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718901828; c=relaxed/simple;
	bh=p5S9jfbwUmvqRP1i2btHbKqu3Moz4r2TjCuUBCtg/oY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=prQD00vyRzwFPOt3NpWbY6pMbctzKQv4z4tcTi/Enine47vf7hrnOefu1jdai9mYfZR8OiUPQyLdukeaJNedTfVZguc7BBZLjlETDDgYkDWs+V7Pzyg2hyneY6CSyJ0RXfcNNcv1P1w4XVEeF5KdL+z/MkyalF8dli2GT6znu2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A7FDs2jX; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7FDs2jX"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-dfb16f9b047so133961276.2;
        Thu, 20 Jun 2024 09:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718901826; x=1719506626; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MpsKA6dN8tiK+ilRBdR/wwMkc9wHaYLF5tM9swx5qe0=;
        b=A7FDs2jXwULbRnrr8gT6ZQywPViiV8pnC46ad2lGCqSOmV8X+izVUi5GYZfqxZDXM6
         Vxs087oTWJarndSExv7W73/ffyBDmPWOxXfvmSE+JxJLORlITIW+ccNGgxzbmM+D4bMG
         GUnAOA5nQpBuxs1lsNcE29aWPsx79XkOr+VwRAy7IWBpJ/lWr1gn2PnmdvmOpOQ4+ZP2
         Q7VNgst62lV7coAsUsoB4lzFjIQsscIc3aU0UnnSIxFpbiOoq5pKBO/C1d5s81iAgLUQ
         +V+vEUklxrT3Oc3AiEakzF0uWGyVZ/9lsXh2xn1kEfI0V77DPSncrtUPArJv9mA45SQA
         +TvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718901826; x=1719506626;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MpsKA6dN8tiK+ilRBdR/wwMkc9wHaYLF5tM9swx5qe0=;
        b=kUwA0GgsUMp76m5liGkzvSgmNLKOI6hayXkXi6dVIjEbSujfcZ/S+KQ5IJBi68Simk
         k2hzkfXoqxlbm0moJOvtzFbbyZAz3DgMhJBTcjlDWIf3zrFLaJCU9odmFTmaAHnscUyH
         V5EV75XZSeb14J5ql+2j8eem052YNa//2ITOuGpTpZeWgl6W3/zMD1vimp8/h5s7rFZ6
         keGmKtaYle/64F1WuzFoaEAe9+ciLlXkDc9QbeVhMsx1Knkhn0k9+wESmkT86/zW99Hb
         aNNZbWWXcpZ5R1oubWtGiW3jCti0bC1UshOeRgBhJL1/b5RA1Dwruu7VjsbWqtfI6L96
         6Jow==
X-Forwarded-Encrypted: i=1; AJvYcCW6TqMqpHyT8VXwILx+Lm1JzFvIWlyNNIkwajQZxngStvhNQFVI6bOF304tM+1DosWYl3PQp9qg0eIchK+oCl/6u/TPG2hEeEhOKGdZRtgycUxBjrTocPcSV5vRTbvvIzm+eUoufvy1ow==
X-Gm-Message-State: AOJu0Yykai979/8LF1Gkv6+sEtMJZpJMX1HOPGXdKG9dfULEdEnIGPqE
	NIA1mZHsT/M30KCVEdz5WLg5gn/F3ngWPUKlzsPT1T6fU8+UR/e9SaZYKsYvQGtAXRYHy6ejWeV
	BfWGaGWZChMEvg42lAchTLS6fV3k=
X-Google-Smtp-Source: AGHT+IF9qo3Y0Z8hx4Q91/rEaLETH4GL8dJgopyoPNv9MOov7usRHZoeRPpAo53RLscGJ+T8lK3qTUbaUnN1ft9P2AU=
X-Received: by 2002:a25:d654:0:b0:dff:164d:6f2 with SMTP id
 3f1490d57ef6-e02be13dd38mr5465650276.2.1718901825615; Thu, 20 Jun 2024
 09:43:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240620120101.419437-1-qq810974084@gmail.com>
In-Reply-To: <20240620120101.419437-1-qq810974084@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Thu, 20 Jun 2024 09:43:34 -0700
Message-ID: <CABPRKS8eGh8AkcxhLswOkaGHB2OewnbCcQd8=WoNiYuxeMGw8A@mail.gmail.com>
Subject: Re: [PATCH V3] scsi: lpfc: Fix a possible null pointer dereference
To: Huai-Yuan Liu <qq810974084@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, james.smart@broadcom.com, 
	dick.kennedy@broadcom.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Huai-Yuan,

Sorry for noticing this later, but a return len while len is 0 would
result in a silent $(cat /sys/class/scsi_host/host*/lpfc_xcvr_data).

Perhaps, it's better to log something to at least notify the user why
SFP information was not able to be collected.

How about something like this?

        /* Get transceiver information */
        rdp_context = kmalloc(sizeof(*rdp_context), GFP_KERNEL);
+       if (!rdp_context) {
+               len = scnprintf(buf, PAGE_SIZE - len,
+                                       "SFP info NA: alloc failure\n");
+               return len;
+       }

        rc = lpfc_get_sfp_info_wait(phba, rdp_context);
        if (rc) {


Thanks,
Justin Tee
