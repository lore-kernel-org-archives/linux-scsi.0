Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6F4503BC4;
	Tue, 22 Sep 2026 10:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071558; cv=none; b=VkBpn5XjtEyNDFkwnmYbnlIEluJlWT/8tI+jqPlYn1MNMn6iOXJ9dcAQddstJK9l9/niY2HQC9wbxy7tcnBVm5cMz62BoXibxp175Rv6Kmc5V/DWBbaJucPK2wJY8Cesn+UJ5+/wOD6PT7iOn60/luN0ralgSUrjFex+gwzAIEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071558; c=relaxed/simple;
	bh=BfLoF1jCHlUaI48Snp61l0Vu2FM/b5RSH77/+5K/Upk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AxsYjexVomF+YFWSAYmE4Kv6kB6/wIQPwez0HmMcT0/z8+KNrV5vd4FNN7ursFInXohFF2cDT6NIosHeO+6dE40TU2/2Jw/iWTHjzjmNZXvQcc8z0vCP9CW8+n8p6ItlkTj4HGlF1qSg6+mx1zxIkm1wbigWXERnnPKQS5KDkpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2fa29c7ab66d11f19a56ed5b684f684d-20260922
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:07c7e53d-71f7-4b66-880d-5834f7c8bd67,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:dc4b83c9f1d78224a7cd7263c3d279f6,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|817|865|898,TC:nil,Content:-10|-8|
	-5|14|50|99,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,CO
	L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2fa29c7ab66d11f19a56ed5b684f684d-20260922
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 288072312; Tue, 22 Sep 2026 18:05:49 +0800
From: Jiayi Li <lijiayi@kylinos.cn>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Michal Pecio <michal.pecio@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: uas: quiesce SCSI before stopping endpoints on unbind
Date: Tue, 22 Sep 2026 18:05:42 +0800
Message-Id: <20260922100542.164047-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922032156.E6AC01F000FF@smtp.kernel.org>
References: <20260922032156.E6AC01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [Severity: High]
> Will moving scsi_remove_host() before devinfo->resetting = 1 and
> uas_zap_pending() cause a 30-second hang and 100% CPU livelock on
> physical unplug?
>
> On physical unplug, usbcore detects the disconnect and calls
> usb_disable_device(), which kills all active URBs with status -ESHUTDOWN
> before calling uas_disconnect().
>
> scsi_remove_host() synchronously waits for all in-flight SCSI commands to
> complete. Because the commands are stuck in-flight until uas_zap_pending()
> forcefully completes them, scsi_remove_host() will block indefinitely.

Thanks for the review.

I tested this case with v2 and can reproduce the approximately
30-second timeout by physically unplugging the device while UAS
commands are still in flight. I have not confirmed the reported
100% CPU livelock.

For a driver-only unbind, soft_unbind keeps the endpoints available
and the new ordering works as intended.

For a physical disconnect, however, the status URB completes with
-ESHUTDOWN before uas_disconnect() gets to drain the SCSI host.
uas_stat_cmplt() takes the error path in this case and does not clear
COMMAND_INFLIGHT.

With the v2 ordering, the sequence is therefore roughly:

    status URB -> -ESHUTDOWN
        -> COMMAND_INFLIGHT remains set
        -> scsi_remove_host()
        -> outstanding command cannot reach scsi_done()
        -> SCSI timeout

The existing disconnect ordering avoids this because
uas_zap_pending() runs before scsi_remove_host() and explicitly clears
COMMAND_INFLIGHT after the status URBs have been killed.

Would it make more sense to retain the original kill/zap-first ordering
for a physical disconnect, while keeping scsi_remove_host()-first for
a soft unbind?

I understand Alan's earlier point that USB_STATE_NOTATTACHED alone has
a race window, so if separate handling is appropriate, the remaining
question would be how to distinguish these cases reliably.

Thanks,
Jiayi
