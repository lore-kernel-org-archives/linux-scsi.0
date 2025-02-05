Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEE06FC5;
	Wed,  5 Feb 2025 01:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738717737; cv=none; b=UaBQalUIlmJd6q7l2lJOWQ+BpOEw0K1pVQ9ZSE+kA+dYm3rEV6I8vxfegL6MwrY7qvx9E4khvuOK5vWmyOv1CGIgzZh/ZzN/CEmtKBpXOwndtEDI7fUy/FM3wONyr+LDI8eyhP8OvvmeLlen9M8GgbNyXF4BQCi9mX6Xo///e1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738717737; c=relaxed/simple;
	bh=AN3QLmMSrd4RddtOjP20RZo3sRk5CZw0dY/9LA531yQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mI5WKYatOz5mKmCoyw0wgeKpBDlNST3+NFs6RSXf6Hnq/LruLiakSnA1QczxjjyTgQsjNa4FAAUq3MYEx1Qt6quVoONwX5FdsxZ9AWLk0agi2CLc67/PBPxsqxRzmYrHBW/IvuZhpuZuikz2HspA8mOPZsMMOB4Yuted0qRc4no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YV4fDXTj; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YV4fDXTj"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4678afeb133so3668071cf.0;
        Tue, 04 Feb 2025 17:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738717735; x=1739322535; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AN3QLmMSrd4RddtOjP20RZo3sRk5CZw0dY/9LA531yQ=;
        b=YV4fDXTjfAi3T/iQ+2QO/RbME7JtdQ9hYqyZwiKPmDKjBPPRA2H4O0hdIjcKkqmean
         qh0EkAYXBS82tRT8/HNGvhdmAQU1E0cvyjU3RE82YtFmw9dVYcxNQhxqwfCeX9HA8XRb
         sX14imdGjSRKNaDLo6r3qwbFThZWy/Thdefet4kRf+BIg1nLtK+nylvQqQm+vhp3iVMr
         +0v6pNWi7VWd3azCGeZvNpur9F7ImQT2shWbTWARLIg32VDetC+R+onfhS81eErfhXT0
         Ko3JzH7zaSS4dARW39yJPgN3bnsZh1pZxvstL/GbhZrm81o044YxfxnRzafczSLCYkkt
         SpQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738717735; x=1739322535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AN3QLmMSrd4RddtOjP20RZo3sRk5CZw0dY/9LA531yQ=;
        b=E2GIYUVr1QVoQl1+JJvwgaDQ6LkygxLSpPiudxyDdVKrxBIB52amypWFmsDd5KdhAU
         Tc428nxDKYPh7n41rwCgdtMArukJV+oCknxZn6rIWMKa2WtVuk3zGQXMXCPyePug3AVc
         chJMrmPfvVswFI+oli9ekNsk2JNJpwjmjeFRr/lEGbp68eFTgVJl/FK27nHfXovkPo0F
         J/50ektMWI52D7MH8XzI5rJvva5J8gmx1kblgnTsd8yBjvCSaIFTp8S5QMGi8kpG+pLD
         QRSyH4eqcRtS5fCeEqDhKWFSpJmTEzOSuUbmUPMc2o6yx2CFgF6MnqFVQNPJSUb5TM3g
         /JTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUC38cvZBPJ7nzrx9jfKD6HDTEA1CoWQ6bzzjT2i6HX/36oycdUu31aSae1j5tGlmtJyjyv/Fy6HcU4DZI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHO9TC+dQhQahdqWNwezYLg3auMa183mR3tMWpq/w9Cox42K7p
	4tFWVYcP7rDY8EczzS8AoUF2k6CHMMlkJtPjJ+ztJWLh7kgr6iUWSEAh7eAaMA3gxB7RH7WWuWQ
	1lBzwY3HDJmO+6f3nPv0uzra6daDu3A==
X-Gm-Gg: ASbGncsJ+FoJcHiKe7t3d7niORHVaQvvWTJbOVwdMz+g/EWiOGw18sHoJZ94P8TcMo6
	K3oBuiUiovoqpf34lfnFm8HnXfBTRZJy+E8ixctYcsRlNxPHcyu9mV+GJUrRZcc/e2xdNh1ne
X-Google-Smtp-Source: AGHT+IFQ+4zNGKV56ULr6UnAMqhJebQ1+H4HPEGXmOsj/uvxeNZ7E/JVDiOdWLKCFuBXVDFX2yE0Myb9kY63SGc65Tg=
X-Received: by 2002:ac8:5808:0:b0:467:5734:da89 with SMTP id
 d75a77b69052e-4701875aff1mr77607801cf.23.1738717735094; Tue, 04 Feb 2025
 17:08:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de> <20250202213239.49065-1-jiashengjiangcool@gmail.com>
 <6221018a-873d-4fd5-bfaa-5c83d09ea2ac@web.de> <CANeGvZX5gcYj+Wjp+t=GLtOePHBjMNmVxiPsk2nruqsbiRaqVQ@mail.gmail.com>
 <444d6d33-d916-467b-aea8-25c61977713a@web.de>
In-Reply-To: <444d6d33-d916-467b-aea8-25c61977713a@web.de>
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Date: Tue, 4 Feb 2025 20:08:43 -0500
X-Gm-Features: AWEUYZnLTw_peeNT7ZWWHnVWWwn1uqk66CBYFMYpr-eGZiRBWj-jl9-9Cr2CpXM
Message-ID: <CANeGvZWWFk4HjFGnzqW9aGc_FPFw_8xx_vizY48AYsP2T7q_WQ@mail.gmail.com>
Subject: Re: [v3?] scsi: qedf: Replace kmalloc_array() with kcalloc()
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, Javed Hasan <jhasan@marvell.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Saurav Kashyap <skashyap@marvell.com>, 
	LKML <linux-kernel@vger.kernel.org>, Arun Easi <arun.easi@cavium.com>, 
	Bart Van Assche <bvanassche@acm.org>, Manish Rangankar <manish.rangankar@cavium.com>, 
	Nilesh Javali <nilesh.javali@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Markus,

On Tue, Feb 4, 2025 at 3:05=E2=80=AFAM Markus Elfring <Markus.Elfring@web.d=
e> wrote:
>
> > Thanks, I have submitted a v3 and added the changelog.
> Are you going to improve your version management?
> Would a small patch series have been helpful to avoid any confusion here?
>
> Regards,
> Markus

Thanks, I have submitted the patch series.

-Jiasheng
