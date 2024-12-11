Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D77525332C;
	Wed, 11 Dec 2024 18:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943241; cv=none; b=iPERsQb2cX8W422K1qWo+SwPB5pmW8XdAbhWrE/dWR4QXQskZYLoKGu8PlgTr+0EogUWHa5MCwZB+x8TrBcARQuPpnGt66/o6bQWdc6EzgAR+7wkjGAlxS9eCAIU71sZi1j86bmMDdQITp9eZkVIHDqiSlFI+HBW+tEuS1N6qfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943241; c=relaxed/simple;
	bh=dyq+J/DiRwkJNI5kNhY9+KmAQLHJejisWtCM0XFxWrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s10ck3/obNG/coxBX9sX0L5dCX3vxJIzaoECTDM9fQu3bgNS2a0j2swsMQSnb4YhbQuIcFzVl6PwU4YvjYSe11aKZ3/undhNIj8RRmn2SRGsnHvjNUajxkjHxO8HuBa042cuhPSYUfzUhgezH3Wg1pgbeOJeZ5oza004EeeVBaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IgLvKu2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IgLvKu2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7AEC4CEDD;
	Wed, 11 Dec 2024 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943241;
	bh=dyq+J/DiRwkJNI5kNhY9+KmAQLHJejisWtCM0XFxWrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgLvKu2OgtolJfxth7FJFnxsXJ18etxwi01Gt5383RhHDxtY5t7xakNUj9QDHAdPO
	 mPg2PBQZCHq0Iq5M2fu2NQ2Nwv0P7tb5LV3SzZxahQDyC7FtECC9RWrU1r4/gRNkAX
	 v2hC5CqVpd2AuMM1+80LMyqPPp7K3nK/eyHKGbt7kN/tp6HMpMSxehr94Pt6X0/HU3
	 BIZLAf+9VYSMJbaHqX5hjXYvJWf01I6eCC5CFhuTP2MVOxvsTGRseGn0gtoSqxQ5sm
	 RoNpIPmHu0taMSQsuEGS0AboOrtIWeoKwOUYHXo6e0IA+118vRSo34w16PDvXR04oe
	 gv+wRr/cM9x7g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Tomas Henzl <thenzl@redhat.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/10] scsi: megaraid_sas: Fix for a potential deadlock
Date: Wed, 11 Dec 2024 13:53:44 -0500
Message-ID: <20241211185355.3842902-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185355.3842902-1-sashal@kernel.org>
References: <20241211185355.3842902-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.173
Content-Transfer-Encoding: 8bit

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 50740f4dc78b41dec7c8e39772619d5ba841ddd7 ]

This fixes a 'possible circular locking dependency detected' warning
      CPU0                    CPU1
      ----                    ----
 lock(&instance->reset_mutex);
                              lock(&shost->scan_mutex);
                              lock(&instance->reset_mutex);
 lock(&shost->scan_mutex);

Fix this by temporarily releasing the reset_mutex.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20240923174833.45345-1-thenzl@redhat.com
Acked-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c2c247a49ce9b..09bb8fe575e36 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8922,8 +8922,11 @@ megasas_aen_polling(struct work_struct *work)
 						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
 						   (ld_target_id - MEGASAS_MAX_DEV_PER_CHANNEL),
 						   0);
-			if (sdev1)
+			if (sdev1) {
+				mutex_unlock(&instance->reset_mutex);
 				megasas_remove_scsi_device(sdev1);
+				mutex_lock(&instance->reset_mutex);
+			}
 
 			event_type = SCAN_VD_CHANNEL;
 			break;
-- 
2.43.0

