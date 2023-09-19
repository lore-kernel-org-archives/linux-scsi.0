Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7D6CD3424
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 00:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjISAFR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 20:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbjISAFP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 20:05:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A349C
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 17:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695081909; x=1726617909;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OsfeTrB9rugivYZ/kHFdIa8zHxOR7UummpVvtk0Egu4=;
  b=XEMOC/qe4c9lgDDjBuKVI1z7wDzp2UlUUB3aywXcqoSD24UFsoEqKBuz
   HMywA4mIEPPYi/VhN4bXdjUay8fPIhgwuBg9ZsFa42T2ZTd8sYmO/x1ko
   3utKEk6cNgfu6lX6aniTXCiqvFBFWlBMa8BV56W0KdT7tVAsYiFw2SZtY
   byaiqifuYf361pA0Afg1k2hCfJV50s3QxKczYOTn/TlG+pjpyjoM3VQ66
   GVfGA2BeG4F+mbqbV0Z05V+8PIP64EbSLyyjlNV9OeulQpBAATneK/qMI
   H9DK0yzXMC2gj4GcOxausKYCkGIuovx7qmUKzAvlKbqOG+OhxaBHhOxfp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="383635441"
X-IronPort-AV: E=Sophos;i="6.02,157,1688454000"; 
   d="scan'208";a="383635441"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 17:05:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10837"; a="1076776448"
X-IronPort-AV: E=Sophos;i="6.02,157,1688454000"; 
   d="scan'208";a="1076776448"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 18 Sep 2023 17:05:06 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qiOEf-0006ey-1z;
        Tue, 19 Sep 2023 00:05:02 +0000
Date:   Tue, 19 Sep 2023 08:04:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tyrel Datwyler <tyreld@linux.ibm.com>, martin.petersen@oracle.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 01/11] ibmvfc: remove BUG_ON in the case of an empty
 event pool
Message-ID: <202309190735.oSIVJWbC-lkp@intel.com>
References: <20230913230457.2575849-2-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230913230457.2575849-2-tyreld@linux.ibm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Tyrel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.6-rc2 next-20230918]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tyrel-Datwyler/ibmvfc-remove-BUG_ON-in-the-case-of-an-empty-event-pool/20230914-085530
base:   linus/master
patch link:    https://lore.kernel.org/r/20230913230457.2575849-2-tyreld%40linux.ibm.com
patch subject: [PATCH 01/11] ibmvfc: remove BUG_ON in the case of an empty event pool
config: powerpc-allyesconfig (https://download.01.org/0day-ci/archive/20230919/202309190735.oSIVJWbC-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230919/202309190735.oSIVJWbC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309190735.oSIVJWbC-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/ibmvscsi/ibmvfc.c:4618:66: warning: variable 'rc' is uninitialized when used here [-Wuninitialized]
    4618 |                 tgt_err(tgt, "Failed to send cancel event for ADISC. rc=%d\n", rc);
         |                                                                                ^~
   drivers/scsi/ibmvscsi/ibmvfc.h:910:57: note: expanded from macro 'tgt_err'
     910 |         dev_err((t)->vhost->dev, "%llX: " fmt, (t)->scsi_id, ##__VA_ARGS__)
         |                                                                ^~~~~~~~~~~
   include/linux/dev_printk.h:144:65: note: expanded from macro 'dev_err'
     144 |         dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                                                                        ^~~~~~~~~~~
   include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                                     ^~~~~~~~~~~
   drivers/scsi/ibmvscsi/ibmvfc.c:4602:8: note: initialize the variable 'rc' to silence this warning
    4602 |         int rc;
         |               ^
         |                = 0
   1 warning generated.


vim +/rc +4618 drivers/scsi/ibmvscsi/ibmvfc.c

  4586	
  4587	/**
  4588	 * ibmvfc_adisc_timeout - Handle an ADISC timeout
  4589	 * @t:		ibmvfc target struct
  4590	 *
  4591	 * If an ADISC times out, send a cancel. If the cancel times
  4592	 * out, reset the CRQ. When the ADISC comes back as cancelled,
  4593	 * log back into the target.
  4594	 **/
  4595	static void ibmvfc_adisc_timeout(struct timer_list *t)
  4596	{
  4597		struct ibmvfc_target *tgt = from_timer(tgt, t, timer);
  4598		struct ibmvfc_host *vhost = tgt->vhost;
  4599		struct ibmvfc_event *evt;
  4600		struct ibmvfc_tmf *tmf;
  4601		unsigned long flags;
  4602		int rc;
  4603	
  4604		tgt_dbg(tgt, "ADISC timeout\n");
  4605		spin_lock_irqsave(vhost->host->host_lock, flags);
  4606		if (vhost->abort_threads >= disc_threads ||
  4607		    tgt->action != IBMVFC_TGT_ACTION_INIT_WAIT ||
  4608		    vhost->state != IBMVFC_INITIALIZING ||
  4609		    vhost->action != IBMVFC_HOST_ACTION_QUERY_TGTS) {
  4610			spin_unlock_irqrestore(vhost->host->host_lock, flags);
  4611			return;
  4612		}
  4613	
  4614		vhost->abort_threads++;
  4615		kref_get(&tgt->kref);
  4616		evt = ibmvfc_get_event(&vhost->crq);
  4617		if (!evt) {
> 4618			tgt_err(tgt, "Failed to send cancel event for ADISC. rc=%d\n", rc);
  4619			vhost->abort_threads--;
  4620			kref_put(&tgt->kref, ibmvfc_release_tgt);
  4621			__ibmvfc_reset_host(vhost);
  4622			spin_unlock_irqrestore(vhost->host->host_lock, flags);
  4623			return;
  4624		}
  4625		ibmvfc_init_event(evt, ibmvfc_tgt_adisc_cancel_done, IBMVFC_MAD_FORMAT);
  4626	
  4627		evt->tgt = tgt;
  4628		tmf = &evt->iu.tmf;
  4629		memset(tmf, 0, sizeof(*tmf));
  4630		if (ibmvfc_check_caps(vhost, IBMVFC_HANDLE_VF_WWPN)) {
  4631			tmf->common.version = cpu_to_be32(2);
  4632			tmf->target_wwpn = cpu_to_be64(tgt->wwpn);
  4633		} else {
  4634			tmf->common.version = cpu_to_be32(1);
  4635		}
  4636		tmf->common.opcode = cpu_to_be32(IBMVFC_TMF_MAD);
  4637		tmf->common.length = cpu_to_be16(sizeof(*tmf));
  4638		tmf->scsi_id = cpu_to_be64(tgt->scsi_id);
  4639		tmf->cancel_key = cpu_to_be32(tgt->cancel_key);
  4640	
  4641		rc = ibmvfc_send_event(evt, vhost, default_timeout);
  4642	
  4643		if (rc) {
  4644			tgt_err(tgt, "Failed to send cancel event for ADISC. rc=%d\n", rc);
  4645			vhost->abort_threads--;
  4646			kref_put(&tgt->kref, ibmvfc_release_tgt);
  4647			__ibmvfc_reset_host(vhost);
  4648		} else
  4649			tgt_dbg(tgt, "Attempting to cancel ADISC\n");
  4650		spin_unlock_irqrestore(vhost->host->host_lock, flags);
  4651	}
  4652	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
