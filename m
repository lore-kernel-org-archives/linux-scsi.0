Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCC12D7380
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2026 22:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786488015; cv=pass; b=tfjTrHzbpzsynItZpE03U3lSYBFY8gVEGICe7OkK+U3jS7uOHEcJvOAyD7Z0Yz6mfJUsZvmkJuVrQlyIeOAQXGw9aYscToQqE1iO5xoxOh+7ePOzrd9rPae/okMUjFYz4y/mSOdm1ELYeQUogRfz8m7r8b4w7uC3OpvKB9Mnpgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786488015; c=relaxed/simple;
	bh=lQ2PDMxZqNNJsyagA2l0ugPQbR15LKHgNZi2teCjjqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N/s5q9iJWU7lEFZXJSEl0BeNIL0pqueIy8p6cLvm1K2IQrVkebYOggdk4rAFsO4GdQ1IZei3JevsN+qGN70AbWqVi/kCtZqmarj8nhMg1joOPStSUrAl2u7UBZqlXws54yvHVQwj4yX93xIqj/eQaQnT/l5QTFC1IrNOXVdu9S0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=Xj3dbLsj; arc=pass smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Xj3dbLsj"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-39c7ef2b1e2so2317171fa.1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2026 15:40:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786488011; cv=none;
        d=google.com; s=arc-20260327;
        b=YuZSPPIPd0/bREokez8wLJ1GSx9Yh6jf63WNxNm9oW8C1lMY2gMTCrwGi2AYMPmPVM
         InMET5+RsJJVHyfrht9pWPuVczPang2AJMjUzvOIYGmjrLEBo21gZdpmlO8ifg2kdmwk
         MI39BTNoRKt2ESV8DHhN2OX7/ubllv77RSCrOXizDv+TUrSnnPz2eyy23yJDvOoUNWIi
         n+tjUZr+IjQF2y/uhzXwGXjsqFg4d0g1m/hjVF+z9MU+v4hwAUQ3pjL0mkbJctVCsFiE
         1GkAkmuN71//xyIm0xvqAuANYUSs+4BlorMYQr5yV0YjM2WmTOevgU+uRlWxxiWHSQyu
         oLRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZMSvgy6lM/O6XOMnt+YhefRsK1fTzAbWeXvMjkG/I8Q=;
        fh=bPqnI7NZgkwSWSGgGmPSHyaZErNEPE0D1fdj2e1Stg8=;
        b=ObUMdrveNtwaEFYgYC+yyd9KVdhPFi0PhTtPVxMSSJ2frJtSI7q6NPGO72dxOilvVK
         g0UQ3VYMel8QV7TpClCi5u4NVAHlh7QyBJpPy+y8p4aOKhLwCx9mMq3PqjJAvat7hDv2
         /pBje6NOrj+AeWPnkkgYLWYcbGSJmjrSJSC7JEv9JnHueDknHKR0n7o+Ush7CSQ/smbq
         AJsliphXXpLi7+3eune1FKIokfi9Dv1HsJNodgBSJ/THnMcfROk74qpoWEzVpyqxt8Yc
         66jD1VhY5j8e/b924VtKUMPmu4QUJfh7cdnqwspjR57M5Gvn2vRA6xruATZbPBrCIznP
         3prA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1786488011; x=1787092811; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZMSvgy6lM/O6XOMnt+YhefRsK1fTzAbWeXvMjkG/I8Q=;
        b=Xj3dbLsj45VnkD+Z46qLgj0/xPxo/cIVVj0JezlEwJOxG9uJuMu1cVwbaUznuE9i/I
         MtRdGu7kJNUPmMXp+6dk3U2dKKPE2npIbqxz4VdoIfhzam4sOBX7M3diikeoarLCmDHD
         Ajsavv/CmspwdviWUPSalPc2eDmj130ahWVR2QjCwdGXURc9BxG8wr+Y1OpMvGQM+Yj+
         jqMn1kWYgz3q7dr3ml/g+hdBW5pg9vftzttdAU7qBbbWF9Rw5xjd2kgfAbCsc87rJgh1
         2oa5bnV5TDH0rFMtAqyMHnAL+17UY68cOfcsWA3A6lDasF+sp1SC4IGZuLKyoHZ/sEx/
         QNuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786488011; x=1787092811;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZMSvgy6lM/O6XOMnt+YhefRsK1fTzAbWeXvMjkG/I8Q=;
        b=k5rieHlFf18lb9XBM4CYmEZNx2KYHSjNxeB1yZFjBPC78QoewE87e1IjbIzjCQRldU
         ME69QHI06kJ+0DWxcMjeWYRd8VZdPdV95xCsDBriBr8xyuUXztiAw9EObw9yOI9OO2ts
         /lNXiFOSzfIEI5acQe24nXr2wIdH78zV43VX91MR2zgFatd0SBFosyD4hLw5TQaVu7AW
         AnaGd2bIUbmH0AGF+fV+F+//wjP93NIK+5BSDD+PNoDH0t4IbJak7+yPAXyTb9du8H96
         wKS6e7MKSlH7bjkoP1qndSmSoz2uaJQQjh/PUnrTXDEqYXzq/bZ+fG8l+binzqi3A1es
         XHvQ==
X-Forwarded-Encrypted: i=1; AHgh+RrwKD/mD3pBkXYcnDt01CgqyJrL6Rd0YG/X0Qa+By/rEIJvygqPwkfL5eyCtPKgG6BwrcM070Ebi5KL@vger.kernel.org
X-Gm-Message-State: AOJu0YxfKwg+RsWuVhdZyrJFqPDnwQ3mu2wvD5SraZe02rCjWtc8bfym
	A6Y7dX4pXrikuEbSVRysaL1E4ew2LPBE/q3jyIkaw7sNJVPl27diL3bt6gyRbKK7pOc1EdgKkLo
	0sB+Qq2vYS346v5srv3cPMOJsDXoJiWIVYgBP1GB45g==
