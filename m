Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0433B195809
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 17:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720633266; cv=none; b=uqbdMsfFtxa4MGKh9w6Q/AasjPDp7dOryQ9bKEUnN25PjUALj5JPNOCUzk+Iey7GZ1YhEdy1nl693Br0cjbF3ZzvDctdryWpkVBkT5wenNFlCj46VMjGCyfx4NHM+R6sjqTcYb/9NI/L70CfvxTLnx59admzRwuUIsSbTQfTMB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720633266; c=relaxed/simple;
	bh=kieP6xzFL7Gg5G/N8KEDy5p1BBDPzDxX9idQeOXBBCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BnA8JQ7lOCJsu0qOzVhTEuxsSJ083JJWl67mO8zudRoxtEl+y9vXON8CuZtz9hEJdfU79Fp/p9NOwMX+bhOn71mUcmELKKLZ1EMmfz/Bpj3Hx+9UD9M/J4pPRwKT+1Qd1Z7tuBO16BLp+KMes2PBkN7o6TwouYlAfYYCcgbIf/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zettlmeissl.de; spf=pass smtp.mailfrom=zettlmeissl.de; dkim=pass (2048-bit key) header.d=zettlmeissl.de header.i=@zettlmeissl.de header.b=S77dJL15; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zettlmeissl.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zettlmeissl.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zettlmeissl.de header.i=@zettlmeissl.de header.b="S77dJL15"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-703ba2477bdso834860a34.2
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 10:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zettlmeissl.de; s=2024-02-28; t=1720633262; x=1721238062; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kieP6xzFL7Gg5G/N8KEDy5p1BBDPzDxX9idQeOXBBCk=;
        b=S77dJL15mFMJcobFQvLNw1RypIiPSlvkU7UkjOWtIltencAZJgZjG97UoQfMgeMTCb
         UCW0WKFV/HTPlu/P0U0Xk8EgfAtGDI5sgTLGmFwzhONnJWHBJlU+Awe3Oeqd1j81mj+K
         yfRG7kWk0XARp86jy2VQl0mjQXOYJRZrHOCXTxVXUxAAg5+rPisrjDlce/a1J5yZqNEU
         IkqTkr7w3/a3iTnaNJM6vnjxlhDFSKigfvm5rJoUIHCMrEPpfuL6lTdxJ/RxbAQ/ihj2
         fRg+FaPREJd7IDu3AfB1+6jv6bu9d7fCucBQqdokFatfbzmVJy8wEyQHcpAZWvUKGl6T
         U/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720633262; x=1721238062;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kieP6xzFL7Gg5G/N8KEDy5p1BBDPzDxX9idQeOXBBCk=;
        b=PLcUFA376OOmCmhPKjizM0U3d59+z/cr0mSSDNBGlwBkko31IVMzm5puMg8wHpOM2t
         lk1ug09utuI+5533bsgAv9X3fmpjoiwQ3gAnp8jYCBgqXzIhU/LVF6h7dq+p3ZFTC+LH
         jx9Ry6OIZyjgwjt7CA01HfmbBq6rad6n2S7Ad/qLxJj+7sbgwcRV8yHsJUCO4M2rnslR
         hLJPKIb7eRQE+5Mzdx5HRFCMdBDb9F3fAjEdojdVMeJrc5otqpWgNwsfZs3Kh59b6JsK
         lFDM17h0t9vzgZYmrLvgY4y443C3tXsCq1n1jO21YGYw1A3DD71UEXrFuj7uNkPPUv4c
         ZP5A==
X-Forwarded-Encrypted: i=1; AJvYcCX7GkhWVI4v2sS5NSF8n5h9wNYp1GhP+SdPLi+wPyPJJB2LPIkJOznx+rzXrYkIZMgYeMxaPq0MImdOlvyhwXNOMLp+/eAQXEgMCg==
X-Gm-Message-State: AOJu0Yy20VTKcO4gE+DSo9xjLZrg/QTbVDMq4VuzP+59RBOK+EuAs3nB
	+XWIKpxRvAxAnUaQqcXYSewW0YXpTv6Udpybl7PUbwWpgpdwyUm7U3YfQfrChYBJxU14t5lDMGf
	JvAA=
X-Google-Smtp-Source: AGHT+IG8lfaQ/jsPlekVDYhm7czKut1ujqKQj5GNd2lx3zUqw9+0vWgY952/9YaA16upuX2RtwBs/w==
X-Received: by 2002:a05:6870:310e:b0:25d:f8fa:b53a with SMTP id 586e51a60fabf-25eae7ce03emr5410196fac.9.1720633261944;
        Wed, 10 Jul 2024 10:41:01 -0700 (PDT)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com. [209.85.167.179])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-25eaa2a2195sm1291681fac.52.2024.07.10.10.41.01
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 10:41:01 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3d9400a1ad9so44280b6e.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 10:41:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUu26LlndycsD5iiE2z9Lg8MZfge46V4NGd0+1VnU3Yx2ibIyDfRD6uPmbYUANrhpFEV/uRMG5sUC73YXps/HSE9br613bWebht3g==
X-Received: by 2002:a05:6871:798f:b0:25e:1c9d:f180 with SMTP id
 586e51a60fabf-25eaec877abmr5272925fac.50.1720633260911; Wed, 10 Jul 2024
 10:41:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zi5YTR98mKEsPqQQ@zettlmeissl.de> <CACjvM=dA7MqfAC6_fiWv4LvmN8mNPnNG_YXoKnEz6t0vzyRkSw@mail.gmail.com>
 <yq1r0c8a65c.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1r0c8a65c.fsf@ca-mkp.ca.oracle.com>
From: =?UTF-8?Q?Max_Zettlmei=C3=9Fl?= <max@zettlmeissl.de>
Date: Wed, 10 Jul 2024 19:40:49 +0200
X-Gmail-Original-Message-ID: <CACjvM=dE3c=s+x8ei7W2-PjCwUGrXpSJEMGF2pWj7VaUcMEM6w@mail.gmail.com>
Message-ID: <CACjvM=dE3c=s+x8ei7W2-PjCwUGrXpSJEMGF2pWj7VaUcMEM6w@mail.gmail.com>
Subject: Re: Oops (nullpointer dereference) in SCSI subsystem
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Jul 2024 at 05:19, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> I appreciate your thorough bug report, it is still tagged in my inbox.
> However, I haven't found the time to investigate yet. I'm afraid the
> CD-ROM side of things isn't getting much use/attention these days.
>

Thank you for the reply, Martin.

Take your time and shoot me a message when you need any further
information or logs on a later Kernel version.
The shorter reply times described in the Kernel Bug reporting
documentation had me a bit worried that something was wrong with my
report. I thought that someone would at least acknowledge it in some
way after validating that it was reported correctly.
