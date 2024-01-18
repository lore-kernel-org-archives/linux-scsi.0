Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB53AD32;
	Thu, 18 Jan 2024 07:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705563119; cv=none; b=L0jWQUUUiJKCHfRkmZkRJzMk4upDuFWnCeGfWCyoS/sIrL+5mCHsh9QxkApor3MsQLm+mvyQEsfAYrJVCtfTEtJ8iTLH1FwaUw4GREwY1x7hDlcQ53bPfUK484Umgi/voC0hv3SeaEjeIVoMp++Kj2zci0C4APla4pyP9Y+TjOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705563119; c=relaxed/simple;
	bh=QfcOeteJgZO5Tpxxt5F5FT7pIA+Q0wr+VNG1OJp5XF4=;
	h=Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 User-Agent; b=a+ntAG9WF8JPQ9KDZjHMT5+vS7PfWhXs73RRSjFT0sRFWyZSqozu8Hmq/jFYuZWK+83qtfChp7oMdeiX616lwbQQbqqCnGQI7THMaiTGSD+gKY66r9TWOFEthd/qLcGhxoTq+UK7ZJpZI11reXjWW32kydOBgoLY89493XXJYdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 004FB68C7B; Thu, 18 Jan 2024 08:31:51 +0100 (CET)
Date: Thu, 18 Jan 2024 08:31:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20240118073151.GA21386@lst.de>
References: <c1658336-f48e-5688-f0c2-f325fd5696c3@huaweicloud.com> <1d3866af-ffca-4f97-914d-8084aca901ab@acm.org> <69b17db7-e9c9-df09-1022-ff7a9e5e04dd@huaweicloud.com> <20240112043915.GA5664@lst.de> <2d83fcb3-06e6-4a7c-9bd7-b8018208b72f@huaweicloud.com> <20240115055940.GA745@lst.de> <0d23e3d3-1d7a-f76b-307b-7d74b3f91e05@huaweicloud.com> <f1cac818-8fc8-4f24-b445-d10aa99c04ba@acm.org> <e0305a2c-20c1-7e0f-d25d-003d7a72355f@huaweicloud.com> <aedc82bc-ef10-4bc6-b76c-bf239f48450f@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aedc82bc-ef10-4bc6-b76c-bf239f48450f@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 16, 2024 at 09:36:27AM -0800, Bart Van Assche wrote:
>  My concern is that the complexity of the algorithm introduced by that patch
> series is significant. I prefer code that is easy to understand. This is why
> I haven't started yet with a detailed review. If anyone else wants to review
> that patch series that's fine with me.

Given that simply disabling fair sharing isn't going to fly we'll need
something more complex than that.

The question is how much complexity do we need, and for that it would
be good to collect the use cases first.

