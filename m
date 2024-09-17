Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A90127442;
	Tue, 17 Sep 2024 14:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726583473; cv=none; b=b98pS3hYJxOLhCNcLLPR/yS94kR+HrYR7FGwFeBXOiJMxfEBkNjjtNEaL+TVw7Lpoz2cASAsVLhg2SZgQkFvTQv6/6GCSrnJopF305sWr8D3jAPU4LpD2Jpk2lHCcN4dpUTYHD6V5fmPtU7lm/5pzgIBqYSN9hw2FgghaVKPJcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726583473; c=relaxed/simple;
	bh=tZ1JP6WdaVWKoYUOCwimdcbYefkzCR7mi76LK6oUkT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gK2HXqkIpnAPCPzlX8tsxmCRvpcHTRFjVr2XYvk0Emuv66MNnhZnLOXBms/rJysK+LteTAO/ax4ZX4NmAE3mAvw9g9M7+KU08L9ovL6R9cFlRi5kj6xqKY9wy48Ktx4iUfCaHk0nnw3VzQRT1hyphTJCduNYvFWYpclnxKgBHTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=n5vrTM4W; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="n5vrTM4W"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X7PN84tGMzlgMVQ;
	Tue, 17 Sep 2024 14:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726583463; x=1729175464; bh=tZ1JP6WdaVWKoYUOCwimdcbY
	efkzCR7mi76LK6oUkT8=; b=n5vrTM4Wz7EMxUjMNBN8QG5DNryqKzsDOgIEQ1UO
	BCmlTX2/Q77B5J7KO4vFYtct/tOUgdKiAqVPmbxkuDhCOZl2c8TOJQQND8S3j3GO
	/PSKNsFXH5olpJoGrLLWXiEq7rRUH3BV6cK2afATnzX1ocHrNow0nfTOFo/VTQ1r
	R/bkv6wSVfGe1c8NpI2OBxDv5O7rIBjs7vcSdcZkNodq8jTORDrQMjwIay6YYreF
	JBS7D1uj0FyNMDQh9o43xwPUYdc0SsHyBG1/q2rSaS8IbLWeq0WErPLTJuURwueB
	cOOxCfbTO2Lx6iMMNDjvmdGQgSC8uxhbVJuXzR7O/u4NSw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bZhC94ojf_z5; Tue, 17 Sep 2024 14:31:03 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X7PN61cVBzlgMVP;
	Tue, 17 Sep 2024 14:31:01 +0000 (UTC)
Message-ID: <b7a05da9-7a80-42f7-bf95-379d78f3296b@acm.org>
Date: Tue, 17 Sep 2024 07:30:59 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240915074842.4111336-1-avri.altman@wdc.com>
 <83fed524-a235-493c-81f6-16736027eeb1@acm.org>
 <DM6PR04MB657549C63703AECEA2169CC4FC612@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657549C63703AECEA2169CC4FC612@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/24 11:52 PM, Avri Altman wrote:
> Is the below proposal evidently better? e.g. with respect of
> efficiency, simplicity, readability etc.?

The approach I proposed has two advantages:
* All code that initializes *lrbp->ucd_req_ptr occurs in the same
function. I think that is a significant advantage with regard to
maintainability.
* ucd_req_ptr->header is initialized once instead of twice. Hence
the approach I proposed is more efficient.

Thanks,

Bart.

