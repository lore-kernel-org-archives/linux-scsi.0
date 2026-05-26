Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8893E2D9787;
	Tue, 26 May 2026 19:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779824949; cv=none; b=astqfv/ycubEgduOnzdHnFmlMhdP41YUSChR4lg3l3O2iP5c5DwWHtYsUSrI3hlWuKovZ7HQ0MEjH59ttucyiRwowhpIYhYZv8xLWQuy/j+PjfbjY69bvkaXQJ1C2gXMnsKhLyRu0PxTBMlYghHEkP5oJBPyeIdW0sJmx8KZKPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779824949; c=relaxed/simple;
	bh=FtNPNmMIbAuEorlBQg183rlpcFZIYyJe2Ccj+Fx/Sek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qu1fZP0/t+3NR60BIoN+MYCmlA2qjUDdAlU7OjxjLGc9pS0sTBZzCxA0cmt0xZ03wvGcSgJXhxovR69FOiGe8uMlasaiev0KH37aL7JMsUluwEUOsZSuT5LhjkU+fmQQV68OILKIQR8XOWUUvL9bu7L0tlAu/UM/nkRXHbyuaWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3v5uzTiG; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3v5uzTiG"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gQ3Gr02kZzlfpMB;
	Tue, 26 May 2026 19:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779824942; x=1782416943; bh=FtNPNmMIbAuEorlBQg183rlp
	cFZIYyJe2Ccj+Fx/Sek=; b=3v5uzTiGaZewq6vRjGxfZRFaIgXen2QUvCF2JPN0
	eJuJGNJvvIv/r5UDPKzvgQPajZKB8xz4d6IHuftUFmjhytpLhAkyLcSITjYg3jOg
	QviSe1GRAkG5Lden+6adLkUU3RO2SBxP0pqMRxTSlCdw/xi+UqNl/k3F180mrJ3W
	/aNOFUF268GGptihzmkijukgO3f62O6uqr11QbdWet2Pmv1gYw9tKAyCpD6aa5qX
	+b5ErKTc5Lo2PBlNTVKwvHUxQM+iD5hefZpx+npsR+AWVYW1LiqgsjMePFlZNNQZ
	zfkKKuvO7z2wiUcDxWSqzZodPaZfMKGOQH94w2ZavWdYbg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id G-AUGxi7Dbqe; Tue, 26 May 2026 19:49:02 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gQ3Gh0vB2zlfgQG;
	Tue, 26 May 2026 19:48:59 +0000 (UTC)
Message-ID: <668ff63a-1ef0-4fe0-aed0-e632158af846@acm.org>
Date: Tue, 26 May 2026 12:48:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Skip link param validation when
 lanes_per_direction is unset
To: daejun7.park@samsung.com,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
Cc: "avri.altman@wdc.com" <avri.altman@wdc.com>,
 ALIM AKHTAR <alim.akhtar@samsung.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "palash.kambar@oss.qualcomm.com" <palash.kambar@oss.qualcomm.com>,
 "mani@kernel.org" <mani@kernel.org>,
 "shawn.lin@rock-chips.com" <shawn.lin@rock-chips.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CGME20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>
 <20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/26 12:00 AM, Daejun Park wrote:
> Skip the check when lanes_per_direction is unset: with no expected value
> to validate against, restore the behaviour from before that commit.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

