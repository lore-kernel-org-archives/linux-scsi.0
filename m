Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9763AF4FA;
	Wed, 12 Jun 2024 03:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718162715; cv=none; b=W9iQRHce7Ot8s0R1dXC7oHLTj5FKUwqXmekadJ7Xi72tRvLazt+RcXi9xDmoMUfsMdwd08esfIS6pmiyBdgNsxRjrnnb8VcKEHXF9vmflRBM+LlZYbE++ns4epMDxCo17a2BNcryE2W5kF3nN6+v3GsX439ZcGa1LiFKE6iX+Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718162715; c=relaxed/simple;
	bh=D1U+G4onHlDfogwfgFIJk0wV2H9L/FftKrn9+bnW70w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uCKlc4eaNpdE2N946EN2RxBVTybbaqW0yDw47ZO5vE8XGfAfneJqCetrF1zvhW4s0jDfE5kpu6l7AOX2O7aErfvbtq1q0Rm3/s/JzkgiG9oR1f1U0rr+OU95WEKk/fzmHHl1p28Vv0gPkotESFBiQw2aB9gv35hPrCbmLkLkWJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=n+Nd94wK; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="n+Nd94wK"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VzWBc52P8zlgMVP;
	Wed, 12 Jun 2024 03:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718162708; x=1720754709; bh=75qnYbD2r13ahqm8NfDmHboF
	heSaMP4KwJLN/K3LkuM=; b=n+Nd94wKx4w7NuRcJqizFBmMaBpI8Ua1GX6exx2N
	7BewA/j0f3PsipyzJzdPArcv65yJsEKe/9idTbEStwbYb1GqKp5ZRt/SCybhF40M
	/Rj/o0nXOL54Tt6mZFDaKEGqAgea8YITrnlXfiP903fL1N5LbdH1muF/O2WLW3c3
	jXbLKHRBluqRMjbvjAo62W7BqiFaJAuqFcy2/7edYbDpX/pq5/OPDvsyCBTW/xvs
	uVlcB3/bFFkkBNmLjwRXqLPJBz3aF758T+ByajtsO7EdAnNC64FDuwu5qYKwqA3A
	j/4u/9SKFajhsifRH6RlHn5GU8w7Cv1xsF4mSTScVi2Kpw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cdO1AAjvbdhz; Wed, 12 Jun 2024 03:25:08 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VzWBR730dzlgMVN;
	Wed, 12 Jun 2024 03:25:03 +0000 (UTC)
Message-ID: <3fa79262-f4ca-4f87-b174-9087a5d18a43@acm.org>
Date: Tue, 11 Jun 2024 20:24:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: Support Updating UIC Command
 Timeout
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, quic_cang@quicinc.com,
 quic_nitirawa@quicinc.com, avri.altman@wdc.com, beanhuo@micron.com,
 adrian.hunter@intel.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Stanley Chu <stanley.chu@mediatek.com>, Peter Wang
 <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 open list <linux-kernel@vger.kernel.org>
References: <cover.1717104518.git.quic_nguyenb@quicinc.com>
 <f3fded35cb250e16ee5aaa67d7a7288fe2799fd7.1717104518.git.quic_nguyenb@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f3fded35cb250e16ee5aaa67d7a7288fe2799fd7.1717104518.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/24 2:36 PM, Bao D. Nguyen wrote:
> +enum {
> +	UIC_CMD_TIMEOUT		= 500,
> +	UIC_CMD_TIMEOUT_MAX	= 2000,
> +};

Since UIC_CMD_TIMEOUT_MAX has been introduced, please rename 
UIC_CMD_TIMEOUT into UIC_CMD_TIMEOUT_DEFAULT or UIC_CMD_TIMEOUT_MIN to
make the role of that constant more clear.

> +static unsigned int uic_cmd_timeout = UIC_CMD_TIMEOUT;
> +module_param_cb(uic_cmd_timeout, &uic_cmd_timeout_ops, &uic_cmd_timeout, 0644);
> +MODULE_PARM_DESC(uic_cmd_timeout,
> +		"UFS UIC command timeout in milliseconds. Default to 500ms. Supported values range from 500ms to 2 seconds inclusively");

Default to -> Defaults to?

> +
> +

A single blank line should be sufficient.

Once these comments have been addressed, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
