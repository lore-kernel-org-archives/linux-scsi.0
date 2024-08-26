Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A6F13D8B8
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2024 06:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724653540; cv=none; b=cenhfqNFflvQZb8okF8STLsyJ9z7ab/dEEJU+vPOn/6AqNgy7+sYtU1pci+DOilxSsR+konWZRqAzSgyNzez+46yreizcwqDLYywFX8sZs2CUnfwaYW52E4iwa7zss978461GBL3Vg4mhHd5xAhvdRMgN2w+JV9lAig83ikda6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724653540; c=relaxed/simple;
	bh=Kyxb3XRB9qny5CjLoAei3cEXcK+1j8EfD2Cpp7gL8zI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=G6yfqgjFcsCcWLECYiKsvRAwBLCTCGcHr45/DWHImftPyVhPq52iHbgg6SKc42b+XMk/hYp5+F7LZQ5EqDDynsUnZcw0Eyo8bdXQyXs3el2iwWfa7YXRehIL/McLnSOY2O82s4zQ5CLR9rgB0+R/AT3/nApU+ldYiq4lZTL26Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vk7o3yjt; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vk7o3yjt"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5a108354819so4978628a12.0
        for <linux-scsi@vger.kernel.org>; Sun, 25 Aug 2024 23:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724653537; x=1725258337; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VKDE8lqIxObfC+D7wdf8I4Vpc7UzyVZemX2pQ+G8N7U=;
        b=vk7o3yjt4pnhq8RBU+uXA6XFFhtyu061/KpqstDEGEvKJugX3UnZ4+XCQwrga1Qouz
         VvmGebqtcskzNm+a4o2wZbT+9LwWONNDSSQ9NTW3d+/QnL+SC1WKJiZeqcOw3CA/Q/7P
         kj8pHHtxpH/1UAvhqD+IdGUnyKpb4Rxy3fa87zFGuldXEXSvl0cUd/G484b4S/jst6sd
         WQon2T2yG0AdHoZROG4uWhkJnBliX322G6rilmBlgkNpn2bFUgIqB2+DuTPHpUgW2oYn
         PJTtemMU52FIBf6y23EtNI86isD9TWymoyG9kMLQJN4aMep2AYdakQtUqVWDlRkVZsx9
         lspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724653537; x=1725258337;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VKDE8lqIxObfC+D7wdf8I4Vpc7UzyVZemX2pQ+G8N7U=;
        b=cdfYhrE67NC+wKgVP3p/SHQ5d+NeKgUapAO7+mKH5RgnAQ9eDtZ5X9QaomuDHJUIm/
         78MlV+7ULY2R2tqEsDJ9LguzQ3LWysVk5LqYAugklQqn/izLObNQEStGAOoL02yAc+0u
         9R4FY2hQU/7h/oUwC5P3vFlxRN6+j3xvhTjWoWmRnTCA3tjByRa+TWPkNCk2NHcQySxC
         mI8NOz6U/6Dh3/waV8tQi5+V/e37LrGlr2aO8YnnuuQE/I0L2wVlkpuFmx0EKyF2Y3WT
         IFXkIRCeMya7cyoa+R6XxoAU50dMT5275cqFNdoAOzX8bq8jUdDgNvMcuykpTdlb/lf9
         OUIw==
X-Forwarded-Encrypted: i=1; AJvYcCUR8NqB+He90mi74DL6QJLn4aMBlDxdgK9b/L4fDTQ4CK3s6BrrityUetZx9UH3QU7kHduheWPNnu7J@vger.kernel.org
X-Gm-Message-State: AOJu0YygjEZ11XriIxsLAMY5RkqmUqKsppNMp+gvbgC4GHe+Hwl/wzjB
	e+Cdbx0dVxHkOKKtRuLSRXWghvD7XLLm22SGB/otgVSw6cidsLYVqxjeB1ysGS4=
X-Google-Smtp-Source: AGHT+IG/w8UHs/xfUMPq/NvtL3L02uVeTkqWsJE3WC9fIQKCPLm6xQgAbVr7mHIK83LQON3VnSTPwQ==
X-Received: by 2002:a17:906:da88:b0:a86:799d:f8d1 with SMTP id a640c23a62f3a-a86a54a991cmr725969866b.47.1724653536994;
        Sun, 25 Aug 2024 23:25:36 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f437971sm628603166b.142.2024.08.25.23.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 23:25:36 -0700 (PDT)
Date: Mon, 26 Aug 2024 09:25:31 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier
 to read
Message-ID: <2d3d17c7-c3f9-4596-aa50-3226163242eb@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821182923.145631-2-bvanassche@acm.org>

