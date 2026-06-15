Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D48F30F55F;
	Mon, 15 Jun 2026 13:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530750; cv=none; b=brxec5DtzwHQsVngypqBRcbP9C8fL4H+Ys305cbapRdhnAWAFGhrX/VkdGtp0sdMClErAqOBkx1r9qUYXdK+4YUUfgt2NQ2F7FD5X3T+Yn16iqPvuOGyl7S0sSOe4sZ3oTByhN6po/D/MP5pCp7TtxyjWnlkZWc4t9HeeA//Krs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530750; c=relaxed/simple;
	bh=78YTjbGZxTifLZ+cKXMXeMnjifjGjtHJ4IoR9irGX6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BMVtKuYsGNEBhn9hmh0Z0PW3OD38uUw0MXIX5zhuiM07Jurhxq58tZszp4QaX6hUMrFfF4h+dAA8H0XVhJ//QpFL5gGlIK56FaLQEQOkV6+YuqUa0b98hg1PJvM7ZYca23QCK90XEzxNZJ6CH+tYtDM3pyrgliJ9rq9vYrJU20Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=p8JEd2Y7; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="p8JEd2Y7"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gfB6h3Tbczlh2sH;
	Mon, 15 Jun 2026 13:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1781530742; x=1784122743; bh=T8k8Rf9XlHQa2IIn9rdesT7M
	+Zq8IpMrOrlDOWEE7QE=; b=p8JEd2Y76sIghHSl/PF3L0Ms7GKsI3v0MEyXDfTh
	KojVERBzVo5LPegdP94SmyozKcjm8zi8zZH/rf+NodHufTnChvt97Kk4O6v7OlE0
	7VZKMwI2wvy6y2dhwuOPZwNFJUf2HuAM98VSa3rRvNuUOFuqtQGt4UZazXUnykcO
	0AgocOWKlPvEl+Aw/clrvHO6erY3k8KbJAqGfr9e8ZJjocOMbrGw5BWnA8RcqRms
	r/ih/TJ4I9XP3kPT6SMvCbx2xCjPz9RHrr8pga4zcdUcttlAHnRGMLwG4BQq+Dqo
	dOHGRuSphlZ8enR7/5BfGQdVv4+xO9o2vOIyKhD5yckB2w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hHl_Bkek00HZ; Mon, 15 Jun 2026 13:39:02 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gfB6T4cDqzlfl5V;
	Mon, 15 Jun 2026 13:38:57 +0000 (UTC)
Message-ID: <35a67c82-f71d-4a20-8560-05c2b1361b06@acm.org>
Date: Mon, 15 Jun 2026 06:38:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: Can Guo <can.guo@oss.qualcomm.com>, krzk@kernel.org, beanhuo@micron.com,
 peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
 Nitin Rawat <quic_nitirawa@quicinc.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>
 <20260615132834.2985346-3-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260615132834.2985346-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/15/26 6:28 AM, Can Guo wrote:
> +	prop = of_find_property(dev->of_node, prop_name, NULL);
> +	if (!prop)
> +		return 0;
> +
> +	count = of_property_count_u32_elems(dev->of_node, prop_name);
> +	if (count < 0)
> +		return count;

Can the above two of_*() calls be combined into a single of_*() call,
e.g. as follows?

count = of_property_count_u32_elems(dev->of_node, prop_name);
if (count == -EINVAL || count == -ENOENT)
	return 0;
if (count < 0)
	return count;

Thanks,

Bart.
