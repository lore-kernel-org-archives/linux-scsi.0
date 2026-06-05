Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAF93290D9
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 16:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780675489; cv=pass; b=KUEREAQctLHYGl2/cUIF2bf80JFK5KEmS7My6mSSzX2LTc9ebXEF9isd8IBleSTuC8Nf2UtfHuqYgPWBDUJsBY1ExWJeL/Moc9rOS7eHryqWg2pml2qM0vbi5Bh24vyiFB4mymOSd8k6vqVWE/veBO25AT96+P4ZFm1GLJLJrPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780675489; c=relaxed/simple;
	bh=LG8J/R+2eufDNwIl81kPJGrTs5zv+E3jtTsi0TpUf2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I0vPI+l6n8YST62Cxq/O8L7TCJIveBI127NqlPlpO5ZM37J7NIoOzgEUsgu9Vpj0g65VAK7X8bCOOcLuDM1LdyraLLWXSskUKFs+kE3t1wDSBrpS1vC4grNhK1kFF2WJL7mvbhSMy3svrWRkM8QxX/W13NpnVMw2I5THuOS4QAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Cv8Lu6JC; arc=pass smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Cv8Lu6JC"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-396753f343aso21998791fa.2
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 09:04:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780675486; cv=none;
        d=google.com; s=arc-20240605;
        b=AJBYXE/mb6p7qkdeKlbOdzzVfRq/KoTyHjr13cP3mTfMoaVk/qo2hi79ZMscPrOQ9Z
         JY3YUI4NPcFfyCJr3+l8g3ksY0XKtO9jZ6p27wOmsXTCWNiinp0Fzzrs+1xBb0g9dtLQ
         VnJ7SYKU10/9To+zUgmw6vdsPMkllDaPAgLWwegisJDa/c0jYnHXuLN6W1G6mp/A6DwG
         OFgi1L+Crj2pUMbZsDeTMzSmv/0Fjs9ek/OtlqdCXzb6P7zuNxq4fMZXCrsHc05MOizi
         FhJilpdmMRyqFUEJ11JdGp+DwOs02QEHuUZOUaDazA+F9MuHd9ofOhnvkQjGUYKcQ6oN
         oQQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Vm/ss87izqfP/0U05LwE7pPzc4bfkP4ilQm2LP62OvM=;
        fh=F1nnWtY5V79wguKyAENFGOKWBR0iSoQT2io3ROLg/1s=;
        b=M4Dt6iBvrgXpxD8UEc7kXGcWWI5fnEWketOVS5dO8gKslDfM8BRDPXHm5EwKeQwtdE
         ve6ruGnOReUSqp0TQYQjM7gYHwIlPTRZPAtl7uddsGOuhNsLIdwrkWWExhFfO1mnKn+6
         OE1eirJ7k1GLPbPCgmbYSQSi7qPbnIuDEBqmT7L4L5ji5/Ubf/lh1hjxsIEAT/eBAIbq
         ChTA+ddblJjqAEpEIsdKLtcf3GOlLsVL+NVSSyHR7dDmIiM4gLNwuzYME7mic6dFQvK5
         bebIt/1mwhrgNMiAOSCIn1trcuH9rdjAcvqO1czJ4l3rvgrSHPvip4Br0k/etLDJgfl2
         TeHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780675486; x=1781280286; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vm/ss87izqfP/0U05LwE7pPzc4bfkP4ilQm2LP62OvM=;
        b=Cv8Lu6JC5XtyxQIsfqjw9APdSzUn3k3L0GM3Fs3LxCqwoDc5s+poIN7gKPHR4G0NUK
         ZzdnM9l8Gl/JJaV4RecX2IPwVXqOIAsMuDtE/5v5mrbqqBR736sZMZZAr9YYyQf2zXJY
         AtFLp5ghh6O+zoSqJdVwXSr1caC9A38Pd+A/HAsUNoJfbBMAwscra6t1LwD+JWVrqqjl
         BVRe12xPmEVB3848m5fqVuCeC+J39Fx6VcOv5Jp6fir3p1eTIdg29zBnF9bW/FFgHsXi
         4Omk3p+ewDYOf8VZL0ZG3lX481gL+i1a04g9GLZ7a9n2YduAvkSBkbPISfIpdPpGNoGk
         vuKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780675486; x=1781280286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vm/ss87izqfP/0U05LwE7pPzc4bfkP4ilQm2LP62OvM=;
        b=V150iDBcejJSppNaUGk33YkAmeaLx9NDQdEJH9KlOXBYMpHEu0gCo9GbdFfPUQmIEx
         wa7pouzqRWvJSKfVq51m+p4ywPjBqCXfD/ZW/mGSnx8a60kCdWfk1lo8rpl3/YjKvq12
         /tNmt/a2dkqbziSq6xez9f59reSD0YjsSM8HMG6y134YfL/LSsMS/TTyrh5ztZPoEMF0
         t5GolCJ9gbkTfSuwQtN/hgLeuo4St0JwWS4Mf3mecSaRG2fRRWHFugTRw30LxvWy+U7f
         PsfTH8zQ9KU6UlrFXmhANfrFny15Mb1xNCVtIvs19DncnW7rdeHxW2Uy1aPe13Ki1jao
         colg==
