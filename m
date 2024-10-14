Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6197116A930;
	Mon, 14 Oct 2024 03:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728878309; cv=none; b=taCaCrpkF2U7BRzN9TgpZG43eY8yAS2voYlSotvzAr8/5JW+Tj3uql2jCorkfhjOHH1pdLOc2AFoSm3q1i9Hdn5o/jc+kKyfSruBDysEQpacxaLFFe9L3zAmrePs+miSuAZg62mcU4FgmMOBbfaa2CkNbmKrx0FBblf9ySjUiHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728878309; c=relaxed/simple;
	bh=ny82F8t43LdFhEOSX2/eHM9nqMS9cmLErClqBBpRx3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZTq1XJWYvfNh9+oraQb8lOwT7EwEjxijm9pdbwyTw+iJ18WXH/sir2gx5znj04iNzLFz5DzlW2PNFVhlPoIjs8lSZwTOonMDMgfoPk+lhrPmEE1aT+GMOisDf14O5wVnJ/4IedjYvUaO28Piog3dxcn6bJ5jyXWhww6Jp11QQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EdBQYj0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EdBQYj0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A681C4CECF;
	Mon, 14 Oct 2024 03:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728878309;
	bh=ny82F8t43LdFhEOSX2/eHM9nqMS9cmLErClqBBpRx3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdBQYj0bRJzOqNvd279cwd1QR0F/YXC+trSs+WLlP3ygHKfZo1q/rSQ1FNL6N/ZNB
	 g6/1qgrNuwyeOwxlGZbeGFygZHNBA+uEcFZa+p1ZzQiSpSH0zqp4jj3OulKRL870jn
	 fAo8XznARXfdVHpX11PLEjuHSzzAvgHZLVJooLFXUJzVselEmt9Er0oozGNDOnioGW
	 ekd75FoevQviOdzngYwSpErPQex6POewns5IT7khLQRW10jagdj60F1tK5J5WWdP7e
	 aH37PloJDuxQINkNxPa9ucgSorsmpt2tMJxuqljwdWQvLFZtEEARgNUJO7XbuomaoA
	 T4hLj6Mt7lO9Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 10/17] scsi: scsi_transport_fc: Allow setting rport state to current state
Date: Sun, 13 Oct 2024 23:58:00 -0400
Message-ID: <20241014035815.2247153-10-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241014035815.2247153-1-sashal@kernel.org>
References: <20241014035815.2247153-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.56
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
index b04075f19445d..96002966ca568 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1255,7 +1255,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
 		 */
 		if (rport->port_state == FC_PORTSTATE_ONLINE)
 			rport->port_state = port_state;
-		else
+		else if (port_state != rport->port_state)
 			return -EINVAL;
 	} else if (port_state == FC_PORTSTATE_ONLINE) {
 		/*
@@ -1265,7 +1265,7 @@ static ssize_t fc_rport_set_marginal_state(struct device *dev,
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

