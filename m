Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5D0165F1A;
	Wed, 10 Jun 2026 18:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781115603; cv=none; b=pvABYL8cTy1Owu4PZYlYuA2uACZP2mWx4xpXVL8dmSpK2vZm+jw7IX2rDOezCp0NK44bc1TsbUv4Ov7yS7c0iuD3IQkQ/r+vHro9gVyKkAjLC0WQIKUc264CoOXa8tkDiawWkFIrqag+X6Bheokp06VEfOIlFwahxpKsXNQDLvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781115603; c=relaxed/simple;
	bh=JVIYg6cJofNnExXLa0L/JWdwfMC0pckWPaSEzyTwAJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a7vAlShZk1BCJofnBhu7L+sqOmF+FYohVPiUmP48NaAL4SiCMyvrnEzd9AuxgZWGkZK5Au1nGdcI6VCdCtSYSx4yDdgOvcLIMx3Glc9d0KSeYJYpqt88xcqiHxlhYQRBz3g9Ns+gknYZKVecyhneXBP96pD1F6S2vxHJz/JKE8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4PtCdXrt; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4PtCdXrt"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gbDb52fQHz1XLyhf;
	Wed, 10 Jun 2026 18:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1781115596; x=1783707597; bh=e20oA2/hYWBsVwzEsdV1BTXP
	nHBOXoli9wZcBXVbjm0=; b=4PtCdXrtx9wrO3j1MPY++vYvqNEfIXDUkqxEIU7R
	JhbTVvId71C0vBiP2yMk5etJOdF3+FVjIRKw1ENyZpOHK0v8Tn/QZlyIyXclpeOP
	/8gTh6FWGYp4+vqVx+mb+HeJHxHqgcGWHrjiCSB3X4gA5QHT67HMuLc9edTVjVXj
	j6Ik8Zxv0frazFmmhgb2K4SbP5Wc40S2NFRpRijBNmoYNxzp0fsJwNgG9GUP5s5W
	Ak+JDJ3XtG1t1ugffwxz5FHCApO5BCCJ0ZUJ4r2mCxGbd8RHCiNMzoUWNZyX21E/
	32WxjtC4JT4x2CVHQsPt7Ou7+lbRKXMoKIvB04fOJnjJRw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1S3SlWX5CanL; Wed, 10 Jun 2026 18:19:56 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gbDZy4xmQz1XLyhT;
	Wed, 10 Jun 2026 18:19:54 +0000 (UTC)
Message-ID: <fd67c7af-4e80-403f-bcde-0e0fadf6d5d0@acm.org>
Date: Wed, 10 Jun 2026 11:19:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: sysfs: Add WB partial flush mode support
To: Daniel Lee <chullee@google.com>, James.Bottomley@hansenpartnership.com,
 martin.petersen@oracle.com
Cc: alim.akhtar@samsung.com, tanghuan@vivo.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260610134316.990430-1-chullee@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260610134316.990430-1-chullee@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/10/26 6:43 AM, Daniel Lee wrote:
> +static const char *ufs_wb_pfm_to_string(u32 pfm)
> +{
> +	if (pfm < NUM_WB_PARTIAL_FLUSH_MODES)
> +		return wb_partial_flush_modes[pfm];
> +
> +	return "unknown";
> +}

Is a new function really required for something that can be written as a
single ternary expression? Please consider folding this function into 
its caller since the above function only has one caller.

> +
> +

Please follow the convention used elsewhere in the Linux kernel and only 
insert a single blank line between definitions.

> +	ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> +		idn, index, &flag);
> +	ufshcd_rpm_put_sync(hba);
> +	if (ret) {
> +		ret = -EINVAL;
> +		goto out;
> +	}

Why is the error code returned by ufshcd_query_flag() changed into
-EINVAL? Isn't this something that should only happen if
ufshcd_query_flag() returns a positive value? From the comment block
above the definition of ufshcd_query_flag():

  * Return: 0 upon success; > 0 in case the UFS device reported an OCS 
error;
  * < 0 if another error occurred.

> +	ret = ufshcd_query_flag(hba,
> +		value ? UPIU_QUERY_OPCODE_SET_FLAG : UPIU_QUERY_OPCODE_CLEAR_FLAG,
> +		idn, index, NULL);
> +	ufshcd_rpm_put_sync(hba);
> +	if (ret) {
> +		ret = -EINVAL;
> +		goto out;
> +	}

Same comment here.

> +	if (ufshcd_is_qword_attr(idn))
> +		ret = ufshcd_query_attr_qword(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			idn, index, 0, &qword_value);
> +	else
> +		ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			idn, index, 0, &value);
> +	ufshcd_rpm_put_sync(hba);
> +	if (ret) {
> +		ret = -EINVAL;
> +		goto out;
> +	}

Same comment here.

> +	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +		idn, index, 0, &value);
> +	ufshcd_rpm_put_sync(hba);
> +	if (ret) {
> +		ret = -EINVAL;
> +		goto out;
> +	}

Same comment here.

> +	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +		QUERY_ATTR_IDN_WB_PFM, ufshcd_wb_get_query_index(hba), 0, &value);
> +	ufshcd_rpm_put_sync(hba);
> +	up(&hba->host_sem);
> +	if (ret)
> +		return -EINVAL;

Same comment here.

> +	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +		QUERY_ATTR_IDN_WB_PFM, ufshcd_wb_get_query_index(hba), 0, &value);
> +	ufshcd_rpm_put_sync(hba);
> +	up(&hba->host_sem);
> +
> +	return ret ? -EINVAL : count;

Same comment here.

Otherwise this patch looks good to me.

Thanks,

Bart.
