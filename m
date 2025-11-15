Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CFF247281
	for <linux-scsi@vger.kernel.org>; Sat, 15 Nov 2025 13:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763214460; cv=none; b=ePaUgJGOipL1RXnlAQIUTUuheVtqpDZCB6QhRX4CvZ0L95vQDqR7IDosQsKirKwIOmTeegkJHRBK85/pE8m4/NekuNycLo7a4+sPL1RBkTxSYUkV2JhS80T2fwFHs9/CcAKnxxmEvI9wkITIgTsjECJsAcqtQDyIVtNj9O052XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763214460; c=relaxed/simple;
	bh=EVgP9ExVkqCUenc9FH0HcoIhOGOFEP8rgqi5TP+s/v8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ni/rh1rhsJVQbe2YxB1sleGaIdAi6/f3U8511lgn8SGbFTB1RVEJFBd2SSYCfYL8SCePE1zbf46hXhwh0GiPY4NCfCmihDuWnc9YSK8y+TqCNNfX/kxn0TYl/FDYHnvzMbwLBHnizSObvrf75vXKF/+TlyN0IrUt2ynMEK0b2II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lLOd4hoj; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lLOd4hoj"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-5dfc6be7df3so632866137.0
        for <linux-scsi@vger.kernel.org>; Sat, 15 Nov 2025 05:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763214458; x=1763819258; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m/gXBXAgqzLo5+JUCiKb5ya5AjR/z9Ngvy4LoMnAnlc=;
        b=lLOd4hojEvcrFFbmawAuxbvykKqsAnlaoevxUl3xs/ka2fBVvOCYTENIp8YvAKlDdx
         LyMYwjSijDfH7tMjca/xXTuQdsmTQ5SD2Khxt/Xa1La+kC7pt/KGo1s+kQJZzRTCirQw
         /eRLy/had85A+s21PSzZ6tdncuCnTe6mHgknFR5DQNC/vb/KdtuPn1tPA5jFO7cdVmps
         9DnwtGKqxwsm6M0qTcBGTZWNkKjlp8MLkLK1z6CZ0HFjFDZsP05qRR7voEtaILkErTnj
         0s8m0SvkOT/9npcaK75M7BJ1aNrGz6Na4AyND8btMMw+h+MXX0Ek1h4vASmGPR4ZRy2R
         c48A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763214458; x=1763819258;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/gXBXAgqzLo5+JUCiKb5ya5AjR/z9Ngvy4LoMnAnlc=;
        b=bDFw/17fGgk+Rdatc55SxMmRwwVLpoi9ZIZwj/SHapHp9OOu6ucDZOJad0Akdia11f
         BJV1SyaONTuhi3uqHWA7WlvU7eOu0HNwgPzNRXPA2vWLcR10JPu+OZ+0WPw4A5NrdKJY
         nFP5JmL3fpZU+J043UDS2QOJ79Op4xX/XtyPqRMCMXddXvzW3rJSP+PuicHMIZmCPgJt
         CWzxLvl4HxVcDHimnHcYCwg8c1UP2vhoRagdMM/a5lwqNUeB4sqNmbNGAd8j9KKtyICE
         WJa+frl2Qp74UJr4meXgUCLGntEBCSKHP/oTlXu3gwQJYEWs47kI7D+RgTxGePsnP95W
         JzLw==
X-Forwarded-Encrypted: i=1; AJvYcCVtNhAx6L7mOEjAq1NlqYnZLqxJKjHVHrc4o6VYCO7T7LXd4iB04wPIKTl1aiBOTGxU/GkaZV4HxNlw@vger.kernel.org
X-Gm-Message-State: AOJu0YzFDlAJZUaS/iAbrodOasZjWPYcYEFlfc341UnfmvNkEcDw/bOO
	ohmFJsnFwzB8WmgsIQPdeI5MDUkwD3h+4oQ1VqqOCsTbx+3JIjicxsTryz1Aa4iJc2sB+Bz+UFY
	ruXhuBLUhV+oOmyvYChz5HosLSVN9qk8=
X-Gm-Gg: ASbGncv6kkD6wzPnME3xPxu5f7D4hzmU0Q1uPu7WvGWwsU+p3j4392C69O+MxlCBmYM
	O8MokE8p60HQ2R13t8sbIlWcJ37ihXDyG/l0y974IucK5OPS8c3opcEXChvsExWfN9PsYu44SO4
	6lRY918ijKQZV6jxr+RFpKjaitph3lXgEC5qRpB3EZ7y3gNZdSZ7qB8c7yneuTNKE4uVdS5mBxW
	CZboqux7428WuAeqfFXJzQnc8xd9hfC/HULJEQWKNDKm68ykfL4aLyeK0471MuKL1nlFhwkQjBq
	7gYZTZ/mRQMkOz1DsoavEjtS5b5UQY0Z3CSc0fvjBI83H9U=
X-Google-Smtp-Source: AGHT+IHWKU/4RdU4gvqjTx7OcBVkWnGkX4o4XGexGqQflsQR7RNiXUTmBdhLzKSVU5OxwWlzQHQEcUFRCkdt/uYGNiY=
X-Received: by 2002:a05:6102:15c6:b0:5dd:b2ee:c6ff with SMTP id
 ada2fe7eead31-5dfc554efc6mr1692122137.8.1763214457248; Sat, 15 Nov 2025
 05:47:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251028145534.95457-1-kubik.bartlomiej@gmail.com> <562fa035-c732-4bfc-8439-2279d029f72a@acm.org>
