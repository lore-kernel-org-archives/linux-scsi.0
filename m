Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2780F8287E;
	Tue, 30 Sep 2025 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759252602; cv=none; b=XwrbEubIvq0KGsda+KvkLEr3BQbX2CItwcMGrS6a22eVIS6gtWUdiN99Ua+YkmP8fTHjM3WY3bJkntxRCyc3R9SIGRgTT71JYvho1XhMuRhhCv6nhdO3f42d1ozBMVycqvh7K9GSNgLZuUpr78Y4l5UUCuA1oDInMfEvuBtEm8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759252602; c=relaxed/simple;
	bh=8uI0EOW02UJQ01YdYKv6yRXGZqn6rtOmjULACCc5Oyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=buL6sHmGhMqpUYwum7m1kNNfG2PV9Gpe1KAsgKYCg9hpcZUdkeOazuiy1bSnpPL6dvdLoBM22EP4rh9EEZhx9p0u5OZ4aT43yAB/alPKumj928vTa6SJ2vkdTiT+RGYvf1NOc1YImGTyvgqLdOGKoSaOAPf0T6HXDn+sukrVFPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2ScBP8Mj; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2ScBP8Mj"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cbl8d6sxBzltBCk;
	Tue, 30 Sep 2025 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759252591; x=1761844592; bh=8uI0EOW02UJQ01YdYKv6yRXG
	Zqn6rtOmjULACCc5Oyg=; b=2ScBP8MjUuqEMXpTOQGlQbMAXwKzNbIBwy+Oy1Da
	TQvjMN0KGWijT1Ggs45xke/1AESGuQx52KQ3CMx/JcIVDEJcokNT9wpS9OzxaGVV
	c8/vvag0uf8sk1nWpPwOcylVdAGIDqdc6KRWeKRrv63f3CzjtfYrza0VYxJelghx
	G80yC/kBez/WFbEfGDsku2wImbmuLkFsm9Yyp5TzwIfB9oQ+AHtbn6uqvKIiKpWy
	ntOieExwu7jCUDXmO2OstMs3Ks6IgEdM7RIaQXB0kmElzlBdk/tTzRGNEF4r5cmD
	sqetE5l1bl+GJyAZMzMbZCffffTmF30ci532b2DuAw1Cww==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Go1pcLbn_Xdb; Tue, 30 Sep 2025 17:16:31 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cbl8R2hDKzlrnQG;
	Tue, 30 Sep 2025 17:16:22 +0000 (UTC)
Message-ID: <b2ece8ae-b7b7-49c7-81d6-087dd6a4a12c@acm.org>
Date: Tue, 30 Sep 2025 10:16:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Include UTP error in INT_FATAL_ERRORS
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
 jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
 kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgs@samsung.com,
 h10.kim@samsung.com
References: <CGME20250930061604epcas2p3f341c32c50f267aa6bd3ae0e82adfbf3@epcas2p3.samsung.com>
 <20250930061428.617955-1-hy50.seo@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250930061428.617955-1-hy50.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/29/25 11:14 PM, HOYOUNG SEO wrote:
> If the UTP error occurs alone, the UFS is not recovered.
> It does not check for error and only generates io timeout or OCS error.
> This is because UTP error is not defined in error handler.
> To fixed this, added UTP error flag in FATAL_ERROR.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
