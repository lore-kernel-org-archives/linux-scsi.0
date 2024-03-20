Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E833623DE;
	Wed, 20 Mar 2024 21:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710970790; cv=none; b=c4PksgIZe0nCUaDrJYSKUNaAQFAHBYhtvvHQ62bNIXrZauzrxoe9W3YYO9JoHR7OvW0kjZEl2Dl0iSk+IWu10HSQSkkh4R/TvoHkKBbWvpdpg5j8XW3YcUNdtTGi2flGxQqBLXj/Lu0aBLMS1W6S8cKFPTFI4e1oAQ9+I82XNbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710970790; c=relaxed/simple;
	bh=0U5vMjocMlLk8Yw73BfhsWOWk1eQADhqyMLavb/YSnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WMu1qG2Ix43qQc9RZaB1LN80tq12yRsi1VAbyeNFQeYcgvWiO+BtrjQfQ8IiYRESK6KhiSe8Lc1VojkFUWJu6vujAzCKeYO8F1LPYYCKNw3bQtrdbmmaHJjxd5tdc8XVivNKli+goHPK/rhGmYqlUYP3YIxgpF8+GQKF4QKC+uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2XEoXnkG; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2XEoXnkG"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V0MSN1Bd8z6Cnk98;
	Wed, 20 Mar 2024 21:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710970786; x=1713562787; bh=ntLADi8IR1swSxvMty94trq0
	yZbd6Lv0xWRvFtJVSeY=; b=2XEoXnkGIlAHLJ17VMcKDeqtSd40UlPFFPMR26P8
	1ZE1UO8+XU1Kl/ZOCp1VBM22CEboy2Cr8qlJYvqlRrKmcvh06KP/QzYnYCYsXchM
	FBN6D0/XBcByj+Iw/hMqX3LhCWSFOG7RAmrhjTGLDZ/PZn51/y0WV8m1pc8RBmS1
	eBWNj0Tqj16QWfGmMkASnCudbp6Gq3U0VPQmhA8qBGBysPFu915NiCWnre02UHAK
	6NUUPcvXfbWDj61IN+L6uSFC/Y1EuujifSe7n4YPZveZy/kZXY/ivvaRsMN08xzL
	QOBNVRDizQmoqH2MlT1vFjcBfvZI8+z7aZfJnFbQnjFhTQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oqONWr5OK4Rz; Wed, 20 Mar 2024 21:39:46 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V0MSK5Bvmz6Cnk97;
	Wed, 20 Mar 2024 21:39:45 +0000 (UTC)
Message-ID: <f5a263c4-f27d-4df0-ba23-4510a357d19b@acm.org>
Date: Wed, 20 Mar 2024 14:39:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: sg: Avoid sg device teardown race
Content-Language: en-US
To: Alexander Wetzel <Alexander@wetzel-home.de>, dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org,
 stable@vger.kernel.org
References: <20240320110809.12901-1-Alexander@wetzel-home.de>
 <20240320213032.18221-1-Alexander@wetzel-home.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240320213032.18221-1-Alexander@wetzel-home.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 14:30, Alexander Wetzel wrote:
> sg_remove_sfp_usercontext() must not use sg_device_destroy() after
> calling scsi_device_put().
> 
> sg_device_destroy() is accessing the parent scsi device request_queue.
> Which will already be set to NULL when the preceding call to
> scsi_device_put() removed the last reference to the parent scsi device.
> 
> The resulting NULL pointer exception will then crash the kernel.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
