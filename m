Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168B3C4363C
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 17:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C74BB206DD
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 17:58:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w56Qwb1A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387602AbgJBR6w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 13:58:52 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52650 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgJBR6w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 13:58:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092Hu7Ah003103;
        Fri, 2 Oct 2020 17:58:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PMyjh+pcZr3w4jFEQFDISBmO/+meiQsT9a6RuFwWbOQ=;
 b=w56Qwb1AabS9hGGTZ14jHyCRzwEcCx41Kaasm5riILvOJeUZ8TLmqfi+27xlJ/g4JYjE
 Ckzqd2qqJvHmsUMDUPHYw+5wWwyGN5cRWRXDC2m53p2JtMhrS7WnxmSuz50MDCiEGgTe
 ON9DMMvB+tRs2qlV8W8L3mXTFGyvXbCP84nmtaAn29eL3zL6ufyTWhXkwYjSjsi/uddH
 Q8MUJw9mct6PipNchtqFr5ZFpRMXgbPMA+WxkUeyTDLHB3a8dYOhBmcNs/MoN3VV6LUK
 grxcE/yDlHWwhRntUZvzfTX40167wAAIEFgziUQZ/6eyGurMfmOzmBIvtG6eagLQ20F7 Cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33wupg33j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 17:58:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092HotDm132990;
        Fri, 2 Oct 2020 17:58:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33tfdxws0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 17:58:49 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 092Hwm16030822;
        Fri, 2 Oct 2020 17:58:48 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 10:58:47 -0700
Subject: Re: [PATCH] scsi: target: core: Add CONTROL field for trace events
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20200929125957.83069-1-r.bolshakov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <af5c5b31-299a-a780-01ab-7a8b62b0edfd@oracle.com>
Date:   Fri, 2 Oct 2020 12:58:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929125957.83069-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 clxscore=1011
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020131
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/20 7:59 AM, Roman Bolshakov wrote:
> trace-cmd report doesn't show events from target subsystem because
> scsi_command_size() leaks through event format string:
> 
>   [target:target_sequencer_start] function scsi_command_size not defined
>   [target:target_cmd_complete] function scsi_command_size not defined
> 
> Addition of scsi_command_size() to plugin_scsi.c in trace-cmd doesn't
> help because an expression is used inside TP_printk(). trace-cmd event
> parser doesn't understand minus sign inside [ ]:
> 
>   Error: expected ']' but read '-'
> 
> Rather than duplicating kernel code in plugin_scsi.c, it's better to
> provide a dedicated field for CONTROL byte.
> 
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  include/scsi/scsi_common.h    |  7 +++++++
>  include/trace/events/target.h | 12 ++++++------
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
> index 731ac09ed231..5b567b43e1b1 100644
> --- a/include/scsi/scsi_common.h
> +++ b/include/scsi/scsi_common.h
> @@ -25,6 +25,13 @@ scsi_command_size(const unsigned char *cmnd)
>  		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
>  }
>  
> +static inline unsigned char
> +scsi_command_control(const unsigned char *cmnd)
> +{
> +	return (cmnd[0] == VARIABLE_LENGTH_CMD) ?
> +		cmnd[1] : cmnd[COMMAND_SIZE(cmnd[0]) - 1];
> +}
> +
>  /* Returns a human-readable name for the device */
>  extern const char *scsi_device_type(unsigned type);
>  
> diff --git a/include/trace/events/target.h b/include/trace/events/target.h
> index 77408edd29d2..67fad2677ed5 100644
> --- a/include/trace/events/target.h
> +++ b/include/trace/events/target.h
> @@ -141,6 +141,7 @@ TRACE_EVENT(target_sequencer_start,
>  		__field( unsigned int,	opcode		)
>  		__field( unsigned int,	data_length	)
>  		__field( unsigned int,	task_attribute  )
> +		__field( unsigned char,	control		)
>  		__array( unsigned char,	cdb, TCM_MAX_COMMAND_SIZE	)
>  		__string( initiator,	cmd->se_sess->se_node_acl->initiatorname	)
>  	),
> @@ -151,6 +152,7 @@ TRACE_EVENT(target_sequencer_start,
>  		__entry->opcode		= cmd->t_task_cdb[0];
>  		__entry->data_length	= cmd->data_length;
>  		__entry->task_attribute	= cmd->sam_task_attr;
> +		__entry->control	= scsi_command_control(cmd->t_task_cdb);
>  		memcpy(__entry->cdb, cmd->t_task_cdb, TCM_MAX_COMMAND_SIZE);
>  		__assign_str(initiator, cmd->se_sess->se_node_acl->initiatorname);
>  	),
> @@ -160,9 +162,7 @@ TRACE_EVENT(target_sequencer_start,
>  		  __entry->tag, show_opcode_name(__entry->opcode),
>  		  __entry->data_length, __print_hex(__entry->cdb, 16),
>  		  show_task_attribute_name(__entry->task_attribute),
> -		  scsi_command_size(__entry->cdb) <= 16 ?
> -			__entry->cdb[scsi_command_size(__entry->cdb) - 1] :
> -			__entry->cdb[1]
> +		  __entry->control
>  	)
>  );
>  
> @@ -178,6 +178,7 @@ TRACE_EVENT(target_cmd_complete,
>  		__field( unsigned int,	opcode		)
>  		__field( unsigned int,	data_length	)
>  		__field( unsigned int,	task_attribute  )
> +		__field( unsigned char,	control		)
>  		__field( unsigned char,	scsi_status	)
>  		__field( unsigned char,	sense_length	)
>  		__array( unsigned char,	cdb, TCM_MAX_COMMAND_SIZE	)
> @@ -191,6 +192,7 @@ TRACE_EVENT(target_cmd_complete,
>  		__entry->opcode		= cmd->t_task_cdb[0];
>  		__entry->data_length	= cmd->data_length;
>  		__entry->task_attribute	= cmd->sam_task_attr;
> +		__entry->control	= scsi_command_control(cmd->t_task_cdb);
>  		__entry->scsi_status	= cmd->scsi_status;
>  		__entry->sense_length	= cmd->scsi_status == SAM_STAT_CHECK_CONDITION ?
>  			min(18, ((u8 *) cmd->sense_buffer)[SPC_ADD_SENSE_LEN_OFFSET] + 8) : 0;
> @@ -208,9 +210,7 @@ TRACE_EVENT(target_cmd_complete,
>  		  show_opcode_name(__entry->opcode),
>  		  __entry->data_length, __print_hex(__entry->cdb, 16),
>  		  show_task_attribute_name(__entry->task_attribute),
> -		  scsi_command_size(__entry->cdb) <= 16 ?
> -			__entry->cdb[scsi_command_size(__entry->cdb) - 1] :
> -			__entry->cdb[1]
> +		  __entry->control
>  	)
>  );
>  

I'm not an expert on the tracing side of the code, but the target/scsi
parts look ok to me.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