X-Forwarded-Encrypted: i=1; AFNElJ91jfhJhpO3svq10UeZlsyc3gjeamKHE2qw9dwrdaxjFQIwLUYU/FuZO5+vz5x6QaTas+lEl7UhUE2N@vger.kernel.org
X-Gm-Message-State: AOJu0YzSRg9qWTI1JdNiBXMVFi2sTlvZHhLa9gjJatHMK7FNc/BnYZ8m
	xgyE8ZrJ8sfhwtrSUkBEovxIuhe/xr37/OEoVyEF4U5LWN6QV6zWPRZJ4QSr+Eq5Ah1qYM6UmBm
	GeLoyhBysIG0WL24XRLmibfm/IE5ObzAltslZGblgVqkkXdxiGHWrHmg=
X-Gm-Gg: Acq92OG8/coYoyZZWUtdzNyzG/rksYEuNkk7lRZeDu9X/9SlHbvIgisZy7yaofjKV/B
	FjOtXr8K6uyfzrvStbMl3oqIgXZMEu1EWxMe4+u7OINbNkX3mJj/Dsoxl7DB2owwc0Xz0/NBJI7
	Pv38WTZClrn3Rk3K9kE64xqG9Glk9M24cXwjMMdhQa15bv/4rTxvRE2aPJ+QkUBg9vqBOruABB4
	pUrQBf7S+5ArLNiG6yzA60SEElvYj5z4K2S1G/UzyyktRNXqg3MqpDR0vV+6xBlVE8HXSZ/v7sp
	8h1r7cuU49rBTq9mD0s=
X-Received: by 2002:a05:651c:2226:b0:396:6bd5:a9c9 with SMTP id
 38308e7fff4ca-396d0951cc0mr13180741fa.20.1780675486192; Fri, 05 Jun 2026
 09:04:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260605122019.24146-1-ddiss@suse.de> <20260605122019.24146-3-ddiss@suse.de>
In-Reply-To: <20260605122019.24146-3-ddiss@suse.de>
From: Lee Duncan <lduncan@suse.com>
Date: Fri, 5 Jun 2026 09:04:34 -0700
X-Gm-Features: AVVi8CcJBFVxH8_a3drKGpbHpoIuI2zt32jQkrprudoFvbnSYf69bqjmgG0S-LM
Message-ID: <CAPj3X_WHMQZTZ7UBv99_H5Gv8UVxcKzgdzW2OWv+ez2ocwfp_g@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: target: use constant-time crypto_memneq for
 CHAP digests
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 5:32=E2=80=AFAM David Disseldorp <ddiss@suse.de> wro=
te:
>
> A constant-time memory comparison is more suitable than plain memcmp()
> for authentication digest comparison.
> CHAP digests use an authenticator-provided random challenge, so any
> timing side-channel shouldn't be easily exploitable.
>
> Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
> Link: https://sashiko.dev/#/patchset/20260521151121.808477-1-hossu.alexan=
dru%40gmail.com
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/iscsi/iscsi_target_auth.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/is=
csi/iscsi_target_auth.c
> index 5858cc3089796..f3c0cdd318300 100644
> --- a/drivers/target/iscsi/iscsi_target_auth.c
> +++ b/drivers/target/iscsi/iscsi_target_auth.c
> @@ -9,6 +9,7 @@
>   ***********************************************************************=
*******/
>
>  #include <crypto/hash.h>
> +#include <crypto/utils.h>
>  #include <linux/kernel.h>
>  #include <linux/string.h>
>  #include <linux/err.h>
> @@ -408,7 +409,7 @@ static int chap_server_compute_hash(
>         pr_debug("[server] %s Server Digest: %s\n",
>                 chap->digest_name, response);
>
> -       if (memcmp(server_digest, client_digest, chap->digest_size) !=3D =
0) {
> +       if (crypto_memneq(server_digest, client_digest, chap->digest_size=
)) {
>                 pr_debug("[server] %s Digests do not match!\n\n",
>                         chap->digest_name);
>                 goto out;
> --
> 2.51.0
>
>

Reviewed-by: Lee Duncan <lduncan@suse.com>
