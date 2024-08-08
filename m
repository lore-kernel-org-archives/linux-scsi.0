Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FE6190068;
	Thu,  8 Aug 2024 17:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723137003; cv=none; b=hcDf1EkmVm/qTOVjKx5tTKqjZJ8K6oWZMjIRzO7bd4n60eFyGnrjYJiNux0qCiAhjryIlXC2WXgeZC0ilIWk69kge3n2CfAkFaeSyc4OiIGdeq8kU1D4ExiOh2EKQX633U1n6ALoSRr8lTQ59KTxdUfYvUAXviSV7m4wOMgrpfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723137003; c=relaxed/simple;
	bh=iSyqywThG/hxbEk9v3WmWpkkQHFaZvfWwHjM9sdoCWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EBDFqxs/eoPxyFPf1Z/L9e73vfiT1RxqefBhEdz9mFWt/sxxoSWLk3tt/+UFaVVGHzCnM3StRqNYivD0vvdX7cLhsA3ndV81iQijZ/4uqUM6QsKkzEBWvRxr7pHPS+pmW5CEn6rgey+dcDvehVRGvrjac/ZTAKiX/sVM8/tJO70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=y/uyOaeE; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="y/uyOaeE"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wftp20c66zlgT1M;
	Thu,  8 Aug 2024 17:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723137000; x=1725729001; bh=iSyqywThG/hxbEk9v3WmWpkk
	QHFaZvfWwHjM9sdoCWI=; b=y/uyOaeEzAfJV6D/dOmHyBkuK0r/9GAYkvdoSXZH
	I/pYTmUoaSpF76dm5DXUHJ+QVhZRCeXueHbnJ/0uIKXH6zQGKULOgqv/4r9a7t8E
	Oj6oKX72SQbzWo9kzP56b1nI28hdrZ8C2aomuyoeSTxPgDBNkzdvji48liU8G+1G
	Gx3qwBfp67cU5C3we/CtJ9xD1Q2N1YamNECt/5Nwrmm9SKDsn2FfSe81XXYb7uuR
	Ou1CHW6J//XfBpvGlH8JAAac81kHUWZCKQ/5QfJiYzLddym5IKx3PezvmuAXwyh0
	iHTiR6vsFZll6EkhBw0yaxdLM90Uk5xsmBZEXJsKlkea6A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OtVUXuN289Ye; Thu,  8 Aug 2024 17:10:00 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wftnz2kclzlgTGW;
	Thu,  8 Aug 2024 17:09:59 +0000 (UTC)
Message-ID: <1a893b5c-8e34-419d-a4ff-8664c4efb08e@acm.org>
Date: Thu, 8 Aug 2024 10:09:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: ufshcd-pltfrm: Use of_property_present()
To: "Rob Herring (Arm)" <robh@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240808170644.1436991-1-robh@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240808170644.1436991-1-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/8/24 10:06 AM, Rob Herring (Arm) wrote:
> Use of_property_present() to test for property presence rather than
> of_find_property(). This is part of a larger effort to remove callers
> of of_find_property() and similar functions. of_find_property() leaks
> the DT struct property and data pointers which is a problem for
> dynamically allocated nodes which may be freed.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
