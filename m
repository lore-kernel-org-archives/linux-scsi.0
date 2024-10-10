Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A02E19A285;
	Thu, 10 Oct 2024 16:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728578431; cv=none; b=hhCop7JauaVTZBt8gnsn/UcLuFKkHjfxiiO0xYvkMenfs5ihCdfWlZslZJeqMlZYC/xlNRFmQKaqqNeF+/D0/76phx+pq2UEAppkvEZV42LB4R9j4e03WYJw/Z1FcmcBaVgODC+P6S5B9hqAxfSzZSL+LSXpzkZy1gthxMxuZ78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728578431; c=relaxed/simple;
	bh=DN2D9uqPaO8rZvr1YulT4ZNQtz5tSOtqH1QeCqLEVXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGHA8vk1WELsEqR+QHdLNyC3awQe5ZdNEULtkMPMNvQcsP2hasTUq4k/RRwm+LygMSoZk00tVAAU3GrsCEE6yAF9bDBoCLNn5AJNLdvjoGYEBpTR+850zbIhN+q643Nuk1MLiVbZR8Dle9RSfjYsyh7eNqXvPvvRvCxXz8Sdodg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mvH4Sfzo; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mvH4Sfzo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728578429; x=1760114429;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DN2D9uqPaO8rZvr1YulT4ZNQtz5tSOtqH1QeCqLEVXA=;
  b=mvH4Sfzoe3MaQgtUsdHmUQb5y3aQfRPMSIFWAVo2mkscuyJFcD5O73FY
   /yPEroFSlL2T/0bhLRlIIVQA7/WMWnPc5R+21PNEA6VcV+lr+vXB6is33
   uXo362uU1OJYpgmjJyJhfa496Ux1BtdKx3q9P07C9L4X1NzBH1Rr/Q5hb
   U7c5dT366sO9EHAc46T6jPo+lzJ8OkzcXHayF8ViXvpj+zJtS+PlNP6OH
   +YCOm6l2tpbsPZrvLbI1QfaS6CXI+6gKtsR8CHpjo8RGQdIAJ891KvqXB
   LaHIxX/Z/UajEDqQz2m33RYPNlpOUxPQLxBZ4iiXinLcrZ9gbRPiNudqt
   w==;
X-CSE-ConnectionGUID: qr5Q/TFeSU22uP/d74Xhsw==
X-CSE-MsgGUID: KmtlYW9LTievqyjMmiJjvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="39322646"
X-IronPort-AV: E=Sophos;i="6.11,193,1725346800"; 
   d="scan'208";a="39322646"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 09:40:28 -0700
X-CSE-ConnectionGUID: l5UiI2hJTOSvrJNFQOVDFg==
X-CSE-MsgGUID: WKs+SeFxSU2xoURwvsxr7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,193,1725346800"; 
   d="scan'208";a="81448225"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 10 Oct 2024 09:40:23 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sywD7-000B1b-18;
	Thu, 10 Oct 2024 16:40:21 +0000
Date: Fri, 11 Oct 2024 00:39:49 +0800
From: kernel test robot <lkp@intel.com>
To: Anastasia Kovaleva <a.kovaleva@yadro.com>, target-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	bvanassche@acm.org, quinn.tran@cavium.com,
	himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux@yadro.com, hare@suse.de,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] scsi: qla2xxx: Drop starvation counter on success
Message-ID: <202410110059.pb1whtvg-lkp@intel.com>
References: <20241009111654.4697-2-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009111654.4697-2-a.kovaleva@yadro.com>

