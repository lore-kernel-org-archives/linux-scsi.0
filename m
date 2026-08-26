Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3C431619C;
	Wed, 26 Aug 2026 15:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758430; cv=none; b=OV41jwH2VZTZk1xMB1CDGzZKmYkbcF77JgafgixLtUIBHLy5GRphUQytzO70rMyR7Cflz9MEW08hGBCqRLLa7UcR9MhSCtF2x7lzAPMnCjMnLLoPaSuFE8pVkmqpKCbXDV9U650bwr/feFXPEdU5149vcYLO97HlXUmAtIr3EzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758430; c=relaxed/simple;
	bh=JNDhiCmo1PLLV2dqHybuWvzXZSHjC+BZT0SYn6XU2J4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OwsKdBDgTmqtVmJ9KgmEcnU2l/5aGxWu3vmL04ezer0lKxyBTkqCF3GhdgMMbrG+ZxXufBfrC6yTvDBdeAnGW7m1GdOD72DPsgs15PNuN87t4qzLsIpe8rFphW88+OsQSAfy9G+wwBNRJlWD61iYgAL1TjGf/FCYyk4WOXhdbsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QEQXZXAM; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QEQXZXAM"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hVTFk4Yp2z1XM4Tn;
	Wed, 26 Aug 2026 15:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1787758422; x=1790350423; bh=yA7IlEbhpc5JZOb1B2LTaWZG
	zNPT/IaVr/dVDVaDels=; b=QEQXZXAMTQgkZcw3A5aKtdAX0iPLxTrjOadJgBrX
	tSxI4sNod7uLDWVOB9NI8xLVMzONRF9EPdN0eATggLnyyY3bNAkpfVcBM7bQqGXd
	H3DP89khJyvDxn2OFOjPfQCgkxzDXV5NiRyOOAB0j4Lbf4fPmYXrfbC+9UyMcDUG
	/ZNdJXZFjTVtxc678l1RAWGziRlLoxVZG/TKNhqGKsx7kfuf36egdv5l2aaSgvD8
	FHeoEvtzg0djvMQawtSJNgXtAPkJ6FQGhma4KukKpCJZU66bcRbt9GTmL9VL0XfY
	KXJX3u3YAFfEF5jm+42uXxrREtbbdcCIVyUTce6eb0pz6Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id azxD2R4YC4av; Wed, 26 Aug 2026 15:33:42 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:f6e3:ef81:c380:703b] (unknown [104.135.182.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hVTFc2kFlz1XM4Tl;
	Wed, 26 Aug 2026 15:33:40 +0000 (UTC)
Message-ID: <4af1df20-f6e4-4559-9cc0-e4db05597090@acm.org>
Date: Wed, 26 Aug 2026 08:33:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] ufs: host: Add common Hibern8 TX FSM polling helper
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
 NXP S32 Linux Team <s32@nxp.com>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-4-larisa.grigore@oss.nxp.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260826134048.854748-4-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/26/26 6:40 AM, Larisa Grigore wrote:
> +	for (i = 0; i < num_lanes; i++) {
> +		err = ufshcd_dme_get(hba,
> +				UIC_ARG_MIB_SEL(TX_FSM_STATE,
> +					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
> +				&tx_fsm_val);
> +		if (err) {
> +			dev_err(hba->dev,
> +					"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
> +					__func__, i, err);
> +			return err;
> +		}
> +
> +		if (tx_fsm_val != TX_STATE_HIBERN8) {
> +			dev_err(hba->dev,
> +					"%s: timeout waiting for lane %u to enter HIBERN8, TX_FSM_STATE=%u\n",
> +					__func__, i, tx_fsm_val);
> +			return -ETIMEDOUT;
> +		}
> +	}
Instead of duplicating this code block, please move it into a new
function.

Thanks,

Bart.
