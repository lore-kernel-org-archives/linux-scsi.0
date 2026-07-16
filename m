Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19FF2DE709;
	Thu, 16 Jul 2026 17:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784223780; cv=none; b=nHjcpfw1Qkgv6QBz74kzEB+WHTTk2kr8aKJxdKi3ryd3Oewo2BHS0sSWMbHe3hw7t3RTryvmOMBa5d46b4E3+8ExIr87wU+5oH5Ufay1k2l6luePC+bnQtPxHF37gOGNssHl09bJTdzNbJ2coISI3KIScPtY/BxsNYDewOleqU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784223780; c=relaxed/simple;
	bh=RDf/mPBvq/H2B8zoQuKxedCf5t69d1nz/GmzACk7B/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i9v2hslRI3ZoQvn2bbb5M3XCVVClXqfiBQoi8fG1PpilwRofaG0w9qDFXY8FNRBn2QgDOi+BAlQkdUApI5NOiuHDHbADvFzH1gKgbE3ImNkw35+hujx+UNw0i/wRaXJRZKpC5dGbhj4eSWJbN6SCDVgOnwTCqFOiwm4YfZSt5GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=u4HjO2qs; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="u4HjO2qs"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h1L3k2X43z1XM6JB;
	Thu, 16 Jul 2026 17:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784223772; x=1786815773; bh=RnhnAlsUQYi4k5TCCQfAhI/a
	rhqQSZILk46BiZnUZTM=; b=u4HjO2qst7NxuSuijqoZGWxsZhkQStg5R0yAJZ29
	IWpoqkHQpelYiM3B0LBI9yNzlG0dcYY1X9QhOyVRaqrpblbYedJoNVW/jjrmo56E
	vnjbc2aEngpCy7OYrZantALGrcHLDNH5O9BZF9KjXvcq45thpQIcKAPYFFrwck65
	sXwDGMWwZGYx8JlGv59YH8s1kP/eqwpZy8be1jGM81s7PyCk/LpGek5i/vlFXAfM
	ttqn6K2a/alXFNvdUXi5l2JThBQxf6og2MMpS+44wX69dsGXcuQNsNvJlRBQuwRn
	l3/vG6v9L5N4s1rhRB8xZd6/QcxTZwVO2PmUbFa5X2DKBA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nMwGlBHPZ1h4; Thu, 16 Jul 2026 17:42:52 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h1L3Y1hX5z1XM5jn;
	Thu, 16 Jul 2026 17:42:48 +0000 (UTC)
Message-ID: <f7367a69-ae99-4916-a6c7-93ac19c3863d@acm.org>
Date: Thu, 16 Jul 2026 10:42:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] scsi: ufs: Fix descriptor parsing and invalid input
 handling
To: liqiang <liqiang01@kylinos.cn>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com,
 can.guo@oss.qualcomm.com, adrian.hunter@intel.com, tomas.winkler@intel.com
References: <cover.1784182493.git.liqiang01@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cover.1784182493.git.liqiang01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/26 11:19 PM, liqiang wrote:
> The first patch validates string descriptor payload sizes and avoids raw
> descriptor overreads. The remaining patches protect command completion and
> MCQ cleanup, validate connected lane counts, validate RPMB frame sizes before
> parsing, and retain a NUL terminator for debugfs input.
Since this is the first time that you are contributing to the UFS 
driver: how have these issues been discovered? How have these issues
been tested? Is my understanding correct that these only have been
compile-tested?

Bart.
