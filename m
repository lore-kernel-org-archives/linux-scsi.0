Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDD738DD3
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 18:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738261666; cv=none; b=NThoix97JvqL/10Zx5FT6X1hNKngsQlTAts0HWj9yswnuPfbhi/+Iex4R3wjtXyWLn2IL7ost6wWFKz9kXwhtnt1Jk7lRjMcYTbA3PCC6Z6v3A9wflOZ9AnFwu/EQlHixJjbQM1Cu95sSC9k6E21c9pmPjhnzu8lO+j3a42ofvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738261666; c=relaxed/simple;
	bh=e7JfnMAJMFwaRjZIb0/hO+AjNykqFMmIChHbJ1RGPjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dlSCDAwX/+VWA8n/f3LjAndkSU72rV//ZROwLBFRBMqpUUOSVs6VbknB5LOBEZNXqXj+hHodDLOBlzztCnywQBfEFw6M39kqCWIsBFnYOkVEOZPlDU4YeYsMryVtn2zZoTv0J3yTG06qI1LaZknVsIom6kkANgj3rQqxSov1iho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TuAI5LGg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TuAI5LGg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738261664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QIyql5XVbRZUeA2Ba1G/rDnO78ooNlYdB8vvcmjxGLg=;
	b=TuAI5LGgERbaR4xg6dS6zm3mL337dIzuCe6Y3YSnPRGxPEckUR8SQ4Rbel06YFQj7EAqEv
	A6IRbKL2NLo9qn8Wj8BosQYJoD7eaMaTCJUOA+M6d2QyKaLkBXPR/LrKbFrR28SjSXLgas
	0H0Sy+3rHlmjRu2Ey9pr8m/rdKPdzD0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-160-LTp8D7RXOWKoYC0Z9Bx61g-1; Thu,
 30 Jan 2025 13:27:40 -0500
X-MC-Unique: LTp8D7RXOWKoYC0Z9Bx61g-1
X-Mimecast-MFC-AGG-ID: LTp8D7RXOWKoYC0Z9Bx61g
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9146F1956050;
	Thu, 30 Jan 2025 18:27:39 +0000 (UTC)
Received: from [10.17.16.215] (unknown [10.17.16.215])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C40E18008F0;
	Thu, 30 Jan 2025 18:27:38 +0000 (UTC)
Message-ID: <84a38d69-7ee7-4faa-82c6-38db2408f823@redhat.com>
Date: Thu, 30 Jan 2025 13:27:37 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] scsi: st: Add sysfs file reset_blocked
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, loberman@redhat.com
References: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
 <20250120194925.44432-5-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250120194925.44432-5-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

One suggestion here.

On 1/20/25 2:49 PM, Kai Mäkisara wrote:
> If the value read from the file is 1, reads and writes from/to the
> device are blocked because the tape position may not match user's
> expectation (tape rewound after device reset).
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   Documentation/scsi/st.rst |  5 +++++
>   drivers/scsi/st.c         | 19 +++++++++++++++++++
>   2 files changed, 24 insertions(+)
> 
> diff --git a/Documentation/scsi/st.rst b/Documentation/scsi/st.rst
> index d3b28c28d74c..2209f03faad3 100644
> --- a/Documentation/scsi/st.rst
> +++ b/Documentation/scsi/st.rst
> @@ -157,6 +157,11 @@ enabled driver and mode options. The value in the file is a bit mask where the
>   bit definitions are the same as those used with MTSETDRVBUFFER in setting the
>   options.
>   
> +Each directory contains the entry 'reset_blocked'. If this value is one,

I suggest calling this 'position_lost' or 'position_unknown' rather than 'reset_blocked'.

> +reading and writing to the device is blocked after device reset. Most
> +devices rewind the tape after reset and the writes/read don't access the
> +tape position the user expects.
> +
>   A link named 'tape' is made from the SCSI device directory to the class
>   directory corresponding to the mode 0 auto-rewind device (e.g., st0).
>   
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 6ec1cfeb92ff..e4fda0954004 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -4703,6 +4703,24 @@ options_show(struct device *dev, struct device_attribute *attr, char *buf)
>   }
>   static DEVICE_ATTR_RO(options);
>   
> +/**
> + * reset_blocked_show - Value 1 indicates that reads, writes, etc. are blocked

       position_lost_show

> + * because a device reset has occurred and no operation positioning the tape
> + * has been issued.
> + * @dev: struct device
> + * @attr: attribute structure
> + * @buf: buffer to return formatted data in
> + */
> +static ssize_t reset_blocked_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct st_modedef *STm = dev_get_drvdata(dev);
> +	struct scsi_tape *STp = STm->tape;
> +
> +	return sprintf(buf, "%d", STp->pos_unknown);
                                    ^^^^^^^^^^^^^^

I'd like the name of this function/sysfs variable to more closely match the code
that drives this state.

> +}
> +static DEVICE_ATTR_RO(reset_blocked);
> +
>   /* Support for tape stats */
>   
>   /**
> @@ -4887,6 +4905,7 @@ static struct attribute *st_dev_attrs[] = {
>   	&dev_attr_default_density.attr,
>   	&dev_attr_default_compression.attr,
>   	&dev_attr_options.attr,
> +	&dev_attr_reset_blocked.attr,
>   	NULL,
>   };
>   

Otherwise, I've tested this out and everything works as expected!

https://github.com/johnmeneghini/tape_tests/commit/9e04599605f4726050f9f2032b84df2daa6cd6ea

Thanks!


