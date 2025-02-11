Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E841F891C
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2025 10:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739270520; cv=none; b=hReyPkI8ik+X8+wbWhaJN4lUYjyDjQ/8+G8yEV+va/GkpyEQJyhPubrwoi6ypZgUr4D0lLcD7TPhZtddWBBN3vEov1nTCleVXopk204aUfKYnJ6w9rw+62ye7f+jLoxBicwvkOtr/sXfsgCidSSNDV1Luga5NErzpdEth1j3Lwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739270520; c=relaxed/simple;
	bh=1g0fWuCfXP4ozG4qrKwBzzQ+ga1nSiXJHNkqR36aCaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YpJ9W4kUWya6aEyUhB3WCYEb3mdt3Tyz4IyICJmeESQ9GABA1I479R+wT9XtE2OfzpJw2bFxYScFy/A7rR3MDFwuAW+lcsYbhHUJtVhb0R4x2kFBktlLYEYXM6PIpLg5mny4Br0cpNltNsJxLtY+bLvNmOWLov2aglnNADiareg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MSgeahRC; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MSgeahRC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739270518; x=1770806518;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1g0fWuCfXP4ozG4qrKwBzzQ+ga1nSiXJHNkqR36aCaA=;
  b=MSgeahRCI9Rey9lzZ1VfmtL91zaMU90MDD2zKuni/t8u/qGzRKgJR+Z3
   /wYCCaU0iFHVmZy95z7aXGNY1fRLAKGR8oyb0m/fxS2pMUp2ioSQQPQtA
   D0HZDJCPzjIllhs5+gKlH7/X5twaGPjManhzpTSDyQCvaidoqCGBnUx1n
   J2rVSIATeb2ANqVWhZOc25RHerviNR19Hs2Z1QczFMHFtyidbDk2CcRTg
   fgRVLjCxyBbQqQBVMc3Sy0tYHnIfGEQQru8BaroYdhKkRw4F7zVWSm9LY
   RlNNTox4QibD9OtRs332ucZ4rHsT4tHTeqB3Xjfl8FQ7oYf+WyiD+7VOk
   Q==;
X-CSE-ConnectionGUID: 1mxu2s3WRfqze0KJtC5GgQ==
X-CSE-MsgGUID: SMt13q+PTMOhCVdHcahKbw==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="57292571"
X-IronPort-AV: E=Sophos;i="6.13,277,1732608000"; 
   d="scan'208";a="57292571"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 02:41:55 -0800
X-CSE-ConnectionGUID: OR7M8NQ/T/GWnNWBzrN5Ew==
X-CSE-MsgGUID: 6xfvOQM4SFmcoWjYaxKYxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,277,1732608000"; 
   d="scan'208";a="112989075"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 11 Feb 2025 02:41:53 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1thniA-00142X-2q;
	Tue, 11 Feb 2025 10:41:50 +0000
Date: Tue, 11 Feb 2025 18:41:00 +0800
From: kernel test robot <lkp@intel.com>
To: Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
	linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com,
	jmeneghi@redhat.com,
	Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH v1 2/7] scsi: scsi_debug: Add READ BLOCK LIMITS and
 modify LOAD for tapes
Message-ID: <202502111805.dXd61ARr-lkp@intel.com>
References: <20250210191232.185207-3-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210191232.185207-3-Kai.Makisara@kolumbus.fi>

Hi Kai,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.14-rc2 next-20250210]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kai-M-kisara/scsi-scsi_debug-First-fixes-for-tapes/20250211-031623
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250210191232.185207-3-Kai.Makisara%40kolumbus.fi
patch subject: [PATCH v1 2/7] scsi: scsi_debug: Add READ BLOCK LIMITS and modify LOAD for tapes
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20250211/202502111805.dXd61ARr-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250211/202502111805.dXd61ARr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502111805.dXd61ARr-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/scsi/scsi_debug.c:31:
   In file included from include/linux/scatterlist.h:8:
   In file included from include/linux/mm.h:2224:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     525 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> drivers/scsi/scsi_debug.c:2926:3: warning: variable 'len' is uninitialized when used here [-Wuninitialized]
    2926 |                 len += resp_partition_m_pg(ap, pcontrol, target);
         |                 ^~~
   drivers/scsi/scsi_debug.c:2791:28: note: initialize the variable 'len' to silence this warning
    2791 |         u32 alloc_len, offset, len;
         |                                   ^
         |                                    = 0
   4 warnings generated.


