Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E985F1D5ABA
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766622; cv=none; b=r93Nxde3X4mgvSGEq2RShUFC87hIE1rPi5EABGSV5eQpFBK8znPpcNYomAK5B8IvsgPEJNcNedYbjPrmrVmaf8tkoRs/VoYVRLYYDCBKAztyZANEs6YLM0Z8J/JF+Ct9dazD12HpK4tfGrYwYSqqNKDcZgAyZT4BVl4TfOSYghQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766622; c=relaxed/simple;
	bh=1Kz5hxqSy9A0KQPE+aJIK+enjCYLQRp1eTrXUSRIuzc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CZtesFH9EXAa8noAOkG8lUTgTwiA2A5ai8RmBwXP7id6vJwrx09/caVMxXUsEWt+WdgTUNy4Z/neW9f0djOszP7eC3gSAtrtrme0xJLeyS8IvB69f4TJS4zDuDZq7C/u0PPLYWStth7j8uJl9/VDdzaRyjAr9Lw2PsFTgeL2XKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TF4B5fsR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TF4B5fsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5714A1F000E9;
	Thu, 23 Jul 2026 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766620;
	bh=WwpZiBTsl7yWPyEoEzm4SB3gpDitveTQZKymZUx+wME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TF4B5fsR87d3go/YNyyBZr7YyaE4eyb9Un46s1Y1SoVWlps55MOa4pTAQ38smKPBY
	 r5wYvVAjyBpgaTLO47houo8GjcDy3ndw/ooT5bJvjUhtrO6NJlgqhMgGXcl/N65ITp
	 NR2o/g+a3/dwGyxbJ0fYb+672hLK5pK0iHgK3aJ8jOjaQUfOnMlKC7WP26v5XzvYLo
	 3zeN3Fp9OKPXwZysm+1T4r21sk4vykF+8+vXtYnIqph7reBVtl7lcaS/kv+TrBvAfg
	 U21NW9F03vs8rcqWgYkAuRCDhI4WrgPZgl0gUyxLntFl4eNTyiJWbTq0nCSFrClD7Y
	 BafsDDiP+vavA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/33] ibmvfc: check for NULL evt in implicit LOGO
 and target delete path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-4-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-4-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:30:19 +0000
Message-Id: <20260723003020.5714A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The error path added for a NULL event attempts an invalid state tr=
ansition to IBMVFC_TGT_ACTION_NONE, leaving the target stuck in IBMVFC_TGT_=
ACTION_LOGOUT_RPORT and potentially causing an infinite host reset loop.
--

--- Patch [3]: [PATCH v2 03/33] ibmvfc: check for NULL evt in implicit LOGO=
 and target delete path ---
commit c8380c3ff6514fe4df58a3ad3f0363eddb03454e
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: check for NULL evt in implicit LOGO and target delete path

Adds a check for a NULL event in the implicit LOGO and target delete path to
prevent a null pointer dereference in ibmvfc_send_event. If the event is
NULL, it escalates to resetting the host.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index 72317d7840a53..59102dd1c7878 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -4406,6 +4406,14 @@ static void ibmvfc_tgt_implicit_logout_and_del(str=
uct ibmvfc_target *tgt)
>  	evt =3D __ibmvfc_tgt_get_implicit_logout_evt(tgt,
>  						   ibmvfc_tgt_implicit_logout_and_del_done);
> =20
> +	if (!evt) {
> +		vhost->discovery_threads--;
> +		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);

[Severity: High]
Will this state transition succeed? Looking at ibmvfc_set_tgt_action(),
it appears that transitioning from IBMVFC_TGT_ACTION_LOGOUT_RPORT to
IBMVFC_TGT_ACTION_NONE is silently rejected by the state machine:

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_set_tgt_action() {
	...
	case IBMVFC_TGT_ACTION_LOGOUT_RPORT:
		if (action =3D=3D IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT ||
		    action =3D=3D IBMVFC_TGT_ACTION_DEL_RPORT) {
			tgt->action =3D action;
			rc =3D 0;
		}
		break;
	...
}

Since this silently fails and leaves the target in
IBMVFC_TGT_ACTION_LOGOUT_RPORT, does this cause ibmvfc_dev_logo_to_do()
to continually return 1?

If so, the discovery loop could get stuck infinitely retrying the logout
and triggering continuous host resets. Should this error path transition
to IBMVFC_TGT_ACTION_DEL_RPORT instead?

> +		kref_put(&tgt->kref, ibmvfc_release_tgt);
> +		__ibmvfc_reset_host(vhost);
> +		return;
> +	}
> +
>  	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT);
>  	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
>  		vhost->discovery_threads--;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D3
