Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE71244667;
	Mon, 21 Sep 2026 02:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789959540; cv=none; b=pTfUAm8rCuw+fg0skwA79dY8Uh66qYLveEoUa5gVRoZK4IULeDP2/Oi8NrT3w9ZVqGOqGBbbIGm5UJ5ZPzYRXD8fZy94ZDKTjcDAPwa/XfPTxgyViOwb/5D0oE1xCdX7JNXfxmukOyU5XtkrddzhO0hl9UU2ni3xh0RkXc3Z+hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789959540; c=relaxed/simple;
	bh=qq/HrIxA/bL6/wJjEKuTI/VAopTwbzecn/dAsqEIv20=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=I6L2kvhjcE5HbK95MNh8lJ+Ndom1MeMCycWDIdDl9Q9BrmsDV+AGE4YzicCJPCdkI/VQLsLqSJ8023nVR5JSNpNw7c8kVNBzO9dtG5QyuUd5mnB1pMeDfqZtyMJRvov60Cv9HblFCpWLvY4+NXXUQPHdSXMUg3iHxqZ6H6HL/d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5dec6558b56811f19a56ed5b684f684d-20260921
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:1a93c21b-53ac-496b-9bb0-fd3d18fea442,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:605a76c4cd180f63604284486b04e2f6,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|865|898,TC:nil,Content:0|15|50|99,
	EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5dec6558b56811f19a56ed5b684f684d-20260921
X-User: lijiayi@kylinos.cn
Received: from [172.25.120.57] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1694522496; Mon, 21 Sep 2026 10:58:48 +0800
Message-ID: <3e392e3e-ec27-43b5-a361-bebca45ce087@kylinos.cn>
Date: Mon, 21 Sep 2026 10:58:43 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jiayi Li <lijiayi@kylinos.cn>
Subject: Re: [RFC PATCH] usb: uas: quiesce SCSI before stopping endpoints on
 driver unbind
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <20260920012358.3362053-1-lijiayi@kylinos.cn>
 <98374a38-eb18-44c7-8da4-d5e34944e72f@rowland.harvard.edu>
In-Reply-To: <98374a38-eb18-44c7-8da4-d5e34944e72f@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Alan,

Thank you for the clarification.
> In general, a class driver like uas shouldn't care whether an unbind is
> what you call "driver-only".  It should take the same steps whether it
> can communicate with the device or not.  (Note that the patch's test for
> USB_STATE_NOTATTACHED isn't fully reliable -- there is a window after a
> device is unplugged before the state gets updated.)
I understand that uas should not distinguish a driver-only unbind from a
physical disconnect based on USB_STATE_NOTATTACHED.  I will remove that
test and use the same teardown ordering for all disconnect paths.

I will retest the revised patch and send v2 after allowing some time for
the uas maintainers to comment.

Thanks,
Jiayi
