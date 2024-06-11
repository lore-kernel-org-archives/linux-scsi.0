Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AB43BB25;
	Tue, 11 Jun 2024 16:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718122374; cv=none; b=he9sC1lCR6KYzlq/4vgRM9Bl0zngvp7/GZeYEFGpAghFNVfCkPY2JRD+2PvXFiDA3CC/P7GUJzuHG8ysgsH5bqSbahQtO0cbmv0UmULeyspoqa2dTtZt3V3/AkSghIN1OJhNki0SVuyxBdrHtnmKQwCH7bpelbR0Rb+P12EjUck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718122374; c=relaxed/simple;
	bh=aPD5BY/1I90SQGbcQ68RrIeaNtfo2nOIAdiK3DWiy+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LwePZaf2I1BYBvCNoMotKJaVgwnontq2DZYSQ4EXbWBWpWu6X5iXPBlE2hgxgDVYN3LGBNrKflVmKRP9fAsmi+WL+PJH5Q6CdS8lRSuqb03gBd+bN4Qf83tdtWASmxd5nygsEPQF055lsD5cjmzNaVoTY0WjOMnNWKxsK0CV1Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dhXcPV19; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dhXcPV19"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718122371; x=1749658371;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aPD5BY/1I90SQGbcQ68RrIeaNtfo2nOIAdiK3DWiy+U=;
  b=dhXcPV19RwmgjtuEiNftd4FARCQM/m6J0Yexho6aRLktTyPYuUGGlevg
   MAtfrXXIIVsNS5d7U7DjyEuTbbvvjrdWY+YVgxWw58I/5TWYNJJvx7udf
   IzBNry77z+LLRq6kAiDf9HH7oZl8EafGuoC5VXT4f58s2cTtkBgl+Mm4b
   Ls4PCnAwCzetDxVpYOhhVaCr/suGvjJkd/IyJRr28dRe0j4SPh/el4ftZ
   r2Ys0h7QOfN9KVL+IhGMTsisU7iAMoYeQuGjqc1iBb3dl7Q5z0bfKDSVd
   OWtr7wzyHmHOUaXOgW4QkROfm+KFtUbCEN4JcsgwdkFloeaqdiMr8o1m3
   g==;
X-CSE-ConnectionGUID: leJJVD2eTC6dV54EwW1pag==
X-CSE-MsgGUID: TBW2DkdISXOmhqMLb5q23Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="18673551"
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="18673551"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 09:12:49 -0700
X-CSE-ConnectionGUID: P3LRiBSUS0y2lK76H7d94g==
X-CSE-MsgGUID: 7XtO6liXQha1Hl60rbxGeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="43888609"
Received: from lkp-server01.sh.intel.com (HELO 628d7d8b9fc6) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 11 Jun 2024 09:12:46 -0700
Received: from kbuild by 628d7d8b9fc6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sH472-0000eA-0H;
	Tue, 11 Jun 2024 16:12:44 +0000
Date: Wed, 12 Jun 2024 00:12:27 +0800
From: kernel test robot <lkp@intel.com>
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, arulponn@cisco.com,
	djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
	satishkh@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: Re: [PATCH 03/14] scsi: fnic: Add support for fabric based solicited
 requests and responses
Message-ID: <202406112309.8GiDUvIM-lkp@intel.com>
References: <20240610215100.673158-4-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610215100.673158-4-kartilak@cisco.com>

Hi Karan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.10-rc3 next-20240611]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Karan-Tilak-Kumar/scsi-fnic-Replace-shost_printk-with-pr_info-pr_err/20240611-060227
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240610215100.673158-4-kartilak%40cisco.com
patch subject: [PATCH 03/14] scsi: fnic: Add support for fabric based solicited requests and responses
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20240611/202406112309.8GiDUvIM-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240611/202406112309.8GiDUvIM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406112309.8GiDUvIM-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/fnic/fdls_disc.c:894:10: warning: variable 'reason_code' set but not used [-Wunused-but-set-variable]
     894 |         uint8_t reason_code;
         |                 ^
>> drivers/scsi/fnic/fdls_disc.c:1009:26: warning: variable 'els_rjt' set but not used [-Wunused-but-set-variable]
    1009 |         struct fc_els_reject_s *els_rjt;
         |                                 ^
>> drivers/scsi/fnic/fdls_disc.c:1520:11: warning: variable 's_id' set but not used [-Wunused-but-set-variable]
    1520 |         uint32_t s_id = 0;
         |                  ^
>> drivers/scsi/fnic/fdls_disc.c:1521:11: warning: variable 'd_id' set but not used [-Wunused-but-set-variable]
    1521 |         uint32_t d_id = 0;
         |                  ^
   drivers/scsi/fnic/fdls_disc.c:627:13: warning: unused function 'fnic_fdls_start_flogi' [-Wunused-function]
     627 | static void fnic_fdls_start_flogi(struct fnic_iport_s *iport)
         |             ^~~~~~~~~~~~~~~~~~~~~
   5 warnings generated.


