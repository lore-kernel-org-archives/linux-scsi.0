Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02BA22A4E5
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 10:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759227347; cv=none; b=bueLOynLNlKucbQH1rqsUKJXma2LTpEolez/INcWJAWXcaxTOUcr0evAYNkV9PjolkoAJNPXF4gib+/cPmu6EqTryHer6QTjCGBE1cFxyG7zpecRRNGzkvRPhxx1nh8S6eoozqzylm7YIak7mzz92VO9E8R+NNYbc41bJeHbPig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759227347; c=relaxed/simple;
	bh=sY6oCpOJZz4P/H49QLE603ZBDcw0yD/qjB3UOZ9QOyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BJ62sSWLl4KUNX2Atlq4IHPkEZExto5Pj9ARRQRoGHFXtpLCxBbGuTOjGBTOHcY6X3w2e7Aw7ZAfnazzcw0aR1xnVc1/kIgAAkAvbYZwtlZ/CmClQmuD/54pDU+L45hOfeZpWeSPDB23/LU9/cHCX35O2YqK75lziKSpFR7kGO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V+3zSEJx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V+3zSEJx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759227344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pfEJXGGOjez9m3as9ie2g530+S/Tkj59HROsinohPWc=;
	b=V+3zSEJxOdrfW+Gksr58+cckgKBqA4QS36WGmnTMBsuQQ2vfx0pfcd0UajQPdGfIfZAMm7
	qhfoh6++mftJ9uVY9mpkJobCZda4R/pHlnG6OeVwIE0Bpr2LKjskdNEaGHwqiPRLfr13n+
	ziDMwOUBjQ91I/gCpRF0cpnn2L4zCTE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-iqqaXjR8P4Sz3R0JMDRhBQ-1; Tue,
 30 Sep 2025 06:15:41 -0400
X-MC-Unique: iqqaXjR8P4Sz3R0JMDRhBQ-1
X-Mimecast-MFC-AGG-ID: iqqaXjR8P4Sz3R0JMDRhBQ_1759227339
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B89A1956089;
	Tue, 30 Sep 2025 10:15:39 +0000 (UTC)
Received: from [10.44.33.194] (unknown [10.44.33.194])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0B1BB19560B4;
	Tue, 30 Sep 2025 10:15:32 +0000 (UTC)
Message-ID: <6f021d24-280e-4b7c-b79f-36434ef99c0b@redhat.com>
Date: Tue, 30 Sep 2025 06:15:31 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 01/11] fc_els: use 'union fc_tlv_desc'
To: Justin Tee <justintee8345@gmail.com>
Cc: hare@suse.de, kbusch@kernel.org, martin.petersen@oracle.com,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 bgurney@redhat.com, axboe@kernel.dk, emilne@redhat.com,
 gustavoars@kernel.org, hch@lst.de, james.smart@broadcom.com,
 Justin Tee <justin.tee@broadcom.com>, kees@kernel.org,
 linux-hardening@vger.kernel.org, njavali@marvell.com, sagi@grimberg.me
References: <20250926000200.837025-1-jmeneghi@redhat.com>
 <20250926000200.837025-2-jmeneghi@redhat.com>
 <CABPRKS_AOnXmG7NAfgsEKLx2Er_WBcR48wCZwxbKLXnv7FPCZQ@mail.gmail.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <CABPRKS_AOnXmG7NAfgsEKLx2Er_WBcR48wCZwxbKLXnv7FPCZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 9/29/25 1:44 PM, Justin Tee wrote:> Hi John,
> 
> Which branch is this patch based on?  include/uapi/scsi/fc/fc_els.h
> does not apply cleanly on 6.18/scsi-queue.

It's in the patch cover letter.  I've re-based V11 onto nvme-6.18.
  
> Presumably, is this patch based on a branch without?
> 44b6169ada7f scsi: fc: Avoid -Wflex-array-member-not-at-end warnings

Yes
  
> Regards,
> Justin
> 

