Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0782122D78A
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2026 00:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768956385; cv=pass; b=PYSv9+ZjSgQ8ftz2gD74/a6HcTaZeXmV970cOePZohi953wAQ1m99cXFcv2UjUg4Blgst5yymhkOm7biflzTM1VtOgC7eCzBhG6JLU39KMcE+qtkPzve4keFN3aPCOY/3DWFpYaBG0vVitkcMSxF5Bzo+oBMS5sR5wU0JJR828I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768956385; c=relaxed/simple;
	bh=L7+YvRlmmsHVmw7jPUevJWwuNB8empKN2tKAQTBU6aE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZxCzG20+QPgelb1izK3WQMEYF9Wl2Ibx/T96CqzHoGvPsxFaSOmzKVtOfvCllo8AsLLKl+sAawF62tkicH7bGc7tnCkVyhvMc7yn1/5YwBgNB/O8/f6ofZG+Gj1O1SCXbA2e/MxPZ/554IAeEP/R72Uf/yUvkm1ArBiKeQS0Z1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WfAD6gsC; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WfAD6gsC"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-502b0aa36feso3979741cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 16:46:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768956383; cv=none;
        d=google.com; s=arc-20240605;
        b=EFNIWZMTCGhewwB1ZXmup4VF79pLtuAOrzqKzUr+Da5DN3agh3cH+I7724ppuq1Cf5
         8PzfjzDlxYDwy2y+3j5/ge4EeiaTmOfRF1+0Wce5COOLWCUwvmJjeWP3+qSm1U42Xxqi
         QSUk9+5ZvDNjohqs8dQZto6zcpXDUDubg6oOmI+d/OrD6Z/RSF2iF6tz9dPyQ/Hf7byU
         QU7dDDs4N9YNwi4uQwQN5nIGA9IKmOgBYQhi/Wi3uLOR1r/gOA7nkGGCntN37rZetr+O
         Xo6FX9YpfGz754k8vJCRn54ksmsLW71nueRVRivaslShQXZHF2SPOIn6zZRRr5dxtFjj
         mKFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3PaRYhPHX40XwUTo1x+p4NurlWa0F4ct5LwytkdlOUY=;
        fh=EcLE1CO6SaEF8QKRa9YHq8h68F7PVNuL8z+9rRy4HM4=;
        b=Au72I2HvVFvV9J7p1u6pt9bLYIebBVGKb2lZ29ktIJKTTiBsVJvTlxII9UAoDh5eYA
         jWy+ke/goPTi/FuYHYFayCBJ2mY3o2nuiLUNOpiEymoP90gvJw029eOEPDGSli2IqX9T
         OJTm1kMc2iBkZRO2mNnM5twkBE8eISyRsmLZ8GxYKOYzPV6hQ8e3Yck0loTKEPRDnUi6
         eGe+T/ppj+9YSY/LfxRJ2zk+3oMCwqMs8fty0wjR62FMTmG2dgY1biVlvEeTYN37Jft0
         bMKbs4RkGL9+XPmT9OwvOxthv5AhMiG9rmJacTB1wuYY8W5D+jidU2dRd0FxuIUzuILe
         4ujg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768956383; x=1769561183; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3PaRYhPHX40XwUTo1x+p4NurlWa0F4ct5LwytkdlOUY=;
        b=WfAD6gsCoWupBz7fTjypcP4sHlt+frw8Bi0mhgnNdgAfW+lsYNE1vPP58aaZ2skU9/
         VUpu6ejbXaC9qv4/MbrpBPjG0uId2c6aA/qEv+kgULECUkveNUoI3Kno5phy449EOjI7
         ob23CfUbYo6Kci+q6+Osbjftt2R3uKIcMFzpL3QpaGwyhYE+OSkY1DL79fsdw+43Erkb
         O5y6hWKkz4JOpQXgqA7JkzYcZPwJHuRfD/YNqDo6qTwodUF04pr5WR5/DbchL8bQ/TJo
         JcDzQHOesuYhqcqrn13ZgUHajsrU6GNnDncgP/H8I1CSUz6ezS+4Hh90ypCUi3eEiqhT
         sdnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768956383; x=1769561183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3PaRYhPHX40XwUTo1x+p4NurlWa0F4ct5LwytkdlOUY=;
        b=XrrsVlpbiny2/tl0csYXvr/C7ZxRDnrPijQZbxcOC+CNF/tsSJg2jAdSeCFYMvtghf
         05XoeuMpva/LSpxpv7R2Imta7DzTiuoz33VngB5HeI4NCnB7ngnzMHBV9jQmxctxX6FN
         qbpdQFJ22fTBX+rzOCEDHh49Fa+pwvWonJfBUo1xoNpvATssbVopsByt/2AzrP5dly+N
         gC7UbNyJy15mrCaTvzuPSRQNhZ18WcuYwg3qD5daeRDdeqrdrCnDqK3JZZx0owT5aphj
         GAR7KY3F6wKO3UqCuva2T4K4KKI+FvhkqJ1EdJSG9pX/POsEH8WY6f8IxPg7ySbj2X7J
         R+PQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBWcUIZmBi0zcb7lAh2fTTCoEIrdlrWkycEQGJonAlljkj9sHrgdRwQqtAynKCo50SxwA4RRaZqrX1@vger.kernel.org
