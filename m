Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793776346;
	b=xWkm/scskn9nmWP7AtpOMKbk/GES7ElXcAsn1SwklDN98EjglamUpyGkf7yljtnd1WzB
	 rn1RRyDQyxOt2DqPVicctaEZWe7MFuEv6InfzWFsqs51dmnMp9HTN3IED1ZjbvnxOcvA7
	 qVjCtiEvF7VPbeHsdkMX1uLAoiknAqDSNiChVKohoZlw0r4yCHRsP4o6MnQnhpXXcpDbf
	 Sdhci32dhPUpqjrRNiDDfGc5iIqp+92tciBr39H0RcpZie06DdOarTO0uJW0eb00fDZUk
	 saIPD+b5/ZkwrqIJMRyt+Hx0moTHduIxcDMDvTAdWNiJTam2Xw/s7RIljqLhxKvgLrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793776346;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5mkctKJi24HNG8RLNBXa9WT1XMaAtNZ7BZ4QTi0fATg=;
	b=YPsyx4vibHZZP9k9OoXoeHB+Eg1f2tQAZI+w1qAR3tKsk1uPQ7pzsYrJ4fM5FLkYLPT2
	 LVvsPUFDbUSeualM6IKxmMD2LM9IzCVG+IhiuoSlXajrbKP6mrl6fZIiTrlOS3oOECZSd
	 UPZ3GoOwcKMQs9TNrB7TdmNFmNutqJkwWqQxi/wsWqyPI0I7kCXiyaV/9O6EBI7lWfuMy
	 I+R3+9i/g4TOpH5frK/phbPtmHesRbnVvGUJc51J/Jpx3ab5j1/aUK+AJp+LGwZhlmjSp
	 0NlXI/SvWX4O1WFmc/UdEAIY8B5jzwcg49BUtyLTCNIYKBKRDrKYwvK9M+iXX553Jrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YudaiWrf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01222606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 07:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YudaiWrf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01B21F000C1;
	Wed,  4 Nov 2026 07:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793776345;
	bh=5mkctKJi24HNG8RLNBXa9WT1XMaAtNZ7BZ4QTi0fATg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YudaiWrfQNi2MnGl9w1sWUmRgLjlUqFFEtRVsOYkbRImovb8lKu+or2aKJ4iaZOdP
	 5MDDyELT7w5alJUZpWfUCZcjm/QAvpWDlRRkLDH7pZoIfsDyDhsNzRYg7OPOfYtcVi
	 cm678hUlGB5L4gM6mZN2z5nHHXUrN2NR9IvkFrUfQW8ekcBhRX2JFmQQLWMRMBRqxy
	 2jwbdhBgjF9LtpVwyfTXx2PIl9yqKhrp1cyknBOWlcxBBJr166fE34nffgoKBd465S
	 Stgx7L0I5SAlaLpLAAp1lZWrx7FpqB8WSwFsd1kF6cedHci3T9cCtnKC6mFmCBNny2
	 nwIY9oEMIp4JQ==
Date: Wed, 4 Nov 2026 08:12:22 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] scsi: mvsas: put the Scsi_Host when host setup fails
Message-ID: <20261104-chirpy-horned-mushroom-3f9a51@quoll>
References: <20261104021440.1468339-1-vulab@iscas.ac.cn>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261104021440.1468339-1-vulab@iscas.ac.cn>


On Wed, 04 Nov 2026 02:14:40 +0000, Wentao Liang wrote:
> mvs_pci_init() allocates the Scsi_Host with scsi_host_alloc() and, once
> everything has been set up, hands it to mvs_pci_remove(), which ends up
> dropping the allocation reference through mvs_free().
> 
> Probing can fail after the host has been added: scsi_add_host(),
> sas_register_ha() and request_irq() all jump to err_out_shost on error,
> where the host is removed with scsi_remove_host() but its reference is
> never dropped. A failed probe therefore leaves the host allocated for
> good.
> 
> Put the host after removing it.
> 
> Fixes: dd4969a892ea ("[SCSI] mvsas: split driver into multiple files")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/scsi/mvsas/mv_init.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Multiple things here:
1. Your team ignored completely previous feedback. Multiple times.

2. You use multiple identities with this email address, thus I doubt that we
   speak with an actual person.

3. Your bot does not even bother running checkpatch, right?

4. Nothing of this was reproduced nor tested.

5. Finally, the same feedback:
You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem (so a patchset grouping multiple patches with a short cover
letter), how to document the issue discovery method and what was
or was not tested.

Best regards,
Krzysztof




