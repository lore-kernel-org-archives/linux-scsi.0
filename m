Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC802DCF45
	for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 07:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789803970; cv=pass; b=GFfOUR8nMdt2UPw037IkNEUJLxqp+rqq11nvwmejXxZcV6yi6BgY7l0SLQ2P8+vsjEwdHmolPlXyy35aNzFmE7qByQz7ghV9KW1hdFoIZB9bsiUVgc7TETniBEF378E8xjtMBhdQFQ4EFFizn2UdD4C+7CjE0dH/yziTJ2ycDu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789803970; c=relaxed/simple;
	bh=6nfk/U2Ny8e8Dsi7KE1IbJ5K999MBUgTnN7tzqDOrU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nLPMPrnTH2mLf73BSUMitz0eXtAnhJ5B3MwDpiG1O28i6g2Lxv+1emSj8SvwWaY6XTbMUch04zOfaVNvq2qrG9dmL0d8mZWI8SSQkKEDWPAELbTE7aTtbNLGh1E8Tq98lmKhmeIWYaqYeGPsUsAms8vo63Jc59616DM6upugoGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PDQ4pFsO; arc=pass smtp.client-ip=74.125.228.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PDQ4pFsO"
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6a6056be4d2so1168518a12.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 00:46:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789803967; cv=none;
        d=google.com; s=arc-20260327;
        b=DivkqlovaBOWDEpgUVqNHNKDJttbE1ENzv5NdcCyDFvRCqB/OdtlHDe0nnwElZDUUr
         lnvZ1LF6yDM5PcULNK/9Ra3a8D1bmi+TW7Dmv5XMvNZbARDY1IUgIuYb/MwANdC6vfpN
         qdqfpve/o6mejdyE4IK1G7dXU55g//KPyfBMkXxcX9Llc/k5Z7vOEX7rtvo50WpwSZw5
         VXXJLmfnEZKm0k3+jEAqaRGsnSpBRrgLCAH65VJnm41qezKODh+TpFgwrI6FddYyWWHb
         f+EUDmCq7QJ1hvY8k3rJb1MDVUgbmaI1E65RtO61x6mHnnZor3z9NTfzNRynUjlYZNmY
         LT8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k1tm4AGXS0ss9gZPE8CcrC9/GLzkfyMOVBZ4IzInrlI=;
        fh=/0aEgdMRzPzbiXNOtbdJrWQiBsUkf7pHtSToqBAsX9U=;
        b=cNOYZEsgnLY/EyExVQG0T524LINJ8iJJDNuJvvsz9XGS/dxqzv9lek7Dgj3KhnGpMv
         Ndh3f2NeckEKau12xsaLF267mTu5W1uK9YqYqxCzpbGT7L86DByjBTXy1Ca1Bz3kmtLG
         B7h/Wo64TXdI+65zSjJl40cWF0qRbyeLNxThuQys78IWqpazakmMA+vm7K89GgeulMmQ
         8tug229Jtytib8eFuZCn5Ff+pJqTzfH6GxEUdnAZMBHm/frndqZQACPIRy9FXDTSXqiU
         xXjmOcY6nzaPvVXlO+8k/eTyvHIXauRfbYrurjOh+L2f1dHnmR3qyKpXUBTSmkt7dZYS
         Yhlw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789803967; x=1790408767; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k1tm4AGXS0ss9gZPE8CcrC9/GLzkfyMOVBZ4IzInrlI=;
        b=PDQ4pFsO431ea8Y6K7IQpUUdXYJFWlugZeDCGil9kqUUO5GXCZarOxtluBJXDQQC43
         p76ZkzhLofyVVwvjuTHkGOVtP+y7l6NCsax4gBbCNImi+3mXrX3qgxWb9gWRQoou2SrB
         kAjui1d9i/xpR8JuF+KMJlsMY5o8BVgJqunQ6p05+UNEh5ri0AXJBuR5Z+LTrsRK93So
         6b3djKqYgzQmwT1YPfJcGxtH8uklMo3XNZ2fEsH0jcC2gsAcxfkSkYwjnT5UFGtq+GIv
         a75O+SRTT48cW5xgPVV41FZc5M151iMjvWKySe2b8rQ/Npszo4BndDTEaetoho18Hdxq
         iDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789803967; x=1790408767;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k1tm4AGXS0ss9gZPE8CcrC9/GLzkfyMOVBZ4IzInrlI=;
        b=bggn/gFU9mbQ4qLms72k5Q35d9rDH+mjCpXat+u7/+6VwOUSR2sb+lVszkwi8ky5Q1
         833tSIx9u4fYHXUeuxTmsPgJUtFN3pZo6l6EL4n+zQWlfbFZ5NCo7i/mhGmklzrGy0UQ
         zyevm+7yFhBpVVdxZSt6YnGTkXj9tRe8xWM5LVPPtdOkRKS3GJ78nD0LQO/2ZfgCSw9H
         GJnIJ7lgdAk/flx7+XO3jHEGvapUF0qYBkEf+bPUzp5OsmpRw3EEH6mYGJ54LK0poN15
         X0O7ATgWR4R9tlBQsQJWoOmDghj9wL9bgjWNdXRaRnRvyPE6CZ4yCtTny7yFeFPzUiEW
         c9SA==
X-Gm-Message-State: AFuF++lWJVEFjP0sfGm0jH2ozAOpThtBczfZfE22ZbV/zaP15rCmCbuQ
	RMvHp/Yb9xDcNNEhIDooQBERGQ2gv7XlD+BdjbxD3JtC+ovbfP7QCzkbxq3ROB1JevFZX2IP+ZY
	0Hb6rxJAKonUQuNv0BsrfroHj7NJhcKSftzakxzo=
