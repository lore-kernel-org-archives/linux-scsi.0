Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4DB3ED3BB
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2026 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780931695; cv=pass; b=G+/y+j1evjyPajeElEHlJFVPtAPOGLN/wLUvGGO3MTpHHVtR9XU1Xd+vIqKg8Jx4yJdvc7neYLlOjj0eiqiV97ykefAHzgsTg/Vf1RVu+3sItcLWuvyyFcYcG0PjAWy9hkXh35NUqRAtMPYbWaeYdyYC3g5jcat60bHUVCgH9Fg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780931695; c=relaxed/simple;
	bh=So4Apl3JSRewY/G4wjcQbewYpePIlhoq6+IFYGWbo/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XIn6WoFCz3Od/gWJI1dBqE9cdb5ODf0guLU5k3wqpU6Y4nFAcwKe0tWC+K0RW+Gah3XyR/H/970Dxb+u3ddURPjVdeX6VUghobkUw7cBfjAMJxgHOeULX1/ylnGW3MQRqjGrLjm1VKxPYneQq9XxUmSltESLzWQP/PUo/d3ciZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=POb3jku5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qG5bJHfs; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="POb3jku5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qG5bJHfs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780931693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MMwv+lCTRtF+dNBulpjTKSz3GDacVUhTwoS1E79WYm0=;
	b=POb3jku5Swg3MS3J9pxpRIz69Z6oaYIYacI3qLKYNlt8vVMO3bwiDeLL92GV/QZyM44+xl
	uyujcSO1ldDsnDrPGbF57sxvw9pEk6n5BkuSF9PYQZoGiSIdAb8RA+SmVr28MelpQ+7QrZ
	Fwn5/mmCqe7NYv94FcfVKXsaRG3YdoA=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-4IyAqU7ZNY-W5AW3Cr3mMw-1; Mon, 08 Jun 2026 11:14:52 -0400
X-MC-Unique: 4IyAqU7ZNY-W5AW3Cr3mMw-1
X-Mimecast-MFC-AGG-ID: 4IyAqU7ZNY-W5AW3Cr3mMw_1780931691
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-66043ac620fso2253091d50.3
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 08:14:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780931691; cv=none;
        d=google.com; s=arc-20240605;
        b=FRCxroAs+HOx5NscNWMUFyQJVMVbgZ8sFG5XLWVNbxQJbRS2wKTgnYnCVdspJS0IWo
         elRiSYOzGHw3ZMUDA0bA0OdbGYFCSkcwwcrfmWp3FxGf7henmhbqGDAYlBAAh77YJoE7
         ESqaTYtCbK5H20mh18qvQ/hFDJZJzeE37koDfBxgU1GSCAzmtpqjXhBHIkofDSs5jtsG
         msB8MFGsEurjXvFlMzQsBVyx0LMZmKdim3IhgCCNDkTS27Q4fpQNQjr0D1GVHy+uSe96
         bj8x7tE2qNh8heFxJL2vJRjS3aIXG4ZLwnCwl7L8XmZQwicW8H7OLB05OJymM8DXS0sz
         VkoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MMwv+lCTRtF+dNBulpjTKSz3GDacVUhTwoS1E79WYm0=;
        fh=V0/Gu/5jnCD9iMwRUVvAKQlUYq7mxd+/8vLtk0BIwHo=;
        b=QUG9/gNwPyTqZOlmtsGEO4Hlls1KUu5gAhIROqKa8x5vgjci+IhEeIrMchVkt1YFmI
         d9sirjeB29QKtqHwR4UrzT9xsiSzSxbHIY89y96F/Fs7jgDvnRa18SZO9rJNIpeBLBlz
         uPXTCzf1oRV+TaeBFW9xGOo7bIfuw4a8bwo/Qu1v7fMI/GngwQTDwApFAeP98jNd66+L
         8G2NMn3/IR7/YdMJ9W5CfEBcoEm4PoxDGD5L1ez2ge2owIofmR5o+N70g26JVA/vYPDK
         jS6lxB8DR2/f2fvZPv0O83IrQAkrSmCcOd56FnvN45hq+VOq8j5Gi47GbeYy9C01Atzv
         zT3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1780931691; x=1781536491; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MMwv+lCTRtF+dNBulpjTKSz3GDacVUhTwoS1E79WYm0=;
        b=qG5bJHfs7yIsu8FOXNBdcOzxY4iy1pHUN4w0EesU5rsfHbdb41tg8LRfRIHEH3bS6A
         8zQwCjjaWzr+4lMLDmtGurdZasE0ALszunekGRgT/QXMXo3A9PEwwsb6JhlhcWx0NhtR
         AHXPd6vOuK406eOLP++N2ihvKMrxVrFeTo7Fv1JooSaQemGH2hSEQVQ5qjQVwsd3nTBV
         nmoT7OtnzDdh82MgFWYH2MBhb5fHTvQNV1vlbTa3t/wW3/payk9vOmIlCX16m/NC/tt5
         IpGUB+fX4Y22MpnmMWMAqiGBEzETUfji20DDHgpkp2W0NdBrs6xJP5lcMgO+PvCfYYQI
         DOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780931691; x=1781536491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MMwv+lCTRtF+dNBulpjTKSz3GDacVUhTwoS1E79WYm0=;
        b=PepHi1pJ2A0YFKysjwVapVLFngnHnk1JPCPv/WGY03IU4xsaiMnrSZuD3ZaYMNcKzK
         DmvjOvJC1+YViFKVBHIx7QlRhtmEKcGhU9WZXcgGalGZSUt0VkkL3NWM1aSfhslOxY0K
         FcYDU+KKtd5AUYuKAQgTnasphCHytGtYAWMfzH05/YzAvIAXCiI+yvsYhkrPoRsGLxSJ
         GgoglUywSUyJ2IHoOrP4DwQ5W8/ftFMOTN63cPIAjCAdLUL4KlwGFe1lB7hPo1vl6AxC
         Hb942h/5iNxeYSBs0c0IbuaKK+nIBYFxZiWG9b03WQPPq1atpYeHr3kCkhw9uEXeuOnC
         GJSA==
