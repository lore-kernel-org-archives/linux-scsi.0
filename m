Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E571E0E08
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jan 2025 19:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738179007; cv=none; b=L+Nt7XKnUPvM95eqScRpeuj8eaOgVjiqML8Dg3LtmUazmoPChfyuU9qhSXtbzJtjPQNLVJu1ZHDCZ45u9My4DfEpygwn8rb3uHyLgFbyuOg3oPTzT4j6xRs6dKIEKndKgl/BB3mK8ABZ1LdHXCJ8V9Esh7ODjq8Wcqljk4/bhv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738179007; c=relaxed/simple;
	bh=JW0KDorVD+p1DI2EAPiVjSm8WRI15m8ZyYrt81hXKzE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TsMaOzkTNZH9N9clZTsuH8q03Iw3REqruzJhXz89dIAD3z1lk9GW4oAiCQeq6/zI88zqNQRzptwVisBYI+ZNKUBh2G02xjxuYbT+MtH1j6Mmm4GxXYrguFIRJZiFLc6anPH+JqOIyxp+wBm44/DE9+mzDAJy5gWi46Y8qWFrND8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fUgM33Ef; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fUgM33Ef"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738179004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eJZLPsKcpyeO0atCc3fV6D6lVGa1tiHEEf0KSjOMaTY=;
	b=fUgM33EfBqwPflW6D6pTKJWtKoWDxji1FrmdaBoxhl+GkPufD+NzVw6xcbdJtC8fwHWz1p
	3xxM4FwALG5j50+myhAbah3/dxxCHbvTkI31ri7geRmr12II1Bkco+oUh0mxTOMEpplZ2a
	M6qxoACR+oB40gvYLeVZT3H+gY8V2LU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-yvfftzEyM2esPZuic8tvbA-1; Wed,
 29 Jan 2025 14:30:01 -0500
X-MC-Unique: yvfftzEyM2esPZuic8tvbA-1
X-Mimecast-MFC-AGG-ID: yvfftzEyM2esPZuic8tvbA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 560161955DC6;
	Wed, 29 Jan 2025 19:29:59 +0000 (UTC)
Received: from [10.22.66.117] (unknown [10.22.66.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 321AD30001BE;
	Wed, 29 Jan 2025 19:29:56 +0000 (UTC)
Message-ID: <62142991-5dda-4f51-94c5-23db95b27037@redhat.com>
Date: Wed, 29 Jan 2025 14:29:56 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] aacraid: Fix reply queue mapping to CPUs based on IRQ
 affinity
To: Sagar Biradar <sagar.biradar@microchip.com>, jejb@linux.vnet.ibm.com,
 linux-scsi@vger.kernel.org
Cc: Tomas Henzl <thenzl@redhat.com>, Marco Patalano <mpatalan@redhat.com>,
 Scott Benesh <Scott.Benesh@microchip.com>,
 Don Brace <Don.Brace@microchip.com>, Tom White <Tom.White@microchip.com>,
 Abhinav Kuchibhotla <Abhinav.Kuchibhotla@microchip.com>
References: <20250127213223.318751-1-sagar.biradar@microchip.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250127213223.318751-1-sagar.biradar@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 1/27/25 4:32 PM, Sagar Biradar wrote:
> Fixes: "(c5becf57dd56 Revert "scsi: aacraid: Reply queue mapping to CPUs
> based on IRQ affinity)"
> Original patch: "(9dc704dcc09e scsi: aacraid: Reply queue mapping to
> CPUs based on IRQ affinity)"

Please add a functional description for the aac_map_queues function here.  All other
functions in this file include a description.  E.g.: look at aac_slave_configure.

/**
  *      aac_slave_configure             -       compute queue depths
  *      @sdev:  SCSI device we are considering
  *
  *      Selects queue depths for each target device based on the host adapter's
  *      total capacity and the queue depth supported by the target device.
  *      A queue depth of one automatically disables tagged queueing.
  */

> +static void aac_map_queues(struct Scsi_Host */**     
> +{
> +	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
> +
> +	blk_mq_map_hw_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> +				&aac->pdev->dev, 0);
> +	aac->use_map_queue = true;
> +}

