Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86381953A9;
	Sat, 12 Oct 2024 14:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728744131; cv=none; b=H7vS4PmjZlub5hW6R2tLWDA5N9LbtR05ykhz3Ao5lwwpWEQK85WukeffYjuon0vEWTtJ26gOuqK4gmeq3TxROxTTjlFPlVAju0lEEE9mPESafwZ2mfxxKN56dMjt1oGKnDQaClb6hZu6yio+pp+IPt1TWiQ4knkvvP+q0lorPcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728744131; c=relaxed/simple;
	bh=pDESQmis9pDtjBkHLgvrCUWa+t7Ogkq9kZFlr/2sfKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DMPccaGdz1dOJUEclGU3fyO1YZ0NvgcM/fxEhv2HZgOBOb7nJHoOOIN0UIyfCqH/otZaeWEgLVSqEwqkFutth5A110L6XpuMgyhkaGe12EbX4H6yZbVnQ3VO9GKrwcrlD8drEIZ8vhp9Wq3X4NH4OaY5yGaX84ZNpBUkK8Y9NBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Puohi0Vo; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Puohi0Vo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728744128; x=1760280128;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pDESQmis9pDtjBkHLgvrCUWa+t7Ogkq9kZFlr/2sfKc=;
  b=Puohi0Vo/LH4r67Kck0kvLMesPsPEEfcXLSsN+jWu6CuW+5l6DsRb84f
   yGPMEAcBInu9t7yB/HO6R9CDIMb44FOIAmfpgciiklmeBCc/3Z/f7mLEb
   lcN0NqfFh6YiZ+mTNWrT9K9OxOy10g3V5SEFhuPZuK5+K7yavPeqZ/GVk
   Glfk7+kJzmCy6gk3eee9PumTACEN2F2B74GvfAgKDAyBqL1ewuDww/lU4
   PXdmzkd2QRpYyC8+/yhuQB+u5zabxQgMRAfX/4n+KVxT0AQixQSxYA4gP
   W/1/LxoKuE9uWTRh9CSMdZfM7zfubrgYcQmGyhV6WWxiZvT3OsvlU+BNa
   A==;
X-CSE-ConnectionGUID: D01BhkqXR9etEoWW80/UdQ==
X-CSE-MsgGUID: LA/2qdbcQ46syihdar7fTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="38701956"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="38701956"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 07:42:08 -0700
X-CSE-ConnectionGUID: utdfJkvhQ2yDhvLcqKNbSA==
X-CSE-MsgGUID: fYXBx54oTSedr960HhydTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="77043030"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 12 Oct 2024 07:42:06 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1szdJj-000DQT-29;
	Sat, 12 Oct 2024 14:42:03 +0000
Date: Sat, 12 Oct 2024 22:41:36 +0800
From: kernel test robot <lkp@intel.com>
To: Xiang Zhang <hawkxiang.cpp@gmail.com>, lduncan@suse.com,
	cleech@redhat.com, michael.christie@oracle.com,
	ames.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Xiang Zhang <hawkxiang.cpp@gmail.com>
Subject: Re: [PATCH] scsi: libiscsi: Set expecting_cc_ua flag when stop_conn
Message-ID: <202410122213.bq19EI34-lkp@intel.com>
References: <20241011081807.65027-1-hawkxiang.cpp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011081807.65027-1-hawkxiang.cpp@gmail.com>

Hi Xiang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.12-rc2 next-20241011]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiang-Zhang/scsi-libiscsi-Set-expecting_cc_ua-flag-when-stop_conn/20241011-161915
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241011081807.65027-1-hawkxiang.cpp%40gmail.com
patch subject: [PATCH] scsi: libiscsi: Set expecting_cc_ua flag when stop_conn
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20241012/202410122213.bq19EI34-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241012/202410122213.bq19EI34-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410122213.bq19EI34-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/libiscsi.c:634:3: warning: variable 'sc' is uninitialized when used here [-Wuninitialized]
     634 |                 sc->device->expecting_cc_ua = 1;
         |                 ^~
   drivers/scsi/libiscsi.c:618:22: note: initialize the variable 'sc' to silence this warning
     618 |         struct scsi_cmnd *sc;
         |                             ^
         |                              = NULL
   1 warning generated.


vim +/sc +634 drivers/scsi/libiscsi.c

   610	
   611	/*
   612	 * session back and frwd lock must be held and if not called for a task that
   613	 * is still pending or from the xmit thread, then xmit thread must be suspended
   614	 */
   615	static void __fail_scsi_task(struct iscsi_task *task, int err)
   616	{
   617		struct iscsi_conn *conn = task->conn;
   618		struct scsi_cmnd *sc;
   619		int state;
   620	
   621		if (cleanup_queued_task(task))
   622			return;
   623	
   624		if (task->state == ISCSI_TASK_PENDING) {
   625			/*
   626			 * cmd never made it to the xmit thread, so we should not count
   627			 * the cmd in the sequencing
   628			 */
   629			conn->session->queued_cmdsn--;
   630			/* it was never sent so just complete like normal */
   631			state = ISCSI_TASK_COMPLETED;
   632		} else if (err == DID_TRANSPORT_DISRUPTED) {
   633			state = ISCSI_TASK_ABRT_SESS_RECOV;
 > 634			sc->device->expecting_cc_ua = 1;
   635		} else
   636			state = ISCSI_TASK_ABRT_TMF;
   637	
   638		sc = task->sc;
   639		sc->result = err << 16;
   640		scsi_set_resid(sc, scsi_bufflen(sc));
   641		iscsi_complete_task(task, state);
   642	}
   643	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
