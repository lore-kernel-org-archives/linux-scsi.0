Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD707306B30
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 09:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763113701; cv=none; b=BW3c7REHdvc9FDzviSkUxLOuDZ5LzrMs1BAHWUuVsJTP+kccOz3+t4ttFSm7LGV21W1e+DiwX6aCjS3zyWcdwUGXnGDKpLyMbAKhg7tbuwDsPTIWYtBTlPHeaX/JkyprlFVk9rNWH8CNru2e2bWwoyCXAw1VGZv+S+KncsZu9Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763113701; c=relaxed/simple;
	bh=wyLodx5kEduMbMMQVKbtHixg3oAvRP8hTloKaWb1KCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9YuWCaQAxoDXYElWefeTG3VDiFUcb19JQEPniT/Dpi3Yhm4h6nNyf7Z+XQg9BlHk/G2z2SgI/ZGtTRJl194BMXmlKSmE8prsB2dU4uJ9e6IkiMsqCYMirewM+3Y4aDJYFxPquXSXTaIa4DkWEysvTe8bzR04RNLkVhNmYsH/rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WLKLBxL/; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WLKLBxL/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763113700; x=1794649700;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wyLodx5kEduMbMMQVKbtHixg3oAvRP8hTloKaWb1KCk=;
  b=WLKLBxL/D6D5IJAiEHyjowhm0WWFSZoJfn4yDsNEv1kpKqaakUfAe946
   HIxQazEnqTNeSWEgV0G7e+mtDLWgAeRIoLV/nwuRHzsjlI1LKe1BVGufW
   M7YNmDbmP/koDJlPvt4vK+SBr9AXcRA/9PgaYzue8igNmsKG52HVOk3IE
   mFV7PSJ8atKvBrvujrdZrO1i94IdqXSFiOjWKQMlJLGCNChrxxwaoGEQD
   pqXwUJ9ZezRLv06ooIn9TUOdljOgzxw7rjnYWyLOaOIDmFB4AA4KOW+m6
   dbVsG+/lfZ23PUcB1QcKlFd2V+6vwM1APq0TH0W0/GxIXuB87lHawwJbr
   g==;
X-CSE-ConnectionGUID: +C9lHzkfSIiBENLn6JdiEQ==
X-CSE-MsgGUID: EbR5o1oiQaCs5NUNkjg5Gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="68830698"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="68830698"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 01:48:19 -0800
X-CSE-ConnectionGUID: 1paWgNv0QdKnjUh0ltK5lQ==
X-CSE-MsgGUID: W28FvJujQQqhw/+9d9E5TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="194886978"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 14 Nov 2025 01:48:18 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJqPf-0006QZ-2N;
	Fri, 14 Nov 2025 09:48:15 +0000
Date: Fri, 14 Nov 2025 17:48:10 +0800
From: kernel test robot <lkp@intel.com>
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH] scsi: core: add re-probe logic into SCSI rescan
Message-ID: <202511141703.pqiMI34x-lkp@intel.com>
References: <20251113201819.76650-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113201819.76650-1-brian@purestorage.com>

