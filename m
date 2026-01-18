Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED58C246781
	for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2026 07:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768719905; cv=pass; b=TyNBW/yTIyyym+Cr2qLtUR5f1lwIB9F7T7aI5BDahRjsXdEenWTyb6KXi4FRHvOwDEyTd8YDPJGAAEKvfLxAl+BKLWPjZ0ZbUa1ct8uNiRbs9IbUWWFp/VnMM8ZR/IEuf6L04yry3G6JrqX0w/aHgY8WlmvQi4F7wNYHq1PKYRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768719905; c=relaxed/simple;
	bh=LL2Rv7fJjOY73zDYhJrxeavmnW+/YROgMpFc+bHA6wk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LBgqSU+4kFrnE74BumqLBv4USRe6uK/bVwvRc8GgmexLXMzeF9UqHVMRFgOvKYc4x28pudyNxbY2JrXDXKmKNUCQxXjrbGOTvSY6Pr695aSSklhV9DSi1+2rzW9imEemdvM/NrDeyyqa3pnn0WzRNgLYbp2braPr5g09hjQ/Fsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OXsZbUPK; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OXsZbUPK"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b801ff00294so71217666b.0
        for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 23:05:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768719902; cv=none;
        d=google.com; s=arc-20240605;
        b=VD4Dt5izwajbC2/cmI7aChGPATSpyOpvFxCLlT6TZ9zj6xB1mg/somWiIU6t46o1gv
         WMZ+b33jDqxahSi3J9qStHPbJn5cU79IYvRB4pyyvqkMjNkRG82gDf0Fo1r8IpZvXENK
         1YVv2TQ9dRb+PSPtH1PjGBlcfFaWVBozmTlj3UKDePIdsjgVHafKiAsTNzgKT6mITCy5
         VnWdm9K2tsskWYNkX+6jNb2Ljp3oGKGlNpx50eSbZtG16LgjyU9jfrAHhscxu9xviZwN
         7CH8FMLHF/zhUfrPftzbMWFY+YRGaLSAr/Ln/Am6Hqm7qAMpKkTDHDjWzGjslrUh9Yxv
         HFvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LL2Rv7fJjOY73zDYhJrxeavmnW+/YROgMpFc+bHA6wk=;
        fh=foyCPyZ/p7YCL0HodHF3aoivjJJzh2yV0UntYZHNlSQ=;
        b=fi1Tdi7rXCU1es3fdrV8W5vN2sYqlc3HkwogBIwth04iGhIIULQPcCfPpFTFfYHH0d
         Vt2EOq0hT+4OuHe9dr8FqLnGxRJuIuUdfeKm9LZ2GAUrtxf5yidkeEDNFA1Tuzc9cpcF
         RH8K5aeiHbHYqy9OebtKGGaDsTnWfzrdQIxH9a+f2dYERrrK5OQXqKm5uJA/ulLwBwv2
         1TocpWRfizXx7cmnjkWCSkIf0CgeOt6uR82yXiJItlpOhpQlVh+dM2Yk65sHus1i0FyR
         HmlMmkD2okj3l//XPkh4U81ZcPwitptJFdKP1MVJ5QeKE7GbAmblDhbolNIUTlNPftMz
         8wRQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768719902; x=1769324702; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LL2Rv7fJjOY73zDYhJrxeavmnW+/YROgMpFc+bHA6wk=;
        b=OXsZbUPKWZ4L9tOk5VvS9laWNRvGN1VvNzvdVL+GZ0ki6HqtkXExPZr1DNuDAFGIp+
         wi3ZsCxsYvmSvXrFgwiUWgjeL6yNbnEQXIaBX7THnlA9lFZUgx0MCt42R75vqc4NbVMK
         kI5mr7V5nvwL9GMDInboABnykzfqhM8vcjUcsb2L3iHlgZUD5qavhOOgmmRWW1hYtXng
         YrX/GBfOBvOikf2it7yEJlfMbUWSeT7Sd0Jt7rqRrh3M0hO5Ey0lEZ9GvBPIHp4RqgFN
         oSGNBoCNgKKQyc6NEBrblTemI0FrJlZhqx1CJUey9e8D6XsztYJ7LjMlw9isKpgBcXlq
         N/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768719902; x=1769324702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LL2Rv7fJjOY73zDYhJrxeavmnW+/YROgMpFc+bHA6wk=;
        b=iMrT/mYSd2XkGKenoGI2gPpn809VkJL5ONCncwRRC/Jw5Zgq/+Q50FUMk22UwMx8ik
         ewq3Ek7Ti/SPdDDPhEeFGcNi/GLuZueztXZnOTp/JPmtJSUzQLwlLJflaZ2qP0cDlZED
         p+hxqrfEPA3wqvwMCtXW5ZGdxjLeWMKcVQQMa9E7bdeYyVU43M93HGPtWfrlhtM8GxAo
         CksrhhJwsmc9sa6u146977J+m9ZevoB2WbEQzrky6noDRkMoIe5+4od4+18woE4PRXLt
         lJA679S3uMGKpcbrj+THjAkRY+Vzl2mLJYHXMhKpNGT0TZOinzHLp8Z6pgM5j/zsj+of
         632Q==
X-Gm-Message-State: AOJu0YxuaPod9wTfFbgmtWQkGzcm8bMjrg88YWp9Zxl5HMCXUp4QdxNK
	CECwIPGqWnfCnbR8VI8hOKb9WjXgGMkeWzQAA+EGiNLYOXtPAOURA6ztWwHb0VRI8selxts0BmM
	/9xjpFk+t3bkWIu87gOFzNOFqLPai2tGAbecoJBM=
X-Gm-Gg: AY/fxX4klG+Nnz6VW7kHe1FMN9gHXsKk5COY6hpEwmouTkTpDi9QwnlrKfW8PWNdCjJ
	y6p6n2ojYqATHgPJUQf3/TNf8lwB3sEJuCG5o0UWlTabGPB9tKko4cDL/hnigbbFcpqJM9eQxfY
	dHqh0gtuonsnFCociX1jekDiHQLawm2WZmqxnPRSGAmLSjZKoBlXCM6wak6iFy6vl214FbBqw+P
	MR1uKroTkPJ/KuXwTEOyB4ERQ8AiO7CigXfpsWaMfV0cHlXdIoeaKHr/YaMG2MGd7r+2rgJ
X-Received: by 2002:a05:6402:518c:b0:64b:5a76:792b with SMTP id
 4fb4d7f45d1cf-65452acca72mr3496414a12.3.1768719902191; Sat, 17 Jan 2026
 23:05:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260118053050.313222-1-dg573847474@gmail.com> <fba6aaf6-3487-426c-bc57-618c30644c18@web.de>
In-Reply-To: <fba6aaf6-3487-426c-bc57-618c30644c18@web.de>
From: Chengfeng Ye <dg573847474@gmail.com>
Date: Sun, 18 Jan 2026 15:04:50 +0800
X-Gm-Features: AZwV_QjIGSWXgUPoJh1tQiBRQ0NKkGL6Tli-yn8ERfV2P4gO1PWi5Qp2AKpyvlI
Message-ID: <CAAo+4rWx=iipRqeSR2FRibWfbRHAR6K3xOyi8wETUubC2ZV+kA@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: Fix use-after-free race in event log access
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Sathya Prakash <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Would it become feasible to apply a scoped_guard() call?
> How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and =
=E2=80=9CCc=E2=80=9D) accordingly?

No problem, addressed the issues in the v2 patch.

Best regards,
Chengfeng
