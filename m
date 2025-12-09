Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0C42877DE
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 08:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765268053; cv=none; b=UioVSYW3gZMBOrZ8LEdPMxCX5+LT5NFIUMixr21K5oBw+zEptDARe0ZQOztwxslkz4qshaEq6X7WxP4tm0bT+pAdz+Egxkyz6hALSz/D2X1U8DHfsSz5yRU7Lv1ZMBh7E8TYOa1mtoZYMwHPXUYSLDvwLPjXxnjXB9UDtzcckFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765268053; c=relaxed/simple;
	bh=WiBPEAcucmMl3ncW6dEf8nzkpRo6LI+EWrYOZiB5vQM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=RS5kpQaPJIPeg67iu6ddqx7OduYgO7QtCka9vBjRSfjiQq0HxaHsZGIdFsb0+5DwL2bltl5Q+gzN7Uk+oPuxeHD2kwBMrCuEpTaVqNIrVuNVUAob9/3UD6KV5Lv1KIzKY3VutTfZ8eP5Wv8JOvHx3WLiQQiZMNcgJQOcIGuecRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sB+2AX0R; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sB+2AX0R"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-477a1c28778so67687685e9.3
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 00:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765268050; x=1765872850; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2wg2FYVkjXh5aCmoBNtOWAaU71M7u5F8AD88H/8BDxU=;
        b=sB+2AX0RG2gAwhNjrJuK9d4s2M8RJMBpR0tV9Njiv3bt6jDYUn91DYeJTIVCMGghbq
         DGAFBwiv39eVA6EJvukcw3kFqsxsmymTEGWbUo8OEWU4uIhPRiGSvrIjvuX+TiKZ9tFj
         oKiIioD1ex4mmYQfDvolwwIH8pYUIDrLCpL86UXWsbWudz6CWVHhQPRRZMhxWDTR02Bb
         aCiwaVzlp1SE5qqexCkv5PKQI2c+b8nNROAccDwHguXonBZeK7Pz0ufbPgOW4TtVzYKC
         vw07hmHMsqAt7EfuvZWVzq2KrMvKFuDeOMdLE3SauhQys3d6hiSI6HHCmu6sJxFWFpKc
         yWwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765268050; x=1765872850;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2wg2FYVkjXh5aCmoBNtOWAaU71M7u5F8AD88H/8BDxU=;
        b=WT0hiAulXhj5aalkCBMNW4Q0qpatTElIFI561U7TkAKJMRJCMCPRYgPpY7W+9EOXsT
         72Z6tn7TewQXhl2T9Y3fYGRa3XefQTySN3SeFPEBcG50wolgTHAcs+mY10p/O/ueJ8oE
         W8ahXfRbKN6nmrCYHWpIpRZ0wU+S9tcJA9D/SZJVol+QOPpV77+sFge5ktH08jEVF8w7
         pcqgMnooOFs3uZ7cbKl1yNpCM3f4QSkWHRP3YFQUTAWW80GX10YrAc1nOYnvNCgMNsKn
         2T2CcGy0wKolri4zRK+25MLLOZeZaHsrxfCmX/oW34cLrgXWbcjFZ84vFQPwbUBFqqVb
         vRhw==
X-Forwarded-Encrypted: i=1; AJvYcCUFhUAl4vXYolv2r0QrXKbqVRWuwhoqi7AubGsywGZziHq+OiUnzhnLA+aUZBkx3ki48Lm6yXrmgS9K@vger.kernel.org
X-Gm-Message-State: AOJu0YxIweJT6U+YQHEU+hsa8Rbb00HXXn4tcJDydrRWmt3gFpjmQmJ4
	VNhi3o+ug0mqbsvn3ExE3PFLabpuAsgkDFG+01cT/KK+rmmkjJ5vwr+A94IAyZG9C2o=
X-Gm-Gg: ASbGncuEZObwjD3p+pip0nbdEWkFg/YQXaQabIQ1XH0TbFSPrkbwbNrKNji/MOOUNIQ
	Bu4SAMiHDKskSzf+AsE7zcSjT1HzNbfdPETkuW/1AnN75yjl0n5wc4pHvGSOlwGRt6UBuvAH/kQ
	lJ603f45MG8sXl1GAavjOm0LjNjnXHnguGb8nRMnh9VlEWoTWX4f9evYm66PKhOOTdtle0ZB/VV
	R5G/+HWa+jr0gad9ZP8oMYrDbuQyqCsqevr2yYnYbLuGNmUm9ZDZMv/0g7Fa0atTJhvIMrbMeZS
	nX3BHWE3cgwYvQngvTZRMUqxp6I9m3qRA8VeDYT3bNt0nFATTgr5ysh31v5aifRxi5PuUrRFH/o
	p5bQA94UvK+6lO4d9oOUF6DXW5GwnXmQwoK0pU/4ci+OxBew1LY0ERTUZMQVpZLjQdhz7FCLitq
	vqIHoFVzjcjzae+7WL
