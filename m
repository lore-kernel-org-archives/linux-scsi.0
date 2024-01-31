Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71773EA91;
	Wed, 31 Jan 2024 06:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706682181; cv=none; b=RGw92PIhePbeTdiBHoZ5IR5xbDzIeaL9OR8SQKifrSTYF0c+8Ga+pLFOc8YdwNGjhDmw2qNYXBZkdXHGJ8iwJIASttCsysXiYQ5dDBVmr1bQJGHmLHJeuFAEj2WwIoYodmq28GhTlCZf6jDPZ7kuehjzRz8WumZ3770IA2FEGKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706682181; c=relaxed/simple;
	bh=h3V8CMWu57oujPgztHe5LOLy1vpX6IdlvJODoVlgdFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D0/ZPR/hvASLk5IIkSzPTr7KhHUifOn1E9WGxN+e4lfJjfVTqLi0gWY1SeS5L3/3RZuAEDn6hxgVg2suPwJsqTJoxtyceNxlEd8HahfEARHZ2CA7ajeHAe/RBTtY7YpwqK5DGAetJimTprBQLjIjkwWUU22UBBXCIoydHTPbA+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DA86168B05; Wed, 31 Jan 2024 07:22:54 +0100 (CET)
Date: Wed, 31 Jan 2024 07:22:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Ed Tsai <ed.tsai@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Message-ID: <20240131062254.GA16102@lst.de>
References: <0d23e3d3-1d7a-f76b-307b-7d74b3f91e05@huaweicloud.com> <f1cac818-8fc8-4f24-b445-d10aa99c04ba@acm.org> <e0305a2c-20c1-7e0f-d25d-003d7a72355f@huaweicloud.com> <aedc82bc-ef10-4bc6-b76c-bf239f48450f@acm.org> <20240118073151.GA21386@lst.de> <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org> <20240123091316.GA32130@lst.de> <ac240189-d889-448b-b5f7-7d5a13d4316d@acm.org> <20240124090843.GA28180@lst.de> <38676388-4c32-414c-a468-5f82a2e9dda4@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38676388-4c32-414c-a468-5f82a2e9dda4@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 29, 2024 at 04:03:11PM -0800, Bart Van Assche wrote:
> Would you agree with disabling fair sharing entirely?

As far as I can tell fair sharing exists to for two reasons:

 1) to guarantee each queue can actually make progress for e.g.
    memory reclaim
 2) to not unfairly give queues and advantage over others

What are you arguments that we do not need this?
