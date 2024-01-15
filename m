Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33132566;
	Mon, 15 Jan 2024 05:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4C01A68AFE; Mon, 15 Jan 2024 06:59:41 +0100 (CET)
Date: Mon, 15 Jan 2024 06:59:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>,
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
Message-ID: <20240115055940.GA745@lst.de>
References: <20231130193139.880955-1-bvanassche@acm.org> <20231130193139.880955-2-bvanassche@acm.org> <58f50403-fcc9-ec11-f52b-f11ced3d2652@huaweicloud.com> <8372f2d0-b695-4af4-90e6-e35b86e3b844@acm.org> <c1658336-f48e-5688-f0c2-f325fd5696c3@huaweicloud.com> <1d3866af-ffca-4f97-914d-8084aca901ab@acm.org> <69b17db7-e9c9-df09-1022-ff7a9e5e04dd@huaweicloud.com> <20240112043915.GA5664@lst.de> <2d83fcb3-06e6-4a7c-9bd7-b8018208b72f@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d83fcb3-06e6-4a7c-9bd7-b8018208b72f@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jan 14, 2024 at 11:22:01AM +0800, Yu Kuai wrote:
> As you might noticed, Bart and I both met the performance problem in
> production due to fair tag sharing in the environment that total driver
> tags is not sufficient. Disable fair tag sharing is a straight way to
> fix the problem, of course this is not the ideal solution, but make tag
> sharing configurable and let drivers make the decision if they want to
> disable it really solve the dilemma, and won't have any influence
> outside the driver.

How can the driver make any sensible decision here?  This really looks
like a horrible band aid.  You'll need to figure out a way to make
the fair sharing less costly or adaptic.  That might involve making it
a little less fair, which is probably ok as long a the original goals
are met.

