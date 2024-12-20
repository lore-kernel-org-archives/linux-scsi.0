Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053C41AC444
	for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2024 09:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734685497; cv=none; b=nUQP/9/p2S6jRyKKdK1lSR+VESktRiohc39fZ4tLUAnfL07kWlajyJeqtPEI/SMdMsqg6+KUWf9z70JMY3iMtTDHuzRJfb8aRC4erIYNNvMo/f8VCxbx/7/UAnFh0tTkCzT5FP2KLU7h4SnezEwccommapsgpeuuyM5jb793qEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734685497; c=relaxed/simple;
	bh=23QV/Z0ncYZtoK3/rhdLeNgePmQZYVuuHiMosMT5tyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSTLdQvNdVA7v5zVs8Fjoxmm+lAcC5x6pbxVKAMoEsMW17i7dRvA3tfosiaiwyysE0HZlCp88QodaWWUOSrk6YBRwc2tMG3RwspiPgrp+HI++2frirFmdi1ZHjehpw39jCCkoxSW1ANGueHmZ20Tf7lKhiYthrRxjR2E8n0+2H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CfMQAJdk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CfMQAJdk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734685495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TNCekzdNJZmUuGpzwzOxUn2DY6eci5HZ8lsy1e03Zho=;
	b=CfMQAJdkh4gnCz3RG8ZyH/v9Q1s7jgnAgefn0Dtt4+K7VBFpK4Pv6aGu8w2t7BwHFToFv8
	JxTyg9m3tRz3UZHg4utZP9IigzGnLNIwgFi/tCqGka492QXht53bCSgYmX1uhj1XqI3ZHd
	3Ejh4ArPsha5z4WwUIlmEpcAGz2TF6I=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-9-V_hpjVgqOaWhO_PeQOMseg-1; Fri,
 20 Dec 2024 04:04:50 -0500
X-MC-Unique: V_hpjVgqOaWhO_PeQOMseg-1
X-Mimecast-MFC-AGG-ID: V_hpjVgqOaWhO_PeQOMseg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53E431956048;
	Fri, 20 Dec 2024 09:04:46 +0000 (UTC)
Received: from fedora (unknown [10.72.116.29])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4FDE195608A;
	Fri, 20 Dec 2024 09:04:24 +0000 (UTC)
Date: Fri, 20 Dec 2024 17:04:19 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Don Brace <don.brace@microchip.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Costa Shulyupin <costa.shul@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Waiman Long <llong@redhat.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>,
	Sridhar Balaraman <sbalaraman@parallelwireless.com>,
	"brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	storagedev@microchip.com, virtualization@lists.linux.dev
Subject: Re: [PATCH v4 9/9] blk-mq: issue warning when offlining hctx with
 online isolcpus
Message-ID: <Z2UzE-CGa7YVwx0f@fedora>
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
 <20241217-isolcpus-io-queues-v4-9-5d355fbb1e14@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217-isolcpus-io-queues-v4-9-5d355fbb1e14@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, Dec 17, 2024 at 07:29:43PM +0100, Daniel Wagner wrote:
> When we offlining a hardware context which also serves isolcpus mapped
> to it, any IO issued by the isolcpus will stall as there is nothing
> which handles the interrupts etc.
> 
> This configuration/setup is not supported at this point thus just issue
> a warning.

As I mentioned on patch 8, this io hang is regression on existed
applications which can work just fine with 'isolcpus=managed_irq'.

Do you think the added warning will prevent people from complaining
the regression? :-)


Thanks,
Ming

