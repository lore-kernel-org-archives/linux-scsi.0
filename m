Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315474EB29;
	Thu, 28 Mar 2024 06:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711606963; cv=none; b=eW2r79BAdC///zR2Z2GjA5ClVv3LyJK0Ar0/6jyYM5qTkNSZOebQV2+ayBPsSRqgxiE8Kuih9a8a1V8ZR+dmWzb4e98GuNvMmOwBWTXnuLVoH2Q3Euixc++gdnMSgATEU764ygUKyrYqVHHTGMv2QFBfKyhv/8FG8+7N7FONrg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711606963; c=relaxed/simple;
	bh=nt1XQ6RoKxwF5HJIKCEzo3AC8J5u8MBJ48gc/wMS3xY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqSdKM3YzJPFOb4hSZgtZ6yiBD89byOOXwtMxBw+V2wJzbRHWk8IBVAtAzTNi6zWO9Pqbkq50U18C2kCyHFZlsc975bCu5H2sw3sVvZEEn19rHOU0IiktPE2L59MhrFLhslWreugXieEDV+2i+55KlA6oJzZtwjTAdRlrNT4m9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 120BF68B05; Thu, 28 Mar 2024 07:22:38 +0100 (CET)
Date: Thu, 28 Mar 2024 07:22:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
Message-ID: <20240328062237.GA17225@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-10-dlemoal@kernel.org> <20240328043016.GA13701@lst.de> <714d0cbc-be4d-4aa9-b200-73c6caaa1d18@kernel.org> <20240328054652.GA16237@lst.de> <7d8f3ec4-c416-445f-92db-7d2b60726821@kernel.org> <20240328060357.GA16819@lst.de> <ca3fe7b0-7e27-4ac9-b669-5263c3cec550@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca3fe7b0-7e27-4ac9-b669-5263c3cec550@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 03:18:46PM +0900, Damien Le Moal wrote:
> > Yes, bt it can use kfree_rcu which doesn't need the rcu_head in the
> > zwplug.
> 
> Unfortunately, it does. kfree_rcu() is a 2 argument macro: address and rcu head
> to use... The only thing we could drop from the plug struct is the gendisk pointer.

It used to have a one argument version.  Oh, that recently got renamed
to kfree_rcu_mightsleep.  Which seems like a somewhat odd name, but
it's still there and what i meant.

