Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D5037883D
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786638312; cv=pass; b=bh+HPDmElmrV6xgSHYgylUzPvrLl2aODm7ph1Qer6XVv6mJCY0H2IO/zNUTloRrFRw6o+R4dJa33cCRlHh6g0pwldWFSCAWhI2nfhyFWts+o2drbka7T9YxAFyHVJwWreYp3kskwnBGqcvYZLfrSZIBOIaWT529T5VeRyiUpSS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786638312; c=relaxed/simple;
	bh=U2gO8HXUYu7UNRdDeVwuXqd4PSnS6zEV3nJs86kjuJ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XcnlXpP/Y+5N9DD904apOG88T9mewPLXpvSTwo//OdPZkbX6bxMd9qSPTvuce+GNXQK0q9BK3zGms1YM7pAQRswCFns+1weRzz+/srHNnfM9+g+xqC1txNE0kIuu4hb7qJaGQNUZVz/VpeuzLZ2U6X8tonxmwyUmPNacXl0AEj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D+1al9KN; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XnYBfDw9; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D+1al9KN";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XnYBfDw9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786638308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xDjRetmtu85IwRz4yKH8gCl8QTGFcjeWkycVMxdyxng=;
	b=D+1al9KNHc3Xhf++5Vy3V7iXUPwkjVVUOCID+rXtqr42C4WSG4e4iW9DB9CJTcK2vEJUhu
	H6/J/hJETXUdtapwoO0TXJZepXVCaNlbiVCvBhVUNHXC4SLDFZhwGBoV+D/pvIn7ktDQJb
	WPeU8CWDMWv0aur584zyCW3u6AWnoto=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-FgcCEdJzP7WEqANz56GcwA-1; Thu, 13 Aug 2026 12:24:58 -0400
X-MC-Unique: FgcCEdJzP7WEqANz56GcwA-1
X-Mimecast-MFC-AGG-ID: FgcCEdJzP7WEqANz56GcwA_1786638297
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4954a93c565so395825e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 09:24:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786638297; cv=none;
        d=google.com; s=arc-20260327;
        b=HtYrm+L0vQMHwLQDcYw7cWsfUcTpO3MpWBtknmg+ysashL2UQ9JnfPOkgkBwtEcaY6
         WxuIxscpJZbm16xnzTSs20DN7FmARGZN7h4EO0uQnDZvpSv33JLH/RVZTNA0Ujtxjq/d
         Z66f4jECcB1y0vnRzyaef92IG/5EPGbVOtnU6PD58ThDMh6M+vLvnJf3kjRtJ5I5HASm
         p4RqumYMtxPmJmTa51QiQopc3KLYWWvDyIdVNsGC2OC65TQvsnav1GWNaRi67iZzxm6k
         VfV3iPvNX6vZiCOcAS/LcC4bpE11g+wcc6i0i4jNnBU0vTqW4EV3j1XZlPZnPrm7lAxX
         m2cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xDjRetmtu85IwRz4yKH8gCl8QTGFcjeWkycVMxdyxng=;
        fh=U2lGiqAN0je33kJ60uEUVTlae4A8ETi0sN2rDh0ukl8=;
        b=XFszt/f8EsU7r/1WAoS7GxdXope1X1r3u4H4HmGJmu7WOdeffRkSwj4dElmQ4QRsk1
         un1XAAlCe40leIIPk1sU26a9xLDQsmjPwuXVweMiOnJmbIDc+8DJIZV2WEra3cGk1zrl
         HcnpH5oVh8Ze5XL7WFg8dnFtCdRc1GOyR9DHbE4twFR8UplM2cTa7j6sGgH328uWUUNL
         oVaIiar9FJm2Gxm2LzMA3hvin9GveFM/R/3RxUzLm2H58eKhCIi4HXIprk3fpmaYgMzi
         h9A4r6huEsZ9ASSR92t148JQXnT+2woW2c4mKnc8M9uwdQMxYl9JsnFGhW7aOMIelE6M
         FVbQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786638297; x=1787243097; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xDjRetmtu85IwRz4yKH8gCl8QTGFcjeWkycVMxdyxng=;
        b=XnYBfDw9XUqnBjt9mLo05gFmxUxDVGQ9W9joyfagSLq68iBuItjlLCBnp2lQIwWINw
         GTMjiSVO0tmcQzfIUpqP+lofJGQ7vqQmPZTn1mA47CfcyVKvlJKFw59gXCUJv54EHEuq
         aTKqXQ96XMekmJV5sqVuWa0S2YEIQ3WxpCWsc/6We4wDTW2qE41Ck/vyrpUxOutp/qJ2
         uwRfUiFaeO+5v8PeQvi9MO01myxS4v3vnayOk8BxbAPmj5QfaM+zBMtGHuRHbijlDq+K
         IwMKwhAeu5tEM6v/V+wi35f6TTiwzr5GZmXHlyOD2YStKjzWGLvWfI3Ra7Xu1cZKUjmT
         k0mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786638297; x=1787243097;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xDjRetmtu85IwRz4yKH8gCl8QTGFcjeWkycVMxdyxng=;
        b=MD1Wigru99NV4eZbyCqALwKvKHIOFXjQbrhKUFXGNJaI5sIMbwifGo1mTKgSGrNudu
         Zdf2e66ImcHopwhxLOb1Z4M7v/J/Us3KiWSJPbPiR/NTaBtA44T9OJtiXtrhvgTu63C3
         ILFyAVkV+AjDj+Fws4x5dQNKNj7ye12P3ivu4UU3UJJ4GwO8P7qao0Knyhawg0di8u/H
         phKjTKXPIhLuWz2fMtHDlNnuvD6eLf5rDcrPx8fqsp1ypPqlAt8ra7TqBzMYCfD7Kt8R
         /zuuuXP1qH+vsIprQ4hGsSAfH+tk2/X2TZ0xqRkl+/b0f6Okf57UIEm8/KPSWgN2ZUMU
         88Rw==
