Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792701044;
	b=iX07B8A6KA5QcltrWytGke//PeSlpE++Q0Ia4LyRlkIpucq/ozglPL7XmyEvXCDrtZoW
	 eH/a6zHkoIgRqqRIGh8NzmlF6Y4u8AuYEDFCkMZcOH0lh9Lk4L9Uj/sCxlN+d/x0L0aYZ
	 Eo47r7Pcz0QnWxM/ghrN8TApy2hQFsVYqia1W7XS6Er4yMcyflptIiNAiyT4UJBHlfvAb
	 HRgR9VLF+KtMFIg1hPoCYHSrfCfK9gQmEWnoN4I3URJRfY82FZBSmc5pWKSGsPH3t8sQH
	 WUHxegsaP9bnwlqGAclL2SJDdG0HGWuKDpG32aknWhDTWN71anblPyhQf+X6QzP5MTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792701044;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TwLGHXSVbX2rCSP/BPHeG6+sTlveNYHXen0aF4/nxh0=;
	b=h8uFmDArmq9mSvypZ3Y6raPgIMS2ADgZ6u3xTca9px9vhaW316TUxGLpPxs+ax8eu8sK
	 YNagh3kY/b00jOX9GZ+ikalKG6z7egDwPzruCIURnM4yVJH5ofg7Lr+4b4aWg0pQjSHy5
	 hlpfhTlLkAd2HfelJckeF+AETr1+6vPr5Qxu8p6E0P5XqMQYxlN2SI8z7pppuu9R9NdRG
	 ossAISsrQroJGzxV2eDqbSAkVGkkAdvn/C8XuLutv6Y+m12AGuAzFd77bGg3UEoYgMDbQ
	 hA1pWZ/rJcn4vAvLCHra8T7A9+LRuQ0UqC4D3ivLmpByytk/C5EG8JxDpdw/j6J2/0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=S+1bLzlo;
	arc=none smtp.remote-ip=209.85.217.42
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADED8606A332
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 20:30:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADED8606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=S+1bLzlo
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7907f01e487so88134137.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 13:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792701043; x=1793305843; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TwLGHXSVbX2rCSP/BPHeG6+sTlveNYHXen0aF4/nxh0=;
        b=S+1bLzloKb8vH0WReXi5f7Mtc5J/LgeQRBie3oVk7EyiNVja35y0WfqKjlYqzZcuKK
         cIzLtYdtHH3jyhwntYkQB2clkEz/JsnUzJoDNdUiXSikJ6dNJ1PBeIzCGIQAlhQ4V92F
         fhuS7oW9UU/WnamAQfxcuXn8PTw2OtbN7wXCREldpCLo3Ca5DFoptU1WZu4XUBdZhRPI
         V/EsQURumKeLfpzO4tNWqkNzIPBxJJCW30klNHIZ+c4hzdLsGhQhbUvOFdEMS9jxGaA7
         /BFKK9vlDsZycUmn884lASZ9HuOrF6Du902ydEp40ch+zX++WFFS5qh+PaSI9wEsB9lQ
         wSKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792701043; x=1793305843;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TwLGHXSVbX2rCSP/BPHeG6+sTlveNYHXen0aF4/nxh0=;
        b=pNC5gEzy0FgKM43MtFcsa4gmISjRAjuZFszdo2HzYsd8MkLLDzdcUDoWkyfL1C520I
         lVFMDaCMprpyURxXCrvsFznzTR0hLelxVz2yn8oQHzQVVgQe3j4/llSbmWf9mxy7/3Az
         46zNSAt5NbR9Ikt/8AYtf8q98HDDZH5TkWpD3ROv69ewMfP/HYh87lCu89zOUzu0kZB1
         IbHA8a9PGtIU5ZPRjpcEwznR4jp6XfiAytgpSru/qjoUnU378Wh2Je+J1DJOKQasG29q
         KivjQP/5VFdX6SHaY6QnXX6TGsPHkm7QYrom15SFLS1hg6osc75kKxMV0iKw8Pf3aFZG
         EdiA==
X-Forwarded-Encrypted: i=1; AKwUvBwB4uTBPm3PsWXIF9bY6ey4Dy1VXj9KoinR63Mp2Skmjv4oidC8G/irHoixKCmGFqUTfGibqhqTcuuV@vger.kernel.org
X-Gm-Message-State: AFq9FYLN7vckKAWlwwMdN8/m8OsTYdl7fI/BOwLWdXBp8oCfOdJBM6+u
	JtTDTgivuXQknHFE/906CYT9txMJ2zHbviBMzhtOxT9kmONuhgGfKBCZRG/prRZw
