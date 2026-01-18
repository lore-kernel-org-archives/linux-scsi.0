Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E437517B425
	for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2026 08:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768724775; cv=pass; b=fBdlLnYASNTVuBfUjGZNeoAFSSvhL80inbYF7bocM0RKnoxCVv6dp7rXYmJTsJq7iPpyO6x55z/s4U5jrmyi/uFXLWZSdXymmPP+bB8TJSRdNbTa+0v+9QajMUEdgDWJLkaRpJMMO6KYpU2oC5KP08nbHc2N8QaT2A17r1cz/zI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768724775; c=relaxed/simple;
	bh=+a8UggOvNst968d3mNf73TKNSess8HaLa3bKiBBQsnA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ezoscsog+C4+VBL+eI2Xs0WXJsayLrNrjHtfXJ5Qyy9EOz54LYH3mzVmtNANfJdwJSnXNjgZwdrqF52p5bf6eEql8r1XxY6XGMqxWXMso5IVvTOfOYL3iqaAjDNMX41B7SKdnSooRDvf4NBfXXZccZBGuYlR6MIONYCixCT9jrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ys7Ap7Eq; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ys7Ap7Eq"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64b7b08fc0eso254742a12.3
        for <linux-scsi@vger.kernel.org>; Sun, 18 Jan 2026 00:26:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768724772; cv=none;
        d=google.com; s=arc-20240605;
        b=VUNAN4vM9lvajVHnRrll0z06P06zQWF2BZac9xBJH+hI4+xr0IyoxZDSEfDkw8jJib
         de2/t5xvB38kXNw3/cNVAO/Toq8YaK498ypJr+gPW40aY+du59yDd74CatA/rtmyd2Nv
         Nn8AMQAiCcHPsD++t1wva7jTOQHsxW+s59ljT/fY7WCBOxqEydzXnB2GViySDJp7X2Dy
         lJBKfOXy3Nk0WjxJGL84Z/R2Vny9KcOrfqq0Nq8n4Odg1/r1ZCFz74G+ck0VtzVyNGC3
         c6v2UT6PGxSEPZZ3Ue6z/r+1eYvSpr9HZlrq4yWvFUz3R+PcqEabhH1taVHIF4gE3rHu
         1xHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+a8UggOvNst968d3mNf73TKNSess8HaLa3bKiBBQsnA=;
        fh=foyCPyZ/p7YCL0HodHF3aoivjJJzh2yV0UntYZHNlSQ=;
        b=YZ//NSk495L0nfAeOyuAtpKRQv9Y9ZJjOiyUzggIzErJnB2GFIVMNnIfCLaXrrJ/Sg
         Bm4FJrqFOViuOegEMb9iF36OAz1kQz1srRUmG4N3AaKgaEerxCyScUUwQrek39Zi9j+3
         /URl7QF/BVKotVNIfstoK4tmIQpKQs18jZUbJAEGHrbDIu6z02iAjdrGpUEn1JCyb+zh
         /t3B3MshkzqI9LnW0zDnUywQ5GzXAHZI2xkpksQiSiHdt9MYNWMyBJ0om7KgQTao4vhR
         ff6lPyoIkTzC1WQ5tpK9ZkZzNRdsJCajWDxguE5aW92Kc5elV1jz8mi8wSGdAGBySU/6
         l8oQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768724772; x=1769329572; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+a8UggOvNst968d3mNf73TKNSess8HaLa3bKiBBQsnA=;
        b=Ys7Ap7EqKjgz4UA3hMpXCPgahWghJVdv8XsxIan+siew8jLcNKgl2LxOpARhnPXwkS
         8TJoy4Tmyb6Vw1BPrIPcOqZsb8dJcPH12K9f72vxXN6MtjeOV9RMm87N6YubDRpLWa3V
         vTwddPpsHICZfL1CgsdaacfofuwDca7rRK27h4qvigbUVWmOojzLuCJYdBDyv9ioujtT
         JhRWM/nXWk6ZKR9lJtCGMXk6YI6oaciPZ0KRHgLV9ZGp/JZHVOLC3/FyEPAb5zllfJHR
         F2dyu0UbQ84mWoszohY7KwN0X5j7BpZkmV+V2XU+H5txHEYnHjML0b+qsl+mA+88r+Wc
         DLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768724772; x=1769329572;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+a8UggOvNst968d3mNf73TKNSess8HaLa3bKiBBQsnA=;
        b=FIz2skM7JtvbB9pFhTkBr5r4VDXtEfop1+l2z9KacfT7ujl6jTva3rvdabquvXTTdC
         yNDr5tZAH+63KRkxE/vPhVPAF1sNg77ZActbb4xiAKF9alhy/Si/x5rg04QdMAF2r2mK
         5pCFDaDP9cBVahPBA1EO5hL+dOoJO8AubYQLMM8x+ZcZGHkkoxwDw8tox37DgTOvZalQ
         XDfJJmeh5bAGkXfnsqAXtYSdRt6MrNIXMghvjkLcvWpUevPqjvs4bZG82bccYXfL265H
         MMw5DailbVH3xaWXooGOjp1YOS6xhkIUeLEeg4YbnMOMXTs/rVly8OXX0XiQjiJPE8C/
         qSjw==