X-Gm-Message-State: AOJu0Yz3AynHnfdWaiVx6LFiyziemQE2RB42WWpTYHDnsne8yOoy/L5h
	WQKlQX0glapRadd2L8IlO6v6CXGRphLbW4ONLQa+8Myzt2BXZYXPTJcyJSLb/ZOEYLaTPO+qhF0
	LP5qlxontj6jyKe7LVrkiBANJKWsHbpcySdzUL++1LjECQ1QvjoTxGcUcEsqAcccbjqlXQOYFTl
	QHYl3qSWEfzjv1ieoMMpEFoQLgLDdpIoa5Jjt0fw==
X-Gm-Gg: AR+sD10/7pI0gsacyuFNVtkmnCS907zqJ5WlPU2SDv50QcCjE5ov3X5cLCSETwmdv3T
	Q1BbQz47a27xAvKtaIowrhPDy+5gZcBsDGGOhBAA9g3vCyXeO83VfMspwuhr7nCn0zz6tQaR/0N
	3uLOMsOoa/VTAL9DzcqjGL/N8jBxSNdlzH9mwNKWjs0VXgcb3CCzxIfuBkpC3TKno44Hs+UNzhJ
	Y6cOLNijzxLIQH9HA==
X-Received: by 2002:a05:600c:4692:b0:499:781e:25fc with SMTP id 5b1f17b1804b1-499821c5a55mr85647535e9.3.1786638296945;
        Thu, 13 Aug 2026 09:24:56 -0700 (PDT)
X-Received: by 2002:a05:600c:4692:b0:499:781e:25fc with SMTP id
 5b1f17b1804b1-499821c5a55mr85646715e9.3.1786638296566; Thu, 13 Aug 2026
 09:24:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812181300.3712426-1-jtaubepe@redhat.com> <CO6PR18MB450084465A542D9DF1E46C51AFDB2@CO6PR18MB4500.namprd18.prod.outlook.com>
