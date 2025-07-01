Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A3B2FEE10
	for <linux-scsi@vger.kernel.org>; Tue,  1 Jul 2025 20:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751401963; cv=none; b=C3vx94cATQ/aR/3RDi0YeKXoavBrX80IZwYHysTdxupO1zkEPsKrS8Ciig0J0tpfQVbeUmgD8llxpzTp513KyY/SNWiNqdh0cZJr1ilI76ToXAFr5dVzWm7VYTW6WmAC/WO3wGXBdZSpZOy7z55L5QunUknnnIXKTehaJdk5+eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751401963; c=relaxed/simple;
	bh=lhbw11nQ7b0aR2Z30rHwPBlF/+badm3+KVmfhXMdWG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eFsibtGy5qsh1nohZg8rVhMHGIoOAkmpOeS7b9BIdrwlvlIso7mdT/nW2M1w6HTd4M3nAjSDbWHshEoM7avEz7zA4jQ/S3UlSJvxhla5DwePStj+2dfXJX8Qdwxjc8PQ3ingSz331doKKNwRhvpFUbLuMBP1OJy0jS69vu91WAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AvulrLHi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AvulrLHi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751401960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E3QAp+njIqgagygGelfi+VFuGwWXW8+PeuSHzW1GgA0=;
	b=AvulrLHiY//6sLMGZhKpI60YMCUyaGjmLKCj+Mws2xaCYIh3IPnfSAD5tgf/1Dh/bfQmNV
	6Q8x2BTp+mx0fCXTcLDoorBrnJC/wikr6NR3p8C3Qs+5N+vRUBNLUKj8noNrRZduWR0S1W
	WZgDzDQ+Oslo/wBDCSBy6vuShJf6m2E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-YFQAK4K9O3GGmhPiIQw-yQ-1; Tue, 01 Jul 2025 16:32:39 -0400
X-MC-Unique: YFQAK4K9O3GGmhPiIQw-yQ-1
X-Mimecast-MFC-AGG-ID: YFQAK4K9O3GGmhPiIQw-yQ_1751401958
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a578958000so1425707f8f.3
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jul 2025 13:32:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751401958; x=1752006758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3QAp+njIqgagygGelfi+VFuGwWXW8+PeuSHzW1GgA0=;
        b=q56p8M5XiKgASYFxQQ+mZKTI0AVk5OI+gOd15y/vD0wdhFhVM80aful5P5cmJ/N1xC
         nse5nnOeOsP5AhPU9ron+iVf41sgQVqD7i0pmri9K4UN92Ur4ttdFKBYB2L3FKyVfch6
         P3InFM5pgzBE2ljj4DiiPUeOEfc+PMhM3S/RfMA25s6PSQ+8eUbcbBdm0tHtgQICLvom
         rYN2j6f3uXyi5tz0Weer1Qibf6UaRmPTemyIbKXhjS72cLJPMUoldqpABtlzKOgZEqBq
         FKHDEvLgJ+bAOzH8Ts4e9iaVNnuZR6swHsP40TZMt8I4PPhRhbiTWkjoKovFboAt1FpL
         dd9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUVG3eH6hUAGF3wMLLt7orPiGYC9JZtlwGa4twYa4umoLfgDkEGMtjT8do82CrbrBA2C5KXNLBwl36X@vger.kernel.org
X-Gm-Message-State: AOJu0YwgpOxTcJQ+L29fMKjPOXU06WhxeZXC5XV5crJV5vlQSalHbVXh
	CTcl/bhUkgtovuGzusJfwJkm2d1G3wsTdwFMc2Zi0O0lgRENqY+FmPwKRPwhNnb2LZyrnTFdcIv
	Op4zJyjx4yQeki5GcSRpQAFbiwTz5c08nruKsUA1Rdt/Abs23vWM1DdCHvGbMmaHUDflTBf8zHu
	e/qXsUL/ZPEGpXpXCo+g9JYTxpqLEirBF4QS5jWQ==
X-Gm-Gg: ASbGncuNisqD16v1b/EQlbFjZNJ3qKA6aJqQttc5t7q5/2vkByfbMVf2hlu3y5RCGWQ
	YKSTFcpM0lrejXLveEXbsdFWuwiV52CMJ1Cxi1Z9TWO6gosKviDfwjuTtp8h8vesyem7GuGeSPM
	luBWCY
X-Received: by 2002:a05:6000:25ca:b0:3a5:8abe:a267 with SMTP id ffacd0b85a97d-3a8fe5b1cf7mr15747188f8f.29.1751401958025;
        Tue, 01 Jul 2025 13:32:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaXTrHdYMTTka2N0mDvXTqVTj3B/c609I9qCTvVCH95ljEAo/uWdP4xeb+yfNBMzV+3n9TvAoTLAQSpx33k7I=
