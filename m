Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6222C14534B;
	Wed, 31 Jan 2024 23:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706742259; cv=none; b=H7sdWhVNZ4KccHgNwHxL/sDAInx+hSCFQlyu14wqR29G0i1gaAccrE4TXCPPMqpWbDTqEPBMoVc0ZOkNrKRHtVQZE4x89jKzEmA5mCtjkRWJPJEkDdTQxhBDRPOrJH9SqqCGurlx5HaYHM+JmzFo2A2/8XH8IJ6ox0YoYTuKTXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706742259; c=relaxed/simple;
	bh=wZ+PithuZv+pm57Z2O2QGMXv1l27cx2NY6BkVV0v+VA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uPlCR0rHlytf6xXTWcZFD7g04nnTZPMAAFw49rQGL/CMm59vG7+qZt6bWLTD+sa9JaWjUToG5xwV3BowgMLsY7cK46f/sgUW71bpIAIxAskg8XXLEDmUfaBaIj4jhjzfkHEGU27KF4YoCzkprsSKCv03p+uasDRnCPTQ822qTpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aU+hzJcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aU+hzJcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1415CC433F1;
	Wed, 31 Jan 2024 23:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706742258;
	bh=wZ+PithuZv+pm57Z2O2QGMXv1l27cx2NY6BkVV0v+VA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aU+hzJcJEyjEPnXIyiClp9oiwL0t4isavtiJzfNcg+/Mqk3J7nH3UAhwv0kfGjH45
	 q+kSqI2uZKQNs7N63VAdpYLSGqacWqF5nR0tOmyOdOxqSLoH7qAwLKlkqch4QuH667
	 qeWartRdqXKXIQkh1dMrGWd91dtMHGf0j1hRCIESxwYgyj24OC9CxPz0y3DPTWo2vy
	 mNRHsINN3ZJGxesGywpVL+PRh8xqB+EVHrvrzd9UgiFnXmVSTmYrw3NTrJQMpCMUzd
	 pxRezBMV77VaTbV4mOVyBU7/+mGfR9flW0r5X0kACiRz6kQS/jazrDpYhxrtG7uR2I
	 XXAf/z/FfDAhw==
Date: Wed, 31 Jan 2024 16:04:15 -0700
From: Keith Busch <kbusch@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Ed Tsai <ed.tsai@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Message-ID: <ZbrR7-DcBSS7V9B7@kbusch-mbp.dhcp.thefacebook.com>
References: <20240118073151.GA21386@lst.de>
 <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org>
 <20240123091316.GA32130@lst.de>
 <ac240189-d889-448b-b5f7-7d5a13d4316d@acm.org>
 <20240124090843.GA28180@lst.de>
 <38676388-4c32-414c-a468-5f82a2e9dda4@acm.org>
 <20240131062254.GA16102@lst.de>
 <d7c1f279-464d-4ecd-8e65-87d2ced984dc@acm.org>
 <Zbq9kVEZZBD4m4ZY@kbusch-mbp.dhcp.thefacebook.com>
 <c2469774-8ebb-4faf-af3b-c9426b8591d4@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2469774-8ebb-4faf-af3b-c9426b8591d4@acm.org>

On Wed, Jan 31, 2024 at 01:42:30PM -0800, Bart Van Assche wrote:
> On 1/31/24 13:37, Keith Busch wrote:
> > What if all the tags are used by one queue and all the tags are
> > performing long running operations? Sure, sbitmap might wake up the
> > longest waiter, but that could be hours.
> 
> I have not yet encountered any storage driver that needs hours to
> process a single request. Can you give an example of a storage device
> that is that slow?

I didn't have anything in mind; just that protocols don't require all
commands be fast.

NVMe has wait event commands that might not ever complete.

A copy command requesting multiple terabyes won't be quick for even the
fastest hardware (not "hours", but not fast).

If hardware stops responding, the tags are locked up for as long as it
takes recovery escalation to reclaim them. For nvme, error recovery
could take over a minute by default.

Anyway, even with sbitmap approach, it's possible most of the waiting
threads are for the greedy queue and will be selected ahead of the
others. Relying on sbitmap might eventually get forward progress, but
maybe not fair.
