Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782666;
	b=ZQ0Bh1h4RVJq6V31NFZ64L4MWtWiJBI1fqdqkDso9g/FYwoAZbTCSrDJMlm1gF5jvjGh
	 M746p2ibWE+XA25X/qCRLw9bKZ/4NDJmNtPIOtY/SaV6BeQUbV0Y/V7LWsagBSJw6Q4ug
	 L1n6PHU7kk+kPAqsVS51ANvlWFubBCJqvDLh2FENGzyG78g+rP4eHy284Jmbh/v9Y2TR5
	 FeN4cc9jnVBv21ujk3KSrI0+p090CaL5/lVZkYQS1JyEaTPO+s5ukrn418hhHXNur6lZ/
	 zm4cYiWtjMvaqe54BB7IMv0Caw9YHuGzvwyMwCQwWUS25dZEz/056N8pWO9bDNlqgoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782666;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vw5aK09NPKd7FOOrgUdgSm82KhVxdYZAKL4Caolp2W0=;
	b=DXvGhivF01gV0uR8TRPa2pw7FetGoquD3CkXf0J//GjtSGY8YzWZVRi3yhaqXLmkVasX
	 ev7yLnS/HUlQLHpxJDj8ej/Z680LInIJ5ArD05Y/v8MQZ0i8ImNS02PwKZK1NSppieS5d
	 nWycKccX24iney8nGXxd8cEy7mhP5ix0pUJPoomwqnoluBDMNDQClUWqt9guVTqWdfiAy
	 ho7LCaRJEyJnv10HEvo6WNqD+d9RTiUsRcrAbp1J1njUckrxNw/bBYqDLcRTRi9os+gTH
	 F4e0skmB8K/l5h4hb8x5sZc/eLEHAj7HuaOIWK9WPa9BIxouAc5Z6s+iCam0izy3Zaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174F9606A338;
	Wed,  4 Nov 2026 08:57:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 174F9606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c9108994d82d11f19a56ed5b684f684d-20261104
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:bf6115f2-216e-4c01-85cd-6a138d47c120,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:4,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-1
X-CID-META: VersionHash:7db8b62,CLOUDID:c1ddf5b89e3c9d8e64892d54341d5a00,BulkI
	D:nil,BulkQuantity:0,SF:81|82|83|102|865|898,TC:nil,Content:0|15|50|99,EDM
	:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c9108994d82d11f19a56ed5b684f684d-20261104
X-User: lijiayi@kylinos.cn
Received: from thinksys.. [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 4631866; Wed, 04 Nov 2026 16:57:38 +0800
From: Jiayi Li <lijiayi@kylinos.cn>
To: Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Michal Pecio <michal.pecio@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] usb: uas: wait for pending commands before unbinding
Date: Wed,  4 Nov 2026 16:57:18 +0800
Message-Id: <20261104085718.3300303-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261028092153.1481202-1-lijiayi@kylinos.cn>
References: <20261028092153.1481202-1-lijiayi@kylinos.cn>
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

Hi,

On Wed, 28 Oct 2026 at 09:48:15 +0100, Oliver Neukum wrote:
> Why? What is it waiting for? And why do you think we can skip
> that wait safely?

A gentle ping on my previous reply about the scan_work cancellation
ordering. Please let me know if any further clarification or changes
are needed.

Thanks,
Jiayi
