Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5584E36A37D;
	Wed, 20 May 2026 16:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294317; cv=none; b=SkTNXZTxdhnHNBwsd8/g604+IAq29amVbjmjftfHk2AcbJPFRzvGNWCbFHRImL0hS97gauMY4RmKmwsu3MAy1xKNL2NvRFw2Viyt4gbh+npMku9vG1TpJ4ZGRd2jMM6DhzyWs5nP23gjg8qjJ47xOOhj1z3uPhv9S7/ISUgRdeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294317; c=relaxed/simple;
	bh=Ol95jQLfrdpBQjki+prXK8uzkfnEQdpuJm1VdFo8jb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KN07CdTupkuiG99k1VXePYnsaqYqrqXOJqmL+Snsw84+PwaHTFGShL7qfIzdTnSyXqwmja8dRZ9tekmjtK6x1EKxuyzNkQOzpAqBQZR5TM5DhXzN4oOek75EHXRJGepnznIQ6wfawIe1gZBYMpX9V4R4Nw4y9IwJYv8ankSOCy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FwOxSY3l; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FwOxSY3l"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gLH2M54CVzlgyG8;
	Wed, 20 May 2026 16:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779294311; x=1781886312; bh=AvSIL1R5mmJ05UNrpWz3pGju
	V/pjdLSvASGCbp0aaM8=; b=FwOxSY3lDGx8jPrdCT/3PISLmROvw/7GlQWyt1B5
	t/Bf9nVEugzURnWG00MnzOcTt/Ee4HjfKDC5R8j0bu8enYnu6yn8z9sakRCBRJnL
	rO0qx9abqcWCJpZkeqIiFrAEEuP0X1fGPtTNMmERnorSg0C1FuRYXyzS4qrYRmpr
	nkszg+xOXP/BB+bzxMiD1M6QyyrdHPzaEE8m76SM4hqTqQWw6E3P1l34W3N3RHWj
	0rWE4ctT1YYVoBxg0BVA0JC3xG9hOd1/i7mU0FL0jstiapFBUmsqQ5cAfSjfFkXz
	zLqRtuUmMSbZgjm6lwCs7RmiSX5SM/BCF2DxgOkN/MvE1g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6Y32Apy0XN7v; Wed, 20 May 2026 16:25:11 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gLH2F3xmtzlfpMC;
	Wed, 20 May 2026 16:25:09 +0000 (UTC)
Message-ID: <806a798d-b2b6-489b-93e3-0fc54eaa14eb@acm.org>
Date: Wed, 20 May 2026 09:25:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: st: Fix lock leak in st_ioctl()
To: Hongling Zeng <zhongling0719@126.com>,
 Hongling Zeng <zenghongling@kylinos.cn>, Kai.Makisara@kolumbus.fi,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 djeffery@redhat.com, jmeneghi@redhat.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260520074016.51975-1-zenghongling@kylinos.cn>
 <6A0D6825.8050902@126.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6A0D6825.8050902@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/20/26 12:52 AM, Hongling Zeng wrote:
>  =C2=A0 The original code is correct. st_common_ioctl() releases &STp->=
lock
>  =C2=A0 internally, so there is no lock leak.
Indeed. See also the annotations in drivers/scsi/st.c in this patch=20
series: "[PATCH 00/36] Enable lock context analysis for most SCSI drivers=
"
(https://lore.kernel.org/linux-scsi/20260312211636.3245119-1-bvanassche@a=
cm.org/).

Bart.
