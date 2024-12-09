Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D739189BBF;
	Mon,  9 Dec 2024 04:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733719419; cv=none; b=hFoLOe1ukedqiEyuSIn5za2BBxBm+qCEtPlO9Zci+Bma289j+OG3zOkNA7KaweRt47vsLVtbrVTiOwS9z2z93K3/0j3oUFHhPGoCwrW00HKNQ2xtdEb2PQM4AdyUifeb+moe0etlsR587pN2NcJlDWVWYdzGvIC76puibLLgRo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733719419; c=relaxed/simple;
	bh=+n0XFzsxVnjy9uuVZLqmTgHRswaGkbGvdNYtiQocNMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZUyaGqYsftPOY0YT5PLOHaK2id1pA9EWx2g5brdNZoDc638kUaIMuILao7kHtSunD3KHYk4BGCuzWSbG5ltOZcRLyAM2cAQYiCH2oMm29zf0KdfuOJFAM1Lzyz8D9pHvwzRJXXpTwBjvvJMHR02FffA8OXLhr0ua9XbPEHYnn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CivLbFcS; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CivLbFcS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733719417; x=1765255417;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+n0XFzsxVnjy9uuVZLqmTgHRswaGkbGvdNYtiQocNMA=;
  b=CivLbFcSYkV3or+cOy6s3ykrwI3Zfs9AMbKw7UVvLoshKKChoT89CGyx
   qsoTZ7Gfay9IMSjGooV5c2PAlLPSnl0f/MvBmec0nmqibq9JLl2WUBNhk
   Dx81U55z1xJWNOr6+Ym15tvHUqVgbfWVvAmfu1+Kwm6Fm8dbK7ZhOArpY
   ZMLe3UzE35SJnB+yw62fp8sCuFzuHA14XOMyD2Gdpv5utonV4fkTVlfM5
   WBZM20+NqDUR2/PqG5M8XiRRoeMNZgiuSTg4mOLaMFTJcTUnZ9Nn0U2q9
   QDYLp7CESuuXr07OJq+pdK8bKOQxsCTJO5fE0Fmm7N0ueAQBLTeHewjIw
   g==;
X-CSE-ConnectionGUID: GRqxsRaTQ9eFvuoE4peFCA==
X-CSE-MsgGUID: PpW3ltchQ7i3ghFyZF1Qbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="51416116"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="51416116"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 20:43:37 -0800
X-CSE-ConnectionGUID: ukFCdVGPQ3qnAVko9o8qEA==
X-CSE-MsgGUID: O/ao/PZvS3+oEfAxIyGrQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="94801539"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 08 Dec 2024 20:43:33 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tKVcJ-0003u1-13;
	Mon, 09 Dec 2024 04:43:31 +0000
Date: Mon, 9 Dec 2024 12:43:13 +0800
From: kernel test robot <lkp@intel.com>
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: oe-kbuild-all@lists.linux.dev, arulponn@cisco.com, djhawar@cisco.com,
	gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com,
	aeasi@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v6 04/15] scsi: fnic: Add support for target based
 solicited requests and responses
Message-ID: <202412081427.SlsFIJY4-lkp@intel.com>
References: <20241206210852.3251-5-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241206210852.3251-5-kartilak@cisco.com>

