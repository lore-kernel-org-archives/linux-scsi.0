Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC56328610;
	Fri,  9 Oct 2026 17:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791565820; cv=none; b=jNDo/2A93V4ICtr8ORKpaW25BlO4uXSstup/qQklaCg6BCdD0SAbYQ3B11y3uryusXHuZHDMopgBhUgyGDQBWpNT9ViNwJQKZUUBJFbbhOegmwJUU1DwIYbWWtREIfXt+0Y9Yx44s6p2VYBh0lfQiXVLCTGWSNK5prNS/w9V6/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791565820; c=relaxed/simple;
	bh=s559eTZ9uAjbv3bPZRktwrs9pw/DNnzQrfHoHcbyaKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0x8rM98TTEJY4lFdmnzJan0F2mLtJYzdQlC4sNe6+M9Tx9k2aJslGnM5d0c3uo7kUH2Wc49nc1EIQ8ebx1Y2SQWXkgRclRKfQEMCFJ9UoA9k4v5U/DTwb/iUC2qHIScYV3Rg0v7eWeGPndRtshZ5LtWRs5B/8o+afRHqsyG2AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5ZvPIxq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5ZvPIxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC26B1F00893;
	Fri,  9 Oct 2026 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565818;
	bh=5Hed5PUQ900tHJ6z7YhDO82LmcseIk88ESypAmjYeYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5ZvPIxqvHGEkStxr+zF3o8eEZbr29KvlzFKADDPer26LKg+rbee8rdS0qrgz7GFa
	 LxkrutPY0KdMAOF+p8G5ODQDkY6n/+bzQgkOlAHVrwplTZShUHg9QKcognPtQIJtG+
	 kHz3qM967HxXAAcNITZ1hZHJiETsHvgdEs3tlaRNslE6RhhaOF4MxCSvxeZbKwjoZf
	 efE61LkgcbeHYEYa0YfEdJjVOigjPpZpt/XCytuXqpjjwECEwRNN73TkL0TdJ8rZIg
	 klKrjc9+kjDF8WCmWFNJmnd2XY4i7j5r/gz5mI+NIkr1hO1EQHpsFgV69bgLAu3H3k
	 mwmsou9yBMqpA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	justin.tee@broadcom.com,
	paul.ely@broadcom.com,
	martin.petersen@oracle.com,
	nihaal@cse.iitm.ac.in,
	linux-scsi@vger.kernel.org,
	Andrey Misiurov <andrey.misyrov@gmail.com>
Subject: Re: [PATCH 6.1.y] scsi: lpfc: Fix use-after-free of mboxq in lpfc_sli4_driver_resource_setup()
Date: Fri,  9 Oct 2026 13:09:43 -0400
Message-ID: <2026-10-09-1-daily-reply-0006-lpfc-mboxq-uaf-6-1-holding@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261008184328.2857037-1-andrey.misyrov@gmail.com>
References: <20261008184328.2857037-1-andrey.misyrov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Move the mempool_free() to where upstream and the other stable trees
> have it.

Thanks for the fix. Ideally a maintainer could ack it.

-- 
Thanks,
Sasha
