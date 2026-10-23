Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792720134;
	b=xFct2qeeiUMSDi5T6UVSgeE876aIquIfLHgZ0ySzsxYSW4CwpfnkxNhj48LXKPFWmiP0
	 Dx6LCb4Uuz0rHIum+0yl66eswCzkeudE4muhIT8iZGLj9Pig9e3EfOPxhYsdgbWi5YpQ6
	 BUvLnoewIpxFKRjMAqr1Rj2QCOUW+yEORTyqbXxnfTVUgZwUwXiXne3fOxZ+w1sL5m/GL
	 GNau1W6FN+hVZX8SxJGf1VfbQgRJecgup8e7qv3djn03asCGCBh5RtX6+Snf5/BrwyT2a
	 MmHuQzZOZ2pKgF0vAq1/QUm3tt4Nx5PDvErBVoZOkljUvg1HLa9vcvwAKrh0XJLJisQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792720134;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BgJjVQhV02xZ70CA9Qs5H+NSnKs98el57tAmUU66SFE=;
	b=EmMeV4fwegkYJy7ZzUEKxHfuBna2V28guFwn4lnAP/g4/Pq5r3zBrZ4Kv2vrYw6Urvth
	 cLKmBPp+s8Oc4QIUJX6NiCrYgzAp0PBvXHID7ch22mOfYC7lViFRNAvj8o77+AFYDXzqE
	 sy8SJODbJpMmo3KX2ew3wleXCludexlxkKxXgLoAT9d0iPZjujD+wtQjWcCacAbjxiz8L
	 Ila+0C7oGiv5BQlWFer7uUr0sWQgD6ZLAR1X8pdKl8bsJSkKPGgIbIRef+VzHPw6wkics
	 SsWGHRCLjJwAVUQt9wXpErQdyqzywvPXibPoVlIm3qw016rur+YHzR1mk2b9/I1pd/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10DD606A319;
	Fri, 23 Oct 2026 01:48:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B10DD606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: e11cdb72ce8311f19a56ed5b684f684d-20261023
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:bc2b87aa-33f6-41fa-9f02-7fa4c180bb6e,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:d90f48e985ef8edec7869a246bbebb83,BulkI
	D:nil,BulkQuantity:0,SF:81|82|83|102|865|898,TC:nil,Content:0|15|50|99,EDM
	:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e11cdb72ce8311f19a56ed5b684f684d-20261023
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1913937578; Fri, 23 Oct 2026 09:48:43 +0800
From: Jiayi Li <lijiayi@kylinos.cn>
To: Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Michal Pecio <michal.pecio@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: uas: wait for pending commands before unbinding
Date: Fri, 23 Oct 2026 09:48:19 +0800
Message-Id: <20261023014819.392464-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <6015c40b-04ae-443e-8271-63e064f08ab0@suse.com>
References: <6015c40b-04ae-443e-8271-63e064f08ab0@suse.com>
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

Hi Oliver,

> please put the blocking of the host in the direct handler for disconnect.

Thank you for the review. I have sent v2 with the host blocking moved
into uas_disconnect(), as you suggested.

Thanks,
Jiayi
