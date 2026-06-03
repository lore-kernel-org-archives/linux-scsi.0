Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2594F3D9028
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2026 16:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780504272; cv=pass; b=LmUi408qOyBblzdAn6C/NZoqh4ykN1CaL/sSoTNGFnrKr99IYQ+w/Z3rJaKITQSzwXQupEsVdKJ06tKM6cHXXSAt23f28uUUdY09cxnUxAah8CCO2mbS+DtVLHjNtVDEHp29K3ySqpqwl0VjNu41i3JrfLLNIxBk/fZLvjLiFpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780504272; c=relaxed/simple;
	bh=GDbsJcs2QiLywbucMnh0d/gAmgm1aQxoL7ban/WLVQI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qa6oAQnNNkZvUgOPrT/4/mVe/vTxQC8qk7yn6HllZNSvmBs1Q4qbRgUOBaipIxdVL3IjlwX7xDIoIBtYPDMujmEYoxQHX8TcgRt6UxdOfoWYC9t+mkW2M1bRq4mPJZpOb4WqCd0TxJx+3BCeb3QIOX0uD8GnPQyv6fEsC2PXpFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gvIrX0ng; arc=pass smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gvIrX0ng"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-39677234558so43961581fa.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2026 09:31:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780504269; cv=none;
        d=google.com; s=arc-20240605;
        b=Niraumc+/eUERiOnbTOR58ObTbE1J9tkzCMGEtnm5ZHdhJWySLD9mia0fYa02Bo8wB
         we+PJCvRr4LbIF+gxf8wwsqGumaCe625JRDgosy3ltScajAfl6B6DC97UKkOMT3BwWoB
         UIah1By/GeHa7MhQj9WoHSNs6J0QKHqjWf9pzOODv5Da2PATqNEbiBurhqw0LKcPMnVu
         SutKqj9M3CbSjx9s9+NIm2kUPHxe+mVHp6yg1ZQzeIgV042PFcLy1/816gsDDHOImrf0
         9bC4PVh/xDh5IQbGB5UcJ2kRIiR11z3TU07OxgHpCDP+t5dqT+i2ibxmbvCAX+G33fBF
         gyzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sxfSZaF8do2hQPd38ry8GeKt7hfM6jV9CMwJ030Ibpc=;
        fh=P66mMhLz1nthv0j+377KwGF9HlleBdYIu6SC4zdI//I=;
        b=I7EUt5h2nCWic4nkOG1/XfgfS9bHd/1biXeShSi2svy9DVT9bupDR+Myk/dU0k20Ep
         QpaDYU+s/xqBaVT+FGud1qhOKE5ZeBXlnSUhTroRNCq/0SWzlxVQiXs3fPWoDT3VdAqR
         cHVEWs68HG1RahBGolO7w9Gqa33mEzt1ZQ9fxfETE0zpq7XtWnTD1GbVRKJe3WgYQYBU
         exPiWua2opXVY8Wtioln+pfrtZ7n2eVrLT+sqs+9ak4sYpwEeAZw4IoHJOL8TxzrjxfR
         ZPQ7HkLIZvKQGUs3BoX8/wdUKyYanwA70Hbjl8FTOCU+S22fDHBJqOAakuHjZWcOjbZF
         DnJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780504269; x=1781109069; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sxfSZaF8do2hQPd38ry8GeKt7hfM6jV9CMwJ030Ibpc=;
        b=gvIrX0ngerlepkqsb0tNKAo01NeEIhSGyCUDWunpHFcfkpQ+ITWr3T+h9/OsYLV54E
         EKJjXVmOcIwzUWiCTV8pjTQ6jouHNwzlBMlvqUoTZ5bgb8u5G73lSn6FPTsxQapBHznS
         fZsHguNEtHtFs+NlqDEBRqx7PTP2e7sXqYHwAeBsoEqvj1vKTTjm3PhFNBTDTkQh5b+I
         MvCUHT31W1qLwEo3Jn4MlkwwgSoRmQkq/vG/pxs6ZPiug2U0iNmylnhOrFBkSJ8oBgPi
         ivAIUFvy26fwb/RmJqBMf4c9sS+4/HflNuvu5AO/A/ezyQ3PWaBQ0E9Cj7/7PiAYgbPG
         kbkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780504269; x=1781109069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sxfSZaF8do2hQPd38ry8GeKt7hfM6jV9CMwJ030Ibpc=;
        b=qDccOWlURfR1/kHvNtv+NTGxaZ6JYeyCrep3m5I1Vn9PRZul4KIucKQwTOdaTrOGv9
         ipx5NcrdhjLsOVfs3jp5bneOkzCXH9vhNsoOVFksK938eNPE8mckYZSqdeJeZlQd6K9N
         x32P1eJC6gggMfnJhSULmhCNubeXDcACrfTNc+x0nanhjk1L09EfV6r3tWsdzcqiBJAY
         NER0AKmvBhnSrki42/HXArmwXuczmsYndTxsJczS6pA7luppfUd9btWLcXmYVS8Lj70S
         yZBf65oGbLZ+jb78th6iMuqEW6opkOXdA/KHRVqwaZ38dtbaGp/M3AM2txSnxO+aQ2Hl
         lnDA==
