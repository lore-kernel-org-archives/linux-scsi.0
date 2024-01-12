Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1559415E9C
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2024 19:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZlF2Qh1k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705088107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jK8NzPdFIJN1xPcLfAXJ5ClxrhUaaRbp5aXU0g0i+6A=;
	b=ZlF2Qh1kGgzT/fqL2SvQ7CWFaOuB82x7Kyo00t5BAkMzhWJyOhOZOoPWQZaVZpY0LScTtv
	eVZgznnIc/5uX28xSVrZaW5CQjAqi7l79tGHOnY1cyG98JG932pJTCRFKk7ZfZUqHWaPFW
	b/RyH/go39krz438CpyL6RO1cvwB2y4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-yteGE78wOAmZU0ebGi9sQg-1; Fri, 12 Jan 2024 14:35:05 -0500
X-MC-Unique: yteGE78wOAmZU0ebGi9sQg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3368698efbdso3574333f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2024 11:35:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705088104; x=1705692904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jK8NzPdFIJN1xPcLfAXJ5ClxrhUaaRbp5aXU0g0i+6A=;
        b=j7D5yDDoMLjFApb/YNBCgL2N0vO+z2Qk0NQH1TOmbYFX3LIOzhydlJTTpA4HtcWC8a
         kTOLFecZrsLv31/7xWgsQKpCH0x+IaiyB893rrLXZAE4KgJrfUkGuirdkCQ4F2fpKryC
         q5Q2zfT88NyO317f2Dd2rpgr7Hdua5VjonoNPH+Juy/IIvajR5Uw8nEWOMyen+mjRJp3
         I+qWwJSGuE4mfcOTeyIDWjQ/5XshNraZGJtmFr+XDM8qD6T1R2CyYlidd3pPLReFY+9b
         sVwWJMTzNaNGcEv26K6Lr8SSLcrdn8go5/BLENVFevWGFEJu726aRU4PUIKU758oMUxM
         Rv2g==
X-Gm-Message-State: AOJu0Yzgn1Bs2HSIhQ3htdycuQJfLljpcnj+IdL2eOBsi4DYA06uG42Z
	fRFi1kVNtEQN4ggJ78U45C7SHsIciJMSeHOFwRaJx6hB9o2GgPJGdmioozkO5eDoKHTe0Jqglhx
	d+qoZ9I2ByBL4OjS5Gj8Yl06ECs79h5QvHasADRcNtJIB6A==
X-Received: by 2002:a05:6000:4023:b0:337:8f4f:9071 with SMTP id cp35-20020a056000402300b003378f4f9071mr1550052wrb.25.1705088104217;
        Fri, 12 Jan 2024 11:35:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGuMgCsBG6CADTdW9RWgxO4LHQuGPmeCuEPXaSjywG+I++5Se+YnBuzBrVRut5mDutQlzWUZLophhQE5Ukb65I=
X-Received: by 2002:a05:6000:4023:b0:337:8f4f:9071 with SMTP id
 cp35-20020a056000402300b003378f4f9071mr1550046wrb.25.1705088103909; Fri, 12
 Jan 2024 11:35:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240112070000.4161982-1-ming.lei@redhat.com> <ccbc1e9b-ca63-415c-9b83-225d4108021a@suse.de>
 <ZaEz066MVkijH68c@fedora>
In-Reply-To: <ZaEz066MVkijH68c@fedora>
From: Ewan Milne <emilne@redhat.com>
Date: Fri, 12 Jan 2024 14:34:52 -0500
Message-ID: <CAGtn9r=Qko22+9Zxg8BnaAMtfEH_WYpkE7mDBmKWSdcm98Ui1Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: move scsi_host_busy() out of host lock for
 waking up EH handler
To: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 12, 2024 at 7:43=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Fri, Jan 12, 2024 at 12:12:57PM +0100, Hannes Reinecke wrote:
> > On 1/12/24 08:00, Ming Lei wrote:
> > > Inside scsi_eh_wakeup(), scsi_host_busy() is called & checked with ho=
st lock
> > > every time for deciding if error handler kthread needs to be waken up=
.
> > >
> > > This way can be too heavy in case of recovery, such as:
> > >
> > > - N hardware queues
> > > - queue depth is M for each hardware queue
> > > - each scsi_host_busy() iterates over (N * M) tag/requests
> > >
> > > If recovery is triggered in case that all requests are in-flight, eac=
h
> > > scsi_eh_wakeup() is strictly serialized, when scsi_eh_wakeup() is cal=
led
> > > for the last in-flight request, scsi_host_busy() has been run for (N =
* M - 1)
> > > times, and request has been iterated for (N*M - 1) * (N * M) times.
> > >
> > > If both N and M are big enough, hard lockup can be triggered on acqui=
ring
> > > host lock, and it is observed on mpi3mr(128 hw queues, queue depth 81=
69).
> > >
> > > Fix the issue by calling scsi_host_busy() outside host lock, and we
> > > don't need host lock for getting busy count because host lock never
> > > covers that.
> > >
> > Can you share details for the hard lockup?
> > I do agree that scsi_host_busy() is an expensive operation, so it
> > might not be ideal to call it under a spin lock.
> > But I wonder where the lockup comes in here.
> > Care to explain?
>
> Recovery happens when there is N * M inflight requests, then scsi_dec_hos=
t_busy()
> can be called for each inflight request/scmnd from irq context.
>
> host lock serializes every scsi_eh_wakeup().
>
> Given each hardware queue has its own irq handler, so there could be one
> request, scsi_dec_host_busy() is called and the host lock is spinned unti=
l
> it is released from scsi_dec_host_busy() for all requests from all other
> hardware queues.
>
> The spin time can be long enough to trigger the hard lockup if N and M
> is big enough, and the total wait time can be:
>
>         (N - 1) * M * time_taken_in_scsi_host_busy().
>
> Meantime the same story happens on scsi_eh_inc_host_failed() which is
> called from softirq context, so host lock spin can be much more worse.
>
> It is observed on mpi3mr with 128(N) hw queues and 8169(M) queue depth.
>
> >
> > And if it leads to a lockup, aren't other instances calling scsi_host_b=
usy()
> > under a spinlock affected, as well?
>
> It is only possible when it is called in per-command situation.
>
>
> Thanks,
> Ming
>

I can't see why this wouldn't work, or cause a problem with a lost wakeup,
but the cost of iterating to obtain the host_busy value is still being paid=
,
just outside the host_lock.  If this has triggered a hard lockup, should
we revisit the algorithm, e.g. are we still delaying EH wakeup for a notice=
able
amount of time?  O(n^2) algorithms in the kernel don't seem like the best i=
dea.

In any case...
Reviewed-by: Ewan D. Milne <emilne@redhat.com>

-Ewan

