Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795163408;
	b=0nPmCOAiiASbwQnI9t39ec2qBuu1UvBmcqU9CvY8p7EFKS0xH5qHgTOqVAlN85TEusHw
	 g+9FexITjTD3YfEL86N3/SMU5jEdg9nxv02H5XSuWWrYLciZUQdymIJJvEOzC/BpyGYlb
	 QnmVfQzQyDEfZXPlqRKEh6KwNuVNBmIECI1uPxUrb7nIBD+H04KiW317pBJUNFXmJJUat
	 8Kut1HR/pAbx1D/h+GBJfdTwVdLkIRUWyUa8E9gc14d/ptr8zG+LthbB/3TozXxgCxyes
	 Wr3OYEAoSDNk4EHmr8LtfPm6+QsnRQEfolr7jUG4Zm0liKuuXgCepYmHoPNkt94p81A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163408;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rew0IjMtoOdPwnHrp63Xk9X2hNVhQsL69C1NgCaKdn8=;
	b=OhppRqYT3kVm3QK4dvahBlv2blYCkhJlPo5vvz/wDWyD/QyoyPZpakbqENewtLykGyeo
	 grE/IuSXIHUOAII9bmafimGR6YMaXWNmNIlw7viOYQAmhvCQQDv3XIQTXzeiorL4qMg+z
	 HbgKFJJrV7dVDNhsu1HDVftKaLr6MB7liEpQVZpH71Qq9lkDfH2ix48+82qT3JMxazfoB
	 evNNFR003ulHNnAYMdysW7oIuzDduoZbcaBP4wtosFAXeWXWaXTGtEXeDRgJFQUHB/OiR
	 NXQIV2iqgJsLw4PalTXFotw35z/HWuvpk+Io9LB6s69g44Cv0VLeYwKmdZVxtSWUGRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=PrLrw2AA;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FB4606A326
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 08:30:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2FB4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=PrLrw2AA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=PrLrw2AAAeubHQw5bQNAXGDI/4vFJkXvGKK9r3Wm+Q7YZeS71aTxPpITUdz5S6aTryjsmkCW9hh2e
	 uYep+uFJGIqkGR0t5dh1IrEmIgwI/WALnPxeOo6hl0xADns7h2Lu4u6aY7NLDy4+NLWM4yxk1d9QsR
	 X1ThS8JGoC5FLN64=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee96b00050ca65-2c4af;
	Fri, 20 Nov 2026 16:30:05 +0800 (CST)
X-RM-TRANSID:2ee96b00050ca65-2c4af
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from desktop-eb75daa8a6be458c-20260816004526035 (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36b00050b324-36845;
	Fri, 20 Nov 2026 16:30:05 +0800 (CST)
X-RM-TRANSID:2ee36b00050b324-36845
From: zhangchujun <zhangchujun@cmss.chinamobile.com>
To: Dongdong Hao <doubled@leap-io-kernel.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	Kees Cook <kees+treewide@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: leapraid: fix off-by-one in reply frame address validation
Date: Fri, 20 Nov 2026 16:30:00 +0800
Message-ID: <20261120083000.1961-1-zhangchujun@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The reply message buffer spans [rep_msg_dma, rep_msg_dma +
rep_msg_qd * LEAPRAID_REPLY_SIZE).  The sanity check on the reply
frame address returned by the firmware uses a strict "rep > end"
comparison, so a reply address equal to the end of the buffer is
still accepted.  leapraid_get_reply_vaddr() then computes
rep_msg + rep_msg_qd * LEAPRAID_REPLY_SIZE, a pointer one past the
end of the buffer, and the completion path dereferences it, reading
outside the DMA allocation.  The out-of-range address is also
written back to rep_msg_addr[] for firmware reuse, which would
make firmware DMA into memory beyond the reply buffer.

This check is the only guard against an out-of-range reply address
from a misbehaving adapter, so make the upper bound check
inclusive-correct by using >=.

Fixes: 5597088c9e79 ("scsi: leapraid: Add new SCSI driver")
Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

diff --git a/drivers/scsi/leapraid/leapraid_func.c b/drivers/scsi/leapraid/leapraid_func.c
index 573bccf1a4ce..c54797e22e74 100644
--- a/drivers/scsi/leapraid/leapraid_func.c
+++ b/drivers/scsi/leapraid/leapraid_func.c
@@ -5667,7 +5667,7 @@ static void leapraid_request_descript_handler(
 		break;
 	case LEAPRAID_RPY_DESC_FLG_ADDRESS_REPLY:
 		rep = le32_to_cpu(rpf->addr_rep.rep_frame_addr);
-		if (rep > (u32)adapter->mem_desc.rep_msg_dma +
+		if (rep >= (u32)adapter->mem_desc.rep_msg_dma +
 			   adapter->adapter_attr.rep_msg_qd *
 			   LEAPRAID_REPLY_SIZE ||
 		    rep < (u32)adapter->mem_desc.rep_msg_dma)
-- 
2.50.1.windows.1



