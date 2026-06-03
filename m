Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EFF436369
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2026 16:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780504236; cv=pass; b=OShvglI3HWK1RQOYQtwQRu6w8aB7aCKCohxXdBgvxTgd3XHVyO9r/sl+4XWBCuTjKjMFFlXYzkkaJRFTRRy8SgTxZeDXafF+Yg7ZaY5aqajSUCkmMRWTqoOoEeFFXMUjkaeSfrkrGljQ09LIVB5BDLULRXmKTCFWbAokZIeMhq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780504236; c=relaxed/simple;
	bh=MGjyHAboyvKunuPMYx+1O58h1Rnay/E34EqctC7+rsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q7xh3TV0vav0eVjK9R6iri6W5rC715Dr/d1QnWlWTKn87bq7feCTu9YyS/JdtKmOsz8+XOOTYSl6hjov+fWMZBWqDnq9+uARaKxx+6alx9QqK+sBySy/19LNGqUKhdfihIqE5G53ibdk6B0/OCskYSCoWp3+nR2TLDlW6xinr10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CG5dssQO; arc=pass smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CG5dssQO"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3966388b388so9915351fa.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2026 09:30:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780504232; cv=none;
        d=google.com; s=arc-20240605;
        b=W6cdEA1Nf6EE10nB6e2OaTkMKXVvAC0rkeNpFlz8nt+u+7GAw2mHG8NUYxHt23SPrH
         pTRddvTi257MFGb5wgqsvIRv/vzGq3L1Lh7G+tFLjmLV1AfRfXH7OQygHLuUps+FcML1
         DUu8OoXfXaV3pEJqZ17hi56u5MOekqyP/+SFjlYf6y1vi4HtjoEgToWLKaSKbVsJuC24
         REpzPhRC/PzcucXQ8Pl2gvgPt1dMaEriWqyzjFNCzBxsvXCGM9k9IGCcP+jZtYMi2UXh
         sIMkC1c4VY/FbWywkDrD0W2KTj7zljlVGpMJGxg+VMd7yRvo3ahV1d+M0u8kqp9YfrGG
         mt8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XoEOVYrB6znHXj9h4Z3nSLM94MZ4hDg42P6x3cwnbBU=;
        fh=XKetfoYxAe6VUYTVM97rZqqbfznHtXVCvA9Vo6m1wVs=;
        b=S30AtJITSeETuQApfdNpv0cB09EQUnT5Utu+iN/njji60rn2UfN+FalRAfKQD32cED
         scY/AcFlyFk1bYxExwMLDXNsjy+L5kNRVS5xSlAclocJT07E9wsAF5LNDHWXMzYn/FB4
         dUPJXLCEuBIwPJUFl97Xa7jjXPHVv6cQGTlUKZA0nA4GW18iwXLSFnreotjE0rivJETr
         yNvFxkPlnmA1KhefLVK/GeU1vDAHzpFgtKZQWjcaQP+Mp/BxI1I5pl1j8uT7Kkx1gkE4
         YMOSzzEUnO82oh/5TuruCyd6p93HUASaiJmRbWUpaXePaD1ju/ZpsKx+HaG49tt2Yc3g
         /+qw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780504232; x=1781109032; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XoEOVYrB6znHXj9h4Z3nSLM94MZ4hDg42P6x3cwnbBU=;
        b=CG5dssQO0+XXNHVw8KrQr6CIpkZgYUTF8oG5Gq9SBTdFrebDZfFzGhFH/ehdishd8g
         F+Q9RX0cgVJRRifcEte+xqLugfD/rSPresdRsoxWZAZogpwAugSqNpOic0gZANlPhI8F
         1vy2PIFSlHwuJpCGKb0WHPSQPnBYWhcWzROfD+tWvSAQGzZxnF1OXgozkLBrWE5fnUrl
         1jgrSJx3uJtsEEf5RxL6kLuK71XH4qNUvFtrhkQysa849JzOwlw35RGLk/Ebt9JRBAWJ
         +tdL8fCpG1OJ9cUKATwwPcquby2rF20Nj+Ub/8TWZC0QdPw6IDLe/+zXfa6DrYN9Er1X
         DTBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780504232; x=1781109032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XoEOVYrB6znHXj9h4Z3nSLM94MZ4hDg42P6x3cwnbBU=;
        b=rqo17FqLrHUoqBE8m0xPguokHhC8BwCcD9hLs1YIOqcfcW3U/dKCZ2K8DOUNYqmiUn
         MXK/ifTqAtNArmfek6s/L2BbnSNNsh0hQucbS8S2ft6EuiMrTllzohlUDciASUoudd+4
         fSlgJzq0RG7hSAymOZmhSkTeODFC54nnXrk7C00ip9BvZtOik0iLlyA8O3OXJeVf3RN7
         8oQloM6EUJe0zB42ggXvqi+diIB5Msf4VMsNcV62yGUDZVzoTj6kiJIs2tfbXf3vUHBr
         9IRfVqn0zVDQZYyJKk6ZonuTXrHH/oS93aWuGxYpsGvnXKy4GoCj3h7AzELblJeeOsze
         5v3Q==