X-Received: by 2002:a05:6000:25ca:b0:3a5:8abe:a267 with SMTP id
 ffacd0b85a97d-3a8fe5b1cf7mr15747169f8f.29.1751401957535; Tue, 01 Jul 2025
 13:32:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250624202020.42612-1-bgurney@redhat.com>
In-Reply-To: <20250624202020.42612-1-bgurney@redhat.com>
From: Bryan Gurney <bgurney@redhat.com>
Date: Tue, 1 Jul 2025 16:32:26 -0400
X-Gm-Features: Ac12FXzlbt2uDX9BNpN5evNVgF5ZoZ7CRlSkxe-hfkTmpSFBIUZ-ko4ETlTFq7w
Message-ID: <CAHhmqcTO_Q59aDr3DywC-tPF=9pe3gxbyn6J4ycdf+eYEOayHQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] nvme-fc: FPIN link integrity handling
To: linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de, 
	sagi@grimberg.me, axboe@kernel.dk
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, njavali@marvell.com, 
	linux-scsi@vger.kernel.org, hare@suse.de, jmeneghi@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2025 at 4:20=E2=80=AFPM Bryan Gurney <bgurney@redhat.com> w=
rote:
>
> FPIN LI (link integrity) messages are received when the attached
> fabric detects hardware errors. In response to these messages I/O
> should be directed away from the affected ports, and only used
> if the 'optimized' paths are unavailable.
> Upon port reset the paths should be put back in service as the
> affected hardware might have been replaced.
> This patch adds a new controller flag 'NVME_CTRL_MARGINAL'
> which will be checked during multipath path selection, causing the
> path to be skipped when checking for 'optimized' paths. If no
> optimized paths are available the 'marginal' paths are considered
> for path selection alongside the 'non-optimized' paths.
> It also introduces a new nvme-fc callback 'nvme_fc_fpin_rcv()' to
> evaluate the FPIN LI TLV payload and set the 'marginal' state on
> all affected rports.
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
> Link: https://people.redhat.com/jmeneghi/LSFMM_2024/LSFMM_2024_NVMe_Cance=
l_and_FPIN.pdf
>
> More rigorous testing was also performed to ensure proper path migration
> on each of the eight different FPIN link integrity events, particularly
> during a scenario where there are only non-optimized paths available, in
> a state where all paths are marginal.  On a configuration with a
> round-robin iopolicy, when all paths on the host show as marginal, I/O
> continues on the optimized path that was most recently non-marginal.
> From this point, of both of the optimized paths are down, I/O properly
> continues on the remaining paths.
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
> Hannes Reinecke (5):
>   fc_els: use 'union fc_tlv_desc'
>   nvme-fc: marginal path handling
>   nvme-fc: nvme_fc_fpin_rcv() callback
>   lpfc: enable FPIN notification for NVMe
>   qla2xxx: enable FPIN notification for NVMe
>
> Bryan Gurney (1):
>   nvme: sysfs: emit the marginal path state in show_state()
>
>  drivers/nvme/host/core.c         |   1 +
>  drivers/nvme/host/fc.c           |  99 +++++++++++++++++++
>  drivers/nvme/host/multipath.c    |  17 ++--
>  drivers/nvme/host/nvme.h         |   6 ++
>  drivers/nvme/host/sysfs.c        |   4 +-
>  drivers/scsi/lpfc/lpfc_els.c     |  84 ++++++++--------
>  drivers/scsi/qla2xxx/qla_isr.c   |   3 +
>  drivers/scsi/scsi_transport_fc.c |  27 +++--
>  include/linux/nvme-fc-driver.h   |   3 +
>  include/uapi/scsi/fc/fc_els.h    | 165 +++++++++++++++++--------------
>  10 files changed, 269 insertions(+), 140 deletions(-)
>
> --
> 2.49.0
>


We're going to be working on follow-up patches to address some things
that I found in additional testing:

During path fail testing on the numa iopolicy, I found that I/O moves
off of the marginal path after a first link integrity event is
received, but if the non-marginal path the I/O is on is disconnected,
the I/O is transferred onto a marginal path (in testing, sometimes
I've seen it go to a "marginal optimized" path, and sometimes
"marginal non-optimized").

The queue-depth iopolicy doesn't change its path selection based on
the marginal flag, but looking at nvme_queue_depth_path(), I can see
that there's currently no logic to handle marginal paths.  We're
developing a patch to address that issue in queue-depth, but we need
to do more testing.


Thanks,

Bryan

