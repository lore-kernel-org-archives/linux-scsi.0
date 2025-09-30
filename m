Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FB44D8CE
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 09:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759224941; cv=none; b=ij/ltlLGcvncSY2qA/gcqlAHFFUsHn688twujtRDShKdrg78dVdcrzJCMeNhnfW1sJKPLv+NjT2t0r2bQ8sA3XXwVG7NPfpizHbDUp0XPTxmQgaiM1V0zEPESuy/Dw/ZdI9SP45zh9MPn+tjnak9IFZHuR3kLcwMQepaHXwSHBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759224941; c=relaxed/simple;
	bh=Q54L1DT+U6piO4VUsc2gAeBqoOQf4NZa9vXmSCNG8VQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uNCUJGJE+aPNKUjs4Lh5u84XWaKlNaN2LkMEoRI1t61ykszdFi82jiL49SIFagYSdJCbP1h67CnxKY3Vi3JWn6OuXb6f+UTUUcBj9bSzV/QWHTCk659gB35LSHHZ78XUpxMS4FGueZFuNoqBPXfYPd8Z0lfgYoXnUOD70HYTF7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WVmCQrWI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WVmCQrWI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759224939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AcBv2gmBH1a2eQ2kJO64gswsAwDukKrga9nsThtCRik=;
	b=WVmCQrWIxcWest7lXllW7Vdupxmo2prfmKOwO6ZS92StioW3Q/Na+w/TOzGSbmRFkTWMXd
	2GhajsezGlT55YYCwrx434jIWWECNsLoVIBAw1+nJuBBhDoiLlE+4nP9g3tc9h/rj+R0mo
	83gTXaHTxkebPX84cSyMbQH36dLuw3A=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-cxNHlLSWPOGhd6mPlEG8AA-1; Tue,
 30 Sep 2025 05:35:33 -0400
X-MC-Unique: cxNHlLSWPOGhd6mPlEG8AA-1
X-Mimecast-MFC-AGG-ID: cxNHlLSWPOGhd6mPlEG8AA_1759224931
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD79E19560B3;
	Tue, 30 Sep 2025 09:35:30 +0000 (UTC)
Received: from [10.44.33.194] (unknown [10.44.33.194])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 875301800452;
	Tue, 30 Sep 2025 09:35:24 +0000 (UTC)
Message-ID: <70657b10-32a3-4c4f-bb53-e95d88435d58@redhat.com>
Date: Tue, 30 Sep 2025 05:35:22 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: qla2xxx: Fix memcpy() field-spanning write
 issue"
To: martin.petersen@oracle.com
Cc: axboe@kernel.dk, emilne@redhat.com, gustavoars@kernel.org, hare@suse.de,
 hch@lst.de, james.smart@broadcom.com, kbusch@kernel.org, kees@kernel.org,
 linux-hardening@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, njavali@marvell.com, sagi@grimberg.me,
 gustavoars@kernel.org
References: <yq1zfajqpec.fsf@ca-mkp.ca.oracle.com>
 <20250925130729.776904-1-jmeneghi@redhat.com>
 <7b1342ce-0f30-4481-bf3b-ef3c92b9bcf8@embeddedor.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <7b1342ce-0f30-4481-bf3b-ef3c92b9bcf8@embeddedor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Martin,

I don't see this patch in scsi/6.18/scsi-queue yet.

Are we going to revert this ?

/John

On 9/25/25 2:57 PM, Gustavo A. R. Silva wrote:
> 
> 
> On 9/25/25 15:07, John Meneghini wrote:
>> This reverts commit 6f4b10226b6b1e7d1ff3cdb006cf0f6da6eed71e.
>>
>> We've been testing this patch and it turns out there is a significant
>> bug here. This leaks memory and causes a driver hang.
>>
>> Link:
>> https://lore.kernel.org/linux-scsi/yq1zfajqpec.fsf@ca-mkp.ca.oracle.com/
>>
>> Signed-off-by: John Meneghini <jmeneghi@redhat.com>
> 
> Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Thanks!
> -Gustavo
> 

