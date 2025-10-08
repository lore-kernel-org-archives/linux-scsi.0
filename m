Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDE12F60A4
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 15:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938544; cv=none; b=OuD1NnXwIKnrZPqvdHZa5QXmFoNXPiUAZ95gz9/t1uE6cyR5andL+RSRTerUFJuOqT7Zwu/6r5vdq/sOHkaI+MkHfQ0/I0aYYdbnU9HmliwCvkaB2YPUi60ugATI1Qh1/UyIv6IYUOby4MOMRhLVfZapdl9e1TGSM+iH54zmz/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938544; c=relaxed/simple;
	bh=HCwXqZfSUuu0LW3FAEKwBXopxzlSPDzO6BL7mRw93F4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H16tGRzce+GN8ybcdIxkaOccX4DTsM1gYALpf8hc7ZETQREo/UL9TU69BigxfEJv2yqozbyNR7sJ7FgzxLaE7MbFg62WbKwxyNkSNC+yVEoVWo1XlztAa3qAdLB00yWaVqkom2QRAWikqD8kGeIhhXbF/N9+l1kdC4u5RlKlkk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hB2LvhFl; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hB2LvhFl"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4chcqw2vwgzlgqTr;
	Wed,  8 Oct 2025 15:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759938538; x=1762530539; bh=29B7ZFk9zMpFwgJBoNrMRzhn
	PTyvN4nOakocrc/NEmM=; b=hB2LvhFlmTfR1TctPot2JIgFzW8GVFCegaKdWcOA
	LHVlV+aoS8ld9BdMdL+0vMr7V3dGRmG9KfAe6e8pOkgnr2KJRCiDJhdLlC3yV0V7
	6DvTDot9jYnOBfH5ByHyKqwiAFwOPpQkpNZoQtgxL7lYblEWa+3bVRNVNV9LfQul
	GTVuCFVlSXS4xwj7N1OLAUHKMWGZ+JW3OW/3TALbJmOr9mny9zwAuV17SEpLFnuk
	h59EQCbZiOLy4xp6xqEPLKWdYCMIOXDezR5PSSR79RjK42LC/1sli+T0XMy3MLEH
	TDGFU1xo45MaMRmuEgszYCRGi9UFJvN3Tmth5Rf8sh3GQA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hyOG8EjGmNKr; Wed,  8 Oct 2025 15:48:58 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4chcqp0Bn8zlgqVj;
	Wed,  8 Oct 2025 15:48:52 +0000 (UTC)
Message-ID: <4cbe3c31-12ec-4de3-99aa-56f7a6140440@acm.org>
Date: Wed, 8 Oct 2025 08:48:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
To: Sebastian Reichel <sebastian.reichel@collabora.com>,
 Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <CAFj5m9K1L7n3C9mL0zgNXmzhttD-B-64LBNbcp=HCPYPNvgjMg@mail.gmail.com>
 <aOX7krhcR7DB7T6a@infradead.org>
 <lrembxwyytccmsry2rztqtgglpgrbkdj6vjk7mmjtawxmodavx@mi7xfyemrvbl>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <lrembxwyytccmsry2rztqtgglpgrbkdj6vjk7mmjtawxmodavx@mi7xfyemrvbl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/25 5:49 AM, Sebastian Reichel wrote:
