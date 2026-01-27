Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B6B32BF41
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 06:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769497157; cv=pass; b=IyXAl1zOExF5kiltwMedUgp+ce8YrMMgRtz2BgkLehl5468iENxIXplXkotvQQpEspm4ObWBTJX/XPDDjpLw8UW6fw+ape5xi6E3oUrR4XfoyL2Mq6HZ30UsalbNtZmOGauc66QXaFmn7G29kbstSI9TTv6olmf9z1QOP+6rtz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769497157; c=relaxed/simple;
	bh=Lxyc64uKF7QoYenR0unF9b9v4/XL5hiToX8HIhOzfaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mRAhF6joUgA0/zLom02FTz0bDsUbkEbvXTaX3uZF4V67FWxK9WSX7L+pnTw1kdILOu6JMS/Ur3nRpMDElNsPUDsqwniLtdSBq6brdpxDeki9uPal44GvW6A0aDhhUHl6MkfYqhgx9+gvVdffauK6adzKLX89LiTfhZ+KCbQ7YPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KYEMnilQ; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KYEMnilQ"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64baa44df99so4284a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 22:59:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769497154; cv=none;
        d=google.com; s=arc-20240605;
        b=IkxpHmyxXcYCgykjLZ1ss6EeHCLgvuXcrUw+ygahrKbDLn7iXVqxjvl4GMu5+S8b64
         Ao+/xcWvqvloGF6olJsFrkJImcR289BT9gdZa1PsojNcldY9cIN0OJzvnS0LKohIxNsN
         lbFZ/2LmkDxrKIcwuK+m+jKXhlBfD+BZLsWbxlM8vaXYNOo7halXWnlDCpUBAm2iM8+t
         YuXqnCFDZo1EDbKnpWVFJvCk6VoLZmSQiRqOGbBht3lsylmJZXYx+n7FTkIYxHBJd/lO
         B+O1bVoJvLA3kOXdgoeYXgw3pS8+NvrxarXJVXHuJk/D8xbSPqWMjcUEmnrhGVGGusDR
         Fu3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lxyc64uKF7QoYenR0unF9b9v4/XL5hiToX8HIhOzfaM=;
        fh=bDKVY6qaWGP2KW44Cvlk4rBhWINhHvCcgJUBSYJt/VE=;
        b=XGyV63u3+6q0rI/PjybAn6HGCxuRxU5WHsKA0jRXmYaZdWx2DOmXAfqYiEGzBq2Vlt
         Bi5dtZEUxgNLLN8OLsEfibnYTRqe22dhbohMLOp+BjXgnEM2AA9cx24K4VPnIIqlgEi1
         IenbJ6HDBew9xuG9+iN6JwZmeb9C/N1rs4mGZVu61OAKEm7yW+c7/DkMk+kB0114MJbv
         1lMJiiGThaFOJUs15GcueItMwjiwteKANHG7YcqjQ4Mp03tua4XxIdLPkIVU56V1johb
         R+RWMOaEiHps67d0YoXcKn3W6Smseiz1nemM776V7lXX5Xg2hEe5he7p5hPxTYsf0rNF
         j7tQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769497154; x=1770101954; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lxyc64uKF7QoYenR0unF9b9v4/XL5hiToX8HIhOzfaM=;
        b=KYEMnilQX5CA9lNDfWSbuh+1tMK5fXBm6Po4taD5qpP2uf9+F4jcn1rXMJ4C6NT/BY
         UixQT7qnRAj67tKeEMsDnaDmBKekal6i8QjitglpPnQBs6icUl/1dAzrV8L2eHvp/9zq
         OXKl6xfuCzzHWDWoqVVtRzZzDMVI6RPHkflJBkAIJ4XLZaanjTENzwEsRipVtMIm4t/O
         Tofw47d5Frrj4edGosnh+CgJK6cGr0Ixpj8ETi5RE0zc1KALm+0oxtloTfXDyk+El4Xt
         FIvLFZfaNvm833oUHXwalIOLfGXoDp527Qdp4VI6hfu0DdGifjCXZYWveGkAbZ/RM/oJ
         lRuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769497154; x=1770101954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lxyc64uKF7QoYenR0unF9b9v4/XL5hiToX8HIhOzfaM=;
        b=IhsRkKGr/IGk+gxGThcrbW9nHKY1W2Vw1tM721QEYCtxljXG5qZF3lHqJxtDymQccQ
         GlrUHAJ8DMEk35HKR2fHKjjrqRNwjTWRHYXNOcJP1rZTNpHnzg82quw8BXm4QTUIdeON
         s3Bl1erSat3EsjwZ5R7t+eMM54AOekC5ox7wbGNaTDajSv3QMwbJWJPKRg1Ii4Gz1K2p
         jhA6Q5tCh2W7aEFk97JVx0yehEjxD6JveIr4vwQJx/CnmNJiqIhP6j0OTd2brMBT5pzm
         bHGilsjgmZjTVGXeT688J0wXlJZgycz37hElT6zUJkGnPlA3kynzfasA+njja6I9O7ZT
         eKyg==
