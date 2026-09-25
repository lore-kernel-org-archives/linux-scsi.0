Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24DC3EC822;
	Fri, 25 Sep 2026 17:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790357199; cv=none; b=GvSbkaNrDRap/RRb6MnO1hL1FRTuwOvPWSyZQbRQshbTLdw5ooBFxuO7insRVXNtoZABW/nGs1AGhBeTo/EeSWxXxGPFw4gpKUMSiVnJvNykKqYwc/NiOiLn3GebO47jXQqLYREy2QLyepKesT/MIuxazWYmbbJsOA6yjtawCF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790357199; c=relaxed/simple;
	bh=ZDIeDNrKSGITmzRvjeeUWbOrpGlqqvdGeO5BfxfjdZI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jPVwz7Wocrrj3PiskwfE5mzua2wr3XDyhzJR61kazeR7MZwjfy2lZe5C9hQMmm1msOrvApQz/VHYXqE/JQVIxFWFj0Mn1aHQpnhn2WFbzfFq/0uOe8iKyckAeut2m8PsktoTMR4EzeSk6XPJhZIVo941iwUyKf2L+PQ1wY6jCew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ckP3Vutd; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ckP3Vutd"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hryL50wwBz1XM4Tl;
	Fri, 25 Sep 2026 17:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:from:from:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790357190; x=1792949191; bh=QVplyjxbHwWiyaiEA6huSbJc
	eEv7U3L3IXN1wwGbOE4=; b=ckP3VutdDoFelpjshEu6fl/n+7dnf+oR3lBXNxl3
	zbU3N/BcjTqFswSuo0oUt4R6AlqF53BKkKNsarrRpqjXfM7kWgGZT2kWfPcbI8SQ
	ryFOGiFGXIbHbjA9GGNBOGG8WGrzlYJ4c3cEDEXjdxPNqMTNUsZrS7bD3jsybbhs
	XAeKXwNQiptBIHPGtG3pxNiEMUiVtNt8e+8XvSjWwGoa8EMSOX/+GkJRlAMdOdSE
	HHxgnmWZScKQvHe1+54jba7hy3zrYbQYqTjO6apmZxqx7TwcicPYbrVfa/YSVyGO
	6r+l9GSmFMXixs1wTOqwHf1z/eqD1NVcxdEvhMjF+wUTFg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uxZHYV3JltT7; Fri, 25 Sep 2026 17:26:30 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hryKt72Nfz1XM4Sx;
	Fri, 25 Sep 2026 17:26:26 +0000 (UTC)
Message-ID: <400fdf78-c021-4fa4-9024-6575e01bec89@acm.org>
Date: Fri, 25 Sep 2026 10:26:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
From: Bart Van Assche <bvanassche@acm.org>
To: Stanley Jhu <stanleyjhu@google.com>, Peter Wang <peter.wang@mediatek.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Can Guo <can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>,
 linux-kernel@vger.kernel.org
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
 <20260918143809.3034592-1-stanleyjhu@google.com>
 <20260918143809.3034592-3-stanleyjhu@google.com>
 <1ddc5181-f547-465c-bfbe-dbf14a91493e@acm.org>
 <20260920135014.3528082-1-stanleyjhu@google.com>
 <e3538f10-fb9e-48ce-b48f-bca25c8f3d6c@acm.org>
 <bab059b9a2dfed258db23993b5a6b4aceca2da49.camel@mediatek.com>
 <df31eb82-7211-415a-9ec1-53ecbc3e39b0@acm.org>
 <f116f82d28f7af4cfca76adf5cff6093fdf393a2.camel@mediatek.com>
 <CAE14pdfbxX7BWzKg9z7ytB9rZPAp40ipXk8NPOdAp2Jv7eq6Xw@mail.gmail.com>
 <eac2f886-61af-4b3e-b237-88d59cc4eab3@acm.org>
Content-Language: en-US
In-Reply-To: <eac2f886-61af-4b3e-b237-88d59cc4eab3@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/23/26 10:02 AM, Bart Van Assche wrote:
> On 9/23/26 4:18 AM, Stanley Jhu wrote:
>> Would DID_RESET be a better fit after a controller reset (including
>> ufshcd_eh_timed_out() right after ufshcd_link_recovery()), similar
>> to mpi3mr_flush_scmd() and mpt3sas's _scsih_flush_running_cmds()?
>> It reports what the driver actually knows at that point without
>> pulling the command into the SCSI error handler.
>=20
> Calling scsi_done() from a .eh_host_reset_handler() implementation is
> not allowed because calling scsi_done() for a command that is on the
> SCSI error handler list corrupts that list. One of the functions called
> by scsi_done() is scsi_complete(). From that function:
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0INIT_LIST_HEAD(&cmd->eh_entry);
>=20
> This corrupts the command lists maintained by the SCSI error handler,
> e.g. work_q and done_q.

A correction: the INIT_LIST_HEAD(&cmd->eh_entry) statement is not
reached while SCSI host recovery is in progress because
SCMD_STATE_COMPLETE is set for all pending commands before the SCSI
host recovery starts. scsi_done() skips SCSI commands for which that
bit is set due to the following code:

	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
		return;

Hence, the scmd->result value is ignored if scsi_done() is called
while SCSI host recovery is in progress.

Bart.
