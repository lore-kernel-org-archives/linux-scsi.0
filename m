Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AEA382293
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 17:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779126844; cv=pass; b=X7RQgnqengab/Q9YKh5jaUdTnUZSBHYjn0MGIXCpY/YBmwpXeUoq9yI+6IrdUlhlUxD4eTH3fll9775ZoWESgrcoN01PagiRMpI6YIwzTEkKv4ecdEYtLp2vMtHz6RiqiTtDErAXZeVypCsrzfIY9XbQ3+0RvBZyTG1LKkx9U3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779126844; c=relaxed/simple;
	bh=823+5xroDvlRIXOQhdz6KcuCK1oBwxslunREjOMwKyc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V+CYBZmrZ+mdZeIZA9pcbWi9O3XJD5M4U5G5ywWla4weRugmVnH/Roq3+KcLDRzCMfcZpXBSe3zZLNPONZGVGuAqNTpY+yz3427IEQg3li/ydI+HQ/cs8Au0yfGH9YTRvXBkfNmCUAqm7fhnPUQmrpbvTDxaTh18QkumvT6DDX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ahS4f8VF; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=d35PSWMA; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ahS4f8VF";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="d35PSWMA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779126841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GqfThZKH83Pq49kMDzP4xulclp1+rWsSNmFmdp9OqbU=;
	b=ahS4f8VFE/IIxkk0QAY6ZvLhutGsM6oqHCIfnRWaU+5vaePGb/s3diA2WIVbW8KnjBqyJw
	qRprhB/YjpBoC0fTWrZniyvnLu74S94+aWtt1ZpALUZbcMOHifF7+0c2t34fCdgThf3wIF
	ULpXczNv2AHzyZV8Co7kRiu/PL2MF1I=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-BZk5QqnNPMCThNE2mIMK3Q-1; Mon, 18 May 2026 13:54:00 -0400
X-MC-Unique: BZk5QqnNPMCThNE2mIMK3Q-1
X-Mimecast-MFC-AGG-ID: BZk5QqnNPMCThNE2mIMK3Q_1779126839
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-95ce07ddc14so4123889241.2
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 10:54:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779126839; cv=none;
        d=google.com; s=arc-20240605;
        b=IqB0hVWUGZzGIPIcin9bR1J2Mv/Xl9OHZvfntojufJBhpI+2C7SeE6cYLdvkZuwPWR
         Yh5PMwfhrCEEV3WVsMAmBJfrqedoUi59LXW/XVEVrLdZmhcUFX5Re8qCU7ztiWmsZo8T
         Tj6oFxjFa5LSz0mPxyRPPJJXJu/q32GDXKZkUr2r5dSA0obWpX1Oo1THRKOC4LBQOf2V
         nr9a0mEs3UipkRrxNSQ7iBSpnGdjDI2G6aYRMmhB2XuafFCNZcMrUwQSddMFo00ElDU5
         KJpVrRxEYgkTiaiJhbrDn7lsqGmHOsoKfpIGlvgJOBVV6Qr8tjeLSCicIG8klTM/D8Qp
         0kAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GqfThZKH83Pq49kMDzP4xulclp1+rWsSNmFmdp9OqbU=;
        fh=tScm2eAN0HS9mCdl3iBYquTZsazadfL7sZDsu6+Quyk=;
        b=YlhAj8hsfo2sA54+IS5v+OGR+MLIAzP12zNMfoCZIf+nqc+QxwjRJsLtzC5Jmew+37
         2oTATFiNahma5AW6JvvaJDy8j8c0OIfZm80c9xHwRE8UCTXifYT75BFm7LnVZv0gmhOn
         lSMqSBS/Tz7zTLinDKYxqXytI6/kMvlU/0ODCHMpop+4endpWXiK3UMnEVUjlQ/hfk0M
         ZHT+VDNOE9lJC1Inq9ER6YQY9EyphMcvmOIKhdvWZdtxG6buQoCxqT8UeLM5LwvPoC0s
         2Wz5OqpYD4J8P2qQ1CthsmaF/ksm8QFsF9fVGuyx8LFZzlWapuNRTCAPpKZqaCeMPYPR
         GPvA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1779126839; x=1779731639; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GqfThZKH83Pq49kMDzP4xulclp1+rWsSNmFmdp9OqbU=;
        b=d35PSWMAWp1btXSUcitGvBJet/rg5rc9B2By0mL2RiyKJoRKUk4vmsLNQQXLlpDIKZ
         MPvxwGHRx48TP1Poe4bgrVeUjofbFHvZHAG7gdYZ3M/h/EeMdN9o4BWzJunZ1NMiflkH
         szFAsHSxRPs5AdVI8Pv2c4dRhKu6mSjLYNZVe2PEaynHFcC9/0CXVslDf5cA72dsIfxv
         t/jCXwo+uj6AN79jgrOkWD5qzlJCta0tLjtok09nemPrb7ySyGZcItsalY+COLMfXuFi
         ZZ3FBz2mIL1If+E4lRHBwJUJ6rSBHe7eOr5gwqqmTUjUMSatteRDbY2Qjr2O6HCygVyt
         bLmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779126839; x=1779731639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GqfThZKH83Pq49kMDzP4xulclp1+rWsSNmFmdp9OqbU=;
        b=WjDOG7HpfETUdupKBPA6qoJm/MhFDYvqJfMsZKjErImFmngvhhpzMBrPP2vz/0agtH
         3KPAsjPJMFawhUqjg6xAsHG3nGRGOWxlWWsK6Qhf02DBqEILn5GK04tbI2PWBjwjoJ/G
         c8O9+xEIllO3e7Ku+RNCX3yxaJwvqLU7VH+ZqTRvS2qs8Lj+WBDGj+8yc7Dd6J2VBIKF
         VF5AYaYNZDd/PGfwCiStqWqX8zQCRWGUAsobk1Tylk4VDZWMOD8WUlI1lgBQDZXFeoKJ
         vmAiSd2qslQETR9EUTdmaruUhfnO6R5SX8ckVJIrjRZwO2UQPOB87DXVaAwZVe7FedKW
         vuhA==
