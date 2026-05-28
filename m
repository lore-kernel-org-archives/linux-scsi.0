Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754052E739B;
	Thu, 28 May 2026 16:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779984190; cv=none; b=pxLudlJg0GqYvJ4HjiB8bXkCkqcAPDN8vIwxP790DLLMBODLD29RxttMIDqLjlqqzd7tI6neNBDU1xH8KKbpvxI3Cy+mHA1NbKyVP280GNsycEwQ7mXc5iDiqziAZasdjmn61P38ieFqGhrmeoDw8xwckc2Khi4mw7holFoU/8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779984190; c=relaxed/simple;
	bh=AGCflnh/AeLI/JsGPwJB/dWf9w3yn00jqy3CQAFl0zA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WhSArk/8V8EjkStezy8hRtNZW08mr4+B8v19GYvtbdheCIYJlpW44/xjNks9fyu9PSQJR7usegeo1v5Id0HiV1TGip+TsKH14Jpw8yEaC87nzVTQz29KrJdQfiavaozrOGIEh281Hxzr+0NlX1002YNaB+bCCscBSSYUD1HxpHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=te3tBCfm; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="te3tBCfm"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gRB926nnwzlh2rl;
	Thu, 28 May 2026 16:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779984175; x=1782576176; bh=D6mZFXOVW0fz1Vm3i9+LgeTQ
	dwXyn8Syn3kRDstNWo0=; b=te3tBCfmNwqK5FJMrK5MVSZVezFFj/WUBLtvaVA5
	pTUJgs/9/IXqvnVLBg266FUmRe5B1S2j2lOFVNBAbnf7uqrjgL+zX4+LoYb+iKwU
	Z/X2UYHvVZ8nFI9qYHlP3xaSAo4aUqGY2FaHe2av9HqBNuEuuE817dFvYAKydfzt
	U546Xb83cA7G9s8pd3IgEcZug6Nx6MFhuoybPt0BkcY0JeFJC+plTUtp4yBrdVZK
	KlzuL0uiwHyOCttTNVDOd8vRhHzdhg1wRwphskTS2uP/7v7+JsT25JW+nIw7IsOl
	zrGbiDV2qV2skSwrzFcsOtRbEnLM59ulM6nfx2O5zAa11g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hWgLC0Zo1v3e; Thu, 28 May 2026 16:02:55 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gRB8r272hzlfpMB;
	Thu, 28 May 2026 16:02:51 +0000 (UTC)
Message-ID: <312d0eca-108f-48af-a1b9-a5dcc24e70fd@acm.org>
Date: Thu, 28 May 2026 09:02:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: Can Guo <can.guo@oss.qualcomm.com>, beanhuo@micron.com,
 peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
 Nitin Rawat <quic_nitirawa@quicinc.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260528100614.3386423-1-can.guo@oss.qualcomm.com>
 <20260528100614.3386423-3-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260528100614.3386423-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/26 3:06 AM, Can Guo wrote:
> +static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba *hba)
> +{
> +	size_t sz = hba->lanes_per_direction * 2;

Please mark constants with "const". Additionally, is "sz" a good name
for this variable? The code below compares "count" and "sz". I haven't
seen it before that a count and a size are compared with each other.

Why "size_t" as data type? u32 should be sufficient, isn't it?

> +	u32 lpd = hba->lanes_per_direction;

Is this another constant?

> +	if (!lpd || lpd > UFS_MAX_LANES)
> +		return;

Should a kernel warning perhaps be issued if lpd > UFS_MAX_LANES?

> +	for (gear = UFS_HS_G1; gear <= UFS_HS_GEAR_MAX; gear++) {
> +		snprintf(prop_name, MAX_PROP_SIZE, "txeq-preshoot-g%d", gear);
> +		count = of_property_count_u32_elems(dev->of_node, prop_name);
> +		if (count <= 0)
> +			continue;

The body of this for-loop is long. Please consider moving the body of
this for-loop into a new function to reduce the indentation level of
the code.

> +		for (i = 0; i < count; i++) {
> +			if (preshoot[i] >= TX_HS_NUM_PRESHOOT) {
> +				dev_err(dev, "An invalid TX EQ PreShoot (%d) provided in %s property\n",
> +					preshoot[i], prop_name);
> +				break;
> +			}
> +		}
> +
> +		if (i != count)
> +			continue;

The traditional way in the Linux kernel for breaking out of a nested
loop is using a "goto" or "return" statement.

Thanks,

Bart.
