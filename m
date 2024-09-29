Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05279143888;
	Sun, 29 Sep 2024 09:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727603069; cv=none; b=m8da9lVFMeBu2REgcWNMiaDr2Uo4Ut+iS7coX2aHBZg0Nq2d3e3mfTqrK+7zRDkufWXvgIqAocOwZg7PEYIHU549EJlqsdJQlLueq33QUS0oCvg8owfQ0VKgAwy/wK1bZwQ/G139+w1L2oCEUQg5ukI4ynZVl8mGBHcx3QhbF1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727603069; c=relaxed/simple;
	bh=5ugB3q/y4M7T75eyYGxcbN5U2536k647rL1C1Ay2lqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kj/VlgXASvxN76nt4j14Zn3yMSol9MNwluPn//oHL+q4Qm9TrwGaUCEQ9F/2zrl9It36VEsuZdEEZCDlu3+wuFovXx1/ahJov1SWwtCAejG5kt7ZQC4eIh47vI28MI9d3kwDbngpx2pD00+HDB/JZo0gad5P9g8vru+/ahoqkTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N72edeqJ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N72edeqJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727603067; x=1759139067;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5ugB3q/y4M7T75eyYGxcbN5U2536k647rL1C1Ay2lqU=;
  b=N72edeqJUVppyNvwEIQ7ZPOkkl/kQZc4rZSeTCPCWarcJrRitMg3ibRR
   qnhRNkHAy1tl0AG6tvoNuylSWj7c0iZNcW+uTu/IKFjlZoXyFvcFZkT5b
   gx1xPTMR91ULoTGmdjohijMJYGMyfbvlvuEY5vteGw71IAhS/v92oqlvr
   EMWihbwLyoZVTIYeuPjduMp5jmLclsntHrGHKFiKY7YV7PzQVDBnj48Oe
   QuZAqV162fxn9Ra/UUphnLwTwOL8Ft1HLdBwkh1AALmQFBvKtjzLkXic3
   xUiHgxpGu1QdEB2iH3nLvwHH4psGb5Bx/10KBi7ZFS9dskk5SLhTIn5Z2
   Q==;
X-CSE-ConnectionGUID: i3lUEvP9SJuOwMFZiQuKSQ==
X-CSE-MsgGUID: hLKiMdPxSpazh82EH53EEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11209"; a="26576009"
X-IronPort-AV: E=Sophos;i="6.11,162,1725346800"; 
   d="scan'208";a="26576009"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2024 02:44:26 -0700
X-CSE-ConnectionGUID: cK9Rr4qQQ5Ocoqar768zBw==
X-CSE-MsgGUID: CF24SmO/SiCPTwM6BYZ4xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,162,1725346800"; 
   d="scan'208";a="73402908"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 29 Sep 2024 02:44:22 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1suqTU-000OAl-0d;
	Sun, 29 Sep 2024 09:44:20 +0000
Date: Sun, 29 Sep 2024 17:44:01 +0800
From: kernel test robot <lkp@intel.com>
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, arulponn@cisco.com,
	djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
	satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: Re: [PATCH v3 05/14] scsi: fnic: Add support for unsolicited
 requests and responses
Message-ID: <202409291705.MugERX98-lkp@intel.com>
References: <20240927184613.52172-6-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240927184613.52172-6-kartilak@cisco.com>

Hi Karan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.11 next-20240927]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Karan-Tilak-Kumar/scsi-fnic-Replace-shost_printk-with-dev_info-dev_err/20240928-025906
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240927184613.52172-6-kartilak%40cisco.com
patch subject: [PATCH v3 05/14] scsi: fnic: Add support for unsolicited requests and responses
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20240929/202409291705.MugERX98-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240929/202409291705.MugERX98-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409291705.MugERX98-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/fnic/fdls_disc.c:3333:11: warning: variable 'nport_name' set but not used [-Wunused-but-set-variable]
    3333 |         uint64_t nport_name;
         |                  ^
