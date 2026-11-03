Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709133;
	b=b738JTu9DImCIwgJoPq2l194bSfkEDZ3I4FNQArN9VfUv9o4xFoAH1Wmkt14CzNRn6E8
	 lSs/en3ZKN6kHr12no74K4GUjEceP4HYFGujhT+UgeiOiZaBQ4UrOxTXfprBV7G71vyCj
	 F/1zR0eooq4fsMQ5p9A8h3DN4PGPGJeDlRkUAzT53upMWkd68LJqGWJmuQ1bVGpWJAKSw
	 KmTnhW/2VuKpqnnjlsvbi6/5t7X764yOg/39rx2lDyfirnxWJ0cN1QvLYvU+abgvwUMaa
	 8eqNQXMz7vsn7r9t5EoFiJteN5f1qTv5pu+NoJPAZsiRIhZd+inGstGiCQR1RN9VDXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709133;
	h=DMARC-Filter:Received:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Rspamd-Pre-Result:
	 X-Rspamd-Server:X-Spamd-Result:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id:X-Rspamd-Pre-Result:X-Rspamd-Action;
	bh=02Sq6sfGjnLSg3szCgZSGDz1nJ2G94ZioA/gjnB61tw=;
	b=PhqquJcTdK4nB+yZGDP1CawCXCsyIFvvtzcAJBnMEXErTKr2ojfHtNf8KMABSyQADgxk
	 eB/nq2miexO4DdC7j4a7d3/KgxhF1zQjjI6RgZ1HeR41ap5rdeaGQYIQTPmCKBJdVNKcg
	 o+XnI1zysxfYeCPcDhql6ex9SFditGiti5CSJZJ6VD8jq9L+CeE5oI4MRW7r2FDupHu9s
	 YpOeNGr4zQuB8v8qJQhOsvhgg5+5gJNbta0AG2pOVGnyb1pr2vwwtFPveiVHLA19gd9rw
	 oCILA/Pn05MWDlpCzX0xRal1ItEbOBmrAHNljxeMpR4xpSjyDw+AeOBGTWCErFi8igw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E18F6082BD6
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 12:32:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E18F6082BD6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7D78C227CF;
	Tue,  3 Nov 2026 12:32:11 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 39D40134B8;
	Tue,  3 Nov 2026 12:32:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YKALBUvU6WphBQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 03 Nov 2026 12:32:11 +0000
From: Daniel Wagner <dwagner@suse.de>
Date: Tue, 03 Nov 2026 13:31:42 +0100
Subject: [PATCH v2 7/7] scsi: qla2xxx: Use FC_SPEED_2 to check for the 64G
 SFP speed byte
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-qla2xxx-fix-v2-7-c6d2cdf2c806@suse.de>
References: <20261103-qla2xxx-fix-v2-0-c6d2cdf2c806@suse.de>
In-Reply-To: <20261103-qla2xxx-fix-v2-0-c6d2cdf2c806@suse.de>
To: Nilesh Javali <njavali@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Himanshu Madhani <himanshu.madhani@oracle.com>, 
 Quinn Tran <qutran@marvell.com>
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.16.0
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Queue-Id: 7D78C227CF
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action

SFF-8472 byte 10 bit 1 says that byte 62 ("Fibre Channel Speed 2") is
valid. Commit 21ab087cae50 ("scsi: qla2xxx: Add support for 64G SFP
speed") added FC_SPEED_2 for that bit, but the 64G check tests FC_SP_2
(bit 2, 200 MBytes/sec) instead, so FC_SPEED_2 is never used.

Test FC_SPEED_2 before looking at fiber_channel_speed2. This only
affects the SFP speed debug message.

Fixes: 21ab087cae50 ("scsi: qla2xxx: Add support for 64G SFP speed")
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ccb039d97353..df46fc409a01 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4114,7 +4114,7 @@ static void qla2xxx_print_sfp_info(struct scsi_qla_host *vha)
 	    "SFP: %.*s -> %.*s ->%s%s%s%s%s%s%s\n",
 	    (int)sizeof(a0->vendor_name), a0->vendor_name,
 	    (int)sizeof(a0->vendor_pn), a0->vendor_pn,
-	    a0->fc_sp_cc10 & FC_SP_2 ? a0->fiber_channel_speed2  &  FC_SP_64 ?
+	    a0->fc_sp_cc10 & FC_SPEED_2 ? a0->fiber_channel_speed2 & FC_SP_64 ?
 					" 64G" : "" : "",
 	    a0->fc_sp_cc10 & FC_SP_32 ? " 32G" : "",
 	    a0->fc_sp_cc10 & FC_SP_16 ? " 16G" : "",

-- 
2.56.0

