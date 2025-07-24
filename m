Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ADE2EB5AA
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753378202; cv=none; b=t8zTgVVI3JqUVCMxnE5rN5FzfMZn/dU9FyhlhGNa37gSaOreBcPDe3Xgu1VKT61Y7mX5NQuwAGA84cJZ+HjE8Btgp9KE6owqFv2ydPItg/JA50NiLcy04GcJLSrXTH6043mV/btU50ayaYLu4xWbpqXNWnyIME0HyEBK3V6+Zq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753378202; c=relaxed/simple;
	bh=sH9LxECNBQOh4kwp4TPJOVvFUjsivO3uUOg2nTrqO/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GWSO1IXEBstxepQb2GmEaMLtd7lO0teFTj5uDLUQy9kZL7Z7p8Rn8NR7x15KPTzuF4qqlcBI44VaX49puuDuT/kIzc12kHPvwZUTv2QPtfNNUY0K3FEEGhpIjLs6A/wVLVxHQ0+jQPYEeO1wjzTKUtr3z04LY0imPjyeeCl6b9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cYTdHw1e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cYTdHw1e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753378198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uW2BHJdp9dqv5cRVcuzbFR8mAZIwlu4AlfBTG+zyhZo=;
	b=cYTdHw1eUbG+lKmZx93ULJkUtApfG7MCNWCqwqcOIN4Z2IRMldMzMU+pX9vEItNbtOr35g
	ZRqmHt1y2yKpwIpHPVBfyqWybDlRlH+JDPSu6kBHwm4G86ay9oEQ0Dwr2ATOH+byz8YMnH
	8yzy87fsh0NIaVxjeC3xF9ZZ6OyOA+o=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-mF4X7KdpOYuXH4JSL5WFpw-1; Thu,
 24 Jul 2025 13:29:57 -0400
X-MC-Unique: mF4X7KdpOYuXH4JSL5WFpw-1
X-Mimecast-MFC-AGG-ID: mF4X7KdpOYuXH4JSL5WFpw_1753378196
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16A3E180045C;
	Thu, 24 Jul 2025 17:29:56 +0000 (UTC)
Received: from [10.22.80.106] (unknown [10.22.80.106])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 487E218001D8;
	Thu, 24 Jul 2025 17:29:54 +0000 (UTC)
Message-ID: <f05f1a64-74f4-4f81-9df3-b1283c5ab39d@redhat.com>
Date: Thu, 24 Jul 2025 13:29:53 -0400
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
Cc: linux-scsi@vger.kernel.org, hare@suse.com, ming.lei@redhat.com,
 Marco Patalano <mpatalan@redhat.com>
References: <20250715111535.499853-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250715111535.499853-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Closes: https://lore.kernel.org/linux-scsi/20250618192427.3845724-1-jmeneghi@redhat.com/
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

Martin, please merge this patch.  This fixes the aacraid driver issue we discussed at LSF/MM.

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

