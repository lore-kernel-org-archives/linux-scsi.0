Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921E220DD51
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 01:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783990819; cv=none; b=CEMEctR5OqWyOVYs5qQ89heHdlyUlGcv2EAgnppSUJJEw1BaBBnsDVtXGWg1osLbYfM3HY0pUcLRLWCAO0OC0xtc+tYZiWBl7Tok3jXOH8nMizzZEg3luif1awq+CACLDOVHImJMpkL0mPOXXKSTk+pZoAcTth40xInrAYuLdec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783990819; c=relaxed/simple;
	bh=nb0TpljrHGlHnL/1tlpmna/l1veBdPQ0C/ew0f713v4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I3EEb0F2G+04yo+8gabjLNWuS36+wTP8kOFYSNhUDomt6JMvySXrWng6/sz3G1iurSthrSoRckUEicL0dto/t0paHt81ijKCtR2+P2GP3FIBpXBvhmPAkKiCgkb6vhOfA376r3USfos86xz4rrEuUq7jyCxaEN5PyGcmaQYqhxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMQwm3I6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMQwm3I6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5DC1F000E9;
	Tue, 14 Jul 2026 01:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783990818;
	bh=SVaBABUyeLwGDv65AApGRrcJ0gIM68oZZ7grzkkV058=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GMQwm3I6NHO31ul4VBwjsQdLjO0Jn97K3quT34SiKng8Sxdt+ZCK9sOvp39mZ84rL
	 TMCjPhILSbKj1p1bq0cUd3Ow+55y2qQ5IBxkci7gj5UQlr4uxuUMF8aJ3tIQlKQwMM
	 lzRyqDtceyfIL2qKsDh8vaCZAT+ULt3ywudbU250S7TFm2EWvSOUiT4k9yaYJc0ASj
	 pQkT9pxyeP50dNwlSHm6eV0tUJdOYKWFhHo4xQDiOaQpy1imLq5UL1FMjo5LM4lSUD
	 QiVm/ykG3YOPJ8p2oL25jTOEETnHtk0mN9rF7U027XZqhpYcvGZSZXOKns+Yz3u61L
	 nRRkMKcz6eYjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 13/14] lpfc: Refactor calls on fc_disctmo to
 lpfc_set_disctmo in RSCN handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Justin Tee" <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714011812.106753-14-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
 <20260714011812.106753-14-justintee8345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 01:00:17 +0000
Message-Id: <20260714010018.0E5DC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing memory barrier in open-coded lock causes NULL pointer dere=
ference.
--

--- Patch [13]: [PATCH v3 13/14] lpfc: Refactor calls on fc_disctmo to lpfc=
_set_disctmo in RSCN handler ---
commit 1b8710fdf36e956919fff9a52e4a58021de35371
Author: Justin Tee <justintee8345@gmail.com>

lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler

This commit refactors discovery timeout timer handling in the RSCN handler
to use lpfc_set_disctmo() instead of modifying the timer directly. This
ensures discovery timer actions are properly logged and visible.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 0a7e69dcb2dbe..0c5524c613e57 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c

[ ... ]

> @@ -8497,11 +8494,9 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct=
 lpfc_iocbq *cmdiocb,
>  		set_bit(FC_RSCN_DEFERRED, &vport->fc_flag);
> =20
>  		/* Restart disctmo if its already running */
> -		if (test_bit(FC_DISC_TMO, &vport->fc_flag)) {
> -			tmo =3D ((phba->fc_ratov * 3) + 3);
> -			mod_timer(&vport->fc_disctmo,
> -				  jiffies + secs_to_jiffies(tmo));
> -		}
> +		if (test_bit(FC_DISC_TMO, &vport->fc_flag))
> +			lpfc_set_disctmo(vport);
> +
>  		if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
>  		    !test_bit(FC_RSCN_DISCOVERY, &vport->fc_flag)) {
>  			set_bit(FC_RSCN_MODE, &vport->fc_flag);

[Severity: High]
This is a pre-existing issue, but could the lockless updates to
fc_rscn_id_cnt and fc_rscn_flush result in a null pointer dereference?

In lpfc_els_rcv_rscn(), new rscn events are added to the list and the flush
flag is cleared without memory barriers. This happens in both the defer pat=
h:

vport->fc_rscn_id_list[rscn_cnt] =3D pcmd;
vport->fc_rscn_id_cnt++;
...
vport->fc_rscn_flush =3D 0;

And at the end of the function:

vport->fc_rscn_id_list[vport->fc_rscn_id_cnt++] =3D pcmd;
...
vport->fc_rscn_flush =3D 0;

If the compiler or cpu reorders these stores, the updated fc_rscn_id_cnt and
fc_rscn_flush =3D 0 could become visible to other threads before the new
pointer is stored in fc_rscn_id_list.

A concurrent thread running lpfc_rscn_payload_check() might then see the
incremented count and cleared flush flag, but read a stale null pointer from
the array:

for (i =3D 0; i < vport->fc_rscn_id_cnt; i++) {
        lp =3D vport->fc_rscn_id_list[i]->virt;

Would it be safer to use smp_store_release() when clearing fc_rscn_flush,
or add an smp_wmb() before updating the flag?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714011812.1067=
53-1-justintee8345@gmail.com?part=3D13
