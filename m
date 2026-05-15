Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80933F0754
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 07:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778830679; cv=pass; b=piPVJCbsfXZwGF8QgyxilsP3Nr+o2ARm/rvQ4e54Klz0HGU/eOhVN6rd6cnyVt0VUj0kkoCXzUXQ+3s3e1IXVcKeYx/RsG5fpJpFzusYsbU4q9d80bRqmIz8N+jPyja310A1TpTBQxOzj5MnF9o/ns+9miAbF4DwBQlxyrR/19U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778830679; c=relaxed/simple;
	bh=TYZR3TsoDgZko63s3KlVg1+ej5JnQ2wWkWjfhovF1Z8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Oyy6/IOLeVs6Dl6FEYKPX9pWJWyDKUcgP7r3ihyCPU+DCVLU5sENsjgmQb86QKIOargCX7Wa2aALT5oe61JQd+FsKJwk6vVeAGC2ccXznNMBNg+Blz6JW0OKVa5/l8J/k068p0O2KfCrFLthohfzLaQJrVVmp9QorU2zEiao2eg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T0+/u0ey; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T0+/u0ey"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5a8d1f43432so8502495e87.3
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 00:37:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778830674; cv=none;
        d=google.com; s=arc-20240605;
        b=LniDEpsqf2fBFSXRweFccIz1SQIEBv0yk2hMAFTup/xhal+WIFjK3k3u8+3TEcAfVc
         ukxur8egVFCv3TMKxjwKVHdTwKDnOXeitcAmHV95DnUQd27oRHhPKs9LO4JA//fDKk3c
         799HD+MVcFz98xU2Ftf2MAv8ZP75QRx0da20sJfnjL90CuhL7JPo+OyOJKFzu5hamrof
         XOV0Gq4MU+X9p27nFOYwfGkW0Q6AfCX0rQEz4AOOBnSJJthPvF6dCtF+rgBMY6dmvxE3
         YW5M7s5+WHUJWJ0lv/qwE366JpTIXzC6oj1Xr/5xIjpz61JFTLcfDcqA0LUe/KFZqCTr
         VaMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TYZR3TsoDgZko63s3KlVg1+ej5JnQ2wWkWjfhovF1Z8=;
        fh=xfBvqOnE0ZARglQfSLRu2+gg7OaHoquWCDQchhwcJwg=;
        b=KZ6FIn0mJ4wm87lGG76I8E+JFfhqZHLUjywIE14l2M0Z0m5iWFfsKDXoiJULqWpOPD
         eZ0qnw19/1e5WLki96+98NxLq9Lz1dYEwGM6kyzikq28PkizBvj4ahCjioHx7cY41+U6
         2qFjiJxUq9RQaOz2kr3BcryAssLH7y7YrUh2Ofz0w5K8bqIKycGzkEBr5ugHhd+HJuj2
         iZUqW1OaGho6Hz5rFV9Mc/8c889Y+N7iW1zo3M2nE2bAHVuCe8npNYhwj7XxEI3o222r
         urkXLA0zfDMpyBGvrUMowNGQb1TK2CKjSlY8NsL1zrQW4teow68f7e3/t/bDBXOINUSw
         eixA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778830674; x=1779435474; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TYZR3TsoDgZko63s3KlVg1+ej5JnQ2wWkWjfhovF1Z8=;
        b=T0+/u0eyzrTVZGvRN9wjzl+h7Q/dIhziX40C7gw8kwAqwQDFZl6WpLGNrdUbYd+S+l
         +PukpOH7OR2H0grLzaG/bBBFEPbI7piyrOpSMv7EQsD9lBtP7Bjkws5tSbVbGNek6hRh
         xcT5y4yL3rD1z0SkGHDSL3bCNu6qBqq6d6C3ciZKlX/OHwunlWLUpPX0zlCLpxviVvQh
         LnG6kiqTjQaXpyPfbctt+9lzHyOdzMvPrulWXcvsEjUwVP2nLik0b7YJ2zc1Yj3TKcYC
         MysuTrcCl7Q9xV61+CuwpvmEgaXQ7pdftaF+8Impf7+Pnr5d9SF0TdLTurdmnQZZNYJh
         blhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778830674; x=1779435474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TYZR3TsoDgZko63s3KlVg1+ej5JnQ2wWkWjfhovF1Z8=;
        b=CHvhCOMiUl5unEoU9YVlzMqp1VLYfA6uYMJGWNsvK2p7R09oTIFVXBMPBFW4l7ktW1
         xFXcg8bjwkGJSZNZU3Fyns7jm/HFwTq9xIdIxwhk6zm6MVljsblyeUgkRiui3N64HEM+
         YEf272+ATGSLhAr7XooMi2LU+a7uBtgpYaQl9eMElXBVJoyTN0MTosmdRzw0vblxAvxB
         Rj9aOE7xYbyobgE3BMACtCg55UX5vXTOsfApD6+MZ04HrFMTuRAYnQVdAEPxlXGVwP64
         M3TmoM3cS7ikGiZ1R1qOOcAo1M+0fnB+ZP7M7I/6dIRX0IK4Vj4pAqP/jwOak/aitmtr
         V7ug==
