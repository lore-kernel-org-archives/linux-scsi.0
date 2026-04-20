Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C56E34F48E;
	Mon, 20 Apr 2026 16:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776703327; cv=none; b=NOiSqF+pdSdjSo5EpzEU61cikDISMpC05Z8oxgTDEckZt3gyogEyxuWoyUg5xUK3o/0cf8GE9E17V7G8Eewhh0qpkLVw239BBx3e1c/mc7WIGVghXuWxJ+NjEJbgWn2WZSYVfi3JHRPVdDAJkMyRFmnqvDsNnOU0IDWSwRf0vi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776703327; c=relaxed/simple;
	bh=S0lHVaMDo8pMI0w3QXKGkb3d5HoepyAqfzQmfWGkQNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EMioCCwgTRu0iiWiJ1fyhkkkujZDMurEkhW3dT3Og6TTZvkQVT/siTuLqi6eT2P/yD9VrzG19Z4nfV0akp7Puzwz3t1smajmeLfDW81tyTDbVhSfGHDoBWGg33UfAFs1FJ+ZKxt+uWudUU3WXrx8gzbZlZfdC2c1R1ciyK4g1+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ULQyjxK/; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ULQyjxK/"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fzrqW2gnbzlfgQJ;
	Mon, 20 Apr 2026 16:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776703316; x=1779295317; bh=jXWXT0C2vYd7DNR5fZmHpXp9
	dz3yLaLQFoAtO+8J5iQ=; b=ULQyjxK/HZDs1UtcVpniJOCYMRQyVCh19kPMreNm
	y6kn1Z1+UdDdaN1Jdk1GDuD1AmCghgSYvrbb0f1ybQ3MDa1vH9ihsxhKeXcpUNkF
	siVy8gZjsNIrq7Ch6dGBmWGO4BkMyduaWQjxY/jNqdLr/06P2kPT9f0f4WFIWaua
	H4/wNckXgEJtzhMTs5yindG+62UqhfrxF2gtTyAjNkGjCZT7k8NcwHg7BoD/s0+9
	UtRuus/VEzZDZvwCuvjxB2LtnvPn2NlYN2FM5eDeSTsRTdhMvAxXBSEjme3iHN8s
	0SZvb19cPBR7W5U2vA1W0vlrtv1GDEdDkqf/nayy/TBgAQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id veVyxmjrEC0c; Mon, 20 Apr 2026 16:41:56 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fzrqQ4PwPzlfc9J;
	Mon, 20 Apr 2026 16:41:54 +0000 (UTC)
Message-ID: <c6a6733e-a652-40a5-8ff3-bc69e3e80102@acm.org>
Date: Mon, 20 Apr 2026 09:41:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] scsi: use percpu counters for iorequest_cnt and
 iodone_cnt
To: Sumit Saxena <sumit.saxena@broadcom.com>, martin.petersen@oracle.com,
 axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 mpi3mr-linuxdrv.pdl@broadcom.com
References: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
 <20260420113846.1401374-4-sumit.saxena@broadcom.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260420113846.1401374-4-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 4:38 AM, Sumit Saxena wrote:
> +#define show_sdev_iostat_percpu(field)					\
> +static ssize_t								\
> +show_iostat_##field(struct device *dev, struct device_attribute *attr,	\
> +		    char *buf)						\
> +{									\
> +	struct scsi_device *sdev = to_scsi_device(dev);			\
> +	unsigned long long count = percpu_counter_sum(&sdev->field);	\

Why "unsigned long long" instead of "u64"? u64 values can be formatted
with "%llx" since "u64" is a synonym for "unsigned long long".

> +	return snprintf(buf, 20, "0x%llx\n", count);			\
> +}									\
> +static DEVICE_ATTR(field, 0444, show_iostat_##field, NULL)

Why "snprintf(buf, 20, ...)"? New code should use sysfs_emit(buf, ...),
isn't it?

Otherwise this patch looks good to me.

Thanks,

Bart.