Hi Brian,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.18-rc5 next-20251114]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Brian-Bunker/scsi-core-add-re-probe-logic-into-SCSI-rescan/20251114-042028
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251113201819.76650-1-brian%40purestorage.com
patch subject: [PATCH] scsi: core: add re-probe logic into SCSI rescan
config: nios2-randconfig-r071-20251114 (https://download.01.org/0day-ci/archive/20251114/202511141703.pqiMI34x-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511141703.pqiMI34x-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511141703.pqiMI34x-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/scsi/scsi.c: In function 'scsi_update_inquiry_data':
>> drivers/scsi/scsi.c:600:35: error: 'BLIST_ISROM' undeclared (first use in this function)
     600 |         if (!(sdev->sdev_bflags & BLIST_ISROM)) {
         |                                   ^~~~~~~~~~~
   drivers/scsi/scsi.c:600:35: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/scsi/scsi.c:618:41: error: 'BLIST_NOT_LOCKABLE' undeclared (first use in this function)
     618 |                 if (sdev->sdev_bflags & BLIST_NOT_LOCKABLE)
         |                                         ^~~~~~~~~~~~~~~~~~
>> drivers/scsi/scsi.c:634:57: error: 'BLIST_NOTQ' undeclared (first use in this function)
     634 |                                   !(sdev->sdev_bflags & BLIST_NOTQ)) ? 1 : 0;
         |                                                         ^~~~~~~~~~


vim +/BLIST_ISROM +600 drivers/scsi/scsi.c

   546	
   547	/**
   548	 * scsi_update_inquiry_data - Update standard INQUIRY data for a SCSI device
   549	 * @sdev: The device to update
   550	 * @inq_result: Buffer containing new INQUIRY data
   551	 * @inq_len: Length of inquiry data
   552	 *
   553	 * Updates the standard INQUIRY data (vendor, model, rev, peripheral qualifier,
   554	 * device type, removable media flag) and capability flags derived from INQUIRY
   555	 * data for an existing SCSI device. This is used when reprobing a device to get
   556	 * fresh INQUIRY information. The old inquiry buffer is freed and replaced with
   557	 * the new data under the protection of inquiry_mutex.
   558	 *
   559	 * Blacklist flags (BLIST_ISROM, BLIST_NOT_LOCKABLE, BLIST_NOTQ) are respected
   560	 * when updating device properties.
   561	 *
   562	 * Returns:
   563	 *   0 on success
   564	 *   1 if device type or peripheral qualifier changed (caller should call device_reprobe())
   565	 *  -ENOMEM on allocation failure
   566	 */
   567	int scsi_update_inquiry_data(struct scsi_device *sdev,
   568				      unsigned char *inq_result, size_t inq_len)
   569	{
   570		unsigned char *new_inquiry;
   571		unsigned char old_type;
   572		unsigned char old_periph_qual;
   573	
   574		/* Allocate new inquiry buffer */
   575		new_inquiry = kmemdup(inq_result, max_t(size_t, inq_len, 36),
   576				      GFP_KERNEL);
   577		if (!new_inquiry)
   578			return -ENOMEM;
   579	
   580		/* Update inquiry data under mutex protection */
   581		mutex_lock(&sdev->inquiry_mutex);
   582	
   583		/* Save old values to detect changes that require reprobe */
   584		old_type = sdev->type;
   585		old_periph_qual = sdev->inq_periph_qual;
   586	
   587		kfree(sdev->inquiry);
   588		sdev->inquiry = new_inquiry;
   589		sdev->vendor = (char *)(sdev->inquiry + 8);
   590		sdev->model = (char *)(sdev->inquiry + 16);
   591		sdev->rev = (char *)(sdev->inquiry + 32);
   592		sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
   593	
   594		/*
   595		 * Update device type and removable media flag from INQUIRY bytes 0-1.
   596		 * This is the single source of truth for setting these fields from
   597		 * INQUIRY data, used by both initial probe (scsi_add_lun) and reprobe
   598		 * (scsi_rescan_device, scsi_probe_and_add_lun).
   599		 */
 > 600		if (!(sdev->sdev_bflags & BLIST_ISROM)) {
   601			sdev->type = inq_result[0] & 0x1f;
   602			sdev->removable = (inq_result[1] & 0x80) >> 7;
   603	
   604			/*
   605			 * some devices may respond with wrong type for
   606			 * well-known logical units. Force well-known type
   607			 * to enumerate them correctly.
   608			 */
   609			if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
   610				sdev_printk(KERN_WARNING, sdev,
   611					    "%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16xhN\n",
   612					    __func__, sdev->type, (unsigned int)sdev->lun);
   613				sdev->type = TYPE_WLUN;
   614			}
   615	
   616			/* lockable defaults to removable, unless blacklist overrides */
   617			sdev->lockable = sdev->removable;
 > 618			if (sdev->sdev_bflags & BLIST_NOT_LOCKABLE)
   619				sdev->lockable = 0;
   620		}
   621	
   622		/* Update capability flags from INQUIRY byte 7 */
   623		sdev->soft_reset = ((inq_result[7] & 1) && ((inq_result[3] & 7) == 2)) ? 1 : 0;
   624	
   625		/* Update protocol support flags */
   626		sdev->ppr = (sdev->scsi_level >= SCSI_3 ||
   627			     (inq_len > 56 && inq_result[56] & 0x04)) ? 1 : 0;
   628		sdev->wdtr = (inq_result[7] & 0x60) ? 1 : 0;
   629		sdev->sdtr = (inq_result[7] & 0x10) ? 1 : 0;
   630	
   631		/* Update tagged queuing support */
   632		sdev->tagged_supported = ((sdev->scsi_level >= SCSI_2) &&
   633					  (inq_result[7] & 2) &&
 > 634					  !(sdev->sdev_bflags & BLIST_NOTQ)) ? 1 : 0;
   635		sdev->simple_tags = sdev->tagged_supported;
   636	
   637		mutex_unlock(&sdev->inquiry_mutex);
   638	
   639		/*
   640		 * If device type or peripheral qualifier changed, return a special
   641		 * code to indicate that caller should trigger device_reprobe() to
   642		 * re-match with appropriate upper-layer driver.
   643		 *
   644		 * - Type changes require different drivers (sd vs sr vs st, etc.)
   645		 * - PQ changes affect scsi_bus_match() which only matches PQ == 0
   646		 *
   647		 * Note: We check this AFTER updating all fields and releasing the
   648		 * mutex, so all INQUIRY-derived data is current regardless of whether
   649		 * reprobe is needed.
   650		 */
   651		if (old_type != sdev->type || old_periph_qual != sdev->inq_periph_qual) {
   652			if (old_type != sdev->type)
   653				sdev_printk(KERN_NOTICE, sdev,
   654					    "device type changed from %d to %d\n",
   655					    old_type, sdev->type);
   656			if (old_periph_qual != sdev->inq_periph_qual)
   657				sdev_printk(KERN_NOTICE, sdev,
   658					    "peripheral qualifier changed from %d to %d\n",
   659					    old_periph_qual, sdev->inq_periph_qual);
   660			return 1; /* Type or PQ changed - caller should reprobe */
   661		}
   662	
   663		return 0;
   664	}
   665	EXPORT_SYMBOL(scsi_update_inquiry_data);
   666	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