X-Gm-Message-State: AOJu0YyNZAUAceIMCkHWfXoaXQu5xiwfo36EEEVpipy2LJfuDM5hVUhn
	st22ZMg5AzQ+B+v5vlPon8V+e2CAVAn6m5V9WZbrBqtEGS3+gFPrEdVCiQU5PEVYgCU4piaX+S1
	Wr6IyOoHopOmDU9v9CG96PVG0zXFdqsR8l3OuoFMBsEFpC8pOiChOrPZFEA5rWVUmx/oVp6lS/7
	GEg6Z4luQoo1GMV52kia5p7ikeH/pn88z8re14eJuVG4CsHg==
X-Gm-Gg: Acq92OHacGo2oUl6yBSTUbLIXmFQ/j8YVcKawifKOXwgi2vYu840A6uIAcmPlYJC72u
	DFK5DIBg99acGAEREJc/KWnR5iJM+7eo0AeJhm5y8YkTElZbq1QZGohX6CdYRXOKOg7rjg6K//y
	U6oSzBpSp83asC4Kuwt9J7zg4qNM/tbk94yNOmv55h0emISeCvN4WZnBLWUaskZYGjSNSqHN3Wa
	F3ippktH5+EO6m5uS6roh39VtNCm11S6gSntVr7p++ikn6dWo1GSbtqoJGwiACQ+b/5m/YMQA==
X-Received: by 2002:a05:690e:bcf:b0:660:5694:9e4d with SMTP id 956f58d0204a3-66108356dabmr13798724d50.20.1780931691329;
        Mon, 08 Jun 2026 08:14:51 -0700 (PDT)
X-Received: by 2002:a05:690e:bcf:b0:660:5694:9e4d with SMTP id
 956f58d0204a3-66108356dabmr13798681d50.20.1780931690858; Mon, 08 Jun 2026
 08:14:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260605182336.134919-1-justintee8345@gmail.com> <20260605182336.134919-3-justintee8345@gmail.com>
In-Reply-To: <20260605182336.134919-3-justintee8345@gmail.com>
From: Ewan Milne <emilne@redhat.com>
Date: Mon, 8 Jun 2026 11:14:39 -0400
X-Gm-Features: AVVi8CebJgmIlu9MO1RhI6jKz_BrcWo_X1eCKpZ1p52RfcW8fDJgpdF_LTZWc5E
Message-ID: <CAGtn9r=PYXet=yYPDdXxi7BCKimgf+jMrXKdGWS+_C13bFmzQw@mail.gmail.com>
Subject: Re: [PATCH v2 02/14] lpfc: Early return out of lpfc_els_abort when
 HBA_SETUP flag is not set
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart833426@gmail.com, 
	justin.tee@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 1:50=E2=80=AFPM Justin Tee <justintee8345@gmail.com>=
 wrote:
>
> It is possible that a dev_loss_tmo callback fires during an hba reset.
> The ELS pring structure is cleared by the hba reset path and the
> dev_loss_tmo callback executing lpfc_els_abort could be using a stale ELS
> pring pointer.  To prevent such a condition, check if HBA_SETUP flag is s=
et
> before proceeding to use the ELS pring pointer in lpfc_els_abort. There i=
s
> no point to issue aborts when the sli port is not setup anyways.
>
> Signed-off-by: Justin Tee <justintee8345@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_nportdisc.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_=
nportdisc.c
> index 9c449055a55e..2c8d995a45bf 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -227,6 +227,11 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_no=
delist *ndlp)
>         struct lpfc_iocbq *iocb, *next_iocb;
>         int retval =3D 0;
>
> +       /* Exit early to prevent race with queue teardown. */
> +       if (unlikely(phba->sli_rev =3D=3D LPFC_SLI_REV4 &&
> +                    !test_bit(HBA_SETUP, &phba->hba_flag)))
> +               return;
> +
>         pring =3D lpfc_phba_elsring(phba);
>
>         /* In case of error recovery path, we might have a NULL pring her=
e */
> --
> 2.38.0
>

Reveiwed-by: Ewan D. Milne <emilne@redhat.com>

