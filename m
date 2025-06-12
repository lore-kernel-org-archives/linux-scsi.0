Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7239A29A327
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 16:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749744824; cv=none; b=lQVWGWLrdpfLnxHMRRs2GLv7BTzos4Afx5GhECBabMQmn7kPpV3dEpm6S+Qr+pw6uJdxomKcusK8upr80BvO5xcn6fTfyHqf6C94p8iz3xCjsdp1wJYlLdH/hsS0zk42ysRwlaUvrb80qUhqYjavyzh3/wklcv+fhioDVvvo8pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749744824; c=relaxed/simple;
	bh=Kvk9kjMYli5HYyMlZjKYstq01OnPTyG0s3L8cV7wxGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Nbt+ClxMfQ+vlF9MjHmoJvBx1WNW8Lf9ZqGQwz+C/z3b4nSC/LxY/yUSFl/Cp19wcuru/1vF69wk7Vur9Co048g3jiXHiFPUDiKMCCvgaJSCV+IgaAoZxKvdylKJjxedFN6B10HdpGQ5xLSjTI1DCk87oaX2AxTFC2NfB9W/sTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gAz2My6i; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gAz2My6i"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bJ6ys2mbmzlgqVT;
	Thu, 12 Jun 2025 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1749744820; x=1752336821; bh=yaXehWKdZRvqkFxEvG+TVhAn
	4ybdTJnXWbgj1AN78pc=; b=gAz2My6iMUXUVS+SHZFWH08G649ClwbCDiVlGcrT
	xSj0jSAL+Jqh6YG2XjIty5obi+Jvpr51PJ6v71UnC6wpjpuyumBeaDRP6jUGy64Q
	qJS0gHSkOb2WVGowvh+YcksikQGArpNOdNZpG6CM3qkf198GnxFHL5GXkpQVGf0b
	DNOh8+FiUEhSfOoViuvHbbrvnJHXnd1Q5wyo6Zfx3f+6ro63UiU767Gv+xHkf0c0
	qCw5TE06ukYKkW7xVGtAFSuyyI6xCpwglnxX5TQjMP/WNC+11oF4eJC9+6HGCCsc
	ZHgoiq5LxfuSc9etXEzYRhK0fU6VPrC8Y0NIp4PW+ZpNLw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HPvuKYPGZJos; Thu, 12 Jun 2025 16:13:40 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bJ6yp5QBtzlgqV1;
	Thu, 12 Jun 2025 16:13:37 +0000 (UTC)
Message-ID: <5cf544f9-202d-4018-8ed1-0733d48bace1@acm.org>
Date: Thu, 12 Jun 2025 09:13:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: Remember if a device is an ATA device
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250611093421.2901633-1-dlemoal@kernel.org>
 <aca75eab-45b4-4afd-8319-e2662fd9d9e8@acm.org>
 <c8cf3ee1-3d65-4241-850c-4539b39f1f5c@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c8cf3ee1-3d65-4241-850c-4539b39f1f5c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 4:14 PM, Damien Le Moal wrote:
> And no, we cannot avoid trying to detect if we are dealing with an ATA/SAT
> device or a real SCSI device in all 3 places where this "if" is done.
> 2 of these used VPD page dereference under rcu lock before, which is rather
> heavy handed. The point of this patch is to simplify that.

Hi Damien,

The code under "if (is_ata)" in scsi_cdl_enable() seems very 
ATA-specific to me. Shouldn't that code be moved under drivers/ata/?

Regarding the following code in scsi_add_lun():

  	if (strncmp(sdev->vendor, "ATA     ", 8) == 0)
		sdev->allow_restart = 1;

Other SCSI LLDs set the 'allow_restart' flag in their sdev_configure
callback. Can this be done for ATA disks too?

Regarding the code that sets the no_write_same flag:

	if (sdev->is_ata)
		sdev->no_write_same = 1;

Why is the RCU reader lock held around that code, a lock that protects
reading from the VPD pages while the above code does not access the
contents of any VPD page?

Other SCSI LLDs set the 'no_write_same' flag in their sdev_configure
callback. Can this be done for ATA disks too?

Thanks,

Bart.
