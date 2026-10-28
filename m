Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793179344;
	b=URMQ24dasmdiTMtFF7KmKSnyZx5p1J7CVUZcL7V5FLDMxSt1pqEC+0x75s1aTA5ioSK5
	 UP3kt82q3pUEnk8jPbBBMmr5OixXE6qTLMMLJ7Ni3RXWHKlooijId2YpIhEoo18q1ZX0b
	 N7lxm8GaeCM+fAN3/KxZodiNOADNdNYIPNemzeLAQ5gKWWXQVD+nhhC5RuaKIHI2TiGQw
	 9nR1pPtGVrJmy0TMGbFXrYXByB0j9EWQFUIcSmbH1BvjfoAXN4NxMDOFU+g/NJRV8g0r5
	 QJ8f1s8oDogMCZ1GhpEGwXYqXsSohKDvfjezrxr7o75bI293zdFW3lZtMc0YysEfScQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793179344;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-META:X-CID-BVR:
	 X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=E+YCM5bjA5bWVsmy2H/KDlpYbRIIKtbo2lnh36vInrU=;
	b=DpOhBAs9YDj2kdbs3DKkiRPFmgxzKe0FX+oMTqKby7KW0PVcu8DTgZsgzbpGY5Ii5RFx
	 NtC8c17s+j8RC0nKfLcNH/AOxkUAgRIv65+9KX/CeyzniqBIFFoEonTwTYeX50VLMCMyF
	 TWg43qDEOZUS/y4VzBz1RVLRCMr0voKw39Bbg7DLZX+JjHpT4uznnFY/m3+AfJyMKmenp
	 B0hjYORWXdge8Y7fxFgZYyild/HEh7B6c72QFlJ4NrZCNLns+VvJGVCqROm+UUhGLHSVm
	 lI7OfHEdAKa+PU6GLTI8IIZjZu/scsUzuMWdO1MiN4uLF/X5Mvcc5VHfkTZufOdBSmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14B3606A31D;
	Wed, 28 Oct 2026 09:22:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A14B3606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0efc6234d2b111f19a56ed5b684f684d-20261028
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:86e7db5b-4852-4942-97b3-0eb42640d1af,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:ce3dac4351f476495faf6e51ac462211,BulkI
	D:nil,BulkQuantity:0,SF:81|82|83|102|865|898,TC:nil,Content:0|15|50|99,EDM
	:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0efc6234d2b111f19a56ed5b684f684d-20261028
X-User: lijiayi@kylinos.cn
Received: from thinksys.tail1c7620.ts.net [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijiayi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 874095675; Wed, 28 Oct 2026 17:22:12 +0800
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
Date: Wed, 28 Oct 2026 17:21:53 +0800
Message-Id: <20261028092153.1481202-1-lijiayi@kylinos.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <5230664a-9666-4196-a798-260da5aa8e8e@suse.com>
References: <5230664a-9666-4196-a798-260da5aa8e8e@suse.com>
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

The wait is not skipped; it is deferred until after the command
cleanup.

uas_scan_work() calls scsi_scan_host(). In the synchronous scan path,
it may be blocked in scsi_execute_cmd() waiting for the current scan
command, such as INQUIRY or REPORT LUNS, to complete.

On a physical disconnect, USB core disables the interface before
calling uas_disconnect(). The status URB may then complete with
-ESHUTDOWN, and uas_stat_cmplt() exits without clearing
COMMAND_INFLIGHT or completing the SCSI command.

Waiting for scan_work before reaching that cleanup can leave the scan
waiting for SCSI timeout/EH instead.

The first cancel_work() only prevents scan_work from starting if it is
still pending. If scan_work is already running, disconnect proceeds to
cancel the URBs and call uas_zap_pending(), which completes the
remaining command with DID_NO_CONNECT.

The existing cancel_work_sync() is then called after that cleanup and
before scsi_remove_host() and resource release. Therefore the running
scan is still synchronized; the wait is moved after the operation
which allows the scan command to finish, rather than omitted.

Thanks,
Jiayi
