Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CE413BC0F;
	Fri, 29 Mar 2024 21:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711748513; cv=none; b=ado2hEO4v/sDi4LzQJ0PMRiyaYxGwR/5xHG/nyPNd34vHZTcZr62ZDYvEoSCJfqsITmdlNSro8/JfZHSpMVNnNPmEZHYNNFq88iRFlYPWXRCYDxFssx/QXLcf9ccKlV1YcztMn1TqfOBvyDGOW7it2VZhDx40RQOkESyyqKNaPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711748513; c=relaxed/simple;
	bh=FRIggP1YvWWV3rj+5WU1Cj2nMoZrQOSbDSPE/2jMC40=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MSMtfBfAF/FDcPCekI0mkL+sKem4lsfDF0A+2V5q4WDhVdpB9X1pshiCsE6z3gZAwtOYnG/csaCul3LSs6NO5rUd/4hgmFaB20XSASNCqr2nvJ83v8r/kCqtzWY86/C8zfq0EBoujW6ZMZUrR84MoYnF65YUxra9BWogt9Uxuj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YlzdRFkB; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YlzdRFkB"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5v4b23hyzlgVnN;
	Fri, 29 Mar 2024 21:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711748509; x=1714340510; bh=FRIggP1YvWWV3rj+5WU1Cj2n
	MoZrQOSbDSPE/2jMC40=; b=YlzdRFkBVs8NBMYil6mQ99PIvJbZUhyhHRthugtO
	CVFRi7fsFaydTEAKHOxZjjzLX7dr2clq4LeYKP+506+tO4cuWe1kRMAFCrDrDjvr
	LDRtwiR1dxK1Z3eA+P0HDX19TgcYc+o+R1E8sjptExIO2hdNYRATqvDyUMwtv5Yz
	f/QduFby1blvpQGsaw8hR97WxoZdbp4KE00gcYPryKNlPwTlcBWX/ePahcYgoGlm
	uC0qxAQhZDm8Unau9qM3Xij9vjM/l9O0JrUygQ/CWvoJkHMh7X/4ngKlM1D4koU4
	djoO4rTVE3M40/XDnHkbvW1ehCI33GA8xmVKeJpBEe32ng==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fZm0OVdQGTpd; Fri, 29 Mar 2024 21:41:49 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5v4V2Ks9zlgTGW;
	Fri, 29 Mar 2024 21:41:45 +0000 (UTC)
Message-ID: <27230b62-b02d-4b4b-862c-e2302446b6ee@acm.org>
Date: Fri, 29 Mar 2024 14:41:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 22/30] block: Simplify blk_revalidate_disk_zones()
 interface
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-23-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-23-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
