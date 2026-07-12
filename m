Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854411C69D
	for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2026 01:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783819479; cv=pass; b=bJ4U+OOmfreqb0l5sknpqUodGZEySrtY3oqozHnXqJkvtW88z++wlqZBgwlqJ3+F6KbzjD8PuZslbqQP0W+SA0rzBbUBKOzUf0maSocwWu1anrlhKru/OGYa/mZOcfzS1njjY6UlEvMuxcOdQD7t/5fqQNPLOoAEyiom1HDYSRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783819479; c=relaxed/simple;
	bh=+FwVSe2d14dPRaXawwqgs3uwuk52uqckNYKaAjC8t+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ELVLYAbqvSxt5TcqkYRCxi0Y5A75gf+NSbjzKlaYdD4BQxEddVwY8pVmOOq4UfOy/mxXTehL+ANpWw8Q4vU42QSMvufLosUgXYf9y2rbwHO2RcnulPiD+b/JOfdQF7dZeY71+qwboLecD5BBfan9ZKqb731BRA69EXRLdjMc7tY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ka3RfpXw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IMXTk2JM; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ka3RfpXw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IMXTk2JM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783819476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7P2WXejgE+Lgg0h3xBd0h5u7lxGNyKGkERuLDYdt4gM=;
	b=Ka3RfpXw0ebPs/fwP42zkADtcdy/Lt1DXBOQZTAsiU7fVq6zQ8CQ2g92l1sY/0ut7Ep2Fz
	7Q1MYVQVdHE3JM8AT/5r9sIKXM2A2Gecw+htxzjkFSBOM+Y7AP/hHgRoqyNxqWMEiOjFey
	GR6KCuEEsKE34g2Zkqp43WQ7Lg7DgOs=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-GtBdbGfbNA2SVqIwsJEAmg-1; Sat, 11 Jul 2026 21:24:35 -0400
X-MC-Unique: GtBdbGfbNA2SVqIwsJEAmg-1
X-Mimecast-MFC-AGG-ID: GtBdbGfbNA2SVqIwsJEAmg_1783819474
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-667825d3bdcso5378371d50.0
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2026 18:24:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783819474; cv=none;
        d=google.com; s=arc-20260327;
        b=cVLyJp6lytzhfH9Gtnfmm12ivAekFMFleaRoxBz/cxoaCLIYdVBiYx4OMdD/TzqS6U
         rFS0BXZ4gr/19HHnzThFTXoqXsJcPvYEjAvijdaDMaC8vAAupvDWG6ekbFkhSNy7O7tT
         6GROJ4yjsgdWKia5SZePjvuxWRuc8ro4TCP/M05IX84/Y+OtStqYnBPRLiuqEb26Q0Q8
         tWZpEFdiFiKiiF+JzagOi+AWWlzUyWMbMX3CzKySnSiHWTphDOsKfQuNJ8BMiZr6/u6I
         3iELDCmkCsoojKVY/28VMhufmrsbB2PEZzSFn1XypOzfBOSe2zYQPjwE+1HcsuIxJxYB
         ilqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7P2WXejgE+Lgg0h3xBd0h5u7lxGNyKGkERuLDYdt4gM=;
        fh=V0/Gu/5jnCD9iMwRUVvAKQlUYq7mxd+/8vLtk0BIwHo=;
        b=A8pHm4xWE+SlSRADCdi9uxWXfStIZFJBriFRNnxsLzmKssd5FNDj+bYsLXX/zgTCzb
         +cCMf2q999VpzuTGrRcTXCD9dd5Zx4xpqEsELCqxrjReMCOYV9P7cD2i9uafhFhyU0Km
         UFEzo2tdrTjILcxM6FRy1OxISTRxv9G0Q/U68ll/V0PhPrdZtRaCFucXYXKlj+TMuS0r
         J6MTZwlvEsCqP4S7nlOl7sbd03Q+LpqymOdGumenxYSA9qVb0sYQxiT+tFZdRh73hoAp
         PV+Ny7nFU5BLmJ3cuY6n/gCLrhUgA/yMY9pAWs7XWT54RwcoRsN0zofOJO9A/eb5nk2d
         IC1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783819474; x=1784424274; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7P2WXejgE+Lgg0h3xBd0h5u7lxGNyKGkERuLDYdt4gM=;
        b=IMXTk2JMOe98woCIi0dzBev4HvC08fKJ+zsTfU4sHyeA1ZdoKcPWw+bBRVslRPR9fR
         HS9LBfGRAC+tGMo5RpTML0zBWrt5Md6QIuPUR0eHzTJZvjOxqiAoX7NX9yHXGwLL/k15
         QG2B//m7XAz9GTGK8Cb3spUukWVq0LKRle8tWLsHH0hs8O29PFVXv2UonyQMf1byW5bH
         xEpFfrhSsQT6DEtzp5FvYDOAv40cA0Gub+9NBRYoOiqhsk65fmIR6Kf7TS2Jtk5YfPFJ
         g40ZFrakvd/73UB70Q2TKMritPyTbiKVFq92GjrFS01rFw4SuTWUn0w/BgeojisaE07J
         FWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783819474; x=1784424274;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7P2WXejgE+Lgg0h3xBd0h5u7lxGNyKGkERuLDYdt4gM=;
        b=c5CBeJ1UsEa5inon9M+zX5yORjkpNne1pn3YsTjpOnGz8a8N8llZZg4Pr7ItiMfG98
         hQjEhHGOVBx6RNSU4hFb8DpyWk8aK2EExtTbuzr/bbmJe6Ngpk2jsACEqYvPgBqorpUM
         mnWUM+n95Z4QQii1GsvkrNWw50IybObZQSrUpbTg0fr5cfSbP9luNcVPQoSvz+CJcZDH
         TL0muZ0wb/7gsgCXXEhAsF+1sCGSd+4TrfnyaSAC/0u3KWh75Ywzbfe3b4oXk180G+tf
         g5gLUNHCKKDxFW+t39VOtQplOYFX+FtH4/SSBNjN7oumUn4itYWIqz1aDQKuFkUV8ZaI
         m3AQ==
