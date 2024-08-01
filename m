Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06891C230A;
	Thu,  1 Aug 2024 00:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722471431; cv=none; b=EcvEbJnWPaTWEqQZjuVovxa5NxodKakcjHg3jaUC/i7qKjTe+ER3uQGxrWnpNxzgBIWeQbTQftdVh1wW76ivfefMy8QMqsWtIh85TQdsUMCypxUaYyhfpW+5NDD5DwukKJaHvlWHVBSiPXl6sGMcR1vGGRTJzDWh7qoDMsE0Zc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722471431; c=relaxed/simple;
	bh=CNNF/6ywk2hpMzWfvqOQwk8sZAMv5WzoKzHP9LesKEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRzyf3sC04NuWT4pkMklMtxcaumBAoRVZ6/8lm8Xcm7fQLka5+vy4Rn1zdlZ1p0QguLrMBu+uQrub9ybpXW1f2Hl9Y1WpPuX51N+31JcudeU3Zu9QafvzkDyy3q9CJC8U7FysTxLMLYN3DZTpPy/unI48gsVd8xxanZXao1ARpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8e5OJzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8e5OJzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4C2C116B1;
	Thu,  1 Aug 2024 00:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722471431;
	bh=CNNF/6ywk2hpMzWfvqOQwk8sZAMv5WzoKzHP9LesKEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8e5OJzIPB2pIQNg/GSCi4O6xQSoEwQWT/gdvyu/Ng9yPkO/2sSPUVuH5k71vFo9t
	 UIx+8uU2cinWnA0f8ZBwXuvuqw6Oggv22t6boaUDkNsisMP8UekM51aToj39XsI0bj
	 K2N6s0dpl0/ontZtprQF1EkP/u7pTE/jBOxkkfdXBtZYhFcbo/zlhGKI1lelIlcu4q
	 Dawpr5L/fhAcr48CC0ECkqdkzIK7Hy5bGSBI8T4wyzzoPK8x6ZvLKsafQfQTVZ00dT
	 E3dJztFEEBLDa9rA8wwosU3s4bSJiQVFm6PxkpG3ZOiXMJhvlfvtaKNnJtA/t/WUEW
	 7pcJAx9VNK6mQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Shantanu Goel <sgoel01@yahoo.com>,
	Oliver Neukum <oneukum@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stern@rowland.harvard.edu,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH AUTOSEL 6.10 096/121] usb: uas: set host status byte on data completion error
Date: Wed, 31 Jul 2024 20:00:34 -0400
Message-ID: <20240801000834.3930818-96-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240801000834.3930818-1-sashal@kernel.org>
References: <20240801000834.3930818-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.2
Content-Transfer-Encoding: 8bit

From: Shantanu Goel <sgoel01@yahoo.com>

[ Upstream commit 9d32685a251a754f1823d287df233716aa23bcb9 ]

Set the host status byte when a data completion error is encountered
otherwise the upper layer may end up using the invalid zero'ed data.
The following output was observed from scsi/sd.c prior to this fix.

[   11.872824] sd 0:0:0:1: [sdf] tag#9 data cmplt err -75 uas-tag 1 inflight:
[   11.872826] sd 0:0:0:1: [sdf] tag#9 CDB: Read capacity(16) 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
[   11.872830] sd 0:0:0:1: [sdf] Sector size 0 reported, assuming 512.

Signed-off-by: Shantanu Goel <sgoel01@yahoo.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/87msnx4ec6.fsf@yahoo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/uas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index b610a2de4ae5d..a04b4cb1382d5 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -423,6 +423,7 @@ static void uas_data_cmplt(struct urb *urb)
 			uas_log_cmd_state(cmnd, "data cmplt err", status);
 		/* error: no data transfered */
 		scsi_set_resid(cmnd, sdb->length);
+		set_host_byte(cmnd, DID_ERROR);
 	} else {
 		scsi_set_resid(cmnd, sdb->length - urb->actual_length);
 	}
-- 
2.43.0

