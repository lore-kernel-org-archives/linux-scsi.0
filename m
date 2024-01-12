Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E41F59175
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2024 12:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I6xyOd+P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705063388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9hYD9vvEMLBXQ94CTL17ZKqQeZbZQQ3i/iQS9n0ydlQ=;
	b=I6xyOd+PrI4d0nKyhsUZfsDT2KcqeSLqIqUbTz8L6813e/02MAQJadgXydbmupd64eM46Q
	GGBQIm8XeyvWFtkpnVPTsFwmHjaQlIGSX5YFSYjpKQDa8KVJxXbIkJTKheLca6GOEhBsf3
	3eg57y5Kzz+sPUT4dVPOAWiXj5yqsr8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-650-1_HfE9JePfCvHVcnuZpWnA-1; Fri,
 12 Jan 2024 07:43:07 -0500
X-MC-Unique: 1_HfE9JePfCvHVcnuZpWnA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BBBF3C13A86;
	Fri, 12 Jan 2024 12:43:06 +0000 (UTC)
Received: from fedora (unknown [10.72.116.130])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF80D2026D66;
	Fri, 12 Jan 2024 12:43:03 +0000 (UTC)
Date: Fri, 12 Jan 2024 20:42:59 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>,
	ming.lei@redhat.com
Subject: Re: [PATCH] scsi: core: move scsi_host_busy() out of host lock for
 waking up EH handler
Message-ID: <ZaEz066MVkijH68c@fedora>
References: <20240112070000.4161982-1-ming.lei@redhat.com>
 <ccbc1e9b-ca63-415c-9b83-225d4108021a@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccbc1e9b-ca63-415c-9b83-225d4108021a@suse.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Fri, Jan 12, 2024 at 12:12:57PM +0100, Hannes Reinecke wrote:
> On 1/12/24 08:00, Ming Lei wrote:
> > Inside scsi_eh_wakeup(), scsi_host_busy() is called & checked with host lock
> > every time for deciding if error handler kthread needs to be waken up.
> > 
> > This way can be too heavy in case of recovery, such as:
> > 
> > - N hardware queues
> > - queue depth is M for each hardware queue
> > - each scsi_host_busy() iterates over (N * M) tag/requests
> > 
> > If recovery is triggered in case that all requests are in-flight, each
> > scsi_eh_wakeup() is strictly serialized, when scsi_eh_wakeup() is called
> > for the last in-flight request, scsi_host_busy() has been run for (N * M - 1)
> > times, and request has been iterated for (N*M - 1) * (N * M) times.
> > 
> > If both N and M are big enough, hard lockup can be triggered on acquiring
> > host lock, and it is observed on mpi3mr(128 hw queues, queue depth 8169).
> > 
> > Fix the issue by calling scsi_host_busy() outside host lock, and we
> > don't need host lock for getting busy count because host lock never
> > covers that.
> > 
> Can you share details for the hard lockup?
> I do agree that scsi_host_busy() is an expensive operation, so it
> might not be ideal to call it under a spin lock.
> But I wonder where the lockup comes in here.
> Care to explain?

Recovery happens when there is N * M inflight requests, then scsi_dec_host_busy()
can be called for each inflight request/scmnd from irq context.

host lock serializes every scsi_eh_wakeup().

Given each hardware queue has its own irq handler, so there could be one
request, scsi_dec_host_busy() is called and the host lock is spinned until
it is released from scsi_dec_host_busy() for all requests from all other
hardware queues.

The spin time can be long enough to trigger the hard lockup if N and M
is big enough, and the total wait time can be:

	(N - 1) * M * time_taken_in_scsi_host_busy().

Meantime the same story happens on scsi_eh_inc_host_failed() which is
called from softirq context, so host lock spin can be much more worse.

It is observed on mpi3mr with 128(N) hw queues and 8169(M) queue depth.

> 
> And if it leads to a lockup, aren't other instances calling scsi_host_busy()
> under a spinlock affected, as well?

It is only possible when it is called in per-command situation.


Thanks,
Ming

