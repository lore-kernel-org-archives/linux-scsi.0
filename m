Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hMFYIX/p"
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028D69D
	for <linux-scsi@vger.kernel.org>; Wed, 22 Nov 2023 01:23:17 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2c887d1fb8fso30518691fa.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Nov 2023 01:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700644995; x=1701249795; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rhC1asTv/RX7QF9kMol6kJpFTRWUtwkcm7USZ02jYEQ=;
        b=hMFYIX/pMxKBRELz+4Cz7CHnF0Epx2S3JLcDnvr2tEYlI25mVOp4prfsvLcbPtYiNE
         MsSk6UeLp0J3g/BGxt8a1JiYoP+6WrBrR+n3XAwVZZSfezfRq6ekVAeStYcmCIaFBeLA
         kMGRxSodQTGeQJ9o4fy/6M+Cvil+azj8006kr/6GB+KpYAqgc/byxiY0Wk6Y66+zRU4Q
         0k8kDtoaGUWhTkRd6iY3KVtTRoC/lCFmWM+4qWaHb7HiNrH8UYg6dwKqGhB4V6ve4Ege
         01anrwtlc07Ggr5FqnoWDpOxFFU37FcRzYbi3H2FGw/xVLgZzW+OPp1CqQlYTSwHM22m
         hY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700644995; x=1701249795;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rhC1asTv/RX7QF9kMol6kJpFTRWUtwkcm7USZ02jYEQ=;
        b=Gg0X8WWppcRQcf+GPc3I0cO42lg2jYNKlfpkTvRxnz1fTER2jeh3FhIUMbtfBATE2c
         WNgFcbci8jlfiVl46lvxhmkjqyQN3aoTd6+xrbO1+SRFnZZneyGAYGaBP1CcZxUoOyjI
         bJ26rKQEhxSDr+Tk5C6SaHTe5IkDcKt4K4X4VFm7jDabqbmyx8dXrebZfMqcrvXxIGhQ
         vIexicogUvEjBSxH8FeVDp7JQdYz/gERdwqKRcC3rDe90wu+9ATQFKX6G7KtIzZ5+lD7
         6BZOUk1JprC4kxrdEM3IWqjDk8kmJJj5Y+TWHJds2qm1CYCLubkSQ1E6d9hiTt0oMhhE
         Kr0A==
X-Gm-Message-State: AOJu0YydjAeVHbSm2Zb5qrg9GwHUDLDe5TtZzoQU4xBW6ljOG+JbxaVT
	SnFzXqAIcmMu3GChetw174u6KA==
X-Google-Smtp-Source: AGHT+IFC9A4xkbgVPJSLpWSTZPDF0VLLciqEZwb/ASpE58NNXzwVw56OuwAKDW2H2DK7/NKV8m71bQ==
X-Received: by 2002:a05:651c:50c:b0:2c5:19ab:7270 with SMTP id o12-20020a05651c050c00b002c519ab7270mr1295603ljp.35.1700644995201;
        Wed, 22 Nov 2023 01:23:15 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c19c900b0040a4751efaasm1518204wmq.17.2023.11.22.01.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Nov 2023 01:23:14 -0800 (PST)
From: Dan Carpenter <dan.carpenter@linaro.org>
X-Google-Original-From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 22 Nov 2023 04:23:11 -0500
To: oe-kbuild@lists.linux.dev, SEO HOYOUNG <hy50.seo@samsung.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com,
	sh425.lee@samsung.com, sc.suh@samsung.com, quic_nguyenb@quicinc.com,
	cpgs@samsung.com, grant.jung@samsung.com, junwoo80.lee@samsung.com
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	SEO HOYOUNG <hy50.seo@samsung.com>
Subject: Re: [PATCH v3] scsi: ufs: core: fix racing issue during
 ufshcd_mcq_abort
Message-ID: <5cd4171c-d992-4e3c-96c7-91bb0ae9feb6@suswa.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231121071128.7743-1-hy50.seo@samsung.com>

Hi SEO,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/SEO-HOYOUNG/scsi-ufs-core-fix-racing-issue-during-ufshcd_mcq_abort/20231121-151923
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20231121071128.7743-1-hy50.seo%40samsung.com
patch subject: [PATCH v3] scsi: ufs: core: fix racing issue during ufshcd_mcq_abort
config: powerpc-randconfig-r071-20231122 (https://download.01.org/0day-ci/archive/20231122/202311220618.OnEhSic6-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 13.2.0
reproduce: (https://download.01.org/0day-ci/archive/20231122/202311220618.OnEhSic6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Closes: https://lore.kernel.org/r/202311220618.OnEhSic6-lkp@intel.com/

smatch warnings:
drivers/ufs/core/ufs-mcq.c:515 ufshcd_mcq_sq_cleanup() warn: variable dereferenced before check 'cmd' (see line 511)

vim +/cmd +515 drivers/ufs/core/ufs-mcq.c

8d7290348992f2 Bao D. Nguyen   2023-05-29  498  int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
8d7290348992f2 Bao D. Nguyen   2023-05-29  499  {
8d7290348992f2 Bao D. Nguyen   2023-05-29  500  	struct ufshcd_lrb *lrbp = &hba->lrb[task_tag];
8d7290348992f2 Bao D. Nguyen   2023-05-29  501  	struct scsi_cmnd *cmd = lrbp->cmd;
8d7290348992f2 Bao D. Nguyen   2023-05-29  502  	struct ufs_hw_queue *hwq;
8d7290348992f2 Bao D. Nguyen   2023-05-29  503  	void __iomem *reg, *opr_sqd_base;
8d7290348992f2 Bao D. Nguyen   2023-05-29  504  	u32 nexus, id, val;
8d7290348992f2 Bao D. Nguyen   2023-05-29  505  	int err;
8d7290348992f2 Bao D. Nguyen   2023-05-29  506  
aa9d5d0015a8b7 Po-Wen Kao      2023-06-12  507  	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
aa9d5d0015a8b7 Po-Wen Kao      2023-06-12  508  		return -ETIMEDOUT;
aa9d5d0015a8b7 Po-Wen Kao      2023-06-12  509  
5363c9d813101c SEO HOYOUNG     2023-11-21  510  	if (!ufshcd_cmd_inflight(cmd) ||
5363c9d813101c SEO HOYOUNG     2023-11-21 @511  	    test_bit(SCMD_STATE_COMPLETE, &cmd->state))
                                                                                          ^^^^^^^^^^^
The patch adds a new unchecked dereference

5363c9d813101c SEO HOYOUNG     2023-11-21  512  		return 0;
5363c9d813101c SEO HOYOUNG     2023-11-21  513  
8d7290348992f2 Bao D. Nguyen   2023-05-29  514  	if (task_tag != hba->nutrs - UFSHCD_NUM_RESERVED) {
8d7290348992f2 Bao D. Nguyen   2023-05-29 @515  		if (!cmd)
                                                                     ^^^
But the old code assumed "cmd" could be NULL

8d7290348992f2 Bao D. Nguyen   2023-05-29  516  			return -EINVAL;
8d7290348992f2 Bao D. Nguyen   2023-05-29  517  		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
8d7290348992f2 Bao D. Nguyen   2023-05-29  518  	} else {
8d7290348992f2 Bao D. Nguyen   2023-05-29  519  		hwq = hba->dev_cmd_queue;
8d7290348992f2 Bao D. Nguyen   2023-05-29  520  	}

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