X-Gm-Gg: AR+sD12Dg4Lp0YXlsNIWmkiqVZxxTtl1dX1iN5ItadzbvffPp7T0qlmA8SLvtCzEWLN
	Y1nbjcnKA/p29SIsIf+VYRDndTDCONatZJXCx9eFEIiQUd2oNRztWeKZCgSjJAWAl2yRRZ052+s
	HKmAIMY3KJlLSuSAtb7qInA6SkH7qvl6UlhXsCAFiCSx90GSBMeU7yUDb/M6xZ32aiHVS/Cg5bk
	30WfI3Pn6RFzr+/bbZXZMOurMxV5aJuwHmbsDXz/Pu+z1Dei8sQCWLNO23DNe08YWEfLsT2nqzm
	hcqfKiFIBUb45rI0ZbTh2pGOcrImpbweJfjCYdFUw3055xzdRyE9nRjXk2SrOIZtRDeFz5K9in9
	OWEqMZnLougSXx5e1gLYDTHQU2qseFAP/bRbNSn+P6sa4vMbq4XZ5lqtEyX6Z
X-Received: by 2002:a2e:be27:0:b0:39c:6d3a:2dc6 with SMTP id
 38308e7fff4ca-3a10d57f055mr51371fa.15.1786488011142; Tue, 11 Aug 2026
 15:40:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715135642.456578-1-haris.iqbal@ionos.com> <CAJpMwyjQc_mimuBjUugbBJsZio2vZQCD-Ay966o2jWtpTt2MEg@mail.gmail.com>
In-Reply-To: <CAJpMwyjQc_mimuBjUugbBJsZio2vZQCD-Ay966o2jWtpTt2MEg@mail.gmail.com>
From: Haris Iqbal <haris.iqbal@cloud.ionos.com>
Date: Wed, 12 Aug 2026 00:40:00 +0200
X-Gm-Features: AUfX_mwxopAEgiB18-Ojw-VQM4RTCyydiWxFsI4oPhRC1ThOaktpDL3qu1EnJm8
Message-ID: <CAJpMwyhBuH4UdMzib7SaDhYE5j=xsiV3M4hf4qYdzsiZvRZuPA@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: don't post task management replies to
 io_uring poll queues
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 3:46=E2=80=AFPM Haris Iqbal <haris.iqbal@cloud.iono=
s.com> wrote:
>
> On Wed, Jul 15, 2026 at 3:56=E2=80=AFPM Md Haris Iqbal <haris.iqbal@ionos=
.com> wrote:
> >
> > mpt3sas_scsih_issue_tm() posts a task management (TM) request to the
> > reply queue given by @msix_task. For ABORT_TASK and the broadcast
> > primitive QUERY_TASK/ABORT_TASK paths, @msix_task is the msix_io of the
> > command being managed; for an io_uring polled (RWF_HIPRI) command that =
is
> > an io_uring poll reply queue (index >=3D ioc->iopoll_q_start_index).
> >
> > io_uring poll queues have no MSI-X interrupt registered and are drained
> > only by mpt3sas_blk_mq_poll(), which the block layer calls to complete
> > polled block I/O. A task management request is not a block layer reques=
t,
> > so nothing polls on its behalf: the reply is posted to a queue that is
> > never serviced during the wait, tm_cmds.done is never completed, and th=
e
> > TM times out even though the controller is healthy. The abort then
> > escalates to a controller reset that was not needed.
> >
> > Post TM replies to reply queue 0 whenever the selected reply queue is a=
n
> > io_uring poll queue; reply queue 0 is always interrupt-serviced. When
> > poll queues are disabled, iopoll_q_start_index equals reply_queue_count=
,
> > so the check is a no-op and behaviour is unchanged.
> >
> > Reachable only when the driver is loaded with poll_queues > 0 and an
> > io_uring polled workload issues I/O that later times out and is aborted=
.
> >
> > Fixes: 432bc7caef4e ("scsi: mpt3sas: Add io_uring iopoll support")
> > Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
> > ---
> > Found by code inspection while auditing the task-management reply path.
> > Posting for review of the analysis.
>
> Gentle ping.

Yet another ping!

>
> >
> >  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sa=
s/mpt3sas_scsih.c
> > index 12caffeed3a0..572ec1787e10 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > @@ -3186,6 +3186,16 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *i=
oc, u16 handle, uint channel,
> >         int_to_scsilun(lun, (struct scsi_lun *)mpi_request->LUN);
> >         mpt3sas_scsih_set_tm_flag(ioc, handle);
> >         init_completion(&ioc->tm_cmds.done);
> > +       /*
> > +        * A task management reply must be posted to an interrupt-servi=
ced
> > +        * reply queue. If the associated command was submitted on an i=
o_uring
> > +        * poll queue, that queue has no MSI-X interrupt and is drained=
 only by
> > +        * mpt3sas_blk_mq_poll(); a task management request is not a bl=
ock layer
> > +        * request, so nothing would process its reply and the command =
would
> > +        * time out. Fall back to reply queue 0 in that case.
> > +        */
> > +       if (msix_task >=3D ioc->iopoll_q_start_index)
> > +               msix_task =3D 0;
> >         ioc->put_smid_hi_priority(ioc, smid, msix_task);
> >         wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
> >         if (!(ioc->tm_cmds.status & MPT3_CMD_COMPLETE)) {
> > --
> > 2.43.0
> >
>
>
> --
>
> Regards
> -Haris
