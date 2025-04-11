Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD2927F4FC;
	Fri, 11 Apr 2025 19:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744400648; cv=none; b=Nrzh86Q4GiBbf8RYakod7pA9GBgyOO8LQVNmmL2Q3iCx+v+k74KxOa3QNbhkjSsCayWAv9uDa+gpa1fgIIahQQxyqaHesSnpBcqE2EuA5PfqyPBwHNgCBQUt+Kf9qoQ0oQAT1NSHczuNdlIDk66rFr1TC5gTwGnjDX8LfBf3+Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744400648; c=relaxed/simple;
	bh=uGeh/UIgStngyUj6gwqOrANe61ukEvNIWqQmV5zU4EY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dV85Vf+GFizEsppG7kCiLbrzYWJ1Rqw1DRw/EBGWW5VXUQ/17gDiOMnmD7eiHX42lKg/E+hgtGwZAxeGbv5TnZNbq6Eir9ZcY18Ro5Bm8ctWz3ZSjjk/gkI8UPgsLJg6B8awiM84RVU2Nn/34i+yPR18oCU/SWCARe4+/ZlrUVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Py9h9zgh; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Py9h9zgh"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6fee50bfea5so20725487b3.1;
        Fri, 11 Apr 2025 12:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744400646; x=1745005446; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uGeh/UIgStngyUj6gwqOrANe61ukEvNIWqQmV5zU4EY=;
        b=Py9h9zghItG0fw1GcYsNOYDj/4jeiIiA1+Y8rD81WMUuZJc51kf9fAVNT5Gx5jl3cl
         7jFK51o3CIPGRxQkdFazQcIB/CzwgdPCPv9ighFLF3/aMPM9xF0D96awxDdSeJFCLbgV
         2iWXflSiMdZUbE0VRbUvO82OTI63Yuh+o7aU5zxD6/adYREUBoNPKym9NtEwZbzouuHA
         PVmz9kYH37PBBulfVDlaULeFN+r5oYMfOPid9psLLNqH7P6vgpkftiPVmZcvTMFv5FME
         i3XsZGN2VAOpSkAjCPHnctWV7VslgHcgole8oli1BZZ3k05UtWvYH58WytKIpd+aHPfW
         IXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744400646; x=1745005446;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uGeh/UIgStngyUj6gwqOrANe61ukEvNIWqQmV5zU4EY=;
        b=V9YcSTN+C2tlcWgGthEVxk9w6bw2ru47Tdn6VLnCWxMkWiwUe+s37TtmJqpRB05dYl
         KO9I+qrcP9hmShZnm0w7cA95ICK2XRa973CXd+/RbS1BEj72RUxiRYSuZZb/ztoA8BMq
         Ki+NixGhvbfT74SfYfZOv+qqSjxcmi4eF+9P4lCcshdGg6dHALyMzPz6yFIQ31+bngG+
         vbOYb1Wr4u3fda2Hweko2mITVZDu8p42eMUGzfZmOxfMTAmfAxgbP9dzFJx1Z7vDISQe
         Vb5ks5nxAjJXgtsczT4YnggdEObAPp0j1AMHjXn13YfkIqiIFEQTCvkiWqKTnOxM2qic
         2fSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUt2f7Le6jV63jiw3OXiw8ixMsFv9PJRcOVBfJhYlNPyXbDzidwAolNbUdySbI6cgLWw59TjrnztgvYNok=@vger.kernel.org, AJvYcCXUX2KWRdcAeIvcZtcxZqr0ruIs1836i8959HIrDJHzRh4E+RZwGvXRGp1fO/QT5ykgad3BPfiSD/DKHw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxMLFZAw4XFkNKvbcbzC0Cgz0dNlpksHh/1OJGd4z+ecflp8KVo
	Hva3XOmKGTjaOHyVXjnxitwxhJKMdu2koIIQuuQXXukZlLNOyP+IRFYoazc3thjSwHwqqhXD9tl
	OkcP3yj3cvX7R1MS+gltqIdE85QQ=
X-Gm-Gg: ASbGnctElT75tEjeYlgzxmtgx8G0ShHRbnR9Ln6R55luQv4Un1vtb8yjERyjBCnX+74
	twl+c7CdioEzVNTqRoVWVV0JqcC5q13T2RY3g791hf7tJCoI+ObW4h4W0UpmZNgjYWYwMQJAlfF
	/qCWvudFo6iLdio1xe8Iyy
X-Google-Smtp-Source: AGHT+IFEnwBammycbfCZDQBYHdaI0KWtrfEeTTOSzL0yFxfEGr8mHvI+9uEO/WOAFjNSV8q/Z1I5SgcyT1A6HrI5rPQ=
X-Received: by 2002:a05:690c:3607:b0:6fb:9b8c:4b50 with SMTP id
 00721157ae682-705599c9835mr76926227b3.13.1744400645752; Fri, 11 Apr 2025
 12:44:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250409-fix-lpfc-bios-str-v1-1-05dac9e51e13@kernel.org>
In-Reply-To: <20250409-fix-lpfc-bios-str-v1-1-05dac9e51e13@kernel.org>
From: Justin Tee <justintee8345@gmail.com>
Date: Fri, 11 Apr 2025 12:42:26 -0700
X-Gm-Features: ATxdqUElLovRwptujdokF8EU-gfMPJaoffHCrnZ0MROGa38ttKerU5zFA2Zm4GA
Message-ID: <CABPRKS_Fr6BT+pO5vGBaeNTcb3T5Yi1OJ7mEj_4+d9qSvQGrCQ@mail.gmail.com>
Subject: Re: [PATCH] lpfc: use memcpy for bios version
To: Daniel Wagner <wagi@kernel.org>
Cc: Justin Tee <justin.tee@broadcom.com>, James Smart <james.smart@broadcom.com>, 
	Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Thanks,
Justin Tee
