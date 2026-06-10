Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E9A29D26E;
	Wed, 10 Jun 2026 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781109365; cv=none; b=tUslUKp1eqF9qdgLJnqFRIKAKyMTnjAM3yyPWX9eOwEAvBQrGi7AwwI1sa9V0JEWcdX3DvIX6fx9ibUuvOJgrUVcDAnTqg93LVDC0SQonKKzkK23fNZExqnmAx0j16XTIJ+JIVgqWlSjnrjsk6yFD42CwQY9sZlmxF7BIaKraCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781109365; c=relaxed/simple;
	bh=Ub3aJDzQfV3ndDy3RlbrtoMFR4cZS0ws3oiDXOTKo58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1YSoOPv65VP/yjqZGuI7ndP5S6BuJ+kmbmiTbPS8kcT4BWIfU60ToER5wywp/7rNa8+N4uN15iLmvR5Yv8di4JEGiTAjOX6zRRZRlbJwA68KcNn6BhANePT25C2Phsn1ZzhA0MG+kVQJjheW93jEywWawbyBpiyL81W8u7leP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dYINVrSZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dYINVrSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40111F00893;
	Wed, 10 Jun 2026 16:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781109364;
	bh=nh8wY943fEj9O68DsnnpwY2/V+toQvePmwkX7p5hMSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dYINVrSZftHL1+14yqMRRxzqdHQ5Aru2hX4Xj5usxEkwHzPmZX+0xwOsW6Dztp5wP
	 buvP2PuA+QV5xPj78OletWBvmwhb43jqvV5GFsrZnuZuAMghgSwQoh0S8sgN+S9BTm
	 ixgW2hKOY1IFxC79EBrsQJFmBJhTgHzktayoDV1vYQ6PUatVZ8z/Tcr6XFUKU/a9/Z
	 pheURjB4DZFygToELeoT3p6Kl+8pJ6zz/rbZLD4ZtWjHEo3RFM2sDUxPLErYC7D1UE
	 E752J6xO3yZ8ppjwDDHNoD60M4V39r80G3RPynl7+S0nx3QFq8NW+mgS9cg+pAi3HA
	 Rq8MlrT88sswQ==
Date: Wed, 10 Jun 2026 10:35:59 -0600
From: Keith Busch <kbusch@kernel.org>
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	Adam Radford <aradford@gmail.com>,
	Khalid Aziz <khalid@gonehiking.org>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	"Juergen E . Fischer" <fischer@norbit.de>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	target-devel@vger.kernel.org,
	Bradley Grove <linuxdrivers@attotech.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Yihang Li <liyihang9@h-partners.com>,
	Don Brace <don.brace@microchip.com>, storagedev@microchip.com,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	linuxppc-dev@lists.ozlabs.org, Brian King <brking@us.ibm.com>,
	Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	open-iscsi@googlegroups.com, Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	megaraidlinux.pdl@broadcom.com,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com, Daniel Palmer <daniel@thingy.jp>,
	GOTO Masanori <gotom@debian.or.jp>,
	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Geoff Levand <geoff@infradead.org>, Michael Reed <mdr@sgi.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Narsimhulu Musini <nmusini@cisco.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, linux-hyperv@vger.kernel.org,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio Perez <eperezma@redhat.com>, virtualization@lists.linux.dev,
	Vishal Bhakta <vishal.bhakta@broadcom.com>,
	bcm-kernel-feedback-list@broadcom.com,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	xen-devel@lists.xenproject.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 3/4] block: drop shared-tag fairness throttling
Message-ID: <aimSb9I0Vl-68hy9@kbusch-mbp>
References: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
 <20260609121806.2121755-4-sumit.saxena@broadcom.com>
 <aikAs4X-2NWTuwCc@infradead.org>
 <CAL2rwxr1uGshb1o=jvP2OnBffNz2cKXj8tHuAUCN5HFuy2vB_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL2rwxr1uGshb1o=jvP2OnBffNz2cKXj8tHuAUCN5HFuy2vB_g@mail.gmail.com>

On Wed, Jun 10, 2026 at 09:16:11PM +0530, Sumit Saxena wrote:
> The motivation for this change stems from performance issue we
> encountered due to false sharing of the 'nr_active_requests_shared_tags'
> counter
> on certain CPU architectures. I initially submitted a patch to move that
> counter to
> its own cache line to avoid conflicts with 'nr_requests' and other hot
> fields
> (see:
> https://patchwork.kernel.org/project/linux-scsi/patch/20260402074637.92417-3-sumit.saxena@broadcom.com/
> ).
> 
> During the review, Bart shared his work, which eliminates the
> counter entirely by removing the fairness throttling. My testing confirmed
> that
> this approach resolved the performance issues and improved IOPS.
> This patch is part of a larger set, and I have reported the cumulative
> performance
> improvements in the cover letter.

So the problem is just the atomic operation accounting overhead? I
previously thought the device just really needed to consume all the tags
to hit performance.
