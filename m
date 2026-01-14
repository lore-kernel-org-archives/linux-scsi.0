Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0D02F0C7D;
	Wed, 14 Jan 2026 20:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768423222; cv=none; b=l4NVugQ90VU01ZfpBezl1/CTJcCo0b/O/uPUtwuvHD5jQYFWPzAaf6TdGFVHamM9MNqItmrlgriKRE5ubj0zIGtNTdAgYvoIAg8TYnqKrkjkEWl9F1AyiiyhO3ntfdy9fAsVFyzw1L/KlFe6kufrYf+nOnqpgsupFK0tlqhWvig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768423222; c=relaxed/simple;
	bh=rYj1G0ZgOrlKgp7cvcUaf3N+xnMfL7FlvmwFqIWNaxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZIzrQRiVO6k16Xc+uuybeO3nLed8PPQZsHIyGV6oVvBNuwd2XYzX+MDZVjH/Aq55iU9FnUYg9wQiTDt75LOubEzJaH10A+C/aGlMxa0Fe8hWz5cocAdX6mQGL34d98A9Og3923hjdnlpt7NI4HPBSrr4/oJ8o+dZbNrh6DjY0JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DczfYK4a; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DczfYK4a"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dryfr4Hj7z1XLwWq;
	Wed, 14 Jan 2026 20:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768423219; x=1771015220; bh=tXLYtMu8kl/sqi/QeVbUV/yQ
	7fOxlre6p6clJYbg/hg=; b=DczfYK4a7GWTwXB7gUHDpkfeJE671HIqhItypJJ1
	71gOJDgCPGiw8lenTruuo7UxipaWyK+drLQMUHWx2u9E/7JZMJKVe0AA0uwtJBYx
	aUmMyk4jjqfdkh+13z7cU2IzsQR8ksWiCLDjcMFXQmcSh9Oll2bSbPDLt0Qy83PK
	4jkG+TYUkiQ95ayeCETJPwPFpKAXOfHdNoTzCrqvnPY6Tsq2X7wm0dJXKGVnS/Mc
	e3FRBQu/PmHju/y0KbyQx9A777UN3l5Bd4ZlIoGtsTZBQd9h0nGyx7YsdJovC7Ar
	HlQct5bosJWPJSyAmmurSPaztagQpCFL0fbOJ1ySLxSCag==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Bis82rDIzv3S; Wed, 14 Jan 2026 20:40:19 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dryfn5NKQz1XM6Jk;
	Wed, 14 Jan 2026 20:40:17 +0000 (UTC)
Message-ID: <ce30b2fe-8225-47fb-b581-251a1b9cd2cf@acm.org>
Date: Wed, 14 Jan 2026 12:40:16 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
To: Igor Pylypiv <ipylypiv@google.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260114175115.384741-1-ipylypiv@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260114175115.384741-1-ipylypiv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/26 10:51 AM, Igor Pylypiv wrote:
> Add a 'serial' sysfs attribute for SCSI and SATA devices. This attribute
> exposes the Unit Serial Number, which is derived from the Device
> Identification Vital Product Data (VPD) page 0x80.
> 
> Whitespace is stripped from the retrieved serial number to handle
> the different alignment (right-aligned for SCSI, potentially
> left-aligned for SATA). As noted in SAT-5 10.5.3, "Although SPC-5 defines
> the PRODUCT SERIAL NUMBER field as right-aligned, ACS-5 does not require
> its SERIAL NUMBER field to be right-aligned. Therefore, right-alignment
> of the PRODUCT SERIAL NUMBER field for the translation is not assured."
> 
> This attribute is used by tools such as lsblk to display the serial
> number of block devices.

How can existing user space tools use a sysfs attribute that has not yet
been implemented? Please explain.

> +int scsi_vpd_lun_serial(struct scsi_device *sdev, char *sn, size_t sn_size)
> +{
> +	int len;
> +	const unsigned char *d;
> +	const struct scsi_vpd *vpd_pg80;

The current convention for declarations in Linux kernel code is to order
these from longest to shortest. In other words, the opposite order of
the above order.

> +	rcu_read_lock();

Please use guard(rcu)() in new code.

> +	vpd_pg80 = rcu_dereference(sdev->vpd_pg80);
> +	if (!vpd_pg80) {
> +		rcu_read_unlock();
> +		return -ENXIO;
> +	}
> +
> +	len = vpd_pg80->len - 4;
> +	d = vpd_pg80->data + 4;
> +
> +	/* Skip leading spaces */
> +	while (len > 0 && isspace(*d)) {
> +		len--;
> +		d++;
> +	}
> +
> +	/* Skip trailing spaces */
> +	while (len > 0 && isspace(d[len - 1]))
> +		len--;
> +
> +	if (sn_size < len + 1) {
> +		rcu_read_unlock();
> +		return -EINVAL;
> +	}

Has it been considered to call strim() instead of implementing 
functionality that is very similar to strim()?

> +	return sysfs_emit(buf, "%s\n", buf);

The C99 standard says that passing the output buffer pointer as an 
argument to sprintf()/snprintf() triggers undefined behavior. I'm not 
sure whether this also applies to the kernel equivalents of these
functions but it's probably better to be careful.

Thanks,

Bart.