X-Gm-Message-State: AOJu0YyMyuOfVhdOoRq9JAwLNfRtNivIbDM0asKP1VQLOFATZvQkAJGZ
	fTvbQEWyeD6dsXGzpiCo1uJcauf0qSwYlJ+FPeHyB8yzZc1/EU02c8iStnnQRoClr+UoJAYbjPx
	GCzBjMYIi0zhSt+zlgOOY0v89e1DdtfMT4AaCCuSObuFdBLQbP/c84N7DKG4vM4LMQpgvNzgcz4
	NSpkjmvxI6e6JvMpzok5GlOiAzEi9lIo0G0ZmtZNVDPSXqmbHg
X-Gm-Gg: Acq92OG/5b7UGlkZA/uJ3yfdZxn98smr0Sw3eMvTA/nWo1yooRigHhS7qN7DVNq01PQ
	nHTA+5ksQUhDjGSyw9WVQ4Eiav5ILkFQr24GBGUMB+7nNPKtyga6LhyKlHYsRU6+E4mzM55I4zH
	lPG0QCvOSJ025HIWGvUryKBtUfpuEIuIocvamzvHZjHSyHMJ0Ny8FoQl4o3n99xiWz6CuxVdrUa
	nRcu4hfjonccYKhnFjP0Oac5jZ+VRnU9DmJClDudPE4qZqhgphJT8Y5+W67
X-Received: by 2002:a05:6102:441d:b0:631:4e9a:bab with SMTP id ada2fe7eead31-63a3ee864b5mr8407515137.18.1779126839480;
        Mon, 18 May 2026 10:53:59 -0700 (PDT)
X-Received: by 2002:a05:6102:441d:b0:631:4e9a:bab with SMTP id
 ada2fe7eead31-63a3ee864b5mr8407502137.18.1779126839015; Mon, 18 May 2026
 10:53:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260515181112.9758-1-djeffery@redhat.com> <b020a37b-ded6-4fd7-af4a-f4553a72717b@acm.org>
