Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959B03A1688
	for <linux-scsi@vger.kernel.org>; Fri,  2 Oct 2026 17:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790963481; cv=pass; b=c8pWyPIzCLeyAmyKH3Y3bEbc6iG5gZn67q9UqLmq6qnToBX0GA9v0c7Buuj3ecj493sEWfM1vXCjXDPr6XUXjxxzz/Hp1zS1n2iKtouIGlXSEKWiRJSGkZDnxJJeS745MTcadNTR+ndp9tJ4GQOlcbVOJ76IrmJ7JP0ayjIN1bM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790963481; c=relaxed/simple;
	bh=nZzkVN4E9BSqcDIHvzqxmjz4QVuzVLP/YMY/poyCrxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uaENhW09oY34v2CbcV1M64J4wxjS5PuXdnGqcBH2ko4vHR2YYlGcGuxF6kShL8z6EzKtWRpu3DCxj2GliAvohHQT5wQDY5gnlaZhzT5ql9BK1N0/xWrm1xhvPgjrgmOe8nU2WnltA7u+mm8oD3F89JZzGTx6qCphn1QiKRokZJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=fZBnIU+n; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="fZBnIU+n"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a166199820so376175e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 02 Oct 2026 10:51:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790963471; cv=none;
        d=google.com; s=arc-20260327;
        b=LTTy2EzpqNp8lfdsQ5G5w51Xj0Q9pxrWjdiXc2J8uXy8uHt2hFG9PDVNjyR9fdVHCy
         X3dejs1irLYkg8b0mgm61r2YM54Ls3r33GDJCjgnqqtgK6OqVPQaHAFbRJVqv9FB4OFw
         Vz10boo/3kn5GVDYn7saeAVwV7GZ+Zw2MowCtwHr5h3+0DIqashI9E1fJ98jAkdmI3Zj
         PmuKhdMPcQ1acOdZRd0E+X6oW8P7arh/eboX81WYTTrwFOEICfOctkTWfxwphRrDnxOA
         Hin7QIK35BA+OINWFruL6I2KM/qY0h2dTdJJrJlw36T8icW7MsZNQhYpHL2oCFSUyUk6
         YCZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IjRLkdydNH/3hEGomUeQ+SayV25kXcztDM+0WcU6ndM=;
        fh=3eFDZttVerugfno6g/Q9nhhMwgSWYvrqdqaU8fq0SQ0=;
        b=c6ZsDleDpPkgsVob8hp05AiBSz40lvKzRKTQNfWprrTXWszXXVG9UgQGI+uf5av8p+
         e2nqKVQsWLyPV7rgKHg3dE6L0UtENTMSRvh4qjAni7sLAq5DJw/BtHiRKTG3bLMy8rUx
         1aJYNF51B2XClxono1GvTtej9b7wgCbLi1BIQQU4KajRAGaAhqiwkNwxv4Kl56meiwww
         yDqlYwZ9TpfIm4q5a9Y0mcYxvbjyvE0X9zqUABjYeV1jPBHbcDtaNYVExh9yvOQAuPQt
         GECSgLTYJ4TZKILO/TfVMNlsmNaQwNcUAEcwmsF5Wu5TbtVSznXDVQP4J/Geh0SHDdrN
         mJrg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1790963471; x=1791568271; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IjRLkdydNH/3hEGomUeQ+SayV25kXcztDM+0WcU6ndM=;
        b=fZBnIU+n11krhpzVwUJTdIeMx48YQOoasgu11dWqDQSBeFutdTsb6BFXfmi5oojz6q
         kbR7VnmynxieKV/K1dL2jnNqoCJP/ILDktjVVdsQdK84JQpgkc7QbpVJWKa22WoZibfO
         uoCuzRw+QzryPoS7edqVT4vVod5Z+Fe3muAcoUfEaDJSjMX9NZSBolm5eiBa33KAywWf
         FzLBi6w/2vIV1l0MRjtmP2Dbs/E6JlVKPXw3j4+Sn+S9Sz/0PjKy4b8PcPxyXQkGDttt
         D+JIlIbqmTOU5mIyzufleCuZvvO5y6aQrQxZokF5LEhvlIUiFpgtH0BiZvwMlHeCkPxo
         pB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790963471; x=1791568271;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IjRLkdydNH/3hEGomUeQ+SayV25kXcztDM+0WcU6ndM=;
        b=l9VLQX+p4lbNzPk1hYgvErBfzmcZT7hWo9QRQ5ZhZ7y4XXusDZpMbRbEGLAjlUXJKd
         5NprP87pkRnFizWgXRQrQrlMC8HWEgA5uRGeKYmuscN+thXfYi/IDyOdE2h3NX3bsrUZ
         dqvPNly0w/92ilr2CvXQx0i2tZxGGXw1trSC/KcCUNqmqHtXPt1e7avteBSYD8ku36Tg
         OF8rNRd7kIn7EwUTmepNVkp0dbqCx1PyRzRNYBSXj078wjQ48GWzxpVJaGrYS2y9VDXH
         UQFFvHGPrUOtrxtsGWh6IfehI2w1QnzL2740DrxowIipu2tqXq7Eu2Jee4Gdm8t1p02e
         dvaw==