X-Gm-Gg: AYBFou1Y0/9qgwLobDFCGIg/pfj4/IefupsB5SNrhYepHi6OWlL8xsksOlTjRe9mT/k
	6SpMyT6oIFDW2K2N1zLgaXg6COX8v3BXbGnEo7ne+ZZ/MrefX7e6lFlRZ9NX7uGDAwhoWiGO1GI
	0mlwBmocjrzK5tx4iqS8bmyyUImxPkach8ISgFbvLAkgiOzyd3eBQUOWG2yzMa5OgUOZqXLxwkL
	7snt9UCWQvJ55XxaER/MVKPkKpfvWWBS8YTbI2cwyS5s0ju436jXMJKD5whp0kN4tyQDWzbYfB3
	hI17Hea5NNyOfPx/4SNGb5tF34M276yfIAtjRf5F7EAsJWZVYFDJykFrLU7/IsgMrxE=
X-Received: by 2002:a05:6402:324b:b0:69f:c929:b88 with SMTP id
 4fb4d7f45d1cf-6aa4f9a56abmr2658043a12.5.1789803966828; Sat, 19 Sep 2026
 00:46:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
In-Reply-To: <20260917222015.61053-1-nkirkland2304@gmail.com>
From: Nigel Kirkland <nkirkland2304@gmail.com>
Date: Sat, 19 Sep 2026 00:45:54 -0700
X-Gm-Features: AcwNN1WvdvYoXYF7dqr9j1OSuw_5PSxurYR6zqCsEd6PfOuldFpRGFVv0OlKGjA
Message-ID: <CACnqm79AfmdHbJZ-hDNsrbeDBXVBuq2A8uwdPKzKu+W7YzrJDg@mail.gmail.com>
Subject: Re: [PATCH v4 00/14] Update lpfc to revision 15.0.0.1
To: linux-scsi@vger.kernel.org, nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com, Nigel Kirkland <nkirkland2304@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 2:57=E2=80=AFPM Nigel Kirkland <nkirkland2304@gmail=
.com> wrote:
>
> Update lpfc to revision 15.0.0.1
>
> This patch set contains bug fixes related to cleanup handling in both
> normal and error paths, discovery rework for large SAN configurations, an=
d
> refactoring of duplicate code.
>
> The patches were cut against Martin's 7.4/scsi-queue tree.
>
> Nigel Kirkland (14):
>   lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
>   lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not set
>   lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted cm=
d
>   lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
>   lpfc: Add handling for when PLOGI or PRLI is dropped during link failur=
e
>   lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery sequ=
ence
>   lpfc: Rework I/O flush ordering when unloading driver
>   lpfc: Improve PLOGI retry handling for large SAN configurations
>   lpfc: Send inhibited ABORT_WQE when PLOGI CQE SEQUENCE_TMO is received
>   lpfc: Remove slowpath cqe process limiter in slow ring event handler
>   lpfc: Put iocbq on phba->txq when ELS WQ is full or ELS SGL unavailable
>   lpfc: Update ELS ACC logging for diagnostic troubleshooting
>   lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
>   lpfc: Update lpfc version to 15.0.0.1
>

Preliminary response regarding Sashiko findings.

Patch #6: Sashiko pointed out 2 [high] issues that appear valid in
theory, but appear
highly improbably in the real world. We are reviewing these findings
and whether to
address in a v5 drop or a future patch set.

Patch #8: Sashiko pointed out 1 [medium] and 1 [high] issue. We are
evaluating if
these are a real concern.

Patch #9: Sashiko pointed out 2 [high] issues. We are evaluating if
these are a real
concern.

Patch #10: Sashiko pointed out 1 [high] issue. Whilst valid in theory,
the patch eliminates
a real world "silent-drop/delayed-reschedule" bug. Removal of the
maximum processing
count does introduce a theoretical concern in the event of a sustained
flood of slow
path CQEs. However, the original issue that prompted addition of the
processing limit was
related to loopback testing. Loopback processing was subsequently
moved away from the
slow path, eliminating that as a producer. Removal of the processing
limit was overlooked at
that time.

Patch #11: Sashiko pointed out 1 [medium] issue. We are reviewing
these findings to
determine whether this should be addressed in a v5 patch set.

Patch #12: Sashiko pointed out 1 [high] theoretical concern, but in
our analysis the race is
unlikely. If seen, the worst case outcome appears to be reporting of
an incorrect cmd code
value in log message 1027.  Closing this theoretical window is
something we plan to address
in a future patch set.

In summary: Analysis of the findings is ongoing with a complete
response anticipated
in a few days.


>  drivers/scsi/lpfc/lpfc_bsg.c       |   7 +-
>  drivers/scsi/lpfc/lpfc_crtn.h      |  12 +-
>  drivers/scsi/lpfc/lpfc_ct.c        |  23 +-
>  drivers/scsi/lpfc/lpfc_disc.h      |   5 +-
>  drivers/scsi/lpfc/lpfc_els.c       | 503 ++++++++++++++++++++++-------
>  drivers/scsi/lpfc/lpfc_hbadisc.c   | 130 ++++----
>  drivers/scsi/lpfc/lpfc_init.c      |  21 +-
>  drivers/scsi/lpfc/lpfc_nportdisc.c | 100 +++++-
>  drivers/scsi/lpfc/lpfc_nvme.c      |   2 +-
>  drivers/scsi/lpfc/lpfc_scsi.c      |   2 +-
>  drivers/scsi/lpfc/lpfc_sli.c       | 227 ++++++++++---
>  drivers/scsi/lpfc/lpfc_sli.h       |  18 ++
>  drivers/scsi/lpfc/lpfc_version.h   |   2 +-
>  13 files changed, 812 insertions(+), 240 deletions(-)
>
> --
> 2.38.0
>
