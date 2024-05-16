Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617FD1DFEF
	for <linux-scsi@vger.kernel.org>; Thu, 16 May 2024 14:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715870515; cv=none; b=ejGu5LdMLFFYegheFgMdI7lngDIk0IIimSj4gmx+vustGltz2o7tV2GrkccpLzSrIUYwREBvFhS22ZqM/3G4NhrRsaHfNPqySS/fgXUzipZjkvx+FeUvjVfTk94PPSGmTL0XMnCiw0oy142iTg8DdRqDJz6xm8r69bnvPNNo4vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715870515; c=relaxed/simple;
	bh=TLfldiVwYsbYT/cjMroyIE55EF+VzSOe9U9KRh2pYf0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B78XHc7bqpbS5aAXGJN//CA4yh+t1E1op33SmRcOTDDnOLS/iZKUtkyGK2bLEmq30wVgYWdDv3vTIOaIdedXRv/QFbvxlROcdw6j5cwWRe24EokJjO0/NVuDghsySOAeRutJ3FNKLHfvX/edbRlgBDSraYHbWaQshwVrLuJBz1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zettlmeissl.de; spf=pass smtp.mailfrom=zettlmeissl.de; dkim=pass (2048-bit key) header.d=zettlmeissl.de header.i=@zettlmeissl.de header.b=Jyy9Cbhd; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zettlmeissl.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zettlmeissl.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zettlmeissl.de header.i=@zettlmeissl.de header.b="Jyy9Cbhd"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6f0ede03023so123942a34.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 May 2024 07:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zettlmeissl.de; s=2024-02-28; t=1715870512; x=1716475312; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TLfldiVwYsbYT/cjMroyIE55EF+VzSOe9U9KRh2pYf0=;
        b=Jyy9CbhdCqLb1SwbpT1u/m0Gb66MOTX26UVr/80d1qQMhAqT2PlbAlkywkhrehelPF
         UnA8fCrSPzyy7/fnmIEpemgH4cAbljRTlymwMgqYo9S22o/gprHw29/fKrwmN4yy9oEF
         ByIKwqm+koIEopa1e29wjZoA9Zaavg56YIg1l9pMJH1lnfZnz9beLkL83esMuccxkeMq
         72u5ki8xvGbBxOuYCcXqVcgPp+2cxkTYCeKSRHQ1kJH6baz846OFovIPykqD8dwd0+Jh
         IQ1q0gChQVTqxr0a9owqbdzFaF4xzFqt5Thos3NG9bc+R2Z03X4qrSS9ByInACz5AZ5F
         deqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715870512; x=1716475312;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TLfldiVwYsbYT/cjMroyIE55EF+VzSOe9U9KRh2pYf0=;
        b=o002n9/wsFZ2CmNMcVaRpUI7pPT5uNSbgnEHTy6ZdUwaxyXO6X5/WdS9sIHYswcjer
         XiTkkt/74yoh0xiYscU5WULc5wDW75OnBcz0iQYUjAoqd97HxXAua6pCttckRIvVkvMw
         gVNgJdKrL3UESYLOLo6GSUdSqrMtaRB8SVhvU1zFzRnqr27C0LRMY2cUMD7l3aNFAfTt
         0hmzbSjC+85wPIpdz0Pa5KIha0k02aeYViVgBTkvlInDI5qu/Mgw9ZutjXf1H5XGgzgC
         gUh8pAWGwOMZaVZwLUFfDFSo9SmYYsbPdv8PsAyYrAflDL98zRwT3l35Wac/TaI4QC5o
         xKnw==
X-Gm-Message-State: AOJu0YxYfdQAyJlhBarJbDl0uk02sKz1UjZ2Su8oVM7EpRXWv/Fz6JC/
	wG0irVyE8Sg1jFJCwCbHsJs8ndKA7Gdf1Yy0/YeS7+ScR1bT4eagc7Z6MxqdTHIGjwmu0naOOFv
	rsds=
X-Google-Smtp-Source: AGHT+IEGebozsG5JlEuYzUgWx+iEZvH5EDD6kBjo5eOeoAE+jbKJR7DB6huNSJ25INBXMQj1RI+K0g==
X-Received: by 2002:a05:6830:486c:b0:6f0:f967:ca46 with SMTP id 46e09a7af769-6f0f967d48amr6665350a34.1.1715870511984;
        Thu, 16 May 2024 07:41:51 -0700 (PDT)
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5b2f1faceeasm957854eaf.7.2024.05.16.07.41.51
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 May 2024 07:41:51 -0700 (PDT)
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5b2e93fddafso146893eaf.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 May 2024 07:41:51 -0700 (PDT)
X-Received: by 2002:a05:6870:f688:b0:229:eb17:3c08 with SMTP id
 586e51a60fabf-24111b0eb4cmr10160365fac.4.1715870511178; Thu, 16 May 2024
 07:41:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zi5YTR98mKEsPqQQ@zettlmeissl.de>
In-Reply-To: <Zi5YTR98mKEsPqQQ@zettlmeissl.de>
From: =?UTF-8?Q?Max_Zettlmei=C3=9Fl?= <max@zettlmeissl.de>
Date: Thu, 16 May 2024 16:41:15 +0200
X-Gmail-Original-Message-ID: <CACjvM=ckhu0iiWYEuGp3vAkVN2guFr5CLm-AkLkLB3f0W4gc=w@mail.gmail.com>
Message-ID: <CACjvM=ckhu0iiWYEuGp3vAkVN2guFr5CLm-AkLkLB3f0W4gc=w@mail.gmail.com>
Subject: Re: Oops (nullpointer dereference) in SCSI subsystem
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Since there has been no reply to my report yet: Did I correctly
interpret the source of the crash in the stack trace and do you have
all information which you might require?
