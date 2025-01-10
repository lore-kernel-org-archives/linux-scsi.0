Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A14207E19
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2025 08:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736499321; cv=none; b=kOLts/1VHsXufry0Mac1doJ2MTA1jbhonZHdLVOOpfbFQp2rXdYbzp11qfU3HsOroYg7fjN4Uvs3X+RaKlUZvcmIO/s7vpK/o+NVsx8oWjkDiEywXMMJpLMFCUGT3i8NIB5yUomIwW5UKqR05mGIDThNsixmYucWJvnihc73RCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736499321; c=relaxed/simple;
	bh=cbmAgBIFGegMw9/n64PG7MiCf/X/4twOdx1csl9BLho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fCZ3SK9Fa9KmpzG+JnONVS2bf673OfHm4ZrVGpsEMgo6vc3o5BqlM4BWoqIMG8ka83Rp59paVa//u6ACwB52B5/UuB6tqPCUf1MNSS2B2NNN2fF6pDUtdopE/++p8Nu/ZeBFnTOt2xSM1nAZjKU3iZRgv6Vn6HB4dq7Em9IMKew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HnmeJPxX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HnmeJPxX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736499316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cbmAgBIFGegMw9/n64PG7MiCf/X/4twOdx1csl9BLho=;
	b=HnmeJPxXvKe4kiBou1wyPLffXx83HpKCHnWwtbmiAQnA51IV8ES0es4ERl9472fFLhNHzz
	BfZORQ15a6I65owTfSxxio6bN+ZU/XwBRc7AR3dysn4cT1w0EoNewdVcKPqyGTwrxaa0ED
	uUwpgxvcPL51KKyJajY833QY7328mRc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-C9lftecXOvqhLWMHzWDZ1Q-1; Fri, 10 Jan 2025 03:55:15 -0500
X-MC-Unique: C9lftecXOvqhLWMHzWDZ1Q-1
X-Mimecast-MFC-AGG-ID: C9lftecXOvqhLWMHzWDZ1Q
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6d8eb5ea994so20854336d6.1
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2025 00:55:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736499314; x=1737104114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cbmAgBIFGegMw9/n64PG7MiCf/X/4twOdx1csl9BLho=;
        b=l1PAn/atGvm8W27mxNpVdOQE0Pkjnx6qSwaF5cwBX5pW3K3IDjmMcP+jUfwQ67YcO1
         NJPZndkqbDVjaMhbLDZ0vOBcJltypXffFfMD6Fsln7O5XaeRe67Y/UYddwnWOXow/7Fn
         wSk2z68Okieb/4Q1XSaIjSdtEEyzCw3mfJ4SPfz8nDqqdCZuEBwB1kPsykUN8MX06oZE
         s7JYnwxU8h9WIHIidEzul+QGBRhe+r5eMGCWwgv9VZKCrqWQXkP7Xh0MssysAqQTTfd7
         l6Jzxp5rHTwnzkD87xy6y/y6ROOYY9tjp9qFQbM2G2zQVDLDfvg1MhEYOkMWjmHzP1yN
         f3tw==
X-Forwarded-Encrypted: i=1; AJvYcCWLyMsq1/zQEdCi70bycmJwlhEnMtQHVPUbrgpd/0F/RKZgXA1SSvl6vXNB+qZUxKL0PBnAMP5m6/OM@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3ImJtU3GYdUFyDl2w4zsbdRBNvHdQWEf1lKX7BwN3QczcgP21
	TF4AEicNoeCOdcuOXx7YyOi8lPH2+f38RE867ZXKfpnPUIZjaf/O/Ye/QEzVnZN5qW6hy9G6d1r
	Rm+4TRjYtWwu0bdWctqFvHjpByt1VhOUT5AKxc4PF1/WzxnmpBCesSxkf7lg6aK98y41bAKU8K0
	ZYGXD1i/me2xGgVVgt7EvQRmQKRIv6vFiIXx+FflII9Yzb
X-Gm-Gg: ASbGncuoN5CcfUtpdsUA6PtQrrzkrP4r3d2bq467vjsvcGSH/fI5RMiMKFDCdJP4qk0
	EWL8i5d6rllUuPTV1mOdVoYx7G9J+q+q0HBHRbw==
X-Received: by 2002:a05:6214:5087:b0:6d4:2131:563c with SMTP id 6a1803df08f44-6df9b262054mr165554686d6.27.1736499314553;
        Fri, 10 Jan 2025 00:55:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlFJ0HS11+WfG0bEtJnjkEwNkOKy8oKZOjFbOo4kwZMQuiwkXmEgjDB8+21fXJ6QpeTexzK3Pg9H5Pxdc7LOM=
X-Received: by 2002:a05:6214:5087:b0:6d4:2131:563c with SMTP id
 6a1803df08f44-6df9b262054mr165554486d6.27.1736499314213; Fri, 10 Jan 2025
 00:55:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241224101757.32300-1-d.bogdanov@yadro.com>
In-Reply-To: <20241224101757.32300-1-d.bogdanov@yadro.com>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Fri, 10 Jan 2025 09:55:02 +0100
X-Gm-Features: AbW1kvYnXJkhbPEqu4IpXNoV5UnRXMqrTZBLlHDj0sIcttE3Bl45IJFK-3u3QEM
Message-ID: <CAFL455nr=4V9ObetZaoECTTvm8wEREkQDfbFN_9_dqjqgJQ_Vg@mail.gmail.com>
Subject: Re: [PATCH] scsi: target: iscsi: fix timeout on deleted connection
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Martin Petersen <martin.petersen@oracle.com>, target-devel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux@yadro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=C3=BAt 24. 12. 2024 v 11:37 odes=C3=ADlatel Dmitry Bogdanov
<d.bogdanov@yadro.com> napsal:
>
> NOPIN response timer may expire on a deleted connection and crash with
> such logs:
> That is because nopin response timer may be re-started on nopin timer exp=
iration.
>
> Stop nopin timer before stopping the nopin response timer to be sure
> that no one of them will be re-started.

Looks ok to me,

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

