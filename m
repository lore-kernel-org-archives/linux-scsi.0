Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28D432C85
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 15:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755011997; cv=none; b=KwKaHN/CGwx9NqUojD6tTXIUILXwNTx9mb9bDe9iqS9gbRZB/ltrEyiYumkRvFcTruJASnDmSB3rbzQEbn29Omp/+jWlN3VRugsO/987YapkrGpHpg1NHb0qX9PWdpjzGJ87/i+DPXwoRs7dfpQn9g8wVVRkRYjthoD1dkYm4AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755011997; c=relaxed/simple;
	bh=tLTj/J4riosgG+3Z0+F91AaYh+j3QBxy53GrI8J7xeg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RSZxMosx8pmb+d2z8tw64mhMA1E3oqk8HX5unZP7EgXUx2rvB4ilIIHUH6DHG+UDYIi6SMo2E1c4hLHfi5bG+C2JDLtvCHcXhy/tmOU33/N4JnaA2wTzjp1x9OgaO5veDTx1xSy/J2CgsOXhXJUuNGNyhxCmgTzDvIbsCAyd0zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nMlGM8U1; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nMlGM8U1"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c1Ztf56q3zm0yQb;
	Tue, 12 Aug 2025 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755011993; x=1757603994; bh=tLTj/J4riosgG+3Z0+F91AaY
	h+j3QBxy53GrI8J7xeg=; b=nMlGM8U1YZfGIqZrLV7AqxZz8k/JpjzRO2dNjrDH
	bkAS5ifz16q+8zKPjK+drFn23kcnDCR1A0snWljUek86Y8kihIIVUXCjJJ82pOoU
	EHKENTAzpfVFAfv92X4iAYy980wZsl9Y4Z+UoO+LfmY2rlHHILuGqh4QeRAl4Mqu
	+jmfQcxh5F8Ba2hQ9HkD0V+jQm307SdF0ks1PgUyN8YZPsqDlKUTDsZbgLZrvnIJ
	Itjwb/hZYrBMRzAkZ7m3LiV6LwNBjAVNfgd9SugycbxGAAQc094mN98cjolc1Vrh
	4GlbpTERfAvH8SUR/F16oag8SMZLnd2tTNt1iJEhCtVv2g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id de7hHMLO7LEX; Tue, 12 Aug 2025 15:19:53 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c1ZtX3YWczm0ysd;
	Tue, 12 Aug 2025 15:19:47 +0000 (UTC)
Message-ID: <478f81a5-7314-484e-9a78-7b471a43535c@acm.org>
Date: Tue, 12 Aug 2025 08:19:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Wildcat Lake
To: Adrian Hunter <adrian.hunter@intel.com>,
 Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@sandisk.com>,
 Archana Patni <archana.patni@intel.com>, linux-scsi@vger.kernel.org
References: <20250812130259.109645-1-adrian.hunter@intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250812130259.109645-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/25 6:02 AM, Adrian Hunter wrote:
> Add PCI ID to support Intel Wildcat Lake, same as MTL.
Please expand acronyms like MTL in future patches since this acronym is
not well known outside your employer. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
