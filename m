Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A4120C023
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 12:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759927802; cv=pass; b=BBA5rCUEpcTFZL6ezgsPiWvrz/FEPpzJkgUCbm3xDlkR0RCLQ14yXQ4LlZncFWuvW00yH2pOtmIqN9gUbUYj03vW7xZKheMqMbmBs0DeJOCwCHAaQghzBjfgZe29mAiyMRwOzzYt3LwLkFhSnqo8bkuiS6zdI3lR3+j3kIrIUQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759927802; c=relaxed/simple;
	bh=86LeVZqUMDCPqcayTtleHC+BsNU1cMntipizGt0Wkf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqQkeGSaKbj2FWvJr6hfac3X+G9gEHtSSVhNaVuG7r+dTM/NNREK7CrcCHjAIW4CP/7psA+2l1+0rYujvy9kCjHVdMcUZyREu2NYsB5zAFJ3vqQqURnfei9zKsHTJrYbXUiWdlJdjRCvbx+DT7mHIr5w+Vc8yuwKp+G2iCyq5xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=sebastian.reichel@collabora.com header.b=UP5ZgToN; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=sebastian.reichel@collabora.com header.b="UP5ZgToN"
ARC-Seal: i=1; a=rsa-sha256; t=1759927776; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=KdeOqQBy1s/rXDOxVKE/EpMT7YUxpRQgth+lGCzGWxz1KrncHCtI2m6sMQEsYnq0qLDtgcVlRCd37w3XuWPd+5MzjIzoVXtfmYTHNuIUhan7FU+FzjukKWGtG2zS1vCJbZj4gj1aiydeCbCv0oFN1wxW12BjBQavn72Ati2jYlE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1759927776; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=pEIXafHhPnF6u0AUO9A/qOXV/dRlWW+OdRdhJfEgMDQ=; 
	b=bdENLcrjWdE0wAvNq84yxFP+k4jOK6zs0aIFF8Q5JB+RqTDyNpXu0wIk4zTEJNyKT5obT9+Ad9H0pXQ2eXxHckIhli4BL+X7YJBNwbe8WIscGgV77uqDavvf3pxaQjDFebqjTRuGlqx4s9avUqtTPqrR7jxTmWTwmcg+Vg8HxSs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=sebastian.reichel@collabora.com;
	dmarc=pass header.from=<sebastian.reichel@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1759927776;
	s=zohomail; d=collabora.com; i=sebastian.reichel@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=pEIXafHhPnF6u0AUO9A/qOXV/dRlWW+OdRdhJfEgMDQ=;
	b=UP5ZgToNwh9kJ0rTD+sVnNzoKBAI8drQ7jYDWuo0/C4vrpoQuLmwZ6hFw2jN9Yqt
	2OoRd1kFFFgAmRimkshwPujR9A+DkMVqMI4SIcoqbAAiDO1MSpFavE3p4JqSPWJSVb1
	Wkx6gWyV4fjNmQWsvERzzhzaAbq89QT3kkCMXa34=
Received: by mx.zohomail.com with SMTPS id 1759927772766375.8601126489972;
	Wed, 8 Oct 2025 05:49:32 -0700 (PDT)
Received: by venus (Postfix, from userid 1000)
	id 3A922182747; Wed, 08 Oct 2025 14:49:25 +0200 (CEST)
Date: Wed, 8 Oct 2025 14:49:25 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bvanassche@acm.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
Message-ID: <lrembxwyytccmsry2rztqtgglpgrbkdj6vjk7mmjtawxmodavx@mi7xfyemrvbl>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <CAFj5m9K1L7n3C9mL0zgNXmzhttD-B-64LBNbcp=HCPYPNvgjMg@mail.gmail.com>
 <aOX7krhcR7DB7T6a@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOX7krhcR7DB7T6a@infradead.org>
X-ZohoMailClient: External

Hi,

On Tue, Oct 07, 2025 at 10:50:10PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 08, 2025 at 11:17:18AM +0800, Ming Lei wrote:
> > Long term, the UFS driver need to be fixed, this or most of scsi core
> > APIs should
> > have been called after the scsi host is initialized.
> 
> Please fix ufs now.  Otherwise we'll be stuck with these hacks forever
> as they never get cleaned up.

The Rock 4D has a pluggable UFS module. UFS is described in the
system's device-tree, but the affected system itself does not
have a module plugged in resulting in UFS erroring out early.

To have an idea - the following is logged at error level because
no UFS module is plugged:

