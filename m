Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D961AC447;
	Mon, 14 Oct 2024 03:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728878376; cv=none; b=uef3re3O6hHvKZpXlReJf8/ntLmwUxdy1oQUqw+WATjnHzXDbLF6GCeypINquuNV/FzUsjBIQcuznriC9XfI9FhpBEQYNVhq8zIRX2yqZpuveF+4UmvF3U40WssB1tEQLkA+30xN+cS90N9GrKYKecdMD9p+KXOa05EBlaIUSzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728878376; c=relaxed/simple;
	bh=g8AetLH79B5fPkJJF4pxvsjmYZo9Ky8r2/DSJdac7MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+5b/cnaGeum7jx9f1EwXS3OJZHPp8Br7TVnVGwJg5Tuirq//uo0ddKhN00XXT10p6p/XcUtxRJ1g6bLvhzK0JihKypU7ZLdkQZsR223SPrbnbndn53um7hcim78wgMdEeVfLl2BWuXl4d3+z8yWQwrv7p3d/dFswt1jSmerYjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dgSfikMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dgSfikMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0C5C4CECF;
	Mon, 14 Oct 2024 03:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728878376;
	bh=g8AetLH79B5fPkJJF4pxvsjmYZo9Ky8r2/DSJdac7MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgSfikMlXmjTYFPxrjXY2D3opT+sVK5TXw6Rz0/nWNpgtTzIR11ofCcQGnFK/pVeZ
	 JFlxZP9UDjL/TDdHKYqQqb75MtluYwB9kTs8jyXPgaEvH5doIXdZRvtFzYkO+IzHw1
	 DrOe/xjmjdLCU+4XiupT6Mz153L/z1p9sDRtL7xIbd4xSsF+bse18DHcZKA0TZllok
	 OCqs/IwLmKCpQfwJxEO1aT6JXAdDUTZsysM+MxgE41xejCcjFcsck1OAnV6RtVviDv
	 Iygbw6ZtHOvEuLotvR3of9LmN9RSqsjQZ6wj8G30dJwXs2no4sEH84VsAYSBBNsQaS
	 HJTUbnO7XgwVQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 5/8] scsi: scsi_transport_fc: Allow setting rport state to current state
Date: Sun, 13 Oct 2024 23:59:20 -0400
Message-ID: <20241014035929.2251266-5-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241014035929.2251266-1-sashal@kernel.org>
References: <20241014035929.2251266-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.167
Content-Transfer-Encoding: 8bit

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit d539a871ae47a1f27a609a62e06093fa69d7ce99 ]

The only input fc_rport_set_marginal_state() currently accepts is
"Marginal" when port_state is "Online", and "Online" when the port_state
is "Marginal". It should also allow setting port_state to its current
state, either "Marginal or "Online".

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Link: https://lore.kernel.org/r/20240917230643.966768-1-bmarzins@redhat.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_fc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index a2524106206db..fbe2036ca6196 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1250,7 +1250,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 		 */
 		if (rport->port_state == FC_PORTSTATE_ONLINE)
 			rport->port_state = port_state;
-		else
+		else if (port_state != rport->port_state)
 			return -EINVAL;
 	} else if (port_state == FC_PORTSTATE_ONLINE) {
 		/*
@@ -1260,7 +1260,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 		 */
 		if (rport->port_state == FC_PORTSTATE_MARGINAL)
 			rport->port_state = port_state;
-		else
+		else if (port_state != rport->port_state)
 			return -EINVAL;
 	} else
 		return -EINVAL;
-- 
2.43.0