X-Gm-Message-State: AOJu0YwsRhQDBsbxsAJAR2X3PLVy1OAPCKi3r/owDqDb0tlNTqn0uTAf
	63lNm3PumH2RKeQLBmPEIKPJb6UbqvV6YNe87Cn0EpXkI4g6T+E32K3A08y3PpZdn4rJQ3E6Qny
	Oz06tenKH1g9+fAxNvUVHBrGeKwFKWVxnJKyJOYYPjOqXHWXJ6RU8MtugdH7sSPy0JPGJDJ7TK1
	JFBoWc756em0ohxr1DqNYYdKdx1UlWK0McPV7X/Q==
X-Gm-Gg: AfdE7ckEoSC96jQuolGYWRB2zT+OsTiuV7xmEhLEns7o+xXthWJ0uC8d1SaZ7+u1Qi+
	YUZt59aTIUjPGJ75A3+JKvexXPfXc6sEhy+XR5L0w0FEs3ul72E1uDjz05NQVyF8fflgPluTsLG
	5cObqh81d+d9QjKDRQMyTg7UVOOKOGxYqb0n84VFjRrcXfPyZjathYwyzDgWq/81CrIXj2abAuY
	WO86FLwG+S0B9jJeHTFbH/D1CwfF8f8pUDbu6RwQO/q8jBwug==
X-Received: by 2002:a05:690e:4199:b0:666:4cf:65b3 with SMTP id 956f58d0204a3-667c5adfd50mr5098149d50.15.1783819474261;
        Sat, 11 Jul 2026 18:24:34 -0700 (PDT)
X-Received: by 2002:a05:690e:4199:b0:666:4cf:65b3 with SMTP id
 956f58d0204a3-667c5adfd50mr5098143d50.15.1783819473774; Sat, 11 Jul 2026
 18:24:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260605182336.134919-1-justintee8345@gmail.com>
In-Reply-To: <20260605182336.134919-1-justintee8345@gmail.com>
From: Ewan Milne <emilne@redhat.com>
Date: Sat, 11 Jul 2026 21:24:22 -0400
X-Gm-Features: AVVi8Cchmschd_burQktGBr7qLT_V9U_LPnMA-XIpuGTagTAelr2nD2Hi76fEMM
Message-ID: <CAGtn9rk+PKVqjBc0Kcy7Y+QO+B9nzhAd5DKNHB-c_ncKmm2Uhw@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] Update lpfc to revision 15.0.0.1
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart833426@gmail.com, 
	justin.tee@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 1:45=E2=80=AFPM Justin Tee <justintee8345@gmail.com>=
 wrote:
>
> Update lpfc to revision 15.0.0.1
>
> This patch set contains bug fixes related to cleanup handling in both
> normal and error paths, discovery rework for large SAN configurations, an=
d
> refactoring of duplicate code.
>
> The patches were cut against Martin's 7.2/scsi-queue tree.
>
> Justin Tee (14):
>   lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
>   lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not
>     set
>   lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted
>     cmd
>   lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
>   lpfc: Add handling for when PLOGI or PRLI is dropped during link
>     failure
>   lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery
>     sequence
>   lpfc: Rework I/O flush ordering when unloading driver
>   lpfc: Improve PLOGI retry handling for large SAN configurations
>   lpfc: Send inhibited ABORT_WQE when PLOGI CQE SEQUENCE_TMO is received
>   lpfc: Remove slowpath cqe process limiter in slow ring event handler
>   lpfc: Put iocbq on phba->txq when ELS WQ is full or ELS SGL
>     unavailable
>   lpfc: Update ELS ACC logging for diagnostic troubleshooting
>   lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
>   lpfc: Update lpfc version to 15.0.0.1
>
>  drivers/scsi/lpfc/lpfc_bsg.c       |   5 +-
>  drivers/scsi/lpfc/lpfc_crtn.h      |  12 +-
>  drivers/scsi/lpfc/lpfc_ct.c        |  19 +-
>  drivers/scsi/lpfc/lpfc_disc.h      |   2 +-
>  drivers/scsi/lpfc/lpfc_els.c       | 427 +++++++++++++++++++++++------
>  drivers/scsi/lpfc/lpfc_hbadisc.c   | 100 +++----
>  drivers/scsi/lpfc/lpfc_init.c      |  16 +-
>  drivers/scsi/lpfc/lpfc_nportdisc.c |  86 +++++-
>  drivers/scsi/lpfc/lpfc_nvme.c      |   2 +-
>  drivers/scsi/lpfc/lpfc_scsi.c      |   2 +-
>  drivers/scsi/lpfc/lpfc_sli.c       | 246 ++++++++++++-----
>  drivers/scsi/lpfc/lpfc_sli.h       |   4 +-
>  drivers/scsi/lpfc/lpfc_version.h   |   2 +-
>  13 files changed, 707 insertions(+), 216 deletions(-)
>
> --
> 2.38.0
>

For the entire series:  No new issues encountered with regression testing.
There are multiple important fixes in this series that address known crashe=
s.

Tested-by: Ewan D. Milne <emilne@redhat.com>

