Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629E31DE892
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 15:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752679689; cv=none; b=UoJga6rnxUrKpA0H7UiMCATaCjzWgEB1r7m2io/ImJN+46aAvEekTiAdh0pDEOZzGksZxIXRsO2yKc4eDiZp6URD5tGfu9l/Cm2gG7QPcJu2gVZOtKiC7np9NtUAUg8RvCOzct40/9SwdT6gZ9xCoNq6Azv2TlazBaTg/zNC5Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752679689; c=relaxed/simple;
	bh=eG1oOzHeD3fFsn5cFG9+ESqYlg1L9/SHLD15icCCqVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tB1/Vb6kH0lON7nj6RHuvANz9Hy5cMZgGKh0o2o7EJakx7U7a5VFpSujoNj2/bN1I+hH5g4r4cxhFA2OhIWV8DpemVGKQCuOlPlvRpL2abkchmD9AjKhK5RKpvrippFd28OVEsmYcdHwO39ciMP7uQgzpzeuACsL16p1VLORR78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=v6+Z5+aF; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="v6+Z5+aF"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bj0Lb3YWfzm1748;
	Wed, 16 Jul 2025 15:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752679684; x=1755271685; bh=eG1oOzHeD3fFsn5cFG9+ESqY
	lg1L9/SHLD15icCCqVU=; b=v6+Z5+aF2wIqG+J2gZwnKE9qubx0wWv9fKBKHIsZ
	euaQUsIX7hVMnNPq/7ocmJfGgeYVg8GBRcuFvlS950FCbXqitzdOyM+H1oL17hCA
	cVjvgLGo/8i3Vc7kGc2Rdq3X7n2W+nHaTuNHgaThWH7XTkFVwqplbd1oZ696hzt4
	t8kScwks6GW3/hznNHxHWjyvFOmntH5xiLJV2nVL0Wg+rV53EV157/zS/mqjulHo
	kQX6K3I82Ul8B7OWNfbqT8lPXtR72zUTPYzn/PDkm+y5IoRZHC+mpBtLkBp1kbSG
	fyvAjKzM2H0utmnj8l5EyMb6XEfy98afRl1HtoLAnGAoyw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id W3EtcA2xNsgz; Wed, 16 Jul 2025 15:28:04 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bj0LF4jcczm174n;
	Wed, 16 Jul 2025 15:27:48 +0000 (UTC)
Message-ID: <9de567ee-f908-41a3-bcb7-7f54ebb17f55@acm.org>
Date: Wed, 16 Jul 2025 08:27:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/10] ufs: host: mediatek: Set IRQ affinity policy for
 MCQ mode
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250716062830.3712487-1-peter.wang@mediatek.com>
 <20250716062830.3712487-7-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250716062830.3712487-7-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 11:25 PM, peter.wang@mediatek.com wrote:
> This patch sets the IRQ affinity for MCQ mode to improve
> performance. Specifically, it migrates the IRQ from CPU0 to
> CPU3 to enhance IRQ handling efficiency.

IRQ affinity can and should be set from userspace.

Bart.
