Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB8D23507C
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780598596; cv=pass; b=MWHzqkdRCXONuUfe9gaju+4t7rSCh6/8G11gWsNie2QdV8X/Qc9hGRQ1K0rWJzw4YA4ybqM4U6IgmO640Q+A35RKtKulRm1TgSrY68Wrou5/gWI1cPLcHPrBjNQqNsRTU5v0CajmHTUn8s8Y9QWBGr9wgKxZGnSbeihhtJT/1vE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780598596; c=relaxed/simple;
	bh=eotJYuddMzet9b8algR4vYdg8t1Mhd7014CzpJGZyy4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pGKMcOIj14IyfUszRpZq8qsEknUOaIXvBw0vysu7B/RwU1K1f0YpMWUiWEvn3xVM4gMWSpOg5mxQOSK0sTvkJsuAb4o48I6N5uRnjYD1nM3Zc+CbusnPS/SMlhkLDwsfq9bipwmkeA98pencGhlIVNlDr607+nkDIbE5fQPcrks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=GJYzn4l3; arc=pass smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="GJYzn4l3"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5aa68d9dc18so1110435e87.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:43:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780598593; cv=none;
        d=google.com; s=arc-20240605;
        b=ZxKi+Xo5ttCGOB0YXraZpmuht3zi3u3XvrMZfrg7lpELP74yqt+5M//PUS6+cYBVrF
         03u6zageVtPQCFt7GadF7pBiuYSlMp+l9bXY2zXvkE3klZPap/J219KruaJjoa/enE6Y
         2xPB4P1/pk5WjokO7uCQL9coa1GvzYiPAutanr1mRMKwBIB+E2obr0dqCX4fSOWvWfAa
         5sxh5WUgygcEqx88uqPWaSRssqagGhFK7oHdWBNfx4dH8RFixI1eY+JdMtoYB+1ggxny
         ykhRTikpwMyGLyT/HCCb6jKdZmyNd08gCIylwaQHiaocUxU3aidbdtcO1mRAYfH0DEsE
         6fEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lk8dusq0quFWGHcSy4ii+GurR95Lq5xubrXWHatHs0Q=;
        fh=wUJKX1ukwBugfigKKR7vKvp3YYvWZ3ad7rXsYrvr+DI=;
        b=TcsfJDWdlNbO5kjNZ4xWe41M5XsG7QRORj3DF8U3RECTvOCb7fh9A0eHTbq0ru7Fsl
         I+grfuow1A2NIcwqysHuzS5vfuh9IkRl5CHZImelKAea5ajNC4JZLfPsYh7NOKOsWmle
         SZhffqrVmW4Q5BO0X25B8IQQod6/MwI3QsUj0eGN7dZg9fqQP/cwSKNxrSCAYOQ507UV
         M3DP4H8x4gZhe9PCwQvG6klKvn6cNvJIlq+Xz3Vsv6GgiLl6lhecLzVX/SXoTLLUrsVv
         Ae0L8wq09mhwuhZmUk/Q42NcQ52c+vxg2pF0Lec1qrlXEykEK/t3LCc2A38cN+FrlW1l
         qSiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780598593; x=1781203393; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lk8dusq0quFWGHcSy4ii+GurR95Lq5xubrXWHatHs0Q=;
        b=GJYzn4l3IR0yMP5EKGeizyFm6m117QL1UZSr+FIUjCEGqLl2TUaJKWxK2s4KLvfAme
         7Q75fN3LCpY6nvWuIXFSQDSJ5xMT+kk9wu7FJoT0oXKbxAmnA2zocrlFpq0rWVZ+eHox
         v883fKD1xtz6O5NrPAjRxQNlxDCMDZVRUsG3DpHE153frzUag7kPG8vkcScOObLqMvmF
         yQuTr3tGVj/qzoHXlGsIC02UB2dPJySzT5zzqtR7SNArhEHMP3BQ7zrEYgS4CP4BwHoN
         VH4Mcd7A+E20jxu/jr4DaYKq4iPRzch0EtsNLV1bxwvHl4yP10b+ziRo0Ugj36IOMQc4
         Xdgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780598593; x=1781203393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lk8dusq0quFWGHcSy4ii+GurR95Lq5xubrXWHatHs0Q=;
        b=ohC50CmfV7SAGzFAmFcRJVDQJ69d5q/riEQkUuZwlZ6MkHuBV6EGb+kW0sk/f1LIpT
         pHQCE8nWG3yHPOhDUFhoTMAE4QaG7qeAC9axtPi8euShylxEPC4/kOfqKySNTb4uXKav
         axIRyyVDCn6w8uAe60OA8GVl7MolcaBeUp0e/POY0AzQg/n1r4LXeECbj2Z3bZfrfZI7
         BQi47ZovyeurYgCioq79GcJLVuVLrTxfTSYVRSXjZw/ptTU9ln5nWKPtiJfbImY9wugy
         6j0MdvT3GFJUngC1evS0tGxhrAqPayHN9Q9rmjATDBqNvehoHmn0HcPZHAeVP2XfqCHm
         ZHDA==
