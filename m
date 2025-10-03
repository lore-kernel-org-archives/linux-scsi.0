Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A2126E6F3
	for <linux-scsi@vger.kernel.org>; Fri,  3 Oct 2025 08:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759480840; cv=none; b=txcu+SZAC+cuy5q3H1duveBQr5V+56hNZha5vD4BnAO/MVWRvbC6CG5FDc3eLTUApwFa5BHrSng5Bxies83GQdT1RfX9wK6W13hdNlHIY+fmwG+oc+VA/sDbE6nAz4ShGzlNp4rImdBkE8aMjePSpkQK6hKtnqwpaaVKFp1DA2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759480840; c=relaxed/simple;
	bh=TFNuXojUxQ5sowkUWUwt/Zu4E1KP3EXf4UKwN5nr/50=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=s1Nc/uWA0dxcBhmBBXNAnq60Qc1mETEKmiDAHe4b/AERW7Hr77GjFFnVRf6GsWQFOxhemcbMr9AWEtCJnLPzZtKOTPWfHjUlew+TuZzCh0jY2CRqM47Z4nY21UvZgI7zg0vyPBgP5z8h3PSHm503a9pu1b85uybZBVQcTSCvt6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SBlvPCnt; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SBlvPCnt"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3f0ae439b56so1268741f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Oct 2025 01:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759480837; x=1760085637; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cio2lKvCKgwpMaSFyqyjcKvDHCLeYNpkbQFBjUDPl20=;
        b=SBlvPCntmLN/DwWuyu63Uo0ZEy32iPg2Hfqtx7bsAhr1F0JeKgdghkpLJY7nHxPCp3
         DWn3ecYs/fwFZGziPH6DFzf1qsTwfFyztEiMCq3ORoFsiFPeVomzL9vtNwgiWDap1Ju8
         8u43obXZjxFWnEP6fPGTlnsS9nMnQct0JEOcNA7oWNsAhd3mlEuf+bF37c6jiLvXwLCC
         CN2fJQ6KK0mqaIwNpw0jhYwjn7vHK7XB65z1a0NU0BzIRzjOLVmLqtg+TQ4K6TtlwOYW
         XGmvpZT4ytWokzDH7BqXKx++Dke5xOvOKR6T7fIKH+lvbesA5cAmeQtqZKNkb7uVB0bs
         I/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759480837; x=1760085637;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cio2lKvCKgwpMaSFyqyjcKvDHCLeYNpkbQFBjUDPl20=;
        b=UtXay8kBMVKAxJYpqHXJMEkgR3eAaGy6lPnCi32omMaFcpBEi8UaFjZRdQV6LXZDSD
         ncULTm0D56ApaZXjJ80pbW+i5eH0aYWN4vRxQH8WjUQee3mIdjzCEALbyjH/DO5rzfGR
         EgBT1yzDRDclqvUDdLYOn+0k/KZUT+VRT+c+RoVn62+cioN0TwQLnc+luM1TVRwhGphX
         CEMcs/R4nOQFyaQIQQ2RZfiNdO7ofuc49pqqAHfOX2kOwA3XgP4Ybxo0VLSm97DZvZi9
         d67gVyhFWUvLuUhi9eH2AuaDxOALpWOT9uiSwTdd0hL4MR/nH7J4s02v2GYu8aDIGmD2
         pTQw==
X-Forwarded-Encrypted: i=1; AJvYcCX7vLIlaTcGmQBeolF+3L8aYg0pZMMZbtD+8l8ifg16IQDeOwuHugRTIKVv5xc1x9kkSIPmcnSZZDRc@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2QsQroSf5BlbsgMsk4VMXa5XUdrEJEpqMH17p/XGnK664KJTZ
	+2YCSZogNXFGVIWED1PDQw1Y5/uef3qc+CVyIaeTHgvn13QYDoJSkTyWXbVvUSOscy0=
X-Gm-Gg: ASbGncsZoHdgyqfajxAxgtnRmlPhvnS4y0QhIU/XxPiUjs65Xnybzs3d7d0MS0dFT6o
	oIFqCrfCSi6YnpQd41ku2obRiSsg36hBTR7ctOsaSFe/jrEZO4x1p75FXdsPUrEJIebKIfF/qoo
	+kvFZUaiDowiJgJACAAIMVe5Meo2dY1WzUjIsyt9mvVAoOtnLqtJyYaYvPQuULaiJX6WLAibtBH
	V3ACnLW/2Yhyt0BEQBq1tML02wtsDXb1lsT3070A7EprROgjnkUh4+HSOK+9gufc27Urogl5V/e
	y7svaH017WpnhrLolA9FMsxB0wEWCVdmXRNUTNTPWEqgW2JW0cHlapVpLRzehER8NwG3+v/AXRx
	dHnGEBTmQH+afSWkqq1OM4VsWqrIfluxfQ8NFJLVRHwoUOZ/GPyV49MA3
X-Google-Smtp-Source: AGHT+IGFZM0FLnmzxxN+Lk4wUetj5MlaFNlOjNUzYIpmA97eR6LNDB8/moRk0p2yC0M/4i827Faq9Q==
X-Received: by 2002:a5d:5f94:0:b0:3ee:15b4:174c with SMTP id ffacd0b85a97d-42567159241mr1462331f8f.3.1759480836867;
        Fri, 03 Oct 2025 01:40:36 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4255d8a8542sm6954756f8f.9.2025.10.03.01.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 01:40:36 -0700 (PDT)
