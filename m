Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA189245028;
	Wed, 10 Sep 2025 08:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757492549; cv=none; b=PMpbs0VRH9dUgFYFOZ0Wg4S6tfeslBkRUwZJ+/xQ1KEMTrOYHwxhVeAd/LpRy+QiGlFGS11LoUmG10kDQjjvUTKZuZmnyeDwbaaZUh0tfG8gHtEK8un2H+kNKWqK+DYHTWJvLqiuNWk/TEq4OzxP56kPNV5XBmCfx2mebzG7s+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757492549; c=relaxed/simple;
	bh=85UKcsOMfyn0E3yinLzfkoR/jW47TpISZIXdMgdVMIE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fMxR3reGUJhmiyiP2FRD3tzAMZmp2IcqDy+GYc+T39V7Cw5K+vQmFY0254ueBDmhTXV1sB/lADnKdmzVEvd9RdzIuOzoPNJ+tXe+1kCppJ8Zz6mBQdl6s4alPOEel2GjZyGVTFBf9RhvqGHa+xO3MGMXN5ku0Eq7i8jpayc3TrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=4OgNlmQT; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=k1RrGMx8; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="4OgNlmQT";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="k1RrGMx8"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1757492546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WQUAVcjXn7tf95scgh3pOPJD9865+15BngQtRr5ID5E=;
	b=4OgNlmQTqS4AyVDZHcTox0tlSaBwDkJEL/Ts7pkw/dx/M20Ltu0mrLteEBzdn9sJCVLD2y
	dfcDP2k/EfsDTMJe8iTDcOHbq2BngCcR1pbaFFCTimZtO0pqy4HziY964ELyL3VGhPzbuS
	I46WwDbecRUNZqYt1o8HVYCiswSpMka/TqCAedJJlSUhci4k9ImyLi3psTc+Rao3niCHBo
	mDNGZo71G7ZhUHWl7fzzx0tPbWfneJvCy34cNAAEOFdknyQqPsI0i8u+u8+b/E2q+kPo4k
	dVOmJyABT05U8tEgXNXEiJ9BjjvnFlL25g3XQ9eMAo54Isys05Y7C9zjDJj6tA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1757492546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WQUAVcjXn7tf95scgh3pOPJD9865+15BngQtRr5ID5E=;
	b=k1RrGMx8UOcygrkA8B9pm+mc/YjWJfzFVvkuTYWUt4MA239Asn+1jaJhj5EpeHW+3neqBz
	3wzspqNtmL4AzyBg==
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, Keith
 Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Costa Shulyupin <costa.shul@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider
 <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, Ming Lei
 <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mel
 Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Aaron Tomlin
 <atomlin@atomlin.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 storagedev@microchip.com, virtualization@lists.linux.dev,
 GR-QLogic-Storage-Upstream@marvell.com, Daniel Wagner <wagi@kernel.org>
Subject: Re: [PATCH v8 04/12] genirq/affinity: Add cpumask to struct
 irq_affinity
In-Reply-To: <20250905-isolcpus-io-queues-v8-4-885984c5daca@kernel.org>
References: <20250905-isolcpus-io-queues-v8-0-885984c5daca@kernel.org>
 <20250905-isolcpus-io-queues-v8-4-885984c5daca@kernel.org>
Date: Wed, 10 Sep 2025 10:22:25 +0200
Message-ID: <87jz26u37i.ffs@tglx>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Sep 05 2025 at 16:59, Daniel Wagner wrote:
> Pass a cpumask to irq_create_affinity_masks as an additional constraint
> to consider when creating the affinity masks. This allows the caller to
> exclude specific CPUs, e.g., isolated CPUs (see the 'isolcpus' kernel
> command-line parameter).
>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>  include/linux/interrupt.h | 16 ++++++++++------
>  kernel/irq/affinity.c     | 12 ++++++++++--
>  2 files changed, 20 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 51b6484c049345c75816c4a63b4efa813f42f27b..b1a230953514da57e30e601727cd0e94796153d3 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -284,18 +284,22 @@ struct irq_affinity_notify {
>   * @nr_sets:		The number of interrupt sets for which affinity
>   *			spreading is required
>   * @set_size:		Array holding the size of each interrupt set
> + * @mask:		cpumask that constrains which CPUs to consider when
> + *			calculating the number and size of the interrupt sets

You surely couldn't come up with a less descriptive name for this
member, right?

> diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
> index 4013e6ad2b2f1cb91de12bb428b3281105f7d23b..c68156f7847a7920103e39124676d06191304ef6 100644
> --- a/kernel/irq/affinity.c
> +++ b/kernel/irq/affinity.c
> @@ -70,7 +70,13 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
>  	 */
>  	for (i = 0, usedvecs = 0; i < affd->nr_sets; i++) {
>  		unsigned int nr_masks, this_vecs = affd->set_size[i];
> -		struct cpumask *result = group_cpus_evenly(this_vecs, &nr_masks);
> +		struct cpumask *result;
> +
> +		if (affd->mask)
> +			result = group_mask_cpus_evenly(this_vecs, affd->mask,
> +							&nr_masks);

Please get rid of this line break. You have 100 characters.

