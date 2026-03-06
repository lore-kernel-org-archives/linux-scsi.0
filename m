Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CFC2E8897
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 13:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772802045; cv=none; b=PMqne82mf/LfTQI7qk/+1Iuh34Rck346XSpZh82SxL4ysuMf61IecmgvLtGmjIQlzUijZ+0bRtChhgYCS4wz+X5a9KDNtyU+gxg8p+Guz0YhLoGX0VjPl3+y3EE4dSrf0gw918Vry2BcicSVdro/XYoFgSO6Fc6uzXSmJShmF0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772802045; c=relaxed/simple;
	bh=FTWCEgxsIFL5rqSjlUXUxvNiQA8jhw8NCnxQBv6Nrm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EFRCPeSPCJewon1XoFGf+zyHpZQQosdeGZT5r0hn5WJX5fbZgGpuVUIhfIWz5cQfajPZS1LEDbTwQoudsde4peirmGJLW61IBPN8ZQUHS3mE6jfFStmHikMtm6BJDMDhccX1Ptf5+FI7kdhpaOtu5qvT8apmIMCwi0hFfAW0fto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KCYNTC3o; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KCYNTC3o"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fS63020qLz1XLyYZ;
	Fri,  6 Mar 2026 13:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772802041; x=1775394042; bh=FTWCEgxsIFL5rqSjlUXUxvNi
	QA8jhw8NCnxQBv6Nrm8=; b=KCYNTC3oOpo3LfrZl8LDTNpFmFn1gdXlqEEkMen7
	NOYp0UeAF1YQ/zAdiYAJVNkcvKO6SdaBwjTLP2SI3Ssnp9FwuGtfw82jXQqKiyJE
	ZCU9Ph/chfFG+baX+zXyUMtW+k4473comh19gedq+CKZ6bC3uoAa4wMbGCvHcuP4
	wVvsTl7Bfwp6f4FG/ES6nVAGLK/l1gI8w1ndCKmhh7seMiISIyKNuNJxG3pVbbQm
	yAnUAOEUvHI/Yu9+bzq1vvI68InRUWcv7bkPZaCYKjcGUou+sUGyLkDNRZeFo1/X
	LW1giSCa+EWIU85r2flGDr/en6ePsbFV77n5vf073Ji1WQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 58NB20eqm7M0; Fri,  6 Mar 2026 13:00:41 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fS62v39Dyz1XM0p2;
	Fri,  6 Mar 2026 13:00:38 +0000 (UTC)
Message-ID: <15409eb0-53c7-4d15-a29e-653b3415f4df@acm.org>
Date: Fri, 6 Mar 2026 07:00:37 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 11/23] scsi: ufs: mediatek: Remove undocumented
 downstream reset cruft
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "kernel@collabora.com" <kernel@collabora.com>
References: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
 <3472277.mvXUDI8C0e@workhorse>
 <2a68eb32987c21b6a48547ce044ee38d1eb01fa5.camel@mediatek.com>
 <4282403.mvXUDI8C0e@workhorse>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4282403.mvXUDI8C0e@workhorse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/6/26 6:53 AM, Nicolas Frattaroli wrote:
> And I thought putting bindings through bindings review was a basic
> requirement, but apparently not for you when you can subvert the
> kernel's review process and push your downstream crap into mainline
> willy-nilly.

Please keep it professional and focus on the reported issue rather than
attacking the person who reported the issue.

Thanks,

Bart.