Hi Anastasia,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.12-rc2 next-20241010]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anastasia-Kovaleva/scsi-qla2xxx-Drop-starvation-counter-on-success/20241009-192031
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241009111654.4697-2-a.kovaleva%40yadro.com
patch subject: [PATCH v2 1/3] scsi: qla2xxx: Drop starvation counter on success
config: um-allmodconfig (https://download.01.org/0day-ci/archive/20241011/202410110059.pb1whtvg-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 70e0a7e7e6a8541bcc46908c592eed561850e416)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241011/202410110059.pb1whtvg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410110059.pb1whtvg-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/scsi/qla2xxx/qla_target.c:20:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/um/include/asm/cacheflush.h:4:
   In file included from arch/um/include/asm/tlbflush.h:9:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   In file included from drivers/scsi/qla2xxx/qla_target.c:20:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:548:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     548 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:561:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     561 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   In file included from drivers/scsi/qla2xxx/qla_target.c:20:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:574:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     574 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   In file included from drivers/scsi/qla2xxx/qla_target.c:20:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:585:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     585 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:595:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     595 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:605:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     605 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:693:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     693 |         readsb(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:701:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     701 |         readsw(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:709:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     709 |         readsl(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:718:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     718 |         writesb(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
   include/asm-generic/io.h:727:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     727 |         writesw(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
   include/asm-generic/io.h:736:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     736 |         writesl(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
>> drivers/scsi/qla2xxx/qla_target.c:6833:4: error: cannot take the address of an rvalue of type 'uint8_t *' (aka 'unsigned char *')
    6833 |                         WRITE_ONCE(&vha->hw->exch_starvation, 0);
         |                         ^          ~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:61:2: note: expanded from macro 'WRITE_ONCE'
      61 |         __WRITE_ONCE(x, val);                                           \
         |         ^            ~
   include/asm-generic/rwonce.h:55:25: note: expanded from macro '__WRITE_ONCE'
      55 |         *(volatile typeof(x) *)&(x) = (val);                            \
         |                                ^ ~
   13 warnings and 1 error generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for MODVERSIONS
   Depends on [n]: MODULES [=y] && !COMPILE_TEST [=y]
   Selected by [y]:
   - RANDSTRUCT_FULL [=y] && (CC_HAS_RANDSTRUCT [=y] || GCC_PLUGINS [=n]) && MODULES [=y]
   WARNING: unmet direct dependencies detected for GET_FREE_REGION
   Depends on [n]: SPARSEMEM [=n]
   Selected by [m]:
   - RESOURCE_KUNIT_TEST [=m] && RUNTIME_TESTING_MENU [=y] && KUNIT [=m]


vim +6833 drivers/scsi/qla2xxx/qla_target.c

  6793	
  6794	/*
  6795	 * qlt_24xx_process_atio_queue() - Process ATIO queue entries.
  6796	 * @ha: SCSI driver HA context
  6797	 */
  6798	void
  6799	qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
  6800	{
  6801		struct qla_hw_data *ha = vha->hw;
  6802		struct atio_from_isp *pkt;
  6803		int cnt, i;
  6804	
  6805		if (!ha->flags.fw_started)
  6806			return;
  6807	
  6808		while ((ha->tgt.atio_ring_ptr->signature != ATIO_PROCESSED) ||
  6809		    fcpcmd_is_corrupted(ha->tgt.atio_ring_ptr)) {
  6810			pkt = (struct atio_from_isp *)ha->tgt.atio_ring_ptr;
  6811			cnt = pkt->u.raw.entry_count;
  6812	
  6813			if (unlikely(fcpcmd_is_corrupted(ha->tgt.atio_ring_ptr))) {
  6814				/*
  6815				 * This packet is corrupted. The header + payload
  6816				 * can not be trusted. There is no point in passing
  6817				 * it further up.
  6818				 */
  6819				ql_log(ql_log_warn, vha, 0xd03c,
  6820				    "corrupted fcp frame SID[%3phN] OXID[%04x] EXCG[%x] %64phN\n",
  6821				    &pkt->u.isp24.fcp_hdr.s_id,
  6822				    be16_to_cpu(pkt->u.isp24.fcp_hdr.ox_id),
  6823				    pkt->u.isp24.exchange_addr, pkt);
  6824	
  6825				adjust_corrupted_atio(pkt);
  6826				qlt_send_term_exchange(ha->base_qpair, NULL, pkt,
  6827				    ha_locked, 0);
  6828			} else {
  6829				/*
  6830				 * If we get correct ATIO, then HBA had enough memory
  6831				 * to proceed without reset.
  6832				 */
> 6833				WRITE_ONCE(&vha->hw->exch_starvation, 0);
  6834	
  6835				qlt_24xx_atio_pkt_all_vps(vha,
  6836				    (struct atio_from_isp *)pkt, ha_locked);
  6837			}
  6838	
  6839			for (i = 0; i < cnt; i++) {
  6840				ha->tgt.atio_ring_index++;
  6841				if (ha->tgt.atio_ring_index == ha->tgt.atio_q_length) {
  6842					ha->tgt.atio_ring_index = 0;
  6843					ha->tgt.atio_ring_ptr = ha->tgt.atio_ring;
  6844				} else
  6845					ha->tgt.atio_ring_ptr++;
  6846	
  6847				pkt->u.raw.signature = cpu_to_le32(ATIO_PROCESSED);
  6848				pkt = (struct atio_from_isp *)ha->tgt.atio_ring_ptr;
  6849			}
  6850			wmb();
  6851		}
  6852	
  6853		/* Adjust ring index */
  6854		wrt_reg_dword(ISP_ATIO_Q_OUT(vha), ha->tgt.atio_ring_index);
  6855	}
  6856	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
