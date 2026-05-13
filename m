Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF1225B0A4
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 18:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778696469; cv=pass; b=aLudI4M4u+U8Ud/HAKSZRzirXGoR++6e5Hn7vrL4ihqsyXlDOqQ3Q6sawpv/0q2nDbJ66Pf+ksVOEydtgNehzhcSeUr4fY1aTZ3/cXw82GvmsIjCXu3AnU6rAh/gOACAZRiSOWKcfuiDipdkUIKLBEbEabaRnx+tOhCebiQO+zk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778696469; c=relaxed/simple;
	bh=uxlj+d6/XwLFTAUya2+1pKDT/d4pxMIdKQKjKpjGw4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eUvH4TK+QxOto8ORfFFv/yNfOMYF2wR7RXWq9ni8WSeuLaDR5DYnRCw5//e50dEKHGAFtJY929AGRYZgCGw3PTgU2zp+ImQPpxACeY73wB/RNU/BPux9XIIMujarJPa8bT52SM3C2PvKJtkSju7eDcdx4DJBC1q/qWOT0VODvLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N2JaMS2Q; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GEiHs+9g; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N2JaMS2Q";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GEiHs+9g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778696467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tcPz4+77uujpByXTjSSUTkOmlqjy7g/XR5Dvgj/lMZY=;
	b=N2JaMS2QphDIO74Kyer5RNR2Ykq3k8R83d6qQZpHs+nYcWE+Ir7ujmYtTSUQYW0w6Jdb02
	ckpRKmioMGt1muMJ/s8ysXfwG6sIRPQxWUBufXgKTNo2IF9AqjVEF1t5BQzTAwO9aGaTNy
	avA0EdNLorJlp+oKVUazNpM8U17yqk4=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-KA1niV43Mt2iGFfS8ROHjA-1; Wed, 13 May 2026 14:21:06 -0400
X-MC-Unique: KA1niV43Mt2iGFfS8ROHjA-1
X-Mimecast-MFC-AGG-ID: KA1niV43Mt2iGFfS8ROHjA_1778696465
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-95cfe3d4c16so10947344241.3
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 11:21:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778696465; cv=none;
        d=google.com; s=arc-20240605;
        b=UhnZvPUjWkWiZobQYAmuBl/bCmip4BI4MJgmyNzIvn1TTCnIaOfhFYayUmT+SGsLnK
         eeALhDLchlziD1U4z+iBe6JuS5W5gH0cZaXy0zgWHzGXKqpKh8Q767qSJm8q7mo9xjVV
         W9bwgeMtTIbl325Flq2VzExOlH3IBLcnKNwCJqI5zbPlRHJ6aKBVDbdkT8ioRRnVh4Fa
         I5Gcq2THSxJD3U+nkW/0EVblhs4YD3aNBjFjicv7ZtSFJvV08QiR/D8z4teayWQImrpH
         hir+EowauMpFtXfgxDQtAy5glbFQtuCPhTqwfY8e5nAYF819ACs+AaaZJW688F3e3nMJ
         t48Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tcPz4+77uujpByXTjSSUTkOmlqjy7g/XR5Dvgj/lMZY=;
        fh=tScm2eAN0HS9mCdl3iBYquTZsazadfL7sZDsu6+Quyk=;
        b=SVHB8yOnOLP1svcwUE58cA7aaD0607JiVO2I9iacu4LN6idNiLC8t5WPOQ6qlucfI+
         bq6Dkpro9Jy1f/13odbH7LonWTzqkzNoiDQXrN1IBYdg9efhaqzSj3nysHka/ZZlkSMx
         8YfkzmFiqLZwgT4JzB/DpTUkvO2gEcN7oIyfRGfzdqh3kInEzcl0MHDWCtq2ZSrGIBJZ
         0KUgvL4rXeTK6HQszaHbndjHMMUdC3OTOwbN4dQYKKfBqV/0RIshCNkXIlC9E7DVtj5W
         vxwQ2U8CEAHk2mJ/mC4Gai+RjYjTpeAoM6K/xXRPs1yyCuRlPwvUJ9n5bunhAb3fmb1W
         qlyA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778696465; x=1779301265; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tcPz4+77uujpByXTjSSUTkOmlqjy7g/XR5Dvgj/lMZY=;
        b=GEiHs+9gpuRl2bAhj5JD8xhKVzuNgQHSo+xvE9QTOplAxi0AGo+b7aPOXndFGkl82S
         TIMVpmsk9vKs8JTkcnQKsGCIl2UoDtcR0m9YbJmKaiFlSabLQ0BKSO2CuPe0E21hm8B4
         /sEWBaBPI6RXv+3AH3uK5HlreEj+tHL+q1StQeIrquSMpXboO6uyJpva3WAI+QrTDp5K
         vLOX+sZeWnfxkk7uil2/z56ck83HBBuWhgT7cZ6CZSTr/uI1OWiDY6m1t8l6NEIELBds
         OqE8RKClWLQGwEPdcTYscVNYq0SkQsYEpz5mXYAeC9++t33/tJ2pC0cJFZIKpyw6j+5M
         ZZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778696465; x=1779301265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tcPz4+77uujpByXTjSSUTkOmlqjy7g/XR5Dvgj/lMZY=;
        b=MHmfIoP1cUmVk6oYCiB1P0zd0txcUDj2c8FLy3ePaZlJyu9RvPUeeNn1LGrDf+23Wv
         4YegimMh4hKhWZTW0lGxcj2Edyi0roGkg/hTaJdwuPx+abt0AmkdtqXTawpkwjhrqiwT
         FmpD71VRiuSK0M+UfbwiFidE9S9yvjF8rWAITDSvhG175FRnxmwrqe/LjXUq0b1YPwp4
         oTxWNEQJRwZMcUIwNPGLNdVMEcrOHzN6ootYJzrYmVKs0Pk+QD3YlDTjz1GXX5Wrn1pe
         DlrCNJWZ31C1tXmYAkh1pON3u1PRd+m4IoVCuThgyO/VeRGafTGb0+Hzg8e3TVTUJxbn
         KKAg==
