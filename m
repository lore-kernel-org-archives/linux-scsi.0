Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BADF3E5590;
	Tue, 24 Mar 2026 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774363091; cv=none; b=c8h/VhXgTV+LVHie/dhwQmlPFZMfna8micPEuGUayZrDjpFo7LLnCO7AbBI+/Wgr8kLS9jwGXvgxdKe0iOYyBrVt1rsHCdB0ML+QMZu119xmBT9cjpISSkajMSmtMlCJlTXKCUwM7F/UBy/QRlEOP2y7iBi0qI7UAqHrHTS39b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774363091; c=relaxed/simple;
	bh=e5f6jgo0dBEyQUURQKSWrpDzBd0JxDsZ01SMVL8k3SU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kdbr3XE67ebaWhFIQfJh0BrRzY6t758FoB4ttwB0P1w8Lh8ltSVKt41dG8fwNUecX1/h9xeY2NZIG3PaQIPV3oNwRErebtIdtvKy56t7+0F4SB30cqhc0k622Nos2cjpHkxY+XqC7bpC2XQNdQYLceTUHqbtnRl+U3wj47DKjxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qIMNEe8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qIMNEe8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6B0C19424;
	Tue, 24 Mar 2026 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774363091;
	bh=e5f6jgo0dBEyQUURQKSWrpDzBd0JxDsZ01SMVL8k3SU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qIMNEe8jc/gh4IeEeHB78CDBRX8uly5TJ7AQbfM/aTBCdNlUClXSmZ3DGj32XYiJq
	 w3bJ+ggFkIa6py50tYHZOmCtQhawWtrsj76/eDZGqNTS2E6DEDw7zok6+dGEPnugh1
	 rN0pTjYTfRuusdcmWnyo9rBjiDrJMXTlzi6iUnqi2UkrzVyRfQZmP9Akgci7mz3F+g
	 QuGR7o1Khy+ZyGWNS8jwo3oNlwx2iL889bycIRnXzH46HhBhKml65awhc9OfKZRYcU
	 c9A/SwhXZceArl/7YVlb4KEf7T2vzd4jdb/0Re/Fh6+vKY2naQlBbaFBfS5NTPAKfw
	 5GaQjW2N9rzXA==
Message-ID: <89b0e46e-693f-454e-ac74-6e396183c5c6@kernel.org>
Date: Tue, 24 Mar 2026 15:38:01 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/21] mm: have mmap_action_complete() handle the rmap
 lock and unmap
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <8d1ee8ebd3542d006a47e8382fb80cf5b57ecf10.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <8d1ee8ebd3542d006a47e8382fb80cf5b57ecf10.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> Rather than have the callers handle this both the rmap lock release and
> unmapping the VMA on error, handle it within the mmap_action_complete()
> logic where it makes sense to, being careful not to unlock twice.
> 
> This simplifies the logic and makes it harder to make mistake with this,
> while retaining correct behaviour with regard to avoiding deadlocks.
> 
> Also replace the call_action_complete() function with a direct invocation
> of mmap_action_complete() as the abstraction is no longer required.
> 
> Also update the VMA tests to reflect this change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Nice simplification.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

