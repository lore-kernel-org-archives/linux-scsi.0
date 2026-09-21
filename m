Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8403AEF4E;
	Mon, 21 Sep 2026 09:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983866; cv=none; b=QlpvJWC6IjIHGUylDXY/l/Uiqphg0J6Sy0G3fqoyV0tus33ecmGTCRHcCAyVqByjG/dMfCQoREFcEX0aQ5Uf6GQ+d1SmCAY2giq1o0/BO9zzitfdnY/uucFMSLWGBd+BqR3WL0ze8gTvnr5WHk5QW2M+J3B3/qXMkfk/scUYyws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983866; c=relaxed/simple;
	bh=Ny2qS2fMxi0fAcYUfnNf3pmIxiRJbqNgL/Fh4LCY4Ik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cc3xDUbzCXJrH4Z4EUAQaK7pglHxE/7iYanB5DiVVtJqVaDi6d9FEdob5JIEvuxQrnYvTaApNTU+51EgTHaKeHdbNMUYumSX6flXM1kzynVpg0DSVHU8rrnDrI9uPEy1C+M4nDssCCIam6Crwyxj4itvPBQrdlM4xhXrqNk1SAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 03157cdab5a111f19a56ed5b684f684d-20260921
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:1c0d18b0-7032-41a2-a203-6262f7da3134,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:28c43a1190f95a13f376e43396c62bc9,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|865|898,TC:nil,Content:-10|0|15|50
	|99,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 03157cdab5a111f19a56ed5b684f684d-20260921
X-User: lijiayi@kylinos.cn
Received: from [172.25.120.57] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1376205578; Mon, 21 Sep 2026 17:44:17 +0800
Message-ID: <60d7692e-4d8e-4b94-b45d-a530bc2cff72@kylinos.cn>
Date: Mon, 21 Sep 2026 17:44:14 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] usb: uas: quiesce SCSI before stopping endpoints on
 driver unbind
To: Michal Pecio <michal.pecio@gmail.com>
Cc: Oliver Neukum <oneukum@suse.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <20260920012358.3362053-1-lijiayi@kylinos.cn>
 <20260921092615.7402711d.michal.pecio@gmail.com>
From: Jiayi Li <lijiayi@kylinos.cn>
In-Reply-To: <20260921092615.7402711d.michal.pecio@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Michal,


> This is actually an anomaly, transfer events should always point
> to valid rings. Device sendig bogus Stream ID would be code 34:
> Invalid Stream ID Error.
>
> Is this an ASMedia host controller? PCI ID doesn't looke like one...


The original controller was not ASMedia.  It was a Zhaoxin xHCI
controller, PCI ID 1d17:9204.


I have now reproduced the same post-rebind failure with the same USB
storage bridge (USB ID 2109:0715) and workload on an Intel xHCI
controller (PCI ID 8086:a2af).  This additional run used
6.14.0-27-generic.


The relevant post-bind log is:


   scsi host7: uas
   scsi 7:0:0:0: tag#4 data cmplt err -75 uas-tag 1 inflight: CMD
   scsi 7:0:0:0: tag#4 CDB: Inquiry 12 00 00 00 24 00
   scsi 7:0:0:0: tag#4 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD
   usb 2-2: reset SuperSpeed USB device number 2 using xhci_hcd
   scsi host7: uas_eh_device_reset_handler success
   ...
   scsi 7:0:0:0: tag#7 CDB: Test Unit Ready 00 00 00 00 00 00
   scsi host7: uas_eh_device_reset_handler success
   sd 7:0:0:0: Device offlined - not ready after error recovery


There was no "Transfer event 26 for unknown stream ring" message in the
Intel run.  Therefore, I agree that event 26 is anomalous, but it is not
required for the storage failure and appears to be a secondary symptom
specific to the original run.  The first post-bind failure is the
Data-In completion error on INQUIRY, and the same error occurs on both
controllers.


Thanks,
Jiayi


