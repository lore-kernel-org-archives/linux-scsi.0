Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19702348886;
	Thu,  6 Nov 2025 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445412; cv=none; b=Gcga3X8j9jB8Sv/vvQXwArDj4u/odmCbQTMh7Lh9P+thjHq8kqgoMiRoNFgyGRVvHcpb9Rsg6K5PMo+jVg35u2GerwtCFu+TZkWCAR3HfAhVlXr35CD8yqOl7tMhMw4NbvBvleqAMCVBer6C8tMnrrlFtnEIlWjf3ib58qy/GAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445412; c=relaxed/simple;
	bh=yx68jlp5TVW8MOPOBmFb/CHXQ8Lo0PuueyYV4FbHxQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fd2Q3A4y6fpKmhEgMRRjtcEfP6rH5n2+FxXV4UFxalkjMlADqiqKdNqrcraT1G1U2jI3KyhsHhlidYDEUiN2Zy2inHg2lpw8WZpuqLTC7nK46nuvg3d3zDR6LNt7Cntd613uiuNa6nBFGMjsoZAfcpNfgPGYN88eyfTCU3QSWhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3CoxJcgt; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3CoxJcgt"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d2Rwy0qmSzlwvjn;
	Thu,  6 Nov 2025 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1762445407; x=1765037408; bh=JbOXav1hK+I4AqaED7t1ngzt
	AeFVpDmbg9zDGi63jIg=; b=3CoxJcgt7kXKzraXuTQ8pwvKnzMvzwEhd2x0J9I+
	Xv8y+5PZCiql5qxbjNtIZ9LT0rY48tMZGzT5t8T0oqb81LMzHE1H/bQCjdzqjfQF
	aGtCGeI+Hwl5KIh6+oHRp6Eq7bRpGrqWtxk/Ih9fp3NdyQZQqqSFEL9w7zcRRuqH
	XYphQ45rWrXuqw/nlvIbU+/zmw2uwP/pF7FxbegxhyHSl0eq95XF84bWc9i3daPS
	zQaFWo/flh8xVgZmkxxOsy0f9L23HDuzwlQ+fuwruXGP31J+mKH7GIXDh2uhBPST
	rKSpr4fypKF1dsft7HWvzvf/V/dgK7uSpJc8OoX7LUJ+jA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WJYavAK_KNg0; Thu,  6 Nov 2025 16:10:07 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d2Rwf6MLszlws8b;
	Thu,  6 Nov 2025 16:09:53 +0000 (UTC)
Message-ID: <7a4d0770-cb2d-4a0a-b82a-f9da635ee36f@acm.org>
Date: Thu, 6 Nov 2025 08:09:51 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: fix hid sysfs group update
To: "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Daniel Lee <chullee@google.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Gregory CLEMENT <gregory.clement@bootlin.com>, Udit Kumar <u-kumar1@ti.com>,
 Prasanth Mantena <p-mantena@ti.com>, Abhash Kumar <a-kumar2@ti.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251106-scsi-ufs-core-fix-sysfs-update-hid-group-v1-1-1262037d6c97@bootlin.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251106-scsi-ufs-core-fix-sysfs-update-hid-group-v1-1-1262037d6c97@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/6/25 2:46 AM, Thomas Richard (TI.com) wrote:
> Without UFSHCD_QUIRK_SKIP_PH_CONFIGURATION, the UFS core fails to create
> sysfs groups due to a pre-existing hid group.

Please help with testing this patch: "[PATCH] ufs: core: Revert "Make 
HID attributes visible""
(https://lore.kernel.org/linux-scsi/20251028222433.1108299-1-bvanassche@acm.org/).

Thanks,

Bart.
