Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8042C1E8839
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 10:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736245435; cv=none; b=Oqs1NHRwBQPSVddwobWpr5Ulxfg9tCD5JKZ9jJBiJuGsuTK5KuPBZ5xtoZc2ItMgSBXhgM9SqYB3hJvttIpsYd1h4A3egnvwdFkupD2rcyi3gQAyjdk3SrRo4CJqurI7Fk3dGLRWd9MHH9yCLZ8INFEsbdmRSgwXGk5JyeUVjIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736245435; c=relaxed/simple;
	bh=f40GZyskT5c/R/N8DyVzjExYvlzYyrtbl1SGvGE47fM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UDwcipK7ebShKJLF7LBU3SKmGBFfvrrLIeyk1QPylEKATEpGHBCzM7XJ7AU5HSW+su9u7aCiKKshOiaR76f8SzOt4Hn81Pt8Md1QN1K6T/nu1c9mwxviTqewBUFYhIckc0rPqzXyHmKKpNP+lVei7qS3fi7ieatXk+N55HXzfE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fIU72/bD; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fIU72/bD"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d3e638e1b4so4788a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jan 2025 02:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736245431; x=1736850231; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f40GZyskT5c/R/N8DyVzjExYvlzYyrtbl1SGvGE47fM=;
        b=fIU72/bDW8BlhRNzAZkgD6EdPtaGP/pI7u2DGHMYxpxs2ii0KspHQ58eZZv58wXr3g
         bsKcM1RXHvfo8O1gx3f5306o1dPIzvTJA3iXsi1cNSE4KDDvKUMZHIZF5Mgm+fUd8XPR
         AhfmU08DfJj6zLBlmcmcyUyFmQQTkDo7vu7CCJnLCn/6AGq/iBszMozMfVlSam7mEtWE
         ZRYeOl5ua7Q/LoiNHrzW7+89wgycVa7H7Dp62jk/lKZQQkXWK/uyvX5jbODIBmZseuWX
         LgpNhYvwLWctp1EkeuIUZeF0lj9+MZ97zzYqSJ5QOVklEWClJQIj5tutVj9sHpvG0Z9b
         XMSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736245431; x=1736850231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f40GZyskT5c/R/N8DyVzjExYvlzYyrtbl1SGvGE47fM=;
        b=FWELYF1q3ltpmuJlb2jfhiS5cJI4zNC/XErsO5s9um5BvxteEhZp4/e9/lhjxpU4+4
         qbK5meKcxpolZYrMv/A/fjG+y2dq2bcdwivvajGt/02LvmTNU7F1xcZ5MjZPP0U4BKE8
         8iaUCWdvHmJGPBWmUN+a5FBQkLmCYx29SKERQSMX5O6YCRC4RV3ZOw0Bd1scvqUml1Tj
         FC6lslGJA7ifyB6T5HxvFEUDZw/uabR405cfWR6ShJdkKQ9d/RTM5jW24ZgY+g93NGev
         FN7ppA1fZOHDm1/e30e5wGut0GryYKZ5PtDTajsZiaautCU3fPIwe4EUZmRVPk2AqvvA
         Dkbw==
X-Forwarded-Encrypted: i=1; AJvYcCW5z2BvTEu4b3xN15FNhxYXfcLzmDxDkbRBYvWO5ThZVDYwumIm29hag2SC9KX44s5OSI34/T2TMrQR@vger.kernel.org
X-Gm-Message-State: AOJu0YzR1NYV6pUcA+Nhl/iN9iQexCfAbmHE8bAzHlovLtZ5PV2IYtpf
	rGk9GPz5vlRm0cBsK0u8/IXhN3a8mgewvTOdJ2r63cIB7eaVb/Qd/vbkQkfpzUoYdnUgIPPahw9
	kRFXVv3tqZsC+Fl8QrxpKeDnKgdXbghfNhkMt
X-Gm-Gg: ASbGncuSu2R8kjUhKA6hzf0omUzZnXJ85NLM2xe/VgyUp3dQ8yLL6L5Hg4/GgN/gg3v
	C2G38X4Lvfres7fGxl/jPEG0XLTKGr0IN6TT/WkBXGrMrll97yNDRVI1+NRXzrcOCkc8=
X-Google-Smtp-Source: AGHT+IEOC3r+GC8qQ+uoOx3yBauv/2O1ACtn8B43uGAQwI44DB0iNp164uNOKEDJH7gnxjyAP2D355m3/JaVTeKVPjk=
X-Received: by 2002:a50:8d46:0:b0:5d0:eb21:264d with SMTP id
 4fb4d7f45d1cf-5d965d049ebmr51172a12.1.1736245430674; Tue, 07 Jan 2025
 02:23:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240220090805.2886914-1-rohitner@google.com> <1920a2f6-e398-47af-a5d7-9dad9c70e03d@acm.org>
 <c7635c10-1724-4db5-9568-d554e1c64f72@quicinc.com> <CAGt9f=T5352bo=K2OAa7QRMds=tQC1JspN+zQ2aYxNRDWGSVnA@mail.gmail.com>
 <f5ac9637-99e2-487a-998c-5e63fdd3ccff@acm.org>
In-Reply-To: <f5ac9637-99e2-487a-998c-5e63fdd3ccff@acm.org>
From: Rohit Ner <rohitner@google.com>
Date: Tue, 7 Jan 2025 15:53:38 +0530
Message-ID: <CAGt9f=RffRM=gvvEFvmhWMk7PKDAp3bHhRFFpgaDWq0aV=AKyg@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix setup_xfer_req invocation
To: Bart Van Assche <bvanassche@acm.org>
Cc: Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>, 
	Stanley Chu <stanley.chu@mediatek.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 8:56=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 2/22/24 00:27, Rohit Ner wrote:
> > Can we stick to the current approach of moving the .setup_xfer_req()
> > up, keeping in mind the following pros?
> > 1. Avoid redundant callbacks for setting up transfers
> > 2. Trim the duration for which hba->outstanding_lock is acquired unnece=
ssarily
>
> No, we can't. The Exynos implementation of the .setup_xfer_req() callback
> is not thread-safe and relies on serialization by the caller. This patch
> breaks the Exynos driver. A better title for this patch would be "Break
> the setup_xfer_req() invocation".
It would be inaccurate to tag this patch as breaking as Can did
mention a vops use case in the hotpath for UFSHCI compliant drivers.

Having two different setup_xfer_req functions for mcq/lsdb mode just
because a particular vendor driver relies on serialization by the
caller defeats the purpose of having vops as the core logic is still
burdened with quirks.
>
> Bart.
>

Rohit.
