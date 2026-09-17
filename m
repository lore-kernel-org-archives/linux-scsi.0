Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA2E3921C8
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 02:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612119; cv=none; b=DleRr95iJ67jKnxSJnWNyuBCiH1Vlw0cp9Bz8avvc/6TqoZw1uQn9Op1Q5rCOesN+7q0eH+kipSvDKBdFwLT0ABDGvxfXP1JwLPsADupwiufqgLdF7/mbPJX6vaiZC64kX4SbGKnTKOylzwu22w1LN2tQxh2e+/512NrscTOsrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612119; c=relaxed/simple;
	bh=sAyun5VAQQI0vvxMOhdcSrpBCB+0IrIenm9LrrFw4Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdghIdvCmZKa2ZaWORbwzot1kB4yU3+V+PtGNqbWZRAXgrJpbEHP62i7m4uQ7f5z1bFB2jZb+g+UHfy2e4XFhZ1BmHPdFIBZWu7uuKXU85t+lWQeyIipLPCYCuDu2RN4Qf0jR55GRu7i2F9yx7xRA1IxC8MJiLRWYhpWVIV9Jjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eeUq2uMk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eeUq2uMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9FA1F0089B;
	Thu, 17 Sep 2026 02:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612114;
	bh=RguZCz1EsMEN6rCKB1NUfXv5ocdYz3x8qkPAgooCIeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeUq2uMkej/Bv0dRwWPImdaKKqNN6xBu3KKeND17tRPUrriRY/R4TFU+nZWMeH1eA
	 SZeAKyHOTkdxeIoSfJ3kSt9m9cOfbMw+wqNzBC5bQaIOYbHowTp8SMheb9Fk4OieHF
	 Y2T7ZSbi4/orUAJEL0bZmCOv8n3WaDtOCnHIotuop1e/A6GgK1lRJz32pMUiPhx1nK
	 +sD8E1RCL+S+m+frPbzYD9AEQJOwKTIpo40YapIqQv4dN6x89PwGkVd6/vxmh7eriI
	 qV46Ww7G49ZXxgPddh4bw+CGGFHHTWGtyyqXDyFqSMqfOoe45XB1hnRRYRLiMUctmZ
	 uUZHrkL1RBo8g==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Ewan D. Milne" <emilne@redhat.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>
Subject: Re: [PATCH] scsi: devinfo: add BLIST_SKIP_IO_HINTS for EMC Symmetrix
Date: Wed, 16 Sep 2026 22:28:16 -0400
Message-ID: <178961190600.3672510.13129632944035702697.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915173800.39117-1-emilne@redhat.com>
References: <20260915173800.39117-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 15 Sep 2026 13:38:00 -0400, Ewan D. Milne wrote:

> EMC Symmetrix returns an error on MODE SENSE for page 0Ah subpage 05h
> because it does not implement the SBC-5 I/O hints.  These commands
> began to be sent as a result of commit 4f53138fffc2 ("scsi: sd: Translate
> data lifetime information").  Add BLIST_SKIP_IO_HINTS to avoid sending
> these commands because in large configurations the failed commands are
> displacing other useful information in internal error logs.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: devinfo: add BLIST_SKIP_IO_HINTS for EMC Symmetrix
      https://git.kernel.org/mkp/scsi/c/f06a44e235ef

-- 
Martin K. Petersen
