Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CED282F3A;
	Fri,  7 Aug 2026 17:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786123707; cv=none; b=ENiAKlJ3Bq8bTQIFSCE0wChairosONB0xZ7uw61pAQOLoKYbqciX4mBAZwe+fKNKQKT6sr2bcKAk5U6rn1ZazRostY1YxsNdyXMSeDDXf5fAQHj4bZXlVwOcIvOEI5OMz/HdsVjCZEy410rH9iA63mbSb4tPT/O0QrkzTiN4xVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786123707; c=relaxed/simple;
	bh=wvF/yAdAENW6ynY5aE7h6/r8LjNYZddSAaoDaQhOmrY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=f/+KX1z+ehanRb/MvW6NjrPkf5XxziJ88iK3hdFbFwLPeZwtqzmp7qD7Bx7aW5UdvjUEkRFoaeD0K9wJ8gbikrTjNLw8PwqtZ5vMzi0SgO9bYghTd4NDnw8QjTBQFsZK/jTOoI6e+HF7TcG02yFljsHhHjwmlhvHRut5imU145k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZpn2v6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZpn2v6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7FC1F000E9;
	Fri,  7 Aug 2026 17:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786123705;
	bh=RYNg6VgBqbMhT3DRW9zf2CopE96jsw77BBtpsdA364k=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=FZpn2v6GQWa2wwwZg5tECIDlDt7mkSecyb+HGIbwLghQxDk6XUCqgjD/zouNAotXR
	 Ca5+SGtUbDtE1tJgrLH9qk6P1Yx3SalKhjb29CF1KeYZLGAnJL83oAnLFaSR97WOLq
	 Iqn7j/CU6XUQXZ3NlL9OXIcH1oHACOOQNVjmtVxBCTR52SGJNAJfuduxAQAXNWyEop
	 WNh6CAjHv1IJb/yjIV6kGG3qBjZVS8CLKw/sBzhx58UZl+nsZ8v612XCw0DMwWZ9Tc
	 z4KprcF/Xk9QYITqiwbsYI0anu3m3fMa5MqtW3Th0ALohvxTCvUEjyAGNWijlXDLX1
	 aWEXB0pyOu6vA==
To: Laurence Oberman <loberman@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,  Haiyang Zhang
 <haiyangz@microsoft.com>,  Wei Liu <wei.liu@kernel.org>,  Dexuan Cui
 <decui@microsoft.com>,  Long Li <longli@microsoft.com>,  "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <martin.petersen@oracle.com>,  linux-hyperv@vger.kernel.org,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: storvsc: Support manual scans for all Hyper-V
 targets
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260723163743.1274830-1-loberman@redhat.com> (Laurence
	Oberman's message of "Thu, 23 Jul 2026 12:37:43 -0400")
Message-ID: <yq18q6h3kol.fsf@mail.kernel.org>
References: <20260723163743.1274830-1-loberman@redhat.com>
Date: Fri, 07 Aug 2026 13:28:24 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Laurence,

> The Fibre Channel transport topology created by storvsc exposes only
> one dummy remote port per SCSI host. Its scsi_target_id is always
> zero.
>
> As a result, the FC transport user-scan path looks up the remote port
> using target ID 0. It cannot initiate a scan for Target 1 or higher.
> No SCSI command is therefore sent to Hyper-V when userspace explicitly
> requests a scan of one of these targets.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
