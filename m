Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B838E2BD0B
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jul 2026 09:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784970325; cv=none; b=S81Filuanoq6ucnHV1sP8KNO7bikNHDyPkA0ShFRojClr+8wRgBKB58Ay/Fds0S39rJN+rkkUdc6i0JdwmqWJo/xc/VaYKMwU0+Y3ujlA1W0BlXlrD4ZK8hfEldmNXhCH6CZukMUBLvW6TOktKQgj6lRapt+1iz0+jXMAPmB2gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784970325; c=relaxed/simple;
	bh=/29itB43A7t1GOGKR58qNVokZfI9wNIQK+ssl7COI6c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ATehBjREQ2QB6OJ87IK7x1gh8pd6yCjTFMfNXelCd+3n7PRFn8EtJ4uDIeaExq11Z/fOv2xPBSB/m0Zr0t1c9rbFcus2DSqarpHS3MZvXvcRuzwfcJl0Wo/My9QHZmt0Zj4lfXxv8Pwr0PyRnCo+BNDEO17DhAM7BmDJxs4SZT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBlICrjp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBlICrjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4254C1F000E9;
	Sat, 25 Jul 2026 09:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784970324;
	bh=zWi+q81yLVcDqu5LeKY+TLPyF2iFLnazZsDDrsodiek=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mBlICrjpzdK9d0l6/uv6+9CD3aw+H4R2q/PPsOXP7sTIq86vZO4W9DGRmX40zfR2K
	 pKuNE0zFZ7dCImZ35fatbNmJJVnORQChhNQu541RXABdY51udwMCeg+TVso/lSoJwX
	 opLeadNR7NiP14NZl3WlPsusPaIeTttiicUO8Ggr0blOcQCcBEaVxfNGTnizuVJHyD
	 +J3en3Ovle0DgnpjAXqkwRjxKsED+n9RZcV7hnVpdWIyRq+2fnK1xuSFXx0OnniiQ7
	 +oWPQ+5Ri2CbcU3M/AOPNJ8uf1CxKYiu4PRJx8cCONqJO6OaSi9AL++rKmTxc75dvx
	 XMW/2o2wfcY+A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: Fix NULL se_tpg dereference in
 target_complete()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260725084939.694403-1-yhlee@isslab.korea.ac.kr>
References: <20260725084939.694403-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 25 Jul 2026 09:05:23 +0000
Message-Id: <20260725090524.4254C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Missing `READ_ONCE()` on lockless read of `cmd->se_sess->se_tpg`=
 allows compiler TOCTOU race.

Pre-existing issues:
- [Critical] Incomplete fix leaves identical NULL dereferences and intentio=
nal BUG_ON() crashes unhandled in the submission and PR paths, allowing rem=
ote Denial of Service.
--

--- Patch [1]: [PATCH] scsi: target: Fix NULL se_tpg dereference in target_=
complete() ---
commit ffc7efb612d242d91429fd1154920a3b7603d316
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: target: Fix NULL se_tpg dereference in target_complete()

Commit a47fa41381a0 guarded target_complete() against a NULL se_tpg_wwn.
This patch adds an additional check to prevent a NULL pointer dereference
when se_sess->se_tpg itself is NULL after a session is deregistered.

> target_submit() reads the same chain (se_sess->se_tpg->se_tpg_tfo) and is
> exposed to the identical NULL.  That path has not been reproduced here and
> is left for a separate change.

[Severity: Critical]
This is a pre-existing issue, but does deferring these fixes leave the
kernel exposed to crashes from remote initiators?

If an initiator sends a SCSI command or TMR concurrently with session
teardown, the RX path could hit the same race.

For example, could this trigger the BUG_ON() in target_init_cmd() if
transport_deregister_session() clears se_tpg concurrently?

drivers/target/target_core_transport.c:target_init_cmd() {
    ...
    se_tpg =3D se_sess->se_tpg;
    BUG_ON(!se_tpg);
    ...
}

Could it also crash during TMR submission?

drivers/target/target_core_transport.c:target_submit_tmr() {
    ...
    se_tpg =3D se_sess->se_tpg;
    BUG_ON(!se_tpg);
    ...
}

Would it be safer to handle all se_tpg teardown races in a single patch?

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
> index fad03a15c969e..ee5781d894339 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -904,7 +904,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
> =20
>  static void target_complete(struct se_cmd *cmd, int success)
>  {
> -	struct se_wwn *wwn =3D cmd->se_sess->se_tpg->se_tpg_wwn;
> +	struct se_portal_group *se_tpg =3D cmd->se_sess->se_tpg;
> +	struct se_wwn *wwn =3D se_tpg ? se_tpg->se_tpg_wwn : NULL;

[Severity: Medium]
Is a READ_ONCE() needed here when reading cmd->se_sess->se_tpg?

Since transport_deregister_session() can concurrently set se_sess->se_tpg to
NULL locklessly, could the compiler refetch the pointer after the NULL check
and still cause a NULL pointer dereference?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260725084939.6944=
03-1-yhlee@isslab.korea.ac.kr?part=3D1
