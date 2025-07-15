Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28EE7464
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 19:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752607133; cv=none; b=F4BgEUwgZIIEmTInTSyVq2+CE4M+KimlDGl2/8iDM84SCYdRfh+2HDrkhfxA3Ng1Flmf02OebmJMSUAku0jUi2fn5oDZXsVbWAmg0kziCcMf6P6udlLaYCqku5KQA7LA7xWjJHXNnyPHE0APMP5JFjsbsK3J+QLldpGbXJtt6C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752607133; c=relaxed/simple;
	bh=ty/jkQU04nQCi8LyYrcIXf583RZTrUah5X7HwHoarIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AbARNq6QcJxh6Y+ry1OT2UN9pgJCknIeutHSq//zlvzS7j+iJycjed4hoZ7IElDlGYMWvokRKCrXzKIrzf9khe1uuH8ayZkV2WOtJ1lOirf8Z9OCpBGs16WOQGH2GkLWjdAH4V2S/W0xGSMPn5mefiOHbFx8SOl0/qrGMAit2p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YDRsJxTx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YDRsJxTx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752607130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ayfAu8XduV3dyFUP9GKHIwc2bzqGIxLNoIfQfcrfzuU=;
	b=YDRsJxTx19rD8iwo+0bfq/WL2qA2eTakc/UPrbN3dmRUdHZpKeoDw67Xiwd+PJN9gJOguD
	7D9YjknCv9Z7dV9khOZSSkvqn/u3Q1sjh9vCgw6MhQkjeEc47B85tE17bLD/1rXzKA6yhM
	+DaMcCbnkxesLoXl1lVP+fBBaKZ/3Y8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-BVxUWYxbOZGKBX1L9n7xmA-1; Tue,
 15 Jul 2025 15:18:47 -0400
X-MC-Unique: BVxUWYxbOZGKBX1L9n7xmA-1
X-Mimecast-MFC-AGG-ID: BVxUWYxbOZGKBX1L9n7xmA_1752607126
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00289180028F;
	Tue, 15 Jul 2025 19:18:46 +0000 (UTC)
Received: from [10.22.88.94] (unknown [10.22.88.94])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BE0D119560A7;
	Tue, 15 Jul 2025 19:18:43 +0000 (UTC)
Message-ID: <beaeca23-a475-405e-b0ea-af42373dd3bd@redhat.com>
Date: Tue, 15 Jul 2025 15:18:42 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: aacraid: Stop using PCI_IRQ_AFFINITY
To: John Garry <john.g.garry@oracle.com>, jejb@linux.vnet.ibm.com,
 martin.petersen@oracle.com, sagar.biradar@microchip.com
Cc: linux-scsi@vger.kernel.org, hare@suse.com, ming.lei@redhat.com
References: <20250715111535.499853-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250715111535.499853-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

OK John. Thanks for the patch.

We will test this out on our test bed here at Red Hat and let you know if this solves the problem.

/John

On 7/15/25 7:15 AM, John Garry wrote:
> When PCI_IRQ_AFFINITY is set for calling pci_alloc_irq_vectors(), it
> means interrupts are spread around the available CPUs. It also means that
> the interrupts become managed, which means that an interrupt is shutdown
> when all the CPUs in the interrupt affinity mask go offline.
> 
> Using managed interrupts in this way means that we should ensure that
> completions should not occur on HW queues where the associated interrupt
> is shutdown. This is typically achieved by ensuring only CPUs which are
> online can generate IO completion traffic to the HW queue which they are
> mapped to (so that they can also serve completion interrupts for that
> HW queue).
> 
> The problem in the driver is that a CPU can generate completions to
> a HW queue whose interrupt may be shutdown, as the CPUs in the HW queue
> interrupt affinity mask may be offline. This can cause IOs to never
> complete and hang the system. The driver maintains its own CPU <-> HW
> queue mapping for submissions, see aac_fib_vector_assign(), but this
> does not reflect the CPU <-> HW queue interrupt affinity mapping.
> 
> Commit 9dc704dcc09e ("scsi: aacraid: Reply queue mapping to CPUs based on
> IRQ affinity") tried to remedy this issue may mapping CPUs properly to
> HW queue interrupts. However this was later reverted in commit c5becf57dd56
> ("Revert "scsi: aacraid: Reply queue mapping to CPUs based on IRQ
> affinity") - it seems that there were other reports of hangs. I guess that
> this was due to some implementation issue in the original commit or
> maybe a HW issue.
> 
> Fix the very original hang by just not using managed interrupts by not
> setting PCI_IRQ_AFFINITY.  In this way, all CPUs will be in each HW
> queue affinity mask, so should not create completion problems if any
> CPUs go offline.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
> build tested only
> 
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
> index 28cf18955a08..726c8531b7d3 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -481,8 +481,7 @@ void aac_define_int_mode(struct aac_dev *dev)
>   	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
>   		min_msix = 2;
>   		i = pci_alloc_irq_vectors(dev->pdev,
> -					  min_msix, msi_count,
> -					  PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
> +					  min_msix, msi_count, PCI_IRQ_MSIX);
>   		if (i > 0) {
>   			dev->msi_enabled = 1;
>   			msi_count = i;