X-Gm-Message-State: AOJu0YzsrChRgvrARt5oBKRG6HBZ4+e/CZQcbk/hdkWZrUSBK5ovMjQM
	2Z3Uh2rj4/TH5KJFCfqlJ2wok2o1RNx5WNLZ2UD4iduy5XxBPVFjC6/lvTVz4T6VXxVxtRssewW
	fMLAGU+FPPvlXfOp8Be/fBtUFbo/lwiE=
X-Gm-Gg: AZuq6aKWfGZSKi5GlwxddEEvqMUwuBx907J5R/vqkTrb0LkPo4u6vY28ovcI1b7TEb2
	7qXbziK7KCmqebNe+ReP0Usx0akfov0RxxMaQO2xcaXYTBIoHDT5f2hOO6M1Uwz2ODv6v0MgalG
	ifTAGJmm0dLY03mtD+g/kao0NWD88f5UDMrGDjX5L3FZ11rBdB3g2NC2WKK9xQwIyEVI8HUwy6S
	3TH/sFtnAM4Al8uC+uho9ZkjmIgKBTD2bJl6Rs8rlTR54rTKeXqcy8utLbbZu0phIae2/91
X-Received: by 2002:a05:622a:3cf:b0:4ed:9264:30fa with SMTP id
 d75a77b69052e-5019f8fb7b6mr310557491cf.31.1768956382904; Tue, 20 Jan 2026
 16:46:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113222716.2454544-1-minipli@grsecurity.net>
 <CABPRKS89zwXdUT1Bhj37cQDyOHNupOJ-Ez6kS7Dp_pu06X9Myw@mail.gmail.com>
 <CABPRKS-ongXPqWVpNYiKvy_afVKn999bxtSEfsBVQ7z5JVCgeQ@mail.gmail.com> <59933d92-eefe-49f6-ad70-79fe7aef0f3c@grsecurity.net>
In-Reply-To: <59933d92-eefe-49f6-ad70-79fe7aef0f3c@grsecurity.net>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 20 Jan 2026 16:44:41 -0800
X-Gm-Features: AZwV_QjvxVbc9XI5JGpt5b6TxYiJ_ddM2ot66uWhwHDOcKm-B630v_jysuW5rKk
Message-ID: <CABPRKS8C4WmEYX+jtAOTS_jeFYt_GeTp9uBoWzCMF8cUZxxzUA@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Properly set WC for DPP mapping
To: Mathias Krause <minipli@grsecurity.net>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>, 
	linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mathias,

Thanks, I think I=E2=80=99m able to reproduce the call trace of concern.  I=
=E2=80=99ll
have a closer look at this patch and will report back.

Regards,
Justin