X-Gm-Gg: AYBFou3aETj0S2V1/I6/2z1O44CFLUBO8bp8VL3zAj6/qf1vfyAi3xMVzaj07UYnRiS
	LxaYTc4AQ9RcEhercv6AWaJp0bcdn30ZBC5cRKmKzo+92hT0T5I9wvMtxSnAkV4aLbAcC7OsLjo
	Y1ZSMQvdMHfDBVeiNFAe8uoi2f6iBzBwUa5v9Yxkv2v66ApAcxLUfueOiRSbt6MKok9IwMuOSDO
	+i28H5PcWZ5HJe/ekk+daSCJU7/k3KQTNqH0TuRRAAr8iUOpgjTGZkM/vJeppTs3Y5h3SmlkzM2
	oVCv31BQRM5cZtg04XLyHLnvs9ZvBpfSfSxMWzUUPMiLB1xqQwh5Wq2x2thbZ0/vW5vtAYQAxyT
	vo+/Cm9lq4cOg2WIY5fywaaF5MWTX6chnJj4vh0nETnv2Clh1+qpRzNDXfqIxpSe49XaQ35ACyn
	ZHzxKYM/odRoL+B6Wq4NL+xzdCt2ogj4G3EmUu9MfFqHKO+HwkxMfbe2qtlWXZylMWEZwAwWCJa
	Ap2j/AoYQP9Pgn4vjFGMPlURyzxTvb7Y8LyPm/qXY0S3kXCz+gd168jXGupwBP4KJIlivVlspxJ
	5gdEKNCITWc0jfq11GwW
X-Received: by 2002:a05:6102:644a:b0:7c3:91f5:26f1 with SMTP id ada2fe7eead31-7ccc32f27c8mr227930137.6.1792701042480;
        Thu, 22 Oct 2026 13:30:42 -0700 (PDT)
Received: from Biostar-A520MT ([187.94.15.233])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9910184bc75sm371879241.12.2026.10.22.13.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 13:30:42 -0700 (PDT)
From: Breno Rodrigues Alves <breno3011alves@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Breno Rodrigues Alves <breno3011alves@gmail.com>
Subject: Re: [PATCH v2] scsi: arm: Convert acornscsi-io.S to C
Date: Thu, 22 Oct 2026 17:30:15 -0300
Message-ID: <20261022203016.75038-1-breno3011alves@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <4e2383f0-9791-4840-a4d9-93fbe51b7a40@acm.org>
References: <20261022183658.58090-1-breno3011alves@gmail.com> <20261022185224.60700-1-breno3011alves@gmail.com> <20261022185224.60700-2-breno3011alves@gmail.com> <4e2383f0-9791-4840-a4d9-93fbe51b7a40@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Bart,

Thanks for the review.

> Why eight readl() calls instead of a loop?

The eight readl() calls mirror the assembly's unrolled 16-byte body
(4x ldmia + 4x stmia over 16 bytes).  Collapsed into a loop in v3 —
the compiler unrolls it for the aligned case.

> Additionally, please use put_unaligned_be32() instead of open-coding
> it.  Is the code below equivalent to the loop above?

Almost, but not quite — two subtleties:

1. w0 is declared as u16, which truncates the readl() result.  It
   happens to work because the compose step only uses the low 16
   bits, but u32 is less surprising.  Fixed in v3.

2. put_unaligned_be32() would byte-swap relative to the original
   assembly.  The asm did a plain 32-bit store:

        and   r3, r3, lr          ; r3 = w0 & 0xffff
        orr   r3, r3, r4, lsl #16 ; r3 |= w1 << 16
        str   r3, [r1]            ; plain 32-bit store

   On little-endian ARM that writes [w0_lo, w0_hi, w1_lo, w1_hi],
   i.e. put_unaligned_le32() semantics.  put_unaligned_be32()
   writes [w1_hi, w1_lo, w0_hi, w0_lo] — reversed.
   acornscsi_data_read() feeds SCSI payload bytes verbatim into the
   upper layer, so that reversal would corrupt the transferred data.

   v3 uses put_unaligned_le32() / get_unaligned_le32() / le16().
   Note: <asm/unaligned.h> was removed in 6.12; the include is now
   <linux/unaligned.h>.

v3 follows as a reply to this message.  The 16-, 8- and 4-byte bodies
are now a single 4-byte loop per direction.