In-Reply-To: <CO6PR18MB450084465A542D9DF1E46C51AFDB2@CO6PR18MB4500.namprd18.prod.outlook.com>
From: Jesse Taube <jtaubepe@redhat.com>
Date: Thu, 13 Aug 2026 12:24:45 -0400
X-Gm-Features: AUfX_mxnzn0QQGs-cPHrzMNrM17HgyUB_gFx1iWfyyxeIkP3fWyqO39kLk3cHho
Message-ID: <CADRr4bceLLuu4KRf7X+P6aNyBtK+TGrBDKd4T5Uuw5DaM-9gXg@mail.gmail.com>
Subject: Re: [EXTERNAL] [PATCH 00/13] nvme-fc: FPIN link integrity handling
To: Nilesh Javali <njavali@marvell.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Keith Busch <kbusch@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Justin Tee <justin.tee@broadcom.com>, 
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>, Paul Ely <paul.ely@broadcom.com>, 
	Chaitanya Kulkarni <kch@nvidia.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"GR-QLogic-Storage-Upstream@marvell.com" <GR-QLogic-Storage-Upstream@marvell.com>, Hannes Reinecke <hare@suse.de>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, John Meneghini <jmeneghi@redhat.com>, 
	Bryan Gurney <bgurney@redhat.com>, Chris Leech <cleech@redhat.com>, 
	"Ewan D . Milne" <emilne@redhat.com>, 
	"shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2026 at 12:54=E2=80=AFAM Nilesh Javali <njavali@marvell.com=
> wrote:
>
>
> From: Jesse Taube <jtaubepe@redhat.com>
> Sent: Wednesday, August 12, 2026 11:43 PM
> To: linux-scsi@vger.kernel.org
> Cc: Jonathan Corbet <corbet@lwn.net>; Shuah Khan <skhan@linuxfoundation.o=
rg>; Keith Busch <kbusch@kernel.org>; Jens Axboe <axboe@kernel.dk>; Christo=
ph Hellwig <hch@lst.de>; Sagi Grimberg <sagi@grimberg.me>; Justin Tee <just=
in.tee@broadcom.com>; Naresh Gottumukkala <nareshgottumukkala83@gmail.com>;=
 Paul Ely <paul.ely@broadcom.com>; Chaitanya Kulkarni <kch@nvidia.com>; Jam=
es E.J. Bottomley <James.Bottomley@HansenPartnership.com>; Martin K. Peters=
en <martin.petersen@oracle.com>; Nilesh Javali <njavali@marvell.com>; GR-QL=
ogic-Storage-Upstream@marvell.com; Hannes Reinecke <hare@suse.de>; Jesse Ta=
ube <jtaubepe@redhat.com>; Gustavo A. R. Silva <gustavoars@kernel.org>; Joh=
n Meneghini <jmeneghi@redhat.com>; Bryan Gurney <bgurney@redhat.com>; Chris=
 Leech <cleech@redhat.com>; Ewan D . Milne <emilne@redhat.com>; shinichiro.=
