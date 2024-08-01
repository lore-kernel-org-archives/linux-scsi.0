Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0211E3CAA;
	Thu,  1 Aug 2024 00:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722472714; cv=none; b=GHa8YU4ajr2l6MEtCAWqUr0zB4IpCbA7Q7Khe87W0bQJNp3pyh5n5dT+ZP4rVBZNIS9wYJO9EqQzUw6cvDMujP1mJr5QB7/2Xm7tYypDPLe5JZLlQpvPKmAbmlO9tsW7vex3YncQdSVTTiiUROZo6ietcGORctwEJwrPBUMqEOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722472714; c=relaxed/simple;
	bh=VJolDZfVtPLBOBkEyWqu07UH6tU3pqiYF5mWBFg916o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZJyum1wqbN5LKN2KBO3d7P8vQvz8LMFkitSalPQ42KgfxdQUrS24oNhS+y69hbBwjzEz64HsQ8yj7TjV06Di+Ls7okVaWPhP/w2dCESX6EW/K9MiUjr2H8lMuqDJWpMsxUxgT1bOg3nnZfjXrwOR6urE+APfYwlT5VCmEa5FAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2dbc+/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2dbc+/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C12FC32786;
	Thu,  1 Aug 2024 00:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722472714;
	bh=VJolDZfVtPLBOBkEyWqu07UH6tU3pqiYF5mWBFg916o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2dbc+/gbDcrRL/sJ4F6HU4HyHKpRu+rkR2dcuWN5ehR9RtguL6+L3YJCs0SjXibk
	 IdYIDAyDrPEu6aR6etECFKITyH0+y+LDbpwXsrnHVBAHh0DDTCXuxzcEUJfreB80Gr
	 wV5H7ZdumNJ95pS6G/1Ck1aljZZWtbskIsaEHKyS2P4uXXc6pyb95SFPL7PNomjB0r
	 3hKcdF+1DnOlHuSwGsMYU0w5Zoc7254H/gX3r4TAuQEpIDJtbPYXkmzufQjwq9HyLh
	 +vdffUcqZ8RM9xoMrRBjcAPhn6toFUF4eFa7XVLkH4IxC+7AWMIjtx3hFSil6f0Dp9
	 WA/0/Kl3B/8Cw==
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
Subject: [PATCH AUTOSEL 5.10 30/38] usb: uas: set host status byte on data completion error
Date: Wed, 31 Jul 2024 20:35:36 -0400
Message-ID: <20240801003643.3938534-30-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240801003643.3938534-1-sashal@kernel.org>
References: <20240801003643.3938534-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.223
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
index ff6f41e7e0683..ea1680c4cc065 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -424,6 +424,7 @@ static void uas_data_cmplt(struct urb *urb)
 			uas_log_cmd_state(cmnd, "data cmplt err", status);
 		/* error: no data transfered */
 		scsi_set_resid(cmnd, sdb->length);
+		set_host_byte(cmnd, DID_ERROR);
 	} else {
 		scsi_set_resid(cmnd, sdb->length - urb->actual_length);
 	}
-- 
2.43.0

