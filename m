Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C953D726B
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 17:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499852; cv=pass; b=iTm6OqhA2Di64LRyLct3tJsW2hcmU1R75gQweNKCzsg7efpoXa1Cesi3/hGMPcrN3aqIlQ3WISXac0t2pVue5QsZiq3cmwbuG0HZLhf0DI88bmnj9K7uvztAw6Ux+zGXD17Bh4COLfPzQ6YAn7ga9ZYNDmPE38nSNTkknl3msXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499852; c=relaxed/simple;
	bh=oNBpSxYwt8yi0UwGHma4JoLIOAwUXw4sn2ECG6WpxpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aRDCCYk83d7SvP+f5D/HdF3SSnn/E+MU31GQQFk0I+7x69arxBHayEX7wp5s8lqgu6Z32abRdA8POhrhBGI7fPvhDvd9CNWSZ2xd7+ncLxjmB3A8Tn1vl7kaFUpkVtITflAQcGphm/yYJouWNxNdN7BnuA7iGFQKTeD6lT9t+yo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GWkaEHnl; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GWkaEHnl"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64b5eb14e88so133342a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 09:57:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768499849; cv=none;
        d=google.com; s=arc-20240605;
        b=O+zOkuLAKyYczHbfHD1o4f5P7Tw0usbU2Qyu5LWPAuMo+JL/0zmVnc2rZMVbuj0Jyt
         mci5GE/6KqenAuYLuyDYzH+K8XuY3D2qvTdLCOhLrukcIB/t0RV0LmO1y3tmB5xhpgkM
         8PHnoHf9Lm7s+QjGUrv0dwNbHy0+Y9bmJzut699UdMCzTZGbIbNi+33ORLuwxw3BVdk0
         5OzlmlqIp6ljNcPXlqX/nZ6D03H2MnJLLJoe78b254MKx/FGPpFaBIS8AQ9SUhagtp8Z
         Rxnlgc9PypYmwEe1bnrxgZRR4CCqUFe8oQAfeCLglS5pN01Fdu24rD9gpXY67kl80IFN
         ncCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=oNBpSxYwt8yi0UwGHma4JoLIOAwUXw4sn2ECG6WpxpE=;
        fh=rgHrGSt69gqIZF7MmI5FPU8i0Nqvn3MeB0leMQqf1wc=;
        b=FLJZlGtZCnPVHISTSAo7JSvua3Aq8nzxfK3dyGHdeb0kQWMdHacGcjJnKGHgsa8wUL
         40wKQLz6PZGSIgb/MDg50RuwAEdFAenUxMAuap6SA/4yC0SCGqVwfTpZz2OXWsv+bH5j
         WhnwLt2JL+l32UMHlLkFoXd5CL9RhXTOZoShuvgxrKjAKcSAdSfMtpRRdfV4vZVfUBa+
         BSYzjWutNwAw3E9fVlXny7nw/cVbnUEdQ12/0LpeuZBgnepWCuOCIL1xH6iOSrnV8AuK
         ZxYEi4DHQdgrfuPgHKPRT5XM++/eiva68lzW4/KEaypqcwFtACTgvG9Cia49pPcU6EQ2
         JaQA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768499849; x=1769104649; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oNBpSxYwt8yi0UwGHma4JoLIOAwUXw4sn2ECG6WpxpE=;
        b=GWkaEHnlqpD3DyOntYumxmZ7HpX2bmTaetHuDF8X4eicv5C0fstFtDkLJS3O3G0VPn
         XTSQJqXGBOUCnYawGuDD4IZcdViF0pPHQMAQqEgSP+deOFfnCc91kmPAYGhNxudpXDPC
         pZQ8Ni4mnDJO9NkAeEubkzHrd92Ab6CpLSnUktDUg0+NHaoDiuoDe/6Qwqq0Y8jzlEGW
         Fi9o80IAqqXwKUoCgC8qwU3jS/VqsLtaDn7UIgnin6XhcUZJd8C22WGlOjiBWsXEvBjr
         1+PR/fOhv50lXASEU/V7VyeAQ9Vh0V92RuRC9LK4T/xyxDl/YCds2CDKjz3Hs6YzENKY
         U0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768499849; x=1769104649;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oNBpSxYwt8yi0UwGHma4JoLIOAwUXw4sn2ECG6WpxpE=;
        b=T7HX7z6WeQhPJHM0EV/uLklqtseb3FRLC393qnFO9kMAyGSdD+qa1+oBfBPDFMIv8L
         J9dIrRPEO5+bJbPyH0uDPtQbcBBzlUNVCqkln2ptdj7QQiI5Pb1rMeym3/P5chH+ecNm
         Wpu85bZOiH7JS+FG46ggzvhs3yFaQmJ2QZdt5PSP0r3j/LG5ZWqvUp5dMmSS/go0KzjV
         1Peyv/FgnteePqz4pOMrwyzwG5Jriiie0ZaL25/yLomDk2y8P2CcI52iDwdpTx+7Pl9j
         prxXF3gF0XBvB0+r/xYAKy0KZpA+PsKUFpChgTrTaW4p79FU6ptZ2esi2dfTF/XS1wap
         hB7w==
