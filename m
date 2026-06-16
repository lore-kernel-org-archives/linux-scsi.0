Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC71F30B529;
	Tue, 16 Jun 2026 13:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781617084; cv=none; b=FRCYWd1kwG6SXfIThV9QW6tuzzd9DDHMnGo2b5M5QYUXamWzp+g+cHmq5eZXBXZIUiJRNle2iNs0uQCNgC0Hya9GtN1Dnau7UW5McoqQgbjJ4yYzDBaQZDe5bMVG/uI4Lv5/yfVq4488P8pkld75iADmhdx7JTTpw++k3IqAA0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781617084; c=relaxed/simple;
	bh=LiMLrj4cuFPiOK244lJKnP5Ht3rcEBebE5gLFRG4qLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZnTgGaHbSmRiGVqaP2NLWZQOZT6VEZY4gAi9xqwFEgJqdr31i1zFn+efnXB5ku8EErBD93/iFFrC0AFxkL6fexbTDfy7CdIVKEOelZ2FYOhbW5Bv9vH7WS+dpwKtt5N2CYtLyRMQJjiffls+qDWdI6fxmBRW5XpNKb1MbJ2Pobo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Mj662X1Y; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Mj662X1Y"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gfp2s6g49zlfvq8;
	Tue, 16 Jun 2026 13:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1781617073; x=1784209074; bh=qzdnOS/8bKYKFDfK3PT3Mo5H
	mZfwIr6BF2MF+JM/FUY=; b=Mj662X1YTWfQYs0OV5XZRf5ZJIQJDxmkbKleC87o
	3+N6hYODcASR4VECI7FDe8L4OHuAmsWjHEPaYCjXEsxDh0N8KhzmMLnyQp61s70w
	TDbesq7K+9wO74YE60Yk+nUSaS5iayb8FuFyBuujPVl+yA07Kl6ekK8h/jbu2duN
	66fBI3bXqW2rJrIHrw7WcpcTuoy8/hHoErd948uNGIcAYRNv81yMj7umBPC7msuy
	7kDjzYvbs54BdwlaiA5wkzTt09mL+RI1QqzyQ+YkqEBTphUy0Nfe5eBxK9vUPr1Q
	0s939g0jPlZhDT4a+AY2j4HR1weR6r6q8wqa1sd23RNMIw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GDooQ5cB0UZF; Tue, 16 Jun 2026 13:37:53 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gfp2j3pTyzlgwNJ;
	Tue, 16 Jun 2026 13:37:49 +0000 (UTC)
Message-ID: <c040d167-8747-43f7-ac30-2f5c5bcfbc02@acm.org>
Date: Tue, 16 Jun 2026 06:37:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: sysfs: Add HS_GEAR6 string in
 power_info/gear sysfs output
To: Himanshu Batra <himanshubatra@google.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-serial@vger.kernel.org, vamshigajjela@google.com, manugautam@google.com
References: <2026061659-enjoyer-boogeyman-25c0@gregkh>
 <20260616100121.548759-1-himanshubatra@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260616100121.548759-1-himanshubatra@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 3:01 AM, Himanshu Batra wrote:
> In power_info/gear sysfs, currently it supports output only till gear 5.
> If operating mode is gear 6, it outputs "UNKNOWN".
> Add support for HS_GEAR6 string in sysfs output when operating mode
> is gear 6.

Some general advice:
- New versions of a patch should be posted as a new email thread instead
   of as a reply to an existing email conversation. Replies to an
   existing email conversation tend to get overlooked.
- At least 24 hours should elapse before a new version of a patch is
   posted. Otherwise reviewers who are in another time zone don't have
   the chance to reply. For large patch series, more time should elapse
   between reposts (e.g. one week).
- The "scsi:" prefix is no longer used for UFS kernel patches.

Since the code changes look good to me:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

