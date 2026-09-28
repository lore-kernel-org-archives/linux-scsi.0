Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C634F0537
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790615621; cv=pass; b=b5c5wO5ViI6cYVRG0YUAetG7B1K7bH046QZ0JeCC7os+oceBbozHA65ZV0napmTsJKuDL9CNThSSItC9SULdrnzvel4fQYje/FNfIiiwiVo7UCTNuhkFWQPKLOIRXHCoUGas/ozcN8xF6J3YxKOmW4HFBsRmgDwlLdl2NwHDpfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790615621; c=relaxed/simple;
	bh=gmc7Pc0metHyIRWYyxOLtpRi0OKsTB8KcyEk2TkyMaY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c4jBDYZyxH4c5krTAnzj5Ox/o9bHNZ104xtE66/ec33EkMWDSi4/xhzYSvi8YF3yhhAac9yTfCYYRN5i8AAwDE7DvlJECNoe0ENtyNmUcwUhzcDNhKHYmcti/IvwuyBM2nwOdkaRE24uFIBVRwCV/6zzXLHzKG3DJYkqyDeZc5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=flHk9qMx; arc=pass smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="flHk9qMx"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2af43c5b0cso402997966b.1
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 10:13:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790615618; cv=none;
        d=google.com; s=arc-20260327;
        b=DUhcJcZJFHy9P9z2wEU8wGY0M4eWWVOPJziZh8ubQM0QtSB68f6GdLmSt2WmuK4uLX
         E98zl3P6gla7bEX7V8wUGzPf8c0zsxJzaxGxFgmtL5/ccUIK+b/1n4eKPD8fCkOsQbX7
         8KrdK6nSP/4L9edoAaG18hf9rZx4n7yHRZ3EQUoHKA0S8PTFzvcNhM13o6Xsddw7yV8O
         r/1WRcatDsh1IgcLl7ntvkVtlEOIYLrvcUXOC6FmgcphC1Las0sR43o0z+QaEHK2fZd9
         GZx4SMoVpnw80/ixTges1v+DmYIExMYCOLwWJ0S5LtPw9wHaOs9Ge2UxJWnZp0NwV6rl
         sGZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q5c/Mh1KIdWOYND7CZ3pWQaMV70vYz5Z5e9OrbANVNM=;
        fh=EmhP1HCqta23iwc1un51CtNb/ZNNmxToI7M4twW/mzk=;
        b=pmuJ48LI5IVqfQ9CJLc4+TD3lDZIdnEe51Chv1dv1KoxdxS1wulDYOA/sIz9QNoUMW
         YTP0KyaNkfr7Bbn74X564LdD8FMCUECcA2udPJvC3vuO+JcUw+hQR1YZZAOOMjP+Zybn
         fFzQHbclinOZXau7klQSDloImjD8c1VIrtEaYNQ2CO8jQLv1jfrLDqz3XMxticUTGDvl
         LM1lSMXro4N83Q7/aeA5DsrJNC3EAWX4dFIPiOnx9zqB6htIZY1sKtFPtD7GAZfUUlO4
         YEbmI+EiBlel+TjiPacFWXZdlcQbCGyEKs4ooxrUP6U16kxxBftk7WBdzVgsNJMPmD6/
         Oqtw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790615618; x=1791220418; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q5c/Mh1KIdWOYND7CZ3pWQaMV70vYz5Z5e9OrbANVNM=;
        b=flHk9qMxws8BpGNxe99yBwCyCt0iJ3t7a+XwpghsDjRy/ChGrUq3GFyRhegg0jb8YP
         bffYhKvJTRFqGvkvTeV8W/nYp+N0IWd7Ex6fb06vSwaexFcsmkSEfDwWKOp3Gn9vfZvZ
         cnAZ1KxsS3WxZP7MSv0A/bwnAKw6zgd9jmf4Uc2FW7U85zO4lqGZt2aKGRZm9p+gSMwS
         373LgPXWI1zXqotQ44BksJslJ0ECj8//Ux9qQPDSQ+jQWD7UhiOtWZhSpRVH2CCialVl
         XrGegC7phKS9rE9Gfv9xlCa60nS2leR+0cOXgh8ZkXW5ezc8jfGjU7vM9X0cHgJdikc5
         Vqcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790615618; x=1791220418;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q5c/Mh1KIdWOYND7CZ3pWQaMV70vYz5Z5e9OrbANVNM=;
        b=zLnoIyn7fiQW1ikZ0mcQ1u8u7fFjGBMeuzt09J21D7TkhQ7Wx9A3QhUEdBf0+Wfa5v
         tMXLEbh7gO67DwXM1syElGpXcIaJaVtZMSi89QkWdFsOlvLmxQSdtHFBqXU1WouJ90jX
         hl+SkusVK2ZM4O3Zheva4V5r0uLZkhoUbqh0mSzj5vo4VGODvnrL5RT9IafbxeOzRvXj
         sBjZqvE5hAV53WodqzyhPDbwy6743XBYBaWQ9w5RXm2DCNgf9WFyJj92+ctWEaq5cOTJ
         RVJhTyG5bQwGEKjxXqZYCmMjW1DBnwLprkIQwSsft6m4ZC6G5dryKnQPtupvPlh8yd8u
         +Q0Q==
