Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7941AAA10;
	Tue,  7 Jan 2025 08:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240312; cv=none; b=ssKXSbLLJLiUSTljy/6I2L4sCYB7uQ2GN+t4ZTwlg6n8iDp05z72UPAWtAB6F63EnQGND1Dnh3ZwJmGQiL63ziAMI5BDK6puN6FTRWS5Dfb+ds6Q2SFKXOWeTcF0SJv/HHKpFdf3dGHvFX0rObwhoUAkP3gScv5Jmk+VlIymqvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240312; c=relaxed/simple;
	bh=gt/A1iLRjslVd4gUt+W4KGMOsCFp7ACpHPTCuOI3QIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IRQ5bthBRGJR60+5UdJnhLO4wMB8Utit3QqvTQrxxVmtbQvZ0v2bEC0NITT0ADlIdLvsYIQlRRR0Hxec74mzt/RFK+soSOyx7h1AZ6IPjk33toXVTGtyLmAsz82wOJ0R9Iz3+d7vIT93XP/PrHuKrDBeZw2xp9I7L/WljEpU+q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E40C968AFE; Tue,  7 Jan 2025 09:58:25 +0100 (CET)
Date: Tue, 7 Jan 2025 09:58:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	nbd@other.debian.org, linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 6/8] nvme: fix queue freeze vs limits lock order
Message-ID: <20250107085825.GA16827@lst.de>
References: <20250107063120.1011593-1-hch@lst.de> <20250107063120.1011593-7-hch@lst.de> <96c48ba0-3db5-4504-a456-e57440aa1b56@linux.ibm.com> <20250107082224.GB15960@lst.de> <263963d9-ac40-4f87-b38a-edb4202d294c@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <263963d9-ac40-4f87-b38a-edb4202d294c@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 07, 2025 at 02:15:05PM +0530, Nilay Shroff wrote:
> The nvme_set_ctrl_limits() sets certain queue limits which are 
> also used during IO processing. For instance, ->max_segment_size
> is used while submitting bio.

nvme_set_ctrl_limits only sets them in the on-stack queue_limits
structure, which is local to the calling thread.

