Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3F223536B
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760718367; cv=none; b=gY8N0H4KV+tNr8muqACivWmn08p09jEwv0zhGKRRHJt+br2oKA78i8X75i+U8JJdLpgjGloLX3daZel//RxoinRAQIplZPKO4hwGmqqF0dUmC8DaQx87UBTHIA7FQLc7f/pk8uPZ0C7Q01QeYd214sj3dGbi4CyQ1UimGzGQRew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760718367; c=relaxed/simple;
	bh=yQhS/p84wVaVmjt6wp9vLTPOQvrveAknYJJxF918Ny4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V/PBf+ToThtaEXEgEmV1mlUhJc3+EBLMmLBQ1RfeVokqNWfzeZ0k2GLmhVKAsESYCmJ1wrzoWOZHw5d6kHR4j0oWPvJV7O8HKt8zRfA4CL+zyndPADPKmoL6J06k7GkGIW1tOU4RxtBfFiXmPTPPfIkYVwSf42Gvq8W8GkQVHQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=v58klolB; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="v58klolB"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cp9DW2Mfszm0yVN;
	Fri, 17 Oct 2025 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760718361; x=1763310362; bh=ZMA3zqGztcSfgYnsohjerRl3
	leJavYs/1vPN/qDayA4=; b=v58klolBypf50j/tUNXv0ij8oznJ3WH2CUt2psfT
	r4l86oY8EOO0Xkk5q0noPriH9xlgLnGA+MsfoGUn7+8nF43YoT+1QQV4KcXBb8bw
	E4hFWSDxeE2ScJr0SQpLhifGAQCpgrcsve0yO9bu5NELzSvGcBA1gYx8UORDoKyv
	PB+V8R5UD4WFxwYUBXrmmsHRkr1m8xQGH8uMRRuAoGjUp0sGQ9rhxx0ucFBbylZ1
	+3dZLrkNHuu4LDU77sDsY0XrHMh7d9zqJkyIMwSxZEsh4p5by8ssHPys713hWuGI
	fWtV6rFYvK2pgnwOk2iY+QBTNqvSFSJdKP1Psfwfq0sWEQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uhc-6xZk_P6Q; Fri, 17 Oct 2025 16:26:01 +0000 (UTC)
Received: from [192.168.15.91] (unknown [216.194.108.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cp9DL1lCnzm0yNQ;
	Fri, 17 Oct 2025 16:25:53 +0000 (UTC)
Message-ID: <569fcd05-4d77-468a-bc8d-c86d0a5dfc8c@acm.org>
Date: Fri, 17 Oct 2025 09:25:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid"
 attribute group
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "chullee@google.com" <chullee@google.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
 <20251014200118.3390839-2-bvanassche@acm.org>
 <22dd7d580444be92d0029694468cdddf1ac98f13.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <22dd7d580444be92d0029694468cdddf1ac98f13.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/17/25 1:27 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> How does the sysfs_update_group() call happen from the context
> of the thread that executes ufshcd_async_scan()?
> Do you have a backtrace?

Sure. The call chain is as follows:

ufshcd_async_scan()
   ufshcd_probe_hba(hba, true)
     ufshcd_device_init()
       ufshcd_device_params_init()
         ufs_get_device_desc()
           sysfs_update_group()

Please note that this call chain is only taken if the following quirk
has been set: UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH.

Thanks,

Bart.
