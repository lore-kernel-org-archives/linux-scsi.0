Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFF439846;
	Wed, 31 Jan 2024 21:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706737045; cv=none; b=lsLaXm/lRN/wmnNlf8+2nzgB3KnM3EwoJIdWe0Tv/eKW1nK34ZC4cMVQTks36LEoytLOtvMUDnf5NEBtGctQogaBg//8G6Cn/WmArUnranAEx7AojLkDBAHpxc9x4ixm+z9zswZ4nDS4t6osz23d1SEysMwF8rgc9YU1FFB0KLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706737045; c=relaxed/simple;
	bh=1dhVEjigGRbmyjiA7AsfU2pm789Qvy4Rs6ur5FQDLzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5I56CKaN1hGDVmzUisWx5nEACV+u2vLLXu9yNEZc+FlhStUCdzQ0/rn1Qf1pqyPRw9Q0e8TWpBc4Z3BJnEnQXfr6bDjVUbI+bVFOjN46UqUEpp9wPVXq4giAyrrA6UXv6dl7BPp7QZQHftjprjBJMpwjJs3VRcspzDIOIMlRzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MS3KZrq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MS3KZrq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A632C433F1;
	Wed, 31 Jan 2024 21:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706737045;
	bh=1dhVEjigGRbmyjiA7AsfU2pm789Qvy4Rs6ur5FQDLzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MS3KZrq4UmxIB2MVPplqlJ528ydc24IuVOuJcTCEbWcTXgozWkTqAXuDM/l4og73w
	 8dWul/60z5gPoFNnjvzGMfe0r2+B8eHPuIjsudsVDk/fTRPh4aidLchwkAx0Re73iX
	 9WjAKamOvoJ6aK8QGfeit3zvO+/ejz6HeLYtbcY8YuaxhBLGm9CMlaQkSTrkZF+Zy7
	 VgUB249trpIbcVFgMqkfGb3XlqW+bIYyZGOFUfBpu3HMZai/xRfM3cMlwxjFqRfqYz
	 JFzCNb7NmPtkNhOffTqZs8wnzSQe+u7lSXEXnw2rQPk/FAjuy/ctFEqKyAbGRQgedJ
	 XWnPUUmEEwMAw==
Date: Wed, 31 Jan 2024 14:37:21 -0700
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
Message-ID: <Zbq9kVEZZBD4m4ZY@kbusch-mbp.dhcp.thefacebook.com>
References: <e0305a2c-20c1-7e0f-d25d-003d7a72355f@huaweicloud.com>
 <aedc82bc-ef10-4bc6-b76c-bf239f48450f@acm.org>
 <20240118073151.GA21386@lst.de>
 <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org>
 <20240123091316.GA32130@lst.de>
 <ac240189-d889-448b-b5f7-7d5a13d4316d@acm.org>
 <20240124090843.GA28180@lst.de>
 <38676388-4c32-414c-a468-5f82a2e9dda4@acm.org>
 <20240131062254.GA16102@lst.de>
 <d7c1f279-464d-4ecd-8e65-87d2ced984dc@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7c1f279-464d-4ecd-8e65-87d2ced984dc@acm.org>

On Wed, Jan 31, 2024 at 01:32:40PM -0800, Bart Van Assche wrote:
> On 1/30/24 22:22, Christoph Hellwig wrote:
> > On Mon, Jan 29, 2024 at 04:03:11PM -0800, Bart Van Assche wrote:
> > > Would you agree with disabling fair sharing entirely?
> > 
> > As far as I can tell fair sharing exists to for two reasons:
> > 
> >   1) to guarantee each queue can actually make progress for e.g.
> >      memory reclaim
> >   2) to not unfairly give queues and advantage over others
> > 
> > What are you arguments that we do not need this?
> 
> Regarding (1), isn't forward progress guaranteed by the sbitmap
> implementation? The algorithm in __sbitmap_queue_wake_up() does not guarantee
> perfect fairness but I think it is good enough to guarantee forward progress
> of code that is waiting for a block layer tag.

What if all the tags are used by one queue and all the tags are
performing long running operations? Sure, sbitmap might wake up the
longest waiter, but that could be hours.