Hi Karan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on linus/master v6.13-rc1 next-20241206]
[cannot apply to mkp-scsi/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Karan-Tilak-Kumar/scsi-fnic-Replace-shost_printk-with-dev_info-dev_err/20241207-054453
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241206210852.3251-5-kartilak%40cisco.com
patch subject: [PATCH v6 04/15] scsi: fnic: Add support for target based solicited requests and responses
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20241208/202412081427.SlsFIJY4-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241208/202412081427.SlsFIJY4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412081427.SlsFIJY4-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/fnic/fdls_disc.c: In function 'fdls_tport_timer_callback':
>> drivers/scsi/fnic/fdls_disc.c:1745:18: warning: variable 'oxid' set but not used [-Wunused-but-set-variable]
    1745 |         uint16_t oxid;
         |                  ^~~~


vim +/oxid +1745 drivers/scsi/fnic/fdls_disc.c

  1739	
  1740	static void fdls_tport_timer_callback(struct timer_list *t)
  1741	{
  1742		struct fnic_tport_s *tport = from_timer(tport, t, retry_timer);
  1743		struct fnic_iport_s *iport = (struct fnic_iport_s *) tport->iport;
  1744		struct fnic *fnic = iport->fnic;
> 1745		uint16_t oxid;
  1746		unsigned long flags;
  1747	
  1748		spin_lock_irqsave(&fnic->fnic_lock, flags);
  1749		if (!tport->timer_pending) {
  1750			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
  1751			return;
  1752		}
  1753	
  1754		if (iport->state != FNIC_IPORT_STATE_READY) {
  1755			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
  1756			return;
  1757		}
  1758	
  1759		if (tport->del_timer_inprogress) {
  1760			tport->del_timer_inprogress = 0;
  1761			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
  1762			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1763				 "tport_del_timer inprogress. Skip timer cb tport fcid: 0x%x\n",
  1764				 tport->fcid);
  1765			return;
  1766		}
  1767	
  1768		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1769			 "tport fcid: 0x%x timer pending: %d state: %d retry counter: %d",
  1770			 tport->fcid, tport->timer_pending, tport->state,
  1771			 tport->retry_counter);
  1772	
  1773		tport->timer_pending = 0;
  1774		oxid = tport->active_oxid;
  1775	
  1776		/* We retry plogi/prli/adisc frames depending on the tport state */
  1777		switch (tport->state) {
  1778		case FDLS_TGT_STATE_PLOGI:
  1779			/* PLOGI frame received a LS_RJT with busy, we retry from here */
  1780			if ((tport->flags & FNIC_FDLS_RETRY_FRAME)
  1781				&& (tport->retry_counter < iport->max_plogi_retries)) {
  1782				tport->flags &= ~FNIC_FDLS_RETRY_FRAME;
  1783				fdls_send_tgt_plogi(iport, tport);
  1784			} else if (!(tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
  1785				/* Plogi frame has timed out, send abts */
  1786				fdls_send_tport_abts(iport, tport);
  1787			} else if (tport->retry_counter < iport->max_plogi_retries) {
  1788				/*
  1789				 * ABTS has timed out
  1790				 */
  1791				fdls_schedule_oxid_free(iport, &tport->active_oxid);
  1792				fdls_send_tgt_plogi(iport, tport);
  1793			} else {
  1794				/* exceeded plogi retry count */
  1795				fdls_schedule_oxid_free(iport, &tport->active_oxid);
  1796				fdls_send_delete_tport_msg(tport);
  1797			}
  1798			break;
  1799		case FDLS_TGT_STATE_PRLI:
  1800			/* PRLI received a LS_RJT with busy , hence we retry from here */
  1801			if ((tport->flags & FNIC_FDLS_RETRY_FRAME)
  1802				&& (tport->retry_counter < FDLS_RETRY_COUNT)) {
  1803				tport->flags &= ~FNIC_FDLS_RETRY_FRAME;
  1804				fdls_send_tgt_prli(iport, tport);
  1805			} else if (!(tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
  1806				/* PRLI has time out, send abts */
  1807				fdls_send_tport_abts(iport, tport);
  1808			} else {
  1809				/* ABTS has timed out for prli, we go back to PLOGI */
  1810				fdls_schedule_oxid_free(iport, &tport->active_oxid);
  1811				fdls_send_tgt_plogi(iport, tport);
  1812				fdls_set_tport_state(tport, FDLS_TGT_STATE_PLOGI);
  1813			}
  1814			break;
  1815		case FDLS_TGT_STATE_ADISC:
  1816			/* ADISC timed out send an ABTS */
  1817			if (!(tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
  1818				fdls_send_tport_abts(iport, tport);
  1819			} else if ((tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)
  1820					   && (tport->retry_counter < FDLS_RETRY_COUNT)) {
  1821				/*
  1822				 * ABTS has timed out
  1823				 */
  1824				fdls_schedule_oxid_free(iport, &tport->active_oxid);
  1825				fdls_send_tgt_adisc(iport, tport);
  1826			} else {
  1827				/* exceeded retry count */
  1828				fdls_schedule_oxid_free(iport, &tport->active_oxid);
  1829				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1830						 "ADISC not responding. Deleting target port: 0x%x",
  1831						 tport->fcid);
  1832				fdls_send_delete_tport_msg(tport);
  1833			}
  1834			break;
  1835		default:
  1836			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1837						 "Unknown tport state: 0x%x", tport->state);
  1838			break;
  1839		}
  1840		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
  1841	}
  1842	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
