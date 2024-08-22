Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4135C1D130F;
	Thu, 22 Aug 2024 16:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724343847; cv=none; b=n/jplLC+4+2gn4qzjGVWVRfav2RSFK28vC8lZtQQgASQmL8E1vc2Q6A/Ot1GUnbAuu6FyJsv8yeYugZLqV0Fmwgn9lNg3E0VtIusj3NDpUFfum0J+W5cQNutQQqjxcj5Eza2rHmdQNWqgIgHyQeEa1jLTj5GyD7bACErpbpJ5kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724343847; c=relaxed/simple;
	bh=SwqBy/IFYkSdaGABowxYG5PFUg0JN/99ks5RBxE5S+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WkNOrhnCF7OzacejJAh/48ipM3qyJaWx2WytzaeyRucnKCie30U+typaOtMvxD8YJ957sKZ7epfXZR8e+f1I6OhKuuIhaLlbNSHJ7fuYooD2MBtBIs3uRhNqa5tG3i4ul3ekPl/epPChxI3FvIFLFfWpuvxisn9nukRtne622eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PAPM7owE; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PAPM7owE"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqT6Y41Ndz6ClY9J;
	Thu, 22 Aug 2024 16:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724343840; x=1726935841; bh=SwqBy/IFYkSdaGABowxYG5PF
	Ug0JN/99ks5RBxE5S+Y=; b=PAPM7owElkhyjgHV4tA9gF1hkyKQCfiX+vtJeoN6
	5Tw6LRD8vBoTnxdbrvvq9lX3ED4kr/TEdLfXJbIJBoR3qb4vfC2RUQtRGOOD+7qB
	uJjF1YSvamdHp2+HnJc5Ma/sxq6ixEic88quP5xq80iDYSEGrns5PtRDddEwuxMw
	MTHb4VtzPh0TgAkU9ONQO1IZk7Z8HoELszMzqx05HspZgYrFRSel6tdSP2ibaDHy
	t9a/qD0IhwhzIgFE0ZGL4UozbuXy/dn9G2LtEPcumdXRPoHBnu7d5t6ZWUlR33L9
	7+VZ4TlWrdhQ01CWN501kSnO8SaLbXVS8xjqyc5/TSHTag==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BTZvaIiRj0pn; Thu, 22 Aug 2024 16:24:00 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:2a97:b8c7:bd2d:fb28] (unknown [104.135.204.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqT6R0GnWz6ClY9D;
	Thu, 22 Aug 2024 16:23:58 +0000 (UTC)
Message-ID: <0ad83cb2-3835-4438-a7c3-398b1ff5798a@acm.org>
Date: Thu, 22 Aug 2024 09:23:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] scsi: ufs: introduce a callback to override OCS
 value
To: Bean Huo <huobean@gmail.com>, Kiwoong Kim <kwmad.kim@samsung.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, beanhuo@micron.com, adrian.hunter@intel.com,
 h10.kim@samsung.com, hy50.seo@samsung.com, sh425.lee@samsung.com,
 kwangwon.min@samsung.com, junwoo80.lee@samsung.com, wkon.kim@samsung.com
References: <CGME20240822111247epcas2p2d3051255f42af05fd049b7247c395da4@epcas2p2.samsung.com>
 <cover.1724325280.git.kwmad.kim@samsung.com>
 <ed370c6355dee6a4af15587cdbb3b06a1fe0b842.camel@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ed370c6355dee6a4af15587cdbb3b06a1fe0b842.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/22/24 7:54 AM, Bean Huo wrote:
> I didn't see your above two patches following your cover-letter, did
> you send patch with "--thread" optioin?

I haven't received these patches either but found them here:

https://lore.kernel.org/linux-scsi/763ab716ba0207ecdad6f55ce38edf2d1bc7d04b.1724325280.git.kwmad.kim@samsung.com/

Bart.

