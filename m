Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667FF427FBF;
	Fri,  9 Oct 2026 06:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526244; cv=none; b=C3B0Ol2rwqeNhjg7QdJiav/QClH88FODaJcMxLrkVRLbSNBByx4x8VbQjSQYQKmHi0I/yl8U9iuZvY97EwLgtobnHoa5iE2IaJfBC/BUlYaXk/83J5AQaMSlYytu2Ywiahl8wEypmvGkH3d2VLFHTwel6UQYTOs2sIdlmbTnXK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526244; c=relaxed/simple;
	bh=qWVCUMv+05dbMHEs9hy+pYj8kfk37TJfd0nuNcp0x8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VtR3xUOkdFZ8j5BOXdOVRhnEz9WJaAAp2g2DVUTz4m17syLZg098De6vU6yLu6Y+NgivX2jsiEpKmX9xjmw3jYatZd2ed/LOnCkWgM1XE/+vXv7mZgML1WcmCtviFbpQYoAGFtXF/LDlALOkUP0VH4cc8FDcZOfAlTgnIPDNpS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IG8AWHmx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IG8AWHmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A91F1F00893;
	Fri,  9 Oct 2026 06:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526242;
	bh=QwHFVPuXBquPEGMyUZnxzJnxgW+4GMWcshWyvzeLTeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IG8AWHmxgcgfeQJDzx8TznUhmmfIR9iQsxELHM1DJ9iLm+tG0Qx5Ft2AeeShvR7rG
	 +MhwNOWOC6otnzznLRXqQa8de9w92/vGkLmpPIh4gTZgCUa6+aa46rZeOfm4GeW8yt
	 5YXSJ8hYmmCGKYX7tzG5pbeDX1x9niwjsJ81aKtkQnxoVn1EyE7AwoUxGgPqmvzdR5
	 jAugDxKHTq8/476p43ZNzwL5Qqquu29UMneLEzxgaLrA+lW03HDWQYIFrwRQn0cSb3
	 wZH+6OiYtyxMlbtJJO3grVRzqOcwL94XqIqXNhxuQZLwZTzxdgVR6lyAIwrBzpY3tq
	 XeAV88PEwIBSg==
Date: Fri, 9 Oct 2026 08:10:39 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Haotian Zhang <vulab@iscas.ac.cn>
Cc: James Smart <jsmart2021@gmail.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	Daniel Wagner <dwagner@suse.de>, Ram Vegesna <ram.vegesna@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: libefc: fix resources leak in efcport_init()
 error path
Message-ID: <20261009-muscular-dazzling-bullfinch-fdb28c@quoll>
References: <20261008185403.2791781-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261008185403.2791781-1-vulab@iscas.ac.cn>


On Fri, 09 Oct 2026 02:54:03 +0800, Haotian Zhang wrote:
> efcport_init() creates efc->node_pool and efc->node_dma_pool before
> allocating efc->els_io_pool. When the latter allocation fails it returns
> -ENOMEM without releasing the node dma pool or the node pool, leaking
> both. The caller efct_efclib_config() only logs the error and
> efct_device_attach() failure path never calls efcport_destroy(), so the
> resources are never freed.
> 
> Destroy node_dma_pool and node_pool before returning from the
> els_io_pool allocation failure path.
> 
> Fixes: d7b71fd2195e ("scsi: elx: libefc: Emulex FC discovery library APIs and definitions")
> Assisted-by: DeepSeek-V4.1-Flash
> Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
> ---
>  drivers/scsi/elx/libefc/efclib.c | 2 ++
>  1 file changed, 2 insertions(+)
> 



Multiple things here:
1. Your team ignored completely previous feedback.

2. You use multiple identities with this email, thus I actually doubt we speak
   with actual person.

3. Finally, same feedback:
You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem (so a patchset grouping multiple patches with a short cover
letter), how to document usage of LLM and how what you should not do
if this was posted in a good faith.

Best regards,
Krzysztof