In-Reply-To: <b020a37b-ded6-4fd7-af4a-f4553a72717b@acm.org>
From: David Jeffery <djeffery@redhat.com>
Date: Mon, 18 May 2026 13:53:47 -0400
X-Gm-Features: AVHnY4Kd8G96-eIBmmWoZfM99g8knQN3rpCKcrg3mGkkv_xWAHpzCyLWvUH8jho
Message-ID: <CA+-xHTEc=Q-tGLgvDBK=upzgqyiDuusBzNnw2-L+PftJs6ir2Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: wake eh reliably when using scsi_schedule_eh
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 3:49=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 5/15/26 11:11 AM, David Jeffery wrote:
> > Drivers which use the scsi_schedule_eh function to run the error handle=
r
> > currently risk the error handler thread never waking once all commands =
are
> > timed out or inactive. There is no enforced memory order between settin=
g
> > the host into error recovery state and counting busy commands. This can
> > result in a race with scsi_dec_host_busy where neither CPU sees both
> > conditions of all commands inactive and the host error state to request
> > waking the error handler.
> >
> > To fix this, run the scsi_schedule_eh's scsi_eh_wakeup from a new work =
item
> > which will use rcu to ensure scsi_schedule_eh's call to scsi_host_busy =
will
> > occur after the error state is globally visible and will be seen by any
> > current scsi_dec_host_busy callers.
> The comment above scsi_dec_host_busy() is not correct. I don't think
> that call_rcu() guarantees what the comment above that function claims
> that it guarantees. Maybe something like the patch below needs to be
> folded in into this patch (entirely untested)?
>
> Thanks,
>
> Bart.
>
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index e047747d4ecf..d991b0fa0421 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -354,9 +354,6 @@ static void scsi_host_dev_release(struct device *dev)
>         struct Scsi_Host *shost =3D dev_to_shost(dev);
>         struct device *parent =3D dev->parent;
>
> -       /* Wait for functions invoked through call_rcu(&scmd->rcu, ...) *=
/
> -       rcu_barrier();
> -
>         if (shost->tmf_work_q)
>                 destroy_workqueue(shost->tmf_work_q);
>         if (shost->ehandler)
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 147127fb4db9..c021932504a6 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -278,28 +278,6 @@ static void scsi_eh_reset(struct scsi_cmnd *scmd)
>         }
>   }
>
> -static void scsi_eh_inc_host_failed(struct rcu_head *head)
> -{
> -       struct scsi_cmnd *scmd =3D container_of(head, typeof(*scmd), rcu)=
;
> -       struct Scsi_Host *shost =3D scmd->device->host;
> -       unsigned int busy;
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(shost->host_lock, flags);
> -       shost->host_failed++;
> -       spin_unlock_irqrestore(shost->host_lock, flags);
> -       /*
> -        * The counting of busy requests needs to occur after adding to
> -        * host_failed or after the lock acquire for adding to host_faile=
d
> -        * to prevent a race with host unbusy and missing an eh wakeup.
> -        */
> -       busy =3D scsi_host_busy(shost);
> -
> -       spin_lock_irqsave(shost->host_lock, flags);
> -       scsi_eh_wakeup(shost, busy);
> -       spin_unlock_irqrestore(shost->host_lock, flags);
> -}
> -
>   /**
>    * scsi_eh_scmd_add - add scsi cmd to error handling.
>    * @scmd:     scmd to run eh on.
> @@ -308,6 +286,7 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
>   {
>         struct Scsi_Host *shost =3D scmd->device->host;
>         unsigned long flags;
> +       unsigned int busy;
>         int ret;
>
>         WARN_ON_ONCE(!shost->ehandler);
> @@ -324,11 +303,27 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
>         scsi_eh_reset(scmd);
>         list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
>         spin_unlock_irqrestore(shost->host_lock, flags);
> +
>         /*
>          * Ensure that all tasks observe the host state change before the
> -        * host_failed change.
> +        * host_failed change. scsi_dec_host_busy() depends on this order=
.
>          */
> -       call_rcu_hurry(&scmd->rcu, scsi_eh_inc_host_failed);
> +       smp_mb();
> +
> +       spin_lock_irqsave(shost->host_lock, flags);
> +       shost->host_failed++;
> +       spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +       /*
> +        * The counting of busy requests needs to occur after adding to
> +        * host_failed or after the lock acquire for adding to host_faile=
d
> +        * to prevent a race with scsi_dec_host_busy() and missing an eh =
wakeup.
> +        */
> +       busy =3D scsi_host_busy(shost);
> +
> +       spin_lock_irqsave(shost->host_lock, flags);
> +       scsi_eh_wakeup(shost, busy);
> +       spin_unlock_irqrestore(shost->host_lock, flags);
>   }
>
>   /**
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 6e8c7a42603e..7a636d771c13 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -362,20 +362,11 @@ int scsi_execute_cmd(struct scsi_device *sdev,
> const unsigned char *cmd,
>   }
>   EXPORT_SYMBOL(scsi_execute_cmd);
>
> -/*
> - * Wake up the error handler if necessary. Avoid as follows that the err=
or
> - * handler is not woken up if host in-flight requests number =3D=3D
> - * shost->host_failed: use call_rcu() in scsi_eh_scmd_add() in combinati=
on
> - * with an RCU read lock in this function to ensure that this function i=
n
> - * its entirety either finishes before scsi_eh_scmd_add() increases the
> - * host_failed counter or that it notices the shost state change made by
> - * scsi_eh_scmd_add().
> - */
> +/* Wake up the error handler if necessary. */
>   static void scsi_dec_host_busy(struct Scsi_Host *shost, struct
> scsi_cmnd *cmd)
>   {
>         unsigned long flags;
>
> -       rcu_read_lock();
>         __clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>         if (unlikely(scsi_host_in_recovery(shost))) {
>                 /*
> @@ -393,7 +384,6 @@ static void scsi_dec_host_busy(struct Scsi_Host
> *shost, struct scsi_cmnd *cmd)
>                         scsi_eh_wakeup(shost, busy);
>                 spin_unlock_irqrestore(shost->host_lock, flags);
>         }
> -       rcu_read_unlock();
>   }
>
>   void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd=
)
>

Hello,

Unfortunately, this non-RCU way is racy due to possible store-load
reordering within scsi_dec_host_busy. With no form of memory barrier
or other forced ordering like atomics or spinlocks on its fast path,
scsi_dec_host_busy does not guarantee what order its load of scsi host
state and its store to clear SCMD_STATE_INFLIGHT will occur relative
to other CPUs.

With a non-RCU version of scsi_eh_scmd_add, there is a race where a
last command through scsi_dec_host_busy reorders this critical
store-then-load. From other CPU perspectives, it loads Scsi_Host state
first so that scsi_host_in_recovery is false while its store to clear
SCMD_STATE_INFLIGHT is delayed. scsi_dec_host_busy never goes down its
error path.The CPU calling scsi_eh_scmd_add sets the host to in
recovery, but no local ordering will guarantee when the INFLIGHT clear
from the other CPU is visible. So the scsi_eh_scmd_add CPU can see the
command as still busy from its load of SCMD_STATE_INFLIGHT occurring
before the other CPU's store clears the bit. Then neither CPU wakes
the error handler as scsi_dec_host_busy never sees the host as in
recovery while scsi_eh_scmd_add sees a command as still busy.

The scsi_dec_host_busy comment may not be completely clear from
condensing too many details on how and why it works, but the RCU usage
does cover this type of race. The rcu read lock combined with the rcu
callback will mean the execution of scsi_eh_inc_host_failed can only
happen at a point in time where any active call to scsi_dec_host_busy
is guaranteed to see the host as in recovery and take the error path.
And the error path's memory barrier and locking will then work with
scsi_eh_inc_host_failed's ordering to avoid a missed wakeup.

David Jeffery

