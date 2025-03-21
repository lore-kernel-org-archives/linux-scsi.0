Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007081DDA09;
	Fri, 21 Mar 2025 16:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574743; cv=none; b=DSKaDEdNz/GFnSw2rfReHoPg56NboCjPfNzpiWk2oE6STh01kOeMHbebf8mDWw5yfjlmAPL+9dSuktw/mddGL+XUCWkBdh3EHyVHVsxCZxgwQkvZ1UJlzvH+iYtPQz+95pi0xymSqtJj10qnpXo2nrak+Rjzn5Gz54keMTlosfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574743; c=relaxed/simple;
	bh=+5t7JiGZ8ox7V6WMRNQOwYFA0BHvaRGlQ8zdBipXe24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XfO79qZDQY94+huQnBFX/Q5nZLN3SZn5vyNVpIhD2OHwAl6TutTN8ExImXFqrswaLCCRCtBf9mLVSWUFYLZDc91zPKdz72ZYai/JNYZ99F18p+snUPwh6ODyJx1l1vcsLaH0a7gkzVlr6yL8dv6aniJV78bgeWgH8VYU0HiA8eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VnAb7wjr; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VnAb7wjr"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZK7JZ5ZXbzm20D0;
	Fri, 21 Mar 2025 16:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1742574731; x=1745166732; bh=UlxzR0XCJ6n7/EMEDMj0k4zb
	JvMo8W17G4J+lkLDXOE=; b=VnAb7wjraE+UDMrObmRranb8RoRXA4fsK1ty4emt
	NEeaHise91Jx56D4Aea7ZJ9liyuEOv+7+hQOrqYqpJDaY+SUM+X2CQkRwUllNyvR
	t5e2jS+zalQ30COcnicw2cqrOH/e6WHY9epTqcAh6ebbL840ifjfR0WIeSVtQ9Re
	N2Ul8pq2N3GN7clgxX+8tNWG5cOOeP+ZgaQgPadRpxNtpF92Qh/hrEwXwinwA46z
	BpuBoOfj/2MRh6Y6MM9qFG07UIpJnKyjNszy7TCE08dMdFCkVovGUohkWthTmj+J
	ZSw6+apTPIazlG8IMnAL7bDtRknL+uKLvTdk1cfLheAuZw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id S1yP9yQA0YLC; Fri, 21 Mar 2025 16:32:11 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZK7JD42sNzlyHFL;
	Fri, 21 Mar 2025 16:31:55 +0000 (UTC)
Message-ID: <6cc97521-aba1-439b-9c06-a5a06adea498@acm.org>
Date: Fri, 21 Mar 2025 09:31:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: add device level exception
 support
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, quic_cang@quicinc.com,
 quic_nitirawa@quicinc.com, avri.altman@wdc.com, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, minwoo.im@samsung.com,
 adrian.hunter@intel.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Bean Huo <beanhuo@micron.com>, Keoseong Park <keosung.park@samsung.com>,
 Ziqi Chen <quic_ziqichen@quicinc.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Gwendal Grignou <gwendal@chromium.org>, Eric Biggers <ebiggers@google.com>,
 open list <linux-kernel@vger.kernel.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
References: <4370b3a3b5a5675bb3e75aaa48a273674c159339.1742526978.git.quic_nguyenb@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4370b3a3b5a5675bb3e75aaa48a273674c159339.1742526978.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 8:18 PM, Bao D. Nguyen wrote:
> The ufs device JEDEC specification version 4.1 adds support for the
> device level exception events. To support this new device level
> exception feature, expose two new sysfs nodes below to provide
> the user space access to the device level exception information.
> /sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_count
> /sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
> 
> The device_lvl_exception_count sysfs node reports the number of
> device level exceptions that have occurred since the last time
> this variable is reset. Writing a value of 0 will reset it.
> The device_lvl_exception_id reports the exception ID which is the
> qDeviceLevelExceptionID attribute of the device JEDEC specifications
> version 4.1 and later. The user space application can query these
> sysfs nodes to get more information about the device level exception.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
