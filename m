Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBE3380;
	Thu,  7 Mar 2024 07:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709796583; cv=none; b=qRZSwrZLJzXMf6dIh/TWLGhbBZLsG8o7XHW+eZY9xTAU2AxcCwMYtoIg2ce0woh1dlXsBLpu4V22a2P8IqmuNMptmuaN3EEOQS8lMd4KrBKXQioDIPCOulKR8A3vct2kY7n0Zag/TrA8dK8vRoTC0dH+11ngCMg7qjvAxj0aw0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709796583; c=relaxed/simple;
	bh=WTCmRUFn9loqRZBZsNwtJfhC5krDk3NUpnBxh/UBZuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5k+RkQX64gONoVssoLcBjRtA7JToU0xLtzpo2t+oN+VWFUW1CkDBegd63Iv3PkwNU3A88quOASkHF45YRec7Yq/BfIhsEkveJnZiLVLysmNLcNgfjoMJmtmH7z2lzcAd1wF/E2MkbX6RBTr9zig1+EPprL3atmFeM5xnzKiXzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LrwkogI5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LrwkogI5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5zuLqYXEcrU0IPXnJfRZey6qQ6C1CibUgZYtXv3ee+4=; b=LrwkogI5MD3mB2ZKZDtdSnB8XN
	USTKsHnJIQsl120q7UgahKq6PX8viZIMVtqHYuNF8bchMfZ6noelYGfxyaF0v28nZ+jAzb/xIT0+x
	dgmtwMvJAUODmYfh2JFjSV5gS5t7YjhElxBlSiCN+bnD+qwnYk4/tOiOExfXiSoBqi17Jcs2dB2J/
	zN4CmjI1VG2oUjCHv1mMiI931lkUGOWImvsLvWZCNdmj7+bP+yyy+W0Z0Y+01jBie28NU1vIKFWtu
	wq4J1/aqGdnn5KtJJvkduVCBctmBuHIM8HRURw1EOMsCilW2MR46oF6bs5SGCXYdwbmjAy8mCyB1h
	rAXeLLTw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ri8C6-00000003Qme-3F6u;
	Thu, 07 Mar 2024 07:29:34 +0000
Date: Wed, 6 Mar 2024 23:29:34 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "kbus @pop.gmail.com>> Keith Busch" <kbusch@kernel.org>,
	NeilBrown <neilb@suse.de>, Tso Ted <tytso@mit.edu>,
	Matthew Wilcox <willy@infradead.org>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, Jan Kara <jack@suse.cz>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@infradead.org>,
	Hannes Reinecke <hare@suse.de>,
	Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier.gonz@samsung.com>,
	lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Message-ID: <Zels3qAHksXonaAs@bombadil.infradead.org>
References: <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
 <ZYUbB3brQ0K3rP97@casper.infradead.org>
 <ZYUgo0a51nCgjLNZ@infradead.org>
 <9b46c48f-d7c4-4ed3-a644-fba90850eab8@acm.org>
 <ZZxOdWoHrKH4ImL7@casper.infradead.org>
 <ZdeWRaGQo1IX18pL@bombadil.infradead.org>
 <ZdvIlLbhtb7+1CTx@dread.disaster.area>
 <ZdytYs8W9o0CIu_C@bombadil.infradead.org>
 <ZekfZdchUnRZoebo@bombadil.infradead.org>
 <ZelRRFTBvpyXeVGD@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZelRRFTBvpyXeVGD@dread.disaster.area>
Sender: Luis Chamberlain <mcgrof@infradead.org>

Then it does seem we have everything we need already, and no changes
are needed. Because these drives *do* support the logical block size
advertised, it's just not optimal.

On Thu, Mar 07, 2024 at 04:31:48PM +1100, Dave Chinner wrote:
> Sure, doing 512 byte aligned/sized IO to a 4kB sector sizer device
> is not optimal. IO will to the file will be completely serialised
> because they are sub-fs-block DIO writes, but it does work because
> the underlying device allows it. Nobody wanting a performant
> application will want to do this,

It's a good time to ask though if there may be users who want to opt-in to
promote this sort of situation so that the logical block size is lifted
to prevent any IOs. For NVMe drives it could be where the atomic >= Indirection
Unit (IU). This is applicable even today on a 4k IU drive with 4k atomic
support. Who would want this? Since any IO issued to a drive which is
smaller than the IU implicates a RMW, it means your if you restrict the
drive to only IOs matching the IU could in theory improve endurance.

> but there are cases where this case fulfils important functional requirements.

Sure.

> e.g. fs tools and loop devices that use direct IO to access file
> based filesystem images that have 512 byte sector size will just
> work on such a fs and storage setup, even though the host filesystem
> isn't configured to use 512 byte sector alignment directly
> itself....

It would seem like quite a bit of things. This is useful, thanks.

  Luis
