Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB52B2D3EC7;
	Tue,  2 Jun 2026 17:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780421503; cv=none; b=rHnpzVuv9Thw3txl9aw3rVO/qskfrsOTN9xto6IH/Ek4mxfjGW4i8jsPZM8bw8D5JRCSVSoyuPuWnzV4kdTXfDJFom6FnX79YhkxzL2Ja7wFESBNmZQVecKAenjYAZLlBqNslq4ks1we9boCSSl3miUFajKIZZXk+b/6bi28DpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780421503; c=relaxed/simple;
	bh=Ny6f+3soOnU1PuRRvLwbWsav6xe40zgTVVnliG71Pq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AY9fjNS8STDTkTupnUUw/JHJgo6vp0nzxavC8xrJ5sYv3Nejx7UBJWOwBuVGPFb1BbuoaWQQ+cpZL87DpvZ9wmTrJFlOf57IT+mH4gGtO/n1oqMPUKc4eNjXV9Uv2MB1FMgrCy+Zlt9WTl0iJiiaLtn//p0eL+yDIw06TUO1oVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gXw5VtP4; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gXw5VtP4"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gVHv22dV2z1XM0nw;
	Tue,  2 Jun 2026 17:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1780421498; x=1783013499; bh=b5+hvqe60xNKrqH7mpuIw3IP
	XosvsstooGsd1hecZZo=; b=gXw5VtP4LDupJZl/+RbHIiswn9BBPAeR9YXuB0zq
	nhKxPiV075065FzMdRuBklVomwg1zk2wSP5A9Co4mn4Dj3GPpqUN1WcbfGkhMRrw
	uGcyg37IF0DUC8COShQ7OuyCrajYu1B4Pa0IUZSY1J79jCym1j09CxIYDo/B0pev
	3Xz58Sf86gl66iqSQFyQRe5e3s63vHoWecWqya15EIspx+c8C3PN+mgpV2diM0rZ
	BBOCxdVJV+iHaFj95L6Kq0sfWZF3+fA9HDJAcfUqN/+Bb2IIiajWpVGOVdLnK23a
	6F3S95//FqaX9WKXwxmaPx6tMYQDd4bkGcJD4rMCfdQ5AQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id j-wGY2mKMPTZ; Tue,  2 Jun 2026 17:31:38 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gVHtv74kTz1XM0nn;
	Tue,  2 Jun 2026 17:31:35 +0000 (UTC)
Message-ID: <3f210420-ccfe-4cc4-87aa-8d810d580aa0@acm.org>
Date: Tue, 2 Jun 2026 10:31:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
To: Hongjie Fang <hongjiefang@asrmicro.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260602124103.1581617-1-hongjiefang@asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260602124103.1581617-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/26 5:41 AM, Hongjie Fang wrote:
> -	return scsi_host_busy(hba->host) ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
> +	/*
> +	 * ufshcd_link_recovery() may already have completed @scmd, e.g. via
> +	 * the existing MCQ force-completion path.
> +	 */
> +	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {

The above test can be left out if scsi_done() would be called before
ufshcd_link_recovery(), isn't it? Otherwise this patch looks good to me.

Thanks,

Bart.


