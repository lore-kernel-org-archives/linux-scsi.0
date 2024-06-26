Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6107E6E611;
	Wed, 26 Jun 2024 18:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719426869; cv=none; b=O0xhuu1TXMqlzwUNY1EqA4gFoJMwn/bldkQNLG5icQ6gp8f4L62O/b0UiWnfjTPnV4CIQvNZNKAIstUcG4nGyvLgNZlGJDdHmkoAbssN31RVuof88AVDcsv+g5U+db+B6HmVY3LMqZGfmtrgJMexmWOUycCngk/dkY/8yK5LrAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719426869; c=relaxed/simple;
	bh=3yRDMMKMNncuYzsdnB9q9Wa3ZtQxVjiUH3bfWc2ch6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRgvjKq+4ATKLubc7sIUisI/fPFvwYRgvfRPBWcxXMKq5KPP3ryYjodnnOwcF1O0KTp99E4HcX0VQBj3J9CGAT1KqB/a1EM+2wDbQY4ZZerqO755IZm3G59hZKcmDxTHUx9sgKsA2rwoYERjufaUhtTiAarX+IIMT0h73IRzyzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5kIggxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5kIggxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DF7C116B1;
	Wed, 26 Jun 2024 18:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719426868;
	bh=3yRDMMKMNncuYzsdnB9q9Wa3ZtQxVjiUH3bfWc2ch6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g5kIggxeGmKhWe7XAwXmjcNMqbaEHxo85kZhD/WLawen7YH6griu5GM6nfza9yykS
	 CcRbgPqThP2dmjlphE+/5qPlNunRtVdPcb61/Nq71HTItICRZoGpQzJsJfUr3iBT5d
	 OFMHuiejTP/w9PP4KVOHKtzq9Fm8GksCgznd6LsgScB9/vRAfkm1S4y/MbcAtUSzgO
	 Kv8efzjSYcwcnuFc4b1bifU/1NbCLJwsVScBmmbELd3yOLgzXWMDZLkZ9Z4RYkvaCK
	 L4xuD1UY+mXDBJur2bC3u4LVjQiazYQtxz+i+Q2qKm5VJhAA+YZb/GL8FOPUpJHHbJ
	 pmvoRLuB402cQ==
Date: Wed, 26 Jun 2024 20:34:19 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	stable@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 03/13] ata: ahci: Clean up sysfs file on error
Message-ID: <ZnxfK0a0pQrR4gxH@ryzen.lan>
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-18-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626180031.4050226-18-cassel@kernel.org>

On Wed, Jun 26, 2024 at 08:00:33PM +0200, Niklas Cassel wrote:
> .probe() (ahci_init_one()) calls sysfs_add_file_to_group(), however,
> if probe() fails after this call, we currently never call
> sysfs_remove_file_from_group().
> 
> (The sysfs_remove_file_from_group() call in .remove() (ahci_remove_one())
> does not help, as .remove() is not called on .probe() error.)
> 
> Thus, if probe() fails after the sysfs_add_file_to_group() call, we get:

Nit:
s/we get/the next time we insmod the module we will get/