X-Forwarded-Encrypted: i=1; AKwUvBwB7sVGsAyNrxtU/hGFwS3Rb7YL9UbvFmeH3GI3dFvGOu3NdnS5Np66guCljih0s/rZg30+16Ot8/JF@vger.kernel.org
X-Gm-Message-State: AFuF++mHialLoO5ymjjVtTl2fh1MIDCFrQPgvsEQZjilxXRhWiS4sANB
	puT3kb4RDtriAUJ6bRis5ArUazZnwfHfD1JXOHkxRCS2Itj/kWpYySC9pJb2ACvLZdAcO+y9cEo
	WpSZcAZEP/CYwK3XDoFir6pgKEcPPIM6UNmhOjkEqWw==
X-Gm-Gg: AYBFou1oC63SJT1xJCLwmCENhQ+kqB6nZtXAwPVXZLZZjjRTFsvRfEI7vtiqLNuzgsd
	Rp9l0kVw2bZ7nWp39PR2tppjV44ZtSv3sgcsi/5k7cAmFphKedwH1szRQQ3vmCyMnCYxDhd+BTG
	a8DHu5zEknQtIalkvogn2nKS+5CAFd45BeyL99bMMvSfoQolRLnSxyoZGrVHf+/bnBkWvf+x0qA
	Vs0RI0QgBPEblyuT0b0MYKFB4wMQiPcRk0l6uJIk0QUXydZQ77HS5JQc5/1S+0j8MNCD8wgny71
	2tdu5OTGS2TRPfrPA5wthaZVCrdXyOAYZidnWpm5H1YIF33NIs7/Bemhh54+SrEOmGHeEuWAML6
	8WO1er9dL2zATocv7edxBoBerbjCrQMc/WPuJ9B1qafuGuw==
X-Received: by 2002:a05:600c:5888:b0:49f:d742:97ea with SMTP id
 5b1f17b1804b1-4a01eab3237mr108637715e9.0.1790963470511; Fri, 02 Oct 2026
 10:51:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930024505.96440-1-artem@trailofbits.com> <2026-09-30-1-daily-reply-0014-lpfc-sfp-info-mbox-timeout-6-6@kernel.org>
In-Reply-To: <2026-09-30-1-daily-reply-0014-lpfc-sfp-info-mbox-timeout-6-6@kernel.org>
From: Artem Dinaburg <artem@trailofbits.com>
Date: Fri, 2 Oct 2026 13:50:34 -0400
X-Gm-Features: AclHuK97lTiqaebg1I8sTjOuQdYcc3iS6N5jctNtVuQ2foq17QpUfDpnDgfMSbA
Message-ID: <CAP3zxaCrgUA4tAtd2nS=b5sn3xSQ3LBiRRFwsRMeCGvHrhgprg@mail.gmail.com>
Subject: Re: [PATCH 6.6.y] scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Justin Tee <justin.tee@broadcom.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paul Ely <paul.ely@broadcom.com>, jejb@linux.ibm.com, 
	martin.petersen@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sasha,

Thanks for catching this.

I'm working on, and will send, a v2 addressing the issues.

While working on a fix, I also found what appears to be a separate
mailbox timeout/completion ownership race in both 6.6.y and current
mainline.

I do not have proper hardware to validate certainty, and can't emulate
it in QEMU, but I do have a hardware-independent KUnit test that
reproduces one of the failing interleavings. I'll send that separately
as an RFC to the LPFC/SCSI maintainers.

To be clear, v2 will not attempt to fix this newly identified
potential race. It will remain scoped to the existing backport and the
6.6-specific problems. If the RFC is accepted upstream, I can submit
its stable backport separately.

Thanks,
Artem Dinaburg

On Thu, Oct 1, 2026 at 9:52=E2=80=AFAM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> > [ Backport to 6.6.y: v6.6 predates ext_buf and uses ctx_buf for the SLI=
3
> >   raw payload. Restore ctx_buf to the saved struct lpfc_dmabuf before
> >   testing LPFC_MBX_WAKE so a timed-out mailbox's late default completio=
n
> >   sees the DMA descriptor rather than payload bytes. ]
>
> This isn't safe on SLI3 HBAs. When the new 60s wait times out, ctx_buf
> is pointed back at mpsave, a 40-byte struct lpfc_dmabuf, while
> out_ext_byte_len is still 256. If the firmware completes between 60s and
> the 300s mailbox timeout, the SLI3 interrupt handler copies those 256
> bytes into the dmabuf. That is a slab overflow, and lpfc_mbuf_free() then
> runs on the corrupted virt/phys.
>
> --
> Thanks,
> Sasha