>> drivers/scsi/fnic/fdls_disc.c:3414:6: warning: variable 'newports' set but not used [-Wunused-but-set-variable]
    3414 |         int newports = 0;
         |             ^
   drivers/scsi/fnic/fdls_disc.c:1685:13: warning: unused function 'fnic_fdls_start_flogi' [-Wunused-function]
    1685 | static void fnic_fdls_start_flogi(struct fnic_iport_s *iport)
         |             ^~~~~~~~~~~~~~~~~~~~~
   3 warnings generated.


vim +/nport_name +3333 drivers/scsi/fnic/fdls_disc.c

  3327	
  3328	static void
  3329	fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
  3330	{
  3331		struct fc_std_logo *logo = (struct fc_std_logo *)fchdr;
  3332		uint32_t nport_id;
> 3333		uint64_t nport_name;
  3334		struct fnic_tport_s *tport;
  3335		struct fnic *fnic = iport->fnic;
  3336		uint16_t oxid;
  3337	
  3338		nport_id = ntoh24(logo->els.fl_n_port_id);
  3339		nport_name = logo->els.fl_n_port_wwn;
  3340	
  3341		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  3342					 "Process LOGO request from fcid: 0x%x", nport_id);
  3343	
  3344		if (iport->state != FNIC_IPORT_STATE_READY) {
  3345			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
  3346				 "Dropping LOGO req from 0x%x in iport state: %d",
  3347				 nport_id, iport->state);
  3348			return;
  3349		}
  3350	
  3351		tport = fnic_find_tport_by_fcid(iport, nport_id);
  3352	
  3353		if (!tport) {
  3354			/* We are not logged in with the nport, log and drop... */
  3355			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
  3356						 "Received LOGO from an nport not logged in: 0x%x",
  3357						 nport_id);
  3358			return;
  3359		}
  3360		if (tport->fcid != nport_id) {
  3361			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
  3362						 "Received LOGO with invalid target port fcid: 0x%x",
  3363						 nport_id);
  3364			return;
  3365		}
  3366		if (tport->timer_pending) {
  3367			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
  3368						 "tport fcid 0x%x: Canceling disc timer\n",
  3369						 tport->fcid);
  3370			fnic_del_tport_timer_sync(fnic, tport);
  3371			tport->timer_pending = 0;
  3372		}
  3373	
  3374		/* got a logo in response to adisc to a target which has logged out */
  3375		if (tport->state == FDLS_TGT_STATE_ADISC) {
  3376			tport->retry_counter = 0;
  3377			oxid = ntohs(tport->oxid_used);
  3378			fdls_free_tgt_oxid(iport, &iport->adisc_oxid_pool, oxid);
  3379			fdls_delete_tport(iport, tport);
  3380			fdls_send_logo_resp(iport, &logo->fchdr);
  3381			if ((iport->state == FNIC_IPORT_STATE_READY)
  3382				&& (fdls_get_state(&iport->fabric) != FDLS_STATE_SEND_GPNFT)
  3383				&& (fdls_get_state(&iport->fabric) != FDLS_STATE_RSCN_GPN_FT)) {
  3384				FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
  3385							 "Sending GPNFT in response to LOGO from Target:0x%x",
  3386							 nport_id);
  3387				fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
  3388				return;
  3389			}
  3390		} else {
  3391			fdls_delete_tport(iport, tport);
  3392		}
  3393		if (iport->state == FNIC_IPORT_STATE_READY) {
  3394			fdls_send_logo_resp(iport, &logo->fchdr);
  3395			if ((fdls_get_state(&iport->fabric) != FDLS_STATE_SEND_GPNFT) &&
  3396				(fdls_get_state(&iport->fabric) != FDLS_STATE_RSCN_GPN_FT)) {
  3397				FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
  3398							 "Sending GPNFT in response to LOGO from Target:0x%x",
  3399							 nport_id);
  3400				fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
  3401			}
  3402		}
  3403	}
  3404	
  3405	static void
  3406	fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
  3407	{
  3408		struct fc_std_rscn *rscn;
  3409		struct fc_els_rscn_page *rscn_port = NULL;
  3410		int num_ports;
  3411		struct fnic_tport_s *tport, *next;
  3412		uint32_t nport_id;
  3413		uint8_t fcid[3];
> 3414		int newports = 0;
  3415		struct fnic_fdls_fabric_s *fdls = &iport->fabric;
  3416		struct fnic *fnic = iport->fnic;
  3417		uint16_t rscn_payload_len;
  3418	
  3419		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  3420					 "FDLS process RSCN %p", iport);
  3421	
  3422		if (iport->state != FNIC_IPORT_STATE_READY) {
  3423			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  3424						 "FDLS RSCN received in state(%d). Dropping",
  3425						 fdls_get_state(fdls));
  3426			return;
  3427		}
  3428	
  3429		rscn = (struct fc_std_rscn *)fchdr;
  3430		rscn_payload_len = be16_to_cpu(rscn->els.rscn_plen);
  3431	
  3432		/* frame validation */
  3433		if ((rscn_payload_len % 4 != 0) || (rscn_payload_len < 8)
  3434		    || (rscn_payload_len > 1024)
  3435		    || (rscn->els.rscn_page_len != 4)) {
  3436			num_ports = 0;
  3437			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  3438						 "RSCN payload_len: 0x%x page_len: 0x%x",
  3439					     rscn_payload_len, rscn->els.rscn_page_len);
  3440			/* if this happens then we need to send ADISC to all the tports. */
  3441			list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
  3442				if (tport->state == FDLS_TGT_STATE_READY)
  3443					tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
  3444				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  3445							 "RSCN for port id: 0x%x", tport->fcid);
  3446			}
  3447		} else {
  3448			num_ports = (rscn_payload_len - 4) / rscn->els.rscn_page_len;
  3449			rscn_port = (struct fc_els_rscn_page *)(rscn + 1);
  3450		}
  3451		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  3452				 "RSCN received for num_ports: %d payload_len: %d page_len: %d ",
  3453			     num_ports, rscn_payload_len, rscn->els.rscn_page_len);
  3454	
  3455		/*
  3456		 * RSCN have at least one Port_ID page , but may not have any port_id
  3457		 * in it. If no port_id is specified in the Port_ID page , we send
  3458		 * ADISC to all the tports
  3459		 */
  3460	
  3461		while (num_ports) {
  3462	
  3463			memcpy(fcid, rscn_port->rscn_fid, 3);
  3464	
  3465			nport_id = ntoh24(fcid);
  3466			rscn_port++;
  3467			num_ports--;
  3468			/* if this happens then we need to send ADISC to all the tports. */
  3469			if (nport_id == 0) {
  3470				list_for_each_entry_safe(tport, next, &iport->tport_list,
  3471										 links) {
  3472					if (tport->state == FDLS_TGT_STATE_READY)
  3473						tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
  3474	
  3475					FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  3476								 "RSCN for port id: 0x%x", tport->fcid);
  3477				}
  3478				break;
  3479			}
  3480			tport = fnic_find_tport_by_fcid(iport, nport_id);
  3481	
  3482			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  3483						 "RSCN port id list: 0x%x", nport_id);
  3484	
  3485			if (!tport) {
  3486				newports++;
  3487				continue;
  3488			}
  3489			if (tport->state == FDLS_TGT_STATE_READY)
  3490				tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
  3491		}
  3492	
  3493		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  3494					 "FDLS process RSCN sending GPN_FT %p", iport);
  3495		fdls_send_gpn_ft(iport, FDLS_STATE_RSCN_GPN_FT);
  3496		fdls_send_rscn_resp(iport, fchdr);
  3497	}
  3498	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
