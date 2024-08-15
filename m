Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23B84205D;
	Thu, 15 Aug 2024 19:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723748582; cv=none; b=Nk2wl4eWPgHAHS5A9x8sPNF8BUeI8ktFHyFsuc4uo4vriF3ZdTHTPQtOINtLR9XGfyQxsbh2rDsz8/LB8BvX919DXjQyfrOGaJ84hbkjgi1UPbuAfEaRyWlZppixRQT5K8QGh6hsjaReNoyz4Zli8TYTgLXAdlVbwFpvqcqYroM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723748582; c=relaxed/simple;
	bh=rPYXwEdoUC7hHymrv0U4v7KOoFbGQh+1iMoGKOLlhPU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GrKAxRA6lvzXssFycjk+94Qs7GWbLDjHScpjAqNkjIDZ44i+BeYcnY9ex/4YEjS1kU3BCelW9WXD523r7+YwBBNYS5fOL0jU3p1PdKEKdx3/4F96OlgHyldYgyJKpaxjiQ/G4HXySOhqJbHZTlwxZ4LZroLZu+wPWS5+buUeSrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OB/seB3y; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OB/seB3y"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3db16129143so675486b6e.0;
        Thu, 15 Aug 2024 12:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723748580; x=1724353380; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZOIvKpRMlh8zdrdHV2sndOfzYWoOVHWs7qeV4QPz4A=;
        b=OB/seB3yv4nsNSsZJIPbmAhkGVci8BGXgSNfIaLEE3qzHiJDL0tLIg1V/y+DuK0xSK
         XgyqYnT+QHCF+uClLC7fjV+XRhPGlCSTmkvIVgr+25xK4DcLJkZ+n/IC6w7GOdbANek6
         gnkvtNTyCJFClDcVrPaQYiPabX0CE70MpkOuDwpvIZaVywbytfTI2cq9RJ5O2I53eVob
         Xfi64j/DeIZon6oCfr60rprrNRnNeh9r++KodyHLMbQSzaqKl6TdY7K/EgalvwQutYhD
         3mppAItym5fGNiUpWyv2MinRMOUaqw5btnde4NbdXzSzfMkSYBAm9KZ65cYbevu5OBOc
         wKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723748580; x=1724353380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AZOIvKpRMlh8zdrdHV2sndOfzYWoOVHWs7qeV4QPz4A=;
        b=sQTYSCrsZ71Tke3HzHctg6qX9xIPNQ7G7w5JX+8kPJbIV7Z3ajRq6JaFt6d3Or3T6V
         FDooyPldZaXu+Zbv8/XSjgXqReCKXLWJtsNnq/diU9b3GRaj1Zbh6jRSr19WHA+6tHJz
         ULnVlUqxuQWRNVAOcx3a3xPz6HYvB2DaaZNfbxDgzpIfwA5m2m9n6KbwJLzj7PwyN56W
         GNI9Y72EyceKuPmc/3hTp33t9INtVcJBAw+jtc/7SmfeU4n90n1VhbugHGU+6JBY5TLY
         nScN6ygx276XAGdzmaC9PHBaPCM25moOZdiD3bIURHBfORBVyI65zOzMKwaZMr1rw5+M
         dc2A==
X-Forwarded-Encrypted: i=1; AJvYcCX4X9eIyDy7ZJnC3hyWDt6cccn8osxCAIxCT2eZWXgkp2MCRFOJxvss5Wokh8duXBLk+4tigdg0BNYU9A==@vger.kernel.org, AJvYcCXoXctetSOkJyngwH9REyY6QUhHrqa5l0H8EIon72UStwlhv+RqMkQ/Yl58xv/BcLOFPUw5W6DwtQEw9Ew=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz7MtUn9CowIR/KlFx4gaQDCBdneqXA0gX6BPlpHFj6KTgfGVD
	nt3jbAlfyYE8/kJMUpFwsTJeRe96zDKcxpkBG5YM4Aefb74tRJDPCG3MNTH9Vd7oZi9PkMd7zMf
	OAZxXVlrJbHMh0ZQ0JdJ/jAeQiu4=
X-Google-Smtp-Source: AGHT+IEJsvkpN7Xv7Mb9X2uLdMoNEq5kn8t+hhx5IOPV2ybS88r6JfHaHOPHc6sZ2OTa7yza0nhNVOtIQO75ENxcLqA=
X-Received: by 2002:a05:6358:740d:b0:1af:7f7a:e6e5 with SMTP id
 e5c5f4694b2df-1b39331111bmr84983655d.26.1723748579844; Thu, 15 Aug 2024
 12:02:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240810112307.175333-1-kdipendra88@gmail.com> <CABPRKS9qUmWgTcg3vXEb7JxFCx1n5O7MeeU73LJZAZ0DhGRTaw@mail.gmail.com>
In-Reply-To: <CABPRKS9qUmWgTcg3vXEb7JxFCx1n5O7MeeU73LJZAZ0DhGRTaw@mail.gmail.com>
From: Dipendra Khadka <kdipendra88@gmail.com>
Date: Fri, 16 Aug 2024 00:47:48 +0545
Message-ID: <CAEKBCKNqGpC0hfEa4bzbEau4Mnwvasi6nqwa2HB+hMS2T2EtqA@mail.gmail.com>
Subject: Re: [PATCH] staging: drivers: scsi: lpfc: Fix warning: Using plain
 integer as NULL pointer in lpfc_init.c
To: Justin Tee <justintee8345@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, james.smart@broadcom.com, 
	dick.kennedy@broadcom.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Justin,

On Mon, 12 Aug 2024 at 22:09, Justin Tee <justintee8345@gmail.com> wrote:
>
> Hi Dipendra,
>
> Perhaps the branch being referred to is out of date?
>

Sorry, you are right. It is due to the branch mismatching.

> This has already been addressed in the following commit.
>
> commit 5860d9fb5622ecd79913ac981403c612f6c8a2d8
> Author: Colin Ian King <colin.i.king@gmail.com>
> Date:   Sat Sep 25 23:41:13 2021 +0100
>
>     scsi: lpfc: Return NULL rather than a plain 0 integer
>
>     Function lpfc_sli4_perform_vport_cvl() returns a pointer to struct
>     lpfc_nodelist so returning a plain 0 integer isn't good practice.  Fi=
x this
>     by returning a NULL instead.
>
>     Link: https://lore.kernel.org/r/20210925224113.183040-1-colin.king@ca=
nonical.com
>     Signed-off-by: Colin Ian King <colin.king@canonical.com>
>     Signed-off-by: Martin K. Petersen martin.petersen@oracle.com
>
>
> And, the routine called lpfc_enable_node doesn=E2=80=99t exist anymore.
>
> Regards,
> Justin Tee

Best Regard,
Dipendra Khadka
