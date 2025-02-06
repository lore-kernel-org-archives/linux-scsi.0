Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3761188736;
	Thu,  6 Feb 2025 18:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865819; cv=none; b=YzuD/bM5E/Oqpe8fQPgjOsv5WgeTK9iOIYZoW6qbXELnhDiPiH5Uv5AEa6xf5/gqyP55lhIQHmk1HegrDiLWwfHApmmeOwaNqBd0hxKMLC0wuujQQFu+ImSW1/wxVnv9Dj81ZAt598cKGivbMvp9LFD1uif89kF7n1Mab0N3KpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865819; c=relaxed/simple;
	bh=5IoI4yTSML17q45NTtWasfD5ueDXQj2jKN3KqKyCm8M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D9YsH/xo2YNSjjHYyOpPQLMZGY5Ll6C7F8S04gGKGsjmouIOpwQ7Jru9EkRb0JAeK5McNtOHIOLVKcOTTFggpUC3BYVljgUFW7nkhB5YvvjXaDLrrjG02BgSnswxHY7lWhaoghwqiDsCj3AVTiasV2bbEgqnEsmMVko9nrtf6xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IJ2CcHAU; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IJ2CcHAU"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e3978c00a5aso885752276.1;
        Thu, 06 Feb 2025 10:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738865816; x=1739470616; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCWngI2B1htW5cx83uUyl1FjlhlC5ksVMwFAqOIKXZg=;
        b=IJ2CcHAUCgyljKDHiT3oHvtxzUCsDrtaQZZPDkjTtXuW+riS5mR6sWKERj5LyMnPPx
         Rn7zjBsNKdx8gMpR/7fPXwfPDKXMp7053iOUpJkO3th8nqkbzF6VNOLso8IKp1IGazOe
         gT708m1JCnqlt1JjVD1Ff5HR+Wh7lRZVUTLxcZFmjJuqZFFSU9Db5EH3BAvfvAjreohZ
         Op72lRDW1EqqXMmt6WgjTcn52tt4d3hsfRoJWsl8jjpW4w6syjNhmoPFARdUn5dfriK4
         OMt8jVe3eeli1sRqymRqSBTHcfsgLX663RiOLl4IZuc0bk2D5TD6NeGvlF810xsb6Yip
         Er6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865816; x=1739470616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LCWngI2B1htW5cx83uUyl1FjlhlC5ksVMwFAqOIKXZg=;
        b=CJjgZ1bVHw3bG2xFgYSn549WoXB5TQjWZpwxXdUc8KEeU1+WF04lvLoLEqnl7kPHrI
         hAkdpkA2htUA2KnNpzhGTWBGPK5YozKWC7monM7W4s/Q9NsQAi3G1dOUkHLJYF3+xmC5
         E3R0dlVaPHmZ5KLy8nG0UIvokSUFiLYL5Qbo3iEtLRqvkVTeul5hon+Bi83JYI/wAbpt
         cR+rxVTqivPPDhqCEFiH2fAKTymdKY14Ilw29/42m3Sj6cc3NWDG6d5tHRIBejtc89Pn
         rP6eeRp+kR0qC7lPOMIig5BWFVg933qxJuydo1+KtMU32nzEnviHFC4TUTEc6wWVZg3v
         F1Ww==
X-Forwarded-Encrypted: i=1; AJvYcCUKfx5mL9dUZYL4hrwP6jrl07afB+q/3tpLJeS0dkFvJH5Z0o0v69n/nMDjNR5niy+1pBDMq68mbn0rPQ==@vger.kernel.org, AJvYcCUxKp6Th33ehXRq4fsYt5DLmDF2tdgk6aXzfl27SJpDoONNPywkzuYpljP1LiWdAWm9ETLD5gTvM3LyE1s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzT0FX6FACd4ZS0Dp3+rxVfukisJnVauDLYpjX81zlwLuFrogsO
	OUx/e/I+CYlZssONdcJLUqrfO7qnzmNkkFy3wqNrzpDhyE+fE97kz0b1CODCAQvN5/Mx6gdYpyc
	iFuONbjfayMdXQdRFzMsyl551nkJldsbs
X-Gm-Gg: ASbGncuXk/u4ujfq+qsTRwX9N6lE9CH/m8OasBU5X9goUY3z8Ia4sh3ZgxeFfoo8LX2
	FTz6VFby6Ltj+dLiYaToi/P7yW65yXGKmfPenJWXRTucNJXCfQ0LkIMnG7dvA/UOhmsTV8cJYog
	==
X-Google-Smtp-Source: AGHT+IGYHwT07IcKuuzqI2vVcoynHl75sNcEcwEyBQHbPyKXMMOwG1wh18V8QON9Ic15bZRM0v/ZWU9q75dVXk0dHaU=
X-Received: by 2002:a05:6902:2589:b0:e4a:fc25:30ca with SMTP id
 3f1490d57ef6-e5b461e3742mr170284276.24.1738865815739; Thu, 06 Feb 2025
 10:16:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250206155822.1126056-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20250206155822.1126056-1-andriy.shevchenko@linux.intel.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Thu, 6 Feb 2025 10:16:09 -0800
X-Gm-Features: AWEUYZmE8YSSk5_YCRgZyoFIGCGTl9_7I2ZM7KyekN3zHJCn4cfr3i-oHV-VA44
Message-ID: <CABPRKS-7c+8sQPzYugAeQ5OeC6P82XGDjKowkoJZFNaQz59CBw@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] scsi: lpfc: Switch to use %ptTs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Justin Tee <justin.tee@broadcom.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andy,

The purpose of the lpfc_cgn_update_tstamp routine is more than just
printf.  The *ts pointer argument is updated with cur_time, and is
typically a pointer to a global statistics struct used by the device
driver in various contexts.  Sorry, but we can=E2=80=99t remove the lines
suggested in this patch.

Regards,
Justin Tee
