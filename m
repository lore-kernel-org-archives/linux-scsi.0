Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1192B1A7062;
	Mon, 14 Oct 2024 03:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728878338; cv=none; b=i6mMaaXQrMkJd6jerzx0mZag9R18PnTSbvOTU9T/DfYcQyomdl+LCGbuouBowJxKWzsZCnKNQ0ZLR26Us7Fj0DPRxd13WywOx++9pHDbMj8yggvBIhK6NAnneQXoRwEVKRjHP1Z9NaJKRElOI+7dqxTIGa2vGu3xS9V5HHkIMVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728878338; c=relaxed/simple;
	bh=EEwQJM6UjH6LfciOUNPLG6CzjG0L+/ES9mq8B59X8bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPBf3jQwm5DUFuny7fG8BmI8bjDFCIlAe9xBBLOg6cvLHH/P2VXEvo86umiMrUJuc07yhrA0sFeYzV8K6QoUM253Lz+va1G21gvRikg8v8A3cW830WZVTB8CSQqO9iX7e9XwQUNuvkv7pcs66vXJc6tC5BuGtbC/tc2Cq0+o/OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ADpDTbrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ADpDTbrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D19C4CEC3;
	Mon, 14 Oct 2024 03:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728878337;
	bh=EEwQJM6UjH6LfciOUNPLG6CzjG0L+/ES9mq8B59X8bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADpDTbrf4AS2zDz1GwvqnfFCEn//A3GvUZ8BUdZMxmApnIov9St2dYiMw/XFpP+yV
	 LSaR/sMYTNY/IKIpJ2LcEoZFOE3J99vg8PAiwpU7J7RyUVdwmJO0rD7sj85UthWN1y
	 y0FTxX6HLctFMVKifGj/QCZUyR/oJewxdthNDpHzmIjLvE28dJ+k46kRphQJrRbxqK
	 kCn8vYpuiom49NttpJoKx8GoMNESGVJVmARMRPjQZ0Z3Z3Go4g7Yc6QJfnSW5OXnLj
	 U2uOqkPKIYstoc3Ydwg9uLvsqDRD5UTcNsvrkZQKDg9CpZ6PXyLV9m1TDsVyO8Id93
	 9kj4EvL0pPubA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 06/10] scsi: scsi_transport_fc: Allow setting rport state to current state
Date: Sun, 13 Oct 2024 23:58:41 -0400
Message-ID: <20241014035848.2247549-6-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241014035848.2247549-1-sashal@kernel.org>
References: <20241014035848.2247549-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.112
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
index 8934160c4a33b..1aaeb0ead7a71 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1252,7 +1252,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 		 */
 		if (rport->port_state == FC_PORTSTATE_ONLINE)
 			rport->port_state = port_state;
-		else
+		else if (port_state != rport->port_state)
 			return -EINVAL;
 	} else if (port_state == FC_PORTSTATE_ONLINE) {
 		/*
@@ -1262,7 +1262,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
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

