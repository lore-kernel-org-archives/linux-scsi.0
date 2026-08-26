Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743102D5A01
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 04:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787719025; cv=pass; b=asWYqAlBj4AtynAw/hqyNyxbD2NA/luJcWmVSNr9ikcEOLwAI8czwaaLR3UKW+UxLsi0RwEIv8GDlfoZsabZDT8Cp0UK55qPP9NJSmGO6/HxqLsM+q5W0ZhFENnYvYZQIrAFmS09//qDxvzZ9LGXbqoXKM1nrYDY+aDLTbOkwA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787719025; c=relaxed/simple;
	bh=xocIVRG0rHG//NgAWUeZnGmxkGXCo2ACyK7AAxZSkhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=USMjUJkWGtB3yHOFrSGc0LldFD9SEFlvOaGej5EC4Fs9hB33eeJ3xPx5xEs00NV8nW9PSAnbcSnOc33ieszYbJSC7XCxtUS+zR8J4ODjdJwSX8oNSmDfNNWhWpSABZKKZ3VG9jNLOd6IrMigAIwsje5onJegzYXeMNMqM6Lv2/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cGAJ0F0N; arc=pass smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cGAJ0F0N"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-39f91ba1ef7so3694331fa.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 21:37:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787719021; cv=none;
        d=google.com; s=arc-20260327;
        b=rdtceRQjKCy6wC2sxx4WJfdmsuXEI/haCz8kZE9vCn81B95pQc3j55xDOer7vlu4iA
         BBTD69rlB1JVBmRGJ1+/lDLM+hevT6WU+I76JJbDl2cZ3p8Tsd3T5ZTwJTsaIo/eoTNj
         O4/49kWHNqJfbtjtecUxyjHHQoyvOac7Ij6wC9KSxwhe8MYkEKoWHwfyWsbwPe74XTnC
         9d1XgmQObl6ADe5h4+MxxqosOToDAnJ1PkDjQcQNrRMFPMU0X8UpIuzTmv/s/xvh/0v+
         NvBUrP0nMRCs/FsvukGbDiRXbRx5vi4EL3hc/zluJKRtIVqs4zxb4RJLHi2616n1uXQx
         Q5UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xocIVRG0rHG//NgAWUeZnGmxkGXCo2ACyK7AAxZSkhg=;
        fh=3/jaMQJOZBEeW+CmNMIqHZS8zn8yYj/KU/6Fy1Uf9p4=;
        b=QqNV2HFQqmpT+4AadYdKDGnR8RVp7DTkA6FERF1SKYJyR0Ju+b9yaIEz1JSDz5y+ic
         RQwfXFvnEWztaOGa5z947n2/j6xPVllaKILxdNs7LpCk+UBtmia770NPEheFKoMVkHch
         XOPM8RXAyeChd6rA6GkbAG44ZQL5ulCjCoUGAtOX6UxPRbsqbNceqw24hPkgSBCgf/Kw
         hufyFeeTdtDWozE2jlGodeRT6aOc/eWonE7s5Q/M4dHwB8H2gGzi6mYqqa6h+9pLhKA7
         wUvH7e1pz39dH7i86gTa63ezclKfXuWZW5jijUvx8iCzeKsI0jlw2cxjwwi37C2Wr39d
         IyLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787719021; x=1788323821; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xocIVRG0rHG//NgAWUeZnGmxkGXCo2ACyK7AAxZSkhg=;
        b=cGAJ0F0NvT4R6rBis1sXGmlDYbFL1VV19zlNRu6fxsdHOyPiLr6oKlbByfrMpa1OTm
         6Fme1vwVYCGahj2CJUGD14C5139xA2QEygzAe/h/d2bnVF9/pIt7YudBNSZsWr7vNJ1h
         y7obhapGDgN9bSP3WPpfP89eLScMoN+xQiyMNYwf8ZHswd36NRb3dyWVXwah1vPVRUtT
         OYIfY97sSv8LFtEjRy6k7mLiSbIUYh6v8kkXtzr+q+SfbUhTB1VKth3lqAkzZgc0KoWm
         gedoMYeZkM9Nb8XlYuTSi/ovm1qrgrz2XRSOD8pmRFSRc9++aUs7hKEg2QMTkQs/6DTz
         Qneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787719021; x=1788323821;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xocIVRG0rHG//NgAWUeZnGmxkGXCo2ACyK7AAxZSkhg=;
        b=ZBQ3YeDZ0pI11YaPY28v7siVS80aiPjLWZtjx2ntCrZ3XtuvK2gKyV7uj3JI4Pn1EQ
         bu1hvrwCKQBODVhAxwNG+0lgf3tP++JbrZOl8bnq3+8hiViOPWIfsem8oJG1Kg/+A+bC
         zpe0GMrwMr744DZhTqTjhfYTiDVZJCh5w3Y9woBnom+2M70nze2LAUCbs/FVv1eqZ1Du
         a8OUdkiW2ofs5Pfwqs9ar04aEAOQkIoiY8h5DSUSiOKAbmsAa6xX+k1HjLZiBGSkNze1
         Wj+zWAGNZjP3PraifgDw/Q8buRYo796Z0jtBLttIJib5LOzey+x9rPDNCVwnrMTWIFjn
         z98A==
