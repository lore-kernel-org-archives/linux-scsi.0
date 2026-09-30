Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650F130C157
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 08:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790756002; cv=none; b=iSXyXa3zVBoOTdiMZojId13m+l6SbQKKqZFZ+SW6zCUPMd5hckYNQAaA2jz7RMkdgZWdXMYJOLd+80BwQe98YThe4SrO8CdrIJhb1Ch4vXB+6NZm+JSUVi/e65mjC3ux8g3RomVS3teWfpbLjLhY9vXO0a7/l1+tJqyUbC/coH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790756002; c=relaxed/simple;
	bh=iISpfZ0DK0IwqTaKUCoEr7vVe/XQG7ZDn9IvTUwAc5c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tMmf0kB34dh6saO71pxH3MBGVMRSzmmGRkDuS1JpP40vi1cWNz6/nWuHnRKPwuAdg5agu3VKKcDdBKbbZeXqGzBBEV6o79ZxgD1AXyW7UK3IMVPEUrKUd04Vvl69xQb5PFPd32gjvsjD+6YTy2V56gNN7O4HmNAllhcpJoYhviw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgTBGhz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgTBGhz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E311F00893;
	Wed, 30 Sep 2026 08:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790756001;
	bh=L6tu4ei+AHWm40ViVHGKFS9byoL7B2BZkJXyOGB6H8w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SgTBGhz98Bokxvu6fs9WVuA5adjRseLxg3X/nQJ+wS1gqaSBDphHUK885JFz1vDt+
	 kkoGeZEcAoRoqjvARehdS4DeViFAKQE6MqCzwPRsNfDU59Tu9MWpCsJih9EmnC6ewi
	 5dAuB0nU+NuU3iu0J6cKlxfzZdngSGytjz75NzuicmtXaez5f4O4uP9RPf7nSbns20
	 iTRBmINKDMB0OHTAAl66+7Fw7EQKq9cttMCpEKRXOKb+rNwIioLyqLz7w8vUoVIx9x
	 I2qUQXEHuBEbVwaQ8DI8AkmRbX9F9djf7guRFMTWie/2/LIkZZZSxPzrtFnmH/9xNu
	 rMc0GleaQNgRg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ibmvfc: synchronize event timer completion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260930075801.2949514-1-runyu.xiao@seu.edu.cn>
References: <20260930075801.2949514-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 08:13:20 +0000
Message-Id: <20260930081320.D6E311F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: deferred MAD event completion executes without host_=
lock
- [High] scsi: ibmvfc: lockless list_del in ibmvfc_free_event_pool() races =
with workqueue
--

commit e0e195e126820c8780df5dcd52eddd1ee13268d3
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: ibmvfc: synchronize event timer completion

This commit replaces timer_delete() with timer_delete_sync_try() during
event completion to avoid races with active timer callbacks. If a timer
callback is executing, it defers the completion to a workqueue and flushes
the work before freeing the event pool.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 3534ac45e9b87..71d9f9886ae55 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -811,6 +811,28 @@ static int ibmvfc_send_crq_init_complete(struct ibmv=
fc_host *vhost)
>  	return ibmvfc_send_crq(vhost, 0xC002000000000000LL, 0);
>  }
> =20
> +static void ibmvfc_complete_event_work(struct work_struct *work)
> +{
> +	struct ibmvfc_event *evt =3D container_of(work, struct ibmvfc_event,
> +						timer_work);
> +
> +	timer_delete_sync(&evt->timer);
> +	evt->done(evt);

[Severity: High]
If the completion is deferred to this workqueue, does it execute the callba=
ck
without acquiring the host_lock?

When ibmvfc_send_event() fails, it overrides evt->done to the raw callback
(evt->_done) to avoid deadlocking inline. If that completion is then deferr=
ed
to this workqueue via ibmvfc_complete_event(), it appears it will run in
process context without the lock. Since MAD event handlers typically require
host_lock to safely modify host state machine fields, could this cause data
races or state corruption?

> +}
> +
> +static void ibmvfc_complete_event(struct ibmvfc_event *evt)
> +{
> +	/* The response path can run in hardirq context, so defer only when the
> +	 * timer callback is already executing on another context.
> +	 */
> +	if (timer_delete_sync_try(&evt->timer) < 0) {
> +		schedule_work(&evt->timer_work);
> +		return;
> +	}
> +
> +	evt->done(evt);
> +}

[ ... ]

> @@ -886,6 +909,7 @@ static void ibmvfc_free_event_pool(struct ibmvfc_host=
 *vhost,
> =20
>  	ENTER;
>  	for (i =3D 0; i < pool->size; ++i) {
> +		flush_work(&pool->events[i].timer_work);
>  		list_del(&pool->events[i].queue_list);

[Severity: High]
Does this lockless list_del() race with work items for other events?

This loop flushes one specific event's work and then immediately removes it
from the list locklessly. However, work items for other events in the pool
might still be completing concurrently on other CPUs.

When those concurrent work items call into ibmvfc_free_event(), they will
acquire queue->l_lock and call list_add_tail() on the queue->free list.
Since list_del() is modifying the same list without taking queue->l_lock,
could this corrupt the list pointers and lead to a crash?

>  		BUG_ON(atomic_read(&pool->events[i].free) !=3D 1);
>  		if (pool->events[i].ext_list)

[ ... ]

> @@ -1851,7 +1875,7 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
>  			evt->done =3D evt->_done;
>  		}
> =20
> -		evt->done(evt);
> +		ibmvfc_complete_event(evt);

[Severity: High]
If ibmvfc_complete_event() here falls back to schedule_work(), the event
completion is abandoned to the workqueue. As mentioned above, the deferred
evt->done() call will execute without the host_lock that the caller of
ibmvfc_send_event() currently holds. Is it safe for the MAD completion path
to run asynchronously without that lock?

>  	} else {
>  		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
>  		ibmvfc_trc_start(evt);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930075801.2949=
514-1-runyu.xiao@seu.edu.cn?part=3D1