X-Gm-Message-State: AFuF++n3cHtSad5jl/db5Ma4oOXRMupf4Dv7zxFeNiUoQrVYVqJ4E97/
	p6hGwVSEvNArZpVd4NtJjDZeZUcEath7TZJPTQEmAzAjv0bbqyn64n1S6VjcngXD/eJUAFTArii
	1l2x+03zY2d2pzX2rHTRvvYSEwmS5HRxv1K/S
X-Gm-Gg: AYBFou0exbJWCDhsJPnWZ2ZYx4bMQC3WjFXdtpIN4qdY4WFYJ/Fisti5pXvNF1/yvlC
	w6kehGmBTzChm1bOEpnafT2DJqxbFfxCl+E2+nJECd49JmbeBjTJkd6BFOJDVW4xH8wuzVdmB8Y
	m+8ma01KUFRrcPiZgKBiPezJFKF7+yGK/4Maprl2drhkFzDrVRiON4x+7su0YChjqU0iNH3zpQX
	C2ZqrID35Uzzrdak0dmE/sW7DHz0o4W0LbRFELseHJY5nGpN78e79F3rSdIOBEqJ1bhEMrVIJiK
	T4rWm32Nd/yXPxjWA4mar1L/oAWfbeTuifCHDFPq/Q1yJ0TA2RNgKx2w
X-Received: by 2002:a17:907:c60d:20b0:c2d:b9b4:f4d1 with SMTP id
 a640c23a62f3a-c2db9b4f61bmr347612266b.6.1790615618145; Mon, 28 Sep 2026
 10:13:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917222015.61053-1-nkirkland2304@gmail.com> <CACnqm79AfmdHbJZ-hDNsrbeDBXVBuq2A8uwdPKzKu+W7YzrJDg@mail.gmail.com>
