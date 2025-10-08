Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3120921FF38;
	Wed,  8 Oct 2025 20:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759954578; cv=none; b=pgzn6Rd5EqSAgSZqDQriBvWSHFejwMQQbXVlXBx6IsCRgsT+PbSztIppphFbOsC5+pA/za0QJda14aJcS3eINqS1xGuQwBlnriYmFjah3mjh9Z47hw/v0euw6bJG4uZprYO5YpAU+kWDJyJVtuDoS0wwqhNTd1YE8dsEB8ev2rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759954578; c=relaxed/simple;
	bh=uwSxdZv9Ob+PevyC0kIku41W4ZkK0UKL799zXUt6KRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GNPdSH0Zjl7tWDLxrJo6FJRtdNHs4pNi4pMaGdNPMEoro1YrfQPwMRT75QU03Ap6MQurx/y9xxuQe/LUHWdMFG/ty2FwYGWJ3Wo5O7Rz9Mh+JWNvFRzJk1GeycygNBOjqKYXuKuf/nqIQApK5Qq6ZaDAaGEtfrMCN7Q/3Nyl1So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=B5/eH4Zt; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="B5/eH4Zt"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4chkmH0LXWzlgqVQ;
	Wed,  8 Oct 2025 20:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759954573; x=1762546574; bh=vCfVetI2+FcGiK2SYCLJ3lvr
	/jgoN7kswENSOY3EGO8=; b=B5/eH4Zt5ArQZGmt6J/Oea9YeyM9NA1yyb4pJIYD
	+LeLGIwm1azfeTOLoFHDEAVL0Z/KGetygRJpiHGsRQ78JR3PGB3kE91/K5AhGRnA
	iAMThgbjc/EG4EtzfvPyA2w5FuWfd/f5ruCrFlDgcngkvIddhd9tov+W63HIMuOj
	I3WXUCobmZvbGTA0NyT9n5s4xsdBeFxg843PgH4Z1c4oaZneCd33vtj99K4GId5y
	WCfzSsVsQ9FcYPmEH8igil2h9bNusllpzCDoeXIDNbiuFKxQdwZQV2ABn4oS4GUJ
	xcPAXb2My29PMVpHlgVuYP1/8tLCYCya5+re9nEjQRvU+w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Sr58_t9rTcg4; Wed,  8 Oct 2025 20:16:13 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4chkmB0RGbzlgqVY;
	Wed,  8 Oct 2025 20:16:09 +0000 (UTC)
Message-ID: <9147add6-303f-4ffe-95b6-9464d3a5f071@acm.org>
Date: Wed, 8 Oct 2025 13:16:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [scsi?] upstream test error: KMSAN: uninit-value in
 scsi_get_vpd_buf
To: syzbot <syzbot+a7b56f5926d90eaf5071@syzkaller.appspotmail.com>,
 James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 syzkaller-bugs@googlegroups.com
References: <68e6c0fe.050a0220.256323.00fd.GAE@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <68e6c0fe.050a0220.256323.00fd.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/25 12:52 PM, syzbot wrote:
> scsi 0:0:1:0: Direct-Access     Google   PersistentDisk   1    PQ: 0 ANSI: 6
> =====================================================
> BUG: KMSAN: uninit-value in scsi_vpd_inquiry drivers/scsi/scsi.c:323 [inline]
> BUG: KMSAN: uninit-value in scsi_get_vpd_buf+0x4cc/0x720 drivers/scsi/scsi.c:455
>   scsi_vpd_inquiry drivers/scsi/scsi.c:323 [inline]
>   scsi_get_vpd_buf+0x4cc/0x720 drivers/scsi/scsi.c:455
>   scsi_update_vpd_page drivers/scsi/scsi.c:479 [inline]
>   scsi_attach_vpd+0x380/0xe70 drivers/scsi/scsi.c:520
>   scsi_add_lun drivers/scsi/scsi_scan.c:1110 [inline]
>   scsi_probe_and_add_lun+0x6933/0x7f20 drivers/scsi/scsi_scan.c:1288
>   __scsi_scan_target+0x2fb/0x2050 drivers/scsi/scsi_scan.c:1776
>   scsi_scan_channel drivers/scsi/scsi_scan.c:1864 [inline]
>   scsi_scan_host_selected+0x68f/0x9a0 drivers/scsi/scsi_scan.c:1893
>   do_scsi_scan_host drivers/scsi/scsi_scan.c:2032 [inline]
>   do_scan_async+0x1ad/0xdc0 drivers/scsi/scsi_scan.c:2042
>   async_run_entry_fn+0x90/0x570 kernel/async.c:129
>   process_one_work kernel/workqueue.c:3263 [inline]
>   process_scheduled_works+0xb91/0x1d80 kernel/workqueue.c:3346
>   worker_thread+0xedf/0x1590 kernel/workqueue.c:3427
>   kthread+0xd59/0xf00 kernel/kthread.c:463
>   ret_from_fork+0x233/0x380 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Syzkaller team, does the above output perhaps indicate that the 
implementation of one of the VPD pages in the Google Persistent Disk
product is not compliant with the SCSI standard? Although it would be
easy to suppress the above complaint by zero-initializing VPD buffers
before submitting an INQUIRY command, I think the above complaint
indicates that the response to an INQUIRY command is shorter than four
bytes. The SCSI SPC standard requires that INQUIRY responses are at
least four bytes long if the EVPD bit has been set.

Thanks,

Bart.


