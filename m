Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196548;
	b=xt4CJp0aQjDxZlEqey2VPY75ryFZcKfZjqL55pbYp1J8fDBWAap+gFg8Aq4h/R123BZw
	 +0dK/rICZd0NpwGf9uZz2XuvZRpOX755CAqo5rIizqw1Xt+74GVdOIo9AfFtq/PmgLTwJ
	 KN9utAxR3PiLYH1RAvlGy8sRA2NCCR26T2BiYfqbXZWwwdanS3bvppfMRlxexiZEvObXo
	 9yUqpiFQgcPtCLsinO/BAd76TrLK6OBLqr0ivpHme6cjSZr150s5BnBWhj6CXhuLQlezA
	 CcjWXaUbKlGyTudHOwC//odbIMJgD+5G5IZ6KHNzplQuVackwQDjkR5+uPNMCZIYvUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Ea+LYLLAL84+aWPcNA3JvxhkUDjjeUjD4ajVVBAr+YE=;
	b=ToI0csKEVscvJhFkM7RlzaMcsSnJHf0lBQXfqdpq3CYOOgEDy79lnLAbqhvN/rr5bIK2
	 9QUQ7I1XJWQ0oj21NhEvzMWPo+enTHekFzwGhISJL72XexxesuGiAnpsRB2PDZZv9h1JQ
	 weKCDyEeppKQQOQhl3kUUfEmE4bjl6pnFwZ/p/JzCWlq4dLkU8W0KbB/3LOVooA1u9kcD
	 m5PO9LilYYm0zTQvbsaJJzO4eJsGyH+dPL+4k57cR0T4Oc6qxnSIzZLrtY28P5DQR3hU1
	 GS1UWDHDZgoZnTgMDjTm+4YMujuhWQA7TCcypt2qttko/jG6ENDA40+NYfvPAR+xu5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zncl3CT2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A4B606EE94;
	Mon,  9 Nov 2026 03:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zncl3CT2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02CA1F008A1;
	Mon,  9 Nov 2026 03:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196547;
	bh=Ea+LYLLAL84+aWPcNA3JvxhkUDjjeUjD4ajVVBAr+YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zncl3CT2Wm24BOpJbjhvbWqscQ4ozTt789VlDk8XEuL5TvI/vsstMYpBNfocJIqT+
	 Ii+4l5Yp3IxBr941VBXbNvL0DHUPaypQQdI1wdEmiR4JHop+j6t26cHeP3vCwVT0Xa
	 j23jdjXSvwBufi88t3Qt7GurzVQoS+Rix5O1eZ9kfyk/9KxhFZvR6IG9TjbQbQ20Jc
	 ConPDLn9MKJLB8W7P3O7qOKM/0eNVG2+rAYmRpppA4gGTfzPYHC6KchVukCv1R37al
	 XEq6CZ9E5SzT3OttTPFOyFLD2YMyVwEBUHpN92OIkluRk+CIknBJKLGbN0guEDYp2Q
	 WOvTfoCqr5VGA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	shao.mingyin@zte.com.cn
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	bvanassche@acm.org,
	hare@suse.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: rdac: Keep the error status when controller lookup fails
Date: Sun,  8 Nov 2026 22:55:28 -0500
Message-ID: <179419615237.1941224.1371295334998705297.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026195409354OWEI2b6HO7swSphvv1FOc@zte.com.cn>
References: <20261026195409354OWEI2b6HO7swSphvv1FOc@zte.com.cn>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 26 Oct 2026 19:54:09 +0800, shao.mingyin@zte.com.cn wrote:

> initialize_controller() records SCSI_DH_RES_TEMP_UNAVAIL when
> get_controller() fails, but then overwrites it with SCSI_DH_OK
> unconditionally. It therefore reports success with h->ctlr == NULL and
> rdac_bus_attach() continues with check_ownership(), which dereferences
> h->ctlr:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   ...
>   check_ownership
>   rdac_bus_attach
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: rdac: Keep the error status when controller lookup fails
      https://git.kernel.org/mkp/scsi/c/46846939d5f3

-- 
Martin K. Petersen
