Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D611202C47;
	Tue, 18 Mar 2025 21:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742332890; cv=none; b=J8cHv8grAsp9fA98L1++ng3fF8/i3N9aVqhqtufZF3zi5MFKqLnTlyBSuL4GJg7ojH9N7JL2G7+c26IDWTi4xfBhnY7bWc0WeXl9zobF/uEYZOwr+YPvCWai8yzuVxzKOCjiaTe/ySIzC7AQbygWX9TwiWjPxNzAts43ZTOf6KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742332890; c=relaxed/simple;
	bh=simiyBjg3exoQdZ0BTUwEIUE35EK4+HTePrCAKei17M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C2AfNIV8FrL/dEArXMABJv2GXwoB+R5OPlHxwwpc8GcgYuwAte9GAo7P89QNNR2oAUvtpQTbLaSol7qfwovCMVzKq0NSrdEhKZuaZuV6EM9KiorISkARgDTaDEqz5dW2ZSJ1RLigV6qX4vswOAq9PO5r0qLAt64pQT/5SHHQ2nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nDOd2Vlo; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nDOd2Vlo"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZHPsg0VyFzm10gS;
	Tue, 18 Mar 2025 21:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1742332884; x=1744924885; bh=GAUjWRvpjCm6y7C23vDEW4li
	4OIOY5J/XdAMBwNxIGc=; b=nDOd2VloVYXtkkSzEyWh7irCogyq2YxcWKLHfcgS
	nd/NDKkUK9GHFHjdt8Xs7oYBZygD2Q+NK3J8zxBwOpLT9QtDf1n5E/k52fmmW7wW
	IaL+vaG9k5D0ncH1dYUcFUS0TjbUvb+/+VvJKj82r1NmTd0O535ZBwDVc7Hlefxy
	CC2ZfRgri/XpRNSa6Dhwk8lb1pijExbOQ4EwpADWVFOvzBywGscTFozvsOWKxA09
	gltzdBK0aW/YEBaOpzD35OQncFr44z+TV2ZxXqxBOlJcO2dJUtBDrx4+KpiSBHFj
	nwoje7VVCwPV//IAGSbt8K37GDdUKVhNbgV1J7LHvUDUqA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6Q_yqVBWG-dI; Tue, 18 Mar 2025 21:21:24 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZHPsN4RSXzm0ySh;
	Tue, 18 Mar 2025 21:21:11 +0000 (UTC)
Message-ID: <98b420e3-87ee-4034-8cb4-76b8e30d7920@acm.org>
Date: Tue, 18 Mar 2025 14:21:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: add device level exception
 support
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, quic_cang@quicinc.com,
 quic_nitirawa@quicinc.com, avri.altman@wdc.com, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, minwoo.im@samsung.com,
 adrian.hunter@intel.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Bean Huo <beanhuo@micron.com>, Ziqi Chen <quic_ziqichen@quicinc.com>,
 Keoseong Park <keosung.park@samsung.com>,
 Gwendal Grignou <gwendal@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Eric Biggers <ebiggers@google.com>, open list <linux-kernel@vger.kernel.org>
References: <df2a1843d1dbfd0d3fef87b9730089969b6f00bd.1741992586.git.quic_nguyenb@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <df2a1843d1dbfd0d3fef87b9730089969b6f00bd.1741992586.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/25 3:55 PM, Bao D. Nguyen wrote:
> +	if (status & hba->ee_drv_mask & MASK_EE_DEV_LVL_EXCEPTION) {
> +		hba->dev_lvl_exception_count++;
> +		sysfs_notify(&hba->dev->kobj, NULL, "device_lvl_exception_count");
> +	}
This increment can race with the code in 
device_lvl_exception_count_store() for clearing
hba->dev_lvl_exception_count. Shouldn't the clearing code and the
code for incrementing hba->dev_lvl_exception_count be serialized in
some way?

Thanks,

Bart.
