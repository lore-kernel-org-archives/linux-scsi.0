Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793776321;
	b=BMTTmqM/1htItQAgW5RvSW3XmmI7AKnCGGVfhVpGpnj1l362Grn7nI6ZVt/yK2sHm8Ud
	 tCxK+7o1kC+/ZQq31tPzJCvkRl5TOnPkm4uAg3ZUxQIKlfmVvG1Wtqdt6B6JvfjRgdFcW
	 YePcZNojD36T5d+5y3q06KTKaIITSPifOWRvHXki0y8/chv4cO29JvAGh+RyNF495uno6
	 ZHdi7aW2SGkf0yUS+52Yg5MpyK+zx+CkfQViJlFFBYltFQtCltbZIY/HnO0PcXhLaLAhE
	 BbqFrL8aaRsKYhlfUsnLbmCqyBF/S3pOJYHRAzbzQA93joi2gcuRapQnNnWk5m0VEWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793776321;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=i0nF4NvOSbcZxgWHiwHcmP13MS4LghIt918I641xiu8=;
	b=5aFX1vDK5wbAKThEKaCpiOr3hYmHtlk+B5OyNAasOr9zFC+JTAUQxYBcsm0xMl5DZNH/
	 xq0sMjb3QtaKiY6gMvUIgvLSfW5DIcrMWJDn4PvrmP6Qd+BeFOZfUhEq7oZT5oLvRNCuJ
	 wJYUzZnr9EtPZWd2CHG9eVgD/VpvdzcHs+W+trmX9PZVvrx9BkM2eWomSO0hlJR08eXL8
	 QBBVNttu4vGId7OA9r2JlgiII7PR0CsqVB33JFnv4rU5/K51YzjdW6kDrUeAxT0+Hu9D7
	 8Atsfzrrcujtqu9hWju5IWCT6SkI/Cb5Ju63Y+sbIVe36dWLGIc9tGGEePggE1KJBnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hzj3tLP4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F805606A326;
	Wed,  4 Nov 2026 07:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hzj3tLP4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D461F000C1;
	Wed,  4 Nov 2026 07:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793776321;
	bh=i0nF4NvOSbcZxgWHiwHcmP13MS4LghIt918I641xiu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hzj3tLP4wSAHRDgBbzkAcSCh2/wZwwNt6W7hFxPFA9O57cmBe7/aVY4VLb7TGIWUQ
	 UjkHHiAk1oxjcUi/8QucVYnYeE4vOD7a09Pty1t4+B34U63UqlVB1s7MCfs766sOT7
	 M/qqmOLgTYJO7KB+tZ8lDq6S6I42jF7uTS+JBHBR8anoyyUEjsq9dUYwXdfra1vURh
	 HbmMMacQerXM6K9mWB4n/R3+T/MR72+LHDCjFoKusYSrBDcjzEDkIB6UBTCYH+X45e
	 +IBwIQ+yOTvNgz297PlUzOIe4tC6LBXCQFuMReMK3RXVSnwcLAfpVslWi3IHHU3GfI
	 sjFDyqlVy8ctA==
Date: Wed, 4 Nov 2026 08:11:57 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: cxgbit: drop the cnp reference when the close
 reply never comes
Message-ID: <20261104-dazzling-nifty-echidna-3aba41@quoll>
References: <20261104021448.1468404-1-vulab@iscas.ac.cn>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261104021448.1468404-1-vulab@iscas.ac.cn>


On Wed, 04 Nov 2026 02:14:48 +0000, Wentao Liang wrote:
> __cxgbit_free_cdev_np() takes a reference on the cxgbit_np before asking
> firmware to remove the server socket, and cxgbit_close_listsrv_rpl()
> drops it when the reply arrives.  cxgbit_wait_for_reply() can also give
> up before any reply is received: it returns -EIO straight away when
> CXGB4_STATE_START_RECOVERY or CXGB4_STATE_DETACH has cleared
> CDEV_STATE_UP while the request was in flight.  That path is not the
> -ETIMEDOUT path, so the function continues, frees the server TID and
> returns without dropping the reference.  As the TID is gone, the reply
> handler can no longer look the cxgbit_np up and the reference is leaked,
> keeping the np allocation alive forever.
> 
> Tell the two -EIO sources apart with completion_done():
> cxgbit_close_listsrv_rpl() completes wr_wait before it drops the
> reference, so a finished completion means the reply owns it.  If the
> wait gave up without a reply, drop the reference locally once the TID
> has been freed.
> 
> Fixes: 9730ffcb8957 ("cxgbit: add files for cxgbit.ko")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/target/iscsi/cxgbit/cxgbit_cm.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

Multiple things here:
1. Your team ignored completely previous feedback. Multiple times.

2. You use multiple identities with this email address, thus I doubt that we
   speak with an actual person.

3. Your bot does not even bother running checkpatch, right?

4. Nothing of this was reproduced nor tested.

5. Finally, the same feedback:
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
letter), how to document the issue discovery method and what was
or was not tested.

Best regards,
Krzysztof




