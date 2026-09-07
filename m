Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F596400995;
	Mon,  7 Sep 2026 20:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811541; cv=none; b=DhkbQS8X5psVi8iIsmj4vdupurwUD7BpyQYSkIB1WHu7GS5vGx0YlPO75H3D/QLsZeymsNfUQbjbTGPI900H8S+HfTVAU8s7gLLlyq5mB6GFtYaQk3WZPaT+09g+Khfjct6g9OU53klFta/jyVZYK6F4pbuoievKJsQ4fX8UYIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811541; c=relaxed/simple;
	bh=mLKUboyc9e2jyWb9PC14dfhWaLk71AbZ/bA7OGPRiXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P3bSiNnj4sbufOBvCJYns2lKdy2+VlihY0FVIBrWwwVXEIyoLAzZPUg9znz3O+u1OLHyZxl3WMFJl+QYj2TpSfCVTbUulehBeLsppUXZ1rn8qk4REG9VLcCzvS2uU0ykMBvFrMXo57PtC57UVvIvGWt6n0CizxV5Gb+PN+amM/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kVp2ymHU; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kVp2ymHU"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hdyjv4wd6zlfvq1;
	Mon,  7 Sep 2026 20:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788811535; x=1791403536; bh=EyZOUCLDvNizyeyBTGbm6/FY
	ft/0ndTu7rfbbnOfx8o=; b=kVp2ymHUQXtm5oxzyMVF+uvwymX+NDkwr2f738HO
	y0HF5YSVp38yBHK22qQ2cgsupo9rQsJIWJYm4MkBUqCI60fxcPUFPhWMG8qlZyqp
	4Bhhiwd24HPnmOlQ2Wskj+5UwCI/gdzqqbe0cBZ5vsqE9dPaLcRyDpspM0oCvaeW
	INY9UTnPCTL8INmVQkyQ0hYJFVHhJ8CZBac/NgiLHlQT+Z0+RjWDncvZ/iq7aKTP
	gekZ6cU/49397+kUnBk1+pXIRoTFqy6rimyA3WXUk49RafAP5glycpQ9nNrUGil+
	mrTylhvGgUQqC9xojPviXcapdLBJ5ef/Yrf0CFagMwEEAA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xDLycQuDva6a; Mon,  7 Sep 2026 20:05:35 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hdyjk3g2czlfvpK;
	Mon,  7 Sep 2026 20:05:30 +0000 (UTC)
Message-ID: <1a2dbe7c-d220-48e8-adf8-f0fe5afca556@acm.org>
Date: Mon, 7 Sep 2026 13:05:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/40] scsi: use struct scsi_sense_hdr to log sense
 keys and codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-7-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260907024343.1046387-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/6/26 7:43 PM, Damien Le Moal wrote:
> -void usb_stor_show_sense(const struct us_data *us,
> -			 unsigned char key,
> -			 unsigned char asc,
> -			 unsigned char ascq)
> +void usb_stor_show_sense(const struct us_data *us, struct scsi_sense_hdr *sshdr)

The sshdr argument can be declared const, isn't it?

Thanks,

Bart.
