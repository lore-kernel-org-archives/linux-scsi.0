Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C456222599;
	Tue, 24 Mar 2026 14:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774362686; cv=none; b=L/aDGYwZmxOBbsqCM9p/wpjtOJpVNO9qVNs0kjCBbp6SGCLoGhNYD/6BE6iCIKf/XjpPzkX1IojM8T49AWrJSlMLA4ymYEaH6PC0VSUkDsozFnAJrx1n2ZV2DRkR14u9CUUmY9QHDfNLD5icnKUolFHZKeu2rLTdS6PZUeJEpgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774362686; c=relaxed/simple;
	bh=0oYopjVJ5FfZx7yBJY5biK1wFueGF1ISoTXTBTdvEco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ToGc+wL6NNofH05NV0efnIy1cQp4ZA5vhKION99z5A6JBNBOD2dn7Pg+bGSyBxcSMk0+WfDbKz1ZJVj4mwWQnUYd8wCt0qTXwudE31asUojSpsD8QY0sUXT4myDdA7iMa865JgNI6qjIdBYBZv/8wB+duoIYbwcg6zanUJ+OX40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/iVyRqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/iVyRqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DCDC19424;
	Tue, 24 Mar 2026 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774362686;
	bh=0oYopjVJ5FfZx7yBJY5biK1wFueGF1ISoTXTBTdvEco=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j/iVyRqoAgsG15GdgKyoiArd2eFqRcIl7DXzGaGTtG2Y0o7o+tjV70May3h7h7RLT
	 V7S2RptNUFiSvB3YL9Arvd1/5pUSBJrsV385XLYdp8ncPFclpr5NciQAWxqxmbnEiV
	 oGusSnopYimqq5x+nEGLkPHfJfSrph+4t9ZTsmakMF24m+DuJZinF+HwwBv0F6oXfj
	 8Ajb3LcvpJ0geiSO23cTGq4R54D5xwU781bHvtDBiy0/W+L+jGnt1gku6YsbTLI6qO
	 tBqw5ZSz29d6y6/PZPYtjCgDpggJ+d1BrWbTeduVQTASS9C9lGiBuYSSdwtQJAyER5
	 Iy/3msdCCKs7A==
Message-ID: <82dc0ffb-a0e2-4358-b182-94af71ceb697@kernel.org>
Date: Tue, 24 Mar 2026 15:31:16 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/21] mm/vma: remove superfluous
 map->hold_file_rmap_lock
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
 <42c3fbb701e361a17193ecda0d2dabcc326288a5.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <42c3fbb701e361a17193ecda0d2dabcc326288a5.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> We don't need to reference this field, it's confusing as it duplicates
> mmap_action->hide_from_rmap_until_complete, so thread the mmap_action
> through to __mmap_new_vma() instead and use the same field consistently.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

