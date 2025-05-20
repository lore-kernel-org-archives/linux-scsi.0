Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116931D54E3;
	Tue, 20 May 2025 13:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747748146; cv=none; b=XX2qxRLxUgIqHW4PTwX7TKKRCZrbRsIPvrYLhPzW5R4iW06G9uyTZ0yaAIPAcLbefpImoEkuDgEyRJGWs2I0V7knhVgbikFB7QGr4PSDPEOCcKacUAqSPuEK2038+t8eQjBmkY3TVhxCwaeDbowLEp3NtcS9M3piMItoxO1dWTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747748146; c=relaxed/simple;
	bh=JQ/+RK7ut2lZjN+rTHfjW5dbIY7cfU3p7INKmyzD7yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SsRVX+bl5rbrtrt/gytdU0eqp3a9Cco4ZJfErFkwjW7AXU1GXty/eIgwRk49aaoOEIzucDUWdXu2NTWLbvW4OF6zGAMuQil9wkaRMXHD9MIFhUqB8LOGEj/GHORB4gtrKnFq/VlTYt1KNA91AG32+zbwWdwW1xlKsYg9ACIdjPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mZFmGgcG; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mZFmGgcG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747748144; x=1779284144;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JQ/+RK7ut2lZjN+rTHfjW5dbIY7cfU3p7INKmyzD7yo=;
  b=mZFmGgcGosb9VYxhY6NAvgJwAnwS+tVzsLSfBAcVX5oE2hpWRP+jp96R
   tg8G5rU/frdzybLXV979D5LEYGcNBwtYfYRQk+taPsN/l0fLvOb1HFQ2T
   qRxTt0+KCrpwLXO/Qy7rDs2qoCd8bFfNT2/FC8e7Rjk2xPS3tIYbfdz41
   TqHceFgHbd1i4DlaiUIgzV3YqVni6QWnVTx6ZI0wTWFQkIw3u2jYcEr78
   VRe1Y+UgMTvaQdZoWERJxq9ed6rYzrSXebrwL1VCAr90zKXPj5POZdvZK
   3zgMLG2nGOMembX57sI9ysYoSh4fcpLLO2bnxC1sKULTBk3n7kDUUBMyb
   w==;
X-CSE-ConnectionGUID: UuYcyb6SQJuyUK0USiBUig==
X-CSE-MsgGUID: UqgCIdcBQzO/7Xt1knKRJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="67091819"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="67091819"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 06:35:44 -0700
X-CSE-ConnectionGUID: 6ckYr3rXTzuGb6lw4RNhJw==
X-CSE-MsgGUID: uhNkDd8ORyC6+j+LUmntog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="139540585"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 20 May 2025 06:35:41 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uHN85-000Mcy-28;
	Tue, 20 May 2025 13:35:37 +0000
Date: Tue, 20 May 2025 21:35:21 +0800
From: kernel test robot <lkp@intel.com>
To: Kassey Li <quic_yingangl@quicinc.com>, rostedt@goodmis.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	quic_yingangl@quicinc.com
Subject: Re: [PATCH v3] scsi: trace: change the rtn log in string
Message-ID: <202505202106.Y2BDIohp-lkp@intel.com>
References: <20250520010405.3844511-1-quic_yingangl@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520010405.3844511-1-quic_yingangl@quicinc.com>

Hi Kassey,

kernel test robot noticed the following build errors:

