Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570C72DAFAE;
	Tue,  2 Dec 2025 19:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764703261; cv=none; b=oWUJUguuVLH7Q+qOa/Ux3FxsWTfibKyp3wMwLeyKlrWsOfxo2NcV10su1PiJbMaQl+VGPwhXAnNHaCMyPhAGTUdkwoUao5e0JyVkSeShleHdU7LhsMQzfm3kHAqXFmBPRq03KqJcU9K4PznIk2LFtxjGo22SgduS7oIAOZkxqRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764703261; c=relaxed/simple;
	bh=q32lN4z3XiKPNxNXBPpZVxb9ivyASyaAlwhe5fnN3ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxtpZ5gF+e+0QnZpB6nAfN6ybPoJvC2mRg/7ewnuZFtLWyV0cjdtt++ks7STFe34XfTFsJKtf57A9ICo9QAFtUI3jcqvC6wD0VZJn2l/aNzSUqFqxf6dHeGEctW79nsUUkcU5lA1RoCUYITZGCzW1lZ715Te3fQmYXVzueqPjwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ezap8Z4M; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ezap8Z4M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764703259; x=1796239259;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=q32lN4z3XiKPNxNXBPpZVxb9ivyASyaAlwhe5fnN3ek=;
  b=Ezap8Z4MPdUQbhOHbfNMt/X0i2+gUatsVAxdNiYxN5veIMZBGNkJC+zA
   8IQRcquvh5JVHYBs16vpfUdYCJLPFTMjQOkWnezeu3ckJVpM6OsQw3/Ag
   geyCtmwwPKzNVz7wd+FfqHeeVVUrXvg8dqpGS/IM9/Ql461/578imFZbP
   973oZNNMarrKt+ftclOQuTVfR3ClzH+Jh3OMOLiaC+FVoBck+aMamf7h5
   SsK1xN9oN5/6isvKonZMh5nM91RO+A9dQ1eayRWlD+OShTlI9w+Rh+qP8
   YDcCbv87PvzvLSi+omOC/C2ip5f0QAsNhF6gg38DFcZcSrKvdVZLUUPm2
   A==;
X-CSE-ConnectionGUID: lESe6rFHSYSouGKvyY884Q==
X-CSE-MsgGUID: 6zNTtRSyQoikx8UbBA9v3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="78151761"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="78151761"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 11:20:50 -0800
X-CSE-ConnectionGUID: CTw/QShmRuS3sNzagv2Fkg==
X-CSE-MsgGUID: Q+MirQL0QlKOVlnEHmFllg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="225149371"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 02 Dec 2025 11:20:48 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vQVvZ-00000000A8n-0uC4;
	Tue, 02 Dec 2025 19:20:45 +0000
Date: Wed, 3 Dec 2025 03:20:16 +0800
From: kernel test robot <lkp@intel.com>
To: Po-Wen Kao <powenkao@google.com>
Cc: oe-kbuild-all@lists.linux.dev, Brian Kao <powenkao@google.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: core: Fix error handler encryption support
Message-ID: <202512030247.AllzCFdb-lkp@intel.com>
References: <20251202011529.73738-1-powenkao@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202011529.73738-1-powenkao@google.com>

