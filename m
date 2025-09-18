Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E1B24468C
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 18:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758220232; cv=none; b=UhooGbOej1FBbZ1yKl3Qp3wgOP+pGzdzT676wGDfWHrL+u0sUFpTVxC1q0txHXD+I/Vd0AxecsaUspEPBJhnZ8kWykx6YxiCVbcuZueVEK361Im5wFDhL8MX49pq60OX7/XbR0theEsphNcku9gv4oTh4lp9wGjkyBNP02p7Dd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758220232; c=relaxed/simple;
	bh=t/fSSvgsW3pawIQ3Egof9djmka1o0u7cLgWNCZuci0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FvNMLfKOuejN1MrD5aaOKV61OqGDXag/bVdPER6h9s5Xk7slom2GyQKB2AI3VIbNa35DBsf0CFKdOxlXEEE7tcIgpsp2beTryIQZIIkOUu1NTVyOL0ZdSHI8gYkPmh4sq0eqv7vsPVOvY82TyWmBkmw7Q3/IeG/n1xcUF4W22+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mX4ThNNB; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mX4ThNNB"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cSPMT62CRzltQM8;
	Thu, 18 Sep 2025 18:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758220227; x=1760812228; bh=t/fSSvgsW3pawIQ3Egof9djm
	ka1o0u7cLgWNCZuci0Y=; b=mX4ThNNBBpA3VuHN/e7FBXzarWrcMXSMZAVnh7Sy
	9APgPdd+tgFfviyh2f/PpapEe0zR27IGmeu+EU4o+O8/6GIjHJbg88VDMY9Xrd43
	BD3CzalNnHJLJ03DR5eBsljHsmdvqFyij1njUBr8o6UEOCQN20P+nz+ec3cNgayi
	APlWtJAZiaaGJC2ey22QGcl8TDhuEpAHfYCuwlGLG6BYf56EZrOVorjPBFPctKJy
	1wfJeifG/x74FceyRGAaV6u9rPHg4WbNlr3Ra+7fIJlAetfocf2Idk3EmVGfGBeu
	fUI4RXa4SkDFjpY/fCB/ookNyJ8yFShOrUUep/q2yu/LZg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oxVgUQ-ehWAL; Thu, 18 Sep 2025 18:30:27 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cSPMC47FQzltQLx;
	Thu, 18 Sep 2025 18:30:14 +0000 (UTC)
Message-ID: <02338932-b3e9-458a-ac24-41b4f29eb514@acm.org>
Date: Thu, 18 Sep 2025 11:30:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/10] ufs: host: mediatek: Correct clock scaling with
 PM QoS flow
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250918104000.208856-1-peter.wang@mediatek.com>
 <20250918104000.208856-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250918104000.208856-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/25 3:36 AM, peter.wang@mediatek.com wrote:
> Correct clock scaling with PM QoS during suspend and resume.
> Ensure PM QoS is released during suspend if scaling up and
> re-applied after resume. This prevents performance issues
> and maintains proper power management.

Is this issue related in any way to the MediaTek UFS host driver? If
not, please change this patch into a patch for the UFS core driver such
that this issue is fixed for all UFS host drivers at once.

Thanks,

Bart.
