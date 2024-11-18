Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2211E1301;
	Mon, 18 Nov 2024 19:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731958054; cv=none; b=CAP/bq9+Jc1xCXtkrtIyEAbUR7h7cUsXVS+RrRWCw9PvNORN6/Hw+78BkQFcUEKGD25aqsWcov2l6jot5sJOaZ/VDpgJnDwhp/Tsy0IHlD3+liZDs+MSY1zC3ftghS9DpIlUIuA1ma+wlzyaP4GidT4Ww4jFinQhbeXHLdAdY9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731958054; c=relaxed/simple;
	bh=RcPIYbyMlZ34oP2LBXyEIbCgPpT3+dQrSy/cfQ6AqU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DCNUbhp6CxC6mKttYIXFUIhGYAMD8b370NvR8iUIQMVpwVs7xeOD6Dvxch0e2QxJy8rolGntL8rGxwkskcxFDopFywKtpy0ixtjUFhlGjCFPjXQS/dQgq0kNAw4itOFtkOHobBhwaWtpn7flCnfuecT9T7ZotjpJToAvCSGhftw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WXiN559Z; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WXiN559Z"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xsd1T6y26zlgVXv;
	Mon, 18 Nov 2024 19:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1731958042; x=1734550043; bh=pJOpEX/ldT1R99usUkIIxpTX
	afIC3dd1RVWEnQ/TPLU=; b=WXiN559ZnZZDMueOh0xvD2n/D9hm0No2wx1qNojw
	DlY2a3a5XW+0RMKwVM9VQaTdcsHa8k5l8UFXJPCe6aXGD+ECURHliJmvrtlZJ3Yx
	/kbkQzUMahEKbHcNMHHpjx02omMgbRI/epYuQI8pQeRjhiGfCVrnci7m2+H4OOfL
	iWaYXjy/DtHVhbBiYWB9VL5jf6geb+HUFTxaDA5fE8+m2uCJ9HyGk0oIx72Xb9+0
	c4CQGSOsdj/msK/lOpPQuliDBFIdQLbraEIDRk9SGW4viISdmLeHye9dtRy77Qk6
	46rs/eO2mf3bhCmSSlmEcXPxfrJ/Xp11eFugm32Mjm0M3g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fOWhWX0pm2FQ; Mon, 18 Nov 2024 19:27:22 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xsd1P3mYJzlgTWQ;
	Mon, 18 Nov 2024 19:27:20 +0000 (UTC)
Message-ID: <6bc47ad5-e815-46c4-b689-3e2cdcea16ea@acm.org>
Date: Mon, 18 Nov 2024 11:27:17 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [scsi?] [usb?] KASAN: slab-use-after-free Read in
 sg_release
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-usb@vger.kernel.org
References: <6737dd3b.050a0220.85a0.0005.GAE@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6737dd3b.050a0220.85a0.0005.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/24 3:46 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> KASAN: slab-use-after-free Read in sg_release
> 
> ==================================================================
> BUG: KASAN: slab-use-after-free in sg_device_destroy+0x57/0x180 drivers/scsi/sg.c:1572
> Read of size 8 at addr ffff888034a06008 by task syz.3.47/7437
> 
> CPU: 1 UID: 0 PID: 7437 Comm: syz.3.47 Not tainted 6.12.0-rc1-syzkaller-00116-g9024d215a5d3 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:94 [inline]
>   dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>   print_address_description mm/kasan/report.c:377 [inline]
>   print_report+0x169/0x550 mm/kasan/report.c:488
>   kasan_report+0x143/0x180 mm/kasan/report.c:601
>   sg_device_destroy+0x57/0x180 drivers/scsi/sg.c:1572
>   kref_put include/linux/kref.h:65 [inline]
>   sg_release+0x274/0x3c0 drivers/scsi/sg.c:404
>   __fput+0x23f/0x880 fs/file_table.c:431
>   task_work_run+0x24f/0x310 kernel/task_work.c:228
>   resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>   exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
>   exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>   syscall_exit_to_user_mode+0x168/0x370 kernel/entry/common.c:218
>   do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f

The above output shows that the tested patch postponed the use-after-
free from the mutex_unlock() call in sg_release to the code that I
inserted after that call. This is the patch that has been tested:

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 84334ab39c81..6c6e03f37b5f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -385,6 +385,8 @@ sg_release(struct inode *inode, struct file *filp)
  		return -ENXIO;
  	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp, "sg_release\n"));

+	kref_get(&sdp->d_ref);
+
  	mutex_lock(&sdp->open_rel_lock);
  	kref_put(&sfp->f_ref, sg_remove_sfp);
  	sdp->open_cnt--;
@@ -398,6 +400,9 @@ sg_release(struct inode *inode, struct file *filp)
  		wake_up_interruptible(&sdp->open_wait);
  	}
  	mutex_unlock(&sdp->open_rel_lock);
+
+	kref_put(&sdp->d_ref, sg_device_destroy);
+
  	return 0;
  }