X-Forwarded-Encrypted: i=1; AJvYcCVAR6G9jHpgaTaDUkgEn5hmNFqdwcmL1SZAQEIOk1vKPRBorHK5pAUjqkDTior8YvqL+fSS5+5pSu1r@vger.kernel.org
X-Gm-Message-State: AOJu0YwNlJinLCGYsJY9zbj7s5BDG6GCbLhcdz+D9KbYiXOCoMfo7CAI
	ZkH2HUm5JqgP5WY8PGTVGawUpZUY8EZvjQJlazV70NqA0JtPmhzf1ufCHrZbBhKuAXI56eyG6mQ
	WZLTNjhrl+cH9lRZ8WxeGpwfl+IE9DVTUt9T5+5IR
X-Gm-Gg: AZuq6aLUPK99yCSJeuab1kEX6KKwyYgXHzNoXYJ+eoyoOB/uxBzc8WCE5gXjVrOdaNT
	c7Mzybgusabd9iGYS+VE0XA5Xli5wBAnKKVrpNUkVTLWu5s2fJO3qwP/ypnRWyTfj76kwXfaAEF
	mLUUAdOM8YYdtzX+uiANKGEQzx+h7ONZvN85024FqcQG3LwxZNvCCzmO8uBv2edqsPMLYhl4TXf
	ck/R/Mfc/ReGq9UghNwzqwLsG/h0hbfLYm+aAqb1ih6jKK8WSG8Kdg1NVfTn9GmvY8c0XEIsBXV
	FyfdhMu+3dRvDytewyp6Q+TK
X-Received: by 2002:a05:6402:4583:b0:655:ac89:92ce with SMTP id
 4fb4d7f45d1cf-658a5f2cc2dmr10096a12.16.1769497154198; Mon, 26 Jan 2026
 22:59:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260123045504.3507948-1-powenkao@google.com> <99f7a432182123d3bf38e5183cbb18457288b602.camel@mediatek.com>
 <CA+=0d2ZKT7ynBLvBcqM3YqLk7tX3knhpNwyL9LKxjB3=KvpVMg@mail.gmail.com>
In-Reply-To: <CA+=0d2ZKT7ynBLvBcqM3YqLk7tX3knhpNwyL9LKxjB3=KvpVMg@mail.gmail.com>
From: Brian Kao <powenkao@google.com>
Date: Tue, 27 Jan 2026 14:59:02 +0800
X-Gm-Features: AZwV_QinYyuYeK1_sQlDGtrWCruTjgBBqIF5hg0tOLkva13DGCeh-vCWiHvvzMA
Message-ID: <CA+=0d2ZLxrDkB+tY9SDu2ikeCU52=8MamEhAagjVyNq_d-V1Kw@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Schedule EH on WLUN resume failure
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Cc: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>, 
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, 
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, 
	"James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[RESEND in plaintext]
Hi Peter,

> May I know at which step in __ufshcd_wl_resume the error occurred?
In our case, ufshcd_reset_and_restore() may return errors due to Link
Startup (LSS) failure.

> After recovery, is the return value still an error?
Since the error handler is scheduled to run asynchronously, the error
still propagates to the runtime PM framework when __ufshcd_wl_resume()
returns. If LSS succeeds during the error handler's execution, the
runtime PM error should be cleared in ufshcd_recover_pm_error(),
returning the host to an operational state.

Best regards,
Brian Kao


On Tue, Jan 27, 2026 at 2:41=E2=80=AFPM Brian Kao <powenkao@google.com> wro=
te:
>
> Hi Peter,
>
> > May I know at which step in __ufshcd_wl_resume the error occurred?
> In our case, ufshcd_reset_and_restore() may return errors due to Link Sta=
rtup (LSS) failure.
>
> > After recovery, is the return value still an error?
> Since the error handler is scheduled to run asynchronously, the error sti=
ll propagates to the runtime PM framework when __ufshcd_wl_resume() returns=
. If LSS succeeds during the error handler's execution, the runtime PM erro=
r should be cleared in ufshcd_recover_pm_error(), returning the host to an =
operational state.
>
> Best regards,
> Brian Kao
