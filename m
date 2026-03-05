Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30FA3624B5;
	Thu,  5 Mar 2026 14:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719878; cv=none; b=p6ua4ye+3KciCrFc7zodIU5YDFuit5tK2oP6kqDi53Cj9T+efSQ95Dy9sc7P/yySd3YGfPySRjs16EL2L2UohZ/yaQ8B/IPF783OQ/SD13r/uq0B0mjeu1OkBmjt+aKcHdupLse9BxPvakVqME4R+fEAu6OAjJg/DqS0P2dOTDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719878; c=relaxed/simple;
	bh=qO9Oc1fUiRx2YwJellXTRBq38hew4BJ/bEQF2JJvqKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gZsA1bj7A7YALpDHxWpRoja2T+zodiu7xMiz4bihKNbGPp7u+Ft99YB65xtlfc1/O2XTlNo7Ns6sTw+YDKQVc391lMrxXLSPXieSeoBntK/9My+Aa5YrvYHR4zzRyAmpWkmpCGzvEWXz3zB+xenFKPJZcDKUFXNNDbOOI7n2n+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qd4vA1ic; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qd4vA1ic"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fRWfr3ZWQz1XM0pg;
	Thu,  5 Mar 2026 14:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772719869; x=1775311870; bh=zJowjjLCVMMfZyl0F6EvRD6J
	RaFV2iNWrz6mqghgels=; b=qd4vA1icDhw//5tMOngmP8C+KTrHfp+C8KsDbVne
	i+LgA6xqtt7N14qhs2WaW8U3HupbgIFvsYkqgkAnXYRjiSwtnObR67V9eJ11EtYN
	BpgezeP42tXyDd3c4nkjAYBqUbHKzXnJzPWjjopyCAOs5n1tGmfhuKK5adzXen3N
	M7FjRUwyphSuY8Ej7uNz65AfeNcZ09isYEb8sMZcdAFjzfvrlwBoeGubwq8GeYB7
	oKFKxtFx9LEUrCN8RNSRrTuU95OINzehxaIL58y2xuvVlfOoN08an9QEFLQSJZQm
	0aXmHN8ksCG79wooe0hMg/cgGID2mb9nNBV4jl+ypfJH8A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rP3km06Q5rn4; Thu,  5 Mar 2026 14:11:09 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fRWfc6mCgz1XM5kD;
	Thu,  5 Mar 2026 14:11:04 +0000 (UTC)
Message-ID: <22dcd303-db72-4661-9d42-67c7215cc089@acm.org>
Date: Thu, 5 Mar 2026 08:11:02 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] scsi: ufs: core: Add support to retrain TX
 Equalization via debugfs
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-7-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260304135313.413688-7-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/26 7:53 AM, Can Guo wrote:
> +	ret = kstrtoint_from_user(buf, count, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val != 1)
> +		return -EINVAL;

Why does "1" have to be written into the "retrain_tx_eq" attribute to
trigger retraining? Nobody will know that "1" has to be written into
this attribute without reading the code. I propose to accept strings
for this attribute, e.g. "retrain" to trigger retraining. I expect that
this will make shell scripts that write into this attribute easier to
read.

> +int ufshcd_retrain_tx_eq(struct ufs_hba *hba, u32 gear)
> +{
> +	struct ufs_pa_layer_attr new_pwr_info, final_params = { 0 };
> +	int ret;

The recommended style for zero-initializing data structures is "{}"
instead of "{ 0 }". The initializer "{}" doesn't trigger any compiler
warnings if the first member of a data structure is a pointer. A
compiler warning will be triggered when using "{ 0 }" and the first
member of a data structure is a pointer.

> +	ret = ufshcd_pause_command_processing(hba, 1 * USEC_PER_SEC);
> +	if (ret)
> +		return ret;
> +
> +	ufshcd_hold(hba);

The ufshcd_hold() call probably should come before the
ufshcd_pause_command_processing() call to reduce latency.

> +int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&hba->host->scan_mutex);
> +	blk_mq_quiesce_tagset(&hba->host->tag_set);
> +	down_write(&hba->clk_scaling_lock);
> +
> +	if (ufshcd_wait_for_pending_cmds(hba, 1 * USEC_PER_SEC)) {
> +		ret = -EBUSY;
> +		up_write(&hba->clk_scaling_lock);
> +		blk_mq_unquiesce_tagset(&hba->host->tag_set);
> +		mutex_unlock(&hba->host->scan_mutex);
> +	}
> +
> +	return ret;
> +}
> +
> +void ufshcd_resume_command_processing(struct ufs_hba *hba)
> +{
> +	up_write(&hba->clk_scaling_lock);
> +	blk_mq_unquiesce_tagset(&hba->host->tag_set);
> +	mutex_unlock(&hba->host->scan_mutex);
> +}

Because of the "one change per patch" rule, introduction of these two
helper functions should go into a separate patch.

Thanks,

Bart.
