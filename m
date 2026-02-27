Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8BB37C10B
	for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2026 18:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772217978; cv=none; b=oPThl5rjs0sB1TYKEotrXa56WSNgxSsLjN5P96TwU+9ta5319Zdp7yVTTpwPkeAIB/A2GYQG414JWSlJfZKwJ3affWE8qrHXRgzgXwJ5NQ0EGFwkOAbZ9MAuyMrITV5tv0427haWrlDz54voc117UOtWcKs0bnqGl+KIUs0pSVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772217978; c=relaxed/simple;
	bh=xG/EKrnNSqeAjN6LsyzXT6i6trWkRG65suYYR1rVkQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XsYNTcms4cZG1FNB/yL6XhUnuZ5mr4YtsZVULN9Hzam/8XaF30HuOb+odYwGu08au+iQz+1RDDAemeohX/WiM8Hbf5MEHSb1g4zW3yd3qifNjBqi/BVZT5rlDWPDgcC5dnzme9X2fx87h10kQ5k70t6VNwYruyE+4kA7BTK9MY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VQPZLxqx; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VQPZLxqx"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fMy2x0V1zz1XM0pC;
	Fri, 27 Feb 2026 18:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772217974; x=1774809975; bh=485DDFtfK8PCNUwqxR8bUrOJ
	LXwzZGKTp/yOuc6aYJ4=; b=VQPZLxqxM6tWSHwTuDtjSjOyJHtjhLZDsQcRd3Qq
	Wpuy/t4K67xpz8NGm/afRn6dw1mOB+1LXlAfF3lFyz9wS95RokkhnNm9PfklSe8x
	iDVOJla2j6+s4TlTJF3wvwH7tQn7hsnHG5mJquxtt4NWhPmMIR37R8MYhyEqqpC5
	SsKwBwZyUSBrykDy+IhYxBKz1XeZx9vH1lESTnKHKmUpyIt+Nw+FgdgbKuUUDkTy
	F3li+Pt2uW8ofx3jJYsaL9P8x1/+ln7vTUEEbKLTyrLqkgokhFt6RENCa0YfHzl3
	zwTfDqw4JBL9wrQfJhlG4wUDIllif/qfkfCddPB2LFemfQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SkfpnX8P0WAV; Fri, 27 Feb 2026 18:46:14 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fMy2s6NfMz1XM0p9;
	Fri, 27 Feb 2026 18:46:13 +0000 (UTC)
Message-ID: <ecd223ba-aebb-4930-bd21-76a7d44f5789@acm.org>
Date: Fri, 27 Feb 2026 10:46:13 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix refcount leaking for "tagset_refcnt"
To: Junxiao Bi <junxiao.bi@oracle.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20260223232728.93350-1-junxiao.bi@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260223232728.93350-1-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/26 3:27 PM, Junxiao Bi wrote:
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 7acbfcfc2172..c64ef71633d8 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -361,6 +361,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   	 * since we use this queue depth most of times.
>   	 */
>   	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
> +		kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
>   		put_device(&starget->dev);
>   		kfree(sdev);
>   		goto out;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

