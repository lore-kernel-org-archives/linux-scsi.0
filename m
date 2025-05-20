Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F01267F41;
	Tue, 20 May 2025 12:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747743097; cv=none; b=puiOWp0poBjr59yngriDnfSmBMfaIxpoayPdPUC7CH5TvGQjC0GLih7MNU28x452Mn5CGl4cMiFEkqwqPM3bt84r8+BqrKo3SDTBZgYw8cW6WnW1GJxL1pdoCuT14I0TrGUpKZ0Syx2bTt8JmvQ4BxgohX+YWkvd6UibTE+Q86A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747743097; c=relaxed/simple;
	bh=EHSvRNvgm+GaXbq1NtOZOkHkxxBeWpFGycrSmffCy+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dF9Wre/FIiyPKuz4YEcVo51Ad7zMu8smdazwJ+5+8GBreS0b9QFBV4cpcaVgwO2z/Fm7V7XQH5N4N7s/0o/VzYpIppa4fFOvm6vNwx1fil1kKaI/Y0Artcoe5KQOjXqU7P82RYkvGBXgnjKd2IqEI1Mf5GJ9YWdNMiQg4fqibhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ccpco1co; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ccpco1co"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747743095; x=1779279095;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EHSvRNvgm+GaXbq1NtOZOkHkxxBeWpFGycrSmffCy+g=;
  b=Ccpco1co7VwyRno66kxjwIntJhemTnOM1B5J7V8/vNEsO720ydOegrsr
   AFPZ9mp5ok/AmIIyxVKPsWPcsb0zXLmRY5cEFAh8WlDeUNniZYFfQdgMZ
   +RvEUQcDyDp3mQdtZaEZEjHxrAx6QLlEcBh5PLRxMbPNHS7xECcvfM569
   jASe1R+S0+DpJTO9sJplZHm91Q/9IZr8W4hGFl6e2maK/aVekXcl4NcTX
   7sIeU7r9GKZAOJxHpy5nJ7e7wKvYPhdLFVt7TlmxFQQXxO023Toq8hH3+
   SquLmWgKAox5CGnTbyj6VxY3I4hp6eTRNg5uKW2CuvznVyfnB0RN+T87v
   A==;
X-CSE-ConnectionGUID: OKcrrkIYSw2m1m22+TgB6A==
X-CSE-MsgGUID: 4tfQjVklQSmIANOrYOP0zg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="75075187"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="75075187"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 05:11:34 -0700
X-CSE-ConnectionGUID: lf+5YtciTJapDKPzB3o74w==
X-CSE-MsgGUID: 6ODpm6GhQSiKKHgA6g363Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="162976147"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 20 May 2025 05:11:32 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uHLog-000MYa-06;
	Tue, 20 May 2025 12:11:30 +0000
Date: Tue, 20 May 2025 20:10:50 +0800
From: kernel test robot <lkp@intel.com>
To: Kassey Li <quic_yingangl@quicinc.com>, rostedt@goodmis.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	quic_yingangl@quicinc.com
Subject: Re: [PATCH v3] scsi: trace: change the rtn log in string
Message-ID: <202505201948.7kMKhg6W-lkp@intel.com>
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

kernel test robot noticed the following build warnings:

