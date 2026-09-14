Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E7A1BD9D0;
	Mon, 14 Sep 2026 13:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789392317; cv=none; b=pimdLZ6+mbH6Uiu4BEWDp/TMFq/Za00LvmIJQ3VPx1jeZtq+92cbVQIRqJhGdqmsCGBztOntFNF63ySAcgYo/R8nrNaj1r4bd6pkxioXPRbUYpboD6dJfLRDtoCkLynNb5IX2AbaK6Ot+Y1MgbVv+J6Otfy9/zQC1plLHs7Jxas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789392317; c=relaxed/simple;
	bh=Ee4LgDKckiBTO+R2lJDbFQ5VWZgiQK0tmQ46MSH3o/Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r8xXI6ILcaYCK/T0zy/HFxM44XGTk4Ahq3QbxD9aFY9JAa6CFHPTYYPgi9lrAhouJbKFgF46x0S4bmRXkWu4Eq2XNqSjLG5b14EmJJA56/FEZzRJOMZHCVcKxxAUgs4hjpHG2FqQKNLJA09gSqYuQXH4BV8/6j4xKfOO2Urj1ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ur7g3YDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ur7g3YDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1811F000FF;
	Mon, 14 Sep 2026 13:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789392315;
	bh=zZc+xIHcFwMzzddzraJJ8lrGzjvEH1+rj3zm5cKudN8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ur7g3YDyx4/H+iQrNJduJ0DoJ+BNzNHdICjFnsL+AgZT5JwYDafxWTR+EFSLHgZ9i
	 HmJJKu+nIAnRRDcQmwaXU73EdXhaljLjdH4/sx770sOPlB82RKbhlYSUh9cDftE7yg
	 VP5P6QD10W96tU/cVARiewQS8NemmWicrYZlPOEy/ZwPCjC+Xw4liNzAz2V20l5/w9
	 ZPz1/2auNzzoT9qgAJ9/pfkWGnKdnlRPERsXlowvAH/Q9gx+h3uurW3Z1RZ3GvghrC
	 A8kW1tcwCqXCqKKo/KXMRrs6TXSOlZWAm9DiwZb3qEOuh6Z4kuU6ImhTaKitUSC6No
	 ecj8UqYlsF0vA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/10] ufs: host: Add common Hibern8 TX FSM polling
 helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Larisa Grigore" <larisa.grigore@oss.nxp.com>
Cc: linux-scsi@vger.kernel.org, conor+dt@kernel.org, robh@kernel.org, devicetree@vger.kernel.org, Frank.Li@kernel.org, imx@lists.linux.dev
In-Reply-To: <20260914125000.30812-4-larisa.grigore@oss.nxp.com>
References: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
 <20260914125000.30812-4-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 13:25:14 +0000
Message-Id: <20260914132514.AC1811F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The polling loop in `ufshcd_dme_check_tx_hibern8()` incorrectly =
conflates a DME communication timeout with the TX lane not yet being in the=
 HIBERN8 state, causing redundant retries on hard failures.
--

commit 36540d76db2dafb48398ab3a254711f31858e35f
Author: Larisa Grigore <larisa.grigore@oss.nxp.com>

ufs: host: Add common Hibern8 TX FSM polling helper

This commit factors out the common logic used to poll TX_FSM_STATE until
the TX lanes enter Hibern8 into a single helper, ufshcd_dme_check_tx_hibern=
8().
It updates the HiSilicon and Qualcomm drivers to use this new helper and
normalizes the error path to return -ETIMEDOUT.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 2ba244cf40ac7..e5facc0a59a79 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4448,6 +4448,84 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 a=
ttr_sel,
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
> =20
> +/**
> + * ufshcd_poll_tx_hibern8_lanes - Check TX_FSM_STATE of all TX lanes once
> + * @hba: host controller instance
> + * @num_lanes: number of TX lanes to check
> + *
> + * Read TX_FSM_STATE for every lane and verify it reached Hibern8.
> + *
> + * Return: 0 if all lanes are in Hibern8, -ETIMEDOUT if any lane is not
> + * (yet) in Hibern8, or a negative errno if the attribute read fails.
> + */
> +static int ufshcd_poll_tx_hibern8_lanes(struct ufs_hba *hba,
> +					unsigned int num_lanes)
> +{
> +	u32 tx_fsm_val =3D 0;
> +	unsigned int i;
> +	int err;
> +
> +	for (i =3D 0; i < num_lanes; i++) {
> +		err =3D ufshcd_dme_get(hba,
> +				UIC_ARG_MIB_SEL(TX_FSM_STATE,
> +					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
> +				&tx_fsm_val);
> +		if (err) {
> +			dev_err(hba->dev,
> +				"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
> +				__func__, i, err);
> +			return err;
> +		}
> +
> +		if (tx_fsm_val !=3D TX_STATE_HIBERN8)
> +			return -ETIMEDOUT;

[Severity: Medium]
Since ufshcd_dme_get() returns -ETIMEDOUT on a hard UIC command timeout, is=
 it
safe to overload -ETIMEDOUT here to mean "state not reached"? Could this ca=
use
the caller to conflate a simple retry condition with a hard hardware
communication failure?

> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ufshcd_dme_check_tx_hibern8 - Check if all TX lanes entered Hibern8 s=
tate
> + * @hba: host controller instance
> + * @num_lanes: number of TX lanes to check
> + * @timeout_ms: timeout in milliseconds for all lanes
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_la=
nes,
> +				unsigned int timeout_ms)
> +{
> +	unsigned long timeout;
> +	int err;
> +
> +	if (!num_lanes)
> +		return -EINVAL;
> +
> +	timeout =3D jiffies + msecs_to_jiffies(timeout_ms);
> +
> +	do {
> +		err =3D ufshcd_poll_tx_hibern8_lanes(hba, num_lanes);
> +		if (err !=3D -ETIMEDOUT)
> +			return err;
> +
> +		/* sleep for max. 200us */
> +		usleep_range(100, 200);
> +	} while (time_before(jiffies, timeout));

[Severity: Medium]
If ufshcd_dme_get() encounters a hard transport communication failure and
returns -ETIMEDOUT, will this loop blindly continue retrying instead of
aborting immediately?

It seems this could significantly multiply the timeout duration on an error
path (e.g., waiting multiple 500ms UIC timeouts) and spam the error log on
each iteration.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914125000.3081=
2-1-larisa.grigore@oss.nxp.com?part=3D3
