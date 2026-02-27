Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B0C155A5D;
	Fri, 27 Feb 2026 21:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772229346; cv=none; b=Ohv9WXYHWyrKllbLHw0nN7Q2FM7l6RhEkfB38jvYO1PTCwmVmh/iPcJtLp/pl3xd7G2QzD8Iya9EkF7o3m20x1zla/nxdgZAFj5bZmWsAQEYOdRfiqhDDQXyY2ncQ4uOnajzl7buWdeXRvGUYTCcawxX6XmiA/utmnF0YaC4IuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772229346; c=relaxed/simple;
	bh=43jtFTRJnUrs5mQijCC179rp6S6aC9ev9BM0AXFz1r4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lr6TMAaw+rYOR+C4Fu7se/tLUtcDrb6DrWP519DgLsglEkhTWNDsXdNNA9dY8lzBl6v6aV5AESCmAbyRKrxkmrrqyeh924Jw5u53wtCXyXJQlfohZJhfdNv9HidU1cRIAmmhP0gAB+MUaF7ZXdT2SsC6FhIhPKaQn3ilMFIHnUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UCENJ3IZ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UCENJ3IZ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fN2FX6sb7zlfdCw;
	Fri, 27 Feb 2026 21:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772229339; x=1774821340; bh=9hg1z+ql6a8dRG/vmwNmNic4
	+tVHW89+3Ukrniie2g4=; b=UCENJ3IZNH0eWWIVFeTsFqx5gkf5T1CugVVzUPtL
	9FhmCpm8InqZpWKKpwzRM3xyLSVEQ+wt4h+sk5kMq1edX9mHFo69RzyRoGQDN9JT
	aqKWHmYtThyfENB4OaZ1B7vIhjFYyLJDk432iz7r6+kWeRsCWVXIT25EkEFNhIXP
	8PqF9TUYmiuYcErOYT5XjjbOLaBGxvCmm9un5hCLvGBLfDb2xiCUBrD5IU2nDx4q
	VhTFGQpXNuEDmQM8z8GhjCqXviWcWPXb+yoctR6ACGTg1GuNjKWGXZggoDT/5527
	emyHthkSW23xXOQFodiANJhHjhMBhRJ9e98EPjLXabiYYA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IistJ490zLd1; Fri, 27 Feb 2026 21:55:39 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fN2FP4RlVzlfgQG;
	Fri, 27 Feb 2026 21:55:37 +0000 (UTC)
Message-ID: <a4f442ab-e58e-42ef-824e-c4e797f3bc33@acm.org>
Date: Fri, 27 Feb 2026 13:55:36 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] scsi: ufs: core: Add support to retrain TX
 Equalization via debugfs
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
 <20260227160809.2620598-7-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260227160809.2620598-7-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/26 8:08 AM, Can Guo wrote:
", 0200, hba->debugfs_root, hba,
> +			    &retrain_tx_eq_fops);
>   	for (attr = ufs_tx_eq_attrs; attr->name; attr++)
>   		debugfs_create_file(attr->name, attr->mode, root, (void *)attr,
>   				    attr->fops);

Instead of creating one retrain_tx_eq attribute, please create one such 
attribute in each gear directory.

> +static int ufshcd_retrain_tx_eq_prepare(struct ufs_hba *hba)
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
> +		goto out;
> +	}
> +
> +	ufshcd_hold(hba);
> +
> +out:
> +	return ret;
> +}
> +
> +static void ufshcd_retrain_tx_eq_unprepare(struct ufs_hba *hba)
> +{
> +	up_write(&hba->clk_scaling_lock);
> +	blk_mq_unquiesce_tagset(&hba->host->tag_set);
> +	mutex_unlock(&hba->host->scan_mutex);
> +	ufshcd_release(hba);
> +}

Instead of duplicating some of the ufshcd_clock_scaling_prepare() /
ufshcd_clock_scaling_unprepare() code, please extract helper functions
from these functions for pausing and resuming command processing.
Additionally, please keep all code related to command processing in
ufshcd.c.

Thanks,

Bart.
