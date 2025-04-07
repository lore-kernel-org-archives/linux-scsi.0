Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912EC155A59;
	Mon,  7 Apr 2025 20:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744057849; cv=none; b=GTNdKXQIYDOXDrrVP0frmnUWctbrDaMVTMd8vjUHe0rgoVJhWQGVR/YSCldcqf+H7fz0My7TSDt6zK0ib4xDnPd9YmmEoaqIh/rA+sssTQP9jdiRiOClzBZ61lr6X6z227vo1gxEZvl3/HiEkAc8hV7hyck+aW+Ta1Q5rUsXOQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744057849; c=relaxed/simple;
	bh=aX8gqFFDz3aJgiJg+W0QD39qGZotbE0J+oqjt08tgH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KjOoqMFeGbYzg1kNvMsne7VgHETOGY+b7AO+JM6CAI1epY96ZRXmYuaj216BY4opw9D5/EhidNVD9w9dke3XM7gp9yXz8GjQW8ceZ+RILwNaCjAffOGMk6FtqAq6qNozZqQOIyP6V6Iv7cTP6K164oYZx5iL9+t6B6uZz3jF9EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zt+xCYHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zt+xCYHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EE6C4CEDD;
	Mon,  7 Apr 2025 20:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744057849;
	bh=aX8gqFFDz3aJgiJg+W0QD39qGZotbE0J+oqjt08tgH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zt+xCYHt9EIIZFqi6AgmNiWL6K0G8MoqwjgEl2rir6MnyEDm7706x+kqPjbBJVFBQ
	 ghp53bHFXfyd2wiq8JyNROwlTD5ZWWu9/v7mrlNXDiEFiY3lEt/YNBQs282HiE4ijM
	 brLgqF6YACgWs7FZpXsvkXiIOrERy8/yiGo24pvOs8NVzOZkG1lzXR3SWDi/qD0ATK
	 FOzAjTq2F6oVjtcRv02VLtJ6hk/MS/1g5TGpnFcnsTK0d6tPfHI9JCT5KWnLmptn8F
	 kkQqSy8NgiWp8n0hj3BULNWtrOhH1fTUorL5363XG6rD9DBzXc4QFOZ12y5X8HoM8C
	 46Yqlkrj3AuLw==
Date: Mon, 7 Apr 2025 13:30:46 -0700
From: Kees Cook <kees@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: James Smart <james.smart@broadcom.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: sli4: Replace deprecated strncpy() with
 strscpy()
Message-ID: <202504071330.90FC6D8@keescook>
References: <20250226185531.1092-2-thorsten.blum@linux.dev>
 <202504071126.37117C5D@keescook>
 <67E5FE26-F258-4690-A466-236A7E7484E8@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67E5FE26-F258-4690-A466-236A7E7484E8@linux.dev>

On Mon, Apr 07, 2025 at 09:01:53PM +0200, Thorsten Blum wrote:
> On 7. Apr 2025, at 20:28, Kees Cook wrote:
> > On Wed, Feb 26, 2025 at 07:55:26PM +0100, Thorsten Blum wrote:
> >> strncpy() is deprecated for NUL-terminated destination buffers; use
> >> strscpy() instead.
> >> 
> >> Compile-tested only.
> >> 
> >> Link: https://github.com/KSPP/linux/issues/90
> >> Cc: linux-hardening@vger.kernel.org
> >> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> >> ---
> > 
> > Standard question for these kinds of conversions: Why is it safe that
> > this is not NUL padded? I haven't found where this buffer is being
> > zeroed out, but it probably is (given the "- 1" on the length), but
> > without run-time testing, this needs much more careful analysis.
> 
> I think this was submitted before I started to explain this better.
> 
> 'wr_obj' is the zeroed out 'buf' returned from sli_config_cmd_init().

I don't see how dma->virt and buf are associated?

> 
> I'll update the description and submit a v2.

Thanks!

> 
> Thanks,
> Thorsten
> 

-- 
Kees Cook