[auto build test WARNING on trace/for-next]
[also build test WARNING on jejb-scsi/for-next mkp-scsi/for-next linus/master v6.15-rc7 next-20250516]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kassey-Li/scsi-trace-change-the-rtn-log-in-string/20250520-090745
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20250520010405.3844511-1-quic_yingangl%40quicinc.com
patch subject: [PATCH v3] scsi: trace: change the rtn log in string
config: riscv-randconfig-002-20250520 (https://download.01.org/0day-ci/archive/20250520/202505201948.7kMKhg6W-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project f819f46284f2a79790038e1f6649172789734ae8)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250520/202505201948.7kMKhg6W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505201948.7kMKhg6W-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/scsi/scsi.c:73:
   In file included from include/trace/events/scsi.h:358:
   In file included from include/trace/define_trace.h:132:
   In file included from include/trace/trace_events.h:256:
   include/trace/events/scsi.h:256:5: error: call to undeclared function 'show_rtn_type'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     256 |                   show_rtn_type(__entry->rtn)
         |                   ^
>> include/trace/events/scsi.h:256:5: warning: format specifies type 'char *' but the argument has type 'int' [-Wformat]
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


vim +256 include/trace/events/scsi.h

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
   260	DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
   261	
   262		TP_PROTO(struct scsi_cmnd *cmd),
   263	
   264		TP_ARGS(cmd),
   265	
   266		TP_STRUCT__entry(
   267			__field( unsigned int,	host_no	)
   268			__field( unsigned int,	channel	)
   269			__field( unsigned int,	id	)
   270			__field( unsigned int,	lun	)
   271			__field( int,		result	)
   272			__field( unsigned int,	opcode	)
   273			__field( unsigned int,	cmd_len )
   274			__field( int,	driver_tag)
   275			__field( int,	scheduler_tag)
   276			__field( unsigned int,	data_sglen )
   277			__field( unsigned int,	prot_sglen )
   278			__field( unsigned char,	prot_op )
   279			__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
   280			__field( u8, sense_key )
   281			__field( u8, asc )
   282			__field( u8, ascq )
   283		),
   284	
   285		TP_fast_assign(
   286			struct scsi_sense_hdr sshdr;
   287	
   288			__entry->host_no	= cmd->device->host->host_no;
   289			__entry->channel	= cmd->device->channel;
   290			__entry->id		= cmd->device->id;
   291			__entry->lun		= cmd->device->lun;
   292			__entry->result		= cmd->result;
   293			__entry->opcode		= cmd->cmnd[0];
   294			__entry->cmd_len	= cmd->cmd_len;
   295			__entry->driver_tag	= scsi_cmd_to_rq(cmd)->tag;
   296			__entry->scheduler_tag	= scsi_cmd_to_rq(cmd)->internal_tag;
   297			__entry->data_sglen	= scsi_sg_count(cmd);
   298			__entry->prot_sglen	= scsi_prot_sg_count(cmd);
   299			__entry->prot_op	= scsi_get_prot_op(cmd);
   300			memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
   301			if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
   302			    scsi_command_normalize_sense(cmd, &sshdr)) {
   303				__entry->sense_key = sshdr.sense_key;
   304				__entry->asc = sshdr.asc;
   305				__entry->ascq = sshdr.ascq;
   306			} else {
   307				__entry->sense_key = 0;
   308				__entry->asc = 0;
   309				__entry->ascq = 0;
   310			}
   311		),
   312	
   313		TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u " \
   314			  "prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s) " \
   315			  "result=(driver=%s host=%s message=%s status=%s) "
   316			  "sense=(key=%#x asc=%#x ascq=%#x)",
   317			  __entry->host_no, __entry->channel, __entry->id,
   318			  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
   319			  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
   320			  __entry->scheduler_tag, show_opcode_name(__entry->opcode),
   321			  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
   322			  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
   323			  "DRIVER_OK",
   324			  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
   325			  "COMMAND_COMPLETE",
   326			  show_statusbyte_name(__entry->result & 0xff),
   327			  __entry->sense_key, __entry->asc, __entry->ascq)
   328	);
   329	
   330	DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,
   331		     TP_PROTO(struct scsi_cmnd *cmd),
   332		     TP_ARGS(cmd));
   333	
   334	DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_timeout,
   335		     TP_PROTO(struct scsi_cmnd *cmd),
   336		     TP_ARGS(cmd));
   337	
   338	TRACE_EVENT(scsi_eh_wakeup,
   339	
   340		TP_PROTO(struct Scsi_Host *shost),
   341	
   342		TP_ARGS(shost),
   343	
   344		TP_STRUCT__entry(
   345			__field( unsigned int,	host_no	)
   346		),
   347	
   348		TP_fast_assign(
   349			__entry->host_no	= shost->host_no;
   350		),
   351	
   352		TP_printk("host_no=%u", __entry->host_no)
   353	);
   354	
   355	#endif /*  _TRACE_SCSI_H */
   356	
   357	/* This part must be outside protection */
 > 358	#include <trace/define_trace.h>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
