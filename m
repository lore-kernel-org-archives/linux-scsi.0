Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DABC450FE
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 20:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729543290; cv=none; b=r/qKdueCMODtbzG/r15w42tm+dWPxrJBl8lCIO8fMmwH4knh//Z3kwhzXy2PS9Z3ZoPNv6pjqfrdfG2t4BRCF7bBxwhCTSYgOWLd0dyMM2uPCIiepmEaF0NE2NGhfH/RLOFiZWU0K6jMT7vEOUfpSRA9+Nxc6fM1c+VZyLWmS+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729543290; c=relaxed/simple;
	bh=y8tAc2+uGWL+1iHWQpPHIofsXYRWVWqH4/By3bwXsbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qnB024LnK+UNaJ8K+1RBu8s0HMee2KWH/SH5cZeVNawNl4Szz384jPt6mEWkDc7P6N2EYKZT2I1WmOkH+/EtbgGefNVS5KsrHq//35lAqIObt0HvQney8ijhcdUpgS2Leu4rjPkjKIFz5zfT/CPujxkc5JFx4+bKEhg9GBDSG8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FqcImlic; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FqcImlic"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XXRzn5pCzz6ClY9Z;
	Mon, 21 Oct 2024 20:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729543283; x=1732135284; bh=DmoYXxwcI+pCUT0SM6tvDwew
	tvBGyMwxK8LpdMQG+y4=; b=FqcImlicTKJH5X1qFFqH1ZNpoV3Gj7ThKiaI+Wk4
	KzA0aeVv38c0KfqsIsLJ64+a41IjVwwPSrbyJZYoIwws/CcCUQo8JzS6Bnil+UZw
	B//kL/HST867xwWkC0YlEULiGnzCIaHrh4vAQ/yUdYoQGIN0o2x97luHSpDY6rcC
	rFQ++F59tjErVDfHBY1INeYM1EDKq19GL1cylh7cISwhg6Nk0XaX4CSn3FjHcXgU
	gu/J8i98BDEJJGHg1Fmi9+g0lUdPACfYYnft7pKMn+l1iyqfSslrPU5nFJXvVEkB
	HSqFiQM0/6GwhtkBZLW0sb2cxGbd3jwpM6gs+ITRwexMLw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pJzZS0aU8G14; Mon, 21 Oct 2024 20:41:23 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XXRzl0clMz6ClY9C;
	Mon, 21 Oct 2024 20:41:22 +0000 (UTC)
Message-ID: <dbd8fd89-57ca-403f-b47a-a3fce383d75f@acm.org>
Date: Mon, 21 Oct 2024 13:41:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] scsi: ufs: core: Simplify
 ufshcd_err_handling_prepare()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-6-bvanassche@acm.org>
 <37f935a047e05f001e1fa38f58d98abac4543ab0.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <37f935a047e05f001e1fa38f58d98abac4543ab0.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/21/24 2:43 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Using blk_mq_quiesce_tagset instead of ufshcd_scsi_block_requests
> could cause issues. After the patch below was merged, Mediatek
> received three cases of IO hang.
> 77691af484e2 ("scsi: ufs: core: Quiesce request queues before checking
> pending cmds")
> I think this patch might need to be reverted first.
>=20
> Here is backtrace of IO hang.
> ppid=3D3952 pid=3D3952 D cpu=3D6 prio=3D120 wait=3D188s kworker/u16:0
> 	vmlinux __synchronize_srcu() + 216
> </proc/self/cwd/common/kernel/rcu/srcutree.c:1386>
> 	vmlinux synchronize_srcu() + 276
> </proc/self/cwd/common/kernel/rcu/srcutree.c:0>
> 	vmlinux blk_mq_wait_quiesce_done() + 20
> </proc/self/cwd/common/block/blk-mq.c:226>
> 	vmlinux blk_mq_quiesce_tagset() + 156
> </proc/self/cwd/common/block/blk-mq.c:286>
> 	vmlinux ufshcd_clock_scaling_prepare(timeout_us=3D1000000) + 16
> </proc/self/cwd/common/drivers/ufs/core/ufshcd.c:1276>
> 	vmlinux ufshcd_devfreq_scale() + 52
> </proc/self/cwd/common/drivers/ufs/core/ufshcd.c:1322>
> 	vmlinux ufshcd_devfreq_target() + 384
> </proc/self/cwd/common/drivers/ufs/core/ufshcd.c:1440>
> 	vmlinux devfreq_set_target(flags=3D0) + 184
> </proc/self/cwd/common/drivers/devfreq/devfreq.c:363>
> 	vmlinux devfreq_update_target(freq=3D0) + 296
> </proc/self/cwd/common/drivers/devfreq/devfreq.c:429>
> 	vmlinux update_devfreq() + 8
> </proc/self/cwd/common/drivers/devfreq/devfreq.c:444>
> 	vmlinux devfreq_monitor() + 48
> </proc/self/cwd/common/drivers/devfreq/devfreq.c:460>
> 	vmlinux process_one_work() + 476
> </proc/self/cwd/common/kernel/workqueue.c:2643>
> 	vmlinux process_scheduled_works() + 580
> </proc/self/cwd/common/kernel/workqueue.c:2717>
> 	vmlinux worker_thread() + 576
> </proc/self/cwd/common/kernel/workqueue.c:2798>
> 	vmlinux kthread() + 272
> </proc/self/cwd/common/kernel/kthread.c:388>
> 	vmlinux 0xFFFFFFE239A164EC()
> </proc/self/cwd/common/arch/arm64/kernel/entry.S:846>

Hi Peter,

Thank you very much for having reported this hang early. Would it be
possible for you to test the patch below on top of this patch series?
I think the root cause of the hang that you reported is in the block
layer.

Thanks,

Bart.


diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7b02188feed5..7482e682deca 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -283,8 +283,9 @@ void blk_mq_quiesce_tagset(struct blk_mq_tag_set *set=
)
  		if (!blk_queue_skip_tagset_quiesce(q))
  			blk_mq_quiesce_queue_nowait(q);
  	}
-	blk_mq_wait_quiesce_done(set);
  	mutex_unlock(&set->tag_list_lock);
+
+	blk_mq_wait_quiesce_done(set);
  }
  EXPORT_SYMBOL_GPL(blk_mq_quiesce_tagset);


