Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA25244C4FF
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 22:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789683054; cv=none; b=Ejs9SJ/TfsPUJZOCECPwaMP5dTzLaMXiMj70s4rWl1wvIssWmnUvqqL8eKsTEFqswtmOBGU9cAagkJSTI8hIoh4jLLx4y5yxVQUgHXep0vSVPueoZ2a6JtS3E7mGADhk7uCFWiQAnt6DeJiX1WNJ4bL/siLxk9pxIiiJvABOMtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789683054; c=relaxed/simple;
	bh=Gp7rE0E+549dajlKFQIDmbANgSQPxyxg17DFLRc7RjE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M2Uk2vCmi09ApNVSbEQ6uxXK99JkoajbbR4Wm8TzUxf7/+BoRD7DIYhwiP7AfzgZopuHol4hZUIWnQ1JAwD0wT5cqRBNZshvU8cDAE96ySvFSCMBITdaYpXKzYOrxquCXZxogzV8lbB3LnXLwCxZNzFxc4MK2QjRi0o5uuAxts0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UwRFDM1+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UwRFDM1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250F11F000FF;
	Thu, 17 Sep 2026 22:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789683053;
	bh=D+8igVe5h6uHQtUsB46Pnk0kvLzdlD5m47+N1jVuynI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UwRFDM1+VIMqfjyoOEn8L80h5OkY3QADlSpd5nN6Pi2U2PSpYCo2XCQH6VaV8XMYO
	 Rt4iGqSnDW4O3v52HYNRvCb4ZEgTDS68Cq1UuE7RjmWGY7+XQN1tcRuKZd/0RQJIP3
	 VOd4wbDWOxWCbg9xueGZ7egwiDRSqn0o6tTCNJw3PH/eyOAxjVtedh5RRIvRjWsREC
	 KUu/WNO56TX/iF28umAuO91BNTqqdAe6oLqqACKT6D9tKPJqdju/idlTBdK52hz3iy
	 dY8HZpy3B3ZlWpLRx4FyoCG3FFUOBfEl+Nv+JaMHzbOl+L+37skcsoMHCwAhxNSKC2
	 +awkCxWNZxmAQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/14] lpfc: Fix ndlp use-after-free during repeated
 RSCN and rediscovery sequence
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917222015.61053-7-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
 <20260917222015.61053-7-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 22:10:52 +0000
Message-Id: <20260917221053.250F11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: lpfc: Use-after-free in NVMe unregistration due to missing s=
erialization
- [High] scsi: lpfc: ndlp memory leak due to concurrent registration race
--

commit 6da5a3b652f8d5c08807e25e9db6e426dc7022ff
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery sequence

This commit refactors how registration state is tracked by separating the S=
CSI
and NVME transport registration flags. It introduces new wait flags to track
unregistration and a new flag for NVMET target nodes to address use-after-f=
ree
issues during target port failovers and RSCN storms.

> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hb=
adisc.c
> index 4c673dffa671b..b4a5c7d5c2a0b 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
[ ... ]
> @@ -4623,7 +4632,10 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct=
 lpfc_nodelist *ndlp)
>  	lpfc_check_nlp_post_devloss(vport, ndlp);
> =20
>  	spin_lock_irqsave(&ndlp->lock, iflags);
> -	if (ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
> +	if (((ndlp->fc4_xpt_flags & SCSI_XPT_REGD) &&
> +	     !(ndlp->fc4_xpt_flags & SCSI_XPT_UNREG_WAIT)) ||
> +	    ((ndlp->fc4_xpt_flags & NVME_XPT_REGD) &&
> +	     !(ndlp->fc4_xpt_flags & NVME_XPT_UNREG_WAIT))) {
>  		/* Already registered with backend, trigger rescan */
>  		spin_unlock_irqrestore(&ndlp->lock, iflags);

[ ... ]

> -	ndlp->fc4_xpt_flags |=3D NLP_XPT_REGD;
>  	spin_unlock_irqrestore(&ndlp->lock, iflags);

[Severity: High]
Does removing the atomic test-and-set of the registration flag here introdu=
ce=20
an ndlp memory leak?

If multiple threads execute lpfc_nlp_reg_node() concurrently (e.g., from
repeated RSCNs), they can all pass the registration check above while the f=
lags
are still cleared. All threads will drop the lock and proceed to call
lpfc_register_remote_port(), which will unconditionally increment the ndlp
reference count via lpfc_nlp_get().

During unregistration, the SCSI path correctly prevents double unregistrati=
on
by checking SCSI_XPT_UNREG_WAIT, so it will only drop one reference. The ex=
tra
references taken during the concurrent registrations will permanently leak.

> =20
>  	if (lpfc_valid_xpt_node(ndlp)) {

[ ... ]

> @@ -4706,16 +4728,11 @@ lpfc_nlp_unreg_node(struct lpfc_vport *vport, str=
uct lpfc_nodelist *ndlp)
>  				 kref_read(&ndlp->kref));
>  	}
> =20
> -	if (ndlp->fc4_xpt_flags & NVME_XPT_REGD) {
> +	if ((ndlp->fc4_xpt_flags & (NVME_XPT_REGD | NVME_XPT_UNREG_WAIT)) =3D=3D
> +	    NVME_XPT_REGD) {

[Severity: High]
Can this lockless flag check cause a use-after-free on the ndlp object?

Because the flag check happens outside of ndlp->lock in lpfc_nlp_unreg_node=
(),
multiple threads can concurrently pass this check and call
lpfc_nvme_unregister_port().

Unlike the SCSI unregistration path, lpfc_nvme_unregister_port()
unconditionally sets the NVME_XPT_UNREG_WAIT flag under the lock without
verifying if a concurrent thread has already set it. Both threads will then
call nvme_fc_unregister_remoteport() and lpfc_nlp_put(). Since the ndlp
reference was only incremented once during NVMe registration, the double
lpfc_nlp_put() could result in a use-after-free.

>  		vport->phba->nport_event_cnt++;
> -		if (vport->phba->nvmet_support =3D=3D 0) {
> -			lpfc_nvme_unregister_port(vport, ndlp);
> -		} else {
> -			/* NVMET has no upcall. */
> -			lpfc_nlp_put(ndlp);
> -		}
> +		lpfc_nvme_unregister_port(vport, ndlp);
>  	}
> -
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917222015.6105=
3-1-nkirkland2304@gmail.com?part=3D6
