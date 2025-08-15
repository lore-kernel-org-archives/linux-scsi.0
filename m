Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739BDAD21
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 19:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755285472; cv=none; b=iVgjA1VvvQxVmEHZbIrbMSqeOVrC+GjJ9PaNgdkp6T+7GteSJoCUxvMb4iNcw3Pfm7HVMjIwCPBxROo2B66i+BBRRoZ44KEFNeppMplJ8ntq0fVB9q1ZttGqiJC9Cs/XTtDluz9yl1U49uE3qPUgEsQIC6Dev1Wh+gHk4IEysj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755285472; c=relaxed/simple;
	bh=QCfjkDTxtqVaV/X5O75Lfz7+sQrNxnTt3Vvwad+suzc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nnFcPYFLQB6I/MkikieUQlMEtzsLc8VjUhGNPQ6NtsihxqTcNM3iJ3BrFodNH9IWsxXPjQxNfvGR95tPFfeFGLqT4H5lidpT1qEc5I/EhdgFEmrD3wxMH/eKWL8c9/gQ0CtLWcF3MBP2oZ4ATjkHD4O8EqB2xRL+MSQLVEm3rlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HPdLOSXa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HPdLOSXa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755285469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Yb3L8aOKTUITMsVaGLItOkTUWl8xSkbVsBMtlozssY=;
	b=HPdLOSXaESLCvrBhT4VE4euF8q5e8x4TLUsTnQJtBgsP35HH1dDm8uFWWy+r9sbfxwB4Jy
	MXs9mhLYE2cRon8MBa85cLWy51m0ugFg+TL3wl2vpKD5PNzTir5pgoiGPbcQVkSp9oVtG4
	4akLjeCap5wQV8IfI4Wy/ZBp8yLktt0=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-MTO7eMXrOyKo7aHLFSFVSw-1; Fri, 15 Aug 2025 15:17:47 -0400
X-MC-Unique: MTO7eMXrOyKo7aHLFSFVSw-1
X-Mimecast-MFC-AGG-ID: MTO7eMXrOyKo7aHLFSFVSw_1755285467
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-71d605f9914so36909287b3.3
        for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 12:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755285467; x=1755890267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Yb3L8aOKTUITMsVaGLItOkTUWl8xSkbVsBMtlozssY=;
        b=eLGIcgZ3fhJ8fH9jdIyqD2oYmhddYOo7DvJSsn0pmgCWGubGOKXR1DysEoblAkOvcx
         gwWNt80jCJU0Hx6z8Bijja+/1/Fr+erezlTqiDif6hnf95QntnGJcL3+QCSsuAoHTk3f
         vGx5OBDfgwoCKY/yAQ+5KMRV72L6QwtfhZx/2Yq6lkkP9ZF4GqC3oTqseJ8HIaijbcWM
         Izr7s3+suRe1eW35tpEV5k6bVHQTK63FcMRMAWbHCZeOUZyVvGSVbDWDTQaZLZSiH7lE
         PIUDBVR/PV/iiPG2wVS2YQuEvbBRECssCOY9fduGiSjzNtL2kogs0OrLDAHgqNJxyLcT
         M/fA==
X-Gm-Message-State: AOJu0YwxH9D5PQqTZxBvnEWMkNfUaMeyc3QaD4ioZ8FPItIbE19JLSVI
	sj2ewg4YDz4fGXtH7I5glB+EOkv5YmWcmpkQoLrgGyNx30+/GAqFewHQXJzKhsyrBauLhuOsfVi
	wqSP2RYHOYLwNVYfUi1caO1OiFfxB9O4BgdA58QkBsT7cWBQNKATaU16nMs80baDuCuNDBmuqkg
	570PTqAkS69jFu1iSLVxViH1ZNQls25RNzvf5kJg==
X-Gm-Gg: ASbGncvIWWUUNivUccidWXTsuXNeho+B0tHdey5MJTzsFHTRaaGn+RebpW0cjK6S0ig
	Sytt5Wrh/gMu9YL9BxKiPWwaPTS+dxcX5VxqvhDBEl2vfBEbIQ8cmp5Qr+MrmtyExgPh3t0Cz9l
	HV5T11/EthLv1c+fRQoqEBdQ==
X-Received: by 2002:a05:690c:3690:b0:710:f46d:cec3 with SMTP id 00721157ae682-71e7749de0fmr3675087b3.5.1755285467324;
        Fri, 15 Aug 2025 12:17:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4dSgFVh3Rz0N/iP6Q6sZ66vdmvHLtI4/3KYs9kitgvr8Gx9lEC6oCuMzZt10D8lL4/HdkXTitzVd6nL380dM=
X-Received: by 2002:a05:690c:3690:b0:710:f46d:cec3 with SMTP id
 00721157ae682-71e7749de0fmr3674897b3.5.1755285467023; Fri, 15 Aug 2025
 12:17:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814182907.1501213-1-emilne@redhat.com> <20250814182907.1501213-3-emilne@redhat.com>
 <f56d5c4b-5a26-4f89-af3b-32e4d8583b69@acm.org>
In-Reply-To: <f56d5c4b-5a26-4f89-af3b-32e4d8583b69@acm.org>
From: Ewan Milne <emilne@redhat.com>
Date: Fri, 15 Aug 2025 15:17:36 -0400
X-Gm-Features: Ac12FXyW5EnslV5lzM9V6yzq3Ueqp8qf-E4v6Jnyu0a1N0VW7nagIppqjHiMV7M
Message-ID: <CAGtn9rmSjZKGwrXsCwHZtUeX044EV=tZzah6PSBjREck+pW-Yw@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] scsi: sd: Explicitly specify .ascq =
 SCMD_FAILURE_ASCQ_ANY for ASC 0x3a
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, michael.christie@oracle.com, 
	dgilbert@interlog.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2025 at 5:25=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 8/14/25 11:29 AM, Ewan D. Milne wrote:
> > This patch
> > changes the retry behavior, we no longer retry 3 times on ASC 0x3a
> > if a nonzero ASCQ is ever returned.
>
> Hmm ... my understanding is that this patch makes read_capacity_10()
> retry if ASC =3D=3D 0x3a and ASCQ !=3D 0 and also that without this patch
> these retries don't happen. Did I perhaps misunderstand something?
>
> Bart.
>

As I understand the scsi_failure mechanism, scsi_check_passthrough()
goes through the scsi_failure entries looking for a match.  If an entry
doesn't match (i.e. in the case where .ascq was not explicit and is therefo=
re
zero).  It moves on to the next one.  If none match no retry is performed.

But, the last entry in failure_defs[] in read_capacity_10() matches on
any result (SCMD_FAILURE_RESULT_ANY).  So it will retry 3 times
if nothing matches.

Current behavior (before patch):
  Match on either UNIT ATTENTION or NOT READY, with ASC 0x3a:
    ASCQ 00 (default, since not specified) - DO NOT RETRY
    ASCQ not 00 - RETRY, since scsi_failure entry won't match, but later
                            entry SCMD_FAILURE_RESULT_ANY will match

Behavior with patch:
  Match on either UNIT ATTENTION or NOT READY, with ASC 0x3a:
     ASCQ 00 - DO NOT RETRY
     ASCQ not 00 - DO NOT RETRY

Behavior change is not to retry regardless of ASCQ value.
I think this is what we want to do here, I thought this was what you meant
in your review of v1.

-Ewan

