Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DC521C16D;
	Wed, 14 May 2025 23:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747263991; cv=none; b=GCOhmnGC79AI5wZWmj1qCjrdiCyA8P6G4g7olUzLCkdDmLSpLmajpEA+G7Z0yTrue7A525o9ZfYXhyr0qZRRN1qJP7LXntPkjvzWh9A+Ogtsz4Prmhj7azeO+Ss+DGYC6fj5h68MBEh+itgdf3oTNYrDdVuEb4zp8tr7kZOPEJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747263991; c=relaxed/simple;
	bh=A01VC/XGBvtR4zSIg/lwMcnJ/66ILpRzcCVrLYWZ/+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYynQ5hoxxuywPQuHk+le3avjL9CfN+ZbdzKQqJ0zl+nvC5LFihLXb+xFWPwyLXPPfREJP7QKLP7sCy+9DYA9vjMkprY4YbH7dyeDoFA7CemC2LJYMXKhXuwe48DWfoE6Bva5Ygw2P3YpLNcwaFg8pWUKOc+z3964VjccwBOd/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SE10z1FC; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SE10z1FC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747263989; x=1778799989;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A01VC/XGBvtR4zSIg/lwMcnJ/66ILpRzcCVrLYWZ/+o=;
  b=SE10z1FCJMgWeBjBLaeVNUFIB8ANdzlm5we0uvLxhGT2glq6JtXD0Pje
   r8rFrD54x7g7wc/YNLN8Jx+aAzANtmVjy6qPPd5wtkGZf8Bv3mLEC04UY
   +EREnFeqHjZ63a3soFyqydP+W5CQDvX3S2zZZg0/73FG1/gprTsz12v6W
   xg+tsSolvPwNG5bcm35O6dAdxVpyX5/juGceaBBqgAkXRmxvPxQe+fUrT
   +EdXJ0CGD2R1L7OAKqIgNBUo+Ym2ADD1g4cEbVZOVdJS2FznS0lxXfU33
   bIdDriqr9+tqP12Yv+cummwxVr6lxL0r2zKV7vjMnrGfUTVWmtF66qHuw
   g==;
X-CSE-ConnectionGUID: Dj2mYHk3SfeLNXzp9pQMXQ==
X-CSE-MsgGUID: muyK4KjtTT2eidN7VY9dQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="66589842"
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="66589842"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 16:06:28 -0700
X-CSE-ConnectionGUID: zCjpNI4pQ3iF8fFmUIWZOw==
X-CSE-MsgGUID: vN+1BPM1SdeXQi1vBu2dCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="137907482"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 14 May 2025 16:06:26 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uFLB9-000Hfb-2Z;
	Wed, 14 May 2025 23:06:23 +0000
Date: Thu, 15 May 2025 07:05:35 +0800
From: kernel test robot <lkp@intel.com>
To: Kassey Li <quic_yingangl@quicinc.com>, rostedt@goodmis.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, quic_yingangl@quicinc.com
Subject: Re: [PATCH v2] scsi: trace: change the rtn log in string
Message-ID: <202505150658.uk9oRnKr-lkp@intel.com>
References: <20250514074456.450006-1-quic_yingangl@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514074456.450006-1-quic_yingangl@quicinc.com>

Hi Kassey,

kernel test robot noticed the following build errors:

[auto build test ERROR on trace/for-next]
[also build test ERROR on jejb-scsi/for-next mkp-scsi/for-next linus/master v6.15-rc6 next-20250514]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kassey-Li/scsi-trace-change-the-rtn-log-in-string/20250514-155034
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20250514074456.450006-1-quic_yingangl%40quicinc.com
patch subject: [PATCH v2] scsi: trace: change the rtn log in string
config: i386-buildonly-randconfig-001-20250515 (https://download.01.org/0day-ci/archive/20250515/202505150658.uk9oRnKr-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250515/202505150658.uk9oRnKr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505150658.uk9oRnKr-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:119,
                    from include/trace/events/scsi.h:355,
                    from drivers/scsi/scsi.c:73:
   include/trace/events/scsi.h: In function 'trace_raw_output_scsi_dispatch_cmd_error':
>> include/trace/events/scsi.h:250:36: error: 'rtn' undeclared (first use in this function)
     250 |                   __print_symbolic(rtn, { SCSI_MLQUEUE_HOST_BUSY, "HOST_BUSY" },
         |                                    ^~~
   include/trace/trace_events.h:219:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     219 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   include/trace/events/scsi.h:203:1: note: in expansion of macro 'TRACE_EVENT'
     203 | TRACE_EVENT(scsi_dispatch_cmd_error,
         | ^~~~~~~~~~~
   include/trace/events/scsi.h:241:9: note: in expansion of macro 'TP_printk'
     241 |         TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
         |         ^~~~~~~~~
   include/trace/events/scsi.h:250:19: note: in expansion of macro '__print_symbolic'
     250 |                   __print_symbolic(rtn, { SCSI_MLQUEUE_HOST_BUSY, "HOST_BUSY" },
         |                   ^~~~~~~~~~~~~~~~
   include/trace/events/scsi.h:250:36: note: each undeclared identifier is reported only once for each function it appears in
     250 |                   __print_symbolic(rtn, { SCSI_MLQUEUE_HOST_BUSY, "HOST_BUSY" },
         |                                    ^~~
   include/trace/trace_events.h:219:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     219 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   include/trace/events/scsi.h:203:1: note: in expansion of macro 'TRACE_EVENT'
     203 | TRACE_EVENT(scsi_dispatch_cmd_error,
         | ^~~~~~~~~~~
   include/trace/events/scsi.h:241:9: note: in expansion of macro 'TP_printk'
     241 |         TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
         |         ^~~~~~~~~
   include/trace/events/scsi.h:250:19: note: in expansion of macro '__print_symbolic'
     250 |                   __print_symbolic(rtn, { SCSI_MLQUEUE_HOST_BUSY, "HOST_BUSY" },
         |                   ^~~~~~~~~~~~~~~~


vim +/rtn +250 include/trace/events/scsi.h

   204	
   205		TP_PROTO(struct scsi_cmnd *cmd, int rtn),
   206	
   207		TP_ARGS(cmd, rtn),
   208	
   209		TP_STRUCT__entry(
   210			__field( unsigned int,	host_no	)
   211			__field( unsigned int,	channel	)
   212			__field( unsigned int,	id	)
   213			__field( unsigned int,	lun	)
   214			__field( int,		rtn	)
   215			__field( unsigned int,	opcode	)
   216			__field( unsigned int,	cmd_len )
   217			__field( int,	driver_tag)
   218			__field( int,	scheduler_tag)
   219			__field( unsigned int,	data_sglen )
   220			__field( unsigned int,	prot_sglen )
   221			__field( unsigned char,	prot_op )
   222			__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
   223		),
   224	
   225		TP_fast_assign(
   226			__entry->host_no	= cmd->device->host->host_no;
   227			__entry->channel	= cmd->device->channel;
   228			__entry->id		= cmd->device->id;
   229			__entry->lun		= cmd->device->lun;
   230			__entry->rtn		= rtn;
   231			__entry->opcode		= cmd->cmnd[0];
   232			__entry->cmd_len	= cmd->cmd_len;
   233			__entry->driver_tag	= scsi_cmd_to_rq(cmd)->tag;
   234			__entry->scheduler_tag	= scsi_cmd_to_rq(cmd)->internal_tag;
   235			__entry->data_sglen	= scsi_sg_count(cmd);
   236			__entry->prot_sglen	= scsi_prot_sg_count(cmd);
   237			__entry->prot_op	= scsi_get_prot_op(cmd);
   238			memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
   239		),
   240	
   241		TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
   242			  " prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s)" \
   243			  " rtn=%s",
   244			  __entry->host_no, __entry->channel, __entry->id,
   245			  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
   246			  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
   247			  __entry->scheduler_tag, show_opcode_name(__entry->opcode),
   248			  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
   249			  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
 > 250			  __print_symbolic(rtn, { SCSI_MLQUEUE_HOST_BUSY, "HOST_BUSY" },
   251				  { SCSI_MLQUEUE_DEVICE_BUSY, "DEVICE_BUSY" },
   252				  { SCSI_MLQUEUE_EH_RETRY, "EH_RETRY" },
   253				  { SCSI_MLQUEUE_TARGET_BUSY, "TARGET_BUSY" })
   254			  )
   255	);
   256	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