X-Forwarded-Encrypted: i=1; AFNElJ8AQd8lMpJC3FhH9mfZNnoUOWWdizCD9cw0PFjm266DSoRZbxF1Jfk6NILw4n+DpCrfmLYRI1/nAzE+@vger.kernel.org
X-Gm-Message-State: AOJu0YxN8cZOg9MFhwiYInZdafyL3t/n6xHkBa0wTSBSqU7NwesmhJCr
	SDG5KfvUeNzTpii+ysqq9vv5de6DJ78QVuH/8V1mWJHX/XMCJjPa1s+W1Eflmrb78uVC+PbaI7T
	LCuit/9ViDw7cyurAn+PWbkNYi4RoDgsS0ICiB3C6Dg==
X-Gm-Gg: Acq92OEu0O6YuHmY4sx8AZVkdryKvJuBOCPZC7ucws/V7f6zvM70RrKJ3fE0JRlURWw
	RXapFHZ/4tjI7/eHhF3VEx67OgyoY8Uha5tFrKAiUMkw+6sLwfSS55Ffrxi9wqPciGmZ622D1D/
	HiiFiTlkzmRsdRsPMo3qWDkWy14uHawJ+7oXHdW3RlvxDxZ8bQBhHRbXklyNplEQaK/t/Jq9pRP
	bSrMrugamtf8smMJYV1NfzspGwsbJLnwFjxqcBUPHfxDpe/sTn6Gk8hVSDdeoBjZ11qRKY9H/2C
	9bYui+wIr7kQ02woPb3D+aCw4eCzcA==
X-Received: by 2002:a05:651c:2115:b0:396:711a:dcb9 with SMTP id
 38308e7fff4ca-396bbaeee4dmr312821fa.16.1780504231815; Wed, 03 Jun 2026
 09:30:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260602115840.26490-1-ddiss@suse.de> <20260602115840.26490-3-ddiss@suse.de>
In-Reply-To: <20260602115840.26490-3-ddiss@suse.de>
From: Lee Duncan <lduncan@suse.com>
Date: Wed, 3 Jun 2026 09:30:20 -0700
X-Gm-Features: AVHnY4K8fEmdPNDZXjCK3g-EVU3HYTqV94mC9U4cLBGZG90M1vb2BXJytEjQwC0
Message-ID: <CAPj3X_U11zY5yHEw6xE4AET2zSzhG+EXRuWH0cKHKwgG+Hz1Uw@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: target: fix auth when CHAP_N carries a hex/b64 prefix
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 2, 2026 at 5:04=E2=80=AFAM David Disseldorp <ddiss@suse.de> wro=
te:
>
> Attempting to authenticate using a CHAP username with a '0x' or '0b'
> prefix currently fails. This is due to extract_param()'s behaviour of
> stripping these prefixes, and the subsequent (type =3D=3D HEX) error-path=
.
> I believe this behaviour is contrary to the RFC 3720 specification,
> which states:
>
>   5.1.  Text Format
>   ...
>   text-value: A string of zero or more characters that consist of
>   letters, digits, dot, minus, plus, commercial at, underscore,
>   slash, left bracket, right bracket, or colon.
>
>   11.1.4.  Challenge Handshake Authentication Protocol (CHAP)
>   ...
>     CHAP_A=3D<A> CHAP_I=3D<I> CHAP_C=3D<C>
>
>    Where A is one of A1,A2... that were proposed by the initiator.
>
>    In the third step, the initiator MUST continue with:
>
>       CHAP_N=3D<N> CHAP_R=3D<R>
>    ...
>    Where N, (A,A1,A2), I, C, and R are (correspondingly) the Name,
>    Algorithm, Identifier, Challenge, and Response as defined in
>    [RFC1994], N is a text string, A,A1,A2, and I are numbers, and C and
>    R are large-binary-values ...
>
> "N is a text string" implies that any hex or base64 encoding prefix
> should not be interpreted or stripped. Fix this by using the new
> extract_param_str() helper function to obtain the CHAP_N value as-is.
>
> Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
> Link: https://sashiko.dev/#/patchset/20260521151121.808477-1-hossu.alexan=
dru%40gmail.com
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/iscsi/iscsi_target_auth.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/is=
csi/iscsi_target_auth.c
> index a3ad2d244dbee..6f21075e58416 100644
> --- a/drivers/target/iscsi/iscsi_target_auth.c
> +++ b/drivers/target/iscsi/iscsi_target_auth.c
> @@ -303,12 +303,8 @@ static int chap_server_compute_hash(
>         /*
>          * Extract CHAP_N.
>          */
> -       if (extract_param(nr_in_ptr, "CHAP_N", MAX_CHAP_N_SIZE, chap_n,
> -                               &type) < 0) {
> -               pr_err("Could not find CHAP_N.\n");
> -               goto out;
> -       }
> -       if (type =3D=3D HEX) {
> +       ret =3D extract_param_str(nr_in_ptr, "CHAP_N", MAX_CHAP_N_SIZE, c=
hap_n);
> +       if (ret < 0) {
>                 pr_err("Could not find CHAP_N.\n");
>                 goto out;
>         }
> --
> 2.51.0
>
>

Reviewed-by: Lee Duncan <lduncan@suse.com>
