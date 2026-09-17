Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7053932D4;
	Thu, 17 Sep 2026 02:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612136; cv=none; b=pqMt5G8ysttIRU7XY6mDfjunlie1MikkplMCbBe8+GP6a/GFEEmn4cgLs8pchMR82Q1+XRqHsxncdblnCcdW4vISP73/cVrjukdQQYVD+5z1+OpvLQD2/RD4R2F7eUt39tJkeSQkmE3ybchHj6IWd0NOMXDo19FDK0BCuzLtyxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612136; c=relaxed/simple;
	bh=NL6yxE/O7YW6mC8w5oTQzUiNz5Lqsvc4kPzEpOeztcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I5ZSheJLLw5z3Log6AvMm420A61NAiK/ZD/Et+iEKKFZjrRXbIAGctPRJreCXc8AFt20j8p6C+tNwRtWEG5FZSiVdjGvbtN6e7CvvhqEHJgrQ3PAm8VAbVXbDeiRU5kVVcv+Lrcg+VEHdcqrZOhs2DiIm1+9E+/qOIGTXVzhlGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqYGnizp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqYGnizp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC991F00898;
	Thu, 17 Sep 2026 02:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612121;
	bh=CMua3TyWlvr3nWYiarskUz8W5kiV577yocMbTDBqi+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bqYGnizpXYyRIPZBc6DA30+Wa3mJUoTuiaTLfDu95Bf8rZuRO0JQOMnFwyfU3BGb7
	 nCVMRBOAclRBKp7Kyy0cs6MltkFkAybaB4u1vybB5mUTqLrLikBZrZh/sKLG72dT+n
	 zDTC8+C7WuyTi/yDvxjfOGdzl4v9T3nGLqrlZuKa2laBDwMrDwoploY/0MhN5x7DHk
	 A3ItbJNvvm3TYSMWuSFPTHb3yHtylggJLJ7Z17z0xY3w8wa+tJ/e1yv3QWHhHE2fci
	 IXsKdrrVfZwzHuOTpVvY+bfvi8IrycevIMKkmUoYRIlEprGZW/CcM3dAaj38s7PO+2
	 VAxnBjUUuMVDA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: James.Bottomley@HansenPartnership.com,
	tyreld@linux.ibm.com,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pavrampu@linux.ibm.com,
	brking@linux.ibm.com,
	davemarq@linux.ibm.com,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] scsi: ibmvfc: Add Kconfig dependency to fix link failure when NVME_FC=m
Date: Wed, 16 Sep 2026 22:28:22 -0400
Message-ID: <178961190577.3672510.9039790246882718532.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903074329.6705-1-venkat88@linux.ibm.com>
References: <20260903074329.6705-1-venkat88@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 03 Sep 2026 13:13:29 +0530, Venkat Rao Bagalkote wrote:

> Building with CONFIG_SCSI_IBMVFC=y and CONFIG_NVME_FC=m results in a
> link failure:
> 
>   ibmvfc-nvme.o: undefined reference to `nvme_fc_register_localport'
>   ibmvfc-nvme.o: undefined reference to `nvme_fc_register_remoteport'
>   ibmvfc-nvme.o: undefined reference to `nvme_fc_unregister_localport'
>   ibmvfc-nvme.o: undefined reference to `nvme_fc_unregister_remoteport'
>   ibmvfc-core.o: undefined reference to `nvme_fc_rescan_remoteport'
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: ibmvfc: Add Kconfig dependency to fix link failure when NVME_FC=m
      https://git.kernel.org/mkp/scsi/c/1274045b0eda

-- 
Martin K. Petersen
