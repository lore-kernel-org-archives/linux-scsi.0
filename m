Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4156318DB0D
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2025 07:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763450783; cv=none; b=e2RZYASTaIsFDTi0tOa1k+kxLEoDCT0DZyoIgFSML6fYXi0QZLBb1Mg0/RaOHnpbzIemx8yscBJuAK2kGVbO+gRoyM1EFWV/w0uecCVIVTWcCLkkxzGZLzHxV9YfCPKjO9Xi/Z3nArXAwDeA2uSFdrH0cdZKl0IhK2n41goQ9pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763450783; c=relaxed/simple;
	bh=tG1Pu79zt6R+oeJgsdJ0+2AsjLitDAU6A+quZxWRvLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jWTjHKuYvozEKuU1vpbrUjq+4NfcXZvX8/Ykk19m9RDWLtI7zjhLGnmMGgxMLAnCBXwFQNLP8jNL+oOexApLs1bYqOuQz749dM2M+pv24pptTM3pbko9wf4dGeWdCuAfX5efPvuaRGbGPCMX6x8g5UxRHrE2iBIRhMyfGvmoTMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QCvMIH4I; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QCvMIH4I"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-640fb02a662so5240a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 23:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763450780; x=1764055580; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KfExQ+1jyL1z8HGLa/kfF1wxmRAORiVly+Zr/0sGp5o=;
        b=QCvMIH4I/uVN2/ijzMZLeCl9Xrf97L/o+vw+DFwP2qSibQgBzDHJJrLfgiCw9AifAM
         ZspaOEni2FMCk3+g88cSJItUgXfiEqlDFx1/7pGw3crreiLFvuOaTL3UGRrDFzBovU8M
         TaTalnvSoKxCJg0wgbN0YNEKfStZuS6UXzXX/QlicE7IroLPNknfyqhmz38veWDjIJu6
         zdZEcwRitvyJcJVWvCgkuOdHIpFDqanFE8gva8IRqcxZ60IcXv0fbKgN0DkJ8kjLVDKs
         kEZsB5C4+rsggcys7pby/H3J5ZwWc30O6byiTl5O3HkRPkUgv9mrMdFNnO6BdxXolZ7W
         Jo+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763450780; x=1764055580;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KfExQ+1jyL1z8HGLa/kfF1wxmRAORiVly+Zr/0sGp5o=;
        b=YCzRKB/HQycHvk7GxQ6JzDENN374JqpNwcDI8hUrElYLfnMJgZvHseZr5bzchyi8gL
         fXI1nS0UFGhrvrXJ1q2Wh6UddH6J/y1Js0BkKrWbLU7hBOISpdXmMSHDuiLxFlMLvWns
         vUmTKuUyX08Vy53XuhnB1gKjDdw73eH8kWQCR15HeYI+95HVsJXv9Cd3mgXW6yIbEuDC
         oHbBHGWVzy9wI/8QCyBf5d+naDfH81dhQRV76No4HIFTlqDdL/EvAlggtTkV6qBMI6hY
         /stfhHCy5Fdfk1CajcW2x5o5u2gWXKvjWLXz2fb9clR97UedwiiG/Oy1EJTiaBYbnmtg
         rTcg==
X-Forwarded-Encrypted: i=1; AJvYcCW0Ou3TnL+zKWwys8/MMp8ZLbM3QCabkah0jwje1WMwMLqq+yheu9FCCz7c77VObBbpfogISENtH5zw@vger.kernel.org
X-Gm-Message-State: AOJu0YyCpNRs9Kn93yFXQo6k202YaiN/bKzDsyHw8Oh4tYHvcCW/cQda
	+DhvF/tSlowPwy39ynSAbgKLJMbjgLQ5rFNAtkYb4Xok0basplP7EAVVbQK3oClL+PBZHRiNMH+
	VdQg+REHO3KwAj1qWWxW+bUiI6JLVwp4SV9yA10jF
X-Gm-Gg: ASbGnct69uny6NS3VRQKl1bt8kLCf7u5L75mtak4wEs9sM7PQOBCImGxggsaiwwRqP3
	XYoFSljdZ/4Lhenf6G+ZtkTvdCALjE7pWit63GZ0BpGMs2I+64xQwoFaOx44xsZfri7OmTZDBUN
	4GCcXuJiz+Mzf4wE08hSadD0KsEm6JvP6zKKGtLKtKdpeF/luBXx+OdvbyG798NJForP7DQyQII
	iPOUjTWVAIBzmK2JXqDNvJ6Yo/NBI57XV3Gvd/vIBMZzEKsH591EZSfT85AtrUFGk66AFlVXkOd
	cZFfkFzl0b2C69T+bHelP7+lX2Yyz83P0LVW
X-Google-Smtp-Source: AGHT+IFVNEeGbD9DVaAgudqc+GiPKmQie5DwZOEyfitcxs5KXEWDcb5jcLGcXApFBf4Mg8ruAX3vluIRiwK/1xSsRQs=
X-Received: by 2002:a05:6402:46c9:b0:643:6975:537e with SMTP id
 4fb4d7f45d1cf-6450cdadd50mr4880a12.12.1763450780399; Mon, 17 Nov 2025
 23:26:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251112063214.1195761-1-powenkao@google.com> <7d964e31162bf93f583e6e78a3044152894ecb94.camel@mediatek.com>
 <CA+=0d2YnrDL41DXtC8kDmtXioy4+hohGsmrOPxJY31jqt22uww@mail.gmail.com> <c4bd6532b003089fedf518db878a3843c516217c.camel@mediatek.com>
In-Reply-To: <c4bd6532b003089fedf518db878a3843c516217c.camel@mediatek.com>
From: Brian Kao <powenkao@google.com>
Date: Tue, 18 Nov 2025 15:26:09 +0800
X-Gm-Features: AWmQ_bkO2aCOXbgO-_v7eTNlYcbtu92nNtRKNCYTuznAMq8Bc32Gr-zKQww9Anw
Message-ID: <CA+=0d2aYn_q=i6Yy=zSu6eE=Fj0oTk4t00e1uezBxqNc5E7pdg@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume error
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Cc: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>, 
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, 
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, "mani@kernel.org" <mani@kernel.org>, 
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"

> Fault injection using saved_uic_err could create this situation,
> but if this cannot happen in reality, we should consider whether
> this is a reasonable test case? If it is, then I think this patch
> looks good to me. If not, maybe we should get the runtime PM state
> in the fault injection and remove this redundant recovery code.
> What do you think?

Hi Peter,

Sorry that I didn't mention that this is in the resume path.
The resume flow in bellow will re-enable IRQ and go through full
re-initialization which potentially trigger issue I described
previously
```
ufshcd_resume()
    ufshcd_enable_irq(hba);
ufshcd_wl_resume()
    ufshcd_reset_and_restore()                            <== depends
on PM level
        ufshcd_hba_enable()
        ufshcd_probe_hba()
    ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);    <== EH is
scheduled before this point
    ....
```
