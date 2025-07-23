Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F14620E717
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 17:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753290874; cv=none; b=VVZsJFDUrVCb8FEzJ6oreDlnh1m6zOaqVSGKAAkdBNm19/ggmHM7JIpZ0Gg8G4Yy2Ulbfkj3G2Q+HEy9Wk0B6FgKawb9uYKhegzdrOqof0VAp+/3VSFdniO0WozPvKXkFffu+0MYcLZutcJAqc5PIUe9Pqg5sGKJsySHlLxzsfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753290874; c=relaxed/simple;
	bh=ornu6AFBb95QUiMj+SWipVIwbpJqDjUHZuL67pZN+Uo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lyo/UBrGt02CFQJSDAXrFcY/hDlckCKFfGsb76qZAkkz2Cg/qmIV/ZNuYNi+h6IzZX3VdjKJQIDm0croDUdXfchEyBXGmQImJvJgpP0sV9ildWG9N2MlO3HRgtDCy/COJjrxeWKnfBIbzLIC1qT59Z1yaxyD2oHSj53Z7EbgJlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nsZenAVg; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nsZenAVg"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bnLN21KZ6zm0yQ1;
	Wed, 23 Jul 2025 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753290864; x=1755882865; bh=wkWr21OdoD21d55YR57QppNi
	oIr0/UQffphDQ+kYKcQ=; b=nsZenAVgcuVlDx1q6MDjSnUZIEIh72upRePhHEwY
	fbXKjgV7K0Lnyk1rpSYGOZtILPMqtMksJJv1E5+c/i4cQKEVNZkEc26IiNp2h+t4
	J3GUYHShTMUoojIKZKjqhKV+zrfnk3GdAb4nhg0iZfZSVNNKFWroYWV0PlIaOfui
	nHQGh2e7o4umm6jJhRycNZUozFjv0pK54j0hvhUuS+3Td7OL6+AfyrUX6rt0xNxq
	aYCpYWidvRBQzak/e29TIehxZtkfzcz7HzvT2yT/gO8FPTIRx5RcijvmJpsf7UuQ
	5HDGDOCB9mAKkYgud1LHIIHe+1X7lA9pfmMU0CP8L729Yg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wB5W5_rqfzRh; Wed, 23 Jul 2025 17:14:24 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bnLMw4wYWzm0gc6;
	Wed, 23 Jul 2025 17:14:18 +0000 (UTC)
Message-ID: <808eb25e-9d59-4348-b1b7-7630435410f7@acm.org>
Date: Wed, 23 Jul 2025 10:14:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/8] scsi: ufs: ufs-pci: Fix hibernate state transition
 for Intel MTL-like host controllers
To: Adrian Hunter <adrian.hunter@intel.com>,
 Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@sandisk.com>,
 Archana Patni <archana.patni@intel.com>, linux-scsi@vger.kernel.org
References: <20250723165856.145750-1-adrian.hunter@intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250723165856.145750-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/25 9:58 AM, Adrian Hunter wrote:
> Here is V2 of a couple of fixes for Intel MTL-like UFS host controllers,
> related to link Hibernation state.
> 
> Following the fixes are some improvements for the enabling and disabling
> of UIC Completion interrupts.
Nice work!

For the entire series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
