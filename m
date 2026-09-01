Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593CF12AAF1
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 01:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788226467; cv=pass; b=ToxzwnshMG0U1IYU511YJB6s9Ykltr8t4hIqQcMliGLMTl+Pr8R1DkzzchgbWt7N8G44Kyo/A6dTW74Qq5+gLJsiRtyA9f4Ef4tmtnaQfCt1ixrHjH/Idb/la0ThqbruwhufJV7cbqoK69qhFY9wMNLwBDVtfukgQwoMC7b/bGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788226467; c=relaxed/simple;
	bh=aUEs5vxH9jF9nJCwZv5RTXkU9Sge3nUc5EckvCSY/FI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s3HiLS2mDRVCt97qj/u8xx5lwrCd+CabDcxLk6MryGAl8svIXydCv4YznZNmw/wXRGsPdQ+F5klOhy2O984vNO/CHSk6gKZ6/iKC6wn4EW7pAixPRFERXetCjbqVQVLFbZ1KqG3lkzqPsvuwZkXoIsbXsFAKNhG9ID0nZm2shzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d5qUVcIC; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d5qUVcIC"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-52faa58bff5so127441cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 18:34:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788226465; cv=none;
        d=google.com; s=arc-20260327;
        b=GzutE5TrBUeiJNQXoMg9EsL0UYzAWrGbTI2fdA5i0vmaiP7i4RT6FnQkTUCB4mXXfr
         lttzhUtH5r693jQ9Zjy4INAsN5dXCuld+sMmpfidsTe/eZ87vfp2Gc+FQMXYqlDykEm1
         vyRmqUwfpiXQ4ISZ5QX4NZkPw+Xy2WTKwryIj0SwP9jP/9sEQTnDOklePbFXcErZQyjK
         G9W18uDv35DmfgeNQHh3J2H4e9VAVY3qvszQKi6tnbRkb0C8UVhaNpe4SnkIYOyFxJk7
         cnOZbV+GMg07U5DDzOaHodLv4I7Iod1FNE7IuOoecfVw8o4JZQ5z2RNnqTgVqj+RI/UO
         asjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=VounH2TLCX+icK8ohtB74w58kkdgdhvjkS5XdKNJR7k=;
        fh=V3L5JyzyetNZbrr5NK+T8IRN8+f1fYvhZz2ptouxs2I=;
        b=r2uFRwlu5Kqb8uwPZ7Nd+mis1KmV50YbH3LAjedy68vVvnF88YGIQwM6YeF8xVKPcH
         y5jHWwK+ZkT8BN/HMZSlUiW4seuXIXYkNTnkK3igr2SnNB42eZmNeVshHOH2TpkCPj0i
         S4ywf9mzZJqh1oOqxZf023xbZAlLhoI7RgR0jnn7Q1+NCAEacuYHo3PFAWXwQvcUhoSK
         TA5Wn8zCVAmYdvgM2+Yv5/XHD0rU1BUQj80wx7cigzCMWcsA/Obr46hqjQQ9nJc0kyir
         G29OeH/k08CGbQa4XO/LVYQhknL0URLqGSAGr62NTQUbV0IINmEeyg/LKTZzls5pJYE5
         Hpcw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788226465; x=1788831265; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VounH2TLCX+icK8ohtB74w58kkdgdhvjkS5XdKNJR7k=;
        b=d5qUVcICWnFtxMFQtrpeF5zHkErGJIKPjeIs3PU7Uzti1/fUQWWZxTiuOM6KfvOCEt
         ymf7tMqdg4ZMhZ98hqUJtnpnsLYxwnEe11rHW7WGUWO0zNH1nWyhelbFZFkCnDXkp16y
         RkhaGlGCqnemDbzc/scNrxHRyeKBPhZL5AN7YvQD3nLJ+inVtqRYiyOutVRiUJ5nFGtA
         nUWb9eg84wCm3q6PmL+QrKoA92I4AROyKtrSOK8BiE64u78tWHmffUKUxnnZ4Ya6c53v
         jzRhDhjWIyTyljXz2iMT/mDQUvYUPPMDCUtQ0gohhbvW/8j/PS+uZIqzSR4lCnd53o6/
         fe1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788226465; x=1788831265;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VounH2TLCX+icK8ohtB74w58kkdgdhvjkS5XdKNJR7k=;
        b=evjZ4+vB+U7qNeNMcDkwfI4jneanrWCUjQcTdADsbMINXxtJ/eygXeERK7chNaZKox
         8iSLJXByKoucIT240Qvjyv7orRsnWm+NUEMLUp3GcElNeZZc1PwXehICPiYllD+D8uF7
         CyOYcUF3rv8M4i/IBxq4EZYCKyTsffByIijun0QsIGjUkS0i1YC5Xv7fksYff6+U5Lej
         aaEmjknM3bpqMlWJmBgL2KkTpSZGSJBthyCFnsEXhhUXvZKMpah81YwOV8ijfHFEjj+Y
         okY5WTxUopu5stOplev5s6n4EYblKSznJbHtKOtvF8HfppbJO3ErCUYocTLpVVwyQkeH
         76HQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrxc/pHzDLQq2+yyohlk7YZ6D1gvbA88gLQOgVF3JhHPxioyhKa4+GKfhvm56a1cSn6d1UY+0NUD77/@vger.kernel.org
