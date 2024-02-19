Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB3A4878A;
	Mon, 19 Feb 2024 18:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708369079; cv=none; b=HlGnKrGG8hQo3gEgVoLS/4Pm376n93lCgMBWkYtOVT55cx9InZzIDmI+M/u7rKUuWmAuFZxjvUbltVbuyz36sJicm9evQpbizaPwgE0Sl/S9jn+74sOIX+IYLozjCZrmC52nc2qJjk2thUqMET8DO3bE0wzjnJhsyfi6isoACkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708369079; c=relaxed/simple;
	bh=WX+/BwKaMoi4eZrIDNE+tT6bRVlFBx1G/86vGVtXqD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t6q0jRk83u0MfQIMuu10jp9MLjmBTIzwmWkyqKE23hO2YBYII9pJtdf6kwFT7qQf0dSxit6+uFsfDW/oOF0ZOm/RpiI/VYNGdZvrlC/rAZU35KA9tVPyPCk5yBVU+S1AhT4+iuidSYUhFSH0KrrOcenogMB9FYUEj9WzXqZOKeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ByWPm0we; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ByWPm0we"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D104AC43399;
	Mon, 19 Feb 2024 18:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708369079;
	bh=WX+/BwKaMoi4eZrIDNE+tT6bRVlFBx1G/86vGVtXqD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ByWPm0weIZLIZDkeu9F7U3wLzNAxvJ0wCc0RX9kGhgdhcJfvd6woVFl/GnXE1TSmM
	 COFe07bO2b5emaS1mCXplG7Nyp/lAlqeDf6IoQ9f8bPe+rUntxpHDqCnExMiY7kJ47
	 KiwTKH06LtDIHzNkYCwqAsiuJvnjz4kdzONe4y5nqyZ40xBUm010Vz30bGq053wPcE
	 +ONYB1Np8G22L8MxHL7VziiI7QiaCYtoXbZ21PR0m6EN4hIiN9NUFXFLyO6dqrPXPJ
	 gBrd6UUtBmYPhuyFFd3uerXJdoDrUxB06wlm4ih5guvURtYgzliLa/DRz5pLQJVpJx
	 RB9hrKDCMCVDg==
Date: Mon, 19 Feb 2024 11:57:55 -0700
From: Keith Busch <kbusch@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com
Subject: Re: [PATCH v4 01/11] block: Pass blk_queue_get_max_sectors() a
 request pointer
Message-ID: <ZdOks-bU2kDY6S6Z@kbusch-mbp>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219130109.341523-2-john.g.garry@oracle.com>

On Mon, Feb 19, 2024 at 01:00:59PM +0000, John Garry wrote:
> Currently blk_queue_get_max_sectors() is passed a enum req_op. In future
> the value returned from blk_queue_get_max_sectors() may depend on certain
> request flags, so pass a request pointer.
> 
> Also use rq->cmd_flags instead of rq->bio->bi_opf when possible.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>
