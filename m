Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D32D1DDA18
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 05:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790312945; cv=none; b=KpQBfLWfzgyGieBKegCSWb2LpCzg+RFdI+xqMpfXiEETd+auyylNTtB60mtX99OxojBqzjZTlqNTDknXiWf7ere9Wu9Yn7kTvz4HlDSxtAToeyD9Y5+LIUgjZg7ussnOf5dvfwZsIhkNvJ+Wj9JO1MM1HQyH0q6x3U7G4X01M6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790312945; c=relaxed/simple;
	bh=W7P8M28tD1OTcooe42zog4JMccMoMDaoVMo7OxDUvLw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RkA5Ou8wB/JrDqGGnUG6fZEnjaYb1Wyia0UrpXC6baNGKOdD9unG0BCDEDEFUEuoJCD9l+dmFeTZMtrrQQaUG6D9rpLalqr4t4FP4epdpVhanR17Y0MJyK1DONNe5i0ir0vMcUs5f+iVmRi9ZfFagi+tDRGmxd03h2E2EtvttP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1VOvWf6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1VOvWf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEC21F000FF;
	Fri, 25 Sep 2026 05:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790312944;
	bh=7XEJj9+aQY/yVJv0NZuBQQoDMyEisDIVdvTMLMNwYt4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H1VOvWf623Slq4e9VAx8h/Nyl8sRH9IDiIMQnHEShSR/wywQ7PIBsVhaW1BWpHoUa
	 PgGvKnrMx4y46ehopa0pn1fOniCUG4TOJdISaRU/HodTtu9gqGTYHdfZQAEqpo7RIz
	 pX5tELLCDy3cYJf6OwaLcaV8pYZVDgdscDt6Yh2MB35hK4wld8kaQIpe4nqavcQTYe
	 bE9a+/PBVFrZnEFm59i1NPBXH1MbdhK26KxbkxDEzveV7uki9scSela+RXAx6ImxxS
	 MpoiOgYfdG6c1H8ehMCEXNxnph7NH+/0RMzKDossXeYcYbEVsTt8KYgKIi9cJ95qZB
	 U7ZOUP+C8WrvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 10/11] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260925044900.414340-11-tyreld@linux.ibm.com>
References: <20260925044900.414340-1-tyreld@linux.ibm.com>
 <20260925044900.414340-11-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 05:09:03 +0000
Message-Id: <20260925050903.EEEC21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: double registration of scsi_scrqs and missing async_=
scrqs registration
--

commit d44dbe8300fc3639dbfcef8f1950443462606f5b
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub CRQ for events

This commit wires the async sub-CRQ into the sub-CRQ lifecycle so it is
allocated, registered, and freed alongside the SCSI channel queues.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -986,6 +987,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_ho=
st *vhost)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> =20
> +	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
> =20

[Severity: High]
Could this introduce a regression where scsi_scrqs is accidentally register=
ed
twice instead of registering async_scrqs?

Because the first call was added as ibmvfc_reg_sub_crqs(vhost,
&vhost->scsi_scrqs), it appears to skip the async sub-CRQ registration
entirely. This leaves the async sub-CRQ permanently disabled after a CRQ
re-enablement, which could prevent asynchronous event handling (like FPINs)
after recovery.

Also, wouldn't the double registration of scsi_scrqs cause
ibmvfc_register_channel() to fail? If H_REG_SUB_CRQ returns an error for an
already registered channel, this will abort the registration and clear
vhost->do_enquiry =3D 0, functionally breaking multi-queue capabilities dur=
ing
standard operational recovery paths.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925044900.4143=
40-1-tyreld@linux.ibm.com?part=3D10