X-Forwarded-Encrypted: i=1; AFNElJ+GnNzp70JFMODbrirpQ6DOWXOcn5pgNpuzANi/Q9gZSHXrEmAtFm4EYGWGYyalI995IBN/2G7iqWrj@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxf1AealhaifwT+CcyjPaM/Xnl0Ud+nPKj48jhXeaawWCeHYtn
	saSv+0lqUfWR0iKowdQTrQdbmQ7wr+Eztf/NEDEdbGYzwcp1rYC7o5StzMOTeP1fz+xLLCF9zQ7
	NMgMU97sxKASHVNJn8Sce4cdssYGa8ndkHY0GW7zO9Z5tsSlkXFmSVw8=
X-Gm-Gg: Acq92OGPMJ8pC5zRvkURTON98tlWF2TewDhhNYHSHOW3PnYrlq61LUTqNcD1QWh7Mxy
	Us0F4w7aIlUsCYkPDa/TykDdPIY+tar0obqICinoAlT2ROEcb1tjPn7d/wMXlvobGWbobhhZzwP
	auSIs4++nYIqGT7bzNbgwnYsPDpzZVpPExPQoCcjf+5yRh6izFu1GIvycICmD0ttSapY/tYzgdq
	KJTZxj66ORJlRo7X0n80Pp1+DY1XUDOgKTSX55e/4qEYQkgZseGYSVkfrbuF+oP+rcvRjY9t69b
	XX9VdoZKRoVFLQTQqJ9jMNMw6SkujA==
X-Received: by 2002:a05:651c:150d:b0:396:7b8a:3da0 with SMTP id
 38308e7fff4ca-396af4d5d09mr14505761fa.26.1780504269294; Wed, 03 Jun 2026
 09:31:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260602115840.26490-1-ddiss@suse.de> <20260602115840.26490-2-ddiss@suse.de>
In-Reply-To: <20260602115840.26490-2-ddiss@suse.de>
From: Lee Duncan <lduncan@suse.com>
Date: Wed, 3 Jun 2026 09:30:57 -0700
X-Gm-Features: AVHnY4L4u7qOl5tCuqk9eSOmN2pRIjr0SC76D06SccNBNg_xh7kuL7DKkW_MY1E
Message-ID: <CAPj3X_XbHq3W0yozq6LWMom-m2jcWeGiwK=cbJKyns9UXEFeog@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: target: add extract_param_str() helper
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 2, 2026 at 5:04=E2=80=AFAM David Disseldorp <ddiss@suse.de> wro=
te:
>
> The existing extract_param() helper, detects and strips any hex (0x/0X)
> or base64 (0b/0B). This makes sense for some parameters, but not strings
> such as CHAP_N.
>
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/iscsi/iscsi_target_nego.c | 37 ++++++++++++++++++++++++
>  drivers/target/iscsi/iscsi_target_nego.h |  1 +
>  2 files changed, 38 insertions(+)
>
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/is=
csi/iscsi_target_nego.c
> index b03ed154ca34e..53b17d3cc86c3 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -98,6 +98,43 @@ int extract_param(
>         return 0;
>  }
>
> +/* same as extract_param() above, but don't interpret any type-prefix */
> +int extract_param_str(
> +       const char *in_buf,
> +       const char *pattern,
> +       unsigned int max_length,
> +       char *out_buf)
> +{
> +       char *ptr;
> +       int len;
> +
> +       if (!in_buf || !pattern || !out_buf)
> +               return -EINVAL;
> +
> +       ptr =3D strstr(in_buf, pattern);
> +       if (!ptr)
> +               return -ENOENT;
> +
> +       ptr =3D strstr(ptr, "=3D");
> +       if (!ptr)
> +               return -EINVAL;
> +
> +       ptr +=3D 1;
> +       len =3D strlen_semi(ptr);
> +       if (len < 0)
> +               return -EINVAL;
> +
> +       if (len >=3D max_length) {
> +               pr_err("Length of input: %d exceeds max_length:"
> +                       " %d\n", len, max_length);
> +               return -EINVAL;
> +       }
> +       memcpy(out_buf, ptr, len);
> +       out_buf[len] =3D '\0';
> +
> +       return 0;
> +}
> +
>  static struct iscsi_node_auth *iscsi_get_node_auth(struct iscsit_conn *c=
onn)
>  {
>         struct iscsi_portal_group *tpg;
> diff --git a/drivers/target/iscsi/iscsi_target_nego.h b/drivers/target/is=
csi/iscsi_target_nego.h
> index e60a46d348352..6b72edd2aef2e 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.h
> +++ b/drivers/target/iscsi/iscsi_target_nego.h
> @@ -13,6 +13,7 @@ struct iscsi_np;
>  extern void convert_null_to_semi(char *, int);
>  extern int extract_param(const char *, const char *, unsigned int, char =
*,
>                 unsigned char *);
> +extern int extract_param_str(const char *, const char *, unsigned int, c=
har *);
>  extern int iscsi_target_check_login_request(struct iscsit_conn *,
>                 struct iscsi_login *);
>  extern int iscsi_target_locate_portal(struct iscsi_np *, struct iscsit_c=
onn *,
> --
> 2.51.0
>
>

Reviewed-by: Lee Duncan <lduncan@suse.com>
