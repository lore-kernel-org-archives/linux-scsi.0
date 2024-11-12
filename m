Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A272D21746E
	for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2024 18:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731436818; cv=none; b=ZYnlyB/JEEQ7vd7+6PvXIrSY8eOVHhubE5UUA+ZjixKYmtzFeJS0DPcoC/8WIXnE/ZQAr/5JRUWGd8f93DyMV/6Hq59mgd/Xd/6FWqWugKF/IsPRUCFlWVOSuBkZksoqvw+OOhp2GrAoK9WLeWBCp6ZIrUOHkeiPb5uI9VsR1lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731436818; c=relaxed/simple;
	bh=IPgbGVT9VQz52LhJn0V7rIBHilgnV7bTXOaK5vP8au4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VUUI79pKm7WW3wgT781me9G5reWydFCXeHhw6jEm9RZGRhlG8ks3yOQKyYiydMnigi0kPFMM+jUxBOUw3Lmepp4OnLAkJGd2K5A9Z91NXBsZh/RYh8FBSI5svEjUspEvWZJxoGb9arhTTTTtPmAoGp3QuxA57hPHniPEtGqmZFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3uTyePyP; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3uTyePyP"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XnwFq27wwz6ClbFS;
	Tue, 12 Nov 2024 18:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1731436813; x=1734028814; bh=IPgbGVT9VQz52LhJn0V7rIBH
	ilgnV7bTXOaK5vP8au4=; b=3uTyePyPvrCBL4bNW77RHxyNUVOiaOVCgehwdGmC
	zQpeBA4AI6o222Oq+lNhCI2iXvu/xSItCdADzOWsSjT6ydTJ9Sf3fhbJCKkoFVIe
	8gFuo92r1w/YCAdxQFb/azp2lqfRsblS8PKR41qqWiXJx+L3C0TIFry18oxDdrXX
	VOhoJmbX0WBvRpdvhDXogE1fVj2IiItuBTvFp0sh1qRrziOYncMrlYS4Get5nglk
	fCTjZcpycGc+PRx4mjvHrjGhhhkSYIwOeahkiOx+kIt+imBDNSE3V7lUqMz9Hp8B
	d6a4AQFPKps2OLGRER+X3AGJI/UR5TUHiBHd8SJ/R9WFWw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JAhCMhVwcG4q; Tue, 12 Nov 2024 18:40:13 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XnwFm3C2nz6ClbJB;
	Tue, 12 Nov 2024 18:40:11 +0000 (UTC)
Message-ID: <d846d118-e4ad-49f2-96b7-1cbf1363fc44@acm.org>
Date: Tue, 12 Nov 2024 10:40:09 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] scsi: ufs: Bug fixes for ufs core and platform
 drivers
To: manivannan.sadhasivam@linaro.org
Cc: linux-scsi@vger.kernel.org
References: <20241111-ufs_bug_fix-v1-0-45ad8b62f02e@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241111-ufs_bug_fix-v1-0-45ad8b62f02e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/24 9:48 AM, Manivannan Sadhasivam via B4 Relay wrote:
> This series has several bug fixes that I encountered when the ufs-qcom driver
> was removed and inserted back. But the fixes are applicable to other platform
> glue drivers as well.

For the entire series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
