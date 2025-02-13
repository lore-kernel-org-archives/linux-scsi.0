Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0999744C7C;
	Thu, 13 Feb 2025 17:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739468093; cv=none; b=c4EWrAsRfHRcP5OLf42YaQcTnhE7iVSaC93WpdGkz/gQ5+AXjxwLPkT6/UCCv7RrjilTGGPWzOHMPpS8UwIO4He31p2QooHH8eAk6wD2CGq9Th8QjERKrLFE8PU/JAusTCT5TeYvXWSzj4dPFmT2O+ltq4RcynsmsqhiJP5Pz58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739468093; c=relaxed/simple;
	bh=uHxTBVuH8paIM72rg2CMMKIx8nDCXvftXlicGBUe6Sk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nFnVrRivwKo9GE32u5nq9qD2KIu1paGHMscpvZUTq3bCoLoB6onAgVMHeFOlE5CaxrZuxQToTpNxeELRfzKh0EPMhDuLobQpOT9vM37M/QHNTYbeFAiZc5bYvr7ysECCuPfjE2aKSX2UalJnPi4veqgnWtf4X6Zrr1fy5vCXX5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Kc8Tbz8F; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Kc8Tbz8F"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Yv2PR24QCz6CkxTP;
	Thu, 13 Feb 2025 17:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739468086; x=1742060087; bh=SlpGtDtSh+ycsUOXXlFzZCaj
	dsPxkmXnpGXfrjDn3YY=; b=Kc8Tbz8F8pk/W3NZdm03feS52nsI0RBiW2D6fg69
	TH8YAMFRuMp8wbemif+/rN2hfACHNqiOM3jHZn/bcGkwhBD63rNZ3IQGT+lUuMVR
	PHUvJXZfAGBuNSqAnCICbV5JRVDqR7YrUIVyspC95ehKOSOKB8RNlOvM0h1N3DWr
	byfBGcuRva2xrcY+14wCu4jw9oUkobKsl2QRy6yf96AKyzlEkEgcrLfAYGE3s+ig
	LF5Awqa1IqB3+jMyiyIG2eaAp689O2WxaRWJkt1ym1dic0oDjnYlJBU8fSe05FJi
	c/nEU6dABu5/Dd23//HM3nDG13zYqii9v936Bayq3djl8Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ynepo0qvne4p; Thu, 13 Feb 2025 17:34:46 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:96a2:b866:71ad:f87f] (unknown [104.135.204.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Yv2PJ2m7Fz6Cl0jr;
	Thu, 13 Feb 2025 17:34:43 +0000 (UTC)
Message-ID: <51c6b704-7dd0-4d2c-acae-8ba427d57070@acm.org>
Date: Thu, 13 Feb 2025 09:34:38 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: hpsa: Replace deprecated strncpy() with strscpy()
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Don Brace <don.brace@microchip.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-hardening@vger.kernel.org, storagedev@microchip.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250212222214.86110-2-thorsten.blum@linux.dev>
 <34BB4FDE-062D-4C1B-B246-86CB55F631B8@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <34BB4FDE-062D-4C1B-B246-86CB55F631B8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/25 3:24 AM, Thorsten Blum wrote:
> This subtle difference between strncpy() and strscpy() regarding the
> number of bytes copied isn't really documented anywhere, is it? The
> documentation I came across so far seems to focus mostly on the
> different return values of the two functions.

 From the description of commit 9022ed0e7e65 ("strscpy: write destination
buffer only once"):

     So strscpy not only guarantees NUL-termination (unlike strncpy), it 
also
     doesn't do unnecessary padding at the destination.  But at the same 
time
     also avoids byte-at-a-time reads and writes by _allowing_ some 
extra NUL
     writes - within the size, of course - so that the whole copy can be 
done
     with word operations.

     It is also stable in the face of a mutable source string: it explicitly
     does not read the source buffer multiple times (so an implementation
     using "strnlen()+memcpy()" would be wrong), and does not read the 
source
     buffer past the size (like the mis-design that is strlcpy does).

     Finally, the return value is designed to be simple and unambiguous: if
     the string cannot be copied fully, it returns an actual negative error,
     making error handling clearer and simpler (and the caller already knows
     the size of the buffer).  Otherwise it returns the string length of the
     result.

More information is available in the description of commit 30c44659f4a3
("Merge branch 'strscpy' of 
git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile").

Thanks,

Bart.

