Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4472B41A91
	for <linux-scsi@vger.kernel.org>; Thu, 11 Apr 2024 22:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712875206; cv=none; b=Yap6Zqizz+TIBoXCiXwQOxytClKwfHEiz5iWKEgApGMLPg5crJHX7iOCp2FGiwR+FCLIToWVnRwob320iKp8VQtGTKFmCkruPoS71It61taKmbRX4BiprfXUm2OgR0myZ7eBDRhTtVeZu+AMkpQrg7B0URPqFFKCEdo4AmioMWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712875206; c=relaxed/simple;
	bh=S4TnsFcjuXgA9nuQRAvIeS3/zSNBm8/9BgUmS0MLmqs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=UDs6NQGfQBiHPsXW+xk/7ZEeLejbARx57vJ8naN6C2NSShLm5ueR3yoQihpo1vLEaPnn1XI8LoNKJ0yPiLpyQjlYAonuRx6b8dzF8A5q70AepxVcFVgGrY1jqQpoMifydUx4p1s/meNdSfWdfD3tttheAuQ7ozvJO7+arMk2I9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=HrE7Vx3V; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="HrE7Vx3V"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-516d0162fa1so381447e87.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Apr 2024 15:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1712875203; x=1713480003; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S4TnsFcjuXgA9nuQRAvIeS3/zSNBm8/9BgUmS0MLmqs=;
        b=HrE7Vx3VsjO9zx09zpOJKe5SAZpjbJiQlry9KLYoRT4w8RbuXZeMwwSh/XEXQESIck
         gKMtNsMOwu9skWe5ekfDSLBm9kAKGi6YBVIC3zq9r8w2dIOlyjPm54EOXt6ohzfsymWF
         cDzSb8jCYm4lcNa8gKha+9ObHZf9RrEPBm+D1TdrFVFbU1vkRKRrbxomgI18JDI02dXL
         cnJEIiUlTz6UgXyGQUrkOXv+UjTQZKKbD9r7+S62qMAbE7sw33tjxBw+CrspLAqlSGlZ
         MxDn6xfZu/vVjV2ou24iQm57Z6ry3iRc/F8pO+WVLF7OOEwOoFiggiVktAhIxaqG3Nwf
         ilHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712875203; x=1713480003;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S4TnsFcjuXgA9nuQRAvIeS3/zSNBm8/9BgUmS0MLmqs=;
        b=D34GrTr/pV+lbi/I3dH4v4rrGJoWv6yD/dkE8tMlMYtAGEWk/Uxbi457tJBK0ib24Z
         Z0a7DkLMIsoP/madmgv0ULp3vhzhAJnPHHNm8y5x1qnnXWUSoH2k/ZVOVSSltpmne6kS
         XcEhifEGL0/SKM4ie5KRBXh4x16vrTZA9GlNSqEmZbHPTH0GETgZvl1ejOFtDbPLrfoI
         MGoKuLN6O3upI29fIeYIqqpgCy7Eo8bAcfMoqRNL+Z2AMpympL3lVPDBK4maahOO6ET8
         yawg9JXhz2A7nFvwCesXbe6E7m2dP3FIai4cyccN2w9UK9FmWA+768MBHJ8vmPJ0QhcS
         /mDA==
X-Forwarded-Encrypted: i=1; AJvYcCVWKkA/vbFf4hSiVqlTM+baIMH29qWbbm+JrJi0a3A5dAtyj6wYi5bFhR9ucNYJn7PI99KjWkrLZGXMAa9pTxwVOv8DY40GM3JPUA==
X-Gm-Message-State: AOJu0Yz956N3SCFPYpsYY69JnbCpSGMk5xQvQveOfKvkFZQOt+rzYeWP
	bxLLDPgnDlP0rrym0B1aNnhLh0BsyP2j74ib1o+C5hcBaQkDMWAw0gIJZxep0S0=
X-Google-Smtp-Source: AGHT+IGY8qJhojjfCfabFUjR9vvGK5A/WLCfM1Bk52OhJKElMImmd0eUpMrnmf84M99SmcErfv1epA==
X-Received: by 2002:ac2:57db:0:b0:513:eeaa:8f1f with SMTP id k27-20020ac257db000000b00513eeaa8f1fmr649500lfo.47.1712875203340;
        Thu, 11 Apr 2024 15:40:03 -0700 (PDT)
Received: from smtpclient.apple ([2001:a61:10c6:ce01:a470:5d20:8e1a:464a])
        by smtp.gmail.com with ESMTPSA id jx24-20020a170907761800b00a46aba003eesm1144762ejc.215.2024.04.11.15.40.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2024 15:40:02 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] treewide: Fix common grammar mistake "the the"
From: Thorsten Blum <thorsten.blum@toblux.com>
In-Reply-To: <0bd7ccc2-4d8c-455b-a6c2-972ebe1fcb08@moroto.mountain>
Date: Fri, 12 Apr 2024 00:39:51 +0200
Cc: kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-s390@vger.kernel.org,
 speakup@linux-speakup.org,
 intel-gfx@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org,
 linux-wireless@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 linux-afs@lists.infradead.org,
 ecryptfs@vger.kernel.org,
 netfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org,
 linux-unionfs@vger.kernel.org,
 linux-arch@vger.kernel.org,
 io-uring@vger.kernel.org,
 cocci@inria.fr,
 linux-perf-users@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <193B959E-60A3-499A-BFF3-EA7B2D0B6C12@toblux.com>
References: <20240411150437.496153-4-thorsten.blum@toblux.com>
 <0bd7ccc2-4d8c-455b-a6c2-972ebe1fcb08@moroto.mountain>
To: Dan Carpenter <dan.carpenter@linaro.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)

On 11. Apr 2024, at 17:25, Dan Carpenter <dan.carpenter@linaro.org> =
wrote:
>=20
> It's tricky to know which tree a patch like this would go through.

The patch is based on the mainline tree. Should I have sent it directly =
to
Linus then?

I'm relatively new here and therefore only sent it to the corresponding =
mailing
lists.

Thanks,
Thorsten=
