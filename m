Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35191C9DE1;
	Thu,  1 Aug 2024 00:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722471930; cv=none; b=IILYEyRMr99cfhhGEXpZnNdePBy8Bd9L7/iTt4PLyZxXHFD3fzjHmS8PDqrxIWNm6ZeuW7P50VIQQMM1mKGuvvWjdd8s0qMOj3ofq0X7Z2VN4+CBUn3qO2en6HMHZr/gdDIcfE8dDe+tDutdvMw8f7JyWvdq5ztRbegDMuggls8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722471930; c=relaxed/simple;
	bh=v3ZmhvwoRxOca8R0n0ipeDTKy50TAw5w+XASHSJRXDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WewFIpv/PzScHHM7k+tdm8iVC2I5j44DonhpBG13FhMD6ApkSUVhJI2PD561CFRg0uK0aeBAMd5pyZcOE0UYQ24Ep7se9NJjeJAfsouJ7ok8s7MJysuto2BzbrCBx49DebjJVwMssF8F2ovPrpeLEXSi0eImvvdpcNm94b6pGzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NV1Wj4CQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NV1Wj4CQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53498C4AF0C;
	Thu,  1 Aug 2024 00:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722471930;
	bh=v3ZmhvwoRxOca8R0n0ipeDTKy50TAw5w+XASHSJRXDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NV1Wj4CQDqT32CcfdGaMMwglLCyp6PvNZdW5uCL1oImKvQTTwYoJST+zy+FqUrXKu
	 MjQ5eSPsLYcCQje2FC8gk+tBhIVI5/sDg1JCp68nivFkGAoGIFDaKJlf6OMlO8vU8Z
	 1dmeITgAVcZCb/wxHu8TmzVohtLnOXqebUg4/ypLvShsWnI6p38UmYWpogsMs+sLS5
	 952XCzOPIaTsYvx1w225yMAJqULYNdxsKH1LRAGRnx70DfCqDfSzLcQzuX6/0NCpO/
	 DW9lxfafM/px08GcY0PRrnjGrnoPrjCjd05U2+JPSgKTnvxZdDyGspCXbEvrEfozMl
	 ORPsnEe+KrQ4w==
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
Subject: [PATCH AUTOSEL 6.6 66/83] usb: uas: set host status byte on data completion error
Date: Wed, 31 Jul 2024 20:18:21 -0400
Message-ID: <20240801002107.3934037-66-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240801002107.3934037-1-sashal@kernel.org>
References: <20240801002107.3934037-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.43
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
index 451d9569163a7..f794cb39cc313 100644
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