> The Rock 4D has a pluggable UFS module. UFS is described in the
> system's device-tree, but the affected system itself does not
> have a module plugged in resulting in UFS erroring out early.
> 
> To have an idea - the following is logged at error level because
> no UFS module is plugged:
> 
> [    2.731721] ufshcd-rockchip 2a2d0000.ufshc: link startup failed 1
> [    2.732311] ufshcd-rockchip 2a2d0000.ufshc: UFS Host state=0
> [    2.732812] ufshcd-rockchip 2a2d0000.ufshc: 0 outstanding reqs, tasks=0x0
> [    2.733410] ufshcd-rockchip 2a2d0000.ufshc: saved_err=0x0, saved_uic_err=0x0
> [    2.734030] ufshcd-rockchip 2a2d0000.ufshc: Device power mode=1, UIC link state=0
> [    2.734687] ufshcd-rockchip 2a2d0000.ufshc: PM in progress=0, sys. suspended=0
> [    2.735320] ufshcd-rockchip 2a2d0000.ufshc: Auto BKOPS=0, Host self-block=0
> [    2.735931] ufshcd-rockchip 2a2d0000.ufshc: Clk gate=0
> [    2.736396] ufshcd-rockchip 2a2d0000.ufshc: last_hibern8_exit_tstamp at 0 us, hibern8_exit_cnt=0
> [    2.737166] ufshcd-rockchip 2a2d0000.ufshc: error handling flags=0x0, req. abort count=0
> [    2.737875] ufshcd-rockchip 2a2d0000.ufshc: hba->ufs_version=0x200, Host capabilities=0x187011f, caps=0x48c
> [    2.738727] ufshcd-rockchip 2a2d0000.ufshc: quirks=0x2000, dev. quirks=0x0
> [    2.739349] host_regs: 00000000: 0187011f 00000000 00000200 00000000
> [    2.739910] host_regs: 00000010: 00000000 000005e6 00000000 00000000
> [    2.740480] host_regs: 00000020: 00000000 00000470 00000000 00000000
> [    2.741039] host_regs: 00000030: 00000008 00000001 00000000 00000000
> [    2.741598] host_regs: 00000040: 00000000 00000000 00000000 00000000
> [    2.742156] host_regs: 00000050: 00000000 00000000 00000000 00000000
> [    2.742715] host_regs: 00000060: 00000000 00000000 00000000 00000000
> [    2.743273] host_regs: 00000070: 00000000 00000000 00000000 00000000
> [    2.743831] host_regs: 00000080: 00000000 00000000 00000000 00000000
> [    2.744398] host_regs: 00000090: 00000016 00000000 00000001 00000000
> [    2.744959] ufshcd-rockchip 2a2d0000.ufshc: No record of pa_err
> [    2.745480] ufshcd-rockchip 2a2d0000.ufshc: No record of dl_err
> [    2.746000] ufshcd-rockchip 2a2d0000.ufshc: No record of nl_err
> [    2.746520] ufshcd-rockchip 2a2d0000.ufshc: No record of tl_err
> [    2.747040] ufshcd-rockchip 2a2d0000.ufshc: No record of dme_err
> [    2.747568] ufshcd-rockchip 2a2d0000.ufshc: No record of auto_hibern8_err
> [    2.748174] ufshcd-rockchip 2a2d0000.ufshc: No record of fatal_err
> [    2.748716] ufshcd-rockchip 2a2d0000.ufshc: link_startup_fail[0] = 0x1 at 2731713 us
> [    2.749398] ufshcd-rockchip 2a2d0000.ufshc: link_startup_fail: total cnt=1
> [    2.750001] ufshcd-rockchip 2a2d0000.ufshc: No record of resume_fail
> [    2.750559] ufshcd-rockchip 2a2d0000.ufshc: No record of suspend_fail
> [    2.751125] ufshcd-rockchip 2a2d0000.ufshc: No record of wlun resume_fail
> [    2.751721] ufshcd-rockchip 2a2d0000.ufshc: No record of wlun suspend_fail
> [    2.752332] ufshcd-rockchip 2a2d0000.ufshc: dev_reset[0] = 0x0 at 2297266 us
> [    2.752953] ufshcd-rockchip 2a2d0000.ufshc: dev_reset: total cnt=1
> [    2.753497] ufshcd-rockchip 2a2d0000.ufshc: No record of host_reset
> [    2.754047] ufshcd-rockchip 2a2d0000.ufshc: No record of task_abort
> [    2.755475] ufshcd-rockchip 2a2d0000.ufshc: error 000000000dbbd97c: Initialization failed with error 1
> [    2.756358] ufshcd-rockchip 2a2d0000.ufshc: error 000000000dbbd97c: ufshcd_pltfrm_init failed
> [    2.757115] ufshcd-rockchip 2a2d0000.ufshc: probe with driver ufshcd-rockchip failed with error 1
> 
> I think the best solution would be to avoid this huge error print
> in the first place for a completley missing device, but I haven't
> checked the details.
How about reducing link startup logging with the patch below?

Thanks,

Bart.


Subject: [PATCH] ufs: core: Reduce link startup failure logging

Some systems, e.g. Rock 4D, have a pluggable UFS module. Link startup
fails systematically on these systems. If no UFS module has been plugged
in, more than fourty lines are logged after the "link startup failed"
message. Avoid this by reducing link startup failure logging.

An intended side effect of this patch is that scsi_host_busy() is not
called before scsi_add_host() is called.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/ufs/core/ufshcd.c | 6 +-----
  1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6d1d853ec620..be4bf435da09 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5117,12 +5117,8 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
  	ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
  	ret = ufshcd_make_hba_operational(hba);
  out:
-	if (ret) {
+	if (ret)
  		dev_err(hba->dev, "link startup failed %d\n", ret);
-		ufshcd_print_host_state(hba);
-		ufshcd_print_pwr_info(hba);
-		ufshcd_print_evt_hist(hba);
-	}
  	return ret;
  }


