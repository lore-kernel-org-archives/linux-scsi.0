Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535753B5832;
	Thu, 12 Mar 2026 21:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350069; cv=none; b=ClazzjrQcwGjPmHPlzQNoIvqLnqie62ti5ZhuBrlk3rYTrHtPIpgMv7+AgZeDVa07e++5wK2mtgppkW9ghlIUUrFoYc8kVv0X7w/vGE+4w+W9Nl0b67FMnlwEmCuYWxpDhZWRrYhkknLU8XbwIM/a552h0cdoh7bYCrFL0+cvM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350069; c=relaxed/simple;
	bh=BHIeqMCeZ08yvAl5YqqjtddRClVSOvGwSHug5GXzEz8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=JWtcw6Wr/qHSOHghAHwLNXQ5H9EjpKf+6d4b8QTvHv3t6m+X0i9kFc+rom59saPj9FbLW4B0X2nakzINPbA9u6comct7v/EN6H/r+KVgeY9qEXp/dYImmq1/vk27JyLGmD6QWIgGtM1DUDhn0OCXNUp9JlLYKMhA2PDM/4IWjDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Duh+dhDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Duh+dhDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3794C4CEF7;
	Thu, 12 Mar 2026 21:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773350068;
	bh=BHIeqMCeZ08yvAl5YqqjtddRClVSOvGwSHug5GXzEz8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Duh+dhDjn9i3oyIucNjLcpV7CKSwWMDBwP1nrAeCAWcyGXtDakHpRp+pm3kMEvL8y
	 SEaAaWk5jP3gQGaz8kV5kaoD1HdJgTdnHuWBZE8KvOuDSG+7q7krHiTC3YYNdfGDfn
	 Xpz6tLlo5tMrkq0Sz1LyxlbqOsozNn9yfZFUkN8M=
Date: Thu, 12 Mar 2026 14:14:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Alexandre Torgue
 <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen"
 <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, Marc
 Dionne <marc.dionne@auristor.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Ryan Roberts
 <ryan.roberts@arm.com>
Subject: Re: [PATCH 01/15] mm: various small mmap_prepare cleanups
Message-Id: <20260312141425.1837736829210f2d0b00cac6@linux-foundation.org>
In-Reply-To: <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
	<56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 12 Mar 2026 20:27:16 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> +int mmap_action_prepare(struct vm_area_desc *desc,
> +			struct mmap_action *action)
> +
>  {
>  	switch (action->type) {
>  	case MMAP_NOTHING:
> -		break;
> +		return 0;
>  	case MMAP_REMAP_PFN:
> -		remap_pfn_range_prepare(desc, action->remap.start_pfn);
> -		break;
> +		return remap_pfn_range_prepare(desc, action);
>  	case MMAP_IO_REMAP_PFN:
> -		io_remap_pfn_range_prepare(desc, action->remap.start_pfn,
> -					   action->remap.size);
> -		break;
> +		return io_remap_pfn_range_prepare(desc, action);
>  	}
>  }
>  EXPORT_SYMBOL(mmap_action_prepare);

hm, was this the correct version?

mm/util.c: In function 'mmap_action_prepare':
mm/util.c:1451:1: error: control reaches end of non-void function [-Werror=return-type]
 1451 | }

--- a/mm/util.c~mm-various-small-mmap_prepare-cleanups-fix
+++ a/mm/util.c
@@ -1356,6 +1356,8 @@ int mmap_action_prepare(struct vm_area_d
 		return remap_pfn_range_prepare(desc, action);
 	case MMAP_IO_REMAP_PFN:
 		return io_remap_pfn_range_prepare(desc, action);
+	default:
+		BUG();
 	}
 }
 EXPORT_SYMBOL(mmap_action_prepare);
_

