Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC011FDD
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 05:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709789515; cv=none; b=ju6KnmIIpcfQnXxPbkWSZKZYB4ATf8Y9SKyRj/TX8XxMyOzpY8Rr6MmxrYpJtNS1yz51Ea2UoFF5gY477PQ7jb8rZzNFVJ7OLKmN1nYFA1d5ao17IvXyR7AZU6q3QrZcw/H42WcewWlea7DXigVIEr3CjLnTk3ABFRig1CIDYt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709789515; c=relaxed/simple;
	bh=d0Ufl4MibzFscR0K1VA6p6YEY6iaz+LmQ01k8l4gkOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PB/RL3gxywnoYUr0go4oU5OF+jgqsBcPO442RRzP+qCUbtFKd43lAijyMSKyr5gwxF7L4jUEZ33N+gLh1olpgtyW2GUS4pF6qfNaxx5PtHS5W2Av+Z31tOVvI2VTD0SKYeMV33j5Znlvs4b5SkrZZ+DU6McBCcVEj28XPmXFJDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=cE/l1/at; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="cE/l1/at"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dc3b4b9b62so4340115ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Mar 2024 21:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709789513; x=1710394313; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L47MhA6RlNNWhsEXCUPqvDSxXvqi0AMkVxgVFxt+deE=;
        b=cE/l1/at8BXkS8vq3j9a/XvN48Q84ehmiAJlit9Arfg0dF6ZWwNXIOSosfGJUOt5C1
         R4jMOMfs4hOkd1xGPN9cwwSywv7K78TpYGYreL/iCDTk3iHY7M4Oe5Nmmug5mwFhlqwL
         xK2+rlcIRNjUAizmDXNvkc0nkVHhxDTYCIx+tzrdfG4rsTqRaspik1hebeMF//v+HlVk
         RblLtkOpOyJw6EmU1vlltEwYB7ZVAov+a5+tLOAVbm68r/d3z2dOyV8G2bsmaF3mGL8P
         0aQzbK4YbJT+RhhOaT6LDKXNHy6CskSNvJK8ASXaHvN0Tw5FP5Qbe+kFmEDByG48a/8S
         1WDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709789513; x=1710394313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L47MhA6RlNNWhsEXCUPqvDSxXvqi0AMkVxgVFxt+deE=;
        b=Xniuaq8rt/Zejf//e7FUmuTZ9Q303cgBeRuLxqrGL5r/CAETZy8An9zCk4BrqrDl21
         5i1ukoUoLd9siY8o1O7cg3rE/y8QY0zkhR4ietw541rhWW869Wb36tRKklkxb9yB2afI
         pcSvuN9VSHITtCvg21DQmVEMPE1H6qwegYePpSAXRA/Ze1OBSE4CTd3qDe/bbg9VCZ6L
         A8uMiKHmdcYmel+9aH4glCs4wH7atNtq9pFmvIHM4eME3IZVFQ0tsy0fWB4ZxBVpLUor
         4pttB7DXOGuGSCdU1+8jd/VBxxbxNhbcOlA5swgKWHQjPL3roCShjStYVJ8ccr/WyR1F
         UAVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKcpQ9TStqn76h807pB6m86Z9Kf/qH81NsZt1jxMEunAbqVAKcA48XKBMr9jeZ1409sEC9NQYeXEqp4DucdBXypt5SADt76HsiqA==
X-Gm-Message-State: AOJu0YzoXbhFG4FAzrqGUHtMXykheurY1gyd6WuZBiEhlr66r4o7j0ug
	MAdrQxwJrIirmEGBqUNUvvQeMqBd6A5oR/Ni4rgUEwPm2Cr899R0AmAYDsjaRig=
X-Google-Smtp-Source: AGHT+IGz82Z2o57rsxo8MUUyj5kmz5ZD4c9J2gDw8Id8hGUA6zXaFrREbrxI/w7LJItZwwUPJP5S2w==
X-Received: by 2002:a17:902:b494:b0:1dc:a836:19af with SMTP id y20-20020a170902b49400b001dca83619afmr523182plr.32.1709789512233;
        Wed, 06 Mar 2024 21:31:52 -0800 (PST)
Received: from dread.disaster.area (pa49-179-47-118.pa.nsw.optusnet.com.au. [49.179.47.118])
        by smtp.gmail.com with ESMTPSA id lh13-20020a170903290d00b001dd58258d19sm127006plb.40.2024.03.06.21.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Mar 2024 21:31:51 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1ri6M8-00G7kw-1e;
	Thu, 07 Mar 2024 16:31:48 +1100
Date: Thu, 7 Mar 2024 16:31:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
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
Message-ID: <ZelRRFTBvpyXeVGD@dread.disaster.area>
References: <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
 <ZYUbB3brQ0K3rP97@casper.infradead.org>
 <ZYUgo0a51nCgjLNZ@infradead.org>
 <9b46c48f-d7c4-4ed3-a644-fba90850eab8@acm.org>
 <ZZxOdWoHrKH4ImL7@casper.infradead.org>
 <ZdeWRaGQo1IX18pL@bombadil.infradead.org>
 <ZdvIlLbhtb7+1CTx@dread.disaster.area>
 <ZdytYs8W9o0CIu_C@bombadil.infradead.org>
 <ZekfZdchUnRZoebo@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZekfZdchUnRZoebo@bombadil.infradead.org>

On Wed, Mar 06, 2024 at 05:59:01PM -0800, Luis Chamberlain wrote:
> On Mon, Feb 26, 2024 at 07:25:23AM -0800, Luis Chamberlain wrote:
> root@frag ~/bcc (git::blkalgn)# cat
> /sys/block/vdh/queue/physical_block_size 
> 4096
> root@frag ~/bcc (git::blkalgn)# cat
> /sys/block/vdh/queue/logical_block_size 
> 512

This device supports 512 byte aligned IOs.

> mkfs.xfs -f -b size=4k -s size=4k /dev/vdh

This sets the filesystem block size to 4k, and the smallest metadata
block size to 4kB (sector size). It does not force user data direct
IO alignment to be 4kB - that is determined by what the underlying
block device supports, not the filesystem block size or metadata
sector size is set to.

Sure, doing 512 byte aligned/sized IO to a 4kB sector sizer device
is not optimal. IO will to the file will be completely serialised
because they are sub-fs-block DIO writes, but it does work because
the underlying device allows it. Nobody wanting a performant
application will want to do this, but there are cases where this
case fulfils important functional requirements.

e.g. fs tools and loop devices that use direct IO to access file
based filesystem images that have 512 byte sector size will just
work on such a fs and storage setup, even though the host filesystem
isn't configured to use 512 byte sector alignment directly
itself....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
