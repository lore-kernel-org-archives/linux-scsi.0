Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BFF3D5259
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 23:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791502041; cv=none; b=Y6z7kUFMxX9icGtFDn2LlH9TJbNBFN9tPGHWyDvcsx2sMH2pkSBzmFf0e/5lWh0ZBHFm6ccMQ52KRH9PIw2lRsBS/A1AQdeGBmwlD7293DAhGA8nr7fCeY74Icsfkx1YkDfxXJnpSzXNjCGb3kYrgKK6jkzCN9I6YeNMq+Sl9T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791502041; c=relaxed/simple;
	bh=7/lUnei2N7JKunFbL0jSOJCWLeZ5DdBaDpW66Qg5G/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XXBgTWhDVNq77wGXt+owSQv7Dai3z7JL0VLUY4Ov2fa9cZYAYDiU+U8hmgTonjSMfzTS7UuRgQNnXNAgzZmajUsjqoIyn6YiLrKTDcpl+CJOH9v6f/hO4GRdPq6mZ5+wZINslbdP5sI4VhhnhUlzhsRpagogUeY6s1UQLzDott0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3HEwS2xA; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3HEwS2xA"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j15kH6LbczlfvpM;
	Thu,  8 Oct 2026 23:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1791502038; x=1794094039; bh=7/lUnei2N7JKunFbL0jSOJCW
	LeZ5DdBaDpW66Qg5G/I=; b=3HEwS2xAwobf1LR7EP9iYdltyynAg3hmR4Zv+bbQ
	q4O2u1FBNRAVgaIjTVlB+cgtLglIX3piMu19567N98MdUtRzqcSaiuZ/TuSaok25
	m3Kp5Zf8+1TI4yTCopTd5OLV1LWCe96hdKxwbrRcZYazIsa+l7GZa9T67ic0bijZ
	Up1cRsFJLcm74rzqa/hU1zrAOqnsr3A18k9RZ4brf6503+v7GzYb280uer0A1M69
	RAlVy487i5/cpX7DQYmFFgMKBkBIyKGDEYEfJ4sA6E07tyt8jIQBTsyXoVmIax5w
	g54Uy6sEMsRQ+mueoSxu9kOJhL5A7GaZ+ditCnoKe1wCvg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kBSeSqFy7DwG; Thu,  8 Oct 2026 23:27:18 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:6825:e545:ab06:fef5] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j15kG1pWNzlfvpH;
	Thu,  8 Oct 2026 23:27:17 +0000 (UTC)
Message-ID: <ef54993d-7a72-456e-80e9-2daaaefef7a1@acm.org>
Date: Thu, 8 Oct 2026 16:27:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/8] scsi: scsi_debug: Split resp_write_same()
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <cover.1791499174.git.bvanassche@acm.org>
 <1127ce1be450f0c4503845b41eaa24c27aba373a.1791499174.git.bvanassche@acm.org>
 <sashiko-outbox-164650@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <sashiko-outbox-164650@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/8/26 3:52 PM, sashiko-bot@kernel.org wrote:
> [Severity: Medium]
> Does this early return result in a data race on the sip->storep buffer?

I think this counts as a preexisting issue that has not been introduced
by this patch series.

Bart.
