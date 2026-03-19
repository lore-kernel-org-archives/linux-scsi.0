Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967DB3EC2FF
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 17:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773940879; cv=none; b=Bu4zd7cj0BZYqf++2krD+eQnb4zqOWMBVhiObAuCBvftGy146ZBGLEvKyKOnHfEOulv00XaYtSY08VbOmfvi7FFSV2jestSMvbrqNGO8xzOdCn97pGstVZvGzNCsowBZLznUrQrwH4uMSyr+zTqSOuueks6W7pouLWw31L6fmOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773940879; c=relaxed/simple;
	bh=wGDJt2EeckAiiEp6j7hhtEYnqCGOxZo+hM+YdjFK5U8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oV3sgWnzKuX3POyiiu4zp7Uphn0MzIikuWCTxP+OjQI0hGInVS6qPSy9Wx9sJSNcJ9RT0KdYQ37WZaUrvsdl/izNuVug/U6ED33x2F94jFkJ4WiPYuLuoJCJpvtMJX70gYDqLpb4uMduzXb0worT+iBCeW8ew7brlW0S9Ps79Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=19JsIPDp; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="19JsIPDp"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fcCCb6XQCzlfvq4;
	Thu, 19 Mar 2026 17:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773940874; x=1776532875; bh=wGDJt2EeckAiiEp6j7hhtEYn
	qCGOxZo+hM+YdjFK5U8=; b=19JsIPDpuStmlJrbWGE4MQwL+EC2QLCdazvUzkhG
	UOj8ExBb8ibljVQ1Sg2AvHbOG1EL9KP7fqw0kFe2nfESO889Ug8KkyICfoucbX3A
	ErjLGyATIdvhS5K2W/y9IUCYhW1DUGHHF7FNFFJoAteWvZMXBiA+kYeW6KW/NL0R
	B3Hqg3Qzu79h5745fi9Lja2urQj0dLl9wIbvUo0H4rDh6/TQNYEYRHL+AIFslMmg
	fSYgDBhOT2OeLOwJywkmj+Ck5QGvLBYDRaGWPguf6NlrBUZPRuhHeOzE8Ycel1NM
	0GlUHiqp+E0rC+5H5u8gIy9lSRL+WVLIayS6mwSIqcPJxA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jbqvOtOJFwzP; Thu, 19 Mar 2026 17:21:14 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fcCCY3MfmzlfvpK;
	Thu, 19 Mar 2026 17:21:13 +0000 (UTC)
Message-ID: <b112fa95-3586-473d-89b5-7dc7c7a7badb@acm.org>
Date: Thu, 19 Mar 2026 10:21:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: fix missing put_disk() in sd_probe() error path
To: Yang Xiuwei <yangxiuwei@kylinos.cn>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
References: <20260319065759.2413777-1-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260319065759.2413777-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/26 11:57 PM, Yang Xiuwei wrote:
> Call put_disk(gd) when device_add(&sdkp->disk_dev) fails in sd_probe()
> to keep error-path cleanup balanced.

Fixes: and Cc: stable tags are missing. Additionally, please mention in
the patch description how the issue was discovered.

Thanks,

Bart.



