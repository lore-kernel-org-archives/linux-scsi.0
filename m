Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D6F288C96
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792024164; cv=none; b=JaNpt7tEE9d3Xwy2hUl9/cxv+bRPJOi14hOOwEURj4dJB6fRbbERxVIOEzc5CJ7L59nKmNmhYVxTtf5oR2BTW8BJt30e0D7Zk7LOrwv3LLFvYvkN495oFe/GdObgjEOH8MmZtvNeDSQCrW6s7i7iiLxd1krP5Z3peEfpSd20Dg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792024164; c=relaxed/simple;
	bh=zRhYt0pbScMV28bposaiTxEHHImtpza00QQmWkt84bo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AABaOQS2BD84KDkpusTH+M2bHwWnud5JBCg23o7XNp+AgoKK0EzY3Pxn+sWG1eQRcLVKEVJ3aEoICMGaY/HJMXhYQKxFTacWtctk49szw8ZB+woFkT1q3sWJ9G9YbwWmLq2LdOuW3eK1tT5quJDyA4KfQCjfhW4uk2zUl+q1YBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u4qK9mvL; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u4qK9mvL"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-88bbc27f85cso6298877b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792024162; x=1792628962; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zRhYt0pbScMV28bposaiTxEHHImtpza00QQmWkt84bo=;
        b=u4qK9mvL6uhLNfWVVafvmOECA5Lmq78SvQWgc5uSi4mx07T6e75vvivJUW8vqdAvb2
         r8B1JIfFMG1o37rP2cIu4/GTPVQMMMBc85ACMxbO0epxzJYj9J72RPw3qM/z/fsm/vsp
         r5Q6SV0/YaNIDu81BPYtejAgTuCJ0PkfrNDCs0lu1vMVCy7RXojmMJoBF23pMtCM+iSu
         4XYmPz883ullBZteoWE9gnxCg62HMwAyThxNvUgIqCOVswf/GdCS5cyup2tEll1dKdBX
         jO/U0IzO0T7K7goz6t5K2LndGazNmNT9kYi6aQSjVq5xOLez9UDB4kWBgsF42vBha3MU
         Lytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792024162; x=1792628962;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zRhYt0pbScMV28bposaiTxEHHImtpza00QQmWkt84bo=;
        b=jTKqlmCcjXrBQ/smQMEPpeXA/6bwEaNLyD/eQW3+w7LuEj8fmCB5bI9ppzH28o8dHk
         lvjXaNMknrUMkjxlb7la1f5buuy2eSsATxsVSRSGGm17eM4xnFxGRbFVsyuyioNkR7uC
         DwO88/k30/wVJ3TOa6qYmdO2/qNHYb0NaRM3jdlmT9hvPufnDqZU1FiNs9PaXG7ecPUH
         +ZxbQr9UwrGzh/7wMLVOeOvN7sKjErah0oX4mGI608qcNyGwK8916Xs76aKXjONcEwzA
         t8Upn2+Wt+Jc9RD9l0yPsSaL9b6X2QJ7degJApQbOcXmhGMm1MGHmaxJCDpvg7hsbjHp
         WZNQ==
X-Forwarded-Encrypted: i=1; AKwUvBxXlW+wcOP6jroDX9hmCk7PsLGs5liZQ83sqv59t9joEd/zZYyO4CfxiKe1mVLzTYwhEUj9C6FQtRhF@vger.kernel.org
X-Gm-Message-State: AFq9FYKajpElC5TVPKpiWPLa8X8I+c33zpyyMUU9Ij0sem3L+TkZWqjN
	/NevGUBBongYd7FmT2IUx5bqcnMBuBSHANkwgGaJhMWiBEZ+N9J/C1o6149VR6T3+awkLjI0IwQ
	wDKDEpQ88BChFPMb36MNITg==
X-Received: from pfdr2.prod.google.com ([2002:aa7:8b82:0:b0:89d:52d0:c942])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:178f:b0:881:4b47:f305 with SMTP id d2e1a72fcca58-897c49b2b37mr14482551b3a.5.1792024161613;
 Wed, 14 Oct 2026 17:29:21 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:29:20 +0800
In-Reply-To: <sashiko-outbox-169530@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <sashiko-outbox-169530@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015002920.3469178-1-stanleyjhu@google.com>
Subject: Re: [PATCH 3/3] scsi: ufs: core: Clear stale UIC result byte before
 peer DME retries
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Brian Kao <powenkao@google.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 13, 2026 at 10:41:55AM +0000, sashiko-bot@kernel.org wrote:
> Should uic_cmd.argument3 be restored to mib_val before retrying, similar
> to how argument2 is cleared here?

Yes, done in v2:
https://lore.kernel.org/all/20261015001855.3450573-6-stanleyjhu@google.com/
