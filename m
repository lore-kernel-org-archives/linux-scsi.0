Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477DD125D2;
	Tue, 23 Jan 2024 09:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706001203; cv=none; b=VyELcQ4XODZFI6f7n09+ELfScC2OJHY0aGXbsrNvWq3mSrSZSxgisU9LDg444ZRvX+1+SZ2carM2w9mIh/cCRXLKsFrc5S5gZEwgI3OdGLLWYQaQ6ZJ4qaBri4VeCqkMsJVtuJyQkpGdue3PogQALcJS/BdCNGRQYna+njmdkec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706001203; c=relaxed/simple;
	bh=3JPqtuzdQSdLuH7kcK024Kf93V9nlSHru3MqljUsO9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=npBJelrTumaoEm7XoxUdkUvwF6SSEU87eKDWQGTExw/fkvedeKXeQfeV7YO2wLxrpw/tNvN87Jp6pQxmsQt08ux6oQNr9eFjtMX4ixYeRwQAlASlsCImOSe5rmf9eac1JKuzr4kwnrlRbHVoGSZ4HLYn8/uzyC1ajS5aXDREtlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B635B68BEB; Tue, 23 Jan 2024 10:13:16 +0100 (CET)
Date: Tue, 23 Jan 2024 10:13:16 +0100
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
Message-ID: <20240123091316.GA32130@lst.de>
References: <69b17db7-e9c9-df09-1022-ff7a9e5e04dd@huaweicloud.com> <20240112043915.GA5664@lst.de> <2d83fcb3-06e6-4a7c-9bd7-b8018208b72f@huaweicloud.com> <20240115055940.GA745@lst.de> <0d23e3d3-1d7a-f76b-307b-7d74b3f91e05@huaweicloud.com> <f1cac818-8fc8-4f24-b445-d10aa99c04ba@acm.org> <e0305a2c-20c1-7e0f-d25d-003d7a72355f@huaweicloud.com> <aedc82bc-ef10-4bc6-b76c-bf239f48450f@acm.org> <20240118073151.GA21386@lst.de> <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 18, 2024 at 10:40:26AM -0800, Bart Van Assche wrote:
> So far two use cases have been identified: setups with an UFSHCI 3.0
> host controller and ATA controllers for which all storage devices have
> similar latency characteristics. Both storage controllers have a queue
> depth limit of 32 commands.
>
> It seems to me that disabling fair sharing will always result in better
> performance than any algorithm that realizes fair sharing (including the
> current algorithm).

Fair sharing by definition is always faster than not doing fair
sharing, that is not the point.

The point is why you think fair sharing is not actually required for
these particular setups only.