X-Gm-Message-State: AFuF++llB1LuUKGwJVJFAyvlo/bpJuxdyZYndYqSJ8n6/HUmgMGN0Ptj
	WTw4IWqkh7MMnpGdwIaDzI6DehRYES2p5M1zfiJVw2kBPhh+J+5xgqgJ5tcpKJDbNHwlVeVNWUj
	Vxzp4vpyBFt1pQ6eW6kE8j4adJIBNXoFFZcKanxYR
X-Gm-Gg: AR+sD13E+MiKDLHfMN6nujQF30En6qMwxuBgR9F4Wpkwd930iCrEXCp4JFQR4VLxuyy
	h6+43MF9GU5ZOm1ZqYIb3ydm1Oz1v5XghB9w+i4yj/T+B6t0UkOzyZp4GbH0P5PyTlzT1eYPGZ5
	RWgczY63hw+TDCWbx9m7O2h9FApBBulLgnStsd00SNYRjnaG6dx1GsYOQOcbLVb8R/BunEW16tM
	CbuCLQ5l9KvjwYUDADOkiZscQ5dNiw2OQKuF/Rgflgk+4Q5r8RCDLhYziTN/oKM9Kig5FFDVwA6
	on7V6LZYlILLlkSVecS54EAZQSQgpjAf7/WCDuToVlDYV8ahqWmO+iI11B3/idyvblJX9Z3IYFh
	5ULhsA3Jjqw==
X-Received: by 2002:a05:622a:2593:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-530274756b0mr5249191cf.1.1788226464562; Mon, 31 Aug 2026
 18:34:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831130129.3979454-1-beanhuo@iokpp.de> <20260831130129.3979454-4-beanhuo@iokpp.de>
In-Reply-To: <20260831130129.3979454-4-beanhuo@iokpp.de>
From: Stanley Jhu <stanleyjhu@google.com>
Date: Tue, 1 Sep 2026 09:33:47 +0800
X-Gm-Features: AcwNN1UR0AZpDFzuH5KotfUNB6xie5KyQVQlfhTBFVnUWK0vU3xxZdDP2DIKgiM
Message-ID: <CAE14pddCf1VhLVC_H-Nv30C4BzK_UO4Eknd27g72d1nAjdBdpA@mail.gmail.com>
Subject: Re: [PATCH 3/3] scsi: ufs: core: Report the current clock frequency
 to devfreq
To: Bean Huo <beanhuo@iokpp.de>, MyungJoo Ham <myungjoo.ham@samsung.com>, 
	Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Jie Zhan <zhanjie9@hisilicon.com>, 
	Krzysztof Kozlowski <krzk@kernel.org>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Bean Huo <beanhuo@micron.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 31 Aug 2026 15:01:29 +0200, Bean Huo wrote:
> +     /*
> +      * target_freq stays 0 until something scales the controller for the
> +      * first time. Report nothing rather than 0 so devfreq falls back to
> +      * the frequency it last set.
> +      */
> +     if (!cur_freq)
> +             return -EINVAL;

If ufshcd_devfreq_get_cur_freq() returns -EINVAL here, devfreq falls back
to devfreq->previous_freq. However, because UFS does not set
devfreq_profile.initial_freq, previous_freq is also 0 at boot. On platforms
with use_pm_opp=true, the initial sysfs read or the first transition before
scaling still ends up seeing 0 Hz.

Would it be cleaner to initialize hba->clk_scaling.target_freq and
devfreq_profile.initial_freq to the max frequency in ufshcd_devfreq_init()?
That way, cur_freq is valid from the start and we wouldn't need to handle
the !cur_freq case here.

Thanks,
Stanley Jhu