[auto build test ERROR on trace/for-next]
[also build test ERROR on jejb-scsi/for-next mkp-scsi/for-next linus/master v6.15-rc7 next-20250516]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kassey-Li/scsi-trace-change-the-rtn-log-in-string/20250520-090745
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20250520010405.3844511-1-quic_yingangl%40quicinc.com
patch subject: [PATCH v3] scsi: trace: change the rtn log in string
config: riscv-randconfig-002-20250520 (https://download.01.org/0day-ci/archive/20250520/202505202106.Y2BDIohp-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project f819f46284f2a79790038e1f6649172789734ae8)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250520/202505202106.Y2BDIohp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505202106.Y2BDIohp-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/scsi/scsi.c:73:
   In file included from include/trace/events/scsi.h:358:
   In file included from include/trace/define_trace.h:132:
   In file included from include/trace/trace_events.h:256:
>> include/trace/events/scsi.h:256:5: error: call to undeclared function 'show_rtn_type'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     256 |                   show_rtn_type(__entry->rtn)
         |                   ^
   include/trace/events/scsi.h:256:5: warning: format specifies type 'char *' but the argument has type 'int' [-Wformat]
     209 |                 __entry->prot_op        = scsi_get_prot_op(cmd);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     210 |                 memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     211 |         ),
         |         ~~
     212 | 
     213 |         TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     214 |                   " prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s)" \
         |                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     215 |                   " rtn=%s",
         |                   ~~~~~~~~~~
         |                         %d
     216 |                   __entry->host_no, __entry->channel, __entry->id,
         |                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     217 |                   __entry->lun, __entry->data_sglen, __entry->prot_sglen,
         |                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     218 |                   show_prot_op_name(__entry->prot_op), __entry->driver_tag,
         |                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     219 |                   __entry->scheduler_tag, show_opcode_name(__entry->opcode),
         |                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     220 |                   __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
         |                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     221 |                   __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
         |                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     222 |                   show_rtn_type(__entry->rtn)
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
     223 |           )
         |           ~
     224 | );
         | ~
   include/trace/stages/stage3_trace_output.h:9:43: note: expanded from macro 'TP_printk'
       9 | #define TP_printk(fmt, args...) fmt "\n", args
         |                                 ~~~       ^
   include/trace/trace_events.h:45:16: note: expanded from macro 'TRACE_EVENT'
      40 |         DECLARE_EVENT_CLASS(name,                              \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      41 |                              PARAMS(proto),                    \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      42 |                              PARAMS(args),                     \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      43 |                              PARAMS(tstruct),                  \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      44 |                              PARAMS(assign),                   \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      45 |                              PARAMS(print));                   \
         |                              ~~~~~~~^~~~~~~
   include/linux/tracepoint.h:139:25: note: expanded from macro 'PARAMS'
     139 | #define PARAMS(args...) args
         |                         ^~~~
   include/trace/trace_events.h:219:27: note: expanded from macro 'DECLARE_EVENT_CLASS'
     219 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   1 warning and 1 error generated.


vim +/show_rtn_type +256 include/trace/events/scsi.h

   210	
   211		TP_PROTO(struct scsi_cmnd *cmd, int rtn),
   212	
   213		TP_ARGS(cmd, rtn),
   214	
   215		TP_STRUCT__entry(
   216			__field( unsigned int,	host_no	)
   217			__field( unsigned int,	channel	)
   218			__field( unsigned int,	id	)
   219			__field( unsigned int,	lun	)
   220			__field( int,		rtn	)
   221			__field( unsigned int,	opcode	)
   222			__field( unsigned int,	cmd_len )
   223			__field( int,	driver_tag)
   224			__field( int,	scheduler_tag)
   225			__field( unsigned int,	data_sglen )
   226			__field( unsigned int,	prot_sglen )
   227			__field( unsigned char,	prot_op )
   228			__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
   229		),
   230	
   231		TP_fast_assign(
   232			__entry->host_no	= cmd->device->host->host_no;
   233			__entry->channel	= cmd->device->channel;
   234			__entry->id		= cmd->device->id;
   235			__entry->lun		= cmd->device->lun;
   236			__entry->rtn		= rtn;
   237			__entry->opcode		= cmd->cmnd[0];
   238			__entry->cmd_len	= cmd->cmd_len;
   239			__entry->driver_tag	= scsi_cmd_to_rq(cmd)->tag;
   240			__entry->scheduler_tag	= scsi_cmd_to_rq(cmd)->internal_tag;
   241			__entry->data_sglen	= scsi_sg_count(cmd);
   242			__entry->prot_sglen	= scsi_prot_sg_count(cmd);
   243			__entry->prot_op	= scsi_get_prot_op(cmd);
   244			memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
   245		),
   246	
   247		TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
   248			  " prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s)" \
   249			  " rtn=%s",
   250			  __entry->host_no, __entry->channel, __entry->id,
   251			  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
   252			  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
   253			  __entry->scheduler_tag, show_opcode_name(__entry->opcode),
   254			  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
   255			  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
 > 256			  show_rtn_type(__entry->rtn)
   257		  )
   258	);
   259	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
