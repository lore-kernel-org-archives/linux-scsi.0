Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1C663AA;
	Thu, 28 Dec 2023 08:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mOMgG2Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DFDC433C8;
	Thu, 28 Dec 2023 08:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703753132;
	bh=rg07FllBtKojv/YWJK2MSz8nZ8FE0W1k1xLI73NnDS8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mOMgG2ShTxVcg/nq0Vjpe/hg38Gfp+L1z4JHQkLPxG4GS8W2mj5o1y/dNJJeAF/D1
	 9AvI7t1D196SHeCA1pCLJp3cLK0FrhiCHplLavFBwQgLg9960AjORahAnkd87wLw7C
	 1guAAIsI6KHTtk02tpxlrQI+3dQ+DL1OUtRNi9idBFFjUbBeQf82KfWvas3QhBMdwb
	 YOCsbpO/4sHLBUizs37uV5WO2JlTqJdVz4DElPrr475PkT9FFGCKjlR4h3BYMIHxDC
	 7mCJFe4hf14ydVcPU/Ooybno4xMk8DxAwnKa1nQy3LtqcSze+5fCHXoiUc/c7LUOm+
	 CfkjnyB2L6haA==
Message-ID: <6933c048-f77b-4645-a667-adae0f89b347@kernel.org>
Date: Thu, 28 Dec 2023 17:45:29 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: remove another host aware model leftover
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org
References: <20231228075141.362560-1-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231228075141.362560-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/28/23 16:51, Christoph Hellwig wrote:
> Hi all,
> 
> now that support for the host aware zoned model is gone in the
> for-6.8/block branch, there is no way the sd driver can find a device
> where is has to clear the zoned flag, and we can thus remove the code
> for it, including a block layer helper.

Hmmm... There is one case: if the user uses a passthrough command to issue a
FORMAT WITH PRESET command to reformat the disk from SMR to CMR or from CMR to
SMR. The next revalidate will see a different device type in this case, and
SMR-to-CMR reformat will need clearing the zoned stuff.

> 
> Diffstat:
>  block/blk-zoned.c      |   21 ---------------------
>  drivers/scsi/sd.c      |    7 +++----
>  include/linux/blkdev.h |    1 -
>  3 files changed, 3 insertions(+), 26 deletions(-)
> 

-- 
Damien Le Moal
Western Digital Research