Date: Fri, 3 Oct 2025 11:40:33 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Tony Battersby <tonyb@cybernetics.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-scsi <linux-scsi@vger.kernel.org>,
	target-devel@vger.kernel.org, scst-devel@lists.sourceforge.net,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v2 11/16] scsi: qla2xxx: fix TMR failure handling
Message-ID: <202510031227.18psESZQ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f52cda16-4952-4b28-bbf7-d44f4e054490@cybernetics.com>

Hi Tony,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Tony-Battersby/Revert-scsi-qla2xxx-Perform-lockless-command-completion-in-abort-path/20250930-024814
base:   e5f0a698b34ed76002dc5cff3804a61c80233a7a
patch link:    https://lore.kernel.org/r/f52cda16-4952-4b28-bbf7-d44f4e054490%40cybernetics.com
patch subject: [PATCH v2 11/16] scsi: qla2xxx: fix TMR failure handling
config: i386-randconfig-141-20251002 (https://download.01.org/0day-ci/archive/20251003/202510031227.18psESZQ-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202510031227.18psESZQ-lkp@intel.com/

New smatch warnings:
drivers/scsi/qla2xxx/qla_target.c:5735 qlt_handle_abts_completion() error: we previously assumed 'mcmd' could be null (see line 5723)

Old smatch warnings:
drivers/scsi/qla2xxx/qla_target.c:671 qla24xx_delete_sess_fn() warn: can 'fcport' even be NULL?

vim +/mcmd +5735 drivers/scsi/qla2xxx/qla_target.c

6b0431d6fa20bd1 Quinn Tran      2018-09-04  5706  static void qlt_handle_abts_completion(struct scsi_qla_host *vha,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5707  	struct rsp_que *rsp, response_t *pkt)
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5708  {
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5709  	struct abts_resp_from_24xx_fw *entry =
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5710  		(struct abts_resp_from_24xx_fw *)pkt;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5711  	u32 h = pkt->handle & ~QLA_TGT_HANDLE_MASK;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5712  	struct qla_tgt_mgmt_cmd *mcmd;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5713  	struct qla_hw_data *ha = vha->hw;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5714  
81bcf1c5cf0ee87 Bart Van Assche 2019-04-11  5715  	mcmd = qlt_ctio_to_cmd(vha, rsp, pkt->handle, pkt);
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5716  	if (mcmd == NULL && h != QLA_TGT_SKIP_HANDLE) {
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5717  		ql_dbg(ql_dbg_async, vha, 0xe064,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5718  		    "qla_target(%d): ABTS Comp without mcmd\n",
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5719  		    vha->vp_idx);
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5720  		return;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5721  	}
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5722  
6b0431d6fa20bd1 Quinn Tran      2018-09-04 @5723  	if (mcmd)
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5724  		vha  = mcmd->vha;

mcmd can be NULL

6b0431d6fa20bd1 Quinn Tran      2018-09-04  5725  	vha->vha_tgt.qla_tgt->abts_resp_expected--;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5726  
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5727  	ql_dbg(ql_dbg_tgt, vha, 0xe038,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5728  	    "ABTS_RESP_24XX: compl_status %x\n",
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5729  	    entry->compl_status);
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5730  
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5731  	if (le16_to_cpu(entry->compl_status) != ABTS_RESP_COMPL_SUCCESS) {
7ffa5b939751b66 Bart Van Assche 2020-05-18  5732  		if (le32_to_cpu(entry->error_subcode1) == 0x1E &&
7ffa5b939751b66 Bart Van Assche 2020-05-18  5733  		    le32_to_cpu(entry->error_subcode2) == 0) {
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5734  			if (qlt_chk_unresolv_exchg(vha, rsp->qpair, entry)) {
74dabbbd8bb833e Tony Battersby  2025-09-29 @5735  				qlt_free_ul_mcmd(ha, mcmd);
                                                                                                     ^^^^
But here it is dereferenced without checking.  Previously it called
tcm_qla2xxx_free_mcmd() which checks for NULL.

6b0431d6fa20bd1 Quinn Tran      2018-09-04  5736  				return;
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5737  			}
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5738  			qlt_24xx_retry_term_exchange(vha, rsp->qpair,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5739  			    pkt, mcmd);
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5740  		} else {
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5741  			ql_dbg(ql_dbg_tgt, vha, 0xe063,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5742  			    "qla_target(%d): ABTS_RESP_24XX failed %x (subcode %x:%x)",
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5743  			    vha->vp_idx, entry->compl_status,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5744  			    entry->error_subcode1,
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5745  			    entry->error_subcode2);
74dabbbd8bb833e Tony Battersby  2025-09-29  5746  			qlt_free_ul_mcmd(ha, mcmd);
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5747  		}
e752a04e1bd14cc Bart Van Assche 2019-08-08  5748  	} else if (mcmd) {
74dabbbd8bb833e Tony Battersby  2025-09-29  5749  		qlt_free_ul_mcmd(ha, mcmd);
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5750  	}
6b0431d6fa20bd1 Quinn Tran      2018-09-04  5751  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

