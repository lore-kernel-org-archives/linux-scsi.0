Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8721D41BA7F;
	Thu,  8 Oct 2026 10:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791456623; cv=none; b=CTow361jMaslQi2LIZTF/3P4vCojP+UhFU3Cy55pG6iNyR6he61ma8tKY1h1py8LL8E3fsRIyaLbIbsgzlXtDR4Fq5Udam0pOfkLNWGluqADowPEZzdxwNCP3R17PYa5QldYDnxpxQCMaZ1basTKYQdlmI4QIwF0Lfz16UmvK3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791456623; c=relaxed/simple;
	bh=5B6UxseGYw6wLmsbJEtbmVdevNpq984Y1Mne95EQfmA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DUDQ8GRzHUGeiL3ZL6CLTEeFEy06/T/7RlzUsTTcC9dg7PCWmf2W2P+1gzZubvdjk0Cgc0JPMGZF+JKq0C7VlkcTzVQV0mPXHqwyLvZGSoydLJccb68Shcicj9VmxxlsaWnhppUpKJa0ns9Qy6ViiyBKTv7LxzDLVJ+KsK2Nk/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 09327a92c30611f19a56ed5b684f684d-20261008
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c30dba20-bb13-4f8d-9b80-49c396e7d13e,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:7db8b62,CLOUDID:f533aac2d9d4e81a5402c5cfe1f13f2e,BulkI
	D:nil,BulkQuantity:0,SF:81|82|83|102|865|898,TC:nil,Content:0|15|50|99,EDM
	:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 09327a92c30611f19a56ed5b684f684d-20261008
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2131061613; Thu, 08 Oct 2026 18:50:11 +0800
From: Jiayi Li <lijiayi@kylinos.cn>
To: oneukum@suse.com
Cc: stern@rowland.harvard.edu,
	michal.pecio@gmail.com,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: uas: quiesce SCSI before stopping endpoints on unbind
Date: Thu,  8 Oct 2026 18:49:26 +0800
Message-Id: <20261008104926.2674417-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <813dcf3a-0615-4152-baa7-47b0046ca113@suse.com>
References: <813dcf3a-0615-4152-baa7-47b0046ca113@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Oliver,

Sorry for the delayed reply, and thank you for the feedback.

> Why this specific trigger?

I initially chose -ENODEV and -ESHUTDOWN to handle reported device
removal or transport shutdown. Earlier errors such as -EPROTO can also
be transient, so I did not include them in the same transport-dead
handling.

However, I agree that we cannot assume an URB will necessarily fail
with -ENODEV during physical disconnection. I think earlier errors
such as -EPROTO may also need additional handling, and I am looking
into this.

> In the context of which work?

I mean the existing per-device retry work, devinfo->work, handled by
uas_do_work().

In the current local candidate, the transport-dead state is set under
devinfo->lock and the existing work item is queued:

static void uas_mark_transport_dead_locked(struct uas_dev_info *devinfo)
{
	lockdep_assert_held(&devinfo->lock);
	if (devinfo->resetting || devinfo->transport_dead)
		return;

	devinfo->transport_dead = 1;
	queue_work(workqueue, &devinfo->work);
}

The relevant part of uas_do_work() is:

	if (devinfo->resetting)
		goto out;
	if (devinfo->transport_dead) {
		spin_unlock_irqrestore(&devinfo->lock, flags);
		usb_kill_anchored_urbs(&devinfo->cmd_urbs);
		usb_kill_anchored_urbs(&devinfo->sense_urbs);
		usb_kill_anchored_urbs(&devinfo->data_urbs);
		uas_zap_pending(devinfo, DID_NO_CONNECT);
		return;
	}

This moves the URB draining into work context, outside devinfo->lock.

> I wonder what is to be done if error handling has already started
> on the SCSI level.

In the current local candidate, after usb_lock_device_for_reset()
succeeds, uas_eh_device_reset_handler() sets resetting and calls
cancel_work_sync(&devinfo->work) before draining the URBs.

I will run more tests with SCSI EH already in progress to check for
races between the cleanup worker and the abort/reset paths.

I am trying to refine the patch.

Thanks,
Jiayi Li

