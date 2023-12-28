Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DEC101C1;
	Thu, 28 Dec 2023 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C1B6B68AFE; Thu, 28 Dec 2023 18:14:45 +0100 (CET)
Date: Thu, 28 Dec 2023 18:14:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: remove another host aware model leftover
Message-ID: <20231228171445.GA25852@lst.de>
References: <20231228075141.362560-1-hch@lst.de> <6933c048-f77b-4645-a667-adae0f89b347@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6933c048-f77b-4645-a667-adae0f89b347@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 28, 2023 at 05:45:29PM +0900, Damien Le Moal wrote:
> On 12/28/23 16:51, Christoph Hellwig wrote:
> > Hi all,
> > 
> > now that support for the host aware zoned model is gone in the
> > for-6.8/block branch, there is no way the sd driver can find a device
> > where is has to clear the zoned flag, and we can thus remove the code
> > for it, including a block layer helper.
> 
> Hmmm... There is one case: if the user uses a passthrough command to issue a
> FORMAT WITH PRESET command to reformat the disk from SMR to CMR or from CMR to
> SMR. The next revalidate will see a different device type in this case, and
> SMR-to-CMR reformat will need clearing the zoned stuff.

scsi_device.type is only set in scsi_add_lun and thus can't change without
a re-probe of the upper level driver.