[    2.731721] ufshcd-rockchip 2a2d0000.ufshc: link startup failed 1
[    2.732311] ufshcd-rockchip 2a2d0000.ufshc: UFS Host state=0
[    2.732812] ufshcd-rockchip 2a2d0000.ufshc: 0 outstanding reqs, tasks=0x0
[    2.733410] ufshcd-rockchip 2a2d0000.ufshc: saved_err=0x0, saved_uic_err=0x0
[    2.734030] ufshcd-rockchip 2a2d0000.ufshc: Device power mode=1, UIC link state=0
[    2.734687] ufshcd-rockchip 2a2d0000.ufshc: PM in progress=0, sys. suspended=0
[    2.735320] ufshcd-rockchip 2a2d0000.ufshc: Auto BKOPS=0, Host self-block=0
[    2.735931] ufshcd-rockchip 2a2d0000.ufshc: Clk gate=0
[    2.736396] ufshcd-rockchip 2a2d0000.ufshc: last_hibern8_exit_tstamp at 0 us, hibern8_exit_cnt=0
[    2.737166] ufshcd-rockchip 2a2d0000.ufshc: error handling flags=0x0, req. abort count=0
[    2.737875] ufshcd-rockchip 2a2d0000.ufshc: hba->ufs_version=0x200, Host capabilities=0x187011f, caps=0x48c
[    2.738727] ufshcd-rockchip 2a2d0000.ufshc: quirks=0x2000, dev. quirks=0x0
[    2.739349] host_regs: 00000000: 0187011f 00000000 00000200 00000000
[    2.739910] host_regs: 00000010: 00000000 000005e6 00000000 00000000
[    2.740480] host_regs: 00000020: 00000000 00000470 00000000 00000000
[    2.741039] host_regs: 00000030: 00000008 00000001 00000000 00000000
[    2.741598] host_regs: 00000040: 00000000 00000000 00000000 00000000
[    2.742156] host_regs: 00000050: 00000000 00000000 00000000 00000000
[    2.742715] host_regs: 00000060: 00000000 00000000 00000000 00000000
[    2.743273] host_regs: 00000070: 00000000 00000000 00000000 00000000
[    2.743831] host_regs: 00000080: 00000000 00000000 00000000 00000000
[    2.744398] host_regs: 00000090: 00000016 00000000 00000001 00000000
[    2.744959] ufshcd-rockchip 2a2d0000.ufshc: No record of pa_err
[    2.745480] ufshcd-rockchip 2a2d0000.ufshc: No record of dl_err
[    2.746000] ufshcd-rockchip 2a2d0000.ufshc: No record of nl_err
[    2.746520] ufshcd-rockchip 2a2d0000.ufshc: No record of tl_err
[    2.747040] ufshcd-rockchip 2a2d0000.ufshc: No record of dme_err
[    2.747568] ufshcd-rockchip 2a2d0000.ufshc: No record of auto_hibern8_err
[    2.748174] ufshcd-rockchip 2a2d0000.ufshc: No record of fatal_err
[    2.748716] ufshcd-rockchip 2a2d0000.ufshc: link_startup_fail[0] = 0x1 at 2731713 us
[    2.749398] ufshcd-rockchip 2a2d0000.ufshc: link_startup_fail: total cnt=1
[    2.750001] ufshcd-rockchip 2a2d0000.ufshc: No record of resume_fail
[    2.750559] ufshcd-rockchip 2a2d0000.ufshc: No record of suspend_fail
[    2.751125] ufshcd-rockchip 2a2d0000.ufshc: No record of wlun resume_fail
[    2.751721] ufshcd-rockchip 2a2d0000.ufshc: No record of wlun suspend_fail
[    2.752332] ufshcd-rockchip 2a2d0000.ufshc: dev_reset[0] = 0x0 at 2297266 us
[    2.752953] ufshcd-rockchip 2a2d0000.ufshc: dev_reset: total cnt=1
[    2.753497] ufshcd-rockchip 2a2d0000.ufshc: No record of host_reset
[    2.754047] ufshcd-rockchip 2a2d0000.ufshc: No record of task_abort
[    2.755475] ufshcd-rockchip 2a2d0000.ufshc: error 000000000dbbd97c: Initialization failed with error 1
[    2.756358] ufshcd-rockchip 2a2d0000.ufshc: error 000000000dbbd97c: ufshcd_pltfrm_init failed
[    2.757115] ufshcd-rockchip 2a2d0000.ufshc: probe with driver ufshcd-rockchip failed with error 1

I think the best solution would be to avoid this huge error print
in the first place for a completley missing device, but I haven't
checked the details.

Greetings,

-- Sebastian
