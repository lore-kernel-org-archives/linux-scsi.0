Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D512ED154;
	Wed, 16 Sep 2026 01:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789523563; cv=none; b=a3xjYPml1/7gq+SIAdKvD/eHqjlkjWueWao0Y8lGitAs7SPHQkDckx9RHyLTe2CJ2QCnqW1LSGk+N19YE4OHVaezp0C7GwXkONH+XdQ/EcUn2ZWno8MfsjQfKiDiiD22V3+0grCJaV2zX3PQzUWDFiaT6UedJ60kl+tyl/FH9I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789523563; c=relaxed/simple;
	bh=bVaHqG5lfW5gRf1Q4yy2wzQYNJDGHKKPJrCwDKYaBIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQmSTN3+rU/x8waeF6x5KuJW2kGWJqgvy9BYGJhRVGkthPch+MQtpkqoVa4pq+NlgjEGQvtt4L2Fd3OjCXMUyJyurXaj/zMcrPW8alXtO5JTmVO6lygvub28DPVa3Bqirid4sOXbmdU6L0iY9N0jlZpLl4uLE6OVU5LMAFPdEMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYfwRlMz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYfwRlMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FFF1F0089A;
	Wed, 16 Sep 2026 01:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789523545;
	bh=3+14Ha0wjNy8ghL4gXJPO7+O/WPEKrs1JUa9a23YT+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYfwRlMzZBonbOKJFi+lRvVJYYSSynJyaq0BIm8HarUHeSfCYllCjcaqiKJxvdd0y
	 4LdxQj7Y2JiooWMV68syUYj8uSQliTyJKbUiex3e/heK+iLGr6mnUo+dmYVOaOd7TF
	 M215rKjMbSc6IpMQhZ8ueG7H51YuJjsfdmnAMEjQYWZjWZWRBAjgqGvY6mq3n1BPY0
	 vcMkdV4893SJpGX0mse6M3DytT11t8/Q8zzkOcqVk1ZAC4teJbokP010KFUtdyf+zQ
	 UVzKuhBrEd6B5og4SfbSweNCI+yVbj0CCZiTRD9RHvNPabzmk5KZuyfaoj3M+pTlio
	 6O4/BM8I/hLVA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	mlombard@redhat.com,
	martin.petersen@oracle.com,
	loberman@redhat.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	jonatan.rueda@ggcircuit.com,
	jacob.pitcher@ggcircuit.com,
	Dmitriy Polomoshnov <dmitriy.polomoshnov@ggcircuit.com>
Subject: Re: [PATCH 6.1.y] scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands
Date: Tue, 15 Sep 2026 21:52:08 -0400
Message-ID: <daily-reply-20260915-0003-re-iscsi-write-pending-hang@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260915091456.8-1-dmitriy.polomoshnov@ggcircuit.com>
References: <20260915091456.8-1-dmitriy.polomoshnov@ggcircuit.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ dpolomoshnov: 6.1 does not reach the target_complete_cmd() declaration
>   through the headers iscsi_target.c already includes, so a straight
>   cherry-pick fails to build with "implicit declaration of function
>   'target_complete_cmd'". Added the target_core_backend.h include.
>   No other change from upstream. ]

I went the other way on the older trees and took ea87981a0ee8 ("scsi:
target: iscsi: Handle abort for WRITE_PENDING cmds") on 6.1, 5.15 and
5.10 first, which brings that include with it. d5869dae5080 ("scsi:
target: iscsi: Fix hang for aborted WRITE_PENDING commands") then goes in
unmodified on every tree, which is what I prefer when the option exists.

Queued for 7.2, 6.18, 6.12, 6.6, 6.1, 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
