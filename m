Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03B51A99F0;
	Thu,  1 Aug 2024 00:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722472803; cv=none; b=hp5waDIG8NzKPWfDTke9gghYPRfRcRnKLOEma8EkuEWIWpOIO7E/auHTvQ9zK0C+4brv55yOrhnVJ05xJxbd7qQYoLkAwQAqRkrpmVPkX8ksXGthMSty5ea1jB7LYWG2T21eLNBp8NoOk0sm8hcLfD8aRFVf5xANVf4X/0EHSKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722472803; c=relaxed/simple;
	bh=1S5xV8iSrC7tAFZ1yMI39/6iucFfVsril84naCHv+MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqDYS/MEPaHVnsP4yfIrTYdj3J5gZbSqXJwbKXzJcLo0JMexvjwtkDVcytpN+oql9P0FgV3W5IvdFX86N6E13LVPiqvLDowyEtk07wamA3oKVXdOVIt3q2BhU0dJligrCID4rLsMgE7Ng4iF2C+HqtcikNvzWeD93k8vrBGqZZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9tD8yLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9tD8yLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3175BC32786;
	Thu,  1 Aug 2024 00:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722472803;
	bh=1S5xV8iSrC7tAFZ1yMI39/6iucFfVsril84naCHv+MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9tD8yLUClW8bhf4NdLox3CtxJJksYSXeYtD8aDeR2wTwuzmKizCMtY+/3F/6YNy2
	 U8woV3BwpwHogxtTDQ0s6TXlbzdjQV9tLRHhbepxQuLOH2I7CYwHj6A39BXh7YLUvb
	 Gx+snwTPpdzKiK/1fnpBnd2Fu0Hmcr2BU1pgZFO6EeKNGm3gNy9L6KyLnaeCMG/a7R
	 UuiWVWMSpp+gd1K18K2OArCluwVv8g/8TKtg88wrFjvpIGzCgWyyu9+wwQpLWi9jxD
	 Pa7KjWaugxYcUrOBZKkTfTitjEDpRJ56Jnxjn6xyHjQxpeAtjqAIzKgemmVOWh52hw
	 pa0kNgvCaEYDw==
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
Subject: [PATCH AUTOSEL 5.4 14/22] usb: uas: set host status byte on data completion error
Date: Wed, 31 Jul 2024 20:38:43 -0400
Message-ID: <20240801003918.3939431-14-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240801003918.3939431-1-sashal@kernel.org>
References: <20240801003918.3939431-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.281
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
index 678903d1ce4da..7493b4d9d1f58 100644
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