X-Google-Smtp-Source: AGHT+IEGfnb47BXL7kWT0jK9JS/OOmv6K3jMn7E9kJktQltZ1yjZ9wYvRbNvP+vsFqiJo5afmlDv5A==
X-Received: by 2002:a05:600c:4446:b0:477:b0b9:3131 with SMTP id 5b1f17b1804b1-47939df7d12mr107620625e9.8.1765268049577;
        Tue, 09 Dec 2025 00:14:09 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a7d632cebsm27773675e9.7.2025.12.09.00.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 00:14:09 -0800 (PST)
Date: Tue, 9 Dec 2025 11:14:05 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Nilesh Javali <njavali@marvell.com>,
	martin.petersen@oracle.com
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
	agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
	jmeneghi@redhat.com
Subject: Re: [PATCH v2 07/12] qla2xxx: Delay module unload while fabric scan
 in progress
Message-ID: <202512090414.07Waorz0-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204151751.2321801-8-njavali@marvell.com>

Hi Nilesh,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Nilesh-Javali/qla2xxx-Add-Speed-in-SFP-print-information/20251204-233117
base:   e6965188f84a7883e6a0d3448e86b0cf29b24dfc
patch link:    https://lore.kernel.org/r/20251204151751.2321801-8-njavali%40marvell.com
patch subject: [PATCH v2 07/12] qla2xxx: Delay module unload while fabric scan in progress
config: x86_64-randconfig-r072-20251208 (https://download.01.org/0day-ci/archive/20251209/202512090414.07Waorz0-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202512090414.07Waorz0-lkp@intel.com/

New smatch warnings:
drivers/scsi/qla2xxx/qla_os.c:1187 qla2x00_wait_for_hba_ready() warn: if statement not indented
drivers/scsi/qla2xxx/qla_os.c:1189 qla2x00_wait_for_hba_ready() warn: inconsistent indenting

Old smatch warnings:
drivers/scsi/qla2xxx/qla_os.c:4249 qla2x00_mem_alloc() warn: missing unwind goto?

vim +1187 drivers/scsi/qla2xxx/qla_os.c

638a1a01d36a14 Sawan Chandak    2014-04-11  1176  static void
638a1a01d36a14 Sawan Chandak    2014-04-11  1177  qla2x00_wait_for_hba_ready(scsi_qla_host_t *vha)
86fbee86e94c7e Lalit Chandivade 2010-05-04  1178  {
86fbee86e94c7e Lalit Chandivade 2010-05-04  1179  	struct qla_hw_data *ha = vha->hw;
783e0dc4f66ade Sawan Chandak    2016-07-06  1180  	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
86fbee86e94c7e Lalit Chandivade 2010-05-04  1181  
1d48390117c7df Dan Carpenter    2016-08-03  1182  	while ((qla2x00_reset_active(vha) || ha->dpc_active ||
9d35894d338abc Sawan Chandak    2014-09-25  1183  		ha->flags.mbox_busy) ||
9d35894d338abc Sawan Chandak    2014-09-25  1184  	       test_bit(FX00_RESET_RECOVERY, &vha->dpc_flags) ||
cedcf9d7bcbe3a Anil Gurumurthy  2025-12-04  1185  	       test_bit(FX00_TARGET_SCAN, &vha->dpc_flags) ||
cedcf9d7bcbe3a Anil Gurumurthy  2025-12-04  1186  		(vha->scan.scan_flags & SF_SCANNING)) {
783e0dc4f66ade Sawan Chandak    2016-07-06 @1187  			if (test_bit(UNLOADING, &base_vha->dpc_flags))

This if statement is indented too far.

783e0dc4f66ade Sawan Chandak    2016-07-06  1188  			break;
86fbee86e94c7e Lalit Chandivade 2010-05-04 @1189  		msleep(1000);
86fbee86e94c7e Lalit Chandivade 2010-05-04  1190  	}
783e0dc4f66ade Sawan Chandak    2016-07-06  1191  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