X-Gm-Message-State: AOJu0Ywx0Nl+C98jsb8ctNcEdgNC6XoCFBAzf0kiaUl44dM32RZyriw3
	GltlBUh7POblLXLewzesnjmT9TSDIW3pGFAM27eilZw/2ahsurU1IRSeHyjGCXxF59GRacet1ap
	T6io0PSCNrqxG1450j+G/3xZ+y0ImqHQ=
X-Gm-Gg: AY/fxX4gTGpCwk6FbXgUbOddcMUbOhSMJFCGVmZLb9huPziKxHFGLBLbcdcDqEuoFPl
	Wpnq0xon1BRTGouSqacrMrQ3M9QMxym1u0Du5Uuk46tIrqQoF0TTGXs2T8+Tlx/BAeDa16kta7X
	pYzu9Wn7Hih71oRyiuGIvgcUp2czwqWTKNV5ttQv3QIB5mWK9KU/tLl18bIYs2Zv31GcK0BMnkN
	cIeECJqGP/Mz3LdcjXrmoimmogPBtbHBEs2ft7tA4k3eXoZhgQ2eWKuWNZQwMbcw/a43PaI
X-Received: by 2002:a05:6402:40cf:b0:64c:9e19:983c with SMTP id
 4fb4d7f45d1cf-654524ce0e8mr3347006a12.2.1768724772008; Sun, 18 Jan 2026
 00:26:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260118053050.313222-1-dg573847474@gmail.com>
 <fba6aaf6-3487-426c-bc57-618c30644c18@web.de> <CAAo+4rWx=iipRqeSR2FRibWfbRHAR6K3xOyi8wETUubC2ZV+kA@mail.gmail.com>
 <2145b6f6-7dac-40d0-8e8b-259bab774de3@web.de>
In-Reply-To: <2145b6f6-7dac-40d0-8e8b-259bab774de3@web.de>
From: Chengfeng Ye <dg573847474@gmail.com>
Date: Sun, 18 Jan 2026 16:26:00 +0800
X-Gm-Features: AZwV_QiixSKvDNBAQ7Ye0iuEfY2F3A1fjKgb7keTaRVg5fHgwT9MdcLowus9_qI
Message-ID: <CAAo+4rXMsmUBcTvzQrBjz+4ey-W=UToGps6esfBZGq-1ji96Gg@mail.gmail.com>
Subject: Re: scsi: mpt3sas: Fix use-after-free race in event log access
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Sathya Prakash <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

> How do you think about to increase the application of scope-based resource management
> occasionally also any more source code places?

Thanks for your suggestion on it. I think it is a very good practice
to get rid of problems like
lock-leak or double-locking, while keeping the code elegant.

I would certainly like to keep the practice while making my future
patch, and help adjust other
code to also use the scope-based locking when appropriate.

Best regards,
Chengfeng
