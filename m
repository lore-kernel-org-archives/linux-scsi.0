Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1BD36A37B
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 18:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790619552; cv=none; b=tL9Zmfla5XlQZkGeifBpJohLUtNs1n8u6DwDE8Uc2bndlELbPX6xs0KvJX6KrLXdtjV4+EqoDGgUUFc9s5OSTMCO8opu9O7B71zaJ5eH+BQJu4XXdV5f+3WAuzVPxvgv4nG5QXP/jiWyZ+hxZJHz/8ylmHF9FU7ylUsM9SCE6v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790619552; c=relaxed/simple;
	bh=M/i3Ds4NATKR+ryE2ZEqp6abBIbMgc/2eKbR9e9qqi0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Th5fioMpEgSXvCtbIvJUQt3ibhzi1NFGAVpXkkpb4eEi0k8GjYHa8GvwV3C3S6vi+Rby+gjj/9b208FAJfuWleYX/yPmiTCsBmfOAoqHJGAEfDmjZkxaIQz+t7NkUuzyUrBKTuHKu2VbsQemx5OQ8xb0ykq+Uctnimu726xsAS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUWz+CXe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUWz+CXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B127C1F000FF;
	Mon, 28 Sep 2026 18:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790619550;
	bh=yM1GUFuofJM+596vtUb3T6DX22dO/TARyDLH9zMUQO0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BUWz+CXe4Q1nIwYfjUeSOMX8K6J4IigNYahe1S8bKES5lKtCGQ2rNqUcCFOqg9Ipk
	 rM+nutXmemmGOsaXx2Q79DQX91KsInvJnfT6etuW4UsbY57Z1aQtADW/GI01dvc7IL
	 8j6vPejg29ysda/19m8sbpX+p1IOr8T1P3T6j6VOD2g6bDJImpoerULYRVUVqW9wYV
	 aN0q2c5B2Fozu351vZB2fiOUZbXoUR7lUgYwZCghB7kaB8DJZWS4l5SetpaK430AEE
	 CFI4+ha4WyWXZ70O5A385pt/SbrlO24fz1/h0GgSxLauhxW7dI76D+B6Ot/48Z6g51
	 8g3QkVyWvIhkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 04/10] lpfc: Check fc4_xpt_flags before decrementing
 ndlp kref on FDISC error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260928181757.21959-5-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
 <20260928181757.21959-5-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 18:19:10 +0000
Message-Id: <20260928181910.B127C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] lpfc: TOCTOU race in lpfc_cmpl_els_fdisc() leads to Use-After-Free
--

commit 46ec54ed5cbeb514e9e9362594a41ca2f9b3aa3d
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error

The current initial kref count drop logic for an ndlp that fails FDISC
assumes that the ndlp has never registered with transport layer and thus
the lpfc_dev_loss_tmo_callbk never called.  However, a failed FDISC can
occur after a successful transport layer registration too.  So,
lpfc_dev_loss_tmo_callbk can occur and there is a potential use-after-free
on the ndlp.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 6f6394a0047c2..45aad4cd2dc80 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
[ ... ]
> @@ -11427,11 +11426,22 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, stru=
ct lpfc_iocbq *cmdiocb,
[ ... ]
> -		/* drop initial reference */
> -		if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
> +		/* If have not previously registered with transport layer and no
> +		 * LPFC_EVT_DEV_LOSS work pending, then drop initial reference.
> +		 * Otherwise, let the dev_loss_tmo_callbk drop the initial
> +		 * reference.
> +		 */
> +		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
> +		    !test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
> +		    !test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
>  			lpfc_nlp_put(ndlp);

[Severity: High]
Does this lockless check introduce a time-of-check to time-of-use race
condition that could lead to a use-after-free?

If an FDISC error occurs concurrently with a devloss timeout for the same
ndlp, lpfc_dev_loss_tmo_callbk() could execute on another CPU:

CPU1 in lpfc_dev_loss_tmo_callbk():
    set_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag);

    spin_lock_irqsave(&ndlp->lock, iflags);
    /* ... */
    ndlp->fc4_xpt_flags &=3D ~SCSI_XPT_REGD;

Because set_bit() lacks a full memory barrier and spin_lock() provides only
an ACQUIRE barrier, could the clearing of SCSI_XPT_REGD become visible to
CPU2 before NLP_IN_DEV_LOSS is seen?

If CPU2 is executing this new check in lpfc_cmpl_els_fdisc() locklessly and
without read barriers, it might see both SCSI_XPT_REGD =3D=3D 0 and
NLP_IN_DEV_LOSS =3D=3D 0.

Could this cause CPU2 to erroneously evaluate the condition as true, execute
lpfc_nlp_put(ndlp), and prematurely drop the initial reference, leading to a
use-after-free when CPU1 later tries to use the ndlp pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928181757.2195=
9-1-nkirkland2304@gmail.com?part=3D4