X-Forwarded-Encrypted: i=1; AFNElJ/I4TvqAAooHU3uDNuPenaclIiltzm1FKGYoXIa6mapUbahomg6txg2N/J5ZUnQ6f5b1Ked+JoYcpvv@vger.kernel.org
X-Gm-Message-State: AOJu0Yz35NrjQvsGxZVKa2BpaXb1taDvLq2lVeuV3U0B0ladM2Af7AaG
	Fk3eh0KVEc+JbdzWz0vOw4jWvVKsRWPTn1YGo16LYm4m57Fpy4Nhtht2WNY/7QIV5dJQ5pF3/G8
	RJDatrZIlMcgF2nRivrQAZnvfypPb4YIOUvAYQBOcnA==
X-Gm-Gg: Acq92OEthofhC13r6FibS/n7pz27dhYQgkRHYXbpGU5V46fjqcyfdmLvYDgzvlqBEoy
	6h8CkFtjxb7hFUrHxO7NUFhvdmatsoaa+00+V5vN+tpacv8nJs7f1YrdzPodj6HSLR3tLSUxeZo
	XUPNlpeQsbSE10CMWCETStuBazLqAbLO4NcNvVot5jditA/tGHHbn789gh+t8IslAWECQR3ZpFO
	/SyFiCWKkUphiDyf56Ou4gyBkjGno3QdO0VFO7L7FNY9kRJi5J11MnGDNlwztp9Lxjv96o/2hRU
	/w2GJUnNqKCRPCDPmasElYlutc/+7S6pg1Zm44rJ
X-Received: by 2002:a05:6512:33d2:b0:5a8:6d98:df26 with SMTP id
 2adb3069b0e04-5aa0e614a97mr798048e87.13.1778830673850; Fri, 15 May 2026
 00:37:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260507143410.337267-1-marco.crivellari@suse.com> <yq1qznd8mej.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1qznd8mej.fsf@ca-mkp.ca.oracle.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Fri, 15 May 2026 09:37:42 +0200
X-Gm-Features: AVHnY4IwQhaV2ubiaP3VHlrB093xLTNTDHTdheqfRxrCs-iqBN9WoaJeNGFmyUo
Message-ID: <CAAofZF7t4pTi7TerxXZZ6G7xdxAjaWdRGaUMLfMawK8PMQFZ7g@mail.gmail.com>
Subject: Re: [RFC PATCH] scsi: scsi_transport_srp: Move long delayed work on system_dfl_long_wq
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 3:58=E2=80=AFAM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Marco,
>
> > Currently the code enqueue work items using
> > {queue|mod}_delayed_work(), using system_long_wq. This workqueue
> > should be used when long works are expected and it is a per-cpu
> > workqueue.
>
> Applied to 7.2/scsi-staging, thanks!
>
> --
> Martin K. Petersen

Many thanks!

--=20

Marco Crivellari

SUSE Labs
