Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495BB2E7BAE
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 13:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757683127; cv=none; b=Zje8tNNC905f3xN4QQCahoq+792XYq4h2GGhZFVkr+e3+3nA/elUCeO1GjvkqQa9pwbXdqXN8vj1Uja+GVBZaZLzStXd+6CQ8X7Q41NZjr73ezU6LX5b7cUJYJVYjqo6HumURCi9VJSxPLoSkSj601xk2sQ4JkVZEyqXee7P7vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757683127; c=relaxed/simple;
	bh=oeww4Ivx5YThdAfSYdbOCn1Gj1LUFzN/W4lJGwFtW3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pgnbKZe6yceD8nRtN0XMcUiAqrVKP2MOtSgRgKTTRnQzmPaMRHYxOZtDtKu5DOK2AWwsIE0wTDrn/tGzdzYtGGmmqKxd57YNvS0vMIRak7qb3Y2ZHaYg8UKFuU8o8XyWZg/mZEajQmZQJ19w3jqLOw8kOpHq3jHgezYmdD6KSIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XaqoIiBN; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XaqoIiBN"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-30cce892b7dso906155fac.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 06:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757683125; x=1758287925; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oeww4Ivx5YThdAfSYdbOCn1Gj1LUFzN/W4lJGwFtW3A=;
        b=XaqoIiBNSrrR2zrG++Bsaoq01VFgfEBGxJ+ysCJftMjj0hrGwBUazuS8iGMytsu/8+
         lTgSxMhEpFJuwhmEn1BH4LoZXb+4OVkBjrOwayy1oNBLRD3QvKof5X70wP0OE6BjrqAj
         Pyj/o9cUfpERUcSu749OXC2u09WfqzBhvJ8fwOUlATiCOTXxW+yURv9ck5QljCIWUDlT
         awKwsMPlCDb510+qlAr2M0LZepenW4WnUIhkOS2NvH2+pk75XlcNBAMYZYa/bEe7rdFK
         5Tpb8/xdAjXOZg4wYnwQDriqs9vJ9EZVUKb3ZqzkWdffm5cyc3VdJkVI3Ej7E8vDnMw4
         uItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757683125; x=1758287925;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oeww4Ivx5YThdAfSYdbOCn1Gj1LUFzN/W4lJGwFtW3A=;
        b=vlXX62CynR30QO+kADvB7bu65nACFTro8j8SRcyo3g9D6RVaZzZhBVK+u/orf9YS4M
         h5RDcZY6q2Poi0kgxnazulOnh9QoNf17h/rS+3XLri6VYxi/eBuQP2kIR8Gs0DB8sziV
         WY/PX41YiFOL1XR0ogAlj7VXq35pFEk36D8y7ZZ3VBiXbpkv22srHFz3UEbZgZYBUEeY
         6BxnL8C6963yDG5NYMIEiuCyx03Y5AwBm+T1jxR68DPdfW0NJJiHi15qjainI7tDPY9F
         iTxknyFZzcFebZXWs/T1LhHGEDaE8poWSSkvG6vz5gLxllOP5JMEPkBphtlIWwCHPA+Y
         ieTA==
X-Forwarded-Encrypted: i=1; AJvYcCU+TDHh4Th6Lrpia7EEmNfgdku0ydhC2gs/hGIJVvhL2eb3CbESBn68DjSmctA55/Dd7B97936vqyEa@vger.kernel.org
X-Gm-Message-State: AOJu0YygdxOD++/5YKHDKn3hkb5m9CSDA/kfYmTx9BGMChLJZW6jOksS
	G/HYtSPxYHU2ErivIhuHJ2Fq4Uzpal5VDL2tGbJju3ubltA6wCybr2AJ9DReiB4CatZHHrpF4Jt
	XPAc5W3TfTI0h0sJusvztXTq6Ge10b++D6JpuukBA4A==
X-Gm-Gg: ASbGnctNSGjVfmLc2XBq0xU73Cp7ayIt+PCkXcvQfYRflJMuZePFcIS+31E8MNGlCvH
	Ger/USAi/GkkqgB0Arjan6vVbtJOAWnpMfuweHxpqGdFxGl9gOUMj2qzDz05WOMCBh6nxigZBL7
	Jfdeph/wsbP5FGNWGKqlDp/c544t0bCB0pJa6cnVO65bE4NkuZBqBZ+slO6Sa2iDZlGSze1ggCW
	AAfu7o=
X-Google-Smtp-Source: AGHT+IGfSaVuijaDjlm+oIKN2iiydfgKjK+5YsMgIZmmXxQ/CONJDi7ONHUL/Qm+aJ4qj0ySkZLSHpb1XTjKs2wTKXo=
X-Received: by 2002:a05:6871:154:b0:322:4639:f3a0 with SMTP id
 586e51a60fabf-32e53e60589mr1203923fac.9.1757683125291; Fri, 12 Sep 2025
 06:18:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250907202752.3613183-1-alok.a.tiwari@oracle.com>
In-Reply-To: <20250907202752.3613183-1-alok.a.tiwari@oracle.com>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Fri, 12 Sep 2025 14:18:34 +0100
X-Gm-Features: Ac12FXyFWdruiBB0gYT4kEG-HddeFzWWyfMX32BSCDTTl49jpBagppTHhtL-eME
Message-ID: <CADrjBPoByCUtKLR193QpfMv+1VTspq1s8Mzm4dzLCUai8P30Tg@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: exynos: correct sync pattern mask timing comment
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: alim.akhtar@samsung.com, krzk@kernel.org, martin.petersen@oracle.com, 
	linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 7 Sept 2025 at 21:27, Alok Tiwari <alok.a.tiwari@oracle.com> wrote:
>
> Fix the comment for SYNC_LEN_G2 in exynos_ufs_config_sync_pattern_mask().
> The actual value is 40us, not 44us, matching the configured mask timing.
> This change improves code clarity and avoids potential confusion for
> readers and maintainers.
>
> No functional changes.
>
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
> ---

Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
