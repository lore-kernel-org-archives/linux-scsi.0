Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154CA38D00F;
	Wed, 25 Mar 2026 09:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774432718; cv=none; b=aU2aRitSln/rwkEyE0m0UQsH5YGaodCqEZ9uCh+HBLpDDxtISJgbIjdbqQHk+Ou13MgRsAgNKh4h7f29iAUseXORigGfXNGNv1TuwlcGf1CdZrk6TElxyQd+BMSbDK/plrGZ0zDCeiCDGvMxG5hXDJdgokDpayf8edLw/F55pfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774432718; c=relaxed/simple;
	bh=HuY/gXey+uWVLYsCI6CkmOeVgc5q6DFm7SVnZaIS/YM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YG+tbgfN2Y59l10U8ZCb+e1hb5lwyWSIi8As7dpKyxVyItzcG4GIAO7uITBV/566VNeD75k2DscsNukYNcYHq9vfhJ+0fdglbA5hLkWSAza4p22DocfedPa4enyhs2HBqh39cwUY9Vq7mygFB/krMUCdfRfgRpbjAaU0pWow0JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u+uY8j9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u+uY8j9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFACC4CEF7;
	Wed, 25 Mar 2026 09:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774432717;
	bh=HuY/gXey+uWVLYsCI6CkmOeVgc5q6DFm7SVnZaIS/YM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u+uY8j9DdWnf6aJO3ZHhf6pj8o6upnz4tgfFLuwATHjhN6SatZRmXJbkO3JFsl45s
	 ADbQAVoZ2bfxIeImDpnwFdFCo0b8tn6HNyoZW5/j1NFRa+uXe019/Hzk1B5PNJSpge
	 oitV6NhzQsBWdl1ZGdGjjAleBOpYArsdSSBmuxkg0gbhRkp5b/B8T8vJcIMEA4HjHA
	 nsppJG3k+pdtmXbLxSqIZuQQW9qLID/Ou1ZIPnKK9/Xrsxbabxym2XTk8bjNKNnh79
	 gW+HYIQy6QtFwqaoSQC+HIe2caOI1oDm6sqQ/VOpZmE6eK1dpqAouDkD3M6o3nEwh3
	 regiPf+e17GQA==
Message-ID: <9b205b06-e938-4f30-a16d-7d90f8c49818@kernel.org>
Date: Wed, 25 Mar 2026 10:58:28 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/21] mm: add mmap_action_simple_ioremap()
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
 <a08ef1c4542202684da63bb37f459d5dbbeddd91.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <a08ef1c4542202684da63bb37f459d5dbbeddd91.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> Currently drivers use vm_iomap_memory() as a simple helper function for
> I/O remapping memory over a range starting at a specified physical address
> over a specified length.
> 
> In order to utilise this from mmap_prepare, separate out the core logic
> into __simple_ioremap_prep(), update vm_iomap_memory() to use it, and add
> simple_ioremap_prepare() to do the same with a VMA descriptor object.
> 
> We also add MMAP_SIMPLE_IO_REMAP and relevant fields to the struct
> mmap_action type to permit this operation also.
> 
> We use mmap_action_ioremap() to set up the actual I/O remap operation once
> we have checked and figured out the parameters, which makes
> simple_ioremap_prepare() easy to implement.
> 
> We then add mmap_action_simple_ioremap() to allow drivers to make use of
> this mode.
> 
> We update the mmap_prepare documentation to describe this mode.  Finally,
> we update the VMA tests to reflect this change.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