In-Reply-To: <CACnqm79AfmdHbJZ-hDNsrbeDBXVBuq2A8uwdPKzKu+W7YzrJDg@mail.gmail.com>
From: Nigel Kirkland <nkirkland2304@gmail.com>
Date: Mon, 28 Sep 2026 10:13:23 -0700
X-Gm-Features: AclHuK8V62zx36PwIWGl-BgbKMrirYwLnGoCHDJTitYVnon-txvDDFPZ_w4EhsE
Message-ID: <CACnqm7_grKUi9sq4a+p3ODYSqqboZGHYtxSmXzjOzNEwoqnBLw@mail.gmail.com>
Subject: Re: [PATCH v4 00/14] Update lpfc to revision 15.0.0.1
To: linux-scsi@vger.kernel.org, nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 19, 2026 at 12:45=E2=80=AFAM Nigel Kirkland <nkirkland2304@gmai=
l.com> wrote:
>
> On Thu, Sep 17, 2026 at 2:57=E2=80=AFPM Nigel Kirkland <nkirkland2304@gma=
il.com> wrote:
> >
> > Update lpfc to revision 15.0.0.1
> >
> > This patch set contains bug fixes related to cleanup handling in both
> > normal and error paths, discovery rework for large SAN configurations, =
and
> > refactoring of duplicate code.
> >
> > The patches were cut against Martin's 7.4/scsi-queue tree.
> >
> > Nigel Kirkland (14):
> >   lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
> >   lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not s=
et
> >   lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted =
cmd
> >   lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC erro=
r
> >   lpfc: Add handling for when PLOGI or PRLI is dropped during link fail=
ure
> >   lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery se=
quence
> >   lpfc: Rework I/O flush ordering when unloading driver
> >   lpfc: Improve PLOGI retry handling for large SAN configurations
> >   lpfc: Send inhibited ABORT_WQE when PLOGI CQE SEQUENCE_TMO is receive=
d
> >   lpfc: Remove slowpath cqe process limiter in slow ring event handler
> >   lpfc: Put iocbq on phba->txq when ELS WQ is full or ELS SGL unavailab=
le
> >   lpfc: Update ELS ACC logging for diagnostic troubleshooting
> >   lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handle=
r
> >   lpfc: Update lpfc version to 15.0.0.1
> >
>
> Preliminary response regarding Sashiko findings.
>
> Patch #6: Sashiko pointed out 2 [high] issues that appear valid in
> theory, but appear
> highly improbably in the real world. We are reviewing these findings
> and whether to
> address in a v5 drop or a future patch set.
>
> Patch #8: Sashiko pointed out 1 [medium] and 1 [high] issue. We are
> evaluating if
> these are a real concern.
>
> Patch #9: Sashiko pointed out 2 [high] issues. We are evaluating if
> these are a real
> concern.
>
> Patch #10: Sashiko pointed out 1 [high] issue. Whilst valid in theory,
> the patch eliminates
> a real world "silent-drop/delayed-reschedule" bug. Removal of the
> maximum processing
> count does introduce a theoretical concern in the event of a sustained
> flood of slow
> path CQEs. However, the original issue that prompted addition of the
> processing limit was
> related to loopback testing. Loopback processing was subsequently
> moved away from the
> slow path, eliminating that as a producer. Removal of the processing
> limit was overlooked at
> that time.
>
> Patch #11: Sashiko pointed out 1 [medium] issue. We are reviewing
> these findings to
> determine whether this should be addressed in a v5 patch set.
>
> Patch #12: Sashiko pointed out 1 [high] theoretical concern, but in
> our analysis the race is
> unlikely. If seen, the worst case outcome appears to be reporting of
> an incorrect cmd code
> value in log message 1027.  Closing this theoretical window is
> something we plan to address
> in a future patch set.
>
> In summary: Analysis of the findings is ongoing with a complete
> response anticipated
> in a few days.
>

Out of an abundance of caution, we will be submitting a v5 patch set.

>
> >  drivers/scsi/lpfc/lpfc_bsg.c       |   7 +-
> >  drivers/scsi/lpfc/lpfc_crtn.h      |  12 +-
> >  drivers/scsi/lpfc/lpfc_ct.c        |  23 +-
> >  drivers/scsi/lpfc/lpfc_disc.h      |   5 +-
> >  drivers/scsi/lpfc/lpfc_els.c       | 503 ++++++++++++++++++++++-------
> >  drivers/scsi/lpfc/lpfc_hbadisc.c   | 130 ++++----
> >  drivers/scsi/lpfc/lpfc_init.c      |  21 +-
> >  drivers/scsi/lpfc/lpfc_nportdisc.c | 100 +++++-
> >  drivers/scsi/lpfc/lpfc_nvme.c      |   2 +-
> >  drivers/scsi/lpfc/lpfc_scsi.c      |   2 +-
> >  drivers/scsi/lpfc/lpfc_sli.c       | 227 ++++++++++---
> >  drivers/scsi/lpfc/lpfc_sli.h       |  18 ++
> >  drivers/scsi/lpfc/lpfc_version.h   |   2 +-
> >  13 files changed, 812 insertions(+), 240 deletions(-)
> >
> > --
> > 2.38.0
> >