X-Forwarded-Encrypted: i=1; AFNElJ+RZSgjyLM5AHOsjKK77RMTP0VtB/PwaUmxkNvMcMl/iDQTUoQZ70eIgs3RfCSrdxIcvB67LoZZmS0n@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8lGkBjJYBUK5+osaOJBdVCTiu+48Pihm7Ap+tTpKjL6tRRLPp
	G+OopXHVkYG7rZEYCfqqLTQVPhmC6NXARdqLWqs85B+eh8oJYG/VZf7ZK8Cu/qbrsJ6ZAhT1sit
	eSyaegqmSr1A4Qm4GoN4Hjk4diQBbV7skObRL8vR8Pg==
X-Gm-Gg: Acq92OGVxprPTiRwd/kiP6IdE94JAJbepdikvcvSvsVrzB2bDSE4KNFUcumUEKVfou0
	vL58bE+HESuxP7cLixbJ+l1OL2sKJEt3Uqa7M/FdFfMsEkEw09jQo6BynPtzjKjqZsEC2QQmoEc
	01sKNWSHu6txH/0qoU0X3bZfVUzFeSpOWJOZY6bRLu8Ifwi6F1y063TjKvp2gJgoO9lTLRxb4q+
	WXD+GQJ0TOKWMA78jKYpzOvt49qLQeKk3AHZYZ6WS+0vOL6MddwG42gz2Jw7bgDHFcuAWjQ2Kwp
	63AeYbNszuIiFLtc
X-Received: by 2002:a19:f615:0:b0:5aa:6a2b:d456 with SMTP id
 2adb3069b0e04-5aa87bc2359mr6214e87.27.1780598593211; Thu, 04 Jun 2026
 11:43:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260603171104.18464-1-sam.moelius@trailofbits.com> <c01aa774677d1f6fdb0f0924ae0e2de47836d55a.camel@HansenPartnership.com>
In-Reply-To: <c01aa774677d1f6fdb0f0924ae0e2de47836d55a.camel@HansenPartnership.com>
From: Samuel Moelius <sam.moelius@trailofbits.com>
Date: Thu, 4 Jun 2026 14:43:01 -0400
X-Gm-Features: AVHnY4IjNNsBu8cY3MG7HJl3iZiGbyZDbrE90xMKY1EvImD9OIRtVpLJ4iKBcp4
Message-ID: <CAE+C+DY4yoHz5ML5nZGEBwCZZ9jjX-0R5Dz=NS4xbDHp3Fe_7g@mail.gmail.com>
Subject: Re: [PATCH] scsi: scsi_debug: reject too-small REPORT ZONES buffers
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	"open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 3, 2026 at 3:11=E2=80=AFPM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Wed, 2026-06-03 at 17:11 +0000, Samuel Moelius wrote:
> > REPORT ZONES subtracts the response header size from the allocation
> > length before ensuring that the allocation is large enough.  A short
> > allocation can underflow and make the remaining length look huge.
> >
> > The handler can then write zone descriptors past the caller-provided
> > response buffer.
> >
> > Validate the allocation length before subtracting the header size.
> >
> > Assisted-by: Codex:gpt-5.5-cyber-preview
> > Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> > ---
> >  drivers/scsi/scsi_debug.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index 1515495fd9ea..f17e59482cfc 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -5911,6 +5911,10 @@ static int resp_report_zones(struct scsi_cmnd
> > *scp,
> >       alloc_len =3D get_unaligned_be32(cmd + 10);
> >       if (alloc_len =3D=3D 0)
> >               return 0;       /* not an error */
> > +     if (alloc_len < RZONES_DESC_HD) {
> > +             mk_sense_buffer(scp, ILLEGAL_REQUEST,
> > INVALID_FIELD_IN_CDB, 0);
> > +             return check_condition_result;
>
> That doesn't look right.  The returned length is almost always the
> first parameter of a SCSI command (it is in this case) and a lot of
> users will send a buffer just big enough for the length (4 bytes in
> this case) to get the actual length before they ask for the whole
> thing.  If you require 64 bytes, we're going to reject perfectly legal
> requests.

This patch is meant to be superseded by:
https://lore.kernel.org/linux-scsi/20260603225239.102803-1-sam.moelius@trai=
lofbits.com/T/#u

Apologies for not having said that explicitly.
