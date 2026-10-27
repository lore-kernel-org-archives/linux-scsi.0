Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793086712;
	b=UGqNFKVExC4jcs6vb8264ZzClK8jKbEpK8ocQB5kjg6xRcHRbTSttwD5VXvmxu5mebxc
	 SNfYUBcuf0F5TMdsEnzUluVLZKvXCL4HpcbyBxIfkvOynQeMTVOmu+R6V6NPz5Z85ObB3
	 YgOl6xODB9iPdHydr3hdmEkaybchS4Lcx3Kf/fJFUMleORq3LfFv/dgjZd7Ndm9aaVz0/
	 Xad66n3tBU462vSRH4CEulcqAj4oDyVwjuN4Q8MbRuVkGjVp7Dl9ju3Q0mgfEEZqNttbt
	 1y2O4QKYcrHiV+MStuBM2WdwUaurRPw5bVZMvQFHdrkRYy9vVNdW7pdP1CBOBfcwJow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793086712;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=g/cQoyLXBnCxnipooHLbfvDEWmeWX4FnyljXnjfREbk=;
	b=0I7TXPeLmaHhqUAdabmQfY0XF2TFFtDQ0DWmVFnEp3pfeM+tK15pCGl8mB8BUhSMpTmF
	 85SEtVjh/aGccs38dmUPus9IWrBhJt7Ikh2npovio9xmO9nMHDCciOxxQrOpiCG0HCGU3
	 4hTvt+rkR+iFTg4zts3txy5mUsZWbRE+q/Ztsp4YFnx/4bu/WZTxkNCCf5p+zl/OIwRn9
	 uKDb2eiwE32Z20KRFDA9+omfzSkGCBad+G2o0OisA2eFpRKKacnHpZr7u+Uy22SDYeS7r
	 ExVcmgzKzemrqe3Vgf3sYcIGmDabe69eF5nY3u8TfNgwmQ5CooEyxgeh1WEtYkjZ/dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAFF606A326;
	Tue, 27 Oct 2026 07:38:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDAFF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 61d60c68d1d911f19a56ed5b684f684d-20261027
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2bb69ba0-fa30-4a77-89d2-568a5f0e7275,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:2f9fde66d6e7e7b741c9b643745160e4,BulkI
	D:nil,BulkQuantity:0,SF:81|82|83|102|865|898,TC:nil,Content:0|15|50|99,EDM
	:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 61d60c68d1d911f19a56ed5b684f684d-20261027
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1220175306; Tue, 27 Oct 2026 15:38:20 +0800
From: Jiayi Li <lijiayi@kylinos.cn>
To: Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Michal Pecio <michal.pecio@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: uas: wait for pending commands before unbinding
Date: Tue, 27 Oct 2026 15:38:00 +0800
Message-Id: <20261027073800.648951-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <e6009e1b-2d95-4350-8374-d5930200ed24@suse.com>
References: <e6009e1b-2d95-4350-8374-d5930200ed24@suse.com>
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

Thank you for the review.

On Mon, Oct 26, 2026, Oliver Neukum wrote:
> 1. If an error happens while disconnect is running, why do we want to schedule
> work?
> 2. Why only this and not also scan_work?

devinfo->work retries allocation and URB submission for commands already
accepted by UAS. Those commands may need further URBs submitted before
they can complete, so I intended to allow that work to continue while
new SCSI requests are blocked.

However, the existing queue_work() calls already schedule these retries;
flush_work() is not needed to enable them.

I tested removing only this flush_work() call, leaving the worker and
retry logic unchanged. Normal reads and commands with controlled
allocation failures that later recovered still completed successfully.
With controlled persistent allocation or submission failures, preparation
timed out and the existing cleanup completed. Subsequent rebinds and reads
also succeeded. I will therefore remove this call in the next revision.

> Some commands run longer

Yes. This is intended as a best-effort grace period before cancellation.
The timeout values were taken from uas_wait_for_pending_cmnds(); they
were not selected to cover the maximum duration of every SCSI command.

If a command remains unfinished when preparation times out, the
existing cleanup proceeds. An affected bridge may still require a
physical disconnect and reconnect in that case.

> Is the resetting flag even needed anymore?
> If it is needed, why set it so late?

resetting is still needed before scsi_unblock_requests(), so requests
dispatched during the remaining teardown cannot submit new URBs.

Setting it before preparation also prevents the submission worker from
progressing and makes the status and data callbacks skip normal command
completion processing. In the hardware comparison with the flag set
earlier, the URBs returned, but the command table remained populated
until preparation timed out.

The intended order is therefore to block new requests, allow accepted
commands to finish, then set resetting before unblocking the host and
performing the final cleanup.

Thanks,
Jiayi
