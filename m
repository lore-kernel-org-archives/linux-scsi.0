Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFE177104;
	Mon, 19 May 2025 21:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747688581; cv=none; b=iawuQAKSX1DiUZdpqebmApa1NVUQCe7f/XRSMDBKaV+jP+EKb9JmSjRZXi/xplRK7nyVc/hfzuUyeEJKTqh1iKEDvB2vH4aHWsrp3TVbnIrRDG2QV9NO6sOqobDLJAzsIRf0Z2tfpWw6bF9p54m5FrOQO/NmjZ60M0Ki5FJeN2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747688581; c=relaxed/simple;
	bh=xSVxlqInoshGkcnJUBt9D1AEiriLSrgitkvnvPVT+l4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=msF+KNC8ibtDR0StMtM55wNOjLXkfZZz426LgWMhU/8hc3anJ3ef/M3eBuQSJbQv7XsXcvj73ns5pyMdqx6Hazc/HUTkHypb9W5GzVSIm31dUT0eNR+MlukK2oxNfMFFsbfwcR42aYYXHzrvt1sN8zpJkGQKn57XaMPjROpEfaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4dFFAmoZ; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4dFFAmoZ"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4b1VWl04lrzlvxb9;
	Mon, 19 May 2025 21:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1747688575; x=1750280576; bh=YEPofVvgLXeaS7bTEy/4niL9
	XtDAUhUTLDA0AO+iElY=; b=4dFFAmoZjm/t+WIfTczGm1srH0zZuAqVYjf9JGMt
	diQ0Biz/ahwGoS6xYMD9mPyvPfIURd1nLyIjmuV9enGrLaPQT5ugEzDoI84rjqSB
	lnoFKCWYMcVIZtJRKHgromm0S5JlM3kBGSDUSujcZHFeN1h927hDRgZxUWMpXzzE
	eJ0WTuGhBRT9G+5N8rJr8xsvgpNB8WlucQpgwgwa6SaTyh1LeWImW4RuErtfUliZ
	q+FdGp6puXXe6+9eTn8ISyndPDu/AjfZCOAsvZtNHA+5qq1zN2no83gpiaOQK/7l
	SNDIn9Br0Ai8lfu4S7dysE+uoaDbSO3GKzAUBBUj5QoSvg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2xkBi9KeFzdj; Mon, 19 May 2025 21:02:55 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4b1VWR5x85zlvq7Q;
	Mon, 19 May 2025 21:02:42 +0000 (UTC)
Message-ID: <08e67735-d5b0-47d0-b476-c22a3b5acdda@acm.org>
Date: Mon, 19 May 2025 14:02:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ufs: core: Add HID support
To: Huan Tang <tanghuan@vivo.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, quic_nguyenb@quicinc.com,
 luhongfei@vivo.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Cc: opensource.kernel@vivo.com, Wenxing Cheng <wenxing.cheng@vivo.com>
References: <20250519022912.292-1-tanghuan@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250519022912.292-1-tanghuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/18/25 7:29 PM, Huan Tang wrote:
> Follow JESD220G, support HID(Host Initiated Defragmentation)
> through sysfs, the relevant sysfs nodes are as follows:
> 	1.analysis_trigger
> 	2.defrag_trigger
> 	3.fragmented_size
> 	4.defrag_size
> 	5.progress_ratio
> 	6.state
> The detailed definition	of the six nodes can be	found in the sysfs
> documentation.
> 
> HID's execution policy is given to user-space.
> 
> Changelog
> ===
> v2 - > v3:
> 	1.Remove the "ufs_" prefix from directory name
> 	2.Remove the "hid_" prefix from node names
> 	3.Make "ufs" appear only once in the HID group name
> 	4.Add "is_visible" callback for "ufs_sysfs_hid_group"
> v1 - > v2:
> 	1.Refactor the HID code according to Bart and Peter and
> 	Arvi's suggestions
> 
> v2
> 	https://lore.kernel.org/all/20250512131519.138-1-tanghuan@vivo.com/
> v1
> 	https://lore.kernel.org/all/20250417125008.123-1-tanghuan@vivo.com/
> 
> Signed-off-by: Huan Tang <tanghuan@vivo.com>
> Signed-off-by: Wenxing Cheng <wenxing.cheng@vivo.com>
> ---

The patch changelog should occur below the three hyphens (---) such that
it doesn't end up in the kernel changelog. Otherwise this patch looks
good to me. Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
