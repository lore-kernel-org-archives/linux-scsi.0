Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793153449;
	b=agqEB7irlX4gOgKUdPAnMoojqpJMKLvNX59OxtKrJDFkOeroPHlJZa6izxOIYSSlkL5a
	 qsZ6wnuYtK9RcmkLIqrJXVIaI+4/0WT38v5RQoDHfTR/Mpq9h0s96g7iAskWWafVpIx6i
	 fEDInk7AfljKEN5pFprLrV3kFqEj3ZzysZ59CqezvyJEtsFuA9lj3NjcHxtKmbAJdIpKv
	 uterfkU6yfy2Jv//o8pNo3Ilyt1U5HUuYq03RnB0P3+uUdM8zbmiQVgzV2/ijTUDfwyEG
	 uf8cZfz9Lo2OvBOCalb/W8agErosg+3N2Hi6OpEYNU0OvYiOQjX1QyO87gMwTzVAkjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793153449;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rPDXc8VeHSDtenYiKgjUC/Ldt2IcNatApkkoJx2qUlY=;
	b=ATj8WawMhQLKyoViVHK1xeXCoV9aM443/nQPe5TsMHFnsLL6W/Hulp9RYHOxYDDZRDXa
	 gYet6fzJ2NN9YaniKY5FrRGvuJg1qrPrECa19OGR2zi2AUNVLp/slpsmqvMAC1eDa7Fni
	 bM+X/I5fD4gGccEQsW+G9CIog1Rm7xAxO6AmuM7QsypHWmYW0YdRKhaOzMMp2LI79eNOg
	 9hEAHWkbgT8RCH8E4PaE/50noyXOPGqLP0eeFJZ6Ov7qHUWXtv0VASpPfM1zMQlggnSD7
	 4yCo94OWvqmJ8l09G8zW6Fr8Z/A2dDpbDRRBmdeAIM0oqVyHCRncbx4dhHxPHdpdm3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C96D606A31A;
	Wed, 28 Oct 2026 02:10:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C96D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c26ce3a8d27411f19a56ed5b684f684d-20261028
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:da498e7a-5b2e-4bb6-b7b9-1f2f04494a06,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:cd555a8ef8a4af76be71358613beff19,BulkI
	D:nil,BulkQuantity:0,SF:81|82|83|102|865|898,TC:nil,Content:0|15|50|99,EDM
	:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c26ce3a8d27411f19a56ed5b684f684d-20261028
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2136337716; Wed, 28 Oct 2026 10:10:34 +0800
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
Date: Wed, 28 Oct 2026 10:09:58 +0800
Message-Id: <20261028020958.1141513-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <8469d5fa-2f4e-4565-8d84-43d6b71b4a9c@suse.com>
References: <8469d5fa-2f4e-4565-8d84-43d6b71b4a9c@suse.com>
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

No worries, and thank you for taking another look.

On Tue, 27 Oct 2026 at 15:35:34 +0100, Oliver Neukum wrote:
> I'd say both ought to use cancel_work_sync()

The physical disconnect case is why I kept the first call
non-synchronous.

USB core has already terminated the interface URBs, but a running
synchronous scan may still be waiting for SCSI command completion.
Waiting for scan_work at the beginning of uas_disconnect() would
therefore delay the command cleanup below.

In testing, using cancel_work_sync() at the beginning waited for
about 11 seconds before reaching uas_pre_disconnect().

I would therefore keep cancel_work() at the beginning and synchronize
scan_work after the command cleanup.

Thanks,
Jiayi
