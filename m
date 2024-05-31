Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA15200B7;
	Fri, 31 May 2024 21:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717189849; cv=none; b=pyoQfbtdrNZ/Qa2kk37MKDDm39zHQe33kmfqAcvHKYveT5OTAUs6SD0SbuoJsghvqlPFqGaBuSqT7Ktol1yaO/Pc9fCVhCT+h5OKE+xer6CzxdDULymWlVKcz3BchWMZNHs5a8rM4aI7nIH7N7zMMAZZLt1ujW15Oj2uhbs2adY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717189849; c=relaxed/simple;
	bh=xlaiIZVQpnoQLjq8KYZChb3XAXfcj6FcTOal5RecnCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lpCSr7wVCHaKY/FnlarQ7ZUIEG7qLyCDhb6vryKJSC8+zJEKj6prp8bsN+FcTbdyMNd+n5E4FRt2S6pwC+bDp74smjFZ2wnBjfDwdDWBYAzPMuhCyCl1xX9Rphq35BrZlfKYDbExJtxFl7j21maaOVfSMfBWEq0BtG71tkvS1bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JBMuE6+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBMuE6+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F6AC116B1;
	Fri, 31 May 2024 21:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717189849;
	bh=xlaiIZVQpnoQLjq8KYZChb3XAXfcj6FcTOal5RecnCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JBMuE6+/4uK+TfBRp2VQ6gOoUwebGVgcqfhkoGHoUJefQqxh51QCzFI3Z5dbVWeLD
	 1+Ha3PBzT2cZZ2kOrQAjGytheeq4zZw2jArSBrd0pZBvsyH6gBFr5vo8V9/k79eMHj
	 rS+wliQZ4+w6cNAXFlLmFUMhyC4P+3Gb4PiJCKhJUiga77YamxslvCAy6Z0CtJUQSp
	 LPQkiDQGV/M7AHdsKb8BBMobicc3+8zROKqAmKU/TxWZL7t2+PdnyNRYcEl8qad5yy
	 aVZgYR2KWthC1Gt+72WCMsvracEBsCZ283+kvtfTazzYMTTizVHOwglKyqE8pTF2Nd
	 LwGpAGJcspjkw==
Date: Fri, 31 May 2024 15:10:45 -0600
From: Keith Busch <kbusch@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, leit@meta.com,
	"open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <MPT-FusionLinux.pdl@broadcom.com>,
	"open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <linux-scsi@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mpt3sas: Avoid test/set_bit() operating in non-allocated
 memory
Message-ID: <Zlo81SBdvflQ_38O@kbusch-mbp.dhcp.thefacebook.com>
References: <20240531180055.950704-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531180055.950704-1-leitao@debian.org>

On Fri, May 31, 2024 at 11:00:54AM -0700, Breno Leitao wrote:
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 258647fc6bdd..fe9f4a4175d1 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -8512,6 +8512,12 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
>  	ioc->pd_handles_sz = (ioc->facts.MaxDevHandle / 8);
>  	if (ioc->facts.MaxDevHandle % 8)
>  		ioc->pd_handles_sz++;
> +	/* pd_handles_sz should have, at least, the minimal room
> +	 * for set_bit()/test_bit(), otherwise out-of-memory touch
> +	 * may occur
> +	 */
> +	ioc->pd_handles_sz = ALIGN(ioc->pd_handles_sz, sizeof(unsigned long));
> +
>  	ioc->pd_handles = kzalloc(ioc->pd_handles_sz,
>  	    GFP_KERNEL);
>  	if (!ioc->pd_handles) {
> @@ -8529,6 +8535,12 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
>  	ioc->pend_os_device_add_sz = (ioc->facts.MaxDevHandle / 8);
>  	if (ioc->facts.MaxDevHandle % 8)
>  		ioc->pend_os_device_add_sz++;
> +
> +	/* pend_os_device_add_sz should have, at least, the minimal room
> +	 * for set_bit()/test_bit(), otherwise out-of-memory may occur
> +	 */
> +	ioc->pend_os_device_add_sz = ALIGN(ioc->pend_os_device_add_sz,
> +					   sizeof(unsigned long));
>  	ioc->pend_os_device_add = kzalloc(ioc->pend_os_device_add_sz,
>  	    GFP_KERNEL);
>  	if (!ioc->pend_os_device_add) {

Do we need similiar ALIGN for _base_check_ioc_facts_changes() too?
Otherwise, yeah, the {test,set,clear}_bit() ops expect an address to
something aligned to 'unsigned long'.