X-Gm-Message-State: AOJu0YwLgQB5gXyub6KUlGUC1LL0kZAps+mox1Awo5XpxXSq26v2oGLT
	ZeO7XXUcPG0t3gGILaUvgg2c0+SkYZ9L3rKzpxxfsP86coeHbQ93iFHNJDDqi516fnVgdXtSusg
	vvaMKT/NBKlzJtvfLClMfTrOjfH2hzhb8zANLxas3680fDB9t9mmwcI9PQ22cVdJA/lqch5phAz
	xRb11iZCI/niGui2qn93vc54vIVaLZySKz0ZXdaw==
X-Gm-Gg: Acq92OHWMQCF1rBLdMfyjGDK/VJP6IIwq6QG7qe8q0R+5Wmx7bDmvFC/C8pDctZvCQe
	nLBAmBqAize7g8CdNBWjdTIuJX4WEjRVkWPcCi88zTACF9ZvOhDTTtPgizkBcAbE/5hCc2JHtSS
	jwTvEX0OgR5zQuw4mqzUXROvVUST83Qn1CYuPaVlIGnpyXMGxgjKPpq7UjI5MtDNmtxkmK4sUdj
	n8RlXQsiBH3bRIQvXM6d8jg0c7MeZ4L5MREM/aLkVPvi2GEQBKXBEzE4t6U
X-Received: by 2002:a05:6102:5e8b:b0:633:d7ec:153c with SMTP id ada2fe7eead31-637732e337amr2975821137.3.1778696465580;
        Wed, 13 May 2026 11:21:05 -0700 (PDT)
X-Received: by 2002:a05:6102:5e8b:b0:633:d7ec:153c with SMTP id
 ada2fe7eead31-637732e337amr2975799137.3.1778696465194; Wed, 13 May 2026
 11:21:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513173552.9222-1-djeffery@redhat.com> <3442d2e5-de1b-4043-97cb-464feda2623f@acm.org>
In-Reply-To: <3442d2e5-de1b-4043-97cb-464feda2623f@acm.org>
From: David Jeffery <djeffery@redhat.com>
Date: Wed, 13 May 2026 14:20:53 -0400
X-Gm-Features: AVHnY4JaHmhP0W3rCgR-Gpx7w8iCbHXxEDFh8jughpBs2gOHwqSI9i9mmxRaIwQ
Message-ID: <CA+-xHTHN-fjkjc6MUdUxR5Uz-ukG_LG3V7TKtf8j5r1gE8uhrw@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: run queues for all non-SDEV_DEL devices from scsi_run_host_queues
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2026 at 1:48=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 5/13/26 10:35 AM, David Jeffery wrote:
> > While a scsi host is in a recovery state, scsi_mq_requeue_cmd will not =
set
> > the requeue list for a requeued command to be kicked in the future. The
> > expectation is a call to scsi_run_host_queues will kick all scsi device=
s
> > once the recovery state is cleared.
> >
> > However, scsi_run_host_queues uses shost_for_each_device which uses
> > scsi_device_get and so will ignore devices in a partially removed state=
 like
> > SDEV_CANCEL. But these devices may also have requeued requests, leaving
> > their requests stuck from not being kicked and causing the removal proc=
ess
> > of the device to hang.
> >
> > scsi_run_host_queues needs to run against more devices than the macro
> > shost_for_each_device allows. Instead of using the too limiting
> > scsi_device_get state checks, only ignore devices in SDEV_DEL state or
> > when unable to acquire a reference. Attempt to run the queues for all o=
ther
> > devices when scsi_run_host_queues is called.
>  From scsi_host.h:
>
> static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
> {
>         return shost->shost_state =3D=3D SHOST_RECOVERY ||
>                 shost->shost_state =3D=3D SHOST_CANCEL_RECOVERY ||
>                 shost->shost_state =3D=3D SHOST_DEL_RECOVERY ||
>                 shost->tmf_in_progress;
> }
>
> This function returns false for the SDEV_CANCEL state. Hence, even with
> commit 8b566edbdbfb ("scsi: core: Only kick the requeue list if
> necessary") applied, the requeue list should still be kicked for SCSI
> hosts in the SDEV_CANCEL state, isn't it?

SDEV_CANCEL is a scsi_device state while the scsi_host_in_recovery
macro is looking only at Scsi_Host state. An SDEV_CANCEL scsi_device
is unrelated to the scsi_host_in_recovery return value.

I will note that looking at scsi_device state in scsi_mq_requeue_cmd
in addition to the
scsi_host_in_recovery call does not fix the issue. The scsi_device can
be in SDEV_RUNNING state at the time of request requeue with the
attempted removal and transition of the scsi_device to SDEV_CANCEL
occurring later while error handling is still unfinished.

David Jeffery

