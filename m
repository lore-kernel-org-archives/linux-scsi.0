Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC9F1A2630
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 15:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753198765; cv=none; b=V+4r0Ve98wLU7TKY5OXHWioE2JgDjfVHRPcwX3DTMQ1zdgbmC0I9LkuEZfLWcIMQATJUXMY/g+7RRADsq+Wb4S7EJwvC/2yq9OgEgIJXZFQbEdfTBN+kknDTrrzggWXtx1Fzded+zndIxitXk4sgWl2Tar1JvLG0Iskdh8fHJ6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753198765; c=relaxed/simple;
	bh=yP3aT+JfGsb4+PzNNmnU3uhOZT3wDG6ycApzRIATA40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pabrwLQmko/d3zi5fcRPZOT0SRUA+eP2RRyQcLyWmr//7wdfVg5Sm4RUacDnjFw4Av15Yyi/68WXbtFl0t2NxK4IlpcE1Tit7CwTOLtd1QSvlMAsShaKap+o1C1dMLHjLB0nknqRoKjQLpWP7XL6ASj40IqkHuVnmOV6BMH6UqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iBqKV5Y7; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iBqKV5Y7"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bmhJj3jKgzltJQT;
	Tue, 22 Jul 2025 15:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753198754; x=1755790755; bh=yP3aT+JfGsb4+PzNNmnU3uhO
	ZT3wDG6ycApzRIATA40=; b=iBqKV5Y7ku78yrodaaAlbFJ0wiIoUQAidWa0JbHt
	64iwejlqKFkMcX3vIth95FR/qw/SosjTOF1nZvVEpj6w8UJ5U4XFXih4EIB0IAr7
	nnxdX1iaqWfUxFQjJD/d0mEPTNb/fP2mVhE7FSB5A3nyZ3Y1diPgIZPr0kjkgM27
	5+ChcpY1AkR9gskEQBVI4aD4VDQ3YhLSV5Dp4aQwWyqSSpcx+7Qs41ERTuQGz1fk
	Lhm5eLjc3PmaLj9T3S9A/8R0mGPmF6ffvnDw3iBaJv+nYy1V/dPiQpbcLgkDmsxM
	c8Z2bXnGZ63/LfRjlv/XClVSnaFZWcqi/4CD0TN8yijg8A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1r234GrJPkxk; Tue, 22 Jul 2025 15:39:14 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bmhJQ4TT3zlsxD1;
	Tue, 22 Jul 2025 15:39:01 +0000 (UTC)
Message-ID: <8b44e181-68b1-451a-9856-95803b7eaf86@acm.org>
Date: Tue, 22 Jul 2025 08:39:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/9] ufs: host: mediatek: Simplify boolean conversion
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250722030841.1998783-1-peter.wang@mediatek.com>
 <20250722030841.1998783-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250722030841.1998783-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/25 8:07 PM, peter.wang@mediatek.com wrote:
> This patch simplifies the conversion from unsigned int to boolean
> by removing explicit conversions and parentheses, relying on implicit
> conversion instead. This change ensures consistency with other
> usages in ufs-mediatek.c and streamlines the code.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