vim +/len +2926 drivers/scsi/scsi_debug.c

  2785	
  2786	static int resp_mode_sense(struct scsi_cmnd *scp,
  2787				   struct sdebug_dev_info *devip)
  2788	{
  2789		int pcontrol, pcode, subpcode, bd_len;
  2790		unsigned char dev_spec;
  2791		u32 alloc_len, offset, len;
  2792		int target_dev_id;
  2793		int target = scp->device->id;
  2794		unsigned char *ap;
  2795		unsigned char *arr __free(kfree);
  2796		unsigned char *cmd = scp->cmnd;
  2797		bool dbd, llbaa, msense_6, is_disk, is_zbc, is_tape;
  2798	
  2799		arr = kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
  2800		if (!arr)
  2801			return -ENOMEM;
  2802		dbd = !!(cmd[1] & 0x8);		/* disable block descriptors */
  2803		pcontrol = (cmd[2] & 0xc0) >> 6;
  2804		pcode = cmd[2] & 0x3f;
  2805		subpcode = cmd[3];
  2806		msense_6 = (MODE_SENSE == cmd[0]);
  2807		llbaa = msense_6 ? false : !!(cmd[1] & 0x10);
  2808		is_disk = (sdebug_ptype == TYPE_DISK);
  2809		is_zbc = devip->zoned;
  2810		is_tape = (sdebug_ptype == TYPE_TAPE);
  2811		if ((is_disk || is_zbc || is_tape) && !dbd)
  2812			bd_len = llbaa ? 16 : 8;
  2813		else
  2814			bd_len = 0;
  2815		alloc_len = msense_6 ? cmd[4] : get_unaligned_be16(cmd + 7);
  2816		if (0x3 == pcontrol) {  /* Saving values not supported */
  2817			mk_sense_buffer(scp, ILLEGAL_REQUEST, SAVING_PARAMS_UNSUP, 0);
  2818			return check_condition_result;
  2819		}
  2820		target_dev_id = ((devip->sdbg_host->shost->host_no + 1) * 2000) +
  2821				(devip->target * 1000) - 3;
  2822		/* for disks+zbc set DPOFUA bit and clear write protect (WP) bit */
  2823		if (is_disk || is_zbc) {
  2824			dev_spec = 0x10;	/* =0x90 if WP=1 implies read-only */
  2825			if (sdebug_wp)
  2826				dev_spec |= 0x80;
  2827		} else
  2828			dev_spec = 0x0;
  2829		if (msense_6) {
  2830			arr[2] = dev_spec;
  2831			arr[3] = bd_len;
  2832			offset = 4;
  2833		} else {
  2834			arr[3] = dev_spec;
  2835			if (16 == bd_len)
  2836				arr[4] = 0x1;	/* set LONGLBA bit */
  2837			arr[7] = bd_len;	/* assume 255 or less */
  2838			offset = 8;
  2839		}
  2840		ap = arr + offset;
  2841		if ((bd_len > 0) && (!sdebug_capacity))
  2842			sdebug_capacity = get_sdebug_capacity();
  2843	
  2844		if (8 == bd_len) {
  2845			if (sdebug_capacity > 0xfffffffe)
  2846				put_unaligned_be32(0xffffffff, ap + 0);
  2847			else
  2848				put_unaligned_be32(sdebug_capacity, ap + 0);
  2849			if (is_tape) {
  2850				ap[0] = devip->tape_density;
  2851				put_unaligned_be16(devip->tape_blksize, ap + 6);
  2852			} else
  2853				put_unaligned_be16(sdebug_sector_size, ap + 6);
  2854			offset += bd_len;
  2855			ap = arr + offset;
  2856		} else if (16 == bd_len) {
  2857			if (is_tape) {
  2858				mk_sense_invalid_fld(scp, SDEB_IN_DATA, 1, 4);
  2859				return check_condition_result;
  2860			}
  2861			put_unaligned_be64((u64)sdebug_capacity, ap + 0);
  2862			put_unaligned_be32(sdebug_sector_size, ap + 12);
  2863			offset += bd_len;
  2864			ap = arr + offset;
  2865		}
  2866		if (cmd[2] == 0)
  2867			goto only_bd; /* Only block descriptor requested */
  2868	
  2869		/*
  2870		 * N.B. If len>0 before resp_*_pg() call, then form of that call should be:
  2871		 *        len += resp_*_pg(ap + len, pcontrol, target);
  2872		 */
  2873		switch (pcode) {
  2874		case 0x1:	/* Read-Write error recovery page, direct access */
  2875			if (subpcode > 0x0 && subpcode < 0xff)
  2876				goto bad_subpcode;
  2877			len = resp_err_recov_pg(ap, pcontrol, target);
  2878			offset += len;
  2879			break;
  2880		case 0x2:	/* Disconnect-Reconnect page, all devices */
  2881			if (subpcode > 0x0 && subpcode < 0xff)
  2882				goto bad_subpcode;
  2883			len = resp_disconnect_pg(ap, pcontrol, target);
  2884			offset += len;
  2885			break;
  2886		case 0x3:       /* Format device page, direct access */
  2887			if (subpcode > 0x0 && subpcode < 0xff)
  2888				goto bad_subpcode;
  2889			if (is_disk) {
  2890				len = resp_format_pg(ap, pcontrol, target);
  2891				offset += len;
  2892			} else {
  2893				goto bad_pcode;
  2894			}
  2895			break;
  2896		case 0x8:	/* Caching page, direct access */
  2897			if (subpcode > 0x0 && subpcode < 0xff)
  2898				goto bad_subpcode;
  2899			if (is_disk || is_zbc) {
  2900				len = resp_caching_pg(ap, pcontrol, target);
  2901				offset += len;
  2902			} else {
  2903				goto bad_pcode;
  2904			}
  2905			break;
  2906		case 0xa:	/* Control Mode page, all devices */
  2907			switch (subpcode) {
  2908			case 0:
  2909				len = resp_ctrl_m_pg(ap, pcontrol, target);
  2910				break;
  2911			case 0x05:
  2912				len = resp_grouping_m_pg(ap, pcontrol, target);
  2913				break;
  2914			case 0xff:
  2915				len = resp_ctrl_m_pg(ap, pcontrol, target);
  2916				len += resp_grouping_m_pg(ap + len, pcontrol, target);
  2917				break;
  2918			default:
  2919				goto bad_subpcode;
  2920			}
  2921			offset += len;
  2922			break;
  2923		case 0x11:	/* Partition Mode Page (tape) */
  2924			if (!is_tape)
  2925				goto bad_pcode;
> 2926			len += resp_partition_m_pg(ap, pcontrol, target);
  2927			offset += len;
  2928			break;
  2929		case 0x19:	/* if spc==1 then sas phy, control+discover */
  2930			if (subpcode > 0x2 && subpcode < 0xff)
  2931				goto bad_subpcode;
  2932			len = 0;
  2933			if ((0x0 == subpcode) || (0xff == subpcode))
  2934				len += resp_sas_sf_m_pg(ap + len, pcontrol, target);
  2935			if ((0x1 == subpcode) || (0xff == subpcode))
  2936				len += resp_sas_pcd_m_spg(ap + len, pcontrol, target,
  2937							  target_dev_id);
  2938			if ((0x2 == subpcode) || (0xff == subpcode))
  2939				len += resp_sas_sha_m_spg(ap + len, pcontrol);
  2940			offset += len;
  2941			break;
  2942		case 0x1c:	/* Informational Exceptions Mode page, all devices */
  2943			if (subpcode > 0x0 && subpcode < 0xff)
  2944				goto bad_subpcode;
  2945			len = resp_iec_m_pg(ap, pcontrol, target);
  2946			offset += len;
  2947			break;
  2948		case 0x3f:	/* Read all Mode pages */
  2949			if (subpcode > 0x0 && subpcode < 0xff)
  2950				goto bad_subpcode;
  2951			len = resp_err_recov_pg(ap, pcontrol, target);
  2952			len += resp_disconnect_pg(ap + len, pcontrol, target);
  2953			if (is_disk) {
  2954				len += resp_format_pg(ap + len, pcontrol, target);
  2955				len += resp_caching_pg(ap + len, pcontrol, target);
  2956			} else if (is_zbc) {
  2957				len += resp_caching_pg(ap + len, pcontrol, target);
  2958			}
  2959			len += resp_ctrl_m_pg(ap + len, pcontrol, target);
  2960			if (0xff == subpcode)
  2961				len += resp_grouping_m_pg(ap + len, pcontrol, target);
  2962			len += resp_sas_sf_m_pg(ap + len, pcontrol, target);
  2963			if (0xff == subpcode) {
  2964				len += resp_sas_pcd_m_spg(ap + len, pcontrol, target,
  2965							  target_dev_id);
  2966				len += resp_sas_sha_m_spg(ap + len, pcontrol);
  2967			}
  2968			len += resp_iec_m_pg(ap + len, pcontrol, target);
  2969			offset += len;
  2970			break;
  2971		default:
  2972			goto bad_pcode;
  2973		}
  2974	only_bd:
  2975		if (msense_6)
  2976			arr[0] = offset - 1;
  2977		else
  2978			put_unaligned_be16((offset - 2), arr + 0);
  2979		return fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, offset));
  2980	
  2981	bad_pcode:
  2982		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
  2983		return check_condition_result;
  2984	
  2985	bad_subpcode:
  2986		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
  2987		return check_condition_result;
  2988	}
  2989	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