Hi Po-Wen,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.18 next-20251202]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Po-Wen-Kao/scsi-core-Fix-error-handler-encryption-support/20251202-091809
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251202011529.73738-1-powenkao%40google.com
patch subject: [PATCH 1/1] scsi: core: Fix error handler encryption support
config: i386-randconfig-013-20251202 (https://download.01.org/0day-ci/archive/20251203/202512030247.AllzCFdb-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251203/202512030247.AllzCFdb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512030247.AllzCFdb-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/scsi/scsi_error.c: In function 'scsi_eh_prep_cmnd':
>> drivers/scsi/scsi_error.c:1122:35: error: 'struct request' has no member named 'crypt_keyslot'
    1122 |         ses->rq_crypt_keyslot = rq->crypt_keyslot;
         |                                   ^~
>> drivers/scsi/scsi_error.c:1123:31: error: 'struct request' has no member named 'crypt_ctx'
    1123 |         ses->rq_crypt_ctx = rq->crypt_ctx;
         |                               ^~
   drivers/scsi/scsi_error.c:1125:11: error: 'struct request' has no member named 'crypt_keyslot'
    1125 |         rq->crypt_keyslot = NULL;
         |           ^~
   drivers/scsi/scsi_error.c:1126:11: error: 'struct request' has no member named 'crypt_ctx'
    1126 |         rq->crypt_ctx = NULL;
         |           ^~
   drivers/scsi/scsi_error.c: In function 'scsi_eh_restore_cmnd':
   drivers/scsi/scsi_error.c:1160:11: error: 'struct request' has no member named 'crypt_keyslot'
    1160 |         rq->crypt_keyslot = ses->rq_crypt_keyslot;
         |           ^~
   drivers/scsi/scsi_error.c:1161:11: error: 'struct request' has no member named 'crypt_ctx'
    1161 |         rq->crypt_ctx = ses->rq_crypt_ctx;
         |           ^~


vim +1122 drivers/scsi/scsi_error.c

  1047	
  1048	/**
  1049	 * scsi_eh_prep_cmnd  - Save a scsi command info as part of error recovery
  1050	 * @scmd:       SCSI command structure to hijack
  1051	 * @ses:        structure to save restore information
  1052	 * @cmnd:       CDB to send. Can be NULL if no new cmnd is needed
  1053	 * @cmnd_size:  size in bytes of @cmnd (must be <= MAX_COMMAND_SIZE)
  1054	 * @sense_bytes: size of sense data to copy. or 0 (if != 0 @cmnd is ignored)
  1055	 *
  1056	 * This function is used to save a scsi command information before re-execution
  1057	 * as part of the error recovery process.  If @sense_bytes is 0 the command
  1058	 * sent must be one that does not transfer any data.  If @sense_bytes != 0
  1059	 * @cmnd is ignored and this functions sets up a REQUEST_SENSE command
  1060	 * and cmnd buffers to read @sense_bytes into @scmd->sense_buffer.
  1061	 */
  1062	void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
  1063				unsigned char *cmnd, int cmnd_size, unsigned sense_bytes)
  1064	{
  1065		struct scsi_device *sdev = scmd->device;
  1066		struct request *rq = scsi_cmd_to_rq(scmd);
  1067	
  1068		/*
  1069		 * We need saved copies of a number of fields - this is because
  1070		 * error handling may need to overwrite these with different values
  1071		 * to run different commands, and once error handling is complete,
  1072		 * we will need to restore these values prior to running the actual
  1073		 * command.
  1074		 */
  1075		ses->cmd_len = scmd->cmd_len;
  1076		ses->data_direction = scmd->sc_data_direction;
  1077		ses->sdb = scmd->sdb;
  1078		ses->result = scmd->result;
  1079		ses->resid_len = scmd->resid_len;
  1080		ses->underflow = scmd->underflow;
  1081		ses->prot_op = scmd->prot_op;
  1082		ses->eh_eflags = scmd->eh_eflags;
  1083	
  1084		scmd->prot_op = SCSI_PROT_NORMAL;
  1085		scmd->eh_eflags = 0;
  1086		memcpy(ses->cmnd, scmd->cmnd, sizeof(ses->cmnd));
  1087		memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
  1088		memset(&scmd->sdb, 0, sizeof(scmd->sdb));
  1089		scmd->result = 0;
  1090		scmd->resid_len = 0;
  1091	
  1092		if (sense_bytes) {
  1093			scmd->sdb.length = min_t(unsigned, SCSI_SENSE_BUFFERSIZE,
  1094						 sense_bytes);
  1095			sg_init_one(&ses->sense_sgl, scmd->sense_buffer,
  1096				    scmd->sdb.length);
  1097			scmd->sdb.table.sgl = &ses->sense_sgl;
  1098			scmd->sc_data_direction = DMA_FROM_DEVICE;
  1099			scmd->sdb.table.nents = scmd->sdb.table.orig_nents = 1;
  1100			scmd->cmnd[0] = REQUEST_SENSE;
  1101			scmd->cmnd[4] = scmd->sdb.length;
  1102			scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
  1103		} else {
  1104			scmd->sc_data_direction = DMA_NONE;
  1105			if (cmnd) {
  1106				BUG_ON(cmnd_size > sizeof(scmd->cmnd));
  1107				memcpy(scmd->cmnd, cmnd, cmnd_size);
  1108				scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
  1109			}
  1110		}
  1111	
  1112		scmd->underflow = 0;
  1113	
  1114		if (sdev->scsi_level <= SCSI_2 && sdev->scsi_level != SCSI_UNKNOWN)
  1115			scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
  1116				(sdev->lun << 5 & 0xe0);
  1117	
  1118		/*
  1119		 * Encryption must be disabled for the commands submitted by the error handler.
  1120		 * Hence, clear the encryption context information.
  1121		 */
> 1122		ses->rq_crypt_keyslot = rq->crypt_keyslot;
> 1123		ses->rq_crypt_ctx = rq->crypt_ctx;
  1124	
  1125		rq->crypt_keyslot = NULL;
  1126		rq->crypt_ctx = NULL;
  1127	
  1128		/*
  1129		 * Zero the sense buffer.  The scsi spec mandates that any
  1130		 * untransferred sense data should be interpreted as being zero.
  1131		 */
  1132		memset(scmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
  1133	}
  1134	EXPORT_SYMBOL(scsi_eh_prep_cmnd);
  1135	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
