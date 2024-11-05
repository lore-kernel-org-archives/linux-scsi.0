Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D237638DD6
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 15:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821655; cv=none; b=iyWkVG0qeONsKO005jEjGevObLabojsVLRopRtlE0XlVxsovfNZWE4ktbaH8dhA909QfgqON1N0b/22pzVPF4y8z7r/99eF2b/riYhv5Z8JWEh8kM/a/f1EGvZPXGhUYYl7bXa06ILxWPLKOsiDqLvovkUXxf7NUfKdDqncBdh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821655; c=relaxed/simple;
	bh=pMHS+BZcJvzC3eTRkGglggaSOrLpzfG/TWKOdJ2jVWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WyUA07B9ZeNLSxty3IPBJyXiDXBv4yiDkCxOM0XgLv58KljrEju7ZfUu3dvNdvcHfWz/oWroQBhmcx5ON15wEWVLpqgyMiaTzXd4byWAcU1ZC8/zyTTEtJEADpJZ52ZIRLwUCEWnJhaogCqGikppgIHP71EcIz8PWk2CRPztVkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iAMrdA0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iAMrdA0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EF1C4CECF;
	Tue,  5 Nov 2024 15:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730821655;
	bh=pMHS+BZcJvzC3eTRkGglggaSOrLpzfG/TWKOdJ2jVWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iAMrdA0cfLPmaowsqvK5YKsuHDfTQReSrFkWp17kPxUhscChSIXDTO3yrwEiSZhG6
	 ggN8fq52t2on2jbANkYli4We9sbEahEgCCYWXW2Bk2wLP2jjj1MedNkJY4fUpWK3jE
	 65B9CfaCqbX4GD+KSJ+5wLTi1beZP2eb408voZhX8JyfEywBvH18Tsi5lXl2Oi8sQK
	 e+CX+/dIy8XojjYO/iDLUUwOKQBAPhnajATSHUX3m75zQNOJfWWPvSXX6z2FXjZ3bK
	 i/lWxXUvFIE8pTYhz/B34QuVAMWHUYVMkVKqnwyEK9vOysl8jqHAKJuvDoFsYwsnKZ
	 cXIVPQvehyZNQ==
Date: Tue, 5 Nov 2024 16:47:31 +0100
From: Niklas Cassel <cassel@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, Wenchao Hao <haowenchao22@gmail.com>,
	Xingui Yang <yangxingui@huawei.com>
Subject: Re: [PATCHv8 00/10] scsi: EH rework, main part
Message-ID: <Zyo-E1PCvx_XULvg@ryzen>
References: <20231023092837.33786-1-hare@suse.de>
 <Zyng-RIx0XkeFLr-@ryzen>
 <a6cc3085-fa5e-4b23-8847-3e238143e191@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6cc3085-fa5e-4b23-8847-3e238143e191@suse.de>

Hello Hannes,

On Tue, Nov 05, 2024 at 04:22:40PM +0100, Hannes Reinecke wrote:
> On 11/5/24 10:10, Niklas Cassel wrote:
> > Hello Hannes,
> > 
> > On Mon, Oct 23, 2023 at 11:28:27AM +0200, Hannes Reinecke wrote:
> > > Hi all,
> > > 
> > > (taking up an old thread:)
> > > here's now the main part of my EH rework.
> > > It modifies the reset callbacks for SCSI EH such that
> > > each callback (eh_host_reset_handler, eh_bus_reset_handler,
> > > eh_target_reset_handler, eh_device_reset_handler) only
> > > references the actual entity it needs to work on
> > > (ie 'Scsi_Host', (scsi bus), 'scsi_target', 'scsi_device'),
> > > and the 'struct scsi_cmnd' is dropped from the argument list.
> > > This simplifies the handler themselves as they don't need to
> > > exclude some 'magic' command, and we don't need to allocate
> > > a mock 'struct scsi_cmnd' when issuing a reset via SCSI ioctl.
> > > 
> > > The entire patchset can be found at:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
> > > branch eh-rework.v8
> > > 
> > > As usual, comments and reviews are welcome.
> > 
> > This seems to be the latest version of your EH rework.
> > 
> > Do you have any plans to send a v9?
> > 
> Weelll ... I didn't really proceed with that, as that requires
> for some LLDDs to set a side a command tag for TMF.
> 
> It was relatively easy pre-multiqueue times (where you could just
> reduce max_commands by 1), but for blk-mq that now longer works.
> 
> We need to do some really cumbersome things (just look at fnic ...)
> and I hoped I could get the 'reserved commands for TMF' patchset
> in first, so then this one would be easy.

I see, I didn't realize that the series had outstanding dependencies.


For anyone else looking for the actual series in lore, here there are:

EH rework prep patches, part 1:
https://lore.kernel.org/linux-scsi/20231002154328.43718-1-hare@suse.de/
- This series has been merged by Martin, and was included in v6.7.

EH rework prep patches, part 2:
https://lore.kernel.org/linux-scsi/20231023091507.120828-1-hare@suse.de/
- This series has not been merged, and is most likely the
  'reserved commands for TMF' series that Hannes is referring to.

EH rework, main part (or part 3):
https://lore.kernel.org/linux-scsi/20231023092837.33786-1-hare@suse.de/
- Depends on part 2 (which has not been merged yet).


> 
> Alas, this hasn't happened, and so I didn't continue on that work.
> But I'll see if I can resurrect it.
