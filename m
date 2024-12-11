Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0371EC4DC
	for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2024 21:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733954252; cv=none; b=cuB0t6NZrqmKQHBkasWQ2qQhLQaUkj2p8+Y6gs0lYNXJ7nKNQrkC5kbjj9pFm/jQq1UI2FmVVvHZ/dD8st3WMEEnU7bLrxoyy5GRFN7nDZfeCqkZWbKD7VN2tY5qP1yiXjwFZIjFpEAqvRjQbPB9S0IIPINYoiiAHyFgOVw53Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733954252; c=relaxed/simple;
	bh=gp2t8IDFmAFlgIA6Q5ErKq9qyb9fG/Wvlf7k/2NqbIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jsfivzoB7Q9wZO5iLFdEo16C46knbL6xGkaXXRIFxF/dFkjElacleqpNtAbNz0dHE8jltNNbIoessJpmpWxnnNfMwrNomUCrQ+uDEZT7T9nmjTn5PiOF9Xx2Wce2ZHkuUpPwk2lu6ohnReFJ+kWLMZWivHin3zBpkemAP7TTl3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K5R+ywvT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K5R+ywvT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733954249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u/y8/bIm+5STkH4REMC6R6vdk2Ayx1I83IJ7A7He2Ng=;
	b=K5R+ywvTMl/yidDhRFand7t4QE7z97YBDxdQCmOgYRmfzFUDFoi1GbY/x0nG4W9HSoI/W5
	wrvK+JVVdgh4oyLcOErE9h2BWF1s6L4bOTgwLSJ0ryC9tJUL3+IBROjsYSwvPSdmYbGJ05
	6gat797lshk0Mm+Ti6JrR3LYrB1yRf4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-176-eyjwCroAOPWwuMl3fXtYeA-1; Wed,
 11 Dec 2024 16:57:28 -0500
X-MC-Unique: eyjwCroAOPWwuMl3fXtYeA-1
X-Mimecast-MFC-AGG-ID: eyjwCroAOPWwuMl3fXtYeA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C497919560B6;
	Wed, 11 Dec 2024 21:57:26 +0000 (UTC)
Received: from [10.22.64.187] (unknown [10.22.64.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D651E3000199;
	Wed, 11 Dec 2024 21:57:25 +0000 (UTC)
Message-ID: <363296a4-6235-4447-8e45-ec32a49c0fe6@redhat.com>
Date: Wed, 11 Dec 2024 16:57:25 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] scsi: st: Add sysfs file reset_blocked
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
 loberman@redhat.com
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <20241125140301.3912-5-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20241125140301.3912-5-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

On 11/25/24 09:03, Kai Mäkisara wrote:
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
> +reading and writing to the device is blocked after device reset. Most
> +devices rewind the tape after reset and the writes/read don't access the
> +tape position the user expects.
> +
>   A link named 'tape' is made from the SCSI device directory to the class
>   directory corresponding to the mode 0 auto-rewind device (e.g., st0).
>   
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index ad86dfbc8919..0e6a87f1f47f 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -4697,6 +4697,24 @@ options_show(struct device *dev, struct device_attribute *attr, char *buf)
>   }
>   static DEVICE_ATTR_RO(options);
>   
> +/**
> + * reset_blocked_show - Value 1 indicates that reads, writes, etc. are blocked
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
> +}
> +static DEVICE_ATTR_RO(reset_blocked);
> +
>   /* Support for tape stats */
>   
>   /**
> @@ -4881,6 +4899,7 @@ static struct attribute *st_dev_attrs[] = {
>   	&dev_attr_default_density.attr,
>   	&dev_attr_default_compression.attr,
>   	&dev_attr_options.attr,
> +	&dev_attr_reset_blocked.attr,
>   	NULL,
>   };
>   