vim +/els_rjt +1009 drivers/scsi/fnic/fdls_disc.c

  1000	
  1001	static void
  1002	fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
  1003						   void *rx_frame)
  1004	{
  1005		struct fnic_fdls_fabric_s *fabric = &iport->fabric;
  1006		struct fc_els_s *flogi_rsp = (struct fc_els_s *) fchdr;
  1007		uint8_t *fcid;
  1008		int rdf_size;
> 1009		struct fc_els_reject_s *els_rjt;
  1010		uint8_t fcmac[6] = { 0x0E, 0XFC, 0x00, 0x00, 0x00, 0x00 };
  1011		struct fnic *fnic = iport->fnic;
  1012	
  1013		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1014					 "0x%x: FDLS processing FLOGI response", iport->fcid);
  1015	
  1016		if (fdls_get_state(fabric) != FDLS_STATE_FABRIC_FLOGI) {
  1017			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1018						 "FLOGI response received in state (%d). Dropping frame",
  1019						 fdls_get_state(fabric));
  1020			return;
  1021		}
  1022	
  1023		switch (flogi_rsp->command) {
  1024		case FC_LS_ACC:
  1025			if (iport->fabric.timer_pending) {
  1026				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1027							 "iport fcid: 0x%x Canceling fabric disc timer\n",
  1028							 iport->fcid);
  1029				fnic_del_fabric_timer_sync();
  1030			}
  1031	
  1032			iport->fabric.timer_pending = 0;
  1033			iport->fabric.retry_counter = 0;
  1034			fcid = FNIC_GET_D_ID(fchdr);
  1035			iport->fcid = ntoh24(fcid);
  1036			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1037						 "0x%x: FLOGI response accepted", iport->fcid);
  1038	
  1039			/* Learn the Service Params */
  1040			rdf_size = ntohs(flogi_rsp->u.csp_flogi.b2b_rdf_size);
  1041			if ((rdf_size >= FNIC_MIN_DATA_FIELD_SIZE)
  1042				&& (rdf_size < FNIC_FC_MAX_PAYLOAD_LEN))
  1043				iport->max_payload_size = MIN(rdf_size,
  1044									  iport->max_payload_size);
  1045	
  1046			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1047						 "max_payload_size from fabric: %d set: %d", rdf_size,
  1048						 iport->max_payload_size);
  1049	
  1050			iport->r_a_tov = ntohl(flogi_rsp->u.csp_flogi.r_a_tov);
  1051			iport->e_d_tov = ntohl(flogi_rsp->u.csp_flogi.e_d_tov);
  1052	
  1053			if (flogi_rsp->u.csp_flogi.features & FNIC_FC_EDTOV_NSEC)
  1054				iport->e_d_tov = iport->e_d_tov / FNIC_NSEC_TO_MSEC;
  1055	
  1056			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1057						 "From fabric: R_A_TOV: %d E_D_TOV: %d",
  1058						 iport->r_a_tov, iport->e_d_tov);
  1059	
  1060			if (IS_FNIC_FCP_INITIATOR(fnic)) {
  1061				fc_host_fabric_name(iport->fnic->lport->host) =
  1062					get_unaligned_be64(&flogi_rsp->node_name);
  1063				fc_host_port_id(iport->fnic->lport->host) = iport->fcid;
  1064			}
  1065	
  1066			fnic_fdls_learn_fcoe_macs(iport, rx_frame, fcid);
  1067	
  1068			memcpy(&fcmac[3], fcid, 3);
  1069			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1070				 "Adding vNIC device MAC addr: %02x:%02x:%02x:%02x:%02x:%02x",
  1071				 fcmac[0], fcmac[1], fcmac[2], fcmac[3], fcmac[4],
  1072				 fcmac[5]);
  1073			vnic_dev_add_addr(iport->fnic->vdev, fcmac);
  1074	
  1075			if (fdls_get_state(fabric) == FDLS_STATE_FABRIC_FLOGI) {
  1076				fnic_fdls_start_plogi(iport);
  1077				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1078							 "FLOGI response received. Starting PLOGI");
  1079			} else {
  1080				/* From FDLS_STATE_FABRIC_FLOGI state fabric can only go to
  1081				 * FDLS_STATE_LINKDOWN
  1082				 * state, hence we don't have to worry about undoing:
  1083				 * the fnic_fdls_register_portid and vnic_dev_add_addr
  1084				 */
  1085				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1086					 "FLOGI response received in state (%d). Dropping frame",
  1087					 fdls_get_state(fabric));
  1088			}
  1089			break;
  1090	
  1091		case FC_LS_REJ:
  1092			els_rjt = (struct fc_els_reject_s *) fchdr;
  1093			if (fabric->retry_counter < iport->max_flogi_retries) {
  1094				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1095					 "FLOGI returned FC_LS_REJ BUSY. Retry from timer routine %p",
  1096					 iport);
  1097	
  1098				/* Retry Flogi again from the timer routine. */
  1099				fabric->flags |= FNIC_FDLS_RETRY_FRAME;
  1100	
  1101			} else {
  1102				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1103						 "FLOGI returned FC_LS_REJ. Halting discovery %p", iport);
  1104				if (iport->fabric.timer_pending) {
  1105					FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1106								 "iport 0x%p Canceling fabric disc timer\n",
  1107								 iport);
  1108					fnic_del_fabric_timer_sync();
  1109				}
  1110				fabric->timer_pending = 0;
  1111				fabric->retry_counter = 0;
  1112			}
  1113			break;
  1114	
  1115		default:
  1116			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1117						 "FLOGI response not accepted: 0x%x",
  1118						 flogi_rsp->command);
  1119			break;
  1120		}
  1121	}
  1122	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