In-Reply-To: <562fa035-c732-4bfc-8439-2279d029f72a@acm.org>
From: =?UTF-8?Q?Bart=C5=82omiej_Kubik?= <kubik.bartlomiej@gmail.com>
Date: Sat, 15 Nov 2025 14:47:26 +0100
X-Gm-Features: AWmQ_bmOozScg0utOIPVx1HD9iuU9Npr5RrozIq1rF3X8kP6d0exCiltHGGVvX0
Message-ID: <CAPqLRf1-zb3v2hMDexM4zCtAtr+yzwQdeSrkzssfo0rkmLo=mA@mail.gmail.com>
Subject: Re: [PATCH RFT v2] driver/scsi/mpi3mr: Fix build warning for mpi3mr_start_watchdog
To: Bart Van Assche <bvanassche@acm.org>
Cc: sathya.prakash@broadcom.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com, 
	martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	linux-scsi@vger.kernel.org, skhan@linuxfoundation.org, khalid@kernel.org, 
	david.hunter.linux@gmail.com, linux-kernel-mentees@lists.linuxfoundation.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Thanks for your time and review.

On Wed, 12 Nov 2025 at 21:55, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 10/28/25 7:55 AM, Bartlomiej Kubik wrote:
> > -     char watchdog_work_q_name[50];
> > +     char watchdog_work_q_name[MPI3MR_WATCHDOG_NAME_LENGTH];
>
>  From include/linux/workqueue.h:
>
>         WQ_NAME_LEN             = 32,
>
>         char                    name[WQ_NAME_LEN]; /* I: workqueue name */
>
> In other words, increasing the workqueue name length beyond 32
> characters is not useful because it will get truncated to 32 characters
> anyway. The workqueue implementation complains about longer names as one
> can see in kernel/workqueue.c:
>
>         if (name_len >= WQ_NAME_LEN)
>                 pr_warn_once("workqueue: name exceeds WQ_NAME_LEN. Truncating to: %s\n",
>                              wq->name);
>

Yes. My mistake: I did not see this before. I walked through the path
where watchdog_work_q_name
is used, but I did not go too deep. I found this when building the
kernel and GCC returned a warning.
I saw a couple of months ago that the watchdog_work_q_name size was
increased from 20 to 50,
and MPI3MR_NAME_LENGTH was also changed from 32 to 64.

> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > index 8fe6e0bf342e..18b176e358c5 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > @@ -2879,8 +2879,7 @@ void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrioc)
> >
> >       INIT_DELAYED_WORK(&mrioc->watchdog_work, mpi3mr_watchdog_work);
> >       snprintf(mrioc->watchdog_work_q_name,
> > -         sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
> > -         mrioc->id);
> > +         sizeof(mrioc->watchdog_work_q_name), "watchdog_%s", mrioc->name);
> >       mrioc->watchdog_work_q = alloc_ordered_workqueue(
> >               "%s", WQ_MEM_RECLAIM, mrioc->watchdog_work_q_name);
> >       if (!mrioc->watchdog_work_q) {
> Leaving out mrioc->id from the workqueue name seems like an unacceptable
> behavior change to me.

Add twice the same ID one after one. Is it not a mistake ??
If mrioc->name has that same ID and the end.

sprintf(mrioc->name, "%s%d", mrioc->driver_name, mrioc->id)

We build watchdog_work_q_name from that and add twice the same ID.
At the end If I correct see watchdog_work_q_name will looks like
watchdog_mpi3mr11



> Please consider replacing the proposed changed with this untested patch:
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 6742684e2990..050dcf111a4c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -1076,7 +1076,6 @@ struct scmd_priv {
>    * @fwevt_worker_thread: Firmware event worker thread
>    * @fwevt_lock: Firmware event lock
>    * @fwevt_list: Firmware event list
> - * @watchdog_work_q_name: Fault watchdog worker thread name
>    * @watchdog_work_q: Fault watchdog worker thread
>    * @watchdog_work: Fault watchdog work
>    * @watchdog_lock: Fault watchdog lock
> @@ -1265,7 +1264,6 @@ struct mpi3mr_ioc {
>         spinlock_t fwevt_lock;
>         struct list_head fwevt_list;
>
> -       char watchdog_work_q_name[50];
>         struct workqueue_struct *watchdog_work_q;
>         struct delayed_work watchdog_work;
>         spinlock_t watchdog_lock;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 8fe6e0bf342e..b564fe5980a6 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -2878,11 +2878,8 @@ void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrioc)
>                 return;
>
>         INIT_DELAYED_WORK(&mrioc->watchdog_work, mpi3mr_watchdog_work);
> -       snprintf(mrioc->watchdog_work_q_name,
> -           sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
> -           mrioc->id);
>         mrioc->watchdog_work_q = alloc_ordered_workqueue(
> -               "%s", WQ_MEM_RECLAIM, mrioc->watchdog_work_q_name);
> +               "watchdog_%s%d", WQ_MEM_RECLAIM, mrioc->name, mrioc->id);
>         if (!mrioc->watchdog_work_q) {
>                 ioc_err(mrioc, "%s: failed (line=%d)\n", __func__, __LINE__);
>                 return;
>
> Thanks,
>
> Bart.