Hi Bart,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bart-Van-Assche/scsi-ufs-core-Make-ufshcd_uic_cmd_compl-easier-to-read/20240822-023058
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240821182923.145631-2-bvanassche%40acm.org
patch subject: [PATCH 1/2] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to read
config: i386-randconfig-141-20240824 (https://download.01.org/0day-ci/archive/20240824/202408241736.p8Mxizp7-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202408241736.p8Mxizp7-lkp@intel.com/

New smatch warnings:
drivers/ufs/core/ufshcd.c:5484 ufshcd_uic_cmd_compl() error: we previously assumed 'cmd' could be null (see line 5474)

vim +/cmd +5484 drivers/ufs/core/ufshcd.c

9333d77573485c drivers/scsi/ufs/ufshcd.c Venkat Gopalakrishnan 2019-11-14  5464  static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
6ccf44fe4cd7c4 drivers/scsi/ufs/ufshcd.c Seungwon Jeon         2013-06-26  5465  {
9333d77573485c drivers/scsi/ufs/ufshcd.c Venkat Gopalakrishnan 2019-11-14  5466  	irqreturn_t retval = IRQ_NONE;
71779e69ba68be drivers/ufs/core/ufshcd.c Bart Van Assche       2024-08-21  5467  	struct uic_command *cmd;
9333d77573485c drivers/scsi/ufs/ufshcd.c Venkat Gopalakrishnan 2019-11-14  5468  
a45f937110fa6b drivers/scsi/ufs/ufshcd.c Can Guo               2021-05-24  5469  	spin_lock(hba->host->host_lock);
71779e69ba68be drivers/ufs/core/ufshcd.c Bart Van Assche       2024-08-21  5470  	cmd = hba->active_uic_cmd;
a45f937110fa6b drivers/scsi/ufs/ufshcd.c Can Guo               2021-05-24  5471  	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
a45f937110fa6b drivers/scsi/ufs/ufshcd.c Can Guo               2021-05-24  5472  		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
a45f937110fa6b drivers/scsi/ufs/ufshcd.c Can Guo               2021-05-24  5473  
71779e69ba68be drivers/ufs/core/ufshcd.c Bart Van Assche       2024-08-21 @5474  	if (intr_status & UIC_COMMAND_COMPL && cmd) {
                                                                                                                               ^^^
cmd checked for NULL here

71779e69ba68be drivers/ufs/core/ufshcd.c Bart Van Assche       2024-08-21  5475  		cmd->argument2 |= ufshcd_get_uic_cmd_result(hba);
71779e69ba68be drivers/ufs/core/ufshcd.c Bart Van Assche       2024-08-21  5476  		cmd->argument3 = ufshcd_get_dme_attr_val(hba);
0f52fcb99ea273 drivers/scsi/ufs/ufshcd.c Can Guo               2020-11-02  5477  		if (!hba->uic_async_done)
71779e69ba68be drivers/ufs/core/ufshcd.c Bart Van Assche       2024-08-21  5478  			cmd->cmd_active = 0;
71779e69ba68be drivers/ufs/core/ufshcd.c Bart Van Assche       2024-08-21  5479  		complete(&cmd->done);
9333d77573485c drivers/scsi/ufs/ufshcd.c Venkat Gopalakrishnan 2019-11-14  5480  		retval = IRQ_HANDLED;
6ccf44fe4cd7c4 drivers/scsi/ufs/ufshcd.c Seungwon Jeon         2013-06-26  5481  	}
53b3d9c3fdda94 drivers/scsi/ufs/ufshcd.c Seungwon Jeon         2013-08-31  5482  
71779e69ba68be drivers/ufs/core/ufshcd.c Bart Van Assche       2024-08-21  5483  	if (intr_status & UFSHCD_UIC_PWR_MASK && hba->uic_async_done) {
71779e69ba68be drivers/ufs/core/ufshcd.c Bart Van Assche       2024-08-21 @5484  		cmd->cmd_active = 0;

Not checked here.  It could be be that when UFSHCD_UIC_PWR_MASK is set that
means cmd is valid?

57d104c153d3d6 drivers/scsi/ufs/ufshcd.c Subhash Jadavani      2014-09-25  5485  		complete(hba->uic_async_done);
9333d77573485c drivers/scsi/ufs/ufshcd.c Venkat Gopalakrishnan 2019-11-14  5486  		retval = IRQ_HANDLED;
9333d77573485c drivers/scsi/ufs/ufshcd.c Venkat Gopalakrishnan 2019-11-14  5487  	}
aa5c697988b4c7 drivers/scsi/ufs/ufshcd.c Stanley Chu           2020-06-15  5488  
aa5c697988b4c7 drivers/scsi/ufs/ufshcd.c Stanley Chu           2020-06-15  5489  	if (retval == IRQ_HANDLED)
71779e69ba68be drivers/ufs/core/ufshcd.c Bart Van Assche       2024-08-21  5490  		ufshcd_add_uic_command_trace(hba, cmd, UFS_CMD_COMP);
                                                                                                                                  ^^^
cmd is not checked for NULL inside this function but it's not dereferenced on
every path either.

a45f937110fa6b drivers/scsi/ufs/ufshcd.c Can Guo               2021-05-24  5491  	spin_unlock(hba->host->host_lock);
9333d77573485c drivers/scsi/ufs/ufshcd.c Venkat Gopalakrishnan 2019-11-14  5492  	return retval;
6ccf44fe4cd7c4 drivers/scsi/ufs/ufshcd.c Seungwon Jeon         2013-06-26  5493  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

