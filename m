Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4B8200B8A
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 11:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741088983; cv=none; b=TjtXQ1FUlZEKgIB5/5hjitzqjfhD8XkP6Gn+jP+UG49TV8AWFpDd0AJt5QsnyPK6l8KDWkjnyYJ6Ri7PK90RoxYLUSGbKarATZW43E7FgKik1qDFwwlEMDeioFWxwGvRPGOEQAEg6O//4F4oOWUJN6b/xFatAcf07W9IKbdVUi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741088983; c=relaxed/simple;
	bh=+UYXnOxCIwrlULirHKNsM/rmv3hmUJmhfF5OSFk6amA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BEx8SByY2u4bM7DFYFvIZ9SFLtuOP45QXXSP0ecXJZofQpMxxoM5fYnC0EwNzHZOWwPJHjnEI/wk/NPeVqXK+5+QVGHMzxvglkCy2mKywVumt8vqEN5VZs+rWwGU71SYHBblxW9GZVH03NmLPkMIiMxcIVpu9i75r767sYJaeyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WPczSK/p; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WPczSK/p"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7272f3477e9so1762854a34.3
        for <linux-scsi@vger.kernel.org>; Tue, 04 Mar 2025 03:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741088980; x=1741693780; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MpdZS1uISB9PX6+/mFmvoGcmNoH+HAc5IkpoWEU15/c=;
        b=WPczSK/pAqOTMboCAqNO59icU4gOm+zyTgyu7nRo/USH/Sw2HSaU9oQDS38tHtAxeS
         J/nQVLjJuz9+k3ZmzR8iqh7rIWhHKR7UmhhzX4GNLDn2UmbR4KGMXMmWdbLO6zDoL0IS
         hC6NcDa2mszfptq7mMvF3wQlt9BBHoESxQZqrSKo8QUMy2CGIVSADzOH4/Nl/rDTzWkV
         Tcu6tmMGfkqHawOhUUFPOlxb90GhGFmq3aBxn7B60+JiN2f/hS+prnWLplp7RL1esuSj
         Tt71/YbIwoSXdfQvjqLE5B+g9f726l+R9tAvUcTnPf5U0BfxKGBRLYu2suxOEj3/GBoi
         bzzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741088980; x=1741693780;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MpdZS1uISB9PX6+/mFmvoGcmNoH+HAc5IkpoWEU15/c=;
        b=l3LNF0WXQKnQHBqbLP4fApbOOc+1HWlcG9iJIlm9nCOe/6S5HD2yiGGMn6OobMpUdr
         OYVXxFrjqovrKlLWJLHS5FAPP/rj6NblwdmlBKnUhL/JMdFBrtEkbsLV+uDVV6L9GVEW
         5Rv4RDh5qLyrdZLE0cxOO9eI+dEQMThlonU+huMsGCE9OthG2VLD1cdvmAheFtgdFN00
         cwW/j1+M+/cvIYecBu9+BrmucGgpAqKTNnkenF+GjybP9m8L9MxG4+WEXhUxenEGnx0h
         LL1NFQfXGdIxVeQWxALCTQhCXK4osAINBSdiTbwCAI7Rx9MHatIecWBgwlpJ+2PFSGtb
         8kSw==
X-Forwarded-Encrypted: i=1; AJvYcCXDlWn9JPz8rnD1sGr7+pQRdGUw4MjUmyK06sd7VxspKOQD+SaGjV0pc7IbH0mg62JvxxyEcu87A2dh@vger.kernel.org
X-Gm-Message-State: AOJu0YxMfH3lwVUlBF/jUCodmjcfYUwVJG872xnu47FsEFsbuZ4tvqtm
	Gx9YsqsetIhyxWL7bcmHfGMcV+Anu7ajLfdQmsp+yUoY+I2vj48sgL7dSp0TyQLA80RPfknVbWB
	B6YKTzbC+QmMa7/Oo28dCx66y/kEc/CT544xcnQ==
X-Gm-Gg: ASbGncuSzZ9AOJ5kQJY91vmECArNnlF/9GLeT92iTNX+Z1jMm6Lb/MiM4lCZQjSmaG3
	rKQ/W6ZRPiFTewWpsvIDdYuwV9BWyLBJjbco3606d53+IZRMAvvezv9GafU2Lz/iVERRXch2QSE
	XFSPpF0nnBOm1mreWOCb4CAoLa7kM=
X-Google-Smtp-Source: AGHT+IEGafDyYI67R/1eqCjcojvEh6ldPVuHGNWY3NXJkAyzvOXEUtHCKhyAhFW7/MlCSqajkBLOaAJFFsTna+x/OIg=
X-Received: by 2002:a05:6830:6995:b0:72a:ceb:d511 with SMTP id
 46e09a7af769-72a0cebdcc7mr3644538a34.11.1741088980595; Tue, 04 Mar 2025
 03:49:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250226220414.343659-1-peter.griffin@linaro.org>
 <20250226220414.343659-5-peter.griffin@linaro.org> <bb595629-f975-4417-af28-8f4924a5ca5c@acm.org>
In-Reply-To: <bb595629-f975-4417-af28-8f4924a5ca5c@acm.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Tue, 4 Mar 2025 11:49:29 +0000
X-Gm-Features: AQ5f1JrFaXvZ7X3TIFZCXeV9ZW9xw5dAWQ1CR6t-L_n-p6-nOP1fD87q5_gFbhs
Message-ID: <CADrjBPrpXH1E2Wt34KXgfdOTNE1v7JCwU3AN7dqoAPYS7j=8YQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] scsi: ufs: exynos: Enable PRDT pre-fetching with UFSHCD_CAP_CRYPTO
To: Bart Van Assche <bvanassche@acm.org>
Cc: alim.akhtar@samsung.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, krzk@kernel.org, linux-scsi@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, willmcvicker@google.com, 
	tudor.ambarus@linaro.org, andre.draszik@linaro.org, ebiggers@kernel.org, 
	kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hi Bart,

Thanks for the review feedback.

On Fri, 28 Feb 2025 at 19:18, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 2/26/25 2:04 PM, Peter Griffin wrote:
> > -     hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_TXPRDT_ENTRY_SIZE);
> > +
> > +     if (hba->caps & UFSHCD_CAP_CRYPTO)
> > +             val |= PRDT_PREFECT_EN;
>
> In a future patch series, please consider renaming PRDT_PREFECT_EN into
> PRDT_PREFECTH_EN.

I was just checking the datasheet naming (it is listed as
PRDT_PREFETCH_ENABLE). As well as the typo in my patch I think your
reply also has a typo :) I'm assuming you would like it renamed to
PRDT_PREFETCH_EN?

Thanks,

Peter
