Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80231143C52;
	Fri, 12 Jul 2024 17:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720806727; cv=none; b=hzdJXSfzSyZeQFKqDxngHQ1UnAEQnCRtgSYWLG0XN2adWmg/PFoDng/xal6kKQoeNPhuiU5HBnP7C/FquUlVsNTKMSKWxrIyFmfD4oP39NpSV4zH1ryuWqYCSfpdvrrMj6eBZiOZRK7w/QOAp0gc1JeAs7NMhUtR6kBq6D7BEK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720806727; c=relaxed/simple;
	bh=i6ghiyZud1s7d2jVLaGdpTehfGlJn4BDOTkDfs84v0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hdvfljNvIV+o1cGL5GNEVKa6lnTa+180CWbSclc4g4cRPugwZl2AjE/mXCGBnweLhOP5dNVHMg/1KDA+wtTGD83BKjpGsqj5Ny3idsonG0ULf8SvwJGn7CqL88Vnx6TOBcCyB4muN4Bd5BnqTwF4KWy/DUp7MPdRqXK7kFcB7WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iUW2bBox; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iUW2bBox"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WLK116sMRzllCRp;
	Fri, 12 Jul 2024 17:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720806721; x=1723398722; bh=qx2yHKrOtr7nncPx5lDJ1DX9
	Y1bBWBHCftoh5jHF4Xw=; b=iUW2bBoxhy+jEggy9y9kAl9AlVn1CPOawcy847h6
	MWX/9rGnjxlQtbUeCKAE4+CfHnzvh1KE+1y8/SRM3wTum/qJF33n9aDmYRoIOW7u
	7u71dawlsWo4E+VbWDUYvC23tmUujVAGMv/AC9PeZahwCtq3vFMb27wkMKoNHPW9
	In5pfvM7KuKGDFe45njqgBxS1LdGywskaLgvWkrNNj0rATBtgjUAUyTJy31R/tJn
	WulihiG0ykDiN/b9qI8CsfrT2t19m8fKjmk+0DwKQep8zpgu5k8bqc3MgTcrlLtP
	+LfTDzb9K8V+unYXtPGaJjunohFS3XT4AYALTvkLD0Qhdw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LtWOsS9hymJ0; Fri, 12 Jul 2024 17:52:01 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WLK0s1LVkzllBd1;
	Fri, 12 Jul 2024 17:51:56 +0000 (UTC)
Message-ID: <4062986c-61be-473d-b8bc-b40d9260f301@acm.org>
Date: Fri, 12 Jul 2024 10:51:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] scsi: ufs: core: Support Updating UIC Command
 Timeout
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, quic_cang@quicinc.com,
 quic_nitirawa@quicinc.com, avri.altman@wdc.com, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, minwoo.im@samsung.com,
 adrian.hunter@intel.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>, Bean Huo <beanhuo@micron.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>,
 open list <linux-kernel@vger.kernel.org>
References: <cover.1720503791.git.quic_nguyenb@quicinc.com>
 <6513429b6d3b10829263bf33ace5c5128f106e59.1720503791.git.quic_nguyenb@quicinc.com>
 <a89910ad-da5b-42c2-8a0f-9f4908fa2c1a@acm.org>
 <6f6a2608-6f1e-60dd-0dcc-93fa3d61202e@quicinc.com>
 <91d9bb0f-d9da-6303-c16a-f449b070a4e5@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <91d9bb0f-d9da-6303-c16a-f449b070a4e5@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/11/24 6:20 PM, Bao D. Nguyen wrote:
> Maybe I misunderstood your comment. You probably was concerned about the 
> execution time of param_set_int(val, kp) vs a single assignment 
> instruction 'uic_cmd_timeout = n;', right? If that's the case, I'll 
> update the patch.

I'm concerned about the two conversions yielding different results, e.g.
because of different handling of base prefixes (e.g. 0x) or different
handling of overflows. This patch would be easier to review if the
conversion from string to int only happens once.

Thanks,

Bart.

