Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A0030FC2E;
	Fri, 27 Feb 2026 20:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772225205; cv=none; b=FyMo/EvL3hipNmaKOvWiqOFuigh+6HU4uZc4JObAsBCxfUaKPNCbMk7s1xSy2va5Pn0xQ759YGNwDegWLY3Oj85DIWffDEueyYzrmw3wDbEBYheqHPqh7fEA17X2OvVUGJJBq0OzW385lyZkQCQ0DTefBPMkXlaCM3vuHh8e3uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772225205; c=relaxed/simple;
	bh=A3ZTFazjTo65N6ono0ieXnUEptFZk+KaOQW6P8PPGeo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ltm6Xy6rbl2SNbTuTBOE869/iUIuyOg26BSMf1CNC1SOHuXZj87YqXsWv5FclXkQXt983pTCyny0VOp2EMONsTfOt2xN5sNVY1APXyV6qGg4WYj9h5qqAS1Z11JT/Aa6luFmR40XF82NgKV27ykG5BWNziO9Isk9VbfCsvUPcGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bzFg57BV; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bzFg57BV"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fN0jv6XPDz1XM6JS;
	Fri, 27 Feb 2026 20:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772225198; x=1774817199; bh=yZKIJczsxO/YthEXVX6+Qeyx
	MvfkP35Ki+QPuvBfAvo=; b=bzFg57BVY8ioK0xChCsHPgmmG/XsVSYfED1TSCA1
	9iv2ucN/5sSpZx9blGBsa/rH3nqJkpxGT88zf7r33Ocy+IpM1IA+aiGdGYI9lLS4
	bWRExcSJRU+0Ra75MqXi7SehbO/RMMeA6INlddnHbV5d0Rh/TULYAx+s9KwnxiPP
	UeG0OSJ9m1kgH0yq2xsKEJ3OoEYbV0PFMQci6icP9eon3eHsFXrbUNsoSXsTFIql
	ZkKMtgViGe7dTz/VZq4SUW0umIQ8smBSRGQzRyi+4NgzV3Ty/qy6/1IacNFEv4QE
	A1/+rKlOsh3e+k0W4uIOyr3eP+5mgJ6qHC7ANzAQwhJLuA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QfVLMf5Llq1C; Fri, 27 Feb 2026 20:46:38 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fN0jm28pfz1XM6Hx;
	Fri, 27 Feb 2026 20:46:36 +0000 (UTC)
Message-ID: <7a90c4ec-7638-4840-bebd-f38cead6435e@acm.org>
Date: Fri, 27 Feb 2026 12:46:35 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/11] scsi: ufs: core: Pass force_pmc to
 ufshcd_config_pwr_mode() as a parameter
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Adrian Hunter
 <adrian.hunter@intel.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Archana Patni <archana.patni@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
 <20260227160809.2620598-3-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260227160809.2620598-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/26 8:07 AM, Can Guo wrote:
> -	ret = ufshcd_config_pwr_mode(hba, &new_pwr_info);
> +	ret = ufshcd_config_pwr_mode(hba, &new_pwr_info, /*force_pmc=*/false);
Comments like "/*force_pmc=*/" are uncommon in the Linux kernel. Please
consider introducing an enumeration type for the new argument, e.g.
enum ufshcd_power_mode_change_policy { DONT_FORCE_PMC, FORCE_PMC }.
While comments like "/*force_pmc=*/" are not verified at compile time
(the Clang option -Wdocumentation is disabled as far as I know), the
type of enumeration labels is checked at compile time.

Thanks,

Bart.

