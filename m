Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C3F24293C;
	Wed, 30 Sep 2026 01:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790732042; cv=none; b=ADpexkeEZA26wAQ8AyoPPvl/p+WmNeR4KYK9DDzMliLMRmJTAR0UIblcjbBP+yE7/wMc/MgQ51LTkakHdGniV1ARehF8Qx56v3DMb6CEbX549A3nmmfJEDHI95AXOQJlwC0QJbkVw5B9zdQKSRRXajlEbPK46CKb2YiKJsHaDDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790732042; c=relaxed/simple;
	bh=WzAJoXByfb/43keDF84D/KoQoJqBQqvgNlQotgpNEvs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CudfzdLxjuBSW/s+B36DSLTAKcTKFo212Z1CFrAE+pCsDAKy6vFAffKLXSiBkbDjBE++UywQzWPAIPUD9SMAcW3QMGoN5qgD+Ofu2KUmafgeFbeb04QZfeggAz2gUhMTeEFvAXvDeqeilDEcFerBQd0nqWKiAAOY3nEmuKbSS8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: fd6e79cebc6e11f19a56ed5b684f684d-20260930
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:e4cfc11f-6381-4532-8cfe-b714fead1edb,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:7db8b62,CLOUDID:5d51a313428181ed0221b01c248a505e,BulkI
	D:nil,BulkQuantity:0,SF:81|82|83|102|865|898,TC:nil,Content:0|15|50|99,EDM
	:5,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fd6e79cebc6e11f19a56ed5b684f684d-20260930
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1348360087; Wed, 30 Sep 2026 09:33:50 +0800
From: Jiayi Li <lijiayi@kylinos.cn>
To: Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Michal Pecio <michal.pecio@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: uas: quiesce SCSI before stopping endpoints on unbind
Date: Wed, 30 Sep 2026 09:33:32 +0800
Message-Id: <20260930013332.829717-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <d3639d68-0213-4b70-a771-aa5dc3ec9767@suse.com>
References: <d3639d68-0213-4b70-a771-aa5dc3ec9767@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Oliver,

> Acked-by: Oliver Neukum <oneukum@suse.com>

Thank you for the Acked-by. Subsequent testing found a regression in
v2: physically unplugging the device with UAS commands in flight can
cause an approximately 30-second SCSI timeout. I described the failure
in my reply to the Sashiko review:

https://lore.kernel.org/linux-scsi/20260922100542.164047-1-lijiayi@kylinos.cn/

I have a local candidate that keeps the unified teardown order.
When URB submission or completion returns -ENODEV or -ESHUTDOWN,
it marks the transport dead, stops further submissions, clears
COMMAND_INFLIGHT and sets DID_NO_CONNECT for pending commands.
It drains the remaining URBs in work context, allowing the commands
to complete through uas_try_complete().

Does this approach seem reasonable, or would you suggest a simpler
way to handle the physical-disconnect case?

Thanks,
Jiayi
