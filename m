Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF6C1DEFD0
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 20:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742330365; cv=none; b=MlXW7UxF56V1foU4GblFr46QOc0WT/a6l/tO0hbTS/9AEFrl5ln1oKZ8ZMPQ1psXXBkRx7dl+JmT7iwTEF56p6TbPBB82Ubqn7tpS8GPPASSjSIhR6x0gAlJdJyPfYKSeCk/mHQ3TnuVPDfSBsIMID+3lCc6BGwiZlf1DKGEEWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742330365; c=relaxed/simple;
	bh=e9MfqshB78R0AVrqHzfH6QpuNfge/9xRRaYBxtQgCiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PwsQKOHku1Q/Cu9Hjga32yu9jCJdEhM0oGHrRqsDNrSZeBgw89W3W6LZmkjs80O2nI/a+keTDiUOZnetwICBvB2ZviGoY2exBW/OzrsVZmuU3L6vfq+zh1htH84rEB4wku2jBlCLXZ3eyUo0a3mYeL17pV7+rncsbytLUQtSor0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RAcoGf+f; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RAcoGf+f"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e46ebe19489so5087449276.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 13:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742330362; x=1742935162; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eEr2RMZoGjmZ0MhdLMunyiJMNVUsI9BD8xK0F1nmCVY=;
        b=RAcoGf+fOxNWJdEyS95aMJ65CKmipJuwBNeEiOnLWicLLkW6q/Ch/99FUEaMI620VE
         5eVDpjnTSB7wwEBE2nU42JconsbBYl7uix/I10GOEeAAAvduDlECicS+1I8Pkv3GbB82
         8KF+1qIj+BtzwchMorJ9ZLrYzsSNGL7mVoccGNQ/WeVzJtEQap0GHu/h+hEBBKAIRPtD
         mYOM6EqY1DehDg3FLfSpcC2iCcfI3R2FfoN5JRPCAoOI5nEllaxrclM6Ho9PxlWsJzrs
         opLIDq1KLiGSvRKk9fkrtTN15U6jkjA3Rr7+5RAV9+rsymXlLoINI7pQ1uXDciIG7XNV
         Iq3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742330362; x=1742935162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eEr2RMZoGjmZ0MhdLMunyiJMNVUsI9BD8xK0F1nmCVY=;
        b=WTnJrpUnd7cZF5NjAk+unksMLalWaeyEBWMXox1nNFSSx/CuSR1tMAME+dOy/JlfnX
         fcUqI0l4tUsi6GriJMp/sBekCNcvqCzCK6+5Ss8LkR/0xaEsaKCohfpSv1lrADwylNtM
         RQ1QKtv8H+wB0GWriMwaIfGpp1dC+AgOMboWkxrRjzQTc65rTimR2m7diHkTQEh45atV
         xwTcbOW8lV5sB2OBIu0FLwInS8atQ8IQ/OmxmNBzkcVRXNlCZjbvaDtV8RCHeRRTkOw7
         4+ctSwnayfbZbve5FdO+yFjVFqwXCtlu4IOQ6WpQYs/3m/DMzqTiekmMa1mGxKnjUzIW
         4qIw==
X-Forwarded-Encrypted: i=1; AJvYcCVjl45wXR2HGHJAdLkCnJfRSh/vQ59zwaZekt3UoGPtzeYagHo9X0A/qrLsa9LvLu8IzSAhIxANoLXI@vger.kernel.org
X-Gm-Message-State: AOJu0YyqptlFa2Zz7OQn3PUx0WHE91jQ8/vhs6Nmx3CX88eQFOm/TNfo
	bEkhBpZGSANkt8zjw60ZlPsc/jHcjPGN+/PwGlxFqqMWXQlnHeRehA1SXnz2P+tTyT9b/2RU4s8
	pmWRq7f5lieCQfBD0YATWLzwNjkX5H0MM
X-Gm-Gg: ASbGncvsHORyGJAHfbVm5QxtweANGTplbhV6BuocJa15Hv0EKXmcqlUx2hl4YxH6OAb
	x5UGgv7RbuAVls8pECn+FJ1SbO3PbGb5gP/SG1l46nv91XnzpdOLpUU1IR7WGCgYkK6h5JWrtnl
	LWuIohAC1QvZ7odKv+sgub3U/k2UY=
X-Google-Smtp-Source: AGHT+IEYiJV+HVAaZ2Xt3SjyQ9RbXv1AjwgwSnzF7os8tHmapOkzmNwc1V58OnL+N8NUMa+VJmmbQ4i4RGXfkfm/zus=
X-Received: by 2002:a05:690c:fd0:b0:6ff:1fac:c4f7 with SMTP id
 00721157ae682-7009bf4ca51mr3732607b3.7.1742330362444; Tue, 18 Mar 2025
 13:39:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <41c1d855-9eb5-416f-ac12-8b61929201a3@stanley.mountain>
In-Reply-To: <41c1d855-9eb5-416f-ac12-8b61929201a3@stanley.mountain>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 18 Mar 2025 13:38:04 -0700
X-Gm-Features: AQ5f1JooXVhTpGIVAoxnp3P2lO-Zb7eqk42_OjJedxBjMMqsrDCH7MFFsGvgI4s
Message-ID: <CABPRKS9NkGWrUs4fM7Kxj08yyQXZUJ26zqkoyZeNT7tkjNMybw@mail.gmail.com>
Subject: Re: [bug report] scsi: lpfc: Prevent NDLP reference count underflow
 in dev_loss_tmo callback
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Justin Tee <justin.tee@broadcom.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Thanks for bringing this to attention.  We=E2=80=99ll have a look at this b=
ug
report and get back.

Regards,
Justin Tee