X-Gm-Message-State: AFuF++natPyHpytiny5nyGyP6p6nLEAXIFtzmtpekNJqt9LKpGlPl9sX
	d9E1CAajif1vykntQDPZ3cPadgA2wWn5p2EENDZerwZ0kozC8kS0FxxbnC2l4IxryK1LA1nErIR
	PbJAHdrvZLu+4C/N/xucJncB5BYp2bz4=
X-Gm-Gg: AR+sD12RjcSeAvVYRtDNG4CYoMcHFyCRv2fZOaYRjE7akn5S3DHs6f/mNBsOTUaxYBf
	dS8/Nb3bogKTW5it7TrAjcVItk2p2id/uuBwX7OU3ELN3Bez/79X7Gyw+GadwOsd1UeCoyMufZN
	45lMYQgiEZlE2u1mj/EwWI9wkrfPxA4dcuyHVehVw0VbfVa48CcueXidA6yBIogX41UYW/R2moP
	2uJXVqrkkw/mhLYEWrhPajUcxBOx1+OjYxlXi8JxE536ICoBKywqtSvL+3dFo5MehQn+1egViS1
	GsNLpGSxeqqW2M+UVD3r+Pb1gRgYIvTohqPJO1iw/CrQja7sdZpK6GlFyMj9b0GbozqVbZ9Dqvn
	sJZo=
X-Received: by 2002:a05:651c:154e:b0:3a1:4509:937e with SMTP id
 38308e7fff4ca-3a1fd473b5emr7956161fa.4.1787719021154; Tue, 25 Aug 2026
 21:37:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260811124843.6817-1-linfeng.sun.dev@gmail.com>
In-Reply-To: <20260811124843.6817-1-linfeng.sun.dev@gmail.com>
From: Linfeng Sun <linfeng.sun.dev@gmail.com>
Date: Wed, 26 Aug 2026 12:36:49 +0800
X-Gm-Features: AcwNN1XMIbrZFQSI7R58mkoIHo9nv9R24upQZvu6XQgKamt0W6uVGxTu_MiYw7M
Message-ID: <CA+kkGbtea56-HmXq=w85r9qGYB2fxeGyDCSddF=ZiRjgNy69tA@mail.gmail.com>
Subject: Re: [PATCH] scsi: target: iscsi: Fix race in discovery auth updates
To: "Martin K . Petersen" <martin.petersen@oracle.com>, Alok Tiwari <alok.a.tiwari@oracle.com>, 
	Mike Christie <michael.christie@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 8:49=E2=80=AFPM Linfeng Sun <linfeng.sun.dev@gmail.=
com> wrote:
>
> Separate configfs opens can concurrently update the discovery AuthMethod
> parameter. Both callers may free the same value in
> iscsi_update_param_value(), causing a double-free.
>
> Protect the lookup and replacement with the discovery TPG access lock, as
> used by the other TPG configfs parameter updates.
>
> I dont consider this a high-severity security bug, but for safety as a
> precaution, I can provide the reproducer PoC privately to the maintainers
> if needed.

Hi,
A gentle ping on this patch. It fixes a reproducible double-free in
discovery AuthMethod updates.

I have not received a response for over two weeks. Please let me know if
you have any comments.

Thanks,
Linfeng Sun
