Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73BE1DD392;
	Thu,  1 Aug 2024 00:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722472517; cv=none; b=A+RLIMH8U+Br95P3+zWjUnKbJZgFTTqjHwULlmhfclycCtKpIoC986edbk2CQrifYM2uO9KbTUscX+yUH/CbHWQ6BGDfuqzLG13tv1MMNNc/RbzxdfvdUs3DFb7VahjL+AsWfK6ZbcB4KG7ZniduCfqtIm/PtGtVLYiwC5Jg9tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722472517; c=relaxed/simple;
	bh=5zfISgYw25AJ/G+BhlY8037e8UEmkJsLaeb/tdlBl2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkncWGuT8c8zXGQ7JzdbhYnkS7UffOvaaGLJOzv/JZegl0e5slxoiYO1pSia+XhysVv1uy7iUE4LWo0l3a+T6qQVyf1JiWUBOVzVMBRZWKTjPevMcIhVIRiy6CYnlyYm/h5JVJchypMPS6sdpYIbrknUDV2v84+Rvf977O+homc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qac840hd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qac840hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2809EC116B1;
	Thu,  1 Aug 2024 00:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722472517;
	bh=5zfISgYw25AJ/G+BhlY8037e8UEmkJsLaeb/tdlBl2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qac840hdJyjL/wXdFvgUG49TWSHtFKphWEnACghSxhqVd3bwm+dYGoGrkuGESq7Yh
	 DLpx0sbaiIRxh8I7xriW3bI9zT7P5f8EF/nOW0kmfsWtfgj3o4ZQnRsaiHqLfE07+M
	 yl3sHe/iLIcucD8s7W5+MJAEqaYaa0ih/3qGBwX0Te9Flw/f/PfN0pRSzkrDy/KHNl
	 K9yR4iNSm72o5ZIrT2itxu/RC/lWwbXqfqTFoZlPbeWUUJHKS9aE5i7HhGsiYBJt1r
	 py5T8nvNLaK7v1NuvdiMyOfg758rdkiK+6chy++3jWjOuTNrNEh/uQW0k7w4csEwYT
	 hf++R2ikZ/7tA==
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
Subject: [PATCH AUTOSEL 5.15 37/47] usb: uas: set host status byte on data completion error
Date: Wed, 31 Jul 2024 20:31:27 -0400
Message-ID: <20240801003256.3937416-37-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240801003256.3937416-1-sashal@kernel.org>
References: <20240801003256.3937416-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.164
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
index 11a551a9cd057..aa61b1041028d 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -422,6 +422,7 @@ static void uas_data_cmplt(struct urb *urb)
 			uas_log_cmd_state(cmnd, "data cmplt err", status);
 		/* error: no data transfered */
 		scsi_set_resid(cmnd, sdb->length);
+		set_host_byte(cmnd, DID_ERROR);
 	} else {
 		scsi_set_resid(cmnd, sdb->length - urb->actual_length);
 	}
-- 
2.43.0

