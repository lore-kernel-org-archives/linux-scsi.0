Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E796C3C9456;
	Thu, 20 Aug 2026 07:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787211016; cv=none; b=i9m2VD/CpRTaJWSr/kLLd54dQOpZTtwQpZkmU5aj5hYQqRkBck+czGxDPCm1w3DTCjWM4bsDoQKkT2QjYAprluqRRAc6TKQ31CGKUZZObI3vwd9GqWiT1/Zn0/Msmt0VbF0rAgA7CKqAepQDsEii/ZMkJ0L/xBV+l4PTvJdbTDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787211016; c=relaxed/simple;
	bh=9E6JZnS9QloMPVbzAmZYFoyEr6DoJGFsWHRpRHXgw90=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qNQWJOClnqgambHhD1CRJ7QNHtoGH7DQe4UxXcIZIwLyQafsJw/yuOfANxARdRLotdeGO61IWYJOLVDJUDvS2d1JacVKfpYx6gM02afGAPBvPM5aNjZEwq80nMpJ/quJZ0zeFsraCDyBXOTFdTX3SYi8pxjk5mH2adWV0R1CVjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: f51ee54a9c6811f19a56ed5b684f684d-20260820
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2dfab66d-bedb-4a9a-8a88-e14d363187ba,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:d1dd54cd25e25517d2bfeceac91f6da6,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|850|865|898,TC:nil,Content:0|15|50
	,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,O
	SA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f51ee54a9c6811f19a56ed5b684f684d-20260820
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 335869584; Thu, 20 Aug 2026 15:30:02 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: fnic: free the NVMe port template from the delete callback
Date: Thu, 20 Aug 2026 15:30:00 +0800
Message-Id: <20260820073000.3984849-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260819114242.3598034-3-lilinmao@kylinos.cn>
References: <20260819114242.3598034-3-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Resending: this reply went to the review thread and linux-scsi on Aug 19
but not to any of you directly, so you may not have seen it.  Please drop
2/2.  The bot's two findings are quoted below; the rest of its mail is
trimmed.

On Wed, Aug 19, 2026 at 11:52 AM +0000, sashiko-bot@kernel.org wrote:
> New issues:
> - [Critical] Relocating `kfree(iport->nv_tmpl)` to the asynchronous
> `nvfnic_local_port_delete()` callback introduces a severe arbitrary free
> and memory corruption vulnerability if the unregister process times out.
>
> Pre-existing issues:
> - [Critical] The driver's bounded timeout design for NVMe FC
> unregistration leaves the `fnic` structure vulnerable to a Use-After-Free
> when deferred callbacks execute.

The bot is right.  Please drop this patch; 1/2 is independent and still
stands on its own.

If the wait times out, fnic_remove() continues and eventually frees fnic,
which also frees the embedded iport still referenced by lport->private.
A later ->localport_delete() callback would therefore read nv_tmpl from
freed memory before passing it to kfree().

The underlying problem is that the bounded wait allows fnic to be freed
while the NVMe/FC transport still holds pointers into it.  I will revisit
that teardown separately.

Sorry for the noise on 2/2.


Thanks,
Linmao
