Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228E513DBA0
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773238463; cv=none; b=T9UkRFMpXgXFCGC6ZIUL9xHdpamY8mz0x/9frLtj4QMWP2kSgMUCjlRa/knf7IIzWM4BUf/zP/MxQVmrpZ7azclVNQWny/WmQuHuT81W2jkoyIWrMsGOHpdlJmH3cL2oHBuh5xWIw0zuE4oezOHoWqoWzi7kEt1J58qVLkikWsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773238463; c=relaxed/simple;
	bh=POUJjzeRhBIXfPGojdZfC417KH92loTKx1KmDpRcfoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r0qJpybQmLaZbDIivLdrZZMyym3KAT1Bzn909Sp7jGjWLepGMem2jCcgC1L2TSs1FNMkK5f/rpQuTWkohwQyiUMFfNp2Ju0TEs3qHaxs/3qpoFbJAuyBCaJ3kSesdVxIawMYCnHaRIK7dThPCAh7w6Q2Qgq0K991FmvBSPZjV74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-660ea6ceb5aso1642993a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 07:14:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773238460; x=1773843260;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIz9Fr5w5J45ZN4rxwvT/0kjXMGfLP1VpB2aKPOax7k=;
        b=BJvt2tZ4dRuwinEv/30b1TEYu05Eh4qKn8nuu8PpYS7bVr5hygRbxWojlm7FCehSUb
         XDaPmN+Ae4JSKF25o9YR+dQ+neWEAGO8HhwjCUI3BkLxaehpgLcsqM2Uw50xnZb2uz4M
         Sc5DsextUef9phFa95zWEVloJ4hx7oU5GCylUB6VwSu5JNBvu4Sn1cqHl2SMEplpA+7j
         CXKCWuSmec63bhF2o+mEV/X7IOBkX3j3I/KDNfEZLlwbPms9+MFJEshJmRWL+PFdcJhq
         6Z8Cl1PJxv9ybpxa/TTNa3QcTw3M53w7SMpZfSJKuqQmsX7zvy7LnuPAumL7s/BGSRDD
         QdJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmJOdhcN506nTyOTx9OcuNtZWuDafJYYbAgWUFeuKtpEYsiMj245A6Gxl6gxTMPHqputqBOBQF71Cm@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv8Mtcml79Dvu+6PzYV8jGO3aJ52N6AwKbuQw8iBzOjlRhF+YV
	Vp8aJ2vivG/mqRFbZnU5+u8ScPjP2khCXxaCyILLZxRN616lwR8TkYhss3A+nFk0jE+g7w==
X-Gm-Gg: ATEYQzyAYjr1ViNeJvvWelyQ6pQE84xVUELM3lh1ORtQJ1I/8WqXfOtIF84+jG+71MV
	k11yLqeSLwgRE6WeDG2AoUNg2SpNssVWJe1LJx1EH+ksC/9gfLRfkfGL/DM68PHxRkRODUTbZff
	7mepZDJwkEyp+zFgrW21vVGIJrabVQIsGyoxTz5ImgfMfaBcDpFxKK2oJC92wnxkrB1RucFw8qc
	xfeVox1EO4nAbAsF4mjD3NMlYugkm60NDl87h6FsWemSHjKtzFCSoXJVEQQR5q0YBNyvUzfwdpX
	Z7i/Kw9NNDZAM0/EyyKnSy80JdWYpaSWC+7YpwRMelh8W4Z2TLy5+Z+YPsZuD/cyi1vTtK9PNgf
	fFSUkJBWbR62e/BA3dIE9VnACAMFD4Z87Ao/jGwtox50pcMKQtdnyZDVh5jKKJQFczF8yJpx+jK
	yBzkGVrkgPLKbagMa9ItFlLFY1QMrx1i11Pz+dSQUZ2xwDrzcUO+0RyOqrpySduGB+beEolwM=
X-Received: by 2002:a17:907:9446:b0:b83:3295:15d2 with SMTP id a640c23a62f3a-b972d8e5545mr133072766b.30.1773238460202;
        Wed, 11 Mar 2026 07:14:20 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b972de83676sm60389966b.29.2026.03.11.07.14.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 07:14:19 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-66325f30570so987038a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 07:14:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW8Exq5jpIBbsPVTqFLeW37X0DSqIEbZmJ7s8PVCrRrOqnolBWfJG3TXbuHxL5s8qE2Hw3te6FNrVnr@vger.kernel.org
X-Received: by 2002:a17:907:6d16:b0:b88:4f25:81da with SMTP id
 a640c23a62f3a-b97113ff0b9mr462021166b.0.1773237981235; Wed, 11 Mar 2026
 07:06:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de> <20260310100750.303af303@gandalf.local.home>
 <20260311141332.b611237d36b61b2409e66cb3@kernel.org> <20260311100332.6a2ce4b1@gandalf.local.home>
In-Reply-To: <20260311100332.6a2ce4b1@gandalf.local.home>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 15:06:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
X-Gm-Features: AaiRm53WEGMMLW4z34e7P-lM1qFvsCJGZ_o4JNL5NPWbhJPKmcqz6k9bJcyL--8
Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
Subject: Re: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL check
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org, 
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org, 
	cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"

Hi Steven,

On Wed, 11 Mar 2026 at 15:03, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 11 Mar 2026 14:13:32 +0900
> Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:
>
> > Hmm, now IS_ERR_OR_NULL() is an inline function, so it is safe.
> > But if you want to use IS_ERR_OR_NULL() here, it will be better something like
> >
> > node = rhashtable_walk_next(&iter);
> > while (!IS_ERR_OR_NULL(node)) {
> >       fprobe_remove_node_in_module(mod, node, &alist);
> >       node = rhashtable_walk_next(&iter);
> > }
>
> But now you need to have a duplicate code in order to acquire "node"
>
> I think the patch just makes the code worse.

Obviously we need a new for_each_*() helper hiding all the gory internals?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