kawasaki@wdc.com; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org; =
linux-nvme@lists.infradead.org; linux-block@vger.kernel.org
> Subject: [EXTERNAL] [PATCH 00/13] nvme-fc: FPIN link integrity handling
>
> FPIN LI (link integrity) messages are received when the attached fabric d=
etects hardware errors. In response to these messages I/O should be directe=
d away from the affected ports, and only used as a last resort. This patch =
adds a new controller
> ZjQcmQRYFpfptBannerStart
> Prioritize security for external emails:
> Confirm sender and content safety before clicking links or opening attach=
ments
>   https://us-phishalarm-ewt.proofpoint.com/EWT/v1/CRVmXkqW!te3Z1f8UYnTa1E=
-duf06bvZlnS-1FrR2Jkcx8WQcjCWqN2c_NKqyKXnJoJcD4hWMKkUnua_-glfm3m67hWRah9Kf0=
UTKp-APm3w$  =E2=80=8C
>
>
> ZjQcmQRYFpfptBannerEnd
> FPIN LI (link integrity) messages are received when the attached fabric
> detects hardware errors. In response to these messages I/O should be
> directed away from the affected ports, and only used as a last resort.
> This patch adds a new controller flag 'NVME_CTRL_MARGINAL' which will be
> checked during multipath path selection, causing the path to be skipped
> when checking for paths. If no other paths are available the 'marginal'
> paths are considered for path selection.
>
> The testing for this patch set was performed by Bryan Gurney, using the
> process outlined by John Meneghini's presentation at LSFMM 2024, where
> the fibre channel switch sends an FPIN notification on a specific switch
> port, and the following is checked on the initiator:
>
> 1. The controllers corresponding to the paths on the port that has
> received the notification are showing a set NVME_CTRL_MARGINAL flag.
>
>    \
>     +- nvme4 fc traddr=3Dc,host_traddr=3De live optimized
>     +- nvme5 fc traddr=3D8,host_traddr=3De live non-optimized
>     +- nvme8 fc traddr=3De,host_traddr=3Df marginal optimized
>     +- nvme9 fc traddr=3Da,host_traddr=3Df marginal non-optimized
>
> 2. The I/O statistics of the test namespace show no I/O activity on the
> controllers with NVME_CTRL_MARGINAL set.
>
>    Device             tps    MB_read/s    MB_wrtn/s    MB_dscd/s
>    nvme4c4n1         0.00         0.00         0.00         0.00
>    nvme4c5n1     25001.00         0.00        97.66         0.00
>    nvme4c9n1     25000.00         0.00        97.66         0.00
>    nvme4n1       50011.00         0.00       195.36         0.00
>
>
>    Device             tps    MB_read/s    MB_wrtn/s    MB_dscd/s
>    nvme4c4n1         0.00         0.00         0.00         0.00
>    nvme4c5n1     48360.00         0.00       188.91         0.00
>    nvme4c9n1      1642.00         0.00         6.41         0.00
>    nvme4n1       49981.00         0.00       195.24         0.00
>
>
>    Device             tps    MB_read/s    MB_wrtn/s    MB_dscd/s
>    nvme4c4n1         0.00         0.00         0.00         0.00
>    nvme4c5n1     50001.00         0.00       195.32         0.00
>    nvme4c9n1         0.00         0.00         0.00         0.00
>    nvme4n1       50016.00         0.00       195.38         0.00
>
> Link: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__people.redha=
t.com_jmeneghi_LSFMM-5F2024_LSFMM-5F2024-5FNVMe-5FCancel-5Fand-5FFPIN.pdf&d=
=3DDwIDAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D7My57sfPbDDcMFJyBD6G2keJbhsQZV7WIf=
8SjB-450c&m=3DViZhyiiF6nkaVXOE1PpaKWe2JBe94gTGHA24wKzPP99uuwXoNoSYqcE55NQRq=
t6_&s=3D0jhQeJW2swbeXGSnNtXSHqXkNX1eVjXmU7QSm6m2IpU&e=3D
>
> Testing has been performed by sending all FPIN LI ELS messages from the
> switch to the Host and verifying the proper nvme multi-pathing behavior
> is effected with each of the eight different FPIN link integrity events.
> Results were verified with iostat and with the nvme list-subsys command.
>
> These tests were run with all scenarios including where there were only
> non-optimized paths available, and where all paths were
> marginal/degraded. All multi-path io-policies were tested including:
> numa, round-robin and queue-depth. When all paths on the host are
> marginal/degraded, I/O continues on the optimized path that was most
> recently non-marginal.  If both of the optimized paths are down, I/O
> properly continues on one of the marginal/degraded non-optimized paths.
>
> Testing has been complete with both Broadcom (lpfc) and Marvell (qla2xx)
> 32GB HBAs.  Both HBAs successfully complete all tests.
>
> For a complete description of the tests that were run, please see
> bugzilla 220329.
>
> To test the path handeling use:
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__github.com_linux-2=
Dblktests_blktests_pull_264&d=3DDwIDAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D7My57=
sfPbDDcMFJyBD6G2keJbhsQZV7WIf8SjB-450c&m=3DViZhyiiF6nkaVXOE1PpaKWe2JBe94gTG=
HA24wKzPP99uuwXoNoSYqcE55NQRqt6_&s=3DXKJyyaOO9_UGG6uH5fv88U7bAke7X9H5Xz0qa3=
9qubs&e=3D
> or
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kernel.org_li=
nux-2Dnvme_20260812174503.3705830-2D1-2Djtaubepe-40redhat.com_&d=3DDwIDAg&c=
=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D7My57sfPbDDcMFJyBD6G2keJbhsQZV7WIf8SjB-450c&m=
=3DViZhyiiF6nkaVXOE1PpaKWe2JBe94gTGHA24wKzPP99uuwXoNoSYqcE55NQRqt6_&s=3DqPf=
emamvpsdH9yAG-9CRAILRyvMrzEaa_xjIaJTo1Ds&e=3D
>
> To test the full set including FPIN decoding use:
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__github.com_johnmen=
eghini_fpin-5Fli-5Ftests&d=3DDwIDAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3D7My57sfP=
bDDcMFJyBD6G2keJbhsQZV7WIf8SjB-450c&m=3DViZhyiiF6nkaVXOE1PpaKWe2JBe94gTGHA2=
4wKzPP99uuwXoNoSYqcE55NQRqt6_&s=3DSzJUICtyPkmr7xYyCu6_gZb5itPn8MZRQm4z0Zoew=
ak&e=3D
>
> Closes: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__bugzilla.k=
ernel.org_show-5Fbug.cgi-3Fid-3D220329&d=3DDwIDAg&c=3DnKjWec2b6R0mOyPaz7xtf=
Q&r=3D7My57sfPbDDcMFJyBD6G2keJbhsQZV7WIf8SjB-450c&m=3DViZhyiiF6nkaVXOE1PpaK=
We2JBe94gTGHA24wKzPP99uuwXoNoSYqcE55NQRqt6_&s=3DYbu1spaO4qBWAVWu7hq8KHIP73x=
HRmGPfJCrZVoqacY&e=3D
>
> New refactored implementation enables administrators to manually control
> port marginal states via sysfs. For example:
>
> # Set remote port to marginal state
> echo "Marginal" > /sys/class/fc_remote_ports/rport-4:0-1/port_state
>
> # Clear marginal state (set to online)
> echo "Online" > /sys/class/fc_remote_ports/rport-4:0-1/port_state
>
> Changes to the original submission:
> - Changed flag name to 'marginal'
> - Do not block marginal path; influence path selection instead
>   to de-prioritize marginal paths
>
> Changes to v2:
> - Split off driver-specific modifications
> - Introduce 'union fc_tlv_desc' to avoid casts
>
> Changes to v3:
> - Include reviews from Justin Tee
> - Split marginal path handling patch
>
> Changes to v4:
> - Change 'u8' to '__u8' on fc_tlv_desc to fix a failure to build
> - Print 'marginal' instead of 'live' in the state of controllers
>   when they are marginal
>
> Changes to v5:
> - Minor spelling corrections to patch descriptions
>
> Changes to v6:
> - No code changes; added note about additional testing
>
> Changes to v7:
> - Split nvme core marginal flag addition into its own patch
> - Add patch for queue_depth marginal path support
>
> Changes to v8:
> - Rebased patch series to nvme-6.17.
> - Added patch from Gustavo Silva, "scsi: qla2xxx: Fix memcpy field-spanni=
ng
>   write issue", which resolves the field-spanning write issue
> - We decided to leave the "marginal" state as is, because the transport
>   driver uses the term "marginal".
>
> Changes to v9:
> - Rebased patch series to nvme-6.18.
> - Refactor and fix a patch from Gustavo Silva, "scsi: qla2xxx: Fix 2 memc=
py
>   field-spanning write issue", which resolves the field-spanning write
>   issue.
>   This new version of Gustavo's patch fixes a bug found in testing.
>
> [NJ:] I could not find this qla2xxx fix in this series. Am I missing some=
thing.
> This fix is certainly required to avoid few call traces reported, as disc=
ussed here,
> https://lore.kernel.org/linux-nvme/97526d45-ec7d-48a0-bdc6-659f75839f53@e=
mbeddedor.com/#t

You fix:
Commit 7db93e3c580d ("scsi: qla2xxx: Enhance purex_entry handling for
29xx series")
fixes the issue.

I forgot to mention it in the change log for V11. i will include it in
the change log for V12.

Thanks,
Jesse Taube

>
> Thanks,
> Nilesh
>

