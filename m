From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [target:queue 3/14] include/trace/events/target.h:131:1: error:
 'struct se_cmd' has no member named 'data_length'
Date: Wed, 01 Jun 2016 13:52:43 -0700
Message-ID: <1464814363.10899.0.camel@haakon3.risingtidesystems.com>
References: <201606011741.SNqyow9h%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <201606011741.SNqyow9h%fengguang.wu@intel.com>
Sender: target-devel-owner@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-06-01 at 17:32 +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git queue
> head:   4d13930836b3a61c70603178d8a3c60e633e40f1
> commit: 11a5da226987da220b750fc40b039936ff6fe5ae [3/14] target: Add target_iostate descriptor
> config: tile-allyesconfig (attached as .config)
> compiler: tilegx-linux-gcc (GCC) 4.6.2
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 11a5da226987da220b750fc40b039936ff6fe5ae
>         # save the attached .config to linux build tree
>         make.cross ARCH=tile 
> 
> Note: the target/queue HEAD 4d13930836b3a61c70603178d8a3c60e633e40f1 builds fine.
>       It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from include/trace/trace_events.h:706:0,
>                     from include/trace/define_trace.h:95,
>                     from include/trace/events/target.h:214,
>                     from drivers/target/target_core_transport.c:54:
>    include/trace/events/target.h: In function 'trace_event_raw_event_target_sequencer_start':
> >> include/trace/events/target.h:131:1: error: 'struct se_cmd' has no member named 'data_length'
>    include/trace/events/target.h: In function 'trace_event_raw_event_target_cmd_complete':
>    include/trace/events/target.h:166:1: error: 'struct se_cmd' has no member named 'data_length'
>    In file included from include/trace/perf.h:89:0,
>                     from include/trace/define_trace.h:96,
>                     from include/trace/events/target.h:214,
>                     from drivers/target/target_core_transport.c:54:
>    include/trace/events/target.h: In function 'perf_trace_target_sequencer_start':
> >> include/trace/events/target.h:131:1: error: 'struct se_cmd' has no member named 'data_length'
>    include/trace/events/target.h: In function 'perf_trace_target_cmd_complete':
>    include/trace/events/target.h:166:1: error: 'struct se_cmd' has no member named 'data_length'
> 
> vim +131 include/trace/events/target.h
> 
> e5c0d6ad5 Roland Dreier 2013-06-26  125  		{ SAM_STAT_RESERVATION_CONFLICT, "RESERVATION CONFLICT" }, \
> e5c0d6ad5 Roland Dreier 2013-06-26  126  		{ SAM_STAT_COMMAND_TERMINATED, "COMMAND TERMINATED" }, \
> e5c0d6ad5 Roland Dreier 2013-06-26  127  		{ SAM_STAT_TASK_SET_FULL, "TASK SET FULL" },	\
> e5c0d6ad5 Roland Dreier 2013-06-26  128  		{ SAM_STAT_ACA_ACTIVE, "ACA ACTIVE" },		\
> e5c0d6ad5 Roland Dreier 2013-06-26  129  		{ SAM_STAT_TASK_ABORTED, "TASK ABORTED" } )
> e5c0d6ad5 Roland Dreier 2013-06-26  130  
> e5c0d6ad5 Roland Dreier 2013-06-26 @131  TRACE_EVENT(target_sequencer_start,
> e5c0d6ad5 Roland Dreier 2013-06-26  132  
> e5c0d6ad5 Roland Dreier 2013-06-26  133  	TP_PROTO(struct se_cmd *cmd),
> e5c0d6ad5 Roland Dreier 2013-06-26  134  
> e5c0d6ad5 Roland Dreier 2013-06-26  135  	TP_ARGS(cmd),
> e5c0d6ad5 Roland Dreier 2013-06-26  136  
> e5c0d6ad5 Roland Dreier 2013-06-26  137  	TP_STRUCT__entry(
> e5c0d6ad5 Roland Dreier 2013-06-26  138  		__field( unsigned int,	unpacked_lun	)
> e5c0d6ad5 Roland Dreier 2013-06-26  139  		__field( unsigned int,	opcode		)
> e5c0d6ad5 Roland Dreier 2013-06-26  140  		__field( unsigned int,	data_length	)
> e5c0d6ad5 Roland Dreier 2013-06-26  141  		__field( unsigned int,	task_attribute  )
> e5c0d6ad5 Roland Dreier 2013-06-26  142  		__array( unsigned char,	cdb, TCM_MAX_COMMAND_SIZE	)
> e5c0d6ad5 Roland Dreier 2013-06-26  143  		__string( initiator,	cmd->se_sess->se_node_acl->initiatorname	)
> e5c0d6ad5 Roland Dreier 2013-06-26  144  	),
> e5c0d6ad5 Roland Dreier 2013-06-26  145  
> e5c0d6ad5 Roland Dreier 2013-06-26  146  	TP_fast_assign(
> 2053a1db4 Roland Dreier 2013-10-08  147  		__entry->unpacked_lun	= cmd->orig_fe_lun;
> e5c0d6ad5 Roland Dreier 2013-06-26  148  		__entry->opcode		= cmd->t_task_cdb[0];
> e5c0d6ad5 Roland Dreier 2013-06-26  149  		__entry->data_length	= cmd->data_length;
> e5c0d6ad5 Roland Dreier 2013-06-26  150  		__entry->task_attribute	= cmd->sam_task_attr;
> e5c0d6ad5 Roland Dreier 2013-06-26  151  		memcpy(__entry->cdb, cmd->t_task_cdb, TCM_MAX_COMMAND_SIZE);
> e5c0d6ad5 Roland Dreier 2013-06-26  152  		__assign_str(initiator, cmd->se_sess->se_node_acl->initiatorname);
> e5c0d6ad5 Roland Dreier 2013-06-26  153  	),
> e5c0d6ad5 Roland Dreier 2013-06-26  154  
> e5c0d6ad5 Roland Dreier 2013-06-26  155  	TP_printk("%s -> LUN %03u %s data_length %6u  CDB %s  (TA:%s C:%02x)",
> e5c0d6ad5 Roland Dreier 2013-06-26  156  		  __get_str(initiator), __entry->unpacked_lun,
> e5c0d6ad5 Roland Dreier 2013-06-26  157  		  show_opcode_name(__entry->opcode),
> e5c0d6ad5 Roland Dreier 2013-06-26  158  		  __entry->data_length, __print_hex(__entry->cdb, 16),
> e5c0d6ad5 Roland Dreier 2013-06-26  159  		  show_task_attribute_name(__entry->task_attribute),
> e5c0d6ad5 Roland Dreier 2013-06-26  160  		  scsi_command_size(__entry->cdb) <= 16 ?
> e5c0d6ad5 Roland Dreier 2013-06-26  161  			__entry->cdb[scsi_command_size(__entry->cdb) - 1] :
> e5c0d6ad5 Roland Dreier 2013-06-26  162  			__entry->cdb[1]
> e5c0d6ad5 Roland Dreier 2013-06-26  163  	)
> e5c0d6ad5 Roland Dreier 2013-06-26  164  );
> e5c0d6ad5 Roland Dreier 2013-06-26  165  
> e5c0d6ad5 Roland Dreier 2013-06-26  166  TRACE_EVENT(target_cmd_complete,
> e5c0d6ad5 Roland Dreier 2013-06-26  167  
> e5c0d6ad5 Roland Dreier 2013-06-26  168  	TP_PROTO(struct se_cmd *cmd),
> e5c0d6ad5 Roland Dreier 2013-06-26  169  
> e5c0d6ad5 Roland Dreier 2013-06-26  170  	TP_ARGS(cmd),
> e5c0d6ad5 Roland Dreier 2013-06-26  171  
> e5c0d6ad5 Roland Dreier 2013-06-26  172  	TP_STRUCT__entry(
> e5c0d6ad5 Roland Dreier 2013-06-26  173  		__field( unsigned int,	unpacked_lun	)
> e5c0d6ad5 Roland Dreier 2013-06-26  174  		__field( unsigned int,	opcode		)
> e5c0d6ad5 Roland Dreier 2013-06-26  175  		__field( unsigned int,	data_length	)
> e5c0d6ad5 Roland Dreier 2013-06-26  176  		__field( unsigned int,	task_attribute  )
> e5c0d6ad5 Roland Dreier 2013-06-26  177  		__field( unsigned char,	scsi_status	)
> e5c0d6ad5 Roland Dreier 2013-06-26  178  		__field( unsigned char,	sense_length	)
> e5c0d6ad5 Roland Dreier 2013-06-26  179  		__array( unsigned char,	cdb, TCM_MAX_COMMAND_SIZE	)
> e5c0d6ad5 Roland Dreier 2013-06-26  180  		__array( unsigned char,	sense_data, 18	)
> e5c0d6ad5 Roland Dreier 2013-06-26  181  		__string(initiator,	cmd->se_sess->se_node_acl->initiatorname)
> e5c0d6ad5 Roland Dreier 2013-06-26  182  	),
> e5c0d6ad5 Roland Dreier 2013-06-26  183  
> e5c0d6ad5 Roland Dreier 2013-06-26  184  	TP_fast_assign(
> 2053a1db4 Roland Dreier 2013-10-08  185  		__entry->unpacked_lun	= cmd->orig_fe_lun;
> e5c0d6ad5 Roland Dreier 2013-06-26  186  		__entry->opcode		= cmd->t_task_cdb[0];
> e5c0d6ad5 Roland Dreier 2013-06-26  187  		__entry->data_length	= cmd->data_length;
> e5c0d6ad5 Roland Dreier 2013-06-26  188  		__entry->task_attribute	= cmd->sam_task_attr;
> e5c0d6ad5 Roland Dreier 2013-06-26  189  		__entry->scsi_status	= cmd->scsi_status;
> e5c0d6ad5 Roland Dreier 2013-06-26  190  		__entry->sense_length	= cmd->scsi_status == SAM_STAT_CHECK_CONDITION ?
> e5c0d6ad5 Roland Dreier 2013-06-26  191  			min(18, ((u8 *) cmd->sense_buffer)[SPC_ADD_SENSE_LEN_OFFSET] + 8) : 0;
> e5c0d6ad5 Roland Dreier 2013-06-26  192  		memcpy(__entry->cdb, cmd->t_task_cdb, TCM_MAX_COMMAND_SIZE);
> e5c0d6ad5 Roland Dreier 2013-06-26  193  		memcpy(__entry->sense_data, cmd->sense_buffer, __entry->sense_length);
> e5c0d6ad5 Roland Dreier 2013-06-26  194  		__assign_str(initiator, cmd->se_sess->se_node_acl->initiatorname);
> e5c0d6ad5 Roland Dreier 2013-06-26  195  	),
> e5c0d6ad5 Roland Dreier 2013-06-26  196  
> e5c0d6ad5 Roland Dreier 2013-06-26  197  	TP_printk("%s <- LUN %03u status %s (sense len %d%s%s)  %s data_length %6u  CDB %s  (TA:%s C:%02x)",
> e5c0d6ad5 Roland Dreier 2013-06-26  198  		  __get_str(initiator), __entry->unpacked_lun,
> e5c0d6ad5 Roland Dreier 2013-06-26  199  		  show_scsi_status_name(__entry->scsi_status),
> e5c0d6ad5 Roland Dreier 2013-06-26  200  		  __entry->sense_length, __entry->sense_length ? " / " : "",
> e5c0d6ad5 Roland Dreier 2013-06-26  201  		  __print_hex(__entry->sense_data, __entry->sense_length),
> e5c0d6ad5 Roland Dreier 2013-06-26  202  		  show_opcode_name(__entry->opcode),
> e5c0d6ad5 Roland Dreier 2013-06-26  203  		  __entry->data_length, __print_hex(__entry->cdb, 16),
> e5c0d6ad5 Roland Dreier 2013-06-26  204  		  show_task_attribute_name(__entry->task_attribute),
> e5c0d6ad5 Roland Dreier 2013-06-26  205  		  scsi_command_size(__entry->cdb) <= 16 ?
> e5c0d6ad5 Roland Dreier 2013-06-26  206  			__entry->cdb[scsi_command_size(__entry->cdb) - 1] :
> e5c0d6ad5 Roland Dreier 2013-06-26  207  			__entry->cdb[1]
> e5c0d6ad5 Roland Dreier 2013-06-26  208  	)
> e5c0d6ad5 Roland Dreier 2013-06-26  209  );
> e5c0d6ad5 Roland Dreier 2013-06-26  210  
> e5c0d6ad5 Roland Dreier 2013-06-26  211  #endif /*  _TRACE_TARGET_H */
> e5c0d6ad5 Roland Dreier 2013-06-26  212  
> e5c0d6ad5 Roland Dreier 2013-06-26  213  /* This part must be outside protection */
> e5c0d6ad5 Roland Dreier 2013-06-26 @214  #include <trace/define_trace.h>
> 
> :::::: The code at line 131 was first introduced by commit
> :::::: e5c0d6ad557b32f431a70a4efba820430f6ff88b target: Add tracepoints for SCSI commands being processed
> 
> :::::: TO: Roland Dreier <roland@purestorage.com>
> :::::: CC: Nicholas Bellinger <nab@linux-iscsi.org>

Fixed.

Thanks Fengguang.