X-Forwarded-Encrypted: i=1; AJvYcCXGQ7fjaTMaEd9XFhP6CBRues4ukbfshagY5V7fq0NKl/1mqnkNP9XQPZUDTBiS/OCvha/s+uMtpGIc@vger.kernel.org
X-Gm-Message-State: AOJu0YyPMvEmShXTvXqZfRCegKKEXVw3gh1Zp9GKbVsnHWuOocMddcrn
	bzyWmDCfG1t6V/Ity+8dA2b0SxjmCyKio3KJSuordy7Lb2KCDxEB7wAsNxlcHg2bXc1M+hIQF/j
	o4c8INg6jq1Wtyzi0twzPjQzRNIi4jfA=
X-Gm-Gg: AY/fxX4OKWu4A/4Edo7tTNP8kD7K8VRoyZZ7GyS7lUlhMDQzGYeiE+HHlZBnWZOuXPu
	SdNwunds0FDLPgODmH+ma+FhJ/MdlqonbhIK1NTjiKMiur4d1koHSklikxRUWU58dF8hDralATY
	OcZ8Q/MSCcFBsmOh/NoLMuxyf5r9V4iFhcObLciuBdVOZulKEZNCyHuIjjrKvDxGO0eFduKKfId
	A5FJNXA1YIbFkqepH9LU0Znywj4dtMCRTQ+Yy+RkLr8yXMg5fyhIGw9BAAw68wZzNE7Zjc=
X-Received: by 2002:a05:6402:520c:b0:64d:23ac:6ca6 with SMTP id
 4fb4d7f45d1cf-65452ad0b19mr163841a12.4.1768499849269; Thu, 15 Jan 2026
 09:57:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115171140.281969-1-cyeaa@connect.ust.hk> <2c210e30-e7bd-4b70-ad4e-cc7a1bbb5309@acm.org>
In-Reply-To: <2c210e30-e7bd-4b70-ad4e-cc7a1bbb5309@acm.org>
From: Chengfeng Ye <dg573847474@gmail.com>
Date: Fri, 16 Jan 2026 01:57:18 +0800
X-Gm-Features: AZwV_QgmzT2TQ0mPzJ_ns69acm1P1KA29sZUdIWR6ngs1iYG-7nKKJWizGGG5u8
Message-ID: <CAAo+4rXcHCyuJJxJSWyw9tj_psCXi0BO1Wn462tdnDK9X3kvng@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: Fix data race in sysfs SAS address read
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Jack Wang <jinpu.wang@cloud.ionos.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Bart,

Thanks for looking into this.

> Why isn't READ_ONCE() sufficient?
READ_ONCE() does not suffice because the write path still uses
memcpy(), which is not atomic.
So it is possible that when READ_ONCE() executes and reads all the 8
bytes at once, the SAS
address is still partially updated by the ISR.

> And why explicit spin_lock_irqsave()
> and spin_unlock_irqrestore() calls instead of using scoped_guard()?
Thanks for the notice. I just sent a v2 patch to address it.

Best,
Chengfeng
