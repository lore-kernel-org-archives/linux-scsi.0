Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C417B1D54F6;
	Thu,  1 Aug 2024 00:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722472262; cv=none; b=InnL7rL89H66DN2eVbsP7SEbSOnyqcTeUQgrv9IF+fXKtvWamFX6ygmVo3k/WWyxgAMjzbCwQp4nN4tXvrX5/R/dUngrPgzhoz5vCpLQeNNB8CYgROu4g1CXdPg28qSwIp7WvoRPgeo65ERqPeTAtY5k3rUQnHgzgUhHK2fPEno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722472262; c=relaxed/simple;
	bh=slbQIJeOsIAtF8UdUwokvnCwoq5kMnxfqZVWBpxtkuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqVSrF8Kpv14BkcadazEzdGHs2uHBeX5xdVtmk/DBGO5ULOSSc/KsR1ZP+p68lPok85Anr8WFfedH1523FyEuwuxp0vWqY2W4S1cTbeCm1nUJFvO5dFX8m3zV2gInBhpbqVkJTBxDspRNGdw4gfDTBkgjttuwhyt3E/gkL3GSM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BePpeLE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BePpeLE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A5FC4AF0E;
	Thu,  1 Aug 2024 00:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722472262;
	bh=slbQIJeOsIAtF8UdUwokvnCwoq5kMnxfqZVWBpxtkuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BePpeLE3jtR79QIVhahXy0EW9FUw/pI2ufcGqRLldrKEvQsFuEn1SKleoX0SsyrUH
	 u+2+44JxqWgvTJwGrSRwQQ+/SnwT6UtaGQIpXNP3B6D3C78fCklFvxvj+1nclL8RzH
	 K2N0B5c3zOQjhHD7EkC723SosKLlofES9yeym34sUOAxwnJZZ+zrGKdVlCb4SoEEPI
	 nhcmGStBfrBlZG/vKZE6fCgxPbmDzLs1U3UQ7UHCZ3zpnRkezINGq+s/vj/h2WUCl8
	 u3pPpeIgNtVwDfSTs05BhPl2TYbZuTD5M8OjYcaLB+bBjjyZdkjdDC3ByW866TRBoe
	 vFP3gL5XHIFjg==
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
Subject: [PATCH AUTOSEL 6.1 48/61] usb: uas: set host status byte on data completion error
Date: Wed, 31 Jul 2024 20:26:06 -0400
Message-ID: <20240801002803.3935985-48-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240801002803.3935985-1-sashal@kernel.org>
References: <20240801002803.3935985-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.102
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
index af619efe8eabf..b565c1eb84b3b 100644
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

