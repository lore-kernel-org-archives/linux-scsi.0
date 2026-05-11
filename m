Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75BD383317
	for <linux-scsi@vger.kernel.org>; Mon, 11 May 2026 22:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778538078; cv=none; b=iQD8QO1vBeiwJePxThNTYyT12JPu3Fg6AoY9frhIE4PPfEgCnQ2skEXyuB500c/PoXoVnHfOH1/slqI5bpCApsmFM+22eGlie7LB3g7NW0Cz8uBI6eNTDYknLhXvUjt7nB0HYIBM1lZLoUQsVaomnPzHnsURVt/i6bEDT9sEtAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778538078; c=relaxed/simple;
	bh=XlRkJocGsWqpufjbAeHzw2wEO+YM5HIvRc1FxpPpfe0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EAwJUSlJnytE3gpvSg95aA12s0zPxnJWI2dPmtYeKqxpDyEfdUceQ3Ebv7rK4wrWQgK6U3bJPzEZ7qWlNljfZh7uUyUNlBpqEg5YHqlgw5aORtL5OXFxy2e6RUny4JGv/si0YpiaWb2Tr88OcTT8EiMW/Mm6Vp8VxfrmqoT6p5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxno5/NX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxno5/NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED635C2BCF7;
	Mon, 11 May 2026 22:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778538078;
	bh=XlRkJocGsWqpufjbAeHzw2wEO+YM5HIvRc1FxpPpfe0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nxno5/NXch9p2ZDlNETtqWE9u4UbhtKyGdX9Rii+6G9deo+mk1k630rT1Egaj49fU
	 l3FEWnWwN2vs/coVya000WFoWsP0HeWELCyDvI8nY70dViY+psRJHtknGJ23ouX9sz
	 ZWjdl5HxJVVMz/4Jy6gNd4Ba/YuomYV5wpjyVZDAji2lbeQ4i7s7+8V7WZdjUnfLb1
	 b9guRgHmz5Twzibtlb3E1DTOvsGNkltOoDwXWx55QWD+9qbwDO3lFlYqIJ/GRK0/PI
	 ahlOtVAiHuIDWDE02rjPiEBBXKNajzMZDD16HEv2/LlbNQ1TFBwZebV0sujpHnQEuy
	 vu+XQzRpmH9Gw==
Message-ID: <62373e3b-2acc-4107-a091-a2c55aa82767@kernel.org>
Date: Tue, 12 May 2026 07:21:16 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: hare@suse.de, bvanassche@acm.org,
 Krishna Kant <krishna.kant@purestorage.com>
References: <20260429012733.40855-1-brian@purestorage.com>
 <20260429224939.77082-1-brian@purestorage.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260429224939.77082-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/30/26 07:49, Brian Bunker wrote:
> All INQUIRY-derived sysfs attributes (type, scsi_level, vendor, model,
> rev, cdl_supported, and the binary inquiry attribute) read data that
> can be updated during device rescan. These reads must be protected
> against concurrent updates.
> 
> Use the existing inquiry_mutex to protect access to these sysfs
> attributes. This ensures that userspace always sees consistent INQUIRY
> data, even if a rescan is updating the buffer concurrently.
> 
> Replace the sdev_rd_attr macro with two new helpers,
> sdev_rd_inquiry_attr_int and sdev_rd_inquiry_attr_str, which generate
> the show functions for INQUIRY-derived integer and string fields and
> take the inquiry_mutex around the field access.
> 
> This is preparatory work for adding INQUIRY data update support during
> device rescan operations.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
