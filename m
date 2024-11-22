Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72676EC4
	for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2024 05:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732251863; cv=none; b=gR7ajWGBU1V7Onm5a9vZAeN5h4C+s3QVyr7/UE8ZPOlFYm/sEwMOsT8i8gLGY5xaZWET0ymXymwnaVBhCzLNAZKRfvI/MtoYsZs3S9sNcIWUjDoXLFgHqao0xKdYemftOjASm62fNtVwu8lmZplIvwZRNgAUQPN2JzD6qgHRBRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732251863; c=relaxed/simple;
	bh=A/lHaHfafAQy7OfTvmDU5OKRmJrBpX9Zmsb83aoIxoE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qEUR80QLB2gfkVxxDSfjJPWTLTt1uqfDqv2czSbqN/ewM7tfJPHhhP72pbPFcAG53GnijKlGz0QMzjxR7x3D3EjBziuUkkD+eIsTIP7iVv2FBVz97BMHEsVV5j2zKR5HZ/fH1cWYh9rxrjxY/uy3e1fMot4qC4+aWCTcTCRDfrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zFdAxetf; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zFdAxetf"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5ee1e04776cso950215eaf.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 21:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732251860; x=1732856660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kIzDwcozFWCn4iWIZHsgYfF1wjH7Z9fC00bR+vHVLs8=;
        b=zFdAxetfqdy6vjgAlPnY8dcPszsTDct+6mOTzaz8OaYYhujrNWdIyDm6DWDXklwxD9
         htk6uVhmakXRcC2Fjd+gf0VKabBgujYbdZJXpGtUEjMEEtaaIRE7vqvmJ5hR+wAFI5U8
         L5I8GNSP3CIuT9SyFp6pG9PwV5p5HISLTOyaBErkch3CTIh7aqGsWYvgFPU1j1pqziiy
         uKEPXqCROjEj5IyAkIC6yldMzfaMXQ/1Z9Xuj1AZ+dwr52LyscyQch1pg5tlhHkcQpqf
         NnNm4QFDdYbsyt0pDXl38nk7FdXVag61wo0cD2DJ/VZhdCGE8Q2jpBj3wJrxcG0OJ0Lw
         5wMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732251860; x=1732856660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kIzDwcozFWCn4iWIZHsgYfF1wjH7Z9fC00bR+vHVLs8=;
        b=mEU5H/Y2VfK9ZLTw+iRWSMrm43/ZBoqJtMw+I1E54leakfa35kSgU6XryZkP9lX6bq
         xn4yqdJddQTpYzYg/kFidhflE9uPFRyw+nWa+FSPYpVOij9hAACGEcfWfEhtVWyipgfL
         TLj4Qm1Q9BphLeuws6mDbgG0bemN+R7AUz+ZeZ7gC1PiXH8ANgs8TLs3WxCx28Ov+URh
         CBoeqDFBGKnaBTP0ycZOhmaNHdcNczP2SHfYRhF19zX95eENsvJGlhc27+Y1DIRuF6r9
         J6TUWB8bPFACYpev+BHvc5laJAY48xdUwEvUPa4ZisKkvGWX0AGdQW/lf3xMeFziS0dL
         8TfA==
X-Forwarded-Encrypted: i=1; AJvYcCWASusaBvc1t54kIjDZ4UJRnI2tcNqoTc7wqviuTcpS9z2Wu0mHhPsZd5U0MnGpNBwGtmfwkKTTdQBO@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4yHJxRgiFKyD8qNn9eusZfrSg4rzC2KlaTqfsKt2Kk/MggiHU
	jCTPTLT+t/Dt+qXCOkYXSEOOI9bdj3JP5s70HV39HYMpI/nl7sPSGmnHm6VZgO0=
X-Gm-Gg: ASbGncs5ZH03sz/T6QZcICY3rY0QGEBnSLPbRKKrEkXX90qP1QQBRBhQJdVUUTJnDKT
	vlGIU7zzpOAdxB28rmTXanowQligr+jWx5nGn8eVPwSqft1Kin4it70sj3/4kCW8weEzOjqW3jX
	HID9ut7gPcLgnihGZ+y8yjxN+VzxChEjuV/dB0sLA1WvEZuLWOtBO8N3a6E31v0ieyM01QbRuOp
	f89l9NbnmCwawgtU2hl5ZV5t0Fg3BbBdgBKFDHuX6ZgrrMQ95vdh0Q=
X-Google-Smtp-Source: AGHT+IGL6MagCY83L4jKNjJ+b2nvEUCxXAYn80qUw2BRxv2rEU4IPc31obmxQrilm0WF+k6fB1jevg==
X-Received: by 2002:a05:6808:1b0e:b0:3e7:9f14:26cd with SMTP id 5614622812f47-3e9157a3724mr2224346b6e.8.1732251860540;
        Thu, 21 Nov 2024 21:04:20 -0800 (PST)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71c0383ba69sm280935a34.61.2024.11.21.21.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 21:04:20 -0800 (PST)
From: Sam Protsenko <semen.protsenko@linaro.org>
To: hch@lst.de
Cc: axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] block: remove the ioprio field from struct request
Date: Thu, 21 Nov 2024 23:04:19 -0600
Message-Id: <20241122050419.21973-1-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241112170050.1612998-3-hch@lst.de>
References: <20241112170050.1612998-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Christoph,

This patch causes a regression on E850-96 board. Specifically, there are
two noticeable time lags when booting Debian rootfs:

  1. When systemd reports this stage:

         "Reached target getty.target - Login Prompts."

     it hangs for 5 seconds or so, before going further.

  2. When I'm logging in, the system hangs for 60 seconds or so before
     the shell prompt appears.

It only seems to reproduce the first time (during the boot). My attempt to
re-start the mentioned systemd target or run "login" command again worked
fine.

Reverting commit 6975c1a486a4 ("block: remove the ioprio field from
struct request") fixes the issue for me. Do you have any ideas by chance
what might be the reason? Or maybe you have any pointers on debugging it?

Thanks!
