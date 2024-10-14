Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372D814B07E;
	Mon, 14 Oct 2024 03:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728878268; cv=none; b=rFqriDIwucB5qnswqJ14MYUCJ5tRC9fSoo2oltA2BHGVJK45USJ+1JL4mn/QqrvWTctuojbS2Y/W7x4E7d3VbfQvGCyuzzNA0ToRmFSU7JaB6ACFQnZSMA5OdwxIoeRS+4Fs3taGr7ep7vdoP/LEUJ2ov1RUC6vGczPbtmqH62w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728878268; c=relaxed/simple;
	bh=NEEkY98w0pFFlClByTlCUIwPBmxrmJYqgH0qvjRWjjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NssPmVOWiHoqBI/AJ1JCq+lrhD3df92RlTgzmf2XJtbWedAZemJz6YpDfQJz8rWNk8cItAWribUVZOAniHd+uxN6G694HGU3NhqdbpkKO3bOlw77dLdS34Fe2TtgxoXfsqGFGnFuTnRHOWJpn1asXmi0i7SNhyxmNlnHla7YmDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igVl9oq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igVl9oq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184BAC4CECE;
	Mon, 14 Oct 2024 03:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728878268;
	bh=NEEkY98w0pFFlClByTlCUIwPBmxrmJYqgH0qvjRWjjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igVl9oq23VfR3otDyVyHickSLVYvEbcOO/XDhG6Ph+I9z6H1ZcrEy0oCxzen5x0Fq
	 /LiC487t9370Mn+tUOCYINsI32atbRaZTv6bxN1ZkFdqWxbXPK1wDviOkeC3EhytMV
	 IQkJ5s/Qu2RNkTmL06juqgqE3v7uecxLpzNFSxMahWlNh52ZzkdILZPs5qHoYDMvrl
	 ai5rnHvmJ8IziesVpUlVrUvJCmEIDoJo+G5ULGUKcj5W5wFNcP12bG+1zR7q2M2rip
	 wLY5IJAtqXSN9CpO5yALoYe+C/hOKmzkwkerupAEju6MhsSw9X/2bousBp//IJUdbd
	 zaPU7oVO6DcRQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 11/20] scsi: scsi_transport_fc: Allow setting rport state to current state
Date: Sun, 13 Oct 2024 23:57:13 -0400
Message-ID: <20241014035731.2246632-11-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241014035731.2246632-1-sashal@kernel.org>
References: <20241014035731.2246632-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.3
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
index 7d088b8da0757..2270732b353c8 100644
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

