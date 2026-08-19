Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7D038BF6A
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 03:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787110622; cv=none; b=L9sLiqqgkklX5mSyxcXfHFCel3olSpEmvYE3jdey7tiHsTHqysw9I3yy4IR+/X+RZC/E3N8lfm2Bv3fn5XpKOSw0tLBrEpoUNHD5bLhdQF01JgDjduId+1Rt48FpSeT/d77Ypbf1K8oDahduQTmaqb8TNNB351l7srdVpU31Tmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787110622; c=relaxed/simple;
	bh=fvWzo6fdALj6KjKBMKAlGbifuFa8SrJg+rFQCoceo4s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S8+c/Xs7l6U6UgYpUSEKm5f8FISezXs3hWUxVksaLHJFDYI7GyE4ysg8mLRgvMnnVNVpUU/QNp/hW9UHkwlvuOr4bdt9suQpVYtZY39Y2ZGwQ7fuhSntLTiwT6xj8+kBRwMUcKaey6JFiQAFnFX4jlnMN3FXunSfokUZYq5fGgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFTJoozk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFTJoozk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C5C1F000E9;
	Wed, 19 Aug 2026 03:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787110620;
	bh=QOxR3Zb3sxmbcPg6t2t9Z0ifmq9n53IYGHonYAfWEiQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eFTJoozkhPplZkUAUSJgog5f97u++juzF9m6ojXZPmAeb4C3liyX1lMBm/Z68h+/t
	 HceCpo+LwjncYXveb5hQnzQr7ZYYIzmLPXCrgzXu0jnNHyjRKL//BEDoFuw6POSbpy
	 Q/fvl5v5JMWcFHuZag37cyHwuwqSUfyN2By4XUR5+8J2qFfRZAxXgl9h7aQ2iXh7se
	 R3PIGDD4hYs9c6VvtXcP2ISxqvJDaFp5IDv+y1VSFg4eRD7ocngADmdBtoOO+/ui9s
	 wTw6VC6tNnSCkC9D9t5PNlZG86pqOPv4FPJxWAjoO7kE+N4IqA+QzYlihx5xhzlMR+
	 iRNY8h3Hh1TSA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/3] scsi: libsas: Handle errors in sas_set_ex_phy()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eshaan Deshmukh" <eshaan2031@icloud.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260819032321.493746-3-eshaan2031@icloud.com>
References: <20260819032321.493746-1-eshaan2031@icloud.com>
 <20260819032321.493746-3-eshaan2031@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 03:37:00 +0000
Message-Id: <20260819033700.87C5C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Propagating errors from sas_set_ex_phy() aborts the entire expande=
r discovery loop, leading to unintended and complete topology loss.
--

--- Patch [2]: [PATCH v4 2/3] scsi: libsas: Handle errors in sas_set_ex_phy=
() ---
commit 5c1f09068df832f5cb0e690bb6d4560d1c0cf52e
Author: Eshaan Deshmukh <eshaan2031@icloud.com>

scsi: libsas: Handle errors in sas_set_ex_phy()

This commit modifies sas_set_ex_phy() to return an error instead of
using BUG_ON() or returning void. It updates the callers of
sas_set_ex_phy() to propagate the newly returned error codes.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index f1a1417b09819..ab6afbad37feb 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c

[ ... ]

> @@ -220,14 +220,15 @@ static void sas_set_ex_phy(struct domain_device *de=
v, int phy_id,
>  	struct sas_rphy *rphy =3D dev->rphy;
>  	bool new_phy =3D !phy->phy;
>  	char *type;
> +	int error;
> =20
>  	if (new_phy) {
>  		if (WARN_ON_ONCE(test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)))
> -			return;
> +			return -EBUSY;
>  		phy->phy =3D sas_phy_alloc(&rphy->dev, phy_id);
> =20
> -		/* FIXME: error_handling */
> -		BUG_ON(!phy->phy);
> +		if (!phy->phy)
> +			return -ENOMEM;
>  	}
> =20
>  	switch (disc_resp->result) {

[ ... ]

> @@ -397,8 +403,8 @@ static int sas_ex_phy_discover_helper(struct domain_d=
evice *dev, u8 *disc_req,
>  		pr_notice("Found loopback topology, just ignore it!\n");
>  		return 0;
>  	}
> -	sas_set_ex_phy(dev, single, disc_resp);
> -	return 0;
> +
> +	return sas_set_ex_phy(dev, single, disc_resp);
>  }

[Severity: High]
Does propagating this error up abort the entire expander discovery loop?

If sas_set_ex_phy() returns -EBUSY (e.g. when SATA error recovery is active)
or -ENOMEM, sas_ex_phy_discover_helper() will pass that error back to
sas_ex_phy_discover().

sas_ex_phy_discover() iterates over all PHYs in the expander:

drivers/scsi/libsas/sas_expander.c:sas_ex_phy_discover() {
        ...
        for (i =3D 0; i < ex->num_phys; i++) {
                res =3D sas_ex_phy_discover_helper(dev, disc_req,
                                                 disc_resp, i);
                if (res)
                        goto out_err;
        }
        ...
}

Could this cause the entire expander discovery to fail and tear down the
expander if a single PHY fails to initialize, instead of just skipping the
problematic PHY as it did previously?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819032321.4937=
46-1-eshaan2031@icloud.com?part=3D2
